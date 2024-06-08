function CreateInstuctionScaleform(scaleform)
	local scaleform = RequestScaleformMovie(scaleform)

	while not HasScaleformMovieLoaded(scaleform) do
		Citizen.Wait(10)
	end

	PushScaleformMovieFunction(scaleform, "CLEAR_ALL")
	PopScaleformMovieFunctionVoid()

	PushScaleformMovieFunction(scaleform, "SET_CLEAR_SPACE")
	PushScaleformMovieFunctionParameterInt(200)
	PopScaleformMovieFunctionVoid()

	PushScaleformMovieFunction(scaleform, "DRAW_INSTRUCTIONAL_BUTTONS")
	PopScaleformMovieFunctionVoid()

	PushScaleformMovieFunction(scaleform, "SET_BACKGROUND_COLOUR")
	PushScaleformMovieFunctionParameterInt(0)
	PushScaleformMovieFunctionParameterInt(0)
	PushScaleformMovieFunctionParameterInt(0)
	PushScaleformMovieFunctionParameterInt(80)
	PopScaleformMovieFunctionVoid()

	return scaleform
end

function CreateCCTVCamera(camData)
    SetVisibility(false)
    local ped = PlayerPedId()
    
    RequestCollisionAtCoord(camData.coords.x, camData.coords.y, camData.coords.z)
    local cam = CreateCamWithParams("DEFAULT_SCRIPTED_CAMERA", camData.coords.x, camData.coords.y, camData.coords.z, camData.rotation.x, camData.rotation.y, camData.rotation.z, camData.fov, false, 1)
    SetFocusPosAndVel(camData.coords.x, camData.coords.y, camData.coords.z, 0.0, 0.0, 0.0)
    -- load textures at camera coords

	DrawScaleformMovieFullscreen(CreateInstuctionScaleform("instructional_buttons"), 255, 255, 255, 255, 0)
	SetTimecycleModifier("scanline_cam_cheap")
	SetTimecycleModifierStrength(1.0)
    SetCamActive(cam, true)
    RenderScriptCams(true, false, 0, true, true)
    if camData.canMove then
        Citizen.CreateThread(function()
            local limitX = 0.0
            local limitZ = 0.0
            while DoesCamExist(cam) do
                Citizen.Wait(0)
                if IsControlPressed(0, 174) then
                    if limitZ < 30.0 then
                        camData.rotation = camData.rotation + vector3(0.0, 0.0, 0.1)
                        limitZ = limitZ + 0.1
                    end
                end
                if IsControlPressed(0, 175) then
                    if limitZ > -30.0 then
                        camData.rotation = camData.rotation + vector3(0.0, 0.0, -0.1)
                        limitZ = limitZ - 0.1
                    end
                end
                if IsControlPressed(0, 172) then
                    if limitX < 15.0 then
                        camData.rotation = camData.rotation + vector3(0.1, 0.0, 0.0)
                        limitX = limitX + 0.1
                    end
                end
                if IsControlPressed(0, 173) then
                    if limitX > -15.0 then
                        camData.rotation = camData.rotation + vector3(-0.1, 0.0, 0.0)
                        limitX = limitX - 0.1
                    end
                end
                SetCamRot(cam, camData.rotation.x, camData.rotation.y, camData.rotation.z, 2)
                if IsControlJustPressed(0, 202) then
                    DestroyCam(cam, 0)
                    RenderScriptCams(0, 0, 1, 1, 1)
                    ClearTimecycleModifier("scanline_cam_cheap")
                    SetFocusEntity(ped)

                    cam = nil
                end
            end
            SetVisibility(true)
        end)
    end
    return cam
end
