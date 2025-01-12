
TargetedEntity = nil

local TargetedName = nil
local TargetedTime = 0
local TargetedDist = Vector(0,0,0)

ValidTargetEnts = { "prop_physics", "sent_oxygen", "sent_fuel_diesel", "sent_fuel_gas", "sent_propane_tank", "sent_propane_canister", "sent_barrel_radioactive", "sent_barrel_biohazard" }

function GM:GetEntityID( ent )
	
	if table.HasValue( ValidTargetEnts, ent:GetClass() ) then
	
		local tbl = item.GetByClass( ent:GetClass() )
		
		if tbl then
	
			TargetedName = translate.Get( tbl.Name )
			TargetedEntity = ent
			TargetedDist = Vector( 0, 0, TargetedEntity:OBBCenter():Distance( TargetedEntity:OBBMaxs() ) )
		
		else
		
			tbl = item.GetByModel( ent:GetModel() )
			
			if tbl then
			
				TargetedName = translate.Get( tbl.Name )
				TargetedEntity = ent
				TargetedDist = Vector( 0, 0, TargetedEntity:OBBCenter():Distance( TargetedEntity:OBBMaxs() ) )
			
			end
		
		end
		
	elseif ent:GetClass() == "sent_droppedgun" then
	
		local tbl = item.GetByModel( ent:GetModel() )
		
		if tbl then
	
			TargetedName = translate.Get( tbl.Name )
			TargetedEntity = ent
			TargetedDist = Vector( 0, 0, 10 )
		
		end
	
	elseif ent:GetClass() == "sent_lootbag" then
	
		TargetedName = translate.Get( "rd_items_loot_name" )
		TargetedEntity = ent
		TargetedDist = Vector( 0, 0, 10 )
		
	elseif ent:GetClass() == "sent_cash" then
	
		TargetedName = translate.Format( "rd_items_money_x_bones", ent:GetNWInt( "Cash", 10 ) )
		TargetedEntity = ent
		TargetedDist = Vector( 0, 0, 5 )
	
	elseif ent:GetClass() == "sent_antidote" then
	
		TargetedName = translate.Get( "rd_items_antidote_crate_name" )
		TargetedEntity = ent
		TargetedDist = Vector( 0, 0, 15 )
		
	elseif ent:GetClass() == "sent_supplycrate" then
	
		TargetedName = translate.Get( "rd_items_supply_crate_name" )
		TargetedEntity = ent
		TargetedDist = Vector( 0, 0, 15 )
		
	elseif ent:GetClass() == "sent_bonuscrate" then
	
		TargetedName = translate.Get( "rd_items_weapon_cache_name" )
		TargetedEntity = ent
		TargetedDist = Vector( 0, 0, 25 )
		
	elseif ent:GetClass() == "npc_scientist" then
	
		TargetedName = translate.Get( "rd_items_field_researcher_name" )
		TargetedEntity = ent
		TargetedDist = Vector( 0, 0, 40 )
	
	elseif ent:IsPlayer() and ent:Team() == TEAM_ARMY then
	
		TargetedName = ent:Name()
		TargetedEntity = ent
		TargetedDist = Vector( 0, 0, 35 )
	
	end
	
	if IsValid( TargetedEntity ) then
	
		TargetedTime = CurTime() + 5
	
	end
	
end

function GM:HUDTraces()

	local tr = util.TraceLine( util.GetPlayerTrace( LocalPlayer() ) )
	
	GAMEMODE.LastTraceEnt = tr.Entity

	if IsValid( GAMEMODE.LastTraceEnt ) and GAMEMODE.LastTraceEnt:GetPos():Distance( LocalPlayer():GetPos() ) < 800 then
	
		GAMEMODE:GetEntityID( GAMEMODE.LastTraceEnt )
		
	end
	
end

function GM:HUDDrawTargetID()

	if not IsValid( LocalPlayer() ) then return end
	
	if not LocalPlayer():Alive() or LocalPlayer():Team() == TEAM_ZOMBIES then return end
	
	if IsValid( TargetedEntity ) and TargetedTime > CurTime() then
	
		local worldpos = TargetedEntity:LocalToWorld( TargetedEntity:OBBCenter() ) + TargetedDist
		local pos = ( worldpos ):ToScreen()
		
		//print( TargetedName .. " " .. tostring(TargetedDist) .. tostring(pos.visible) .. " - " .. pos.x .. " n " .. pos.y )
		
		if pos.visible then
			
			draw.SimpleText( TargetedName or "Error", "AmmoFontSmall", pos.x, pos.y, Color( 80, 150, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
			
		end
	
	end

end
