function deletePlayerProps()
    local playerPed = PlayerPedId()
    local attachedEntities = {}

    local rightHandBoneIndex = GetEntityBoneIndexByName(playerPed, "IK_R_Hand")
    local leftHandBoneIndex = GetEntityBoneIndexByName(playerPed, "IK_L_Hand")

    if rightHandBoneIndex == -1 and leftHandBoneIndex == -1 then
        print("Failed to find both hand bones.")
        return
    end

    for object in EnumerateObjects() do
        if DoesEntityExist(object) and IsEntityAttachedToEntity(object, playerPed) then
            local objectCoords = GetEntityCoords(object)

            if rightHandBoneIndex ~= -1 then
                local rightHandCoords = GetWorldPositionOfEntityBone(playerPed, rightHandBoneIndex)
                if #(rightHandCoords - objectCoords) < 0.2 then
                    table.insert(attachedEntities, object)
                    goto continue
                end
            end

            if leftHandBoneIndex ~= -1 then
                local leftHandCoords = GetWorldPositionOfEntityBone(playerPed, leftHandBoneIndex)
                if #(leftHandCoords - objectCoords) < 0.2 then
                    table.insert(attachedEntities, object)
                end
            end
        end
        ::continue::
    end

    for _, object in ipairs(attachedEntities) do
        SetEntityAsMissionEntity(object, true, true)
        DeleteObject(object)
        print("Deleted prop from player's hand.")
    end

    if #attachedEntities == 0 then
        print("No props attached to the player's hands.")
    end
end
