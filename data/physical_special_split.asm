PhysicalToSpecialMoves:
; Flying
        db GUST
		db RAZOR_WIND
		db HURRICANE
; Poison
        db ACID
		db SMOG
        db SLUDGE
; Ground
		db MUD_SHOT
; Normal
        db HYPER_BEAM
        db SWIFT
        db TRI_ATTACK
; Dark
		db NIGHT_DAZE
        db -1 ; end

SpecialToPhysicalMoves:
; Fire
        db FIRE_PUNCH
; Water
        db WATERFALL
; Grass
        db RAZOR_LEAF
        db VINE_WHIP
; Electric
        db THUNDERPUNCH
; Ice
        db ICE_PUNCH
; Dragon
		db DRAGON_CLAW
; Ghost
		db LICK
        db -1 ; end
