
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
	(sleep_forever pitstop_cont)
	(sleep_forever respawn_vehicles)
	;(sleep_forever engine_light)
)

(script startup setup
	;(if (not (game_is_authoritative)) (sleep_forever))
	(if  (game_is_authoritative) (begin (object_create_containing boat) (object_create safety_car)))
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
					(object_create_anew_containing goose)
					(object_create_anew_containing car)
				)
			)
		)
		(begin
			(print "is sp!")
			(set is_mp 0)
			;(vehicle_load_magic car0 "" (player0))
			(vehicle_load_magic car1 "" (player1))
			(if (!= (player0) none) (object_teleport car0 spawn0))
			(if (!= (player1) none) (object_teleport car1 spawn1))
			(object_destroy_containing "mp")
		)
	)
	
	(sleep 60)
	(set damage_enabled true)
)

(script startup mp_race
;what if I do this: player spawns are next to the start line but once the race starts, they all get blocked by a
;large vehicle. then the players spawn in the pitstops where the cars respawn

;what if I use trig volumes to check who spawns where and then teleport them based on that
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
			(object_teleport (player0) tele0)
			(if (!= (player1) none) (object_teleport car1 spawn1))
			(object_teleport (player1) tele1)
			(if (!= (player2) none) (object_teleport car2 spawn2))
			(object_teleport (player2) tele2)
			(if (!= (player3) none) (object_teleport car3 spawn3))
			(object_teleport (player3) tele3)
			(if (!= (player4) none) (object_teleport car4 spawn4))
			(object_teleport (player4) tele4)
			(if (!= (player5) none) (object_teleport car5 spawn5))
			(object_teleport (player5) tele5)
			
			(wake disable_controls)
			(disable_cars)
		)
	)
	(sleep_until (= (game_time_authoritative) (+ teleport_timer race_countdown_timer)) 1)
	(print "3 2 1")
	(sound_impulse_start "levels\monaco\sound\race_start" none 1)
	
	(object_create red_light5)
	(sleep 30)
	(object_create red_light4)
	(sleep 30)
	(object_create red_light3)
	(sleep 30)
	(object_create red_light2)
	(sleep 30)
	(object_create red_light1)
	
	(sleep (- race_countdown 120))
	(print "gooo")
	(sleep_forever disable_controls)
	(player_enable_input true)
	(object_destroy_containing red_light)
	(enable_cars)
	(recording_kill (unit (list_get (local_players) 0)))
)

(script static void disable_cars
	(recording_play car0 nothing2)
	(recording_play car1 nothing2)
	(recording_play car2 nothing2)
	(recording_play car3 nothing2)
	(recording_play car4 nothing2)
	(recording_play car5 nothing2)
)

(script static void enable_cars
	(recording_kill car0)
	(recording_kill car1)
	(recording_kill car2)
	(recording_kill car3)
	(recording_kill car4)
	(recording_kill car5)
)

;This script should only run for each client separately
(script dormant disable_controls
	(units_set_desired_flashlight_state (players) true)
	(sleep_until (not (unit_get_current_flashlight_state (unit (list_get (local_players) 0)))) 1)
	(print "in car")
	(if (game_is_authoritative)
		(recording_play (unit (list_get (local_players) 0)) nothing2)
		(player_enable_input false) ;I should not run this on splitscreen!
	)
	(sleep (+ race_countdown teleport_timer race_countdown_timer))
	(player_enable_input true)
)

(script static void test_lights
	(sleep 150)
	(sound_impulse_start "levels\monaco\sound\race_start" none 1)
	
	(object_create red_light5)
	(sleep 30)
	(object_create red_light4)
	(sleep 30)
	(object_create red_light3)
	(sleep 30)
	(object_create red_light2)
	(sleep 30)
	(object_create red_light1)
	
	(sleep (- race_countdown 120))
	(object_destroy_containing red_light)
)

(script continuous respawn_vehicles
	(if (volume_test_objects script_room car0) (object_teleport car0 car_pit0))
	(if (volume_test_objects script_room car1) (object_teleport car1 car_pit1))
	(if (volume_test_objects script_room car2) (object_teleport car2 car_pit2))
	(if (volume_test_objects script_room car3) (object_teleport car3 car_pit3))
	(if (volume_test_objects script_room car4) (object_teleport car4 car_pit4))
	(if (volume_test_objects script_room car5) (object_teleport car5 car_pit5))
	(sleep 5)
)

(script continuous respawn_boats
	(if (volume_test_objects script_room boat0) (object_teleport boat0 boat_spawn0))
	(if (volume_test_objects script_room boat1) (object_teleport boat1 boat_spawn1))
	(if (volume_test_objects script_room boat2) (object_teleport boat2 boat_spawn2))
	(if (volume_test_objects script_room boat3) (object_teleport boat3 boat_spawn3))
	(if (volume_test_objects script_room boat4) (object_teleport boat4 boat_spawn4))
	(if (volume_test_objects script_room boat5) (object_teleport boat5 boat_spawn5))
	(if (volume_test_objects script_room boat6) (object_teleport boat6 boat_spawn6))
	(if (volume_test_objects script_room boat7) (object_teleport boat7 boat_spawn7))
	(if (volume_test_objects script_room boat8) (object_teleport boat8 boat_spawn8))
	(if (volume_test_objects script_room boat9) (object_teleport boat9 boat_spawn9))
	(if (volume_test_objects script_room boat10) (object_teleport boat10 boat_spawn10))
	(if (volume_test_objects script_room boat11) (object_teleport boat11 boat_spawn11))
	(if (volume_test_objects script_room boat12) (object_teleport boat12 boat_spawn12))
	(if (volume_test_objects script_room safety_car) (object_teleport safety_car safety_car_spawn))
	
	(if (volume_test_objects script_room goose0) (object_teleport goose0 goose_spawn0))
	(if (volume_test_objects script_room goose1) (object_teleport goose1 goose_spawn1))
	(if (volume_test_objects script_room goose2) (object_teleport goose2 goose_spawn2))
	;(object_teleport boat5 boat_spawn5)
	;(object_teleport boat6 boat_spawn6)
	;(object_teleport boat7 boat_spawn7)
	;(sleep 90)
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
)*;


;(script continuous testingggg
;	(if (< (unit_get_shield car0) 1) (inspect (unit_get_shield car0)) )
;)