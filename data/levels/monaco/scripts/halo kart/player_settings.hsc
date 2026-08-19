(global real const_max_hp 70)

(script startup player_health
	(unit_set_maximum_vitality (player0) const_max_hp const_max_hp)
	(if (game_is_cooperative) (unit_set_maximum_vitality (player1) const_max_hp const_max_hp))
)