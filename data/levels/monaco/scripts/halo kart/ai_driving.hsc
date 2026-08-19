(global boolean var_break false)                           ;; Used to prevent large memory stacks by exiting execution
(global object_list var_list (ai_actors group00))  ;; Used to store ai_actors calls temporarily to prevent memory issues
(global unit var_driver (unit (list_get var_list 0)))      ;; Used to store driver in current script execution to save memory/time
(global unit var_passenger (unit (list_get var_list 1)))   ;; Same tbh
(global short var_out 0)                                   ;; Collects return value to then be returned. Saves stack space by doing this instead of conditional chains
(global vehicle var_out_veh kart00)                        ;; Same tbh
(global ai var_out_ai group00)                     ;; Same tbh
(global short var_index 0)                                 ;; Use for low frequency update iteration over frames (fake loops)

(global boolean go false)                            ;; Race started
(global boolean finish false)                        ;; Race over

;; Fake array zone [for fake ass arrays]
(global short aft00 0) (global short aft01 0) (global short aft02 0) (global short aft03 0)
(global short aft04 0) (global short aft05 0) (global short aft06 0) (global short aft07 0)
(global short aft08 0) (global short aft09 0) (global short aft10 0) (global short aft11 0)
(global short aft12 0) (global short aft13 0)
(script static short (array_get_flip_timer (short INDEX))
	(if (= INDEX 0) (set var_out aft00))
	(if (= INDEX 1) (set var_out aft01))
	(if (= INDEX 2) (set var_out aft02))
	(if (= INDEX 3) (set var_out aft03))
	(if (= INDEX 4) (set var_out aft04))
	(if (= INDEX 5) (set var_out aft05))
	(if (= INDEX 6) (set var_out aft06))
	(if (= INDEX 7) (set var_out aft07))
	(if (= INDEX 8) (set var_out aft08))
	(if (= INDEX 9) (set var_out aft09))
	(if (= INDEX 10) (set var_out aft10))
	(if (= INDEX 11) (set var_out aft11))
	(if (= INDEX 12) (set var_out aft12))
	(if (= INDEX 13) (set var_out aft13))
var_out
)

(script static boolean (array_set_flip_timer (short INDEX) (short VALUE))
	(if (= INDEX 0) (set aft00 VALUE))
	(if (= INDEX 1) (set aft01 VALUE))
	(if (= INDEX 2) (set aft02 VALUE))
	(if (= INDEX 3) (set aft03 VALUE))
	(if (= INDEX 4) (set aft04 VALUE))
	(if (= INDEX 5) (set aft05 VALUE))
	(if (= INDEX 6) (set aft06 VALUE))
	(if (= INDEX 7) (set aft07 VALUE))
	(if (= INDEX 8) (set aft08 VALUE))
	(if (= INDEX 9) (set aft09 VALUE))
	(if (= INDEX 10) (set aft10 VALUE))
	(if (= INDEX 11) (set aft11 VALUE))
	(if (= INDEX 12) (set aft12 VALUE))
	(if (= INDEX 13) (set aft13 VALUE))
false
)

(script static vehicle (array_get_kart (short INDEX))
	(if (= INDEX 0) (set var_out_veh kart00))
	(if (= INDEX 1) (set var_out_veh kart01))
	(if (= INDEX 2) (set var_out_veh kart02))
	(if (= INDEX 3) (set var_out_veh kart03))
	(if (= INDEX 4) (set var_out_veh kart04))
	(if (= INDEX 5) (set var_out_veh kart05))
	(if (= INDEX 6) (set var_out_veh kart06))
	(if (= INDEX 7) (set var_out_veh kart07))
	(if (= INDEX 8) (set var_out_veh kart08))
	(if (= INDEX 9) (set var_out_veh kart09))
	(if (= INDEX 10) (set var_out_veh kart10))
	(if (= INDEX 11) (set var_out_veh kart11))
	(if (= INDEX 12) (set var_out_veh kart12))
	(if (= INDEX 13) (set var_out_veh kart13))
	(if (= INDEX 14) (set var_out_veh kart14))    ;; Players kart! Not indexed by ai driving scripts but used by item box scripts
var_out_veh
)

(script static ai (array_get_ai (short INDEX))
	(if (= INDEX 0) (set var_out_ai group00))
	(if (= INDEX 1) (set var_out_ai group01))
	(if (= INDEX 2) (set var_out_ai group02))
	(if (= INDEX 3) (set var_out_ai group03))
	(if (= INDEX 4) (set var_out_ai group04))
	(if (= INDEX 5) (set var_out_ai group05))
	(if (= INDEX 6) (set var_out_ai group06))
	(if (= INDEX 7) (set var_out_ai group07))
	(if (= INDEX 8) (set var_out_ai group08))
	(if (= INDEX 9) (set var_out_ai group09))
	(if (= INDEX 10) (set var_out_ai group10))
	(if (= INDEX 11) (set var_out_ai group11))
	(if (= INDEX 12) (set var_out_ai group12))
	(if (= INDEX 13) (set var_out_ai group13))
var_out_ai
)

