function deletePlayerProps()
    local playerPed = PlayerPedId()
    local attachedEntities = {}
    local handBoneIndex = GetEntityBoneIndexByName(playerPed, "IK_R_Hand")

    for object in EnumerateObjects() do
        if DoesEntityExist(object) and IsEntityAttachedToEntity(object, playerPed) then
            local boneCoords = GetWorldPositionOfEntityBone(playerPed, handBoneIndex)
            local objectCoords = GetEntityCoords(object)

            if #(boneCoords - objectCoords) < 0.2 then
                table.insert(attachedEntities, object)
            end
        end
    end

    for _, object in ipairs(attachedEntities) do
        SetEntityAsMissionEntity(object, true, true)
        DeleteObject(object)
        print("Deleted prop from player's hand.")
    end

    if #attachedEntities == 0 then
        print("No props attached to the player's hand.")
    end
end

RegisterCommand("removeprops", function()
    deletePlayerProps()
end)

function EnumerateObjects()
    return coroutine.wrap(function()
        local handle, object = FindFirstObject()
        local success
        if not handle or handle == -1 then
            return
        end
        repeat
            coroutine.yield(object)
            success, object = FindNextObject(handle)
        until not success
        EndFindObject(handle)
    end)
end
