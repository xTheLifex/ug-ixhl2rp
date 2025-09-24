
AddCSLuaFile()

ENT.Type = "anim"
ENT.PrintName = "Forcefield"
ENT.Category = "HL2 RP"
ENT.Spawnable = true
ENT.AdminOnly = true
ENT.RenderGroup = RENDERGROUP_BOTH
ENT.PhysgunDisabled = true
ENT.bNoPersist = true

function ENT:SetupDataTables()
	self:NetworkVar("Int", 0, "Mode")
	self:NetworkVar("Bool", 0, "Enabled")
	self:NetworkVar("Entity", 0, "Dummy")
end

local MODE_ALLOW_CID = 1 -- Valid CID
local MODE_ALLOW_NONE = 2 -- Full restrict
local MODE_ALLOW_CWU = 3 -- Only CWU
local MODE_ALLOW_OTA = 4 -- Only OTA
local MODE_ALLOW_CA = 5 -- Only OTA and CA

ix.ForcefieldTypes = {
	{
		function(client)
			local character = client:GetCharacter()
			if not character then return true end
			if (client:IsCombine() or character:GetFaction() == FACTION_ADMIN) then return false end

			if (character and character:GetInventory() and !character:GetInventory():HasItem("cid")) then
				return true
			else
				return false
			end
		end,
		"Only allow with valid CID.",
		Color(90,255,255),
		"Citizen"
	},
	{
		function(client)
			local character = client:GetCharacter()
			if not character then return true end
			return !(client:IsCombine() or character:GetFaction() == FACTION_ADMIN)
		end,
		"Never allow citizens.",
		Color(95,150,255),
		"Combine"
	},
	{
		function(client)
			local character = client:GetCharacter()
			if not character then return true end
			local faction = character:GetFaction()

			if (faction == FACTION_CWU or faction == FACTION_ADMIN or client:IsCombine()) then
				return false
			end
			return true
		end,
		"Allow Civil Workers.",
		Color(255,225,95),
		"Civil Worker's Union"
	},
	{
		function(client)
			local character = client:GetCharacter()
			if not character then return true end
			local faction = character:GetFaction()
			if (faction == FACTION_OTA) then
				return false
			end

			return true
		end,
		"Allow Overwatch.",
		Color(255,95,95),
		"Overwatch"
	},
	{
		function(client)
			local character = client:GetCharacter()
			if not character then return true end
			local faction = character:GetFaction()
			if (faction == FACTION_OTA or faction == FACTION_ADMIN) then
				return false
			end

			return true
		end,
		"Allow only Civil Administration.",
		Color(255,95,95),
		"City Administration"
	}
}

