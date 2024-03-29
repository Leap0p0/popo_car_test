ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

RMenu.Add("car_test", "categorie", RageUI.CreateMenu(_U('Essai'), "~b~".._U('categorie')))
RMenu:Get("car_test", "categorie").Closed = function()
    FreezeEntityPosition(PlayerPedId(), false)
end

RMenu.Add("car_test", "voiture", RageUI.CreateSubMenu(RMenu:Get("car_test", "categorie"), _U('choose'), nil))
RMenu:Get("car_test", "voiture").Closed = function()end

RMenu.Add("car_test", "sure", RageUI.CreateSubMenu(RMenu:Get("car_test", "voiture"), _U('sure'), _U('sure')))
RMenu:Get("car_test", "sure").Closed = function()end

cate = {}
voitureliste = {}

--open the menu in RageUI--

local function openMenu()
	FreezeEntityPosition(PlayerPedId(), true)

    RageUI.Visible(RMenu:Get("car_test","categorie"), true)
    Citizen.CreateThread(function()
        while true do

            --Categories--
            RageUI.IsVisible(RMenu:Get("car_test","categorie"),true,true,true,function()
                for category = 1, #cate, 1 do
                    RageUI.Button(""..cate[category].label , ""..cate[category].label, {RightLabel = "~g~>>>"}, true,function(h,a,s)
                        if (s) then
                            label = cate[category].label
                            name = cate[category].name
                        end
                    end, RMenu:Get("car_test", "voiture"))
                end
            end, function()end)

            --Car name--
            RageUI.IsVisible(RMenu:Get("car_test","voiture"),true,true,true,function()
                ESX.TriggerServerCallback('car_test:voiture', function(keys2)
                    voitureliste = keys2
                end)
                for voiture = 1, #voitureliste, 1 do
                    if voitureliste[voiture].category == name then
                        RageUI.Button(""..voitureliste[voiture].name, ""..voitureliste[voiture].name, {RightLabel = "~g~>>>"}, true,function(h,a,s)
                            if (s) then
                                name = voitureliste[voiture].name
                                model2 = voitureliste[voiture].model
                            end
                        end, RMenu:Get("car_test", "sure"))
                    end
                end
            end, function()end, 1)

            --test ?--
            RageUI.IsVisible(RMenu:Get("car_test","sure"),true,true,true,function()
                RageUI.Button(_U('yes'), _U('yes'), {RightLabel = "~g~0$"}, true,function(h,a,s)
                    if (s) then
                        RageUI.CloseAll()
                        FreezeEntityPosition(PlayerPedId(), false)
                        TriggerServerEvent('car_test:go')
                    end
                end)

                RageUI.Button(_U('no'), _U('no'), {RightLabel = "~g~0$"}, true,function(h,a,s)
                    if (s) then
                        RageUI.CloseAll()
                        FreezeEntityPosition(PlayerPedId(), false)
                    end
                end)
            end, function()end, 1)
            Citizen.Wait(0)
        end
    end)

end

--draw marker--
Citizen.CreateThread(function()
    while true do
        local interval = 1
        local pos = GetEntityCoords(PlayerPedId())
        local distance = GetDistanceBetweenCoords(pos, Config.pedpos, true)

        if distance > 30 then
            interval = 200
        else
            interval = 1
            if distance < 1 then
                AddTextEntry("try", _U('open'))
                DisplayHelpTextThisFrame("try", false)
                DrawMarker(2, Config.pedpos, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.5, 0.5, 0.5, 255, 0, 0, 170, 0, 1, 2, 0, nil, nil, 0)
                if IsControlJustPressed(1, 51) then
                    openMenu()
                    ESX.TriggerServerCallback('car_test:cat', function(keys)
                        cate = keys
                    end)
                end
            end
        end
        Citizen.Wait(interval)
    end  
end)

--spawn car function--

function spawnCar(car)
    local ped = PlayerPedId()
    local car = GetHashKey(car)
    local timetoend = Config.timetoend

    RequestModel(car)
    while not HasModelLoaded(car) do
        RequestModel(car)
        Citizen.Wait(0)
    end
    local x, y, z = table.unpack(GetEntityCoords(GetPlayerPed(-1), false))
    local vehicle = CreateVehicle(car, Config.car_pos, 56.87, true, false)
    SetEntityAsMissionEntity(vehicle, true, true)
    SetVehicleNumberPlateText(vehicle, "ESSAI") 
    SetPedIntoVehicle(GetPlayerPed(-1),vehicle,-1)
        local time = Config.time -- 1 heure
        while (time ~= 0) do
        Wait( 1000 ) -- Wait a second
        time = time - 1
        -- 1 Second should have past by now
        if time == Config.timetoend then
            ESX.ShowNotification( _U('timetoend')..timetoend.. _U('timetoend_bis'))
        end
        end
    DeleteVehicle(vehicle)
    FreezeEntityPosition(PlayerPedId(), false)
    SetEntityCoords(ped, Config.pedpos, false, false, false, false)
    TriggerServerEvent('car_test:no_test')
end

-- go or not ?--

RegisterNetEvent("car_test:can_go")
AddEventHandler("car_test:can_go", function()
    TriggerServerEvent('car_test:on_test')
    TriggerServerEvent('car_test:vehicule', 0)
    spawnCar(model2)
end)

RegisterNetEvent("car_test:cant_go")
AddEventHandler("car_test:cant_go", function()
    ESX.ShowNotification(_U('teston'))
end)

--display blip--

Citizen.CreateThread(function()

    local blip = AddBlipForCoord(Config.Blip.Pos.x, Config.Blip.Pos.y, Config.Blip.Pos.z)
  
    SetBlipSprite (blip, Config.Blip.Sprite)
    SetBlipDisplay(blip, Config.Blip.Display)
    SetBlipScale  (blip, Config.Blip.Scale)
    SetBlipColour (blip, Config.Blip.Colour)
    SetBlipAsShortRange(blip, true)
  
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString(_U('Essai'))
    EndTextCommandSetBlipName(blip)
  
end)