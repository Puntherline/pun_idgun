-- (Re)set locals at start
local infoOn = false    -- Disables the info on restart.
local coordsText = ""   -- Removes any text the coords had stored.
local headingText = ""  -- Removes any text the heading had stored.
local modelText = ""    -- Removes any text the model had stored.
local modelVehText = ""    -- Removes any text the model had stored.

local hashes_file = LoadResourceFile(GetCurrentResourceName(), "hashes.json")
local hashes = json.decode(hashes_file)

-- Thread that makes everything happen.
Citizen.CreateThread(function()                             -- Create the thread.
    while true do                                           -- Loop it infinitely.
        local pause = 250                                   -- If infos are off, set loop to every 250ms. Eats less resources.
        if infoOn then                                      -- If the info is on then...
            pause = 5                                       -- Only loop every 5ms (equivalent of 200fps).
            local player = PlayerPedId()                    -- Get the player.
            if IsPlayerFreeAiming(PlayerId()) then          -- If the player is free-aiming (update texts)...
                local entity = getEntity(PlayerId())        -- Get what the player is aiming at. This isn't actually the function, that's below the thread.
                local coords = GetEntityCoords(entity)      -- Get the coordinates of the object.
                local heading = GetEntityHeading(entity)    -- Get the heading of the object.
                local model = GetEntityModel(entity)        -- Get the hash of the object.

                if IsEntityAPed(entity) then
                    local vehicle = GetVehiclePedIsIn(entity, false)
                    local model_veh = GetEntityModel(vehicle)        -- Get the hash of the object.

                    if vehicle ~= 0 then
                        if hashes[tostring(model_veh)] then
                            modelVehText = hashes[tostring(model_veh)]         -- Set the modelText local with the actual name.
                        else
                            modelVehText = model_veh                           -- Set the modelText local.
                        end
                    else
                        modelVehText = ""
                    end

                    if hashes[tostring(model)] then
                        coordsText = coords                         -- Set the coordsText local.
                        headingText = heading                       -- Set the headingText local.
                        modelText = hashes[tostring(model)]         -- Set the modelText local with the actual name.
                    else
                        coordsText = coords                         -- Set the coordsText local.
                        headingText = heading                       -- Set the headingText local.
                        modelText = model                           -- Set the modelText local.
                    end
                else
                    modelVehText = ""
                    if hashes[tostring(model)] then
                        coordsText = coords                         -- Set the coordsText local.
                        headingText = heading                       -- Set the headingText local.
                        modelText = hashes[tostring(model)]         -- Set the modelText local with the actual name.
                    else
                        coordsText = coords                         -- Set the coordsText local.
                        headingText = heading                       -- Set the headingText local.
                        modelText = model                           -- Set the modelText local.
                    end
                end
            end                                             -- End (player is not freeaiming: stop updating texts).
            if modelVehText ~= "" then
                DrawInfos("Coordinates: " .. coordsText, "Heading: " .. headingText, "Hash (PED IN VEHICLE): " .. modelText, "Hash (VEHICLE): " .. modelVehText) 
            else
                DrawInfos("Coordinates: " .. coordsText, "Heading: " .. headingText, "Hash: " .. modelText)     -- Draw the text on screen
            end

			-- print to console on E release
			if IsControlJustReleased(0, 38) then print(("\nCoords: %s\nHeading: %s\nHash: %s\n%s"):format(coordsText, headingText, modelText, modelVehText == "" and "" or ("Vehicle Hash: %s"):format(modelVehText))) end
        end                                                 -- Info is off, don't need to do anything.
        Citizen.Wait(pause)                                 -- Now wait the specified time.
    end                                                     -- End (stop looping).
end)                                                        -- Endind the entire thread here.

-- Function to get the object the player is actually aiming at.
function getEntity(player)                                          -- Create this function.
    local result, entity = GetEntityPlayerIsFreeAimingAt(player)    -- This time get the entity the player is aiming at.
    return entity                                                   -- Returns what the player is aiming at.
end                                                                 -- Ends the function.

-- Function to draw the text.
function DrawInfos(...)
    local args = {...}

    ypos = 0.70
    for k,v in pairs(args) do
        SetTextColour(255, 255, 255, 255)   -- Color
        SetTextFont(0)                      -- Font
        SetTextScale(0.4, 0.4)              -- Scale
        SetTextWrap(0.0, 1.0)               -- Wrap the text
        SetTextCentre(false)                -- Align to center(?)
        SetTextDropshadow(0, 0, 0, 0, 255)  -- Shadow. Distance, R, G, B, Alpha.
        SetTextEdge(50, 0, 0, 0, 255)       -- Edge. Width, R, G, B, Alpha.
        SetTextOutline()                    -- Necessary to give it an outline.
        SetTextEntry("STRING")
        AddTextComponentString(v)
        DrawText(0.015, ypos)               -- Position
        ypos = ypos + 0.028
    end
end

-- Creating the function to toggle the info.
ToggleInfos = function()                -- "ToggleInfos" is a function
    infoOn = not infoOn                 -- Switch them around
end                                     -- Ending the function here.

-- Creating the command.
RegisterCommand("idgun", function()     -- Listen for this command.
	TriggerServerEvent("pun_idgun:c_s:RequestToggle")
end)                                    -- Ending the function here.

RegisterNetEvent("pun_idgun:s_c:ToggleAllowed")
AddEventHandler("pun_idgun:s_c:ToggleAllowed", function()
	ToggleInfos()
end)
