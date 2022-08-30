ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

ESX.RegisterServerCallback('car_test:cat', function(source, cb, plate)
    local xPlayer = ESX.GetPlayerFromId(source)
    local keys = {}

    MySQL.Async.fetchAll('SELECT * FROM vehicle_categories', {}, 
        function(result)
        for category = 1, #result, 1 do
            table.insert(keys, {
                name = result[category].name,
                label = result[category].label,
            })
        end
        cb(keys)

    end)
end)

ESX.RegisterServerCallback('car_test:voiture', function(source, cb, plate)
    local xPlayer = ESX.GetPlayerFromId(source)
    local keys2 = {}

    MySQL.Async.fetchAll('SELECT * FROM vehicles', {}, 
        function(result)
        for voiture = 1, #result, 1 do
            table.insert(keys2, {
                name = result[voiture].name,
                model = result[voiture].model,
                category = result[voiture].category
            })
        end
        cb(keys2)

    end)
end)

RegisterNetEvent('car_test:vehicule')
AddEventHandler('car_test:vehicule', function(prix)
	local xPlayer = ESX.GetPlayerFromId(source)
	local playerMoney = xPlayer.getMoney()
	local min = Config.time
	xPlayer.removeMoney(prix)
	TriggerClientEvent('esx:showNotification', source, _U('ready'))
	TriggerClientEvent('esx:showNotification', source, _U('time') .. min.. _U('time_bis'))

end)