DISTDIR=./bin/
BIN=CycloTracker

OBJ=CycloTracker.o \
	VideoOutput.o \
	ImageProcessor.o \
	ObjectCounter.o \
	ObjectLocator.o \
	ObjectTracker.o \
	PointTracker.o \
	TrackedObject.o \
	Sensors.o \
	Camera.o \
	CoordTransform.o \
	Utils.o

CFLAGS=--std=c++11 \
	   -Wall \
	   -Wextra \
	   -Wpedantic \
	   -Winit-self \
	   -Wmissing-braces \
	   -Wmissing-include-dirs \
	   -Wno-return-local-addr \
	   -Wswitch-default \
	   -Wmaybe-uninitialized \
	   -Wfloat-equal \
	   -Wundef \
	   -Wzero-as-null-pointer-constant \
	   -Wmissing-declarations \
	   -Winline \
	   -g \
	   -O2 \
	   `pkg-config --cflags opencv` \
	   -Werror=c++0x-compat \
	   -pthread
# -Wshadow 
# -Wdouble-promotion //colocar em maquinas 32bits . autconf?
#  https://gcc.gnu.org/onlinedocs/gcc/Warning-Options.html

LDFLAGS=-lm \
	   `pkg-config --libs opencv` \
	   -lpthread


all:$(OBJ)
	@mkdir -p $(DISTDIR)
	@mkdir -p tmp
	g++ $(OBJ) -o $(DISTDIR)/$(BIN) $(LDFLAGS)

clean:
	rm -f $(DISTDIR)/$(BIN)
	rm -f $(OBJ)

%.o: %.cpp
	@echo CCXX $< -o $@ CFLAGS
	@g++ -c $< -o $@ $(CFLAGS)

pgo-firstpass: CFLAGS += -pg -fprofile-generate --coverage
pgo-firstpass: LDFLAGS += -pg -fprofile-generate --coverage
pgo-firstpass:all

pgo-secondpass: CFLAGS += -fprofile-correction -fprofile-use
pgo-secondpass: LDFLAGS += -fprofile-correction -fprofile-use
pgo-secondpass:all
	
.PHONY: pgo pgo-secondpass

distclean: clean
	rm -f *.gcda *.gcno *.gcov gmon.out
