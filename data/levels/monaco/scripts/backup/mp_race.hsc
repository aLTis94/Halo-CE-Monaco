
(global short respawn_time 300)
(global unit car0_driver none)
(global unit car1_driver none)
(global unit car2_driver none)
(global unit car3_driver none)

(script startup mp_race_start
	(sleep 30)
	(if (or (= (game_is_authoritative) false) (= is_race false)) 
		(begin
			(sleep_forever car0_stuff)
			(sleep_forever car1_stuff)
			(sleep_forever car2_stuff)
			(sleep_forever car3_stuff)
			(sleep_forever)
		)
	)
	(print "mp race player count")
	(inspect (list_count (players)))
	
	(object_create_anew car0)
	(vehicle_load_magic car0 "" (player0))
	(object_teleport car0 spawn0)
	
	(sleep_until (> (list_count (players)) 1) 1)
	(object_create_anew car1)
	(vehicle_load_magic car1 "" (player1))
	(object_teleport car1 spawn1)
	
	(sleep_until (> (list_count (players)) 2) 1)
	(object_create_anew car2)
	(vehicle_load_magic car2 "" (player2))
	(object_teleport car2 spawn2)
	
	(sleep_until (> (list_count (players)) 3) 1)
	(object_create_anew car3)
	(vehicle_load_magic car3 "" (player3))
	(object_teleport car3 spawn3)
)

(script continuous car0_stuff
	(sleep 30)
	(if (!= (vehicle_driver car0) none)
		(set car0_driver (vehicle_driver car0))
		(if (!= car0_driver none)
			(begin
				(sleep respawn_time)
				(if (= (vehicle_driver car0) none)
					(begin
						(print "respawning car0")
						(object_create_anew car0)
						(if (> (unit_get_health car0_driver) 0) (vehicle_load_magic car0 "" car0_driver) (set car0_driver none))
					)
				)
			)
		)
	)
)

(script continuous car1_stuff
	(sleep 30)
	(if (!= (vehicle_driver car1) none)
		(set car1_driver (vehicle_driver car1))
		(if (!= car1_driver none)
			(begin
				(sleep respawn_time)
				(if (= (vehicle_driver car1) none)
					(begin
						(print "respawning car1")
						(object_create_anew car1)
						(if (> (unit_get_health car1_driver) 0) (vehicle_load_magic car1 "" car1_driver) (set car1_driver none))
					)
				)
			)
		)
	)
)

(script continuous car2_stuff
	(sleep 30)
	(if (!= (vehicle_driver car2) none)
		(set car2_driver (vehicle_driver car2))
		(if (!= car2_driver none)
			(begin
				(sleep respawn_time)
				(if (= (vehicle_driver car2) none)
					(begin
						(print "respawning car2")
						(object_create_anew car2)
						(if (> (unit_get_health car2_driver) 0) (vehicle_load_magic car2 "" car2_driver) (set car2_driver none))
					)
				)
			)
		)
	)
)

(script continuous car3_stuff
	(sleep 30)
	(if (!= (vehicle_driver car3) none)
		(set car3_driver (vehicle_driver car3))
		(if (!= car3_driver none)
			(begin
				(sleep respawn_time)
				(if (= (vehicle_driver car3) none)
					(begin
						(print "respawning car3")
						(object_create_anew car3)
						(if (> (unit_get_health car3_driver) 0) (vehicle_load_magic car3 "" car3_driver) (set car3_driver none))
					)
				)
			)
		)
	)
)