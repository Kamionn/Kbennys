Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(10)
    end
    while ESX.GetPlayerData().job == nil do
		Citizen.Wait(10)
    end
    if ESX.IsPlayerLoaded() then

		ESX.PlayerData = ESX.GetPlayerData()

    end
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
	ESX.PlayerData = xPlayer
end)


RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
	ESX.PlayerData.job = job
end)


-- MENU FUNCTION --

local open = false 
local mainMenu8 = RageUI.CreateMenu('Bennys', 'Interaction')
local subMenu8 = RageUI.CreateSubMenu(mainMenu8, "Annonces", "Interaction")
local subMenu9 = RageUI.CreateSubMenu(mainMenu8, "Dépannage", "Interaction")
mainMenu8.Display.Header = true 
mainMenu8.Closed = function()
  open = false
end

function OpenMenu8()
	if open then 
		open = false
		RageUI.Visible(mainMenu8, false)
		return
	else
		open = true 
		RageUI.Visible(mainMenu8, true)
		CreateThread(function()
		while open do 
		   RageUI.IsVisible(mainMenu8,function() 

			RageUI.Button("Annonces Bennys", nil, {RightLabel = "→"}, true , {
				onSelected = function()
				end
			}, subMenu8)

			RageUI.Button("Faire une Facture", nil, {RightLabel = "→"}, true , {
				onSelected = function()
					OpenBillingMenu2()
                    RageUI.CloseAll()
				end
			})


			RageUI.Button("Interaction sur véhicule", nil, {RightLabel = "→"}, true , {
				onSelected = function()
				end
			}, subMenu9)

		end)

			RageUI.IsVisible(subMenu8,function() 

			 RageUI.Button("Annonce ~g~Ouvertures", nil, {RightLabel = "→"}, true , {
				onSelected = function()
					TriggerServerEvent('Ouvre:bennys')
				end
			})

			 RageUI.Button("Annonce ~y~Recrutement", nil, {RightLabel = "→"}, true , {
				onSelected = function()
					TriggerServerEvent('Recrutement:bennys')
				end
			})

			RageUI.Button("Annonce ~r~Fermetures", nil, {RightLabel = "→"}, true , {
				onSelected = function()
					TriggerServerEvent('Ferme:bennys')
				end
			})

		   end)

	
	   RageUI.IsVisible(subMenu9,function() 

			RageUI.Button("Réparer le véhicule", nil, {RightLabel = "→→"}, true, {
				onSelected = function()
					local playerPed = PlayerPedId()
					local vehicle   = ESX.Game.GetVehicleInDirection()
					local coords    = GetEntityCoords(playerPed)
		
					if IsPedSittingInAnyVehicle(playerPed) then
						ESX.ShowNotification('Sortez de la voiture')
						return
					end
		
					if DoesEntityExist(vehicle) then
						isBusy = true
						TaskStartScenarioInPlace(playerPed, 'PROP_HUMAN_BUM_BIN', 0, true)
						Citizen.CreateThread(function()
							Citizen.Wait(20000)
		
							SetVehicleFixed(vehicle)
							SetVehicleDeformationFixed(vehicle)
							SetVehicleUndriveable(vehicle, false)
							SetVehicleEngineOn(vehicle, true, true)
							ClearPedTasksImmediately(playerPed)
		
							ESX.ShowNotification('la voiture est réparer')
							isBusy = false
						end)
					else
						ESX.ShowNotification('Aucun véhicule à proximiter')
					end
		 
				end,}) 
				
				RageUI.Button("Nettoyer véhicule", nil, {RightLabel = "→→"}, true , {
					onSelected = function()
						local playerPed = PlayerPedId()
						local vehicle   = ESX.Game.GetVehicleInDirection()
						local coords    = GetEntityCoords(playerPed)
			
						if IsPedSittingInAnyVehicle(playerPed) then
							ESX.ShowNotification('Sortez de la voiture')
							return
						end
			
						if DoesEntityExist(vehicle) then
							isBusy = true
							TaskStartScenarioInPlace(playerPed, 'WORLD_HUMAN_MAID_CLEAN', 0, true)
							Citizen.CreateThread(function()
								Citizen.Wait(10000)
			
								SetVehicleDirtLevel(vehicle, 0)
								ClearPedTasksImmediately(playerPed)
			
								ESX.ShowNotification('Voiture nettoyée')
								isBusy = false
							end)
						else
							ESX.ShowNotification('Aucun véhicule trouvée')
						end
						end,})

								RageUI.Button("Crocheter véhicule", nil, {RightLabel = "→→"}, true , {
				onSelected = function()
						local playerPed = PlayerPedId()
						local vehicle = ESX.Game.GetVehicleInDirection()
						local coords = GetEntityCoords(playerPed)
			
						if IsPedSittingInAnyVehicle(playerPed) then
							ESX.ShowNotification('Action impossible')
							return
						end
			
						if DoesEntityExist(vehicle) then
							isBusy = true
							TaskStartScenarioInPlace(playerPed, 'WORLD_HUMAN_WELDING', 0, true)
							Citizen.CreateThread(function()
								Citizen.Wait(10000)
			
								SetVehicleDoorsLocked(vehicle, 1)
								SetVehicleDoorsLockedForAllPlayers(vehicle, false)
								ClearPedTasksImmediately(playerPed)
			
								ESX.ShowNotification('Véhicule déverrouillé')
								isBusy = false
							end)
						else
							ESX.ShowNotification('Aucune voiture autour')
						end
				end,})
						
				   RageUI.Button("Mettre véhicule en fourriere", nil, {RightLabel = "→→"}, true , {
					onSelected = function()
						local playerPed = PlayerPedId()

						if IsPedSittingInAnyVehicle(playerPed) then
							local vehicle = GetVehiclePedIsIn(playerPed, false)
			
							if GetPedInVehicleSeat(vehicle, -1) == playerPed then
								ESX.ShowNotification('la voiture a été mis en fourrière')
								ESX.Game.DeleteVehicle(vehicle)
							   
							else
								ESX.ShowNotification('Sortez de la voiture')
							end
						else
							local vehicle = ESX.Game.GetVehicleInDirection()
			
							if DoesEntityExist(vehicle) then
								ESX.ShowNotification('La voiture à été placer en fourrière')
								ESX.Game.DeleteVehicle(vehicle)
			
							else
								ESX.ShowNotification('Aucune voiture autour')
							end
						end
				end,})

				
				RageUI.Button("Placer sur la remorque", nil, {RightLabel = "→→"}, true , {
                    onSelected = function()
				local playerPed = PlayerPedId()
				local vehicle = GetVehiclePedIsIn(playerPed, true)
	
				local towmodel = GetHashKey('flatbed')
				local isVehicleTow = IsVehicleModel(vehicle, towmodel)
	
				if isVehicleTow then
					local targetVehicle = ESX.Game.GetVehicleInDirection()
	
					if CurrentlyTowedVehicle == nil then
						if targetVehicle ~= 0 then
							if not IsPedInAnyVehicle(playerPed, true) then
								if vehicle ~= targetVehicle then
									AttachEntityToEntity(targetVehicle, vehicle, 20, -0.5, -5.0, 1.0, 0.0, 0.0, 0.0, false, false, false, false, 20, true)
									CurrentlyTowedVehicle = targetVehicle
									ESX.ShowNotification(_U('vehicle_success_attached'))
	
									if NPCOnJob then
										if NPCTargetTowable == targetVehicle then
											ESX.ShowNotification(_U('please_drop_off'))
											Config.Zones.VehicleDelivery.Type = 1
	
											if Blips['NPCTargetTowableZone'] then
												RemoveBlip(Blips['NPCTargetTowableZone'])
												Blips['NPCTargetTowableZone'] = nil
											end
	
											Blips['NPCDelivery'] = AddBlipForCoord(Config.Zones.VehicleDelivery.Pos.x, Config.Zones.VehicleDelivery.Pos.y, Config.Zones.VehicleDelivery.Pos.z)
											SetBlipRoute(Blips['NPCDelivery'], true)
										end
									end
								else
									ESX.ShowNotification(_U('cant_attach_own_tt'))
								end
							end
						else
							ESX.ShowNotification(_U('no_veh_att'))
						end
					else
						AttachEntityToEntity(CurrentlyTowedVehicle, vehicle, 20, -0.5, -12.0, 1.0, 0.0, 0.0, 0.0, false, false, false, false, 20, true)
						DetachEntity(CurrentlyTowedVehicle, true, true)

						if NPCOnJob then
							if NPCTargetDeleterZone then
	
								if CurrentlyTowedVehicle == NPCTargetTowable then
									ESX.Game.DeleteVehicle(NPCTargetTowable)
									TriggerServerEvent('esx_bennysjob:onNPCJobMissionCompleted')
									StopNPCJob()
									NPCTargetDeleterZone = false
								else
									ESX.ShowNotification(_U('not_right_veh'))
								end
	
							else
								ESX.ShowNotification(_U('not_right_place'))
							end
						end
	
						CurrentlyTowedVehicle = nil
						ESX.ShowNotification(_U('veh_det_succ'))
					end
				else
					ESX.ShowNotification(_U('imp_flatbed'))
	

                end
            end,})
				end)
			Wait(0)
		end
	 end)
  end
