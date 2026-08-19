(script static boolean (init_racer (short INDEX))
	(ai_place_tracked (array_get_ai INDEX))
	(vehicle_load_magic (array_get_kart INDEX) "" (ai_actors (array_get_ai INDEX)))
	(recording_play (vehicle_driver (array_get_kart INDEX)) nothing)
	(unit_set_enterable_by_player (array_get_kart INDEX) false)
	(ai_braindead (array_get_ai INDEX) true)
	(ai_force_active (array_get_ai INDEX) true)
false
)

(script dormant init_race
	(object_create_containing kart)

	(unit_enter_vehicle (player0) kart14 "WS-Driver")
	(if (game_is_cooperative) (unit_enter_vehicle (player1) kart14 "WS-Passenger"))
	(player_enable_input false)
	(wake johnson_init)

	(init_racer 0)
	(init_racer 1)
	(init_racer 2)
	(init_racer 3)
	(init_racer 4)
	(init_racer 5)
	(init_racer 6)
	(init_racer 7)
	(init_racer 8)
	(init_racer 9)
	(init_racer 10)
	(init_racer 11)
	(init_racer 12)
	(init_racer 13)
)

(script dormant start_race
	;; Set vehicle volume a little lower because RRRRRRRRRRRRRRRRR
	(sound_class_set_gain "vehicle_collision" 0.8 1)
	(sound_class_set_gain "vehicle_engine" 0.725 1)

	;; Guilty spark comes out and does countdown here
	(object_create spark)
	(object_teleport spark spark_start)
	(recording_play spark spark_countdown)
	(sleep 120)
	(effect_new_on_object_marker "kart\effects\countdown" spark "glow eye")

	(sleep 80)
	(set go true)
	(music const_music 0)

	(recording_kill (vehicle_driver kart02)) (sleep 3)
	(recording_kill (vehicle_driver kart01)) (sleep 2)
	(recording_kill (vehicle_driver kart00)) (sleep 3)
	(recording_kill (vehicle_driver kart03)) (sleep 1)
	(recording_kill (vehicle_driver kart04)) (sleep 3)
	(recording_kill (vehicle_driver kart08)) (sleep 3)
	(recording_kill (vehicle_driver kart06)) (sleep 2)
	(recording_kill (vehicle_driver kart07)) (sleep 3)
	(recording_kill (vehicle_driver kart05)) (sleep 3)
	(recording_kill (vehicle_driver kart09)) (sleep 1)
	(recording_kill (vehicle_driver kart12)) (sleep 3)
	(recording_kill (vehicle_driver kart13)) (sleep 1)
	(recording_kill (vehicle_driver kart10)) (sleep 3)
	(recording_kill (vehicle_driver kart11)) (sleep 2)
	(ai_braindead (array_get_ai 0) false)
	(ai_braindead (array_get_ai 1) false)
	(ai_braindead (array_get_ai 2) false)
	(ai_braindead (array_get_ai 3) false)
	(ai_braindead (array_get_ai 4) false)
	(ai_braindead (array_get_ai 5) false)
	(ai_braindead (array_get_ai 6) false)
	(ai_braindead (array_get_ai 7) false)
	(ai_braindead (array_get_ai 8) false)
	(ai_braindead (array_get_ai 9) false)
	(ai_braindead (array_get_ai 10) false)
	(ai_braindead (array_get_ai 11) false)
	(ai_braindead (array_get_ai 12) false)
	(ai_braindead (array_get_ai 13) false)

	(ai_try_to_fight_player (array_get_ai 11)) ;; Rocket flood targets player

	(sleep 3)
	(player_enable_input true)

	(sleep 90)
	(object_destroy spark)
)

(script startup init
	(cs)
	(sleep 5)
	(game_save_totally_unsafe)
	(sleep 5)

	(wake init_race)
	(wake intro)

	(sleep 190)
	(wake start_race)
)