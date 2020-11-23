ESX = nil


RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
	ESX.PlayerData.job = job
	Citizen.Wait(5000)
	TriggerServerEvent('esx_policejob:forceBlip')
end)

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
end)

Citizen.CreateThread(function()
    while true do
        local sleep = 200
        for k,v in pairs (BrShared.Soc) do
            if ESX.PlayerData.job ~= nil and ESX.PlayerData.job.grade_name == "boss" then
                if ESX.PlayerData.job.name == v.job then
                    if Vdist2(GetEntityCoords(PlayerPedId(), false), v.boss) < 3.5 then
                        sleep = 5
                        notif("Press ~INPUT_CONTEXT~ to open the "..v.job.." boss menu.")
                        DrawMarker(25, v.boss, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 1.75, 1.75, 1.75, 0, 204, 204, 100, false, true, 2, false, false, false, false)
                        if IsControlJustReleased(0, 38) then
                            TriggerEvent('esx_society:openBossMenu', ESX.PlayerData.job.name, function(data, menu) end)
                        end
                    end
                end
            end
        end
        Citizen.Wait(sleep)
    end
end)






function notif(txt) 
    SetTextComponentFormat("STRING")
    AddTextComponentString(txt)
    DisplayHelpTextFromStringLabel(0, 0, 1, -1)
end