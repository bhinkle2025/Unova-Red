ReadJoypad::
; Poll joypad input.
; Unlike the hardware register, button
; presses are indicated by a set bit.

	ld a, 1 << 5 ; select direction keys
	ld c, 0

	ld [rJOYP], a
	rept 6
	ld a, [rJOYP]
	endr
	cpl
	and %1111
	swap a
	ld b, a

	ld a, 1 << 4 ; select button keys
	ld [rJOYP], a
	rept 10
	ld a, [rJOYP]
	endr
	cpl
	and %1111
	or b

	ld [hJoyInput], a

	ld a, 1 << 4 + 1 << 5 ; deselect keys
	ld [rJOYP], a
	ret

Joypad::
; Update the joypad state variables:
; [hJoyReleased]  keys released since last time
; [hJoyPressed]   keys pressed since last time
; [hJoyHeld] currently pressed keys
	homecall _Joypad
	ld a, [hSelectHoldTimer]
	cp 15  ; Used by the hSelectHoldTimer for bike shortcut
	ret nc
	ld a, [hJoyReleased]
	bit BIT_SELECT, a
	ret z
	ld hl, wFontLoaded
	bit 1, [hl]
	jr z, .setTurbo
	res 1, [hl]
	ret
.setTurbo
	set 1, [hl]
	ret
