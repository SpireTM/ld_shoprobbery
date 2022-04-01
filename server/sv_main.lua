ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

local selfcooldown = {}
local cops = 0

CreateThread(function()
    for i=1, #Config.shelfPositions, 1 do
        table.insert(selfcooldown, false)
    end
    while true do
        for i=1,#selfcooldown do
            selfcooldown[i] = false
        end
        Wait(1000*60*Config.shelfGiveNewItemsMinutes)
    end
end)




RegisterServerEvent('LD_storerobbery:shelf')
AddEventHandler('LD_storerobbery:shelf', function(a, pos)

        if not selfcooldown[a] then
            selfcooldown[a] = true
            local matikka22 = math.random(1,100)
            if matikka22 <= Config.shelfpolicealertPercent then
                TriggerClientEvent('LD_storerobbery:shelf_policealert', -1, pos)
            end
            local xPlayer = ESX.GetPlayerFromId(source)
            local nopeetmatikat = math.random(1,#Config.shelf_items)
            xPlayer.addInventoryItem(Config.shelf_items[nopeetmatikat].databasename, math.random(Config.shelf_items[nopeetmatikat].minamount,Config.shelf_items[nopeetmatikat].maxamount))
            TriggerClientEvent('esx:showNotification', source, 'Löysit '..Config.shelf_items[nopeetmatikat].databasetitle..'!')
        else
            TriggerClientEvent('esx:showNotification', source, 'Tyhjää täynnä!')
        end

end)

RegisterServerEvent('LD_storerobbery:safe')
AddEventHandler('LD_storerobbery:safe', function(a, pos)
    local matikkamaster = math.random(1,100)
    if matikkamaster <= Config.safe.policealertPercent then
        TriggerClientEvent('LD_storerobbery:police_alert', -1, pos)
    end
    local xPlayer = ESX.GetPlayerFromId(source)
    local nopeetmatikat = math.random(Config.safe.moneymin,Config.safe.moneymax)
    print(nopeetmatikat)
  if Config.safe.moneytype == "money" then
    xPlayer.addMoney(nopeetmatikat)
    TriggerClientEvent('esx:showNotification', source, 'Löysit '..nopeetmatikat..'€!')
    elseif Config.safe.moneytype == "black_money" then
    xPlayer.addAccountMoney('black_money', nopeetmatikat)
    TriggerClientEvent('esx:showNotification', source, 'Löysit '..nopeetmatikat..'€!')
    end
end)

ESX.RegisterServerCallback("LD_storerobbery:itemicheek", function(source, cb)
    local xPlayer = ESX.GetPlayerFromId(source)
    local tavara = xPlayer.getInventoryItem("lockpick").count
	if tavara >= 1 then
    	cb(tavara)
		xPlayer.removeInventoryItem("lockpick", 1)
	else
		TriggerClientEvent("esx:showNotification", source, L"need_item")
	end
end)




ESX.RegisterServerCallback('LD_storerobbery:poliis',function(source, cb)
    local xPlayers = ESX.GetPlayers()
    for i=1, #xPlayers, 1 do
      local _source = xPlayers[i]
      local xPlayer = ESX.GetPlayerFromId(_source)
      if xPlayer.job.name == 'police' then
        cops = cops + 1
      end
    end
    cb(cops)
end)

