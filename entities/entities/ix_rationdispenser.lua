
AddCSLuaFile()

ENT.Type = "anim"
ENT.PrintName = "Ration Dispenser"
ENT.Category = "HL2 RP"
ENT.Spawnable = true
ENT.AdminOnly = true
ENT.PhysgunDisable = true
ENT.bNoPersist = true

ENT.Displays = {
	[1] = {"INSERT ID", color_white, true},
	[2] = {"CHECKING", Color(255, 200, 0)},
	[3] = {"DISPENSING", Color(0, 255, 0)},
	[4] = {"FREQ. LIMIT", Color(255, 0, 0)},
	[5] = {"WAIT", Color(255, 200, 0)},
	[6] = {"OFFLINE", Color(255, 0, 0), true},
	[7] = {"INSERT ID", Color(255, 0, 0)},
	[8] = {"PREPARING", Color(0, 255, 0)}
}

function ENT:SetupDataTables()
	self:NetworkVar("Int", 0, "Display")
	self:NetworkVar("Bool", 1, "Enabled")
end

if (SERVER) then
	function ENT:SpawnFunction(client, trace)
		local dispenser = ents.Create("ix_rationdispenser")

		dispenser:SetPos(trace.HitPos)
		dispenser:SetAngles(trace.HitNormal:Angle())
		dispenser:Spawn()
		dispenser:Activate()
		dispenser:SetEnabled(true)

		Schema:SaveRationDispensers()
		return dispenser
	end

	function ENT:GetRationType(client)
		local DEFAULT_RATION = "package_standardration"
	
		local plugin = ix.plugin.Get("simpledatafile")
		if not plugin then return DEFAULT_RATION end
	
		local character = client:GetCharacter()
		if not character then return DEFAULT_RATION end
	
		local datafileID = character:GetDatafile()
		if not datafileID or datafileID <= 0 then return DEFAULT_RATION end
	
		local datafile = ix.datafile.cached[datafileID]
		if not datafile or not datafile.points then return DEFAULT_RATION end
	
		local points = tonumber(datafile.points)
		local faction = character:GetFaction()
		local class = character:GetClass()
	
		-- Faction checks
		local isBiotic = faction == FACTION_BIOTIC
		local isCityAdmin = faction == FACTION_ADMIN
		local isOTA = faction == FACTION_OTA
		local isCWU = faction == FACTION_CWU
	
		-- Free Vorts
		if isBiotic then
			return false
		end
	
		-- Enslaved Vorts get biotic rations
		if isBiotic then
			return "package_bioticration"
		end
	
		-- Points-based ration packages
		-- Thresholds are applied in ascending order
		if points < -10 then
			return false -- Deny rations for extremely negative loyalty
		end
	
		local ration = DEFAULT_RATION
		local delay = 10.2

		local thresholds = {
			{ threshold = -10, package = "package_minimalration", delay = 10.2 },
			{ threshold = 0,   package = "package_standardration", delay = 8 },
			{ threshold = 40,  package = "package_loyalistration", delay = 6 },
			{ threshold = 80,  package = "package_priorityration", delay = 1 },
		}
	
		for _, entry in ipairs(thresholds) do
			if points >= entry.threshold then
				ration = entry.package
				delay = entry.delay
			end
		end
	
		-- Civil Workers always get loyalist rations or better
		if isCWU and points < 40 then
			ration = "package_loyalistration"
		end
	
		-- City Admins always get top-tier rations
		if isCityAdmin then
			ration = "package_priorityration"
		end
	
		return ration, delay
	end
	

	function ENT:Initialize()
		self:SetModel("models/props_junk/watermelon01.mdl")
		self:SetSolid(SOLID_VPHYSICS)
		self:SetMoveType(MOVETYPE_VPHYSICS)
		self:DrawShadow(false)
		self:SetUseType(SIMPLE_USE)
		self:SetDisplay(1)
		self:SetEnabled(true)

		self.dispenser = ents.Create("prop_dynamic")
		self.dispenser:SetModel("models/props_combine/combine_dispenser.mdl")
		self.dispenser:SetPos(self:GetPos())
		self.dispenser:SetAngles(self:GetAngles())
		self.dispenser:SetParent(self)
		self.dispenser:Spawn()
		self.dispenser:Activate()
		self:DeleteOnRemove(self.dispenser)

		self.dummy = ents.Create("prop_physics")
		self.dummy:SetModel("models/weapons/w_package.mdl")
		self.dummy:SetPos(self:GetPos())
		self.dummy:SetAngles(self:GetAngles())
		self.dummy:SetMoveType(MOVETYPE_NONE)
		self.dummy:SetNotSolid(true)
		self.dummy:SetNoDraw(true)
		self.dummy:SetParent(self.dispenser, 1)
		self.dummy:Spawn()
		self.dummy:Activate()
		self:DeleteOnRemove(self.dummy)

		local physics = self.dispenser:GetPhysicsObject()
		physics:EnableMotion(false)
		physics:Sleep()

		self.canUse = true
		self.nextUseTime = CurTime()
	end

	function ENT:SpawnRation(callback, releaseDelay)
		releaseDelay = releaseDelay or 1.2

		local ration = self.rationType or "ration"
		local itemTable = ix.item.Get(ration)

		self.dummy:SetModel(itemTable:GetModel())
		self.dummy:SetNoDraw(false)

		if (callback) then
			callback()
		end

		timer.Simple(releaseDelay, function()
			ix.item.Spawn(ration, self.dummy:GetPos(), function(item, entity)
				self.dummy:SetNoDraw(true)
			end, self.dummy:GetAngles())

			-- display cooldown notice
			timer.Simple(releaseDelay, function()
				self:SetDisplay(5)
			end)

			-- make dispenser usable
			timer.Simple(releaseDelay + 4, function()
				self.canUse = true
				self:SetDisplay(1)
			end)
		end)
	end

	function ENT:StartDispense()
		self:SetDisplay(3)
		self:SpawnRation(function()
			self.dispenser:Fire("SetAnimation", "dispense_package")
			self:EmitSound("ambient/machines/combine_terminal_idle4.wav")
		end)
	end

	function ENT:DisplayError(id, length)
		id = id or 6
		length = length or 2

		self:SetDisplay(id)
		self:EmitSound("buttons/combine_button_locked.wav")
		self.canUse = false

		timer.Simple(length, function()
			self:SetDisplay(1)
			self.canUse = true
		end)
	end

	function ENT:Use(client)
		if (!self.canUse or self.nextUseTime > CurTime()) then
			return
		end

		if (client:IsCombine()) then
			self:SetEnabled(!self:GetEnabled())
			self:EmitSound(self:GetEnabled() and "buttons/combine_button1.wav" or "buttons/combine_button2.wav")

			Schema:SaveRationDispensers()
			self.nextUseTime = CurTime() + 2
			return
		end

		if (!self:GetEnabled()) then
			self:DisplayError(6)
			return
		end

		local factions = {FACTION_ADMIN, FACTION_CITIZEN, FACTION_CWU, FACTION_BIOTIC}
		local allowed = false
		for _,f in ipairs(factions) do
			if (client:Team() == f) then
				allowed = true
			end
		end

		if !allowed then 
			self:DisplayError(7)
			return
		end

		local cid = client:GetCharacter():GetInventory():HasItem("cid")

		if (!cid) then
			self:DisplayError(7)
			return
		end

		-- if theres no ration type it means rations are denied for this person
		self.rationType, self.delay = self:GetRationType(client)
		if (!self.rationType) then
			self:DisplayError(7)
			return
		end

		-- display checking message
		self.canUse = false
		self:SetDisplay(2)
		self:EmitSound("ambient/machines/combine_terminal_idle2.wav")

		-- check cid ration time and dispense if allowed
		timer.Simple(math.random(1.8, 2.2), function()
			if (cid:GetData("nextRationTime", 0) < os.time()) then
				self:SetDisplay(8)
				self:EmitSound("ambient/machines/combine_terminal_idle3.wav")

				timer.Simple(self.delay, function()
					self:StartDispense()
					cid:SetData("nextRationTime", os.time() + ix.config.Get("rationInterval", 1))
				end)
			else
				self:DisplayError(4)
			end
		end)


	end

	function ENT:OnRemove()
		if (!ix.shuttingDown) then
			Schema:SaveRationDispensers()
		end
	end
else
	surface.CreateFont("ixRationDispenser", {
		font = "Default",
		size = 32,
		antialias = false
	})

	function ENT:Draw()
		local position, angles = self:GetPos(), self:GetAngles()
		local display = self:GetEnabled() and self.Displays[self:GetDisplay()] or self.Displays[6]

		angles:RotateAroundAxis(angles:Forward(), 90)
		angles:RotateAroundAxis(angles:Right(), 270)

		cam.Start3D2D(position + self:GetForward() * 7.6 + self:GetRight()*  8.5 + self:GetUp() * 3, angles, 0.1)
			render.PushFilterMin(TEXFILTER.NONE)
			render.PushFilterMag(TEXFILTER.NONE)

			surface.SetDrawColor(color_black)
			surface.DrawRect(10, 16, 153, 40)

			surface.SetDrawColor(60, 60, 60)
			surface.DrawOutlinedRect(9, 16, 155, 40)

			local alpha = display[3] and 255 or math.abs(math.cos(RealTime() * 2) * 255)
			local color = ColorAlpha(display[2], alpha)

			draw.SimpleText(display[1], "ixRationDispenser", 86, 36, color, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)

			render.PopFilterMin()
			render.PopFilterMag()
		cam.End3D2D()
	end
end