if (SERVER) then
	resource.AddFile("sound/ug/ForcefieldEnemy.wav")
	resource.AddFile("sound/ug/ForcefieldFriend.wav")
	local ALARM_ENEMY = "ug/ForcefieldEnemy.wav"
	local ALARM_FRIEND = "ug/ForcefieldFriend.wav"

	function ENT:SpawnFunction(client, trace)
		local angles = (client:GetPos() - trace.HitPos):Angle()
		angles.p = 0
		angles.r = 0
		angles:RotateAroundAxis(angles:Up(), 270)

		local entity = ents.Create("ix_forcefield")
		entity:SetPos(trace.HitPos + Vector(0, 0, 40))
		entity:SetAngles(angles:SnapTo("y", 90))
		entity:Spawn()
		entity:Activate()

		Schema:SaveForceFields()
		return entity
	end

	function ENT:Initialize()
		self:SetModel("models/props_combine/combine_fence01b.mdl")
		self:SetSolid(SOLID_VPHYSICS)
		self:SetUseType(SIMPLE_USE)
		self:PhysicsInit(SOLID_VPHYSICS)

		local data = {}
			data.start = self:GetPos() + self:GetRight() * -16
			data.endpos = self:GetPos() + self:GetRight() * -480
			data.filter = self
		local trace = util.TraceLine(data)

		local angles = self:GetAngles()
		angles:RotateAroundAxis(angles:Up(), 90)

		self.dummy = ents.Create("prop_physics")
		self.dummy:SetModel("models/props_combine/combine_fence01a.mdl")
		self.dummy:SetPos(trace.HitPos)
		self.dummy:SetAngles(self:GetAngles())
		self.dummy:Spawn()
		self.dummy.PhysgunDisabled = true
		self:DeleteOnRemove(self.dummy)

		local verts = {
			{pos = Vector(0, 0, -25)},
			{pos = Vector(0, 0, 150)},
			{pos = self:WorldToLocal(self.dummy:GetPos()) + Vector(0, 0, 150)},
			{pos = self:WorldToLocal(self.dummy:GetPos()) + Vector(0, 0, 150)},
			{pos = self:WorldToLocal(self.dummy:GetPos()) - Vector(0, 0, 25)},
			{pos = Vector(0, 0, -25)}
		}

		self:PhysicsFromMesh(verts)

		local physObj = self:GetPhysicsObject()

		if (IsValid(physObj)) then
			physObj:EnableMotion(false)
			physObj:Sleep()
		end

		self:SetCustomCollisionCheck(true)
		self:EnableCustomCollisions(true)
		self:SetDummy(self.dummy)

		physObj = self.dummy:GetPhysicsObject()

		if (IsValid(physObj)) then
			physObj:EnableMotion(false)
			physObj:Sleep()
		end

		self:SetMoveType(MOVETYPE_NOCLIP)
		self:SetMoveType(MOVETYPE_PUSH)
		self:MakePhysicsObjectAShadow()
		self:SetMode(MODE_ALLOW_NONE)
		self:SetEnabled(true)
	end

	function ENT:IsPlayerInForcefield(client)
		if not IsValid(client) or not client:IsPlayer() then return false end
		
		local dummy = self:GetDummy()
		if not IsValid(dummy) then return false end
	
		local pos1 = self:GetPos()
		local pos2 = dummy:GetPos()
		local playerPos = client:GetPos()
	
		local height = 190
		local thickness = 32
	
		-- Flatten to same Z to get direction in 2D
		local dir = (pos2 - pos1)
		dir.z = 0
		local length = dir:Length()
		dir:Normalize()
	
		-- Vector from pos1 to player, flattened
		local toPlayer = playerPos - pos1
		toPlayer.z = 0
	
		-- Project player onto the axis
		local forwardDist = toPlayer:Dot(dir)
	
		
		-- Check if within field length
		if forwardDist < 0 or forwardDist > length then return false end
		
		-- Check if within side bounds (thickness)
		local sideDist = toPlayer:Cross(dir):Length()
		if sideDist > thickness then return false end

		return true
	end	

	function ENT:PlaySound(clip)
		-- Play sound on the current entity
		self:EmitSound(clip)
	
		-- Play sound on the dummy (other model)
		local dummy = self:GetDummy()
		if IsValid(dummy) then
			dummy:EmitSound(clip)
		end

		-- Play sound at the center of the forcefield (middle point between self and dummy)
		local middlePos = (self:GetPos() + dummy:GetPos()) / 2
		sound.Play(clip, middlePos, 75, 100, 1)
	end	

	function ENT:StartTouch(entity)
		if (!self.buzzer) then
			self.buzzer = CreateSound(entity, "ambient/machines/combine_shield_touch_loop1.wav")
			self.buzzer:Play()
			self.buzzer:ChangeVolume(0.8, 0)
		else
			self.buzzer:ChangeVolume(0.8, 0.5)
			self.buzzer:Play()
		end

		self.entities = (self.entities or 0) + 1
	end

	function ENT:EndTouch(entity)
		self.entities = math.max((self.entities or 0) - 1, 0)

		if (self.buzzer and self.entities == 0) then
			self.buzzer:FadeOut(0.5)
		end
	end

	function ENT:OnRemove()
		if (self.buzzer) then
			self.buzzer:Stop()
			self.buzzer = nil
		end

		if (!ix.shuttingDown and !self.ixIsSafe) then
			Schema:SaveForceFields()
		end
	end

	function ENT:Use(activator)
		if ((self.nextUse or 0) < CurTime()) then
			self.nextUse = CurTime() + 1.5
		else
			return
		end

		if (self:CanDisable(activator)) then
			self:SetEnabled(!self:GetEnabled())

			if (!self:GetEnabled()) then
				self:SetSkin(1)
				self.dummy:SetSkin(1)
				self:PlaySound("npc/turret_floor/die.wav")
			else
				self:SetSkin(0)
				self.dummy:SetSkin(0)
			end

			self:PlaySound("buttons/combine_button5.wav")

			if (self:GetEnabled()) then
				activator:ChatPrint("Activated forcefield.")
			else
				activator:ChatPrint("Disabled forcefield.")
			end

			Schema:SaveForceFields()
		else
			self:PlaySound("buttons/combine_button3.wav")
		end
	end

	function ENT:CanDisable(client)
		local mode = self:GetMode() or 1
		local collides = (istable(ix.ForcefieldTypes[mode]) and ix.ForcefieldTypes[mode][1](client)) or false
		local character = client:GetCharacter()
		local isCombineAffiliated = character:GetFaction() == FACTION_ADMIN or client:IsCombine()

		return (!collides and isCombineAffiliated)
	end

	function ENT:Think()
		if not self:GetEnabled() then return end
	
		self.currentColliders = self.currentColliders or {}
		self.lastColliders = self.lastColliders or {}
		self.wasInFieldLastTick = self.wasInFieldLastTick or {}
		self.rubTimers = self.rubTimers or {}
		self.rubStrikes = self.rubStrikes or {}
	
		local interval = 5
		local strikeThresholds = {
			[1] = 5,  -- Strike 1
			[2] = 10,  -- Strike 2 - Warning!
			[3] = 15,  -- Strike 3
			[4] = 20, -- Strike 4
			[5] = 25, -- Strike 5
			[6] = 30, -- ! Prosecute !
		}
	
		for _, ply in ipairs(player.GetAll()) do
			if not ply:Alive() then continue end
			if ply:GetMoveType() == MOVETYPE_NOCLIP then continue end
	
			local inField = self:IsPlayerInForcefield(ply)
			local wasInField = self.wasInFieldLastTick[ply] or false
			local mode = self:GetMode() or 1
			local collides = (istable(ix.ForcefieldTypes[mode]) and ix.ForcefieldTypes[mode][1](ply)) or false

			if inField then
				if not wasInField then
					-- Just entered forcefield
					self.rubTimers[ply] = CurTime()
					self.rubStrikes[ply] = 0
	
					local last = self.lastColliders[ply] or 0
					if CurTime() - last > interval then
						self.lastColliders[ply] = CurTime()
						self:PlaySound(collides and ALARM_ENEMY or ALARM_FRIEND)
					end
				elseif collides then
					-- Still in field, check strike progression
					local timeInField = CurTime() - (self.rubTimers[ply] or 0)
	
					for strikeLevel = 1, #strikeThresholds do
						if self.rubStrikes[ply] < strikeLevel and timeInField >= strikeThresholds[strikeLevel] then
							self.rubStrikes[ply] = strikeLevel
	
							if strikeLevel == 1 then
								-- * STRIKE 1 *
								self:PlaySound(ALARM_ENEMY)
							elseif strikeLevel == 2 then
								-- * STRIKE 2 *
								self:PlaySound(ALARM_ENEMY)
								timer.Simple(1, function ()
									if (!IsValid(self)) then return end
									if (!self.lastWarning or (CurTime() - self.lastWarning > 120)) then
										self:PlaySound("ug/npc/overwatchvoice/ugcityvoice/overwatch_shortaccess.wav")
										self.lastWarning = CurTime()
									end
								end)
							elseif strikeLevel == 3 then
								-- * STRIKE 3 *
								self:PlaySound(ALARM_ENEMY)
							elseif strikeLevel == 4 then
								self:PlaySound(ALARM_ENEMY)
							elseif strikeLevel == 5 then
								self:PlaySound(ALARM_ENEMY)
							elseif strikeLevel == 6 then
								-- ! PROSECUTE ! -
								self:PlaySound(ALARM_ENEMY)
								timer.Simple(1, function ()
									if (!IsValid(self)) then return end
									if (!self.lastDispatch or (CurTime() - self.lastDispatch > 120)) then
										self:PlaySound("ug/npc/overwatchvoice/ugcityvoice/overwatch_restricted.wav")
										self.lastDispatch = CurTime()
									end
								end)
							end
						end
					end
				end
			else
				-- Left forcefield, reset rub state
				self.rubTimers[ply] = nil
				self.rubStrikes[ply] = nil
			end
	
			self.wasInFieldLastTick[ply] = inField
		end
	
		self:NextThink(CurTime() + 0.1)
		return true
	end	