end



-- FUNCTION BILLING --

function OpenBillingMenu2()

	ESX.UI.Menu.Open(
	  'dialog', GetCurrentResourceName(), 'billing',
	  {
		title = "Facture"
	  },
	  function(data, menu)
	  
		local amount = tonumber(data.value)
		local player, distance = ESX.Game.GetClosestPlayer()
  
		if player ~= -1 and distance <= 3.0 then
  
		  menu.close()
		  if amount == nil then
			  ESX.ShowNotification("~r~Problèmes~s~: Montant invalide")
		  else
			local playerPed        = GetPlayerPed(-1)
			TaskStartScenarioInPlace(playerPed, 'CODE_HUMAN_MEDIC_TIME_OF_DEATH', 0, true)
			Citizen.Wait(5000)
			  TriggerServerEvent('esx_billing:sendBill1', GetPlayerServerId(player), 'society_bennys', ('bennys'), amount)
			  Citizen.Wait(100)
			  ESX.ShowNotification("~r~Vous avez bien envoyer la facture")
		  end
  
		else
		  ESX.ShowNotification("~r~Problèmes~s~ : Personne autour !")
		end
  
	  end,
	  function(data, menu)
		  menu.close()
	  end
	)
  end

-- OUVERTURE DU MENU --

Keys.Register('F6', 'bennys', 'Ouvrir le menu bennys', function()
	if ESX.PlayerData.job and ESX.PlayerData.job.name == 'bennys' then
    	OpenMenu8()
	end
end)

