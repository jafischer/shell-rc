# My bash/zsh startup files

Welcome to my shell startup files. These files represent decades of tweaking
and refining -- I've been using Unix off and on since 1985. Although
originally of course it was just the Bourne shell (`sh`). I even used `csh`
for a while, but settled on bash, probably in the post-Linux timeframe.

I got tired of copying these files around to every new machine, so I finally put
them all in git. Can't believe it took me so long... all I had to do was move
them out of $HOME.

My `.bash_profile` and `.zshrc` now contain just a single line:

```
source ~/mysrc/shell-rc/main
```

Speaking of zsh, now that Apple has forced zsh on new Mac users, I spent some
time ensuring everything here also works in zsh. But after that initial effort,
I've switched back to bash, so it's possible that later updates may break
something in zsh.

## Feel Free to Use This

You can git clone (or fork) this repo, and add a similar `source` statement
to your own shell startup file.

I've taken great pains to make this as general-purpose as possible, but of
course there are some things that are going to be different for every user.
To this end, anything custom goes in a file called `.personalized` in this
directory. You can use the [personalized](personalized) file (without the
leading `.`) as a template.

Just in case there might be something proprietary or confidential in
`.personalized`, I've added it to [.gitignore](.gitignore).

## Learning Tool

I've also tried to make this as easy-to-follow as possible, documenting
everything. So I would recommend that you start with [main](main), just reading
it top to bottom to see what it does; then have a look at the aliases in
[aliases](aliases) and the functions in [functions](functions).

But it isn't meant to be a tutorial on bash (or zsh) itself. There are many
good resources out there. You might want to check out Dave Eddy's excellent
["You Suck at Programming"](https://ysap.sh/).

## 3rd-Party Tools

If any of the functions or aliases rely on a custom utility that I've installed,
I try to remember to prefix it with an `is_installed` test to see if it's
installed.

Here is a list of such utilities:

- `eza`, a "modern replacement for ls" (https://github.com/eza-community/eza)
- `bat`, an enhanced "cat" (https://github.com/sharkdp/bat)
- `gdate` (GNU date), which adds millisecond resolution (e.g.
  `gdate +%H:%M:%S.%3N`).
  <br>`brew install coreutils` to install.
- MacVim (https://macvim.org/)

## "RC"?

Ever wondered, what's with all the files ending in "rc" in Linux? It's just an
ancient Unix convention (pre-dating Unix even):

> The ‘rc’ suffix goes back to Unix's grandparent, CTSS.
> It had a command-script feature called "runcom".
> Early Unixes used ‘rc’ for the name of the operating system's boot script,
> as a tribute to CTSS runcom.
