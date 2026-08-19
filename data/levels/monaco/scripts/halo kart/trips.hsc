(global boolean var_trip false)

(script static boolean player_trip
	(set var_random false)
	(set var_trip_cooldown 2000)
	(set var_trip_chance 0)
	(begin_random
		(if (not var_random) (begin (blue_shell) (set var_random true)))
		(if (not var_random) (begin (zap) (set var_random true)))
	)
false
)

(script static boolean blue_shell
	(object_create shell)
	(objects_attach kart14 "shell point" shell "")
	(scenery_animation_start shell "kart\scenery\blue shell\blue shell" "oof")
	(sleep 12)
	(sound_impulse_start "kart\sounds\blue" shell 1)
	(sleep 59)
	(effect_new_on_object_marker "kart\scenery\blue shell\effects\explosion" kart14 "shell point")
	(object_destroy shell)
	
	(sleep 55)
	(unit_exit_vehicle var_johnson) ;; Kick him out while mid air
false
)

(script static boolean zap
	(effect_new_on_object_marker "kart\scenery\zap\effects\zap" kart14 "shell point")
	(player_enable_input false)
	(object_set_scale kart14 0.5 5)
	(object_set_scale var_johnson 0.5 5)
	(object_set_scale (player0) 0.5 5)
	(object_set_scale (player1) 0.5 5)
	(sleep 150)
	(player_enable_input true)
	(object_set_scale kart14 1.0 25)
	(object_set_scale var_johnson 1.0 25)
	(object_set_scale (player0) 1.0 25)
	(object_set_scale (player1) 1.0 25)
false
)

(script continuous trip_main
	(sleep_until var_trip 20)
	(player_trip)
	(set var_trip false)
)