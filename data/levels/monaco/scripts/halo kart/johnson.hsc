;; If you are in single player you get johnson as your 'buddy'. In co-op the second player takes his place

(global boolean var_johnson_upgrade false)
(global short var_johnson_level 0)
(global unit var_johnson none)

(script static boolean johnson_upgrade
	(if (and (not (game_is_cooperative)) (< var_johnson_level 4) (vehicle_test_seat kart14 "WS-Passenger" (unit (list_get (ai_actors johnson) 0)))) (begin
		(set var_johnson_level (+ var_johnson_level 1))
		(ai_erase johnson)

		(sleep 1) ;; Not ideal but nesscary to make this work
		(if (= var_johnson_level 0) (ai_place_tracked johnson/level00))
		(if (= var_johnson_level 1) (ai_place_tracked johnson/level01))
		(if (= var_johnson_level 2) (ai_place_tracked johnson/level02))
		(if (= var_johnson_level 3) (ai_place_tracked johnson/level03))
		(if (= var_johnson_level 4) (ai_place_tracked johnson/level04))

		(set var_johnson (unit (list_get (ai_actors johnson) 0)))
		(vehicle_load_magic kart14 "WS-Passenger" (ai_actors johnson))
	))
false
)

;; Johnsons script run in a seperate loop from most others due to it having a (sleep 1) call in it
(script continuous johnson_main
	(sleep_until (not (game_is_cooperative)) 3)

	(if (not (vehicle_test_seat kart14 "WS-Passenger" var_johnson)) (begin
		(ai_go_to_vehicle_override johnson kart14 "WS-Passenger")

		(if (and (> (ai_going_to_vehicle kart14) 0) (vehicle_test_seat kart14 "WS-Driver" (player0)))
			(if (<= (objects_distance_to_object var_johnson kart14) 1.25) (begin
				(unit_enter_vehicle var_johnson kart14 "WS-Passenger")
				(print "+JO")
			))
		)
	))
	(if var_johnson_upgrade (begin (johnson_upgrade) (set var_johnson_upgrade false)))
)

(script dormant johnson_init
	(if (not (game_is_cooperative)) (begin
		(ai_place_tracked johnson/level00)
		(set var_johnson (unit (list_get (ai_actors johnson) 0)))
		(vehicle_load_magic kart14 "WS-Passenger" var_johnson)
		(ai_braindead johnson true)
		(ai_force_active johnson true)

		(sleep_until go 10)
		(ai_braindead johnson false)
	))
)