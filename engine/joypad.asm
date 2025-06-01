_Joypad::
; hJoyReleased: (hJoyLast ^ hJoyInput) & hJoyLast
; hJoyPressed:  (hJoyLast ^ hJoyInput) & hJoyInput

	ld a, [hJoyInput]
	cp A_BUTTON + B_BUTTON + SELECT + START ; soft reset
	jp z, TrySoftReset

	; --- Turbo A/B ---
	ld b, a
	ld a, [wFontLoaded]
	bit 1, a
	jr z, .noTurbo

	ld a, [rDIV]
	bit 4, a
	jr z, .noTurbo

	ld a, b
	bit BIT_A_BUTTON, a
	jr z, .checkBTurbo
	xor A_BUTTON
.checkBTurbo:
	bit BIT_B_BUTTON, a
	jr z, .doneTurbo
	xor B_BUTTON
	jr .doneTurbo
.noTurbo:
	ld a, b
.doneTurbo:

	ld b, a
	ld a, [hJoyLast]
	ld e, a
	xor b
	ld d, a
	and e
	ld [hJoyReleased], a
	ld a, d
	and b
	ld [hJoyPressed], a
	ld a, b
	ld [hJoyLast], a

	ld a, [wd730]
	bit 5, a
	jr nz, DiscardButtonPresses

	ld a, [hJoyLast]
	ld [hJoyHeld], a

	ld a, [wJoyIgnore]
	and a
	ret z

	cpl
	ld b, a
	ld a, [hJoyHeld]
	and b
	ld [hJoyHeld], a
	ld a, [hJoyPressed]
	and b
	ld [hJoyPressed], a
	ret

DiscardButtonPresses:
	xor a
	ld [hJoyHeld], a
	ld [hJoyPressed], a
	ld [hJoyReleased], a
	ret

TrySoftReset:
	call DelayFrame

	; deselect (redundant)
	ld a, $30
	ld [rJOYP], a

	ld hl, hSoftReset
	dec [hl]
	jp z, SoftReset

	jp Joypad
