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

RegisterNetEvent('car_test:go')
AddEventHandler('car_test:go', function()
	local xPlayer = ESX.GetPlayerFromId(source)
    local _source = source
	MySQL.Async.fetchAll('SELECT * FROM car_test', {}, function(result)
        local in_test = result[1].in_test
        if (in_test == 0) then
            TriggerClientEvent("car_test:can_go", _source)
        else
            TriggerClientEvent("car_test:cant_go", _source)
        end
    end)

end)

RegisterNetEvent('car_test:on_test')
AddEventHandler('car_test:on_test', function()
    MySQL.Async.execute('UPDATE car_test SET in_test = @in_test WHERE name = @name', {
        ['@name'] = "car_test",
        ['@in_test'] = 1,
    }, function(rowsChanged)
    end)
end)

RegisterNetEvent('car_test:no_test')
AddEventHandler('car_test:no_test', function()
    MySQL.Async.execute('UPDATE car_test SET in_test = @in_test WHERE name = @name', {
        ['@name'] = "car_test",
        ['@in_test'] = 0,
    }, function(rowsChanged)
    end)
end)