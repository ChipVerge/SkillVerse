# Pattern Rules and Wildcards

## Introduction to Pattern Rules
Pattern rules are used to define rules for multiple targets that follow a specific pattern. They are useful for reducing redundancy in Makefiles.

### Example
```makefile
%.o: %.c
    gcc -c $< -o $@
```

In this example:
- `%.o` is the target pattern.
- `%.c` is the dependency pattern.
- `$<` is an automatic variable that represents the first dependency.
- `$@` is an automatic variable that represents the target.

## Using Wildcards
Wildcards are used to match multiple files with a single pattern. They are useful for specifying dependencies and targets.

### Example
```makefile
SRC = $(wildcard *.c)
OBJ = $(SRC:.c=.o)

all: program

program: $(OBJ)
    gcc -o program $(OBJ)
```

In this example:
- `$(wildcard *.c)` matches all `.c` files in the directory.
- `$(SRC:.c=.o)` replaces `.c` with `.o` in the `SRC` variable.

## Automatic Variables
Automatic variables are special variables that represent specific parts of a rule. They are useful for writing concise and flexible rules.

### Example
```makefile
%.o: %.c
    gcc -c $< -o $@
```

In this example:
- `$<` represents the first dependency.
- `$@` represents the target.

## Static Pattern Rules
Static pattern rules are used to define rules for specific targets that follow a pattern. They are useful for defining rules for a subset of files.

### Example
```makefile
objects = main.o utils.o

$(objects): %.o: %.c
    gcc -c $< -o $@
```

In this example:
- `$(objects)` is a list of targets.
- `%.o: %.c` is the pattern rule.

## Simple Exercise
Create a Makefile that uses pattern rules and wildcards to compile the following files:
- `main.c`
- `utils.c`

The Makefile should:
1. Use a wildcard to match all `.c` files.
2. Define a pattern rule to compile `.c` files into `.o` files.
3. Include a `clean` target to remove the compiled files.

### Solution
```makefile
CC = gcc
CFLAGS = -Wall -g
SRC = $(wildcard *.c)
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

