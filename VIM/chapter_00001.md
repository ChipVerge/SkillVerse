# Vi IMproved (VIM)


## Introduction

Vim, which stands for "Vi Improved", is a highly configurable text editor built to enable efficient text editing. It is an improved version of the vi editor distributed with most UNIX systems. Vim is often called a "programmer's editor," and so useful for programming that many consider it an entire IDE.

Here are some key features of Vim:

1. **Modal Editing**: Vim operates in various modes, with the most commonly used ones being: normal, insert, and visual. Each mode has a different purpose and allows different kinds of commands.
2. **Efficiency**: Vim provides a multitude of keyboard shortcuts and commands that allow for fast navigation and editing.
3. **Extensibility**: Vim can be customized and extended using scripts and plugins. There are many plugins available that can add extra functionality to Vim.
4. **Ubiquity**: Vim is available on almost all modern operating systems, making it a reliable choice for developers.

## Install
```bash
sudo apt update
sudo apt-get -y install vim
```

## Simple Exercise

**Basic Navigation**
- Open a file in Vim.
- Move the cursor to the end of the file using `G`.
- Move the cursor to the beginning of the file using `gg`.
- Move the cursor to the end of the line using `$`.
- Move the cursor to the beginning of the line using `0`.

**Editing Text**
- Enter insert mode using `i` and type a sentence.
- Save the changes and exit using `:wq`.
- Open the file again and delete a word using `dw`.
- Undo the change using `u`.
- Redo the change using `Ctrl + r`.

**Searching Text**
- Search for a word in the file using `/word`.
- Navigate to the next occurrence of the word using `n`.
- Navigate to the previous occurrence of the word using `N`.

**Copy and Paste**
- Copy a line using `yy`.
- Paste the line below the cursor using `p`.
- Paste the line above the cursor using `P`.

**File and Window Operations**
- Split the window horizontally using `:split`.
- Split the window vertically using `:vsplit`.
- Navigate between windows using `Ctrl + w` followed by the arrow key.

**Advanced Editing**
- Replace a word using `cw` and then type the new word.
- Replace a character under the cursor using `r` and then type the new character.
- Replace the entire line using `cc` and then type the new line.

**Visual Mode**
- Enter visual mode using `v`.
- Select some text using the arrow keys.
- Copy the selected text using `y`.
- Paste the copied text using `p`.

**Buffers and Tabs**
- Open a new file in a new buffer using `:e filename`.
- Switch between buffers using `:bn` and `:bp`.
- Open a new file in a new tab using `:tabe filename`.
- Switch between tabs using `gt` and `gT`.

**Macros**
- Start recording a macro using `q` followed by a letter to name the macro.
- Perform some actions.
- Stop recording using `q`.
- Play the macro using `@` followed by the name of the macro.

**Customizing Vim**
- Open your vimrc file using `:e ~/.vimrc`.
- Add a new setting, for example, `set number` to display line numbers.
- Save and exit using `:wq`.
- Reload Vim or your vimrc file using `:source ~/.vimrc`.

**Block Selection and Editing**
- Enter visual block mode using `Ctrl + v`.
- Select a block of text using the arrow keys.
- Change the selected text using `c`, then type the new text and hit `Esc`.

**Regular Expressions**
- Search for a pattern in the file using `/pattern`.
- Replace the pattern using `:%s/pattern/replacement/g`.

**Folding**
- Create a fold using `zf` followed by a motion command, like `zf2j` to fold the next two lines.
- Open a fold using `zo`.
- Close a fold using `zc`.

**Command-line Mode**
- Enter command-line mode using `:`.
- Execute a shell command using `:!command`.

**Marks**
- Set a mark using `m` followed by a letter.
- Jump to a mark using `'` followed by the letter.

**Spell Checking**
- Enable spell checking using `:set spell`.
- Navigate to the next misspelled word using `]s`.
- Navigate to the previous misspelled word using `[s`.
- Suggest corrections for a misspelled word using `z=`.

## Study Materials

### Cursor movement
|Command| Description|
|-|-|
| h | move left |
| j | move down |
| k | move up |
| l | move right |
| w | jump by start of words (punctuation considered words) |
| W | jump by words (spaces separate words) |
| e | jump to end of words (punctuation considered words) |
| E | jump to end of words (no punctuation) |
| b | jump backward by words (punctuation considered words) |
| B | jump backward by words (no punctuation) |
| 0 | (zero) start of line |
| ^ | first non-blank character of line |
| $ | end of line |
| G | Go To command (prefix with number) |
| Note: | Prefix a cursor movement command with a number to repeat it. For example, 4j moves down 4 lines. |
| Insert | Mode Inserting/Appending text |
| i | start insert mode at cursor |
| I | insert at the beginning of the line |
| a | append after the cursor |
| A | append at the end of the line |
| o | open (append) blank line below current line (no need to press return) |
| O | open blank line above current line |
| ea | append at end of word |
| Esc | exit insert mode |

### Editing
|Command| Description|
|-|-|
| r | replace a single character (does not use insert mode) |
| J | join line below to the current one |
| cc | change (replace) an entire line |
| cw | change (replace) to the end of word |
| c$ | change (replace) to the end of line |
| s | delete character at cursor and subsitute text |
| S | delete line at cursor and substitute text (same as cc) |
| xp | transpose two letters (delete and paste, technically) |
| u | undo |
| . | repeat last command |

### Marking text (visual mode)
|Command| Description|
|-|-|
| v | start visual mode, mark lines, then do command (such as y-yank) |
| V | start Linewise visual mode |
| o | move to other end of marked area |
| Ctrl+v | start visual block mode |
| O |move to Other corner of block |
| aw | mark a word |
| ab | a () block (with braces) |
| aB | a {} block (with brackets) |
| ib | inner () block |
| iB | inner {} block |
| Esc | exit visual mode |

### Visual commands
|Command| Description|
|-|-|
| > | shift right |
| < | shift left |
| y | yank (copy) marked text |
| d | delete marked text |
| ~ | switch case |
| Cut | and Paste |
| yy | yank (copy) a line |
| 2yy | yank 2 lines |
| yw | yank word |
| y$ | yank to end of line |
| p | put (paste) the clipboard after cursor |
| P | put (paste) before cursor |
| dd | delete (cut) a line |
| dw | delete (cut) the current word |
| x | delete (cut) current character |

### Exiting
|Command| Description|
|-|-|
| :w | write (save) the file, but don't exit |
| :wq | write (save) and quit |
| :q | quit (fails if anything has changed) |
| :q! | quit and throw away changes |

### Search/Replace
|Command| Description|
|-|-|
| /pattern | search for pattern |
| ?pattern | search backward for pattern |
| n | repeat search in same direction |
| N | repeat search in opposite direction |
| :%s/old/new/g | replace all old with new throughout file |
| :%s/old/new/gc | replace all old with new throughout file with confirmations |

### Working with multiple files
|Command| Description|
|-|-|
| :e | filename Edit a file in a new buffer |
| :bnext (or :bn) | go to next buffer |
| :bprev (of :bp) | go to previous buffer |
| :bd | delete a buffer (close a file) |
| :sp | filename Open a file in a new buffer and split window |
| ctrl+ws | Split windows |
| ctrl+ww | switch between windows |
| ctrl+wq | Quit a window |
| ctrl+wv | Split windows vertically |

Source: http://www.keyxl.com/aaa8263/290/VIM-keyboard-shortcuts.htm

##### Copyright (c) 2026 ChipVerge

