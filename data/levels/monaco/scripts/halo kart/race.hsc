;; This script tracks the actual progress and placement of racers

(global short const_laps 2)
(global short const_checkpoints 5)
(global trigger_volume const_checkpoint00 span03)
(global trigger_volume const_checkpoint01 span05)
(global trigger_volume const_checkpoint02 span10b)
(global trigger_volume const_checkpoint03 span14)
(global trigger_volume const_checkpoint04 final)

(global boolean var_final_lap false) ;; Set when we play the final lap music so it doesn't repeat
(global short var_placement 0)
(global short var_trip_chance 0)   ;; The further in the lead the player is the higher this gets, and the more likely you are to get oof'd by an item
(global short var_trip_cooldown 0) ;; Don't spam
(global short var_trip_test 0)     ;; Don't spam
(global short var_index_plus 0)

;; Fake array zone [for fake ass arrays]
(global short arp00 0) (global short arp01 0) (global short arp02 0) (global short arp03 0)
(global short arp04 0) (global short arp05 0) (global short arp06 0) (global short arp07 0)
(global short arp08 0) (global short arp09 0) (global short arp10 0) (global short arp11 0)
(global short arp12 0) (global short arp13 0) (global short arp14 0)
(script static short (array_get_race_progress (short INDEX))
	(if (= INDEX 0) (set var_out arp00))
	(if (= INDEX 1) (set var_out arp01))
	(if (= INDEX 2) (set var_out arp02))
	(if (= INDEX 3) (set var_out arp03))
	(if (= INDEX 4) (set var_out arp04))
	(if (= INDEX 5) (set var_out arp05))
	(if (= INDEX 6) (set var_out arp06))
	(if (= INDEX 7) (set var_out arp07))
	(if (= INDEX 8) (set var_out arp08))
	(if (= INDEX 9) (set var_out arp09))
	(if (= INDEX 10) (set var_out arp10))
	(if (= INDEX 11) (set var_out arp11))
	(if (= INDEX 12) (set var_out arp12))
	(if (= INDEX 13) (set var_out arp13))
	(if (= INDEX 14) (set var_out arp14))
var_out
)

(script static boolean (array_set_race_progress (short INDEX) (short VALUE))
	(if (= INDEX 0) (set arp00 VALUE))
	(if (= INDEX 1) (set arp01 VALUE))
	(if (= INDEX 2) (set arp02 VALUE))
	(if (= INDEX 3) (set arp03 VALUE))
	(if (= INDEX 4) (set arp04 VALUE))
	(if (= INDEX 5) (set arp05 VALUE))
	(if (= INDEX 6) (set arp06 VALUE))
	(if (= INDEX 7) (set arp07 VALUE))
	(if (= INDEX 8) (set arp08 VALUE))
	(if (= INDEX 9) (set arp09 VALUE))
	(if (= INDEX 10) (set arp10 VALUE))
	(if (= INDEX 11) (set arp11 VALUE))
	(if (= INDEX 12) (set arp12 VALUE))
	(if (= INDEX 13) (set arp13 VALUE))
	(if (= INDEX 14) (set arp14 VALUE))
false
)

;; LOOOOOOOOL
(global short var_modulo 0)
(script static short (modulo (short a) (short b))
	(set var_modulo (/ a b))
(- a (* var_modulo b))
)

;; LOOOL
(global short var_modulo2 0)
(script static short (modulo2 (short a) (short b))
	(if (>= a b)
		(set var_modulo2 (modulo2 (- a b) b))
		(set var_modulo2 a)
	)
var_modulo2
)

(global short var_random_int 0)
(script static short random
	(begin_random
		(set var_random_int 0) (set var_random_int 1) (set var_random_int 2) (set var_random_int 3) (set var_random_int 4) (set var_random_int 5) (set var_random_int 6) 
		(set var_random_int 7) (set var_random_int 8) (set var_random_int 9) (set var_random_int 10) (set var_random_int 11) (set var_random_int 12) (set var_random_int 13)
		(set var_random_int 14) (set var_random_int 15) (set var_random_int 16) (set var_random_int 17) (set var_random_int 18) (set var_random_int 19) (set var_random_int 20)
		(set var_random_int 21) (set var_random_int 22) (set var_random_int 23) (set var_random_int 24) (set var_random_int 25) (set var_random_int 26) (set var_random_int 27)
		(set var_random_int 28) (set var_random_int 29)
	)
var_random_int
)

(script static boolean (leader_check (short INDEX))
	(if (> (array_get_race_progress INDEX) (array_get_race_progress var_leader)) (set var_leader INDEX))
false
)

(script static boolean (leader_solo_check (short INDEX))
	(if (and (>= var_leader 0) (not (= var_leader INDEX)) (= (array_get_race_progress INDEX) (array_get_race_progress var_leader))) (set var_leader -1))
false
)

