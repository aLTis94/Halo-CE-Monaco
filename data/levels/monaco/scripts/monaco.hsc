
(global real crash_small_vel 0.04)
(global real crash_med_vel 0.06)
(global real crash_large_vel 0.08)

(global real temp 0)
(global real temp2 0)
(global real temp3 0)
(global real car0_x 10000)
(global real car0_y 10000)
(global real car0_vel 0)
(global real car1_x 10000)
(global real car1_y 10000)
(global real car1_vel 0)
(global real car2_x 10000)
(global real car2_y 10000)
(global real car2_vel 0)
(global real car3_x 10000)
(global real car3_y 10000)
(global real car3_vel 0)
(global real car4_x 10000)
(global real car4_y 10000)
(global real car4_vel 0)

(global short is_mp -1)
(global boolean is_race false)

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
				)
				(begin
					(print "is not race")
					;*(object_create_anew car0)
					(object_create_anew car1)
					(object_create_anew car2)
					(object_create_anew car3)
					(object_create_anew car4)
					(object_create_anew car5)*;
				)
			)
		)
		(begin
			(print "is sp!")
			(set is_mp 0)
			;(vehicle_load_magic car0 "" (player0))
			(vehicle_load_magic car1 "" (player1))
		)
	)
)

(script continuous speed_damage_cont
	(speed_damage car0 car0_vel car0_x car0_y)
	(speed_damage car1 car1_vel car1_x car1_y)
	(speed_damage car2 car2_vel car2_x car2_y)
	(speed_damage car3 car3_vel car3_x car3_y)
)

(script static void (speed_damage (unit car) (real vel) (real x) (real y))
	(set temp (abs_real (objects_distance_to_position car 10000 0 0)))
	(set temp2 (abs_real (objects_distance_to_position car 0 10000 0)))
	
	(set temp3 (+ (abs_real (- temp x)) (abs_real (- temp2 y))) )
	(if (and (> (abs_real (- temp3 vel)) crash_med_vel) (< (abs_real (- temp3 vel)) 3))
		(begin
			;(inspect (abs_real (- temp3 vel)))
			(damage_object "levels\monaco\effects\damage\crash_med" (vehicle_driver car))
			(if (> (abs_real (- temp3 vel)) crash_large_vel)
				(begin
					;(inspect (abs_real (- temp3 vel)))
					(damage_object "levels\monaco\effects\damage\crash_large" (vehicle_driver car))
	))))
	
	(if (= car car0) (begin
		(set car0_x temp)
		(set car0_y temp2)
		(set car0_vel temp3)))
	(if (= car car1) (begin
		(set car1_x temp)
		(set car1_y temp2)
		(set car1_vel temp3)))
	(if (= car car2) (begin
		(set car2_x temp)
		(set car2_y temp2)
		(set car2_vel temp3)))
	(if (= car car3) (begin
		(set car3_x temp)
		(set car3_y temp2)
		(set car3_vel temp3)))
)

(script continuous pitstop_cont
	(pitstop car0 car0_vel)
	(pitstop car1 car1_vel)
	(pitstop car2 car2_vel)
	(pitstop car3 car3_vel)
	(pitstop car4 car4_vel)
)

(script static void (pitstop (unit car) (real vel))
	(if (and (< vel 0.01)(or (volume_test_objects pitstop1 car) (volume_test_objects pitstop2 car)) (< (unit_get_health (vehicle_driver car)) 1))
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
	(if (> (unit_get_health (vehicle_driver car2)) 0.33)
		(object_set_shield car2 0)
		(object_set_shield car2 1.0)
	)
	(if (> (unit_get_health (vehicle_driver car3)) 0.33)
		(object_set_shield car3 0)
		(object_set_shield car3 1.0)
	)
)