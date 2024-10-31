# My bash startup files

Can't believe it took me so long to put these in git. All I had to do was move them out of $HOME.

## How it's loaded by bash

My `.bash_profile` is now just a single line:

```
source ~/src/bash/bashrc
```

## "RC"?

Why the "bashrc" name? It's just an ancient Unix convention (pre-dating Unix even):

> The ‘rc’ suffix goes back to Unix's grandparent, CTSS. 
> It had a command-script feature called "runcom". 
> Early Unixes used ‘rc’ for the name of the operating system's boot script, as a tribute to CTSS runcom.