;; Drive track template function (1 target)
(script static boolean (generic_drive_span (short INDEX) (vehicle KART) (ai AI) (object_list LIST) (trigger_volume TRIGGER) (ai_command_list COMMAND))
	(if (and (not var_break) (volume_test_object TRIGGER KART) ) (begin
		(ai_command_list_by_unit var_driver COMMAND)
		(set var_break true)
	))
false
)

;; Drive track template function (2 targets)
(script static boolean (generic_drive_spans (short INDEX) (vehicle KART) (ai AI) (object_list LIST) (trigger_volume TRIGGER) (ai_command_list COMMAND_A) (ai_command_list COMMAND_B))
	(if (and (not var_break) (volume_test_object TRIGGER KART) ) (begin
		(if (= (modulo INDEX 2) 0) ;; causing a crash
			(ai_command_list_by_unit var_driver COMMAND_A)
			(ai_command_list_by_unit var_driver COMMAND_B)
		)
		(set var_break true)
	))
false
)

;; Drive the track
(script static boolean (track00_drive (short INDEX) (vehicle KART) (ai AI) (object_list LIST))
	;; Initialize break var to false
	(set var_break false)

	;; Test vehicle for dudes
	;;(if (<= (list_count (vehicle_riders KART)) 0) (set var_break true))  ;; deprecated seat test. changed to hopefully use fewer object lists
	(if (not (vehicle_test_seat KART "WS-Driver" var_driver)) (set var_break true))

	;; Track spans
	(generic_drive_span INDEX KART AI LIST span15 track00span15)
	(generic_drive_span INDEX KART AI LIST span14 track00span14)
	(generic_drive_span INDEX KART AI LIST span13 track00span13)
	(generic_drive_span INDEX KART AI LIST span12 track00span12)
	(generic_drive_span INDEX KART AI LIST span11 track00span11)
	(generic_drive_span INDEX KART AI LIST span10b track00span10b)
	(generic_drive_span INDEX KART AI LIST span10a track00span10a)
	(generic_drive_span INDEX KART AI LIST span09b track00span09b)
	(generic_drive_span INDEX KART AI LIST span09a track00span09a)
	(generic_drive_span INDEX KART AI LIST span08 track00span08)
	(generic_drive_span INDEX KART AI LIST span07 track00span07)
	(generic_drive_span INDEX KART AI LIST span06b track00span06b)
	(generic_drive_spans INDEX KART AI LIST span06a track00span06a track00span06a_alt)
	(generic_drive_spans INDEX KART AI LIST span05 track00span05 track00span05alt)
	(generic_drive_spans INDEX KART AI LIST span04b track00span04b track00span04b_alt)
	(generic_drive_span INDEX KART AI LIST span04c track00span04c)
	(generic_drive_span INDEX KART AI LIST span04a track00span04a)
	(generic_drive_span INDEX KART AI LIST span03 track00span03)
	(generic_drive_spans INDEX KART AI LIST span02 track00span02 track00span02alt)
	(generic_drive_span INDEX KART AI LIST span01b track00span01b)
	(generic_drive_span INDEX KART AI LIST span01a track00span01a)
	(generic_drive_span INDEX KART AI LIST span00 track00span00)

	;; Default span - If all other spans fail volume test we run this as a last resort
	(if (not var_break) (ai_command_list_by_unit var_driver track00default))
false
)

;; If driver is dead and the gunner is alive and seated we move the gunner to the driver seat so he's not just sitting there
(script static boolean (generic_swap_seat (short INDEX) (vehicle KART) (ai AI) (object_list LIST))
	(if (and (= var_driver none) (not (= var_passenger none)))
		(unit_enter_vehicle var_passenger KART "WS-Driver")
	)
false
)

;; Force gunner ai back into gunner seat if the driver gets back in
(script static boolean (generic_reseat_gunner (short INDEX) (vehicle KART) (ai AI) (object_list LIST))
	(if (and (> (ai_living_count AI) 1) (= var_passenger none) (not (= var_driver none))) (begin 
		;; Please note that if this function is in the high_freq and runs every frame it will cause a crash. It needs a few frames of delay between execs
		(if (not (= var_driver (unit (list_get LIST 0)))) (vehicle_load_magic KART "" (unit (list_get LIST 0))) )
		(if (not (= var_driver (unit (list_get LIST 1)))) (vehicle_load_magic KART "" (unit (list_get LIST 1))) )
	))
false
)

