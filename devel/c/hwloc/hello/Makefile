#
# Makefile
#

HWLOC_INSTALL_DIR=/home/tjn/projects/hwloc/hwloc-1.11.8/local-install

CC=gcc
CFLAGS=-g -I$(HWLOC_INSTALL_DIR)/include
LDFLAGS=-L$(HWLOC_INSTALL_DIR)/lib
LDLIBS=-lhwloc -lpthread

RM=rm

all: hello-hwloc tst-thrdbind

hello-hwloc: hello-hwloc.c
	$(CC) $(CFLAGS) $(LDFLAGS) hello-hwloc.c -o hello-hwloc $(LDLIBS)

tst-thrdbind: tst-thrdbind.c
	$(CC) $(CFLAGS) $(LDFLAGS) tst-thrdbind.c -o tst-thrdbind $(LDLIBS)

clean:
	$(RM) -f *.o
	$(RM) -f hello-hwloc
	$(RM) -f tst-thrdbind
