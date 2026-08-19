(global boolean var_break false)  
(global object_list var_list (ai_actors ai1))  ;; Used to store ai_actors calls temporarily to prevent memory issues
(global unit var_driver (unit (list_get var_list 0)))
(global short var_index 1)  


(script startup setup_ai
	(ai_place ai1)
	(ai_place ai2)
	(ai_place ai3)
	(ai_place ai4)
	(ai_place ai5)
	(object_create_anew car1)
	(object_create_anew car2)
	(object_create_anew car3)
	(object_create_anew car4)
	(object_create_anew car5)
	(vehicle_load_magic car1 "" (ai_actors ai1))
	(vehicle_load_magic car2 "" (ai_actors ai2))
	(vehicle_load_magic car3 "" (ai_actors ai3))
	(vehicle_load_magic car4 "" (ai_actors ai4))
	(vehicle_load_magic car0 "" (ai_actors ai5))
	
	;testing
	;(camera_control true)
	;(camera_set_dead car1)
	(camera_set_first_person car1)
)

;; Drive the track
(script static boolean (drive (short INDEX) (vehicle KART) (ai AI) (object_list LIST))
	;; Initialize break var to false
	(set var_break false)

	;; Test vehicle for dudes
	;;(if (<= (list_count (vehicle_riders KART)) 0) (set var_break true))  ;; deprecated seat test. changed to hopefully use fewer object lists
	(if (not (vehicle_test_seat KART "W-driver" var_driver)) (set var_break true))

	;; Track spans
	(generic_drive_span INDEX KART AI LIST span13 span13)
	(generic_drive_span INDEX KART AI LIST span12 span12)
	(generic_drive_span INDEX KART AI LIST span11 span11)
	(generic_drive_span INDEX KART AI LIST span10 span10)
	(generic_drive_span INDEX KART AI LIST span09 span09)
	(generic_drive_span INDEX KART AI LIST span08 span08)
	(generic_drive_span INDEX KART AI LIST span07 span07)
	(generic_drive_span INDEX KART AI LIST span06 span06)
	(generic_drive_span INDEX KART AI LIST span05 span05)
	(generic_drive_span INDEX KART AI LIST span04 span04)
	(generic_drive_span INDEX KART AI LIST span03 span03)
	(generic_drive_span INDEX KART AI LIST span02 span02)
	(generic_drive_span INDEX KART AI LIST span01 span01)
	(generic_drive_span INDEX KART AI LIST span00 span00)

	;; Default span - If all other spans fail volume test we run this as a last resort
	;(if (not var_break) (ai_command_list_by_unit var_driver default))
false
)

;; Sets up some variables that we use a lot
(script static boolean (set_vars (short INDEX) (vehicle KART) (ai AI))
	(set var_list (ai_actors AI))

	(set var_driver (vehicle_driver KART))
	;(set var_passenger (vehicle_gunner KART))
	(if (= var_driver none) (set var_break true))
false
)

(script static boolean (kart_ai_update_high_freq (short INDEX) (vehicle KART) (ai AI))
	(if (> (ai_living_count AI) 0) (begin
		(set_vars INDEX KART AI)
		
		;(generic_reseat_driver INDEX KART AI var_list)
		(drive INDEX KART AI var_list)
	))
false
)

;; Drive track template function (1 target)
(script static boolean (generic_drive_span (short INDEX) (vehicle KART) (ai AI) (object_list LIST) (trigger_volume TRIGGER) (ai_command_list COMMAND))
	(if (and (not var_break) (volume_test_object TRIGGER KART) ) (begin
	;(if (volume_test_object TRIGGER KART) (begin
		
		(ai_command_list_by_unit AI COMMAND)
		(set var_break true)
		;(print "driving now")
	))
false
)

(script continuous main
	;; Wait till race is started. We use an if here to prevent sleep_until from delaying execution for a frame
	;(if (not go) (sleep_until go 1))

	;; Update all ai in order for high freq stuff [every frame!]
	(kart_ai_update_high_freq 1 car1 ai1)
	(kart_ai_update_high_freq 2 car2 ai2)
	(kart_ai_update_high_freq 3 car3 ai3)
	(kart_ai_update_high_freq 4 car4 ai4)
	(kart_ai_update_high_freq 5 car0 ai5)

	;; Increment loop index for low freq
	(if (>= var_index 6)
		(set var_index 1)
		(set var_index (+ var_index 1))
	)

 	;; Do low freq operations for this frame index
	;(kart_ai_update_low_freq var_index (array_get_kart var_index) (array_get_ai var_index))

	;; Race tracking stuff
	;(race_status_update)
)

(script continuous braking_cont
	(braking car1 car1_vel ai1)
	(braking car2 car2_vel ai1)
)

(script static void (braking (unit car) (real vel) (ai AI))
	(if (and (> vel 0.5) (volume_test_object span03 car)) (begin
		(recording_play AI brake_short3)
		(sleep 6)
		(recording_kill AI)
	))
	;(inspect vel)
)