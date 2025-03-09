; bit 0: Starter
; bit 1: Pidove Line
; bit 2: Patrat Line
; bit 3: Zorua Line
; bit 4: Tirtouga Line
; bit 5: Cottonee Line
; bit 6: Klink Line
; bit 7: Unused

SetStolen::
; wcf91 holds the species info
	call checkIfRival
	and a
	ret z
	ld a, [wRivalPokemonStolen]
	ld b, a
	ld a, [wcf91]
.checkStarter
	cp SNIVY
	jr c, .checkPidove
	cp SAMUROTT
	jr z, .stoleStarter
	jr c, .stoleStarter
.checkPidove
	cp PIDOVE
	jr c, .checkPatrat
	cp UNFEZANT
	jr z, .stolePidove
	jr c, .stolePidove
.checkPatrat
	cp PATRAT
	jr z, .stolePatrat
	cp WATCHOG
	jr z, .stolePatrat
.checkZorua
	cp ZORUA
	jr z, .stoleZorua
	cp ZOROARK
	jr z, .stoleZorua
.checkTirtouga
	cp TIRTOUGA
	jr z, .stoleTirtouga
	cp CARRACOSTA
	jr z, .stoleTirtouga
.checkCottonee
	cp COTTONEE
	jr z, .stoleCottonee
	cp WHIMSICOTT
	jr z, .stoleCottonee
.checkKlink
	cp KLINK ; Klink is unused, but in the line
	jr c, .checkPatrat
	cp KLINKLANG
	jr z, .stoleKlink
	jr c, .stoleKlink
	ret
.stoleStarter
	ld a, b
	set 0, a
	jr .done
.stolePidove
	ld a, b
	set 1, a
	jr .done
.stolePatrat
	ld a, b
	set 2, a
	jr .done
.stoleZorua
	ld a, b
	set 3, a
	jr .done
.stoleTirtouga
	ld a, b
	set 4, a
	jr .done
.stoleCottonee
	ld a, b
	set 5, a
	jr .done
.stoleKlink
	ld a, b
	set 6, a
	jr .done
.stoleunused
	ld a, b
	set 7, a
	jr .done
.done
	ld [wRivalPokemonStolen], a
	ret

CheckStolen::
; wcf91 holds the species info
	call checkIfRival
	and a
	ret z
	ld a, [wRivalPokemonStolen]
	ld b, a
	ld a, [wcf91]
.checkStarter
	bit 0, b
	jr z, .checkPidove
	cp SNIVY ; Pointless b/c you can't be under SNIVY, but w/e
	jr c, .checkPidove
	cp SAMUROTT
	jr z, .stolen
	jr nc, .checkPidove
	jr .stolen
.checkPidove
	bit 1, b
	jr z, .checkPatrat
	cp PIDOVE
	jr c, .checkPatrat
	cp UNFEZANT
	jr z, .stolen
	jr nc, .checkPatrat
	jr .stolen
.checkPatrat
	bit 2, b
	jr z, .checkZorua
	cp PATRAT
	jr z, .stolen
	cp WATCHOG
	jr z, .stolen
.checkZorua
	bit 3, b
	jr z, .checkTirtouga
	cp ZORUA
	jr z, .stolen
	cp ZOROARK
	jr z, .stolen
.checkTirtouga
	bit 4, b
	jr z, .checkCottonee
	cp TIRTOUGA
	jr z, .stolen
	cp CARRACOSTA
	jr z, .stolen
.checkCottonee
	bit 5, b
	jr z, .checkKlink
	cp COTTONEE
	jr z, .stolen
	cp WHIMSICOTT
	jr z, .stolen
.checkKlink
	bit 6, b
	jr z, .checkUnused
	cp KLINK
	jr c, .checkUnused
	cp KLINKLANG
	jr z, .stolen
	jr nc, .checkUnused
	jr .stolen
.checkUnused
	bit 7, b
	jr z, .notStolen
	cp MON_GHOST
	jr nz, .stolen
.notStolen
	and a
	ret
.stolen
	scf
	ret

checkIfRival:
	ld a, [wTrainerClass]
	cp SONY1
	jr z, .isRival
	cp SONY2
	jr z, .isRival
	cp SONY3
	jr z, .isRival
	xor a
.isRival
	ret