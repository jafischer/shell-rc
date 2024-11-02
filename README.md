# My bash startup files

I got tired of copying these files around to every new machine, so I finally put them all in git.
Can't believe it took me so long... all I had to do was move them out of $HOME.

My `.bash_profile` is now just a single line:

```
source ~/src/bash/bashrc
```

## Feel Free to Use This!

I've taken great pains to make this as general-use as possible, and I've gone through
and marked areas for you to modify (e.g. adding specific things you've installed to
the PATH variable) with the following comment:

```
### PERSONALIZE THIS
```

If any of the functions or aliases rely on a custom utility that I've installed, I prefix it
with a test to see if it's installed.

Here is a list of such utilities:
- `eza`, a "modern replacement for ls" (https://github.com/eza-community/eza)
- `bat`, an enhanced "cat" (https://github.com/sharkdp/bat)
- `gdate` (GNU date), which adds millisecond resolution (e.g. `gdate +%H:%M:%S.%3N`).
  <br>`brew install coreutils` to install.
- MacVim (https://macvim.org/)

## "RC"?

Why the "bashrc" name? It's just an ancient Unix convention (pre-dating Unix even):

> The ‘rc’ suffix goes back to Unix's grandparent, CTSS. 
> It had a command-script feature called "runcom". 
> Early Unixes used ‘rc’ for the name of the operating system's boot script, as a tribute to CTSS runcom.
