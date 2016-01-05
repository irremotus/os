SRCDIR := src
BINDIR := bin
OBJDIR := obj
INCDIR := include

CXX := g++
CC := gcc
ASM := nasm

CXXFLAGS := -g -Wall -std=c++11 -I$(INCDIR)
CCFLAGS := -g -Wall -I$(INCDIR)
ASMFLAGS := -I$(SRCDIR)/


# Edit the below lists to add binaries and objects

# List of projects (binaries) to make by default, run 'make binaryname' to make a non-default one from the list below
PROJS := boot stage2 sector2

# List of binaries that can be made, and the objects they each need

# binname1 := obj1 obj2 obj3
# binname2 := obj1 obj3 obj4
boot := boot
stage2 := stage2
sector2 := sector2.asm

makedisk:
	./createdisk.sh
	./lo.sh
	./formatdisk.sh
	./copyboot.sh
	#./copystage2.sh
	./unlo.sh

full: all makedisk

run: full
	qemu-system-i386 disk.img

runonly:
	qemu-system-i386 disk.img

# Custom clean commands to be automatically executed when 'make clean' is run
userclean: 
	rm -f disk.img



# ----- DON'T EDIT BELOW HERE -----

# So that we can find .h and .cpp files as prereqs
vpath %.h $(INCDIR)
vpath %.c $(SRCDIR)
vpath %.cpp $(SRCDIR)
vpath %.asm $(SRCDIR)

# Format PROJS correctly to be valid targets
_PROJ_TARGETS := $(addprefix $(BINDIR)/, ${PROJS})

# Make all the binaries in $(_PROJ_TARGETS)
.DEFAULT_GOAL := all
.PHONY: all
all: folders $(_PROJ_TARGETS)

.PHONY: folders
folders:
	@if [ ! -d "$(BINDIR)" ]; then mkdir -p $(BINDIR) && echo "mkdir -p $(BINDIR)"; fi
	@if [ ! -d "$(OBJDIR)" ]; then mkdir -p $(OBJDIR) && echo "mkdir -p $(OBJDIR)"; fi

# Makes '$(BINDIR)/binaryname' with prerequisites: '$(OBJDIR)/prereqname.o'.  Prereq names come from expanding the variable named like binaryname
# $$($$(*F)) expands (with second expansion) to the names of the needed prereqs. $(*F) expands to the target name without directory. $($(*F)) in effect expands the variable named *F
.SECONDEXPANSION:
$(BINDIR)/%: $$(addprefix $(OBJDIR)/, $$(addsuffix .o, $$($$(*F))))
	$(CXX) $(CXXFLAGS) -o $(BINDIR)/$* $^

# Secondary to prevent auto deletion of .o files
# CXX objects
.SECONDARY:
$(OBJDIR)/%.o : %.cpp %.h
	$(CXX) $(CXXFLAGS) -c -o $@ $<
# C objects
.SECONDARY:
$(OBJDIR)/%.o : %.c %.h
	$(CC) $(CFLAGS) -c -o $@ $<

# ASM binaries
.SECONDARY:
$(BINDIR)/% : %.asm
	$(ASM) $(ASMFLAGS) -o $@ $<

# Make '$(BINDIR)/targetname' when 'make targetname' is invoked
.DEFAULT:
	$(MAKE) $(BINDIR)/$@

# Disable built-in suffix rules
.SUFFIXES:

.PHONY: clean
clean: userclean
	rm -rf $(OBJDIR) $(BINDIR)