;; If the player is winning we uhhh... fuck em up... to make the race closer. Kind of a dick move but being in first is boring so we need this
(global short var_leader 0)
(script static boolean catch_up_check
	;; See if there is a leader in the race...
	(set var_leader 0)
	(leader_check 0)
	(leader_check 1)
	(leader_check 2)
	(leader_check 3)
	(leader_check 4)
	(leader_check 5)
	(leader_check 6)
	(leader_check 7)
	(leader_check 8)
	(leader_check 9)
	(leader_check 10)
	(leader_check 11)
	(leader_check 12)
	(leader_check 13)
	(leader_check 14)
	(leader_solo_check 0)
	(leader_solo_check 1)
	(leader_solo_check 2)
	(leader_solo_check 3)
	(leader_solo_check 4)
	(leader_solo_check 5)
	(leader_solo_check 6)
	(leader_solo_check 7)
	(leader_solo_check 8)
	(leader_solo_check 9)
	(leader_solo_check 10)
	(leader_solo_check 11)
	(leader_solo_check 12)
	(leader_solo_check 13)
	(leader_solo_check 14)

	;; If the player is leading we ruin his day!
	(if (= var_leader 14) (set var_trip_chance (+ var_trip_chance 1)))

	(if (>= var_trip_test 15)
		(begin 
			(set var_trip_test 0)
			(if (and (= var_leader 14) (<= var_trip_cooldown 0) (> var_trip_chance (* (random) 45))) (set var_trip 1))
		)
		(set var_trip_test (+ var_trip_test 1))
	)
false
)


(script dormant player_win
	(set finish true) (print "player won!")
	(music "kart\music\win" 190)
	(camera_control_tracked 1)
	(camera_set_relative outro00 0 kart14)
	(if (= var_placement 0) (cinematic_set_title place1))
	(if (= var_placement 1) (cinematic_set_title place2))
	(if (= var_placement 2) (cinematic_set_title place3))
	(sleep 200)
	(fade_out 0 0 0 90)
	(sleep 90)
	(game_won)
)

(global vehicle var_winner kart00)
(script dormant player_lose
	(set finish true) (print "player lost!")
	(camera_control_tracked 1)
	(camera_set_dead var_winner)
	(cinematic_set_title dnf)
	(music "kart\music\lose" 160)
	(sleep 140)
	(fade_out 0 0 0 90)
	(sleep 90)
	(game_lost)
)

(script static boolean (racer_status_update (short INDEX) (vehicle KART))
	(if (and (= (modulo (array_get_race_progress INDEX) const_checkpoints) 0) (volume_test_object const_checkpoint00 KART)) (array_set_race_progress INDEX (+ (array_get_race_progress INDEX) 1)))
	(if (and (= (modulo (array_get_race_progress INDEX) const_checkpoints) 1) (volume_test_object const_checkpoint01 KART)) (array_set_race_progress INDEX (+ (array_get_race_progress INDEX) 1)))
	(if (and (= (modulo (array_get_race_progress INDEX) const_checkpoints) 2) (volume_test_object const_checkpoint02 KART)) (array_set_race_progress INDEX (+ (array_get_race_progress INDEX) 1)))
	(if (and (= (modulo (array_get_race_progress INDEX) const_checkpoints) 3) (volume_test_object const_checkpoint03 KART)) (array_set_race_progress INDEX (+ (array_get_race_progress INDEX) 1)))
	(if (and (= (modulo (array_get_race_progress INDEX) const_checkpoints) 4) (volume_test_object const_checkpoint04 KART)) (array_set_race_progress INDEX (+ (array_get_race_progress INDEX) 1)))

	;; Final lap check
	(if (and (>= (array_get_race_progress INDEX) (* (- const_laps 1) const_checkpoints)) (= INDEX 14) (not var_final_lap)) (begin
		(music "kart\music\final" 120)
		(set var_final_lap true)
	))

	;; Race finish check
	(if (>= (array_get_race_progress INDEX) (* const_laps const_checkpoints)) (begin
		(if (= INDEX 14)
			(wake player_win)
			(set var_placement (+ var_placement 1))
		)
		(print "a kart has finished the race!")
		(array_set_race_progress INDEX 0)
		(if (> var_placement 2) (begin (wake player_lose) (set var_winner KART)))
	))
false
)

(script static boolean race_status_update
	(if (and go (not finish)) (begin
		;; Increment loop index for low freq - not reusing var_index from ai_driving because it only goes to 13. this goes to 14 as it includes players
		(if (>= var_index_plus 14)
			(set var_index_plus 0)
			(set var_index_plus (+ var_index_plus 1))
		)

		;; Timer
		(if (> var_trip_cooldown 0) (set var_trip_cooldown (- var_trip_cooldown 1)))
	
		(racer_status_update var_index_plus (array_get_kart var_index_plus))
		(catch_up_check)
	))
false
)