# Project Name (executable)
PROJECT = libqcmc.so
# Compiler
CC = g++

# Run Options       
COMMANDLINE_OPTIONS = #/dev/ttyS0

# Compiler options during compilation
COMPILE_OPTIONS = -O3 -std=c++2a -w -shared -Wall -Wextra -DHAVE_CONFIG_H
# -ansi -pedantic -Wall 

#Header include directories
HEADERS = -I. -I.~/Downloads/Setup/boost_1_80_0/ -I.cflobdd/CFLOBDD -I.cflobdd/CFLOBDD/Solver/uwr/bit_vector/ -I.cflobdd/CFLOBDD/Solver/uwr/assert/ -I.cflobdd/CFLOBDD/Solver/uwr/matrix/ -I.cflobdd/CFLOBDD/Solver/uwr/parsing/ -I.cflobdd/cudd-complex-big/ -I.cflobdd/cudd-complex-big/cudd -I.cflobdd/cudd-complex-big/mtr -I.cflobdd/cudd-complex-big/epd -I.cflobdd/cudd-complex-big/st
#Libraries for linking
LIBS = cflobdd/cudd-complex-big/cplusplus/.libs/libobj.a cflobdd/cudd-complex-big/cudd/.libs/libcudd.a -lgmp -lmpfr -lgmpxx 

# Dependency options
DEPENDENCY_OPTIONS = -MM

#-- Do not edit below this line --

# Subdirs to search for additional source files
SOURCE_FILES := $(shell ls *.cpp)
SOURCE_FILES += $(shell ls cflobdd/CFLOBDD/Solver/uwr/bit_vector/*.cpp)
SOURCE_FILES += $(shell ls cflobdd/CFLOBDD/Solver/uwr/parsing/*.cpp)
SOURCE_FILES += $(shell find cflobdd/CFLOBDD -maxdepth 1 -mindepth 1 -name \*.cpp -a -not -name main.cpp)
# [SOURCE_FILES] -= $(shell ls cflobdd/CFLOBDD/main.cpp)
# $(info $(SOURCE_FILES))

# Create an object file of every cpp file
OBJECTS = $(patsubst %.cpp, %.o, $(SOURCE_FILES))

# Dependencies
DEPENDENCIES = $(patsubst %.cpp, %.d, $(SOURCE_FILES))

# Create .d files
%.d: %.cpp
	$(CC) $(DEPENDENCY_OPTIONS) $< -MT "$*.o $*.d" -MF $*.d

dep:
	cd cflobdd/cudd-complex-big && make all && cd ../../

# Make $(PROJECT) the default target
all: $(PROJECT)
#$(DEPENDENCIES) -shared 
$(PROJECT): $(OBJECTS)
	$(CC) -shared -o $(PROJECT) $(OBJECTS) $(LIBS)

# Include dependencies (if there are any)
# ifneq "$(strip $(DEPENDENCIES))" ""
#   include $(DEPENDENCIES)
# endif

# Compile every cpp file to an object
# %.cpp 
%.o: %.cpp
	$(CC) -c $(COMPILE_OPTIONS) -o $@ $^ $(HEADERS)

# Build & Run Project
run: $(PROJECT)
	./$(PROJECT) $(COMMANDLINE_OPTIONS)

# Clean & Debug
.PHONY: makefile-debug
makefile-debug:

.PHONY: clean
clean:
	rm -f $(PROJECT) $(OBJECTS)

.PHONY: depclean
depclean:
	rm -f $(DEPENDENCIES)

clean-all: clean depclean