else
	local SHIELD_MATERIAL = ix.util.GetMaterial("effects/combineshield/comshieldwall3")

	function ENT:Initialize()
		local data = {}
			data.start = self:GetPos() + self:GetRight()*-16
			data.endpos = self:GetPos() + self:GetRight()*-480
			data.filter = self
		local trace = util.TraceLine(data)

		self:EnableCustomCollisions(true)
		self:PhysicsInitConvex({
			vector_origin,
			Vector(0, 0, 150),
			trace.HitPos + Vector(0, 0, 150),
			trace.HitPos
		})
	end

	function ENT:Draw()
		self:DrawModel()

		local mode = self:GetMode() or 1
		local color = istable(ix.ForcefieldTypes[mode]) and ix.ForcefieldTypes[mode][3] or Color(255,255,255)

		if (!self:GetEnabled()) then
			return
		end

		local angles = self:GetAngles()
		local matrix = Matrix()
		matrix:Translate(self:GetPos() + self:GetUp() * -40)
		matrix:Rotate(angles)

		render.SetMaterial(SHIELD_MATERIAL)
		render.SetColorModulation(color.r / 255, color.g / 255, color.b / 255)

		local dummy = self:GetDummy()
		
		if (IsValid(dummy)) then
			local vertex = self:WorldToLocal(dummy:GetPos())
			self:SetRenderBounds(vector_origin, vertex + self:GetUp() * 150)
			
			cam.PushModelMatrix(matrix)
				self:DrawShield(vertex)
			cam.PopModelMatrix()

			matrix:Translate(vertex)
			matrix:Rotate(Angle(0, 180, 0))

			cam.PushModelMatrix(matrix)
				self:DrawShield(vertex)
			cam.PopModelMatrix()
		end
	end

	function ENT:DrawShield(vertex)
		local height = 190
		local width = vertex:Length()
	
		local uScale = math.max(width / 64, 1)
		local vScale = math.max(height / 64, 1)
		
		mesh.Begin(MATERIAL_QUADS, 1)
			mesh.Position(vector_origin)
			mesh.TexCoord(0, 0, 0)
			mesh.AdvanceVertex()
	
			mesh.Position(self:GetUp() * height)
			mesh.TexCoord(0, 0, vScale)
			mesh.AdvanceVertex()
	
			mesh.Position(vertex + self:GetUp() * height)
			mesh.TexCoord(0, uScale, vScale)
			mesh.AdvanceVertex()
	
			mesh.Position(vertex)
			mesh.TexCoord(0, uScale, 0)
			mesh.AdvanceVertex()
		mesh.End()
	end
	
