TARGET_DIR = bin
TARGET_EXEC = App

BUILD_DIR ?= build
INCLUDE_DIR ?= include
SRC_DIR ?= src

# SRCS := $(shell find $(SRC_DIRS) -name *.cpp -or -name *.c -or -name *.s)
SRCS := $(shell find $(SRC_DIR) -name *.cpp)
OBJS := $(SRCS:%=$(BUILD_DIR)/%.o)
DEPS := $(OBJS:.o=.d)

INC_DIRS := $(shell find $(SRC_DIR) -type d)
INC_DIRS += $(shell find $(INCLUDE_DIR) -type d)
INC_FLAGS := $(addprefix -I,$(INC_DIRS))

DEBUG ?= 0

ifeq ($(DEBUG), 1)
    CPP_DEBUG_FLAG=-DDEBUG
	CXX_DEBUG_FLAG=-g
	TARGET_EXEC = AppDebug
endif

# pkg-config --libs glfw3 glew
# pkg-config --static --libs glfw3 glew
OPENGL_FLAGS=-lglfw -lrt -lm -ldl -lXrandr -lXinerama -lXi -lXcursor -lXrender -lGLEW -lGLU -lGL -lpthread -pthread -ldrm -lXdamage -lXfixes -lX11-xcb -lxcb-glx -lxcb-dri2 -lXxf86vm -lXext -lX11 -lxcb -lXau -lXdmcp

LIBS_FLAGS=$(OPENGL_FLAGS)

# CC=gcc-9
CXX=g++-9
CPPFLAGS ?=$(INC_FLAGS) -MMD -MP $(CPP_DEBUG_FLAG)
CXXFLAGS ?=-std=c++17 -Wall $(CXX_DEBUG_FLAG)

$(TARGET_DIR)/$(TARGET_EXEC): $(OBJS)
	${MKDIR_P} ${TARGET_DIR}
	$(CXX) $(OBJS) -o $@ $(LIBS_FLAGS)

# # assembly
# $(BUILD_DIR)/%.s.o: %.s
# $(MKDIR_P) $(dir $@)
# $(AS) $(ASFLAGS) -c $< -o $@

# # c source
# $(BUILD_DIR)/%.c.o: %.c
# $(MKDIR_P) $(dir $@)
# $(CC) $(CPPFLAGS) $(CFLAGS) -c $< -o $@

# c++ source
$(BUILD_DIR)/%.cpp.o: %.cpp
	$(MKDIR_P) $(dir $@)
	$(CXX) $(CPPFLAGS) $(CXXFLAGS) -c $< -o $@

.PHONY: clean

clean:
	$(RM) -r $(BUILD_DIR)

-include $(DEPS)

MKDIR_P ?= mkdir -p