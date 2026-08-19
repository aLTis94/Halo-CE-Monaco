
(global short modulo_tmp 0)
(global boolean finished false)
(global unit winner_player none)
(global cutscene_flag player0_last_checkpoint a8)
(global cutscene_flag player1_last_checkpoint a8)
(global long timer_minutes 0)
(global long timer_seconds 0)
(global long race_start_minutes 0)
(global long race_start_seconds 0)
(global long race_start_time 0)
(global long race_finish_time 0)
(global long best_lap_time 10000000)

(script startup setup_checkpoints
	(sleep_forever checkpoints_a_player0)
	(sleep_forever checkpoints_a_player1)
	(sleep_forever timer)
	(sleep_forever real_timer)
	(sleep 30)
	(if (= is_mp 0)
		(begin
			(wake checkpoints_a_player0)
			(wake checkpoints_a_player1)
			(wake timer)
			(wake real_timer)
		)
	)
)

(script continuous checkpoints_a_player0
	(print "should start the A...")
	(checkpoints_a 0)
)

(script continuous checkpoints_a_player1
	(if (= (game_is_cooperative) false) (sleep_forever))
	(print "should start the A... FOR COOP!!!!!!")
	(checkpoints_a 1)
)

(script static void (checkpoint (cutscene_flag checkpoint_flag) (short id) (boolean finish_line))
	(activate_nav_point_flag "flag_blue" (unit (list_get (players) id)) checkpoint_flag 0)
	(sleep_until (or finished (and (> (unit_get_health (unit (list_get (players) id))) 0) (< (objects_distance_to_flag (unit (list_get (players) id)) checkpoint_flag) 5.5))) 1)
	
	(deactivate_nav_point_flag (unit (list_get (players) id)) checkpoint_flag)
	(if (= id 0) (set player0_last_checkpoint checkpoint_flag) (set player1_last_checkpoint checkpoint_flag))
	(if (= finished false)
		(if finish_line
			(begin
				;(set finished true)
				(set winner_player (unit (list_get (players) id)))
				(sound_impulse_start "sound\sfx\ui\teleporter_fatal_coexistence" "none" 1)
				(if (> best_lap_time (+ timer_seconds (* timer_minutes 60)))
					(begin
						(print "new best lap time!")
						(numeric_countdown_timer_restart)
						(numeric_countdown_timer_set (* (+ timer_seconds (* timer_minutes 60)) 1000) false)
						(set best_lap_time (+ timer_seconds (* timer_minutes 60)))
					)
				)
				
			)
			(sound_impulse_start "sound\sfx\ui\countdown_timer" "none" 1)
		)
	)
)

(script static void (checkpoints_a (short id))
	
	(set race_start_minutes timer_minutes)
	(set race_start_seconds timer_seconds)
	(set race_start_time (game_time_authoritative))
	(hud_set_timer_position 0 0 bottom_right)
	(hud_set_timer_time 0 0)
	(wake timer)
	
	(checkpoint a1 id false)
	(print "a1")
	(checkpoint a2 id false)
	(print "a2")
	(checkpoint a3 id false)
	(print "a3")
	(checkpoint a4 id false)
	(print "a4")
	(checkpoint a5 id false)
	(print "a5")
	(checkpoint a6 id false)
	(print "a6")
	(checkpoint a7 id false)
	(print "a7")
	(checkpoint a8 id true)
	(print "a8")
)

(script continuous timer
	(sleep 1)
	(hud_set_timer_time (- timer_minutes race_start_minutes) (- timer_seconds race_start_seconds))
	(pause_hud_timer true)
)

(script continuous real_timer
	(set timer_minutes (modulo (/ (game_time_authoritative) 1800) 60))
	(set timer_seconds (modulo (/ (game_time_authoritative) 30) 60))
)

(script static short (modulo (short x) (short y))
  (set modulo_tmp (/ x y))
  (- x (* modulo_tmp y))
)