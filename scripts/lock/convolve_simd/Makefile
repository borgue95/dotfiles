CC			= gcc

OUTDIR		= build
BINARY		= $(OUTDIR)/convolve_simd

# ############################################################################

CFLAGS		=
CFLAGS		+= -O2 -mavx

INCLUDES	=
INCLUDES	+= -I .

LIBRARIES	=
LIBRARIES	+= -L/usr/lib/time_utils -ltimeutils
LIBRARIES   += -L/usr/lib/png_manager -lpngm # libpngm.a depends on libpng.a
LIBRARIES	+= -lpng 
LIBRARIES	+= -lm 

# ############################################################################

SOURCES		= $(shell find . -name '*.c'| grep -e ".*.c")
OBJECTS		= $(SOURCES:%.c=$(OUTDIR)/%.o)

# ############################################################################

all: directories $(BINARY)

$(BINARY): $(OBJECTS)
	$(CC) $^ -o $@ $(LIBRARIES)
		
$(OBJECTS): $(OUTDIR)/%.o: %.c
	mkdir -p $(@D)
	$(CC) $(INCLUDES) $(CFLAGS) -c $< -o $@
	
# ############################################################################

.PHONY: directories
directories:
	mkdir -p $(OUTDIR)

.PHONY: clean
clean:
	rm -rf $(OUTDIR)