;; Make ai go to vehicle and get back in if they fall out
(script static boolean (generic_reseat_driver (short INDEX) (vehicle KART) (ai AI) (object_list LIST))
	(if (and (= var_driver none) (> (ai_living_count AI) 0))
		(ai_go_to_vehicle_override AI KART "WS-driver")
	)
false
)

;; Fixes dumb ai looking the wrong way and standing near their kart
(script static boolean (generic_force_seat (short INDEX) (vehicle KART) (ai AI) (object_list LIST))
	(if (and (= var_driver none) (> (ai_living_count AI) 0))
		(if (> (ai_going_to_vehicle KART) 0) (begin
			(generic_force_seat_addendum INDEX KART AI LIST (unit (list_get LIST 0)))
			(generic_force_seat_addendum INDEX KART AI LIST (unit (list_get LIST 1)))
		))
	)
false
)

(script static boolean (generic_force_seat_addendum (short INDEX) (vehicle KART) (ai AI) (object_list LIST) (unit UNIT))
	(if (and (<= (objects_distance_to_object UNIT KART) 1.5) (> (unit_get_health UNIT) 0)) (begin
		(unit_enter_vehicle UNIT KART "WS-Driver")
		(print "+AD")
	))
false
)

;; Jank test to see if kart is flipped over, if we think it is then we count up a flip timer then flip the vehicle over using an effect
(script static boolean (generic_flip_kart (short INDEX) (vehicle KART) (ai AI) (object_list LIST))
	(if (and (> (ai_living_count AI) 0) (<= (list_count (vehicle_riders KART)) 0))
		(if (<= (ai_going_to_vehicle KART) 0)
			(if (> (array_get_flip_timer INDEX) 4)
				(begin
					(effect_new_on_object_marker "vehicles\c warthog\effects\script flip" KART "script flip")
					(array_set_flip_timer INDEX 0)
				)
				(array_set_flip_timer INDEX (+ (array_get_flip_timer INDEX) 1))
			)
		)
		(array_set_flip_timer INDEX 0)
	)
false
)

;; Sets up some variables that we use a lot
(script static boolean (set_vars (short INDEX) (vehicle KART) (ai AI))
	(set var_list (ai_actors AI))

	(set var_driver (vehicle_driver KART))
	(set var_passenger (vehicle_gunner KART))
	(if (= var_driver none) (set var_break true))
false
)

(script static boolean (kart_ai_update_high_freq (short INDEX) (vehicle KART) (ai AI))
	(if (> (ai_living_count AI) 0) (begin
		(set_vars INDEX KART AI)

		(generic_reseat_driver INDEX KART AI var_list)
		(track00_drive INDEX KART AI var_list)
	))
false
)

(script static boolean (kart_ai_update_low_freq (short INDEX) (vehicle KART) (ai AI))
	(if (> (ai_living_count AI) 0) (begin
		(set_vars INDEX KART AI)

		(generic_flip_kart var_index KART AI var_list)
		(generic_swap_seat var_index KART AI var_list)
		(generic_reseat_gunner var_index KART AI var_list)
		(generic_force_seat var_index KART AI var_list)
	))
)

(script continuous main
	;; Wait till race is started. We use an if here to prevent sleep_until from delaying execution for a frame
	(if (not go) (sleep_until go 1))

	;; Update all ai in order for high freq stuff [every frame!]
	(kart_ai_update_high_freq 0 kart00 group00)
	(kart_ai_update_high_freq 1 kart01 group01)
	(kart_ai_update_high_freq 2 kart02 group02)
	(kart_ai_update_high_freq 3 kart03 group03)
	(kart_ai_update_high_freq 4 kart04 group04)
	(kart_ai_update_high_freq 5 kart05 group05)
	(kart_ai_update_high_freq 6 kart06 group06)
	(kart_ai_update_high_freq 7 kart07 group07)
	(kart_ai_update_high_freq 8 kart08 group08)
	(kart_ai_update_high_freq 9 kart09 group09)
	(kart_ai_update_high_freq 10 kart10 group10)
	(kart_ai_update_high_freq 11 kart11 group11)
	(kart_ai_update_high_freq 12 kart12 group12)
	(kart_ai_update_high_freq 13 kart13 group13)

	;; Increment loop index for low freq
	(if (>= var_index 13)
		(set var_index 0)
		(set var_index (+ var_index 1))
	)

 	;; Do low freq operations for this frame index
	(kart_ai_update_low_freq var_index (array_get_kart var_index) (array_get_ai var_index))

	;; Item block update stuff
	(items_update_med_freq)

	;; Race tracking stuff
	(race_status_update)
)