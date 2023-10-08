local requirePermissions = true

RegisterNetEvent("pun_idgun:c_s:RequestToggle")
AddEventHandler("pun_idgun:c_s:RequestToggle", function()
	local _source = source
	if not requirePermissions or IsPlayerAceAllowed(_source, "command.idgun") == 1 then
		TriggerClientEvent("pun_idgun:s_c:ToggleAllowed", _source)
	end
end)
