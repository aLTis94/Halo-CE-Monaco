;; Handles intro cutscene

(script dormant intro
	(fade_out 0 0 0 1)
	(camera_control_tracked 1)
	(camera_set intro00 0)
	(cinematic_start)
	(sleep 15)
	
	(music "kart\music\start" 190)
	(camera_set intro01 170)
	(fade_in 0 0 0 10)
	(cinematic_set_title title)
	(sleep 120)

	(camera_set intro02 0)
	(camera_set intro03 150)
	(sleep 90)

	(cinematic_stop)
	(camera_control_tracked 0)
	(player_enable_input false)  ;; It seems that camera_control 0 messes this up so we reset this value
	(player_camera_control 1)

	(sleep 30)
	(cinematic_set_title laps)
)