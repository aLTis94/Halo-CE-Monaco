(global short var_item_index 0)    ;; Fake frame loop index but does 5 per frame instead of 1. Medium freq.
(global unit var_player (player0)) ;; Var to hold player when doing loot rolls and figuring out who is back seat

;; Fake array zone [for fake ass arrays]
(global short ait00 0) (global short ait01 0) (global short ait02 0) (global short ait03 0)
(global short ait04 0) (global short ait05 0) (global short ait06 0) (global short ait07 0)
(global short ait08 0) (global short ait09 0) (global short ait10 0) (global short ait11 0)
(global short ait12 0) (global short ait13 0)
(script static short (array_get_item_timer (short INDEX))
	(if (= INDEX 0) (set var_out ait00))
	(if (= INDEX 1) (set var_out ait01))
	(if (= INDEX 2) (set var_out ait02))
	(if (= INDEX 3) (set var_out ait03))
	(if (= INDEX 4) (set var_out ait04))
	(if (= INDEX 5) (set var_out ait05))
	(if (= INDEX 6) (set var_out ait06))
	(if (= INDEX 7) (set var_out ait07))
	(if (= INDEX 8) (set var_out ait08))
	(if (= INDEX 9) (set var_out ait09))
	(if (= INDEX 10) (set var_out ait10))
	(if (= INDEX 11) (set var_out ait11))
	(if (= INDEX 12) (set var_out ait12))
	(if (= INDEX 13) (set var_out ait13))
var_out
)

(script static boolean (array_set_item_timer (short INDEX) (short VALUE))
	(if (= INDEX 0) (set ait00 VALUE))
	(if (= INDEX 1) (set ait01 VALUE))
	(if (= INDEX 2) (set ait02 VALUE))
	(if (= INDEX 3) (set ait03 VALUE))
	(if (= INDEX 4) (set ait04 VALUE))
	(if (= INDEX 5) (set ait05 VALUE))
	(if (= INDEX 6) (set ait06 VALUE))
	(if (= INDEX 7) (set ait07 VALUE))
	(if (= INDEX 8) (set ait08 VALUE))
	(if (= INDEX 9) (set ait09 VALUE))
	(if (= INDEX 10) (set ait10 VALUE))
	(if (= INDEX 11) (set ait11 VALUE))
	(if (= INDEX 12) (set ait12 VALUE))
	(if (= INDEX 13) (set ait13 VALUE))
false
)

;; Decrements all timers at once!
(script static boolean array_decrement_item_timers
	(if (> ait00 0) (set ait00 (- ait00 1)))
	(if (> ait01 0) (set ait01 (- ait01 1)))
	(if (> ait02 0) (set ait02 (- ait02 1)))
	(if (> ait03 0) (set ait03 (- ait03 1)))
	(if (> ait04 0) (set ait04 (- ait04 1)))
	(if (> ait05 0) (set ait05 (- ait05 1)))
	(if (> ait06 0) (set ait06 (- ait06 1)))
	(if (> ait07 0) (set ait07 (- ait07 1)))
	(if (> ait08 0) (set ait08 (- ait08 1)))
	(if (> ait09 0) (set ait09 (- ait09 1)))
	(if (> ait10 0) (set ait10 (- ait10 1)))
	(if (> ait11 0) (set ait11 (- ait11 1)))
	(if (> ait12 0) (set ait12 (- ait12 1)))
	(if (> ait13 0) (set ait13 (- ait13 1)))
false
)

;; Does the shield boost power up.
(script static boolean players_shield_boost
	(if (<= (unit_get_shield (player0)) 2) (player_add_equipment (player0) equip_shield false))
	(if (<= (unit_get_shield (player1)) 2) (player_add_equipment (player1) equip_shield false))
false
)

;; Does the heal power up.
(script static boolean players_heal
	(if (<= (unit_get_health (player0)) 0.975) (player_add_equipment (player0) equip_health false))
	(if (<= (unit_get_health (player1)) 0.975) (player_add_equipment (player1) equip_health false))
false
)

;; Adds weapon to player safely
(script static boolean (player_get_equip (unit PLAYER) (object_definition WEAPON) (starting_profile PROFILE))
	(if (and (not (= PLAYER none)) (not (unit_has_weapon PLAYER WEAPON))) (player_add_equipment PLAYER PROFILE false))
false
)

