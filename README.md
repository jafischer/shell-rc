# My bash/zsh startup files

I got tired of copying these files around to every new machine, so I finally put
them all in git. Can't believe it took me so long... all I had to do was move
them out of $HOME.

My `.bashrc` and `.zshrc` now contain just a single line:

```
source ~/mysrc/rc/main
```

## Feel Free to Use This!

You can git clone this somewhere, and add a similar `source` statement from
above to your own shell startup file.

I've taken great pains to make this as general-purpose as possible, but there
are going to be a couple of things that need to be changed for each user (such
as the directories you add to PATH), and I've gone
through and marked such areas with the following comment:

```
### PERSONALIZE THIS
```

So, load the directory into IntelliJ (or PyCharm or any IDE) and use
Find-in-Files to go through all occurrences of `### PERSONALIZE THIS`.

## 3rd-Party Tools

If any of the functions or aliases rely on a custom utility that I've installed,
I prefix it with an `is_installed` test to see if it's installed.

Here is a list of such utilities:
- `eza`, a "modern replacement for ls" (https://github.com/eza-community/eza)
- `bat`, an enhanced "cat" (https://github.com/sharkdp/bat)
- `gdate` (GNU date), which adds millisecond resolution (e.g. `gdate +%H:%M:%S.%3N`).
  <br>`brew install coreutils` to install.
- MacVim (https://macvim.org/)

## "RC"?

Ever wondered, what's with all the files ending in "rc"? It's just an ancient
Unix convention (pre-dating Unix even):

> The ‘rc’ suffix goes back to Unix's grandparent, CTSS. 
> It had a command-script feature called "runcom". 
> Early Unixes used ‘rc’ for the name of the operating system's boot script,
> as a tribute to CTSS runcom.
