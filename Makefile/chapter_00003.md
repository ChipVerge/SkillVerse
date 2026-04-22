# Targets and Dependencies

## Understanding Targets
A target is a file that Makefile generates. It can be an executable, object file, or any other file that needs to be built. Targets are specified at the beginning of a rule.

## Specifying Dependencies
Dependencies are files that a target depends on. If any of the dependencies are updated, the target will be rebuilt. Dependencies are listed after the target in a rule.

### Example
```makefile
program: main.o utils.o
    gcc -o program main.o utils.o
```

In this example:
- `program` is the target.
- `main.o` and `utils.o` are the dependencies.

## Writing Rules
Rules define how to build a target from its dependencies. Each rule consists of a target, dependencies, and commands to build the target.

### Example
```makefile
main.o: main.c
    gcc -c main.c
```

In this example:
- `main.o` is the target.
- `main.c` is the dependency.
- `gcc -c main.c` is the command to build `main.o`.

## Phony Targets
Phony targets are not actual files but are used to execute commands. They are typically used for tasks like cleaning up files.

### Example
```makefile
clean:
    rm -f program main.o utils.o
```

In this example:
- `clean` is a phony target.
- `rm -f program main.o utils.o` is the command to remove files.

## Simple Exercise
Create a Makefile that defines targets and dependencies for the following files:
- `main.c`
- `utils.c`

The Makefile should:
1. Define a target for the executable `program`.
2. Specify dependencies for each target.
3. Include a `clean` target to remove the compiled files.

### Solution
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

##### Copyright (c) 2026 ChipVerge