-- Remorque

RageUI.Button("Placer sur le flatbed", nil, {RightLabel = "→→"}, true , {
	onSelected = function()
local playerPed = PlayerPedId()
local vehicle = GetVehiclePedIsIn(playerPed, true)

local towmodel = GetHashKey('flatbed')
local isVehicleTow = IsVehicleModel(vehicle, towmodel)

if isVehicleTow then
	local targetVehicle = ESX.Game.GetVehicleInDirection()

	if CurrentlyTowedVehicle == nil then
		if targetVehicle ~= 0 then
			if not IsPedInAnyVehicle(playerPed, true) then
				if vehicle ~= targetVehicle then
					AttachEntityToEntity(targetVehicle, vehicle, 20, -0.5, -5.0, 1.0, 0.0, 0.0, 0.0, false, false, false, false, 20, true)
					CurrentlyTowedVehicle = targetVehicle
					ESX.ShowNotification(_U('vehicle_success_attached'))

					if NPCOnJob then
						if NPCTargetTowable == targetVehicle then
							ESX.ShowNotification(_U('please_drop_off'))
							Config.Zones.VehicleDelivery.Type = 1

							if Blips['NPCTargetTowableZone'] then
								RemoveBlip(Blips['NPCTargetTowableZone'])
								Blips['NPCTargetTowableZone'] = nil
							end

							Blips['NPCDelivery'] = AddBlipForCoord(Config.Zones.VehicleDelivery.Pos.x, Config.Zones.VehicleDelivery.Pos.y, Config.Zones.VehicleDelivery.Pos.z)
							SetBlipRoute(Blips['NPCDelivery'], true)
						end
					end
				else
					ESX.ShowNotification(_U('cant_attach_own_tt'))
				end
			end
		else
			ESX.ShowNotification(_U('no_veh_att'))
		end
	else
		AttachEntityToEntity(CurrentlyTowedVehicle, vehicle, 20, -0.5, -12.0, 1.0, 0.0, 0.0, 0.0, false, false, false, false, 20, true)
		DetachEntity(CurrentlyTowedVehicle, true, true)

		if NPCOnJob then
			if NPCTargetDeleterZone then

				if CurrentlyTowedVehicle == NPCTargetTowable then
					ESX.Game.DeleteVehicle(NPCTargetTowable)
					TriggerServerEvent('esx_bennysjob:onNPCJobMissionCompleted')
					StopNPCJob()
					NPCTargetDeleterZone = false
				else
					ESX.ShowNotification(_U('not_right_veh'))
				end

			else
				ESX.ShowNotification(_U('not_right_place'))
			end
		end

		CurrentlyTowedVehicle = nil
		ESX.ShowNotification(_U('veh_det_succ'))
	end
else
	ESX.ShowNotification(_U('imp_flatbed'))
end
end,})

