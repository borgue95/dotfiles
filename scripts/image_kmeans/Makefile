HOME          = $(PWD)
EXEC          = $(HOME)/main
CC            = g++
SRC           = src/*.c src/*.cpp
CFLAGS        = -Wall -Wextra -fopenmp

UNAME := $(shell uname)

ifeq ($(UNAME), Linux)
INCL_P      = -I$(HOME)/headers
LIBS        = -lm -lOpenCL -lrt -lX11 -lpthread -L/usr/X11R6/lib
INCL_AMD    = -I$(HOME)/headers
LIBS_AMD    = $(LIBS)
CFLAGS_AMD  = $(CFLAGS)
endif

# apple
ifeq ($(UNAME), Darwin)
CC         = /usr/local/bin/g++-6
INCL_P     = -I$(HOME)/headers -I/usr/X11R6/include
LIBS       = -lm -lpthread -L/usr/X11R6/lib -lX11
INCL_AMD   = $(INCL_P) 
LIBS_AMD   = $(LIBS)
CFLAGS_AMD = $(CFLAGS)
endif

all:
	$(CC) $(CFLAGS) $(INCL_P) -c $(SRC)
	$(CC) $(CFLAGS) *.o -o $(EXEC) $(LIBS)
	rm -f *.o

amd:
	$(CC) $(CFLAGS_AMD) -c $(SRC) $(INCL_AMD) 
	$(CC) $(CFLAGS) *.o -o $(EXEC) $(LIBS_AMD)
	rm -f *.o

clean:
	rm -f *.o $(EXEC)

cleanbin:
	rm -f snapshot* image*



