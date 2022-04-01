Config = {}
function L(ld) if Locales[Config.Language][ld] then return Locales[Config.Language][ld] end end

Config.Language = 'FI' --FI 

Config.jobname = "police" --robbery alert job
Config.polisecounttimer = 5 --time in seconds to count police in area
Config.HowLongBlipStays = 5 --how long the blip stays on the map

--SHELF
Config.shelfPositions = { --SHELF positions
  {pos=vector3(-50.15093,-1749.282,29.42102), heading=318.01416015625},
  {pos=vector3(-48.72872,-1755.252,29.421), heading=2.9393012523651},

}

Config.shelf_items = {  --SHELF items
    [1] =  {databasetitle = "puhelin", databasename = "phone", minamount = 1, maxamount = 1},
    [2] =  {databasetitle = "fixkit", databasename = "fixkit", minamount = 1, maxamount = 1},
}

Config.shelfpolicealertPercent = 100 --percent chance of alerting police
Config.shelfGiveNewItemsMinutes = 5 --minuuttia
Config.shelfmincops = 1 --min cops


--SAFE 

Config.safePositions = { --safe positions
  {pos=vector3(-43.46346,-1748.511,29.42101), heading=50.257671356201},
}

Config.safe = {
    poliseneed = 1,
    policealertPercent = 100,
    moneytype = "money", --money / black_money
    moneymin = 1, --min money
    moneymax = 1000, --max money
}