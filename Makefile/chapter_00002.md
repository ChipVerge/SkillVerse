# Variables and Functions

## Defining and Using Variables
Variables in Makefile are used to store values that can be reused throughout the Makefile. They are defined using the `=` operator and referenced using the `$(VAR_NAME)` syntax.

### Example
```makefile
CC = gcc
CFLAGS = -Wall -g

all: program

program: main.o utils.o
    $(CC) $(CFLAGS) -o program main.o utils.o

main.o: main.c
    $(CC) $(CFLAGS) -c main.c

utils.o: utils.c
    $(CC) $(CFLAGS) -c utils.c

clean:
    rm -f program main.o utils.o
```

In this example:
- `CC` is a variable that stores the compiler command `gcc`.
- `CFLAGS` is a variable that stores the compiler flags `-Wall -g`.

## Built-in Functions
Makefile provides several built-in functions that can be used to manipulate variables and perform various tasks.

### Example
```makefile
SRC = main.c utils.c
OBJ = $(SRC:.c=.o)

all: program

program: $(OBJ)
    gcc -o program $(OBJ)

clean:
    rm -f program $(OBJ)
```

In this example:
- The `SRC` variable stores the source files.
- The `OBJ` variable uses the built-in substitution function `$(SRC:.c=.o)` to replace `.c` with `.o`.

## String Manipulation Functions
Makefile includes functions for string manipulation, such as `subst`, `patsubst`, `filter`, and `filter-out`.

### Example
```makefile
SRC = main.c utils.c test.c
OBJ = $(patsubst %.c, %.o, $(SRC))
TEST_SRC = $(filter test.c, $(SRC))

all: program

program: $(OBJ)
    gcc -o program $(OBJ)

clean:
    rm -f program $(OBJ)
```

In this example:
- The `patsubst` function is used to replace `.c` with `.o` in the `SRC` variable.
- The `filter` function is used to extract `test.c` from the `SRC` variable.

## Conditional Functions
Makefile supports conditional functions such as `if`, `else`, and `endif` to control the flow of the Makefile.

### Example
```makefile
DEBUG = true

ifeq ($(DEBUG), true)
    CFLAGS += -g
endif

all: program

program: main.o utils.o
    gcc $(CFLAGS) -o program main.o utils.o

main.o: main.c
    gcc $(CFLAGS) -c main.c

utils.o: utils.c
    gcc $(CFLAGS) -c utils.c

clean:
    rm -f program main.o utils.o
```

In this example:
- The `ifeq` function checks if the `DEBUG` variable is set to `true`.
- If `DEBUG` is `true`, the `-g` flag is added to the `CFLAGS` variable.

## Simple Exercise
Create a Makefile that uses variables and built-in functions to compile the following files:
- `main.c`
- `utils.c`

The Makefile should:
1. Define variables for the compiler and flags.
2. Use a built-in function to convert source files to object files.
3. Include a `clean` target to remove the compiled files.

### Solution
```makefile
CC = gcc
CFLAGS = -Wall -g
SRC = main.c utils.c
OBJ = $(SRC:.c=.o)

all: program

program: $(OBJ)
    $(CC) $(CFLAGS) -o program $(OBJ)

%.o: %.c
    $(CC) $(CFLAGS) -c $< -o $@

clean:
    rm -f program $(OBJ)
```

##### Copyright (c) 2026 ChipVerge

