ifneq ($(wildcard rgbds/.*),)
RGBDS_DIR = rgbds/
else
RGBDS_DIR =
endif

PYTHON := python3
MD5 := md5sum -c --quiet

2bpp     := $(PYTHON) -m extras.pokemontools.gfx 2bpp
1bpp     := $(PYTHON) -m extras.pokemontools.gfx 1bpp
pic      := $(PYTHON) -m extras.pokemontools.pic compress
includes := $(PYTHON) -m extras.pokemontools.scan_includes

unovared_obj := audio_red.o main_red.o text_red.o wram_red.o
unovablue_obj := audio_blue.o main_blue.o text_blue.o wram_blue.o

.SUFFIXES:
.SUFFIXES: .asm .o .gbc .png .2bpp .1bpp .pic
.SECONDEXPANSION:
# Suppress annoying intermediate file deletion messages.
.PRECIOUS: %.2bpp
.PHONY: all clean red blue compare

roms := unovared.gbc unovablue.gbc

all: $(roms)
red: unovared.gbc
blue: unovablue.gbc

# For contributors to make sure a change didn't affect the contents of the rom.
compare: red blue
	@$(MD5) roms.md5

clean:
	rm -f $(roms) $(unovared_obj) $(unovablue_obj) $(roms:.gbc=.sym)
	find . \( -iname '*.1bpp' -o -iname '*.2bpp' -o -iname '*.pic' \) -exec rm {} +

%.asm: ;

%_red.o: dep = $(shell $(includes) $(@D)/$*.asm)
$(unovared_obj): %_red.o: %.asm $$(dep)
	$(RGBDS_DIR)rgbasm -D _RED -h -o $@ $*.asm

%_blue.o: dep = $(shell $(includes) $(@D)/$*.asm)
$(unovablue_obj): %_blue.o: %.asm $$(dep)
	$(RGBDS_DIR)rgbasm -D _BLUE -h -o $@ $*.asm

unovared_opt  = -jsv -k 01 -l 0x33 -m 0x13 -p 0 -r 03 -t "POKEMON RED"
unovablue_opt = -jsv -k 01 -l 0x33 -m 0x13 -p 0 -r 03 -t "POKEMON BLUE"

%.gbc: $$(%_obj)
	$(RGBDS_DIR)rgblink -m $*.map -n $*.sym -o $@ $^
	$(RGBDS_DIR)rgbfix $($*_opt) $@

%.png:  ;
%.2bpp: %.png  ; @$(2bpp) $<
%.1bpp: %.png  ; @$(1bpp) $<
%.pic:  %.2bpp ; @$(pic)  $<
