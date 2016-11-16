# vag

vag is global command when vagrant name is default.
only zsh can be used now.

## example

### 1. check id
```
% vagrant global-status
id       name         provider   state    directory
--------------------------------------------------------------------------------------------------
69a5989  default      virtualbox saved    /Users/UserName/Dir/Project1
ac92051  default      virtualbox saved    /Users/UserName/Dir/Project2
329e845  default      virtualbox saved    /Users/UserName/Dir/Project3
dfecadf  default      virtualbox saved    /Users/UserName/Dir/Project4
44bf64d  default      virtualbox saved    /Users/UserName/Dir/Project5

% vim ~/.zshrc
```

### 2. set associative array

```zsh:~/.zshrc
typeset -A vagrant_name
vagrant_name=( \
  Project1 69a5989 \
  Project2 ac92051 \
  Project3 329e845 \
  Project4 dfecadf \
  Project5 44bf64d
)
```

### 3. execute

```zsh
% exec $SHELL
% vup Project1
% vssh Project1

% vsu Project1
% vh Project1
```