(global boolean var_random false)
(script static boolean (players_roll_item (vehicle KART) (boolean HIGH))
	(set var_player none)
	(if (vehicle_test_seat KART "WS-Passenger" (player0)) (set var_player (player0)))
	(if (vehicle_test_seat KART "WS-Passenger" (player1)) (set var_player (player1)))

	(set var_random false)
	(if HIGH (begin_random
		(if (not var_random) (begin (player_get_equip var_player "weapons\rocket launcher\rocket launcher" equip_rocket) (set var_random true)))
		(if (not var_random) (begin (player_get_equip var_player "weapons\plasma_cannon\plasma_cannon" equip_cannon) (set var_random true)))
		(if (not var_random) (begin (players_shield_boost) (set var_random true)))
	)
	(begin_random
		(if (not var_random) (begin (print "rocket") (player_get_equip var_player "weapons\rocket launcher\rocket launcher" equip_rocket) (set var_random true)))
		(if (not var_random) (begin (print "cannon") (player_get_equip var_player "weapons\plasma_cannon\plasma_cannon" equip_cannon) (set var_random true)))
		(if (not var_random) (begin (print "shield") (players_shield_boost) (set var_random true)))
		(if (not var_random) (begin (print "sniper") (player_get_equip var_player "weapons\sniper rifle\sniper rifle" equip_sniper) (set var_random true)))
		(if (not var_random) (begin (print "shotgun") (player_get_equip var_player "weapons\shotgun\shotgun" equip_shotgun) (set var_random true)))
		(if (not var_random) (begin (print "sniper") (player_get_equip var_player "weapons\sniper rifle\sniper rifle" equip_sniper) (set var_random true)))
		(if (not var_random) (begin (print "shotgun") (player_get_equip var_player "weapons\shotgun\shotgun" equip_shotgun) (set var_random true)))
	))

	(set var_random false)
	(if (< (unit_get_total_grenade_count var_player) 4) (begin_random
		(if (not var_random) (begin (print "nothing") (set var_random true)))
		(if (not var_random) (begin (print "frag") (player_add_equipment var_player equip_frag false) (set var_random true)))
		(if (not var_random) (begin (print "plasma") (player_add_equipment var_player equip_plasma false) (set var_random true)))
	))

	(players_heal) (players_heal) (players_heal)

	(set var_random false)
	(begin_random
		(if (not var_random) (begin (set var_johnson_upgrade true) (set var_random true)))
		(if (not var_random) (begin (print "never lucky!") (set var_random true)))
	)
false
)

(script static boolean (item_update (short INDEX) (short ITEM_INDEX) (scenery SCENERY) (trigger_volume TRIGGER) (animation_graph ANIMATION) (boolean HIGH))
	(if (and (volume_test_object TRIGGER (array_get_kart INDEX)) (<= (array_get_item_timer ITEM_INDEX) 0)) (begin
		(scenery_animation_start SCENERY ANIMATION "respawn")
		(effect_new_on_object_marker "kart\scenery\item block\effects\break" SCENERY "break")
		(array_set_item_timer ITEM_INDEX 30)

		(if (= INDEX 14) (players_roll_item (array_get_kart INDEX) HIGH))   ;; Only roll items for the players warthog!
	))

	(if (<= (scenery_get_animation_time SCENERY) 0) (scenery_animation_start SCENERY ANIMATION "idle")) 
false
)

(script static boolean (items_update (short INDEX))
	(item_update INDEX 0 item00 trigger00 "kart\scenery\item block\a\a" false)
	(item_update INDEX 1 item01 trigger01 "kart\scenery\item block\b\b" false)
	(item_update INDEX 2 item02 trigger02 "kart\scenery\item block\c\c" false)
	(item_update INDEX 3 item03 trigger03 "kart\scenery\item block\a\a" false)
	(item_update INDEX 4 item04 trigger04 "kart\scenery\item block\d\d" false)
	(item_update INDEX 5 item05 trigger05 "kart\scenery\item block\c\c" true)
	(item_update INDEX 6 item06 trigger06 "kart\scenery\item block\d\d" false)
	(item_update INDEX 7 item07 trigger07 "kart\scenery\item block\d\d" false)
	(item_update INDEX 8 item08 trigger08 "kart\scenery\item block\d\d" true)
	(item_update INDEX 9 item09 trigger09 "kart\scenery\item block\d\d" false)
	(item_update INDEX 10 item10 trigger10 "kart\scenery\item block\b\b" false)
false
)

(script static boolean items_update_med_freq
	(if (< var_item_index 10)
		(set var_item_index (+ var_item_index 5))
		(set var_item_index 0)
	)	

	(items_update var_item_index)
	(items_update (+ var_item_index 1))
	(items_update (+ var_item_index 2))
	(items_update (+ var_item_index 3))
	(items_update (+ var_item_index 4))

	(array_decrement_item_timers)
false
)