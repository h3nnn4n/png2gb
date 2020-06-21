TARGET = $(notdir $(CURDIR))
BUILDDIR = $(abspath $(CURDIR)/build)

INCLUDES = -Isrc \

OPTIMIZATION = -O3

CPPFLAGS = $(OPTIMIZATION) $(INCLUDES)
CFLAGS = $(OPTIMIZATION) $(INCLUDES)

UNAME_S := $(shell uname -s)
ifeq ($(UNAME_S),Linux)
	ECHOFLAGS = -e
endif
ifeq ($(UNAME_S),Darwin)
	ECHOFLAGS =
	CFLAGS += -Wno-unused-command-line-argument
	CPPFLAGS += -Wno-unused-command-line-argument -Wno-mismatched-tags
endif

CC = gcc
CXX = g++

C_FILES := $(wildcard src/*.c)
CPP_FILES := $(wildcard src/*.cpp)

SOURCES := $(CPP_FILES:.cpp=.o) \
					 $(C_FILES:.c=.o)

OBJS := $(foreach src,$(SOURCES), $(BUILDDIR)/$(src))

all: build

build: $(TARGET)

rebuild: clean $(TARGET)

$(BUILDDIR)/%.o: %.c
	@mkdir -p "$(dir $@)"
	$(CC) $(CFLAGS) -o "$@" -c "$<"

$(BUILDDIR)/%.o: %.cpp
	@mkdir -p "$(dir $@)"
	$(CXX) $(CPPFLAGS) -o "$@" -c "$<"

$(TARGET): $(OBJS)
	$(CXX) -o "$@" $(OBJS)

-include $(OBJS:.o=.d)

clean:
	rm -rf "$(BUILDDIR)/src/"
	rm -f "$(TARGET).o"
