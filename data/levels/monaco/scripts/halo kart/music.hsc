(global looping_sound const_music "kart\music\beach")

(global looping_sound var_music none)
(global looping_sound var_music_change none)
(global short var_music_duration 0)

(script static boolean (music (looping_sound MUSIC) (short DURATION))
	(set var_music_change MUSIC)
	(set var_music_duration DURATION)
false
)

(script continuous music_update
	(sleep_until (not (= var_music_change none)) 3)

	(if (not (= var_music none)) (sound_looping_stop var_music))
	
	(if (not (= var_music_change const_music)) (begin
		(set var_music var_music_change)
		(sound_looping_start var_music none 0.75)
		(set var_music_change none)
		(sleep var_music_duration)

		(sound_looping_stop var_music)
	)
		(set var_music_change none)
	)

	(if (and go (not finish)) 
		(begin (set var_music const_music) (sound_looping_start var_music none 0.75))
		(print "null music")
	)
)