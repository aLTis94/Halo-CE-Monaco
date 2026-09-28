
(global short teleport_timer 100)
(global short race_countdown_timer 180)
(global short race_countdown 170)

(global real crash_med_vel 0.0285)
(global real crash_large_vel 0.06)

(global real temp 0)
(global real car0_vel 0)
(global real car1_vel 0)
(global real car2_vel 0)
(global real car3_vel 0)
(global real car4_vel 0)
(global real car5_vel 0)

(global short is_mp -1)
(global boolean is_race false)

(global boolean damage_enabled false)

(script startup client_script_killer
	(if (game_is_authoritative) (sleep_forever))
	;(sleep_forever setup)
	;(sleep_forever mp_race)
	(sleep_forever speed_damage_cont)
	(sleep_forever pitstop_cont)
	(sleep_forever respawn_vehicles)
	;(sleep_forever engine_light)
)

(script startup setup
	;(if (not (game_is_authoritative)) (sleep_forever))
	(if  (game_is_authoritative) (object_create_containing boat))
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
					;(mp_race)
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

(script startup mp_race
;what if I do this: player spawns are next to the start line but once the race starts, they all get blocked by a
;large vehicle. then the players spawn in the pitstops where the cars respawn
	(sleep_until (> (game_time_authoritative) 30) 1)
	(if (not is_race) (sleep_forever))
	(if (game_is_authoritative) (object_create_containing car))
	;(sleep_forever) ;uncomment for testing
	(player_enable_input false)
	
	(sleep_until (>= (game_time_authoritative) teleport_timer) 1)
	(player_enable_input true)
	(if (= (game_time_authoritative) teleport_timer)
		(begin
			;(sound_impulse_start "levels\monaco\sound\let_the_race_begin" none 1)
			(sound_impulse_start "levels\monaco\sound\gentlemen_start_your_engines" none 1)
			(if (!= (player0) none) (object_teleport car0 spawn0))
			;(objects_attach car0 "" (player0) "")
			;(objects_detach car0 (player0))
			(object_teleport (player0) tele0)
			(if (!= (player1) none) (object_teleport car1 spawn1))
			(object_teleport (player1) tele1)
			(if (!= (player2) none) (object_teleport car2 spawn2))
			(if (!= (player3) none) (object_teleport car3 spawn3))
			
			(wake disable_controls)
		)
	)
	(sleep_until (= (game_time_authoritative) (+ teleport_timer race_countdown_timer)) 1)
	(print "3 2 1")
	(sound_impulse_start "levels\monaco\sound\race_start" none 1)
	
	(sleep race_countdown)
	(print "gooo")
	(player_enable_input true)
)

;This script should only run for each client separately
(script dormant disable_controls
	(units_set_desired_flashlight_state (players) true)
	(sleep_until (not (unit_get_current_flashlight_state (unit (list_get (local_players) 0)))) 1)
	(print "in car")
	(player_enable_input false) ;I should not run this on splitscreen!
	(sleep (+ race_countdown teleport_timer race_countdown_timer))
	(player_enable_input true)
)

(script continuous respawn_vehicles
	(if (volume_test_objects script_room car0) (object_teleport car0 car_pit0))
	(if (volume_test_objects script_room car1) (object_teleport car1 car_pit1))
	(if (volume_test_objects script_room car2) (object_teleport car2 car_pit2))
	(if (volume_test_objects script_room car3) (object_teleport car3 car_pit3))
	(sleep 5)
)

(script continuous respawn_boats
	(if (volume_test_objects script_room boat0) (object_teleport boat0 boat_spawn0))
	(if (volume_test_objects script_room boat1) (object_teleport boat0 boat_spawn1))
	(if (volume_test_objects script_room boat2) (object_teleport boat0 boat_spawn2))
	(if (volume_test_objects script_room boat3) (object_teleport boat0 boat_spawn3))
	(if (volume_test_objects script_room boat4) (object_teleport boat0 boat_spawn4))
	(if (volume_test_objects script_room boat5) (object_teleport boat0 boat_spawn5))
	(if (volume_test_objects script_room boat6) (object_teleport boat0 boat_spawn6))
	(if (volume_test_objects script_room boat7) (object_teleport boat0 boat_spawn7))
	(object_teleport boat5 boat_spawn5)
	(object_teleport boat6 boat_spawn6)
	(object_teleport boat7 boat_spawn7)
	(sleep 90)
)

(script continuous speed_damage_cont
	(speed_damage car0 car0_vel dummy0)
	(speed_damage car1 car1_vel dummy1)
	(speed_damage car2 car2_vel dummy2)
	(speed_damage car3 car3_vel dummy3)
	(speed_damage car4 car4_vel dummy4)
	(speed_damage car5 car5_vel dummy5)
)

(script static void (speed_damage (unit car) (real vel) (object dummy))
	(set temp (objects_distance_to_object car dummy))
	;(inspect temp)
	
	(if (and (> (abs_real (- temp vel)) crash_med_vel) damage_enabled)
		(begin
			;(inspect (abs_real (- temp vel)))
			(damage_object "levels\monaco\effects\damage\crash_med" (vehicle_driver car))
			(if (> (abs_real (- temp vel)) crash_large_vel)
				(damage_object "levels\monaco\effects\damage\crash_large" (vehicle_driver car))
	)))
	
	(cond 
		((= car car0) (set car0_vel temp))
		((= car car1) (set car1_vel temp))
		((= car car2) (set car2_vel temp))
		((= car car3) (set car3_vel temp))
		((= car car4) (set car4_vel temp))
		((= car car5) (set car5_vel temp))
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

(script continuous engine_light
	(if (> (unit_get_health (vehicle_driver car0)) 0.33)
		(object_set_shield car0 0)
		(object_set_shield car0 1.0)
	)
	(if (> (unit_get_health (vehicle_driver car1)) 0.33)
		(object_set_shield car1 0)
		(object_set_shield car1 1.0)
	)
)


;(script continuous testwe
;	(inspect (device_get_position car0_control))
;	(inspect (device_get_power car0_control))
;)

;*(script continuous controls
	(if (= (vehicle_driver car0) "none")
		(begin
			(object_create car0_control)
			(objects_attach car0 "taillights" car0_control "")
			(objects_detach car0 car0_control)
			
			(if (> (device_get_position car0_control) 0)
				(begin
					(object_create_anew car0_control)
					(object_create_anew car0_biped)
					(objects_attach car0 "" car0_biped "")
					(objects_detach car0 car0_biped)
					(sleep 1)
					(objects_attach car0_biped "head" car0 "")
					(objects_detach car0_biped car0)
					(sleep 1)
					(object_destroy car0_biped)
				)
			)
		)
		(object_destroy car0_control)
	)
	(sleep 1)
)*;