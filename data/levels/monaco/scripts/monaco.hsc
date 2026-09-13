
(global real crash_med_vel 0.0285)
(global real crash_large_vel 0.06)

(global real temp 0)
(global real temp2 0)
(global real temp3 0)
(global real car0_vel 0)
(global real car1_vel 0)
(global real car2_vel 0)
(global real car3_vel 0)
(global real car4_vel 0)

(global short is_mp -1)
(global boolean is_race false)

(global boolean damage_enabled false)

(script startup client_script_killer
	(if (game_is_authoritative) (sleep_forever))
	(sleep_forever setup)
	(sleep_forever mp_race)
	(sleep_forever speed_damage_cont)
	(sleep_forever pitstop_cont)
	(sleep_forever respawn_vehicles)
	;(sleep_forever engine_light)
)

(script startup setup
	(sleep 10)
	(if (= (objects_distance_to_position mp_check 0 0 0) -1)
		(begin
			(print "is mp!")
			(set is_mp 1)
			
			(sleep 10)
			(if (= (objects_distance_to_position race_check 0 0 0) -1)
				(begin
					(print "is race!")
					(set is_race true)
					(mp_race)
				)
				(begin
					(print "is not race")
					;*(object_create_anew car0)
					(object_create_anew car1)
					(object_create_anew car2)
					(object_create_anew car3)
					(object_create_anew car4)
					(object_create_anew car5)*;
					(sleep_forever speed_damage_cont)
				)
			)
		)
		(begin
			(print "is sp!")
			(set is_mp 0)
			(vehicle_load_magic car0 "" (player0))
			(vehicle_load_magic car1 "" (player1))
			(object_destroy_containing "mp")
		)
	)
	
	(sleep 60)
	(set damage_enabled true)
)

(script static void mp_race
	(player_enable_input false)
	(object_create_containing car)
	(sleep 90)
	(if (!= (player0) none) (object_teleport car0 spawn0))
	(vehicle_load_magic car0 "" (player0))
	(if (!= (player1) none) (object_teleport car1 spawn1))
	(vehicle_load_magic car1 "" (player1))
	(if (!= (player2) none) (object_teleport car2 spawn2))
	(vehicle_load_magic car2 "" (player2))
	(if (!= (player3) none) (object_teleport car3 spawn3))
	(vehicle_load_magic car3 "" (player3))
	(sleep 90)
	(player_enable_input true)
)

(script continuous respawn_vehicles
	(if (volume_test_objects script_room car0) (object_teleport car0 car_pit0))
	(if (volume_test_objects script_room car1) (object_teleport car1 car_pit1))
	(if (volume_test_objects script_room car2) (object_teleport car2 car_pit2))
	(if (volume_test_objects script_room car3) (object_teleport car3 car_pit3))
	(sleep 5)
)

(script continuous speed_damage_cont
	(speed_damage car0 car0_vel dummy0)
	(speed_damage car1 car1_vel dummy1)
	(speed_damage car2 car2_vel dummy2)
	(speed_damage car3 car3_vel dummy3)
)

(script static void (speed_damage (unit car) (real vel) (object dummy))
	(set temp3 (objects_distance_to_object car dummy))
	;(inspect temp3)
	
	(if (and (> (abs_real (- temp3 vel)) crash_med_vel) damage_enabled)
		(begin
			;(inspect (abs_real (- temp3 vel)))
			(damage_object "levels\monaco\effects\damage\crash_med" (vehicle_driver car))
			(if (> (abs_real (- temp3 vel)) crash_large_vel)
				(damage_object "levels\monaco\effects\damage\crash_large" (vehicle_driver car))
	)))
	
	(cond 
		((= car car0) (set car0_vel temp3))
		((= car car1) (set car1_vel temp3))
		((= car car2) (set car2_vel temp3))
		((= car car3) (set car3_vel temp3))
	)
	
	(objects_attach car "" dummy "")
	(objects_detach car dummy)
)

(script continuous pitstop_cont
	(pitstop car0 car0_vel)
	(pitstop car1 car1_vel)
	(pitstop car2 car2_vel)
	(pitstop car3 car3_vel)
	(pitstop car4 car4_vel)
	(sleep 11)
)

(script static void (pitstop (unit car) (real vel))
	(sleep 1)
	(if (and (< vel 0.12)(or (volume_test_objects pitstop1 car) (volume_test_objects pitstop2 car)) (< (unit_get_health (vehicle_driver car)) 1))
		(begin
			(damage_object "levels\monaco\effects\damage\heal" (vehicle_driver car))
		)
	)
)

;*(script continuous engine_light
	(if (> (unit_get_health (vehicle_driver car0)) 0.33)
		(object_set_shield car0 0)
		(object_set_shield car0 1.0)
	)
	(if (> (unit_get_health (vehicle_driver car1)) 0.33)
		(object_set_shield car1 0)
		(object_set_shield car1 1.0)
	)
	(if (> (unit_get_health (vehicle_driver car2)) 0.33)
		(object_set_shield car2 0)
		(object_set_shield car2 1.0)
	)
	(if (> (unit_get_health (vehicle_driver car3)) 0.33)
		(object_set_shield car3 0)
		(object_set_shield car3 1.0)
	)
)*;