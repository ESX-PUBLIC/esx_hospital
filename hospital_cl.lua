---------- VARIABLES ----------
local treatment = false
local timer = false

local blips = {
    {name="Hospital", id=61, x = 338.85, y = -1394.56, z = 31.51, color = 1, heading=49.404, scale=0.7 },
    {name="Hospital", id=61, x = -449.67, y = -340.83, z = 33.50, color = 1, heading=82.17, scale=0.7 },
    {name="Hospital", id=61, x = 246.47717285156, y = -1365.7154541016, z = 28.647993087769, color= 1, heading=221.25, scale=0.7},
    {name="Hospital", id=61, x = -874.79931640625, y = -307.5654296875, z = 38.580024719238, color= 1, heading=350.95, scale=0.7},
    {name="Hospital", id=61, x = -496.97717285156, y = -336.14242553711, z = 33.501697540283, color= 1, heading=253.92, scale=0.7},
    {name="Hospital", id=61, x = 298.70138549805, y = -584.62774658203, z = 42.260841369629, color= 1, heading=75.49, scale=0.7},
    {name="Hospital", id=61, x = 1839.5194091797, y = 3672.591796875, z = 33.276710510254, color= 1, heading=214.90, scale=0.7},
    {name="Hospital", id=61, x = -246.98889160156, y = 6330.5834960938, z = 31.426147460938, color= 1, heading=221.37, scale=0.7},
}

---------- FONCTIONS ----------
function Notify(text)
    SetNotificationTextEntry('STRING')
    AddTextComponentString(text)
    DrawNotification(false, false)
end

function ShowInfo(text, state)
    SetTextComponentFormat("STRING")
    AddTextComponentString(text)DisplayHelpTextFromStringLabel(0, state, 0, -1)
end

---------- CITIZEN ----------
Citizen.CreateThread(function()
    RequestModel(GetHashKey("s_m_m_doctor_01"))
    while not HasModelLoaded(GetHashKey("s_m_m_doctor_01")) do
        Wait(1)
    end

    for _, item in pairs(blips) do
        item.blip = AddBlipForCoord(item.x, item.y, item.z)
        SetBlipSprite(item.blip, item.id)
        SetBlipColour(item.blip, item.color)
        SetBlipAsShortRange(item.blip, true)
        SetBlipScale(item.blip, item.scale)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString(item.name)
        EndTextCommandSetBlipName(item.blip)

        CreatePed(4, 0xd47303ac, item.x, item.y, item.z, item.heading, false, true)
        SetEntityHeading(item.blip, item.heading)
        FreezeEntityPosition(item.blip, true)
        SetEntityInvincible(item.blip, true)
        SetBlockingOfNonTemporaryEvents(item.blip, true)
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        for _, item in pairs(blips) do
            if GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(-1)), item.x, item.y, item.z, true) <= 20 then
                DrawMarker(0, item.x, item.y, item.z, 0, 0, 0, 0, 0, 0, 2.001, 2.0001, 0.5001, 0, 155, 255, 200, 0, 0, 0, 0)
                if GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(-1)), item.x,item.y,item.z, true) <= 2 then
                    ShowInfo("Press ~INPUT_VEH_HORN~ to be treated ~r~(~h~~g~$500~r~)", 0)
                    if (IsControlJustPressed(1,38)) and (GetEntityHealth(GetPlayerPed(-1)) < 200) and (GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(-1)), item.x, item.y, item.z, true) <= 2) then
                        TriggerEvent("pNotify:SetQueueMax", -1, "lmao", 10)
                        TriggerEvent("pNotify:SendNotification", {
                            text = "<b style = 'color:white'>The doctor will treat you, please be patient.</b>",
                            type = "alert",
                            queue = "lmao",
                            timeout = 5000,
                            layout = "centerLeft"
                        })                        
                        treatment = true
                    end
                end
            end
            if (IsControlJustPressed(1,38)) and (GetEntityHealth(GetPlayerPed(-1)) == 200) and (GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(-1)), item.x, item.y, item.z, true) <= 2) then
                TriggerEvent("pNotify:SendNotification", {
                    text = "<b style = 'color:red'>You don't need treatment.</b>",
                    type = "alert",
                    queue = "lmao",
                    timeout = 5000,
                    layout = "centerLeft"
                })
            end
            if treatment == true then
                Citizen.Wait(15000)
                timer = true
            end
            if treatment == true and timer == true and (GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(-1)), item.x, item.y, item.z, true) <= 2) then
                TriggerServerEvent('hospital:price')
                SetEntityHealth(GetPlayerPed(-1), 200)
                TriggerEvent("pNotify:SendNotification", {
                    text = "<b style = 'color:white'>The doctor treated you.</b>",
                    type = "alert",
                    queue = "lmao",
                    timeout = 5000,
                    layout = "centerLeft"
                })
                treatment = false
                timer = false
            end
            if treatment == true and timer == true and (GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(-1)), item.x, item.y, item.z, true) > 2) then
                TriggerEvent("pNotify:SendNotification", {
                    text = "<b style = 'color:white'>You have moved away, the doctor could not heal you!</b>",
                    type = "error",
                    queue = "lmao",
                    timeout = 5000,
                    layout = "centerLeft"
                })
                treatment = false
                timer = false
            end
        end
    end
end)
