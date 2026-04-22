# Advanced Makefile Features

## Include Directive
The `include` directive is used to include other Makefiles. This is useful for splitting large Makefiles into smaller, more manageable files.

### Example
```makefile
include common.mk
```

In this example:
- `common.mk` is another Makefile that is included.

## Makefile Functions
Makefile provides several built-in functions that can be used to manipulate variables and perform various tasks.

### Example
```makefile
SRC = main.c utils.c
OBJ = $(SRC:.c=.o)
```

In this example:
- The `$(SRC:.c=.o)` function replaces `.c` with `.o` in the `SRC` variable.

## Conditional Directives
Conditional directives are used to conditionally include parts of a Makefile based on the value of variables.

### Example
```makefile
DEBUG = true

ifeq ($(DEBUG), true)
    CFLAGS += -g
endif
```

In this example:
- The `ifeq` directive checks if the `DEBUG` variable is set to `true`.
- If `DEBUG` is `true`, the `-g` flag is added to the `CFLAGS` variable.

## Overriding and Appending Variables
Variables in Makefile can be overridden and appended to using the `override` and `+=` operators.

### Example
```makefile
CFLAGS = -Wall

override CFLAGS += -O2
```

In this example:
- The `override` directive is used to override the `CFLAGS` variable.
- The `+=` operator is used to append `-O2` to the `CFLAGS` variable.

## Simple Exercise
Create a Makefile that uses advanced features to compile the following files:
- `main.c`
- `utils.c`

The Makefile should:
1. Include another Makefile using the `include` directive.
2. Use conditional directives to add debug flags.
3. Override and append variables.

### Solution
#### common.mk
```makefile
CC = gcc
CFLAGS = -Wall
SRC = main.c utils.c
OBJ = $(SRC:.c=.o)
```

#### Makefile
```makefile
include common.mk

DEBUG = true

ifeq ($(DEBUG), true)
    CFLAGS += -g
endif

override CFLAGS += -O2

all: program

program: $(OBJ)
    $(CC) $(CFLAGS) -o program $(OBJ)

%.o: %.c
    $(CC) $(CFLAGS) -c $< -o $@

clean:
    rm -f program $(OBJ)
```


##### Copyright (c) 2026 ChipVerge

