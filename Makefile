##
# Copyright (c) Project Iota
#
# uCbor is licensed under an Apache license, version 2.0 license.
# All rights not explicitly granted in the Apache license, version 2.0 are reserved.
# See the included LICENSE file for more details.
##

JSMNDIR = ./jsmn

SRCDIR = src
INCDIR = inc
OBJDIR = obj

SRC = $(wildcard $(SRCDIR)/*.c)
INC = $(wildcard $(INCDIR)/*.h)

JSMNSRC = $(wildcard $(JSMNDIR)/*.c)
JSMNINC = $(wildcard $(JSMNDIR)/*.h)
 
OBJ = $(SRC:$(SRCDIR)/%.c=$(OBJDIR)/erpc/%.o)
JSMNOBJ = $(JSMNSRC:$(JSMNDIR)/%.c=$(OBJDIR)/jsmn/%.o)

TARGET = liberpc.a
 
CC := gcc
CFLAGS = -Wall -W -O
LIBS =
LDFLAGS = $(LIBS:%=-l%)

all: $(TARGET)

$(TARGET): $(OBJ) $(JSMNOBJ)
	$(AR) rc $@ $^
 
$(OBJ): $(OBJDIR)/erpc/%.o : $(SRCDIR)/%.c 
	mkdir -p $(OBJDIR)/erpc
	$(CC) $(CFLAGS) -I$(INCDIR) -I$(JSMNDIR) -c -o $@ $<

$(JSMNOBJ): $(OBJDIR)/jsmn/%.o : $(JSMNDIR)/%.c 
	mkdir -p $(OBJDIR)/jsmn
	$(CC) $(CFLAGS) -I$(JSMNDIR) -c -o $@ $<

test: $(OBJDIR)/examples/test.o
	$(CC) $(LDFLAGS) $^ -o $@ -lerpc -L.

$(OBJDIR)/examples/test.o: examples/test.c
	mkdir -p $(OBJDIR)/examples
	$(CC) $(CFLAGS) -I$(INCDIR) -I$(JSMNDIR) -c -o $@ $<
 
.PHONY : clean
clean:
	rm -rf $(TARGET) $(OBJDIR) liberpc.a test

print-%: ; @$(error $* is $($*))

