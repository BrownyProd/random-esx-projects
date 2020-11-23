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
            if ESX.PlayerData.job ~= nil and ESX.PlayerData.job.name == v.job then
                if Vdist2(GetEntityCoords(PlayerPedId(), false), v.vault) < 3.5 then
                    sleep = 5
                    notif("Press ~INPUT_CONTEXT~ to open the "..v.job.. " vault.")
                    DrawMarker(25, v.vault, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 1.75, 1.75, 1.75, 0, 204, 204, 100, false, true, 2, false, false, false, false)
                    if IsControlJustReleased(0, 38) then
                        openMenu(v.soc)
                    end
                end
            end
        end
        Citizen.Wait(sleep)
    end
end)



function openMenu(society)
    local elem = {
        {label = "Put something in the vault", value = "put_stock"},
        --{label = "Get something from the vault", value = "get_stock"},
    }
    ESX.UI.Menu.CloseAll()

    ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'vault', {
		title    = "Vault",
		align    = 'top-left',
		elements = elements
	}, function(data, menu)

		if data.current.value == 'put_stock' then
			OpenPutStocksMenu(society)
		--elseif data.current.value == 'get_stock' then
		--	OpenGetStocksMenu()
		end

	end, function(data, menu)
	end)
end


function OpenPutStocksMenu(society)
    local elements = {}

    local inventory = ESX.GetPlayerData().inventory
    for i=1, #inventory, 1 do
        table.insert(elements, {label = item.label .. ' x' .. item.count, value = item.name})
    end

    ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'stocks_menu', {
        title    = _U('inventory'),
        align    = 'top-left',
        elements = elements
    }, function(data, menu)
        local itemName = data.current.value

        ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'stocks_menu_put_item_count', {
            title = _U('quantity')
        }, function(data2, menu2)
            local count = tonumber(data2.value)

            if not count then
                ESX.ShowNotification("")
            else
                menu2.close()
                menu.close()
                TriggerServerEvent('jobs:PutInVault', itemName, count, society)

                Citizen.Wait(300)
                OpenPutStocksMenu()
            end
        end, function(data2, menu2)
            menu2.close()
        end)
    end, function(data, menu)
        menu.close()
    end)
end


function notif(txt) 
    SetTextComponentFormat("STRING")
    AddTextComponentString(txt)
    DisplayHelpTextFromStringLabel(0, 0, 1, -1)
end


