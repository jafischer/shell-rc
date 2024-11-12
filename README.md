# My bash startup files

I got tired of copying these files around to every new machine, so I finally put
them all in git. Can't believe it took me so long... all I had to do was move
them out of $HOME.

My `.bash_profile` is now just a single line:

```
source ~/src/bashrc/bashrc
```

## Feel Free to Use This!

You can git clone this somewhere, and add the same `source` statement from
above to your own `.bash_profile`.

I've taken great pains to make this as general-purpose as possible. But there
are going to be a couple of things that need to be changed for each user (such
as the directories you add to PATH), and I've gone
through and marked such areas with the following comment:

```
### PERSONALIZE THIS
```

## The Most Important Bash Customization

What's the first thing you do every time you launch the Terminal app?

Usually you have to type in a long `cd` command to get to where you want to go:

```bash
cd Documents/work/github/some-long-repo-name/helm-unified/same-dang-repo-name/omg-are-we-done-yet
```
So much typing!

In Finder you can mark directories as Favorite, and then they're always there,
just one click away. Well the good news is that you can do something similar
in the shell.

### CDPATH

The first thing that will help with this: set up a `CDPATH` environment
variable. It's just like `PATH`, but for directories. 

Imagine if I had to type `/Library/Java/JavaVirtualMachines/current/Contents/Home/bin/java`
every time I need to run the `java` command. Well of course I don't, because
`/Library/Java/JavaVirtualMachines/current/Contents/Home/bin` is one of the
directories in my `PATH` environment variable.

So in the same way, if my CDPATH is `"$HOME/src:$HOME/mysrc:$HOME/3rdparty"`,
then when I type 
```bash
cd kamaji-eliot-ness
```
I will end up in `$HOME/src/kamaji-eliot-ness`.

This saves me a bit of typing, but I'd like to do better.

### Use Heuristics!

Long story short: in the [functions](functions) script lies a function called
`mycd`, which I alias `cd` to. Have a look at it (the main guts are in
`choosedir`). It allows me to jump quickly back and forth between my many git
repos, with usually a 2 or 3 letter shortcut.

## 3rd-Party Tools

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