end

local rats = {
	["npc_rat_hostile"] = true,
	["npc_rat"] = true,
	["npc_rat_big"] = true,
}

-- Shared collide for clientside prediction.
hook.Add("ShouldCollide", "ix_forcefields", function(a, b)
	local entity
	local other
	-- Check if either a or b is the forcefield
	if (IsValid(a) and a:GetClass() == "ix_forcefield") then
		entity = a
		other = b
	elseif (IsValid(b) and b:GetClass() == "ix_forcefield") then
		entity = b
		other = a
	end

	if (IsValid(entity)) then
		if (!entity:GetEnabled()) then
			return false -- Forcefield disabled = no collisions at all
		end

		local client = (a:IsPlayer() and a) or (b:IsPlayer() and b)

		if (IsValid(client)) then
			local mode = entity:GetMode() or 1
			local collides = istable(ix.ForcefieldTypes[mode]) and ix.ForcefieldTypes[mode][1](client)
			return collides
		else
			-- TODO: Call a hook to allow plugins to override behavior
			entity.lastNPCTimer = entity.lastNPCTimer or {}
			if (rats[other:GetClass()] == true and SERVER) then
				local lastTime = entity.lastNPCTimer[other] or 0
				if (CurTime() - lastTime > 10) then
					entity:PlaySound("storm/ForcefieldEnemy.wav")
					entity.lastNPCTimer[other] = CurTime()
				end
				return true
			end

			return false -- default: don't collide with props/ents when enabled
		end
	end
end)