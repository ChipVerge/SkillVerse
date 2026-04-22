# Introduction to Makefile

## What is Makefile?
A Makefile is a special file, containing shell commands, that you create and name `Makefile` or `makefile`. It is used by the `make` utility to automate the process of building and managing dependencies in software projects. Makefiles are particularly useful in large projects where managing the compilation process manually would be cumbersome and error-prone.

## History and Importance of Makefile
Makefile was introduced in 1976 as part of the Unix operating system. It was created to address the need for a tool that could automatically determine which pieces of a program need to be recompiled and issue the commands to recompile them. Over the years, Makefile has become an essential tool in the software development process, especially in Unix-based environments.

## Basic Syntax and Structure
A Makefile consists of a set of rules. Each rule defines how to build a target from its dependencies. The basic syntax of a rule is as follows:

```
target: dependencies
    command
```

- **target**: The file or thing that is to be built.
- **dependencies**: The files that the target depends on.
- **command**: The shell command to build the target.

### Example
Here is a simple example of a Makefile:

```makefile
# This is a comment
all: program

program: main.o utils.o
    gcc -o program main.o utils.o

main.o: main.c
    gcc -c main.c

utils.o: utils.c
    gcc -c utils.c

clean:
    rm -f program main.o utils.o
```

In this example:
- The `all` target depends on `program`.
- The `program` target depends on `main.o` and `utils.o`.
- The `main.o` target depends on `main.c`.
- The `utils.o` target depends on `utils.c`.
- The `clean` target is a phony target used to remove the compiled files.

## Simple Makefile Example
Let's break down the example step by step:

1. **all: program**
   - This is the default target. When you run `make` without any arguments, it will build the `program` target.

2. **program: main.o utils.o**
   - The `program` target depends on `main.o` and `utils.o`. The command `gcc -o program main.o utils.o` will be executed to create the `program` executable.

3. **main.o: main.c**
   - The `main.o` target depends on `main.c`. The command `gcc -c main.c` will compile `main.c` into `main.o`.

4. **utils.o: utils.c**
   - The `utils.o` target depends on `utils.c`. The command `gcc -c utils.c` will compile `utils.c` into `utils.o`.

5. **clean:**
   - The `clean` target does not depend on any files. The command `rm -f program main.o utils.o` will remove the compiled files.

## Simple Exercise
Create a Makefile for a simple project with the following files:
- `main.c`
- `utils.c`

The Makefile should:
1. Compile `main.c` and `utils.c` into object files.
2. Link the object files to create an executable named `program`.
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

