;; Kill volumes for bottomless pits or whatever
(script startup kill00a
	(sleep_until (volume_test_object water (player0)) 10)
	(unit_kill (player0))
)

(script startup kill00b
	(sleep_until (volume_test_object water (player1)) 10)
	(unit_kill (player1))
)