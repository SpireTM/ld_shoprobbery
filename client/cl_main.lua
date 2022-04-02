ESX = nil

Citizen.CreateThread(function ()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj)
            ESX = obj
        end)

        Citizen.Wait(5)
    end
end)

--shelf
Citizen.CreateThread(function()
    local SleepThread = 200
    while true do
        local coords = GetEntityCoords(PlayerPedId())
        local playerPos = GetEntityCoords(PlayerPedId(), true)

        for i=1, #Config.shelfPositions, 1 do
            local distance = #(Config.shelfPositions[i].pos-coords)
            if not holdingUp then
                if distance < 0.5 then
                    SleepThread = 5
                    Draw3DText(Config.shelfPositions[i].pos, L("robb_text"), 0.35)
                    if IsControlJustPressed(0,38) then
                        if not robbing then
                            robbing = true
                            StartAnimation(i)
                        end
                    elseif IsControlJustPressed(0,73) then
                        cancelled = true
                    end
                end
            end
        end
        Citizen.Wait(SleepThread)
    end
end)

--safe
Citizen.CreateThread(function(pos)
    while true do
        Citizen.Wait(5)
        local coords = GetEntityCoords(PlayerPedId())
        local playerPos = GetEntityCoords(PlayerPedId(), true)

        for i=1, #Config.safePositions, 1 do
            local distance = #(Config.safePositions[i].pos-coords)

            if not holdingUp then
                if distance < 0.5 then
                    Draw3DText(Config.safePositions[i].pos, L("robb_text"), 0.35)
                    if IsControlJustPressed(0,38) then
                        ESX.TriggerServerCallback('LD_storerobbery:itemicheek', function(maara)
                            if maara > 0 then
                                if not robbing then
                                    robbing = true
                                    aloitasafepaska()
                                end
                            end
                        end)
                    end
                end
            end
        end
    end
end)



RegisterNetEvent('LD_storerobbery:police_alert')
AddEventHandler('LD_storerobbery:police_alert', function(pos)
    if ESX.PlayerData.job.name ~= nil then
        if ESX.PlayerData.job.name == Config.jobname  then
            CreateThread(function()
                muggi(L"police_alert")
                local copblip = AddBlipForCoord(pos)
                SetBlipSprite(copblip , 161)
                SetBlipScale(copblipy , 2.0)
                SetBlipColour(copblip, 8)
                BeginTextCommandSetBlipName("STRING")
                AddTextComponentString(L"alerblip_name")
                EndTextCommandSetBlipName(copblip)
                PulseBlip(copblip)
                Wait(Config.HowLongBlipStays*1000)
                RemoveBlip(copblip)
            end)
        end
    end
end)

RegisterNetEvent('LD_storerobbery:shelf_policealert')
AddEventHandler('LD_storerobbery:shelf_policealert', function(pos)
    if ESX.PlayerData.job.name ~= nil then
        if ESX.PlayerData.job.name == Config.jobname  then
            CreateThread(function()
                muggi(L"shafe_police_alert")
                local copblip = AddBlipForCoord(pos)
                SetBlipSprite(copblip , 161)
                SetBlipScale(copblipy , 2.0)
                SetBlipColour(copblip, 8)
                BeginTextCommandSetBlipName("STRING")
                AddTextComponentString(L"alerblip_name")
                EndTextCommandSetBlipName(copblip)
                PulseBlip(copblip)
                Wait(Config.HowLongBlipStays*1000)
                RemoveBlip(copblip)
            end)
        end
    end
end)

function muggi(msg)
    local mugshot, mugshotStr = ESX.Game.GetPedMugshot(GetPlayerPed(-1))
    ESX.ShowAdvancedNotification(L'policealert_title', '', msg, mugshotStr, 1)
    UnregisterPedheadshot(mugshot)
end


RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
    ESX.PlayerData.job = job
end)

function aloitasafepaska()
    ESX.TriggerServerCallback('LD_storerobbery:poliis', function(cops)
        if cops >= Config.safe.poliseneed then
            local res = exports["pd-safe"]:createSafe({math.random(0,99),math.random(0,99),math.random(0,99)})
            if res then
                TriggerServerEvent("LD_storerobbery:safe", a, GetEntityCoords(PlayerPedId()))
                robbing = false
            else
                robbing = false
            end

        else
            ESX.ShowNotification('Ei tarpeeksi poliiseja!')
        end
    end)
end


function StartAnimation(a)
    local p = PlayerPedId()
    ClearPedTasks(p)
    SetEntityHeading(p, Config.shelfPositions[a].heading)
    RequestAnimDict("anim@amb@clubhouse@tutorial@bkr_tut_ig3@")
    while not HasAnimDictLoaded("anim@amb@clubhouse@tutorial@bkr_tut_ig3@") do
        Citizen.Wait(0)
    end
    TaskPlayAnim((p), "anim@amb@clubhouse@tutorial@bkr_tut_ig3@", "machinic_loop_mechandplayer", 1.0, 1.0, -1, 9, 1.0, 0, 0, 0)
    SetTimeout(2000, function()
        if not cancelled then
            ClearPedTasks(PlayerPedId())
            TriggerServerEvent('LD_storerobbery:shelf', a, GetEntityCoords(PlayerPedId()))
        end
        cancelled = false
        robbing = false
    end)
end

function Draw3DText(coords, text, scale)
    SetTextScale(0.35, 0.35)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)
    SetTextEntry("STRING")
    SetTextCentre(true)
    AddTextComponentString(text)
    SetDrawOrigin(x,y,z, 0)
    DrawText(0.0, 0.0)
    local factor = (string.len(text)) / 370
    DrawRect(0.0, 0.0+0.0125, 0.017+ factor, 0.03, 0, 0, 0, 75)
    ClearDrawOrigin()
end
