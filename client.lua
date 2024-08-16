local ragdoll = false 
local cmd_cd = false
local commandname = "ragdoll"
local allowkey = true
local keylistenrate = 5
local controlkey = `INPUT_OPEN_JOURNAL` -- J
local cooldown = 5000

local function DoRagdoll(ped)
	if ragdoll then 
		print("off")
		ragdoll = false
		SetPedToDisableRagdoll(ped, false)
		SetTimeout(2000, function()
			SetPedToDisableRagdoll(ped, true)
		end)
	else
		if IsEntityDead(ped) ~= 1 then 
			ragdoll = true
			print("on")
			SetPedToRagdoll(ped, -1, -1, 0, 1, 1, 0)
		end
	end
end

RegisterCommand(commandname, function(source, args, raw)
	if not cmd_cd then 
		cmd_cd = true 
		SetTimeout(cooldown, function()
			cmd_cd = false
		end)
		DoRagdoll()
	end
end)

if allowkey then 
	CreateThread(function()
		while true do
			if IsControlJustPressed(0, controlkey) or IsDisabledControlJustPressed(0, controlkey) then
				DoRagdoll(PlayerPedId())
				Wait(cooldown)
			end
			Wait(keylistenrate)
		end
	end)
end