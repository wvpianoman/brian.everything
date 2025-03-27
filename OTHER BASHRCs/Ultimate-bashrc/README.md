# [Extreme Ultimate `.bashrc` File](https://sourceforge.net/projects/ultimate-bashrc/files/)

### Do you want a more robust experience from your bash shell?

As a Linux systems administrator, I've been working on this `.bashrc` file for well over a decade. Over the years, I have searched through scores of `.bashrc` and script files collecting and improving on new ideas and features.

This portable drop in Bash configuration file can be used on any system anywhere you use a terminal and is designed for and safe for servers and desktop systems alike.

It will detect most settings on most systems and make sure your environment has every feature available automatically without any additional effort or configuration. That was the original purpose and intention behind it.

Want to learn shell scripting? It's also an excellent learning tool. Or take parts of this file and make your own.

> Approximately 30% of this script's lines are comments to help you understand how the script works. Actual code only takes up slightly more than half of the `.bashrc` code itself. Readability was a topmost priority during it's development.

Do you need a command line cheat sheet? Type `hlp` for full color help! Then press Q (or Escape) to quit. If you have a terminal web browser (for `README.html`) like [lynx](https://www.geeksforgeeks.org/using-lynx-to-browse-the-web-from-the-linux-terminal/), [elinks](https://wiki.archlinux.org/title/ELinks), [w3m](https://w3m.sourceforge.net/), [links2](http://www.aboutlinux.info/2007/02/links2-cross-platform-console-based-web.html), [links](https://www.tecmint.com/command-line-web-browsers/) or [`glow` (for README.md)](https://github.com/charmbracelet/glow) (for `README.md`) installed and the appropriate README file downloaded (in either your home directory or in `~/.config/bashrc/`), the `readme` command will display this page in the terminal. This can be helpful for command or configuration reference.

And since there are so many new commands and aliases, the `a` command can be quite useful since you can search for text inside any alias name, alias code, or function name. For example, to find commands for services you could type `a service`.

I think this is the most amazing and ultimate `.bashrc` file I have ever seen, and I wanted to share it.

My original previous version was [released in 2014](https://www.linuxquestions.org/questions/linux-general-1/ultimate-prompt-and-bashrc-file-4175518169/). Others have contributed and made changes to it and even that older version of the `extract` function wound up in the default `.bashrc` for earlier versions of Manjaro. If you liked the older prompt from that earlier version (now with newly added Git support), download the optional `.bashrc_prompt` script file and place it in either your home directory or as the file `~/.config/bashrc/prompt`.

> If you can't get your `.bashrc` file to load, add `[[ -f "${HOME}/.bashrc" ]] && builtin source "${HOME}/.bashrc"` to your `~/.bash_profile` file.

## Table of contents

- [Install](#to-install)
- [Overview of features](#overview-of-features)
- [New commands](#some-of-the-new-helpful-commands-are) (also see [Command Syntax](#command-syntax))
	- [Bashrc](#bashrc)
	- [Information and utility](#information-and-utility)
	- [Quick directories](#quick-directories)
	- [Directory and file management](#directory-and-file-management)
	- [Searching](#searching)
	- [Editing and viewing](#editing-and-viewing)
	- [Scripting](#scripting)
	- [File operations](#file-operations)
	- [Clipboard](#clipboard)
	- [Time and date](#time-and-date)
	- [Trash](#trash)
	- [Graphics](#graphics)
	- [Multimedia and voice](#multimedia-and-voice)
	- [Permissions](#permissions)
	- [Memory and process management](#Memory-and-process-management)
	- [Networking](#networking)
	- [System](#system)
	- [Services](#services-if-systemd-is-present)
	- [Server utilities](#server-utilities)
	- [Security](#security)
	- [File system maintenance](#file-system-maintenance)
	- [Tmux terminal multiplexor or session management](#tmux-terminal-multiplexor-or-session-management)
	- [Distrobox (if installed)](#distrobox-if-installed)
	- [Package management](#package-management)
	- [Git (if installed)](#git-if-installed)
- [Configuration](#configuration)
	- [Environment variables and settings](#environment-variables-and-settings)
	- [Using your own or replacing aliases](#using-your-own-or-replacing-aliases)
	- [Auto-load and source script files](#auto-load-and-source-script-files)
	- [Move files out of the home folder (optional)](#move-files-out-of-the-home-folder-optional)
- [Path locations for binary files](#path-locations-for-binary-files)
- [Auto-display message on load](#auto-display-message-on-load)
- [Birthday and anniversary reminder](#birthday-and-anniversary-reminder)
- [Auto-update](#auto-update)
- [Extra: Bash App Recommendations](#extra-bash-app-recommendations)
- [License](#license)

# To install

It is recommended to back up or rename your original `.bashrc` file first. You can use `cp ~/.bashrc ~/.bashrc_backup` to make a back up copy.

To install, simply execute the following two lines in a terminal:

```
curl -L https://sourceforge.net/projects/ultimate-bashrc/files/_bashrc/download --output ~/.bashrc
curl -L https://sourceforge.net/projects/ultimate-bashrc/files/_bashrc_help/download --output ~/.bashrc_help
```

Or you can use wget instead:

```
wget -O ~/.bashrc https://sourceforge.net/projects/ultimate-bashrc/files/_bashrc/download
wget -O ~/.bashrc_help https://sourceforge.net/projects/ultimate-bashrc/files/_bashrc_help/download
```

Or just download and manually copy the `.bashrc` and `.bashrc_help` files into your home folder (*the `~/.bashrc_help` file can also be relocated to `~/.config/bashrc/help` if you wish to remove it from your home directory*).

To update once installed: type [`bashrcupdate`](#bashrcupdate) (or [`bashrcupdateforce`](#bashrcupdateforce)) in a terminal window to update.

Once you restart bash, type **`hlp`** (or press **`CTRL-h`** if the _SKIP_HELP_KEYBIND option is disabled) for help and shortcuts.

[Go to the top](#table-of-contents)

# Overview of features

- Portability and seemless compatibility on nearly any platform I use that uses Bash 4.0 or greater
- **Auto-load, auto-adapt, and automatically detect/use installed packages** (like [bash completion](https://github.com/scop/bash-completion), [fzf-tab-completion](https://github.com/lincheney/fzf-tab-completion), [lsd](https://github.com/Peltoche/lsd), [lscolors](https://github.com/trapd00r/LS_COLORS) or [vivid](https://github.com/sharkdp/vivid), [source-highlight](https://www.gnu.org/software/src-highlite/), [mysql-colorize](https://github.com/zpm-zsh/mysql-colorize), prompts, huds, custom aliases, motd, etc)
- **Full Color Help** in the console with descriptions for new commands (type **`hlp`** or press **`CTRL-h`**)
- Supports nearly every distribution (even including Git-Bash, Cygwin, and WSL)
- Easy to add to any system even if there is no `root` access
- Provide much better and more sane Bash defaults
- Add color to as much output and as many commands as possible
- Add tons of new commands and usability
- Automatically find and easily edit configuration files for Apache, Nginx, MySQL, PHP, SSH, and more
- Easier to read color directory listings with full color columns, or optional automatic support for [eza](https://github.com/eza-community/eza)/[exa](https://github.com/ogham/exa) (which also supports Git), [lsd](https://github.com/Peltoche/lsd), and [grc](https://github.com/garabik/grc) if installed
- Use most common aliases people are used to to diminish the learning curve
- A `chmod` calculator (`chmodcalc`) and ability to change permissions on just files (`chmodfiles`) or only directories (`chmoddirs`)
- Provide a default beautiful and lightening fast color prompt that supports Git and works on any platform
- Support for the [original old prompt](https://www.linuxquestions.org/questions/linux-general-1/ultimate-prompt-and-bashrc-file-4175518169/) (with newly added Git support) from the previous version that automatically loads (sourced) if the optional `.bashrc_prompt` script file is downloaded into the home directory
- Additional installed prompts are auto-detected and supported like [Trueline](https://github.com/petobens/trueline), [Powerline](https://github.com/powerline/powerline), [Powerline-Go](https://github.com/justjanne/powerline-go), [Powerline-Shell](https://github.com/b-ryan/powerline-shell), [Pureline](https://github.com/chris-marsh/pureline), [Starship](https://starship.rs), [Oh-My-Git](https://github.com/arialdomartini/oh-my-git), [Bash Git Prompt](https://github.com/magicmonty/bash-git-prompt), [Bash-Powerline](https://github.com/riobard/bash-powerline), [Sexy Bash Prompt](https://github.com/twolfson/sexy-bash-prompt), and [Liquid Prompt](https://github.com/nojhan/liquidprompt)
- Auto detect and source the most popular scripts and apps for Bash including [bashmarks](https://github.com/huyng/bashmarks), [blesh](https://github.com/akinomyoga/ble.sh), [commacd](https://github.com/shyiko/commacd), [hstr](https://github.com/dvorka/hstr), [qfc](https://github.com/pindexis/qfc), and [tmux](https://github.com/tmux/tmux/wiki) (many of these are in your software repositories)
- Huds supported are [neofetch](https://github.com/dylanaraps/neofetch), [fastfetch](https://github.com/LinusDierheimer/fastfetch), [screenFetch](https://github.com/KittyKatt/screenFetch), [linux_logo](https://github.com/deater/linux_logo), [archey](https://github.com/HorlogeSkynet/archey4), and [pfetch](https://github.com/dylanaraps/pfetch) (which is a single Bash script file and good for systems without `root` access)
- Enhanced clipboard management in the terminal, allowing you to view, set, and clear clipboard content also supporting piping input and output. Additionally, the command seamlessly integrates with common shell commands like `pwd` and `which` to automatically copy results to the clipboard and Tmux buffer. One of the following clipboard utilities is required: [wl-clipboard](https://github.com/bugaevc/wl-clipboard) (for Wayland), [xclip](https://github.com/astrand/xclip) (for X11), [xsel](https://github.com/kfish/xsel) (for X11) or [pbcopy](https://ss64.com/osx/pbcopy.html) (for Mac).
- Support for sending file to the desktop trash bin using commands `trash`, `trashlist`, and `trashempty` (if `trash-put` is installed, will also have `trashrestore` command available)
- Full support for lightweight `sudo` alternatives like `doas` and `rdo` (environment variable `_SKIP_SUDO_ALTERNATIVE` must be set to `false` to enable)
- Easy to use aliases for Git including support for the very popular [Git Alias project on Github](https://github.com/GitAlias/gitalias) and [Git auto-completion](https://github.com/git/git/blob/master/contrib/completion/git-completion.bash)
- Birthday and anniversary reminder for your terminal (whenever bash loads or the `birthday` command is used) that uses a CSV file `~/.config/birthdays.csv` with the format of (year is optional and can be left blank): Month,Day,Year,"Message"
- Can be enabled to always show the number of updates on bash load (currently only Arch and Ubuntu)
- Full comments inside the `.bashrc` file with links so everything is easy to understand, find, and install
- Most popular package managers are auto-detected and supported with common aliases so you never feel lost installing or updating packages on any system:
    - Arch/Manjaro: [pacman](https://archlinux.org/pacman/), [pamac](https://wiki.manjaro.org/index.php/Pamac), [paru](https://github.com/Morganamilo/paru), [yay](https://github.com/Jguer/yay)
    - Cygwin: [apt-cyg](http://stephenjungels.com/jungels.net/projects/apt-cyg/)
    - Debian/Ubuntu/Mint/Raspbian: [apt](https://itsfoss.com/apt-command-guide/), [apt-get](https://help.ubuntu.com/community/AptGet/Howto), [nala](https://gitlab.com/volian/nala)
    - Gentoo: [emerge](https://www.linode.com/docs/guides/portage-package-manager/)
    - macOS: [brew](https://brew.sh/)
    - Mandrake: [urpmi](https://wiki.mageia.org/en/URPMI)
    - RedHat/Fedora: [dnf](https://fedoraproject.org/wiki/DNF), [yum](https://access.redhat.com/articles/yum-cheat-sheet)
    - Slackware: [slackpkg](https://www.linux.com/training-tutorials/intro-slackware-package-management/)
    - Solus: [eopkg](https://getsol.us/articles/package-management/basics/en/)
    - SUSE: [zypper](https://en.opensuse.org/SDB:Zypper_usage)
- Completely free and open software using the lenient and permissive [MIT license](https://en.wikipedia.org/wiki/MIT_License)

[Go to the top](#table-of-contents)

# Some of the new helpful commands are:

> Please note that certain commands and aliases will only exist if the required dependencies are met

## Bashrc

- [ebrc](#ebrc) - Edit the `.bashrc` file (any parameters does a search in the ~/.bashrc file instead)
- [bashrcupdate](#bashrcupdate) - Automatically update the `.bashrc` file (and the help file) from SourceForge (if problems, use [`bashrcupdateforce`](#bashrcupdateforce))
- [bashrcprotect](#bashrcprotect) - Make the `.bashrc` immutable/write protected (even from root) so that other scripts and applications can't modify it
- [bashrcunprotect](#bashrcunprotect) - Remove the immutable/write protected flag from the `.bashrc` file
- [bashrccheckprotect](#bashrccheckprotect) - Check to see the `.bashrc` file has the immutable/write protected flag

## Information and utility

- [hlp](#hlp) - Show full color help information
- [a](#a) - Show a list of all available aliases and functions (takes optional filter parameter that performs a text search)
- [ver](#ver) - Show the version of the OS and kernel
- [check](#check) - Show if a command is aliased, a file, or a built-in command
- [repeat](#repeat) - Repeat a command n times
- [mostused](#mostused) - See what command you are using the most
- [windowinfo](#windowinfo) - Select a window for information like geometry, class name, etc.
- [cpuinfo](#cpuinfo) - Show CPU information
- [usb](#usb) - Show the USB device tree
- [pci](#pci) - Show the PCI device tree

## Quick directories

> These aliases are case sensitive where lower case is the local user directory and upper case is the global system directory.

- [home](#home) - Go to your home folder
- `autostart` - Change to the `~/.config/autostart` directory if present
- `bashrc` - Change to the `~/.config/bashrc` directory if present (any parameters does a search in the ~/.bashrc file instead)
- `bin` - Change to the `~/.local/bin` directory if present
- `BIN` - Change to the `/usr/bin` directory
- `cache` - Change to the `~/.cache` directory if present
- `config` - Change to the `~/.config` directory if present
- `CONFIG` - Change to the `/etc` directory
- `desktop` - Change to the `~/Desktop` directory if present
- `docs` - Change to the `~/Documents` directory if present
- `DOCS` - Change to the man pages directory (`/usr/local/man`, `/usr/local/share/man`, or `/usr/share/man`)
- `downloads` - Change to the `~/Downloads` directory if present
- `fonts` - Change to the `~/.fonts` or `~/.local/share/fonts` directory if the previous does not exist
- `FONTS` - Change to the `/usr/share/fonts` directory if present
- `icons` - Change to the `~/.icons` or `~/.local/share/icons` directory if the previous does not exist
- `ICONS` - Change to the `/usr/share/icons` directory if present
- `music` - Change to the `~/Music` directory if present
- `pics` or `pictures` - Change to the `~/Pictures` directory if present
- `share` - Change to the `~/.local/share` directory if present
- `SHARE` - Change to the `/usr/share` directory if present
- `shortcuts` - Change to the `~/.local/share/applications` or `~/.gnome/apps` directory if the previous does not exist
- `SHORTCUTS` - Change to the `/usr/share/applications` or `/usr/local/share/applications` directory if the previous does not exist
- `themes` - Change to the `~/.local/share/themes` directory if present
- `THEMES` - Change to the `/usr/share/themes` directory if present
- `tmp` - Change to the `~/tmp` or `~/.cache/tmp` or `~/.cache` directory (whichever exists first)
- `TMP` - Change to the global system temp directory which is usually `/tmp`
- `videos` - Change to the `~/Videos` directory if present
- `wallpaper` - Change to the `~/.local/share/wallpapers` directory if present
- `WALLPAPER` - Change to the `/usr/share/wallpapers` or `/usr/share/backgrounds` directory
- `web` - Change into the one of these web directories: `/srv/http`, `/var/www/html`, `/usr/share/nginx/html`, `/opt/lampp/htdocs`, `/usr/local/apache2/htdocs`, `/usr/local/www/apache24/data`

## Directory and file management

- [ll](#ll) - Directory listing: long listing format with full column color
- [lll](#lll) - Show disk usage for local only using [duf](https://github.com/muesli/duf), [vizex](https://github.com/bexxmodd/vizex), or the default [df](https://www.geeksforgeeks.org/df-command-linux-examples/) command
- [labc](#labc) - Directory listing: alphabetical sort
- [lx](#lx) - Directory listing: sort by extension
- [lk](#lk) - Directory listing: sort by size
- [lt](#lt) - Directory listing: sort by date
- [lc](#lc) - Directory listing: sort by change time
- [lu](#lu) - Directory listing: sort by access time
- [lw](#lw) - Directory listing: wide listing format
- [lm](#lm) - Directory listing: pipe through 'more'
- [lr](#lr) - Directory listing: recursive ls
- [l.](#l.) - Directory listing: only show hidden files
- [lfile](#lfile) - Directory listing: files only
- [ldir](#ldir) - Directory listing: directories only
- [ltree](#ltree) - Directory listing: tree format
- [new](#new) - Directory listing: recently created/updated files
- [llfs +10k](#llfs) - List all files larger than a given size
- [mc](#mc) or [mcc](#mcc) - Midnight Commander (if installed) with and without the subshell
- [r](#r) or [ranger](#ranger) - Launches ranger (if installed) and exits into the last directory selected
- `..` - Go back 1 folder
- `...` - Go back 2 folders
- `....` - Go back 3 folders
- `.....` - Go back 4 folders
- `..2` - Go back 2 folders
- `..3` - Go back 3 folders
- `..4` - Go back 4 folders
- `..5` - Go back 5 folders
- [up](#up) - go up a specified number of folders
- [pwd-](#pwd-) - Show the previous directory
- [pwdtail](#pwdtail) - Returns the last 2 fields of the working directory
- [rmd](#rmd) - Remove a directory and all contents
- [cpp](#cpp) - Copy file with a progress bar
- [cpg](#cpg) - Copy and go to the directory
- [mvg](#mvg) - Move and go to the directory
- [mkdirg](#mkdirg) - Create and go to the directory
- [fullpath](#fullpath) - Shows full path of file or wildcard
- [path](#path) - List the PATH environment variable directories
- [resolvesymlink](#resolvesymlink) - Cross-platform realpath equivalent for resolving symlinks to an absolute path
- [diskspace](#diskspace) - Find out which directories are taking up the most space
- [df](#df) - Show disk usage using [duf](https://github.com/muesli/duf) or the default [df](https://www.geeksforgeeks.org/df-command-linux-examples/) command
- [totalsize](#totalsize) - Just show the size of the current or specified folder
- [folders](#folders) - List disk space of immediate folders one level deep
- [countfiles](#countfiles) - Count all files (recursively) in the current folder
- [treed](#treed) - Show a folder tree (uses `tree`)
- [m](#m) - Mount a file system
- [um](#um) - Unmount a file system
- [p](#p) - Quick alias for `pushd` that now has a deduped directory stack
- [p-](#p-) - Quick alias for `popd`
- [dirsclear](#dirsclear) - Clears the directory stack from pushd
- [dirsdedup](#dirsdedup) - Removes duplicates from the directory stack
- [pathappend](#pathappend) - Add directories to the end of the path
- [pathprepend](#pathprepend) - Add directories to the beginning of the path

## Searching

- [h](#h) - Search command line history (also `CTRL-S` and `CTRL-R`)
- [f](#f) or [findfile](#f) - Search filenames in the current folder
- [findtext](#findtext) - Searches for text in all files in the current folder
- [find24](#find24) - Recursively find all files modified in the last 24 hours
- [findalias](#findalias) - List available aliases with optional filter parameter
- [findapps](#findapps) - Does a text search for installed graphical application in a desktop environment
- [findbashrc](#findbashrc) - Searches for text inside the ~/.bashrc file
- [findcode](#findcode) - Searches for text in only source code files - supports 74 programming languages
- [findfunction](#findfunction) - List available functions with optional filter parameter
- [findlinks](#findlinks) - Find all the symlinks containing search text (i.e. `"/backup"`)
- [findlog](#findlog) - Shows a list of log files with previews and returns the log filename (requires `fzf`)
- [preview](#preview) - Shows all files in the current directory with previews to open for editing (requires `fzf`)
- [ulocate](#ulocate) - When using `mlocate`, update the database before locating a file
- [locount](#locount) - Display the number of matching entries
- [regexformat](#regexformat) - Format and escape text to make it safe for a regular expression search

## Editing and viewing

- [e](#e-or-edit) or [edit](#e-or-edit) - Advanced file editing that ensures maximum security with automatic sudo elevation, handles symlinks and immutable files, auto-finds and edits scripts in your $PATH, supports tab renaming with Tmux integration, and performs post-edit actions like prompting to restart services when modifying relevant configuration files—all using your default editor specified in $EDITOR (or auto-detected for you depending on what is installed)
- [les](#les) - View files with `less` without line numbers
- [csvview](#csvview) - View CSV files in the terminal
- [json](#json) - View JSON files in the terminal
- [typefile](#typefile) - Directly type text into a file
- [swapindent](#swapindent) - Swaps tab and spaces indentation in the provided file or in standard input
- [convert2mdtag](#convert2mdtag) - Converts a markdown title string into a markdown tag

## Scripting

- [analyzecode](#analyzecode) - Analyzes a code file to provide statistics
- [showfunctions](#showfunctions) - List and sort all function names with line numbers from source code files of most languages
- [createmenu](#createmenu) - Use parameters or pipe multiple lines to create a text picker menu
- [hascommand](#hascommand) - Check if a command or alias exists
- [runwithfeedback](#runwithfeedback) - automates the process of executing a command and providing visual feedback (displays an hourglass symbol next to the provided description while the command is running and upon successful execution, the hourglass is replaced with a green checkmark; If the command fails, a red cross symbol is displayed instead)
- [trim](#trim) - Trim characters from text

## File operations

- [open](#open) - Open documents with default applications
- [ui](#ui) - Open the default file manager
- [extract](#extract) - Extract archives
- [lines](#lines) - Display specific lines or line ranges from a file
- [diff](#diff) - Aliases to use the best diff application between [`delta`](https://github.com/dandavison/delta), [`Icdiff`](https://github.com/jeffkaufman/icdiff), [`colordiff`](https://www.colordiff.org), [`neovim`](https://neovim.io), [`vim`](https://www.vim.org), or the [built-in `diff` command](https://man7.org/linux/man-pages/man1/diff.1.html) depending on what is installed (Use `\diff` to bypass)
- [gdiff](#gdiff) - If in a graphical environment, use [Meld](https://meldmerge.org/), [Kompare](https://apps.kde.org/kompare/), [KDiff3](https://kdiff3.sourceforge.net/), or [XXDiff](http://furius.ca/xxdiff/) if installed

## Clipboard

- [clipboard](#clipboard) - Improved terminal clipboard management for viewing, setting, and clearing content, with support for piping input and output
- [file2cb](#file2cb) and [cb2file](#cb2file) - Load or save the contents of a file to/from the clipboard
- [file2asc](#file2asc) and [asc2file](#asc2file) - Compress/extract any file to/from the clipboard as base64 text
- [cbshow](#cbshow) - Show the contents of the clipboard
- [trimcb](#trimcb) - Trim leading and trailing characters on the clipboard

## Time and date

- [today](#today) - Show the date only
- [now](#now) - Show the time
- [stopwatch](#stopwatch) - Stop watch
- [timeelapsed](#timeelapsed) - Show elapsed time since a given date
- [filetimenow](#filetimenow) - Change a file's accessed and modified time to now

## Trash

- [trash](#trash) - Send file(s) to the trash (works with most desktop environments)
- [trashlist](#trashlist) - Display the contents of the trash
- [trashempty](#trashempty) - Empty and permanently delete all the files in the trash

## Graphics

- [colors](#colors) - Print a list of colors with escape codes
- [colors256](#colors256) - Print a list of all 256 color codes
- [colors24bit](#colors24bit) - Test for 24 bit true color in the terminal
- [download-dircolors](#download-dircolors) - Download an extensive LS_COLORS file for color directory listings to the home directory
- [compressimage](#compressimage) - Convert an image to compressed jpg format if [ImageMagick](https://imagemagick.org/index.php) is installed
- [sparkbars](#sparkbars) - Draw spark "EQ" type bars across the terminal
- [sparkbars | lolcat](#sparkbars) - Draw spark "EQ" type bars across the terminal in color
- [toiletfont](#toiletfont) and [toiletfontlist](#toiletfontlist) - Shows [TOIlet](https://www.linuxlinks.com/toilet/) fonts if TOIlet is installed
- [grabvideo](#grabvideo) - Video capture the Linux desktop (requires ffmpeg)
- [whichdisplay](#whichdisplay) - Shows the current display server (e.g. X11 or Wayland)

## Multimedia and voice

- [say](#say) - Text to speech
- [sayclipboard](#sayclipboard) or [saycb](#sayclipboard) - Read the clipboard outloud
- [yt](#yt) - Play YouTube videos

## Permissions

- [chmodcalc](#chmodcalc) - Chmod calculator
- [chmoddirs](#chmoddirs) - Recursively change only folder permissions
- [chmodfiles](#chmodfiles) - Recursively change only file permissions
- [chmodcopy](#chmodcopy) - Copy permissions from one file/directory to another
- [chfix](#chfix) - Recursively set permissions for code files and directories
- [fixuserhome](#fixuserhome) - Repairs and sets proper permissions of the home directory (optionally specify a user)
- [fixinvalidexecutepermissions](#fixinvalidexecutepermissions) - Remove unneeded and invalid execute permissions from strictly non-executable file types recursively
- [mx](#mx) - make files executable

## Memory and process management

- [runfree](#runfree) - Detach programs from terminal
- [smash](#smash) - Kill process by name
- [top](#top) - Runs top program with the most features ([btop](https://github.com/aristocratos/btop), [bpytop](https://github.com/aristocratos/bpytop), [bashtop](https://github.com/aristocratos/bashtop), [nmon](http://nmon.sourceforge.net/pmwiki.php), [glances](https://nicolargo.github.io/glances/), [ytop](https://github.com/cjbassi/ytop), [gtop](https://github.com/aksakalli/gtop), or [htop](https://htop.dev/))
- [cpu](#cpu) - Show the top 10 CPU processes
- [gpu](#gpu) - Task monitor for NVIDIA, AMD and Intel GPUs (requires [NVTOP](https://github.com/Syllo/nvtop))
- [free](#free) - Display amount of free and used memory in MB
- [flushcache](#flushcache) - Clear RAM memory cache, buffer and swap space
- [activewinpid](#activewinpid) - Get active X-window process ID (3 second delay)

## Networking

- [d](#d-or-download) or [download](#d-or-download) - Automatic enhanced downloads based on URL by dynamically choosing the appropriate command including from services like Youtube, Spotify, Tidal, and SoundCloud
- [ytd](#ytd) - Download a YouTube video with `yt-dlp` or `youtube-dl`
- [fastping](#fastping) - Do not wait for ping interval 1 second (go fast)
- [netwatch](#netwatch) - Watch real time network activity
- [ports](#ports) - Show open ports
- [iplocal](#iplocal) - Get local IP addresses
- [ipexternal](#ipexternal) - Get outside external IP addresses
- [flushdns](#flushdns) - Clear DNS cache to refresh domain name data
- [hoststoggle](#hoststoggle) - Toggle the hosts file off and back on
- [alert](#alert) - Network notify alert for long running commands
- [sync2ssh](#sync2ssh) - Synchronize files using rsync over SSH

## System

- [rebootsafe](#rebootsafe) - Safely reboot the system
- [rebootforce](#rebootforce) - Forcefully reboot the system
- [rebootlater](#rebootlater) - Schedule the computer to auto reboot
- [logout](#logout) - Log out the current user
- [checkreboot](#checkreboot) - Check to see if the system needs to be rebooted (for example after an update)
- [createuser](#createuser) - Interactively create, configure, and test a new user
- [deleteuser](#deleteuser) - Remove a user from the system
- [wipeuser](#wipeuser) - Remove a user and all traces (including their home directory) from the system
- [fstab](#fstab) - Edit filesystem table
- [configcopy](#configcopy) - Copy CLI config files
- [firmwareupdate](#firmwareupdate) - Update firmware
- [whichtty](#whichtty) - Alias to show the current TTY (CTRL-ALT-1 through 7)
- [ttymouseon](#ttymouseon) - Turns on mouse support in TTY terminals
- [ttymouseoff](#ttymouseoff) - Turns off mouse support in TTY terminals (may require reboot)
- [ttymousestatus](#ttymousestatus) - Determine if mouse support is activated in TTY terminals

## Services (if systemd is present)

- [failed](#failed) (or servicefailed) - Show any services that have failed
- [services](#services) - List all running or failed services
- [servicesall](#servicesall) - List all services
- [servicestatus](#servicestatus) - Show the status of a service
- [serviceenable](#serviceenable) - Start a service and enable automatic startup at boot
- [servicedisable](#servicedisable) - Start a service and enable automatic startup at boot
- [servicestart](#servicestart) - Start a service
- [servicestop](#servicestop) - Stop a service
- [servicekill](#servicekill) - Forcefully terminate a service
- [servicerestart](#servicerestart) - Stop and restart a service
- [servicereload](#servicereload) - Reload a service's configuration (soft restart)
- [cleansystemlogs](#cleansystemlogs-or-clearsystemlogs) or [clearsystemlogs](#cleansystemlogs-or-clearsystemlogs) - Clears log entries from the systemd journal

## Server utilities

- [apacherestart](#apacherestart) - Restart the Apache web server (requires Apache to be installed)
- [apacheconfig](#apacheconfig) - Edit Apache web server configuration
- [ngrestart](#ngrestart) - Restart the Nginx web server (requires Apache to be installed)
- [ngconfig](#ngconfig) - Edit Nginx web server configuration
- [mysqlconfig](#mysqlconfig) - Edit MySQL database configuration
- [mysqldatadir](#mysqldatadir) - Show MySQL's data directory location
- [phpconfig](#phpconfig) - Edit the PHP configuration
- [phpcheck](#phpcheck) - Check the syntax of a PHP file for errors
- [sshstatus](#sshstatus) - Show if the SSH service is running or not
- [sshstart](#sshstart) - Start the SSH service
- [sshstop](#sshstop) - Stop the SSH service
- [sshrestart](#sshrestart) - Restart the SSH service
- [scanscripts](#scanscripts) - Show all scripts in a directory and show which shell it uses
- [logview](#logview) - Use sudo to view log files in real time
- [logs](#logs) - Show all logs in `/var/log`

## Security

- [genpw](#genpw) - Generate passwords (takes an optional parameter for length and -s or +s for symbols)
- [pwcheck](#pwcheck) - Check password strength (requires `cracklib`)
- [checkloginfailures](#checkloginfailures) - Check failed login attempts (if supported by your system)
- [encrypt](#encrypt) - Encrypt files
- [decrypt](#decrypt) - Decrypt files
- [rot13](#rot13) - Rot13 conversion
- [cleanmeta](#cleanmeta) - Remove Exif metadata
- [checksha256](#checksha256) - Check the sha256 checksum of a file using a checksum file like sha256sum.txt

## File system maintenance

- [btrcheck](#btrcheck) - Check status of raid drives
- [btrstats](#btrstats) - Show device statistics
- [btrscrub](#btrscrub) - Start a scrub
- [btrpause](#btrpause) - Cancel or pause a scrub
- [btrresume](#btrresume) - Resume a paused scrub
- [btrstatus](#btrstatus) - Show status of a scrub
- [btrdefragfile](#btrdefragfile) - Defrag a file
- [btrdefragdir](#btrdefragdir) - Defrag a directory
- [ext3check](#ext3check) - Check and repair Ext3 filesystem
- [ext3stats](#ext3stats) - Show statistics for Ext3 filesystem
- [ext3trim](#ext3trim) - Trim unused blocks on Ext3 filesystem
- [ext4check](#ext4check) - Check and repair EXT4 filesystem
- [ext4stats](#ext4stats) - Show statistics for EXT4 filesystem
- [ext4trim](#ext4trim) - Trim unused blocks on EXT4 filesystem
- [f2fscheck](#f2fscheck) - Check and repair F2FS filesystem
- [f2fsstats](#f2fsstats) - Show statistics for F2FS filesystem
- [f2fstrim](#f2fstrim) - Trim unused blocks on F2FS filesystem
- [xfscheck](#xfscheck) - Check and repair XFS filesystem
- [xfsstats](#xfsstats) - Show information about XFS filesystem
- [xfstrim](#xfstrim) - Trim unused blocks on XFS filesystem
- [zfscheck](#zfscheck) - Check and repair ZFS pool
- [zfsstats](#zfsstats) - Show ZFS pool statistics
- [zfstrim](#zfstrim) - Trim unused blocks on ZFS pool
- [zfsstatus](#zfsstatus) - Check status of ZFS pool
- [zfsscrub](#zfsscrub) - Start a scrub on ZFS pool
- [zfspause](#zfspause) - Pause a scrub on ZFS pool
- [zfsresume](#zfsresume) - Resume a paused scrub on ZFS pool
- [zfsscrubstatus](#zfsscrubstatus) - Show status of ZFS pool scrub
- [zfsdefragfile](#zfsdefragfile) - Defrag a file (snapshot-based)
- [zfsdefragdir](#zfsdefragdir) - Defrag a directory (snapshot-based)
- [ntfscheck](#ntfscheck) - Check and repair NTFS filesystem
- [ntfsstats](#ntfsstats) - Show information about NTFS filesystem
- [fatcheck](#fatcheck) - Check and repair FAT filesystem
- [fatstats](#fatstats) - Show information about FAT filesystem

## Tmux terminal multiplexor or session management

- [tmd](#tmd) - Detach from a Tmux session but leave the session running
- [tmlist](#tmlist) - List all Tmux sessions
- [tmclients](#tmclients) - List all Tmux clients
- [tmlistkeys](#tmlistkeys) - List all the Tmux key bindings
- [tmnew](#tmnew) - Create a new session
- [tmsessiongroup](#tmsessiongroup) - Create a new session group (good for multiple monitors)
- [tmattach](#tmattach) - Attach to an existing Tmux session (shows a menu)
- [tmrename](#tmrename) - Rename a Tmux session
- [tmkill](#tmkill) - Kill a Tmux session
- [tmreset](#tmreset) - Kill all Tmux sessions
- [zj](#zj) or [znew](#znew) - Launch Zellij (if installed) and create a new session if needed
- [zlist](#zlist) - List all the Zellij sessions
- [zattach](#zattach) - Attach to an existing Zellij session (shows menu of sessions)
- [zkill](#zkill) - Kill a Zellij session
- [zreset](#zreset) - Kill all Zellij sessions
- [aa](#aa) - Start or connect to an abduco session (shows a menu)
- [aaro](#aaro) - Connect to an abduco session read-only
- [aals](#aals) - List any abduco sessions
- [aareset](#aareset) - Kill all abduco sessions

## Distrobox (if installed)

- [db](#db) - Easy and short Distrobox alias
- [dbe](#dbe) - Enter a Distrobox (if one isn't specified then shows a menu picklist of installed containers to choose from)
- [dbl](#dbl) - List all Distrobox containers
- [dbls](#dbls) or [distrobox-list-simple](#distrobox-list-simple) - List only the Distrobox container names (useful for scripts)
- [dbs](#dbs) - Stops a Distrobox container
- [dbsa](#dbsa) - Stops all Distrobox containers
- [dbhe](#dbhe) - Shortcut to run the `distrobox-host-exec` command
- [dbup](#dbup) - Upgrade a Distrobox container or all containers if one is not specified
- [dbc](#dbc) or [distrobox-check](#distrobox-check) - Checks the status of Distrobox docker containers
- [distrobox-pick](#distrobox-pick) - Shows a menu to choose a Distrobox container (useful for scripts)

## Package management

- [has](#has) - Show if a package is installed and it's information and version
- [pkgupdateall](#pkgupdateall) - Update the system and all packages
- [pkgupdate](#pkgupdate) - Updates an installed package
- [pkginstall](#pkginstall) - Installs a package
- [pkgremove](#pkgremove) - Removes a package
- [pkgclean](#pkgclean) - Removes orphans or unused packages
- [pkgsearch](#pkgsearch) - Searches for a package
- [pkglist](#pkglist) - List all installed packages
- [pkgdependencies](#pkgdependencies) - View package dependencies
- [pkgwhatuses](#pkgwhatuses) - Find the programs that require a dependent package (only supported by some package managers/distros)

### Arch Linux only

- [pkg](#pkg) - Launch [pacseek](https://github.com/moson-mo/pacseek) if installed
- [pkglistmore](#pkglistmore) - List all packages explicitly installed and all dependent packages that are not explicitly installed
- [pkgforceremove](#pkgforceremove) - Force remove a package ignoring required dependencies
- [pkgforcereinstall](#pkgforcereinstall) - Force remove a package ignoring required dependencies and then reinstall
- [pkginstallregex](#pkginstallregex) - Install a list of packages with regex
- [pkglocalpackagefiles](#pkglocalpackagefiles) - List all the local files in an installed package
- [pkgdependencies](#pkgdependencies) - Add aliases to find dependencies (requires `pacman-contrib`)
- [pkgwhatuses](#pkgwhatuses) - Show what packages use a package (requires `pacman-contrib`)
- [pkgmarkasexplicit](#pkgmarkasexplicit) - Mark a package as explicitly installed or only a dependency
- [pkgmarkasdependency](#pkgmarkasdependency) - Mark a package as only a dependency
- [pkgsearchcontainingfile](#pkgsearchcontainingfile) - Search for a package containing a file
- [pkgverifylocalpackage](#pkgverifylocalpackage) - Verify the presence of the files installed by a package
- [pkgverifyall](#pkgverifyall) - Verify all packages
- [pkgcheck](#pkgcheck) - Check for updates without root access (requires `pacman-contrib`)
- [pacmanfix](#pacmanfix) - Fixes most pacman errors
- [pacmanfixkeys](#pacmanfixkeys) - Fix problematic pacman keys
- [pacman-clean-cache](#pacman-clean-cache) - Clean the pacman and helper package caches
- [pacnew](#pacnew) - Check for default configuration file backups
- [archnews](#archnews) - Show the latest Arch linux update news

### Debian/Ubuntu only

- [pkgdependencies](#pkgdependencies) - Show a package's dependencies
- [pkgwhatuses](#pkgwhatuses) - Show what packages use a package (requires `apt-rdepends`)

### Flatpak (if installed)

- [flatpakhas](#flatpakhas) - Show if a Flatpak package is installed and it's information and version
- [flatpakupdateall](#flatpakupdateall) - Update all Flatpak packages
- [flatpakupdate](#flatpakupdate) - Update a Flatpak package
- [flatpakinstall](#flatpakinstall) - Install a Flatpak package
- [flatpakremove](#flatpakremove) - Remove a Flatpak package
- [flatpakwipe](#flatpakwipe) - Remove a Flatpak package and delete all it's data
- [flatpakclean](#flatpakclean) - Removes orphans or unused Flatpak packages
- [flatpaksearch](#flatpaksearch) - Search for a Flatpak package
- [flatpaklist](#flatpaklist) - List all installed Flatpak packages
- [flatpaksize](#flatpaksize) - List all installed Flatpak packages and their disk space size
- [flatpakmakeicons](#flatpakmakeicons) - Make icons for all installed Flatpak packages
- [flatpakremotes](#flatpakremotes) - Show all Flatpak repos/remotes

### Snap (if installed)

- [snaphas](#snaphas) - Show if a Snap package is installed and it's information and version
- [snapupdateall](#snapupdateall) - Update all Snap packages
- [snapupdate](#snapupdate) - Update a Snap package
- [snapinstall](#snapinstall) - Install a Snap package
- [snapremove](#snapremove) - Remove a Snap package
- [snapclean](#snapclean) - Removes orphans or unused Snap packages
- [snapsearch](#snapsearch) - Search for a Snap package
- [snaplist](#snaplist) - List all installed Snap packages
- [snapsize](#snapsize) - List all installed Snap packages and their disk space size

## Git (if installed)

- [gitfixsettings](#gitfixsettings) - Set Git defaults like user name, email, pager, and diff
- [gitbranch](#gitbranch) - Interactive if no branch specified (can use pickers [fzy](https://github.com/jhawthorn/fzy), [skim](https://github.com/lotabout/skim), [fzf](https://github.com/junegunn/fzf), [peco](https://github.com/peco/peco), [percol](https://github.com/mooz/percol), [pick](https://thoughtbot.com/blog/announcing-pick), [icepick](https://github.com/felipesere/icepick), [selecta](https://github.com/garybernhardt/selecta/), [sentaku](https://github.com/rcmdnk/sentaku), or [zf](https://github.com/natecraddock/zf))
- [gitresetbranch](#gitresetbranch) - Forces Git to overwrite local files and resets the branch
- [cg](#cg) - Returns you to the Git project's top level
- [gitls](#gitls) - List files and show each file status in Git
- [gitmodifieddate](#gitmodifieddate) - List Git files by last modified date
- [gitrepos](#gitrepos) - Find all Git repos in the current directory recursively
- [gitupdaterepos](#gitupdaterepos) - Update all Git repositories in the current directory one level deep (or level depth specified by an optional parameter)
- [gitcommithelp](#gitcommithelp) - Generate standardized [semantic Git commit messages](https://gist.github.com/joshbuchea/6f47e86d2510bce28f8e7f42ae84c716) automatically (with emoji icons) and copy them to the clipboard
- [getbranchhelp](#getbranchhelp) - Assist in generating [structured branch names](https://mirocommunity.readthedocs.io/en/latest/internals/branching-model.html) with options for project codes and ticket numbers
- [gitalias](#gitalias) - Downloads or updates online [Git Alias](https://github.com/GitAlias/gitalias)es that are a popular collection of git version control alias settings
- `lg` - Runs [LazyGit interface for Git](https://github.com/jesseduffield/lazygit) if installed
- `ggu` - Runs [gitui interface for Git](https://github.com/extrawurst/gitui) if installed
- `gitc` - Runs [Git Commander interface for Git](https://github.com/golbin/git-commander) if installed
- `gitt` - Runs [Tig TUI interface for Git](https://github.com/jonas/tig) if installed
- `gitrv` - Runs [GRV Git repository viewer](https://github.com/rgburke/grv) if installed
- `gitundo` or `ggundo` - Runs [Ugit Git undo](https://github.com/Bhupesh-V/ugit) if installed which can "undo" the last Git command

### Bash Aliases for Common Git Commands

Most of these aliases start with `gg` to avoid alias conflicts and to make it easy to type.

| Alias      | Command                                                     | Description                                                 |
|------------|-------------------------------------------------------------|-------------------------------------------------------------|
| `gg`       | `git`                                                       | Shows a Git status summary or if given arguments invokes Git|
| `ggg`      | `git status`                                                | Shows the standard Git status                               |
| `ggs`      | `git status --short --branch`                               | Shows a short Git status with the branch                    |
| `ggp`      | `git pull`                                                  | Fetch and merge                                             |
| `ggf`      | `git fetch`                                                 | Fetch                                                       |
| `ggm`      | `git merge`                                                 | Merge                                                       |
| `ggpu`     | `git push`                                                  | Push                                                        |
| `ggr`      | `git reset`                                                 | Reset (specify a file to un-add or no file to unstage all)  |
| `gga`      | `git add`                                                   | Add                                                         |
| `ggaa`     | `git add -p`                                                | Add interactively (choose hunks)                            |
| `ggac`     | `git add --all && git commit --verbose -m "commit message"` | Add all and commit with message                             |
| `ggc`      | `git commit --verbose -m "commit message"`                  | Commit with message                                         |
| `ggm `     | `git commit --amend --verbose`                              | Amend last commit                                           |
| `ggl`      | `git log --oneline --graph --decorate --all`                | Log with improved formatting                                |
| `ggll`     | `git log --graph --topo-order --date=iso8601-strict --no-abbrev-commit --decorate --all --boundary` | More detailed log   |
| `ggls`     | `git ls-files`                                              | List all files in repo                                      |
| `ggd`      | `git diff`                                                  | Show changes between commits, commit and working tree, etc. |
| `ggds`     | `git diff --stat`                                           | Show diff statistics                                        |
| `ggdc`     | `git diff --cached`                                         | Show diff of staged changes                                 |
| `ggb`      | `git checkout`                                       | Checkout a branch (lists branches by commit order if not specified)|
| `ggcb`     | `git checkout -b`                                           | Create new branch                                           |
| `ggst`     | `git stash`                                                 | Stash changes                                               |
| `ggsta`    | `git stash -p`                                              | Stash changes interactively                                 |
| `ggpop`    | `git stash pop`                                             | Apply stashed changes                                       |
| `gitclean` | `git reflog expire --all --expire=now && git gc --prune=now --aggressive` | Vacuum Git repo database and clean up logs    |

[Go to the top](#table-of-contents)

# Configuration

## Environment variables and settings

You can change some of the settings of the script without changing your `.bashrc` file (handy for updates) using environment variables. You can put custom environment variables in the following locations and they will automatically be loaded:

- `~/.env`
- `~/.envrc`
- `~/.config/bashrc/config`

The text in the file should be something similar to this example:

```
#!/usr/bin/env bash
#######################################################
# Extreme Ultimate .bashrc Environment Variables
# ~/.env
# ~/.envrc
# ~/.config/bashrc/config
# NOTE: Type env to see a list of set variables
#######################################################

# Alias to edit this file
alias ebe="edit ${BASH_SOURCE}"

#######################################################
# Set/override the default editor
# Examples: vim, nvim, emacs, nano, micro, helix, pico
# or gui apps like kate, geany, gedit, notepadqq, or vscodium
# NOTE: In Git Bash, you can use something like "/c/Program\ Files/Notepad++/notepad++.exe"
#######################################################

# Default text editor for various command-line utilities
# (fallback if VISUAL is not set)
export EDITOR=nano
#export EDITOR=vim

# Default text editor for visual (full-screen) utilities
# (takes precedence over EDITOR)
export VISUAL="${EDITOR}"

# Specifies the editor to use with 'sudo -e' or 'sudoedit'
# (overrides VISUAL and EDITOR)
export SUDO_EDITOR="${EDITOR}"

# Specifies the editor for 'fc' command to edit and re-run
# commands from history (falls back to EDITOR)
export FCEDIT="${EDITOR}"

#######################################################
# Extreme Ultimate .bashrc Configuration
#######################################################

# Determines if CTRL-h will show help
# Ctrl+h (for help) and Ctrl+Backspace share the same key binding
# in some terminal emulators so we default to skip this keybind
_SKIP_HELP_KEYBIND=true

# Show an installed information HUD on initial Bash load (if not skipped)
# Link: https://github.com/LinusDierheimer/fastfetch
# Link: https://ostechnix.com/neofetch-display-linux-systems-information/
# Link: https://github.com/KittyKatt/screenFetch
# Link: https://github.com/deater/linux_logo
# Link: https://github.com/dylanaraps/pfetch
_SKIP_SYSTEM_INFO=false

# If not skipped, shows pending updates (only in Arch, Manjaro, and Ubuntu)
# WARNING: This check for updates takes several seconds so the default is true
_SKIP_UPGRADE_NOTIFY=true

# Automatically launch TMUX terminal multiplexer in local, TTY, or SSH sessions
# https://github.com/tmux/tmux/wiki
# Since TMUX is pre-installed on most systems, these must be enabled here
_TMUX_LOAD_TTY=false
_TMUX_LOAD_SSH=false
_TMUX_LOAD_LOCAL=false

# OPTIONAL: Set and force the default TMUX session name for this script and tm
# If not specified, an active TMUX session is used and attached to
# If no active TMUX session exists, the current logged in user name is used
#_TMUX_LOAD_SESSION_NAME=""

# Terminology is a graphical EFL terminal emulator that can run in TTY sessions
# If installed, it can automatically be launched when starting a TTY session
# To split the window horizontally press Ctrl+Shift+PgUp
# To split the window vertically press Ctrl+Shift+PgDn
# To create Tabs press Ctrl+Shift+T and cycle through using Ctrl+1-9
# Link: https://github.com/borisfaure/terminology
# Link: https://linoxide.com/terminology-terminal/
_SKIP_TERMINOLOGY_TTY=true

# Blesh: Bash Line Editor replaces default GNU Readline
# Link: https://github.com/akinomyoga/ble.sh
# Link for configuration: https://github.com/akinomyoga/ble.sh/blob/master/blerc
# WARNING: Can be buggy with certain prompts (like Trueline)
_SKIP_BLESH=false

# Make sure the default file and directory permissions for newly created files
# in the home directory is umask 026 to improve security.
# (user=read/write/execute, group=read/execute, others=execute for directories)
# The default is to skip this security setting and not modify home permissions
_SKIP_UMASK_HOME=true

# Replaces Sudo with one of the two alternatives (if installed):
# RootDO (rdo) - A very slim alternative to both sudo and doas
# Link: https://codeberg.org/sw1tchbl4d3/rdo
# - OR -
# A port of OpenBSD's doas offers two benefits over sudo:
# 1) Its configuration file has a simple syntax and
# 2) It is smaller, requiring less effort to audit the code
# Link: https://github.com/Duncaen/OpenDoas or https://github.com/slicer69/doas
# Default value is skip and must be set to false manually for security reasons
_SKIP_SUDO_ALTERNATIVE=true

# If set to true, cd will not output the current absolute path under certain
# circumstances like when using the command cd - or using cdable_vars bookmarks
# Link: https://www.gnu.org/software/bash/manual/bash.html#index-cd
_SILENCE_CD_OUTPUT=false

# If set to true, will not load anything that modifies the ls command or colors
_SKIP_LS_COLORIZED=false

# LSD (LSDeluxe) is a rewrite of GNU ls with lots of added features like
# colors, icons, tree-view, more formatting options, git support, etc.
# Fonts: Install the patched fonts of powerline, nerd-font, and/or font-awesome
# Link: https://github.com/Peltoche/lsd
_SKIP_LSD=false

# eza/exa is a modern color replacement for ls that also has some Git support
# Link: https://github.com/eza-community/eza
# Link: https://github.com/ogham/exa
_SKIP_EXA=false

# grc Generic Colouriser
# Link: https://github.com/garabik/grc
_SKIP_GRC=false

# Use built-in aliases for grc Generic Colouriser instead of it's own includes
_GRC_USE_BASHRC_BUILTIN=true

# Choose your preferred picker to use with menus
# Valid pickers can be fzy sk fzf peco percol pick icepick selecta sentaku zf
# or if you want UI pickers, you can choose dmenu rofi or wofi
_PREFERRED_PICKER=rofi

# If set to true, will not source bash completion scripts
_SKIP_BASH_COMPLETION=false

# If set to true, will show a calendar when Bash is started
_SHOW_BASH_CALENDAR=false

# If GNU gcal is installed, use this local for holidays
# To show the possible options type: gcal -hh | grep 'Holidays in'
# Link: https://www.gnu.org/software/gcal/manual/gcal.html
# Link: https://unix.stackexchange.com/questions/164555/how-to-emphasize-holidays-by-color-in-cal-command
_GCAL_COUNTRY_CODE=US_AK

# Skip the birthday/anniversary reminder that shows a message in your teminal?
# Reads the birthday CSV file: ~/.config/birthdays.csv
# The first line is ignored (header) and the format is (year is optional):
# Month,Day,Year,"Message"
# Jan,1,1985,"This is a message!"
#
# Figlet and/or Toilet application is an optional dependency
# Install Arch/Manjaro:  sudo pacman -S toilet
# Install Ubuntu/Debian: sudo apt-get install toilet
_SKIP_BDAY_REMINDER=false

# Set the location for the birthday/anniversary reminder CSV file
# The default location is "~/.config/birthdays.csv" but you can change it here:
#_BDAY_FILE="~/.config/birthdays.csv"

# Set the preferred birthday reminder font here (default is "future"):
#_BDAY_FONT=future

# Set to have the built in prompt use a faster but less precise Git method
# This might be necessary on slow connections or networked directories
# Also if set to true, will remove eza/exa's --git flag (use lsg for Git info)
_GIT_IS_SLOW=false

# Optional original prompt from 2014 version now with newly added Git support
# download the optional .bashrc_prompt script file and place it in either your
# home directory or as the file ~/.config/bashrc/prompt
# You will also need to make sure this setting is set to false
_SKIP_PROMPT_ORIGINAL=false

# If false, the built-in prompt will be one single line with an abbreviated path
# If true, the built-in prompt will split into two lines with a full path
_PROMPT_BUILTIN_FULL_PATH=false

# Trueline Bash (true 24-bit color and glyph support)
# This is the prefered prompt since it looks amazing,
# has so many features, is easily extended using functions,
# and is a single Bash script file that is easy to install.
# Link: https://github.com/petobens/trueline
# Install: wget https://raw.githubusercontent.com/petobens/trueline/master/trueline.sh -P ~/
# Fonts: https://github.com/powerline/fonts
_SKIP_PROMPT_TRUELINE=false

# Powerline-Go (this prompt uses no special glyphs)
# Link: https://github.com/justjanne/powerline-go
_SKIP_PROMPT_POWERLINE_GO=false

# Powerline-Shell (details about git/svn/hg/fossil branch and Python virtualenv environment)
# Link: https://github.com/b-ryan/powerline-shell
_SKIP_PROMPT_POWERLINE_SHELL=false

# Pureline (256 color written in bash script)
# Link: https://github.com/chris-marsh/pureline
# Install:
# git clone https://github.com/chris-marsh/pureline.git
# cp pureline/configs/powerline_full_256col.conf ~/.pureline.conf
_SKIP_PROMPT_PURELINE=false

# Starship Cross Shell Prompt (focus on compatibility and written in Rust)
# Link: https://starship.rs
# Install: sh -c "$(curl -fsSL https://starship.rs/install.sh)"
_SKIP_PROMPT_STARSHIP=false

# Oh-My-Git (only used for Git but has huge support for it, requires font)
# Link: https://github.com/arialdomartini/oh-my-git
# Install: git clone https://github.com/arialdomartini/oh-my-git.git ~/.oh-my-git
_SKIP_PROMPT_OH_MY_GIT=false

# Bash Git Prompt (shows git repository, branch name, difference with remote branch, number of files staged, changed, etc)
# Link: https://github.com/magicmonty/bash-git-prompt
# Install: git clone https://github.com/magicmonty/bash-git-prompt.git ~/.bash-git-prompt --depth=1
_SKIP_PROMPT_BASH_GIT_PROMPT=false

# Bash Powerline (no need for patched fonts, supports git, previous command execution status, platform-dependent prompt symbols)
# Link: https://github.com/riobard/bash-powerline
# Install: curl https://raw.githubusercontent.com/riobard/bash-powerline/master/bash-powerline.sh > ~/.bash-powerline.sh
_SKIP_PROMPT_BASH_POWERLINE=false

# Sexy Bash Prompt (supports git, 256 color)
# Link: https://github.com/twolfson/sexy-bash-prompt
# Install: (cd /tmp && ([[ -d sexy-bash-prompt ]] || git clone --depth 1 --config core.autocrlf=false https://github.com/twolfson/sexy-bash-prompt) && cd sexy-bash-prompt && make install)
_SKIP_PROMPT_SEXY_BASH_PROMPT=false

# Liquid Prompt (adaptive prompt with low color and no glyphs)
# Link: https://github.com/nojhan/liquidprompt
# Install: git clone --branch stable https://github.com/nojhan/liquidprompt.git ~/liquidprompt
_SKIP_PROMPT_LIQUIDPROMPT=false

# Original Powerline Status Line for Vim Bash Zsh fish tmux IPython Awesome i3 Qtile
# Link: https://github.com/powerline/powerline
# Install: https://medium.com/earlybyte/powerline-for-bash-6d3dd004f6fc
# NOTE: Requires Python and can be used with Trueline in Bash
# WARNING: This path may change or break in the future with new Python versions
_SKIP_PROMPT_POWERLINE=false
```

## Using your own or replacing aliases

If you have additional custom aliases (optional in order to not modify your main .bashrc file), put them in a file named one of the following:

- `.bash_aliases`
- `~/.config/bashrc/aliases`

And the text in the file should be the text below or something similar to this example:

```
#!/usr/bin/env bash
#######################################################
# Extreme Ultimate .bashrc Local User Aliases
# ~/.bash_aliases or ~/.config/bashrc/aliases
# NOTE: Type alias (or a) to see a list of set aliases
#######################################################

# Alias to edit this file
alias eba="edit ${BASH_SOURCE}"

# Aliases for SSH
# alias SERVERNAME='ssh USER@SERVER'
# alias SERVERPORT='ssh SERVER -l USERNAME -p PORTNUMBER'
# alias SERVERPASS='sshpass -p 'PASSWORD' ssh USER@HOST'
# alias SERVERTMUX='ssh USER@SERVER -t tmux new-session -A -s main'

# Show the weather from wttr.in using curl
# Link: https://github.com/chubin/wttr.in
alias weather='curl wttr.in'

# You can also remove any existing or conflicting aliases here
# unalias command
```

You can also override most aliases in this file as well.

## Auto-load and source script files

Any file or link found in the `~/.config/bashrc/bashrc.d` folder will automatically be sourced and loaded. If the folder does not exist or is empty, this feature is ignored.

This feature gives you the ability to add features, configurations, environment variables, and bash script code to the `.bashrc` without changing it. This also gives you the flexibility to add/remove things that are dependant to that particular machine. It also makes it easier to update your `.bashrc` file without having to make changes to the base file (which makes it more portable to other machines).

All files are processed in alphabetical order and loaded using the `source` command. To specify a load order, files can be prefixed with numbers (e.g. 00--filename, 50--filename, 95--filename).

There are a couple of provided examples in the `bashrc.d` folder. Just download these into your local `~/.config/bashrc/bashrc.d` directory to load them.

| File | Description |
| ---- | ----------- |
|arch_mirrors_support|If you are using Arch or Manjaro, this script adds a new `mirrors_update` command to automatically use the fastest mirrors. NOTE: You will need to modify this script and replace "United States" with your country name if not in the US.|
|clear_color_spark|Draws a colorful EQ type "spark bar" whenever you clear the screen using `clear` or `cls`|
|trueline_config|If you use the Trueline prompt, this provides customizations and settings. It was moved out of the original code base into this script.|
|tty_terminal_color_scheme|Sets a nice easy-to-read color scheme in TTY terminals (which are launched by pressing CTRL+ALT and 1 through 7).|

Steps to create your own:

1. Create a new file in the folder `~/.config/bashrc/bashrc.d` like `nano ~/.config/bashrc/bashrc.d/testfile`
2. Place bash script code into that file like `echo "Hello World"` and save
3. Reload your terminal

Note: If creating your own prompt, you might need to call `unset PS1` first in your script.

## Move files out of the home folder (optional)

Moving the files out of the home folder is completely optional. These files can be moved to `~/.config/bashrc` but the filenames will be different:

|Original Location|New Location|
|-----------------|------------|
|~/.bashrc_help|~/.config/bashrc/help|
|~/.bash_aliases|~/.config/bashrc/aliases|
|~/.env|~/.config/bashrc/config|
|~/.envrc|~/.config/bashrc/config|
|~/.bashrc_prompt|~/.config/bashrc/prompt|
|~/README.md|~/.config/bashrc/README.md|
|~/trueline.sh|~/.config/bashrc/trueline.sh (If using Trueline prompt)|

This script will automatically move your files for you. Just create a new .sh file, add the text below, make the file executable with `chmod +x filename.sh`, and run it. Optionally, you can run each line one at a time to skip creating a script file.

```
#!/usr/bin/env bash
\mkdir -p ~/.config/bashrc
[[ -f "$HOME/.bashrc_help" ]]   && \mv ~/.bashrc_help ~/.config/bashrc/help
[[ -f "$HOME/.bash_aliases" ]]  && \mv ~/.bash_aliases ~/.config/bashrc/aliases
[[ -f "$HOME/.env" ]]           && \mv ~/.env ~/.config/bashrc/config
[[ -f "$HOME/.envrc" ]]         && \mv ~/.envrc ~/.config/bashrc/config
[[ -f "$HOME/.bashrc_prompt" ]] && \mv ~/.bashrc_prompt ~/.config/bashrc/prompt
[[ -f "$HOME/README.md" ]]      && \mv ~/README.md ~/.config/bashrc/
[[ -f "$HOME/trueline.sh" ]]    && \mv ~/trueline.sh ~/.config/bashrc/
```

[Go to the top](#table-of-contents)

# Path locations for binary files

Note that the following directories will automatically be put into your path if they exist when your shell is loaded:

- `~/.bin`
- `~/bin`
- `~/sbin`
- `~/.local/bin`
- `~/local/bin`

You can place any executable script or binary file in one of those folders and it will always be found in the path meaning you can run it from anywhere on the command line.

# Auto-display message on load

Any text or ASCII in a file named `~/.bash_motd_shown` will be shown each time the shell is loaded.

You can create color coded ASCII text using [jp2a](https://github.com/cslarsen/jp2a) and your own image for an impressive effect:

```
jp2a --color input_image.jpg > ~/.bash_motd_shown
```

[Go to the top](#table-of-contents)

# Birthday and anniversary reminder

A file can be configured with a list of birthdays or anniversaries to show reminders whenever bash is loaded.

You can turn on this feature in [one of the settings files](#environment-variables-and-settings) like this:

```
_SKIP_BDAY_REMINDER=false
```

The `~/.config/birthdays.csv` file that holds the data for the birthday and anniversary reminder feature is a CSV (or Comma Separated Values) file. This is a plain text file that contains multiple lines of data where columns are separated by commas.

Here is an example of the CSV file:

```
Month,Day,Year,"Message"
Aug,25,1991,"Happy Birthday Linux!"
Jun,08,1989,"Happy Birthday Bash!"
Sep,13,,"International Programmers Day"
Sep,27,1983,"Happy Birthday GNU!"
```

If you enter an optional year for a row, you will also be told how many years ago the event happened or the person's age.

You can also type `birthday` to manually run the reminders.

The Linux command line [TOIlet](https://www.linuxlinks.com/toilet/) console font application is an optional dependency and, if installed, will be used for all reminder notices. You can change the default font used in the  [settings](#environment-variables-and-settings)

[Go to the top](#table-of-contents)

# Auto-update

You can do this many different ways using either a cron job, anacron script, or systemd timer. Our example will be a cron job.

An example of a cron job that updates once a week on Sunday at 3 in the morning could look like this below:

`sudo -E crontab -e`

**Make sure to change USERNAME to your account user name in the /home folder (in all 3 places)**

Using curl if installed:
```
00 03 *  *  0 if [[ $(lsattr -R -l /home/USERNAME/.bashrc | grep " Immutable") ]]; then chattr -i /home/USERNAME/.bashrc; fi && curl -L https://sourceforge.net/projects/ultimate-bashrc/files/_bashrc/download --output /home/USERNAME/.bashrc
```

Using wget if installed:
```
00 03 *  *  0 if [[ $(lsattr -R -l /home/USERNAME/.bashrc | grep " Immutable") ]]; then sudo chattr -i /home/USERNAME/.bashrc; fi && wget -c -O /home/USERNAME/.bashrc https://sourceforge.net/projects/ultimate-bashrc/files/_bashrc/download
```

***NOTE:*** You'll notice that if the immutable read only flag is set (to prevent scripts and applications from modifying your `.bashrc` file), it is removed before the update. To put it back, add this to the end of the above commands:
`; sudo chattr +i /home/USERNAME/.bashrc`

[Go to the top](#table-of-contents)

# Extra: Bash App Recommendations

By installing these, you will take advantage of many of the best features in this `.bashrc` file. They are all optional.

For now, these package names are for the Arch repositories, but you can still install most of the applications on many other distros. In fact, many of these are already preinstalled, in the main repositories for many popular distribution, or have Git pages with instructions. I have provided descriptions of each application to make them easier to find.

Click on any of the application names below to visit it's main website.

### Arch Linux Main Repo

- [`aria2`](https://aria2.github.io/) - Download utility that supports HTTP(S), FTP, BitTorrent, and Metalink
- [`axel`](https://github.com/axel-download-accelerator/axel) - Light command line download accelerator
- [`bash-completion`](https://github.com/scop/bash-completion) - Programmable completion for the bash shell
- [`bat`](https://github.com/sharkdp/bat) - Cat clone with syntax highlighting and git integration
- [`bat-extras/batdiff`](https://github.com/eth-p/bat-extras) - Bash scripts that integrate bat with various command line tools
- [`bc`](https://www.gnu.org/software/bc/) - Arbitrary precision calculator language that supports interactive execution of statements
- [`bzip2`](https://sourceware.org/bzip2/) - A high-quality data compression program
- [`colordiff`](https://www.colordiff.org/) - Wrapper for diff that produces the same output but with pretty syntax highlighting
- [`curl`](https://curl.se/) - Command line tool and library for transferring data with URLs
- [`dua-cli`](https://github.com/Byron/dua-cli) - A tool to conveniently learn about the disk usage of directories, fast!
- [`duf`](https://github.com/muesli/duf) - Disk Usage/Free Utility
- [`elinks`](http://elinks.or.cz/) - Advanced feature-rich text-mode web browser
- [`eza`](https://github.com/eza-community/eza) - A modern replacement for ls (community fork of exa)
- [`fd`](https://github.com/sharkdp/fd) - Simple, fast and user-friendly alternative to find
- [`fwupd`](https://fwupd.org/lvfs/docs/users) - Simple daemon to allow session software to update firmware
- [`fx`](https://github.com/antonmedv/fx) - Command-line tool and terminal JSON viewer
- [`fzf`](https://github.com/junegunn/fzf) - Command-line fuzzy finder
- [`fzy`](https://github.com/jhawthorn/fzy) - A better fuzzy finder
- [`gawk`](https://www.gnu.org/software/gawk/) - GNU version of awk
- [`git`](https://git-scm.com/) - The fast distributed version control system
- [`glow`](https://github.com/charmbracelet/glow) - Command-line markdown renderer
- [`grc`](https://github.com/garabik/grc) - Yet another colouriser for beautifying your logfiles or output of commands
- [`gzip`](https://www.gnu.org/software/gzip/) - GNU compression utility
- [`htop`](https://htop.dev/) - Interactive process viewer
- [`lazygit`](https://github.com/jesseduffield/lazygit) - Simple terminal UI for git commands
- [`lnav`](https://lnav.org/) - A curses-based tool for viewing and analyzing log files
- [`lolcat`](https://github.com/busyloop/lolcat) - Okay, no unicorns. But rainbows!!
- [`lsd`](https://github.com/Peltoche/lsd) - Modern ls with a lot of pretty colors and awesome icons
- [`lsof`](https://people.freebsd.org/~abe/) - Lists open files for running Unix processes
- [`lynx`](https://lynx.invisible-island.net/) - A text browser for the World Wide Web
- [`mc`](https://midnight-commander.org/) - A file manager that emulates Norton Commander
- [`micro`](https://micro-editor.github.io/) - Modern and intuitive terminal-based text editor
- [`mlocate`](https://pagure.io/mlocate) - Alternative to locate, faster and compatible with mlocate's database
- [`nano`](https://www.nano-editor.org/) - Pico editor clone with enhancements
- [`nano-syntax-highlighting`](https://github.com/scopatz/nanorc) - Nano editor syntax highlighting enhancements
- [`pbzip2`](https://github.com/ruanhuabin/pbzip2) - Parallel implementation of the bzip2 block-sorting file compressor
- [`pigz`](https://zlib.net/pigz/) - Parallel implementation of the gzip file compressor
- [`pwgen`](https://opensource.com/article/21/7/generate-passwords-pwgen) - Password generator for creating easily memorable passwords
- [`ranger`](https://ranger.github.io/) - Simple, vim-like file manager
- [`ripgrep`](https://github.com/BurntSushi/ripgrep) - A search tool that combines the usability of ag with the raw speed of grep
- [`rsync`](https://rsync.samba.org/) - A fast and versatile file copying tool for remote and local files
- [`the_silver_searcher`](https://github.com/ggreer/the_silver_searcher) - Code searching tool similar to Ack, but faster
- [`tmux`](https://github.com/tmux/tmux) - Terminal multiplexer
- [`trash-cli`](https://github.com/andreafrancia/trash-cli) - Command line trashcan (recycle bin) interface
- [`tree`](https://www.tecmint.com/linux-tree-command-examples/) - A directory listing program displaying a depth indented list of files
- [`w3m`](https://salsa.debian.org/debian/w3m) - Text-based Web browser as well as pager
- [`wget`](https://www.gnu.org/software/wget/) - Network utility to retrieve files from the Web
- [`wl-clipboard`](https://github.com/bugaevc/wl-clipboard) - Command-line copy/paste utilities for Wayland
- [`xclip`](https://github.com/astrand/xclip) - Command line interface to the X11 clipboard
- [`xsel`](http://www.kfish.org/software/xsel/) - Command-line program for getting and setting the contents of the X selection
- [`zoxide`](https://github.com/ajeetdsouza/zoxide) - A smarter cd command for your terminal

`sudo pacman -S --asexplicit aria2 axel bash-completion bat bat-extras bc bzip2 colordiff curl dua-cli duf elinks eza fd fwupd fx fzf fzy gawk git glow grc gzip htop lazygit lnav lolcat lsd lsof lynx mc micro mlocate nano nano-syntax-highlighting pbzip2 pigz pwgen ranger ripgrep rsync the_silver_searcher tmux trash-cli tree w3m wget wl-clipboard xclip xsel zoxide`

### Arch User Repository (AUR)

> If you do not know what the AUR is, [click here to learn how to use it](https://itsfoss.com/aur-arch-linux/).

- [`baca-ereader-git`](https://github.com/wustho/baca) - TUI Ebook Reader
- [`commacd-git`](https://github.com/shyiko/commacd) - A faster way to move around (Bash 3+/Zsh)
- [`enhancd`](https://github.com/b4b4r07/enhancd) - A next-generation cd command with your interactive filter
- [`fzf-tab-completion-git`](https://github.com/lincheney/fzf-tab-completion) - Tab completion using fzf in zsh, bash, GNU readline apps (e.g. python, php -a etc)
- [`git-delta`](https://github.com/dandavison/delta) - Syntax-highlighting pager for git and diff output
- [`hstr`](https://github.com/dvorka/hstr) - Easily view, navigate, search and manage your command history
- [`moar`](https://github.com/walles/moar) - A pager designed to just do the right thing without any configuration
- [`multitail`](https://www.vanheusden.com/multitail/) - View one or multiple files like the original tail program

`yay -S baca-ereader-git commacd-git enhancd git-delta hstr moar multitail`

### Install qfc

A shell auto-complete alternative which features real-time multi-directories matching and results while you type against files in the current directory and its sub-directories

https://github.com/pindexis/qfc

`git clone https://github.com/pindexis/qfc $HOME/.qfc`

---

# Command syntax

## Folder navigation

There are no additional parameters for these commands.

- `..` - Go back 1 folder
- `...` - Go back 2 folders
- `....` - Go back 3 folders
- `.....` - Go back 4 folders
- `..2` - Go back 2 folders
- `..3` - Go back 3 folders
- `..4` - Go back 4 folders
- `..5` - Go back 5 folders

# `a`

Syntax: `a [optional_filter]`

Show a list of all available aliases and functions (in color).

If the optional parameter text filter is specified, only matches will be shown. You can use this to search for text inside aliases and bash functions to find them.

# `aa`

Requires: [abduco](https://www.brain-dump.org/projects/abduco/)

Syntax: `aa [optional_session_name]`

Try to connect to an existing abduco session. If the session does not exist, create it and connect.

The parameter is optional and if not specified, shows a list of active sessions to join. If there are no active sessions, defaults to a session with the same name as the logged in user.

# `aals`

Requires: [abduco](https://www.brain-dump.org/projects/abduco/)

No parameters required (but any parameter that the `abduco` command allows is available)

Issues the default `abduco` command that lists any abduco sessions

# `aareset`

Requires: [abduco](https://www.brain-dump.org/projects/abduco/)

No parameters

Kill all abduco sessions

# `aaro`

Requires: [abduco](https://www.brain-dump.org/projects/abduco/)

Syntax: `aaro [session_name]`

Connect to an abduco session read-only. The session name is required.

# `activewinpid`

No parameters

Get active X-window process ID (after a 3 second delay)

# `alert`

Syntax: `echo "This is an alert" | alert`

Create an alert (also useful for long running commands)

Also see: https://askubuntu.com/questions/423646/use-of-default-alias-alert

# `analyzecode`

Syntax: `analyzecode [filename]`

Analyzes a code file to provide statistics

# `apacheconfig`

No parameters

Automatically find the Apache web server configuration file and edit it. If the configuration cannot be found, it will dump the Apache information that should reveal the location.

# `apacherestart`

No parameters

Restart the Apache web server (requires Apache to be installed)

# `archnews`

Requires: [Arch Linux](https://wiki.archlinux.org/title/Arch_is_the_best) or an [Arch based distribution](https://itsfoss.com/arch-based-linux-distros/)

No parameters

Show the latest Arch linux update news

# `asc2file`

Syntax: `asc2file [filename]`

Decode base64 text from the clipboard and save it to a file

Also see: [`file2asc`](#file2asc)

# `bashrccheckprotect`

No parameters

Check to see the `.bashrc` file has the immutable/write protected flag

# `bashrcprotect`

No parameters

Make the `.bashrc` immutable/write protected (even from root) so that other scripts and applications can't modify it

# `bashrcunprotect`

No parameters

Remove the immutable/write protected flag from the `.bashrc` file

# `bashrcupdate`

No parameters

Automatically update the `.bashrc` file (and the help file) from SourceForge

Also see: [`bashrcupdateforce`](#bashrcupdateforce)

# `bashrcupdateforce`

No parameters

Only updates and overwrites the `~.bashrc` file from SourceForge using an alias

Also see: [`bashrcupdate`](#bashrcupdate)

# `btrcheck`

No parameters

Check status of raid drives

# `btrdefragdir`

No parameters

Defrag a directory

# `btrdefragfile`

No parameters

Defrag a file

# `btrpause`

No parameters

Cancel or pause a scrub

# `btrresume`

No parameters

Resume a paused scrub

# `btrscrub`

No parameters

Start a scrub

# `btrstats`

No parameters

Show device statistics

# `btrstatus`

No parameters

Show status of a scrub

# `cb2file`

Syntax: `cb2file [filename]`

Save the contents of the clipboard to a file

Also see: [`file2cb`](#file2cb)

# `cbshow`

No parameters

Show the contents of the clipboard

# `cg`

Requires: [Git](https://www.linode.com/docs/guides/how-to-install-git-on-linux-mac-and-windows/#how-to-install-git-on-linux)

No parameters

Returns you to the Git project's top level directory

# `check`

Syntax: `check [command]`

Show if a command is aliased, a file, or a built-in command

# `checkloginfailures`

Supported optional dependencies:

- [aureport](https://linux.die.net/man/8/aureport)
- [lastb](https://man7.org/linux/man-pages/man1/lastb.1.html)

No parameters

Check failed login attempts (if supported by your system)

# `checkreboot`

No parameters

Check to see if the system needs to be rebooted (for example after an update)

# `checksha256`

Requires: [sha256sum](https://www.howtodojo.com/sha256sum-command-not-found/) (part of coreutils)

Syntax: `checksha256 [filename]`

Check the sha256 checksum of a file (usually an ISO image) using a checksum file in the same directory

# `chfix`

Syntax: `check [optional_directory]`

Recursively set permissions for code files and directories

If a directory is not specified, then the current directory is used

Warning: This can remove execution permissions on script files

# `chmodcalc`

Syntax: `chmodcalc [octal]` or `chmodcalc [user] [group] [other]`

Examples:

- `chmodcalc 664`
- `chmodcalc rwx rw r`
- `chmodcalc rw- r-- ---`
- `chmodcalc rw - -`

Command line `chmod` calculator

# `chmodcopy`

Syntax: `chmodcopy [source_file] [destination_file]`

Copy permissions from one file/directory to another

# `chmoddirs`

Syntax: `chmoddirs [mode] [optional_folder]`

Examples:

- `chmoddirs 775`
- `chmoddirs +x /some/path`

Recursively change only folder permissions (and skip setting file permission)

# `chmodfiles`

Syntax: `chmodfiles [mode] [optional_folder]`

Examples:

- `chmodfiles 664`
- `chmodfiles +x /some/path`

Recursively change only file permissions (and skip setting directory permissions)

# `cleanmeta`

Requires: [`exiftool`](https://exiftool.sourceforge.net/)

Syntax: `cleanmeta [file_or_files]`

Examples:

- `cleanmeta filename.jpg`
- `cleanmeta ~/Pictures/*.jp*`

Removes embedded Exif data (like geotag location or GPS tracking) from images, videos, and documents

# `cleansystemlogs` or `clearsystemlogs`

Requires: [systemd](https://systemd.io/)

No parameters

Clears log entries from the systemd journal

# `clipboard`

Requires one of: [wl-clipboard](https://github.com/bugaevc/wl-clipboard) for Wayland or, [xclip](https://github.com/astrand/xclip) for X11, [xsel](https://github.com/kfish/xsel) for X11, or [pbcopy](https://ss64.com/osx/pbcopy.html) for Mac

Example: `clipboard             # This shows the clipboard text`

Example: `clipboard 'hi'        # Copy 'text_to_copy' into clipboard"`

Example: `clipboard | less      # Paste clipboard's content into 'less'"`

Example: `cat file | clipboard  # Copy file's content into clipboard"`

Improved terminal clipboard management for viewing, setting, and clearing content, with support for piping input and output.

# `colors`

No parameters

Print a list of colors with escape codes

# `colors24bit`

No parameters

Test for 24 bit true color in the terminal

# `colors256`

No parameters

Print a list of all 256 color codes

# `compressimage`

Requires: [ImageMagick](https://imagemagick.org/index.php)

Syntax: `compressimage [image_file]`

Convert an image to compressed jpg format. The output file will be located in the same directory as the original.

# `configcopy`

Syntax: `configcopy [from_user] [to_user]`

Examples:

- `configcopy bob mary`
- `configcopy john root` # Copy settings to root
- `configcopy "${USER}" default` # Copy settings to default `/etc/skel`

Copy CLI configuration files from one account to another

# `convert2mdtag`

Syntax: `convert2mdtag [markdown_title]`

Converts a markdown title string into a markdown tag

# `countfiles`

No parameters

Count all files recursively (including files in sub-directories) in the current folder

# `cpg`

Syntax: `cpg [source_files] [destination_directory]`

Copy and go to the directory specified as the second parameter

Note: This is not recursive

# `cpp`

Syntax: `cpp [source_files] [destination]`

Optional dependency: [rsync](https://rsync.samba.org/)

Copy files with a progress bar

# `cpu`

No parameters

Show the top 10 CPU processes

# `cpuinfo`

No parameters

Show CPU information

# `createmenu`

Supported optional dependencies:

- [fzy](https://github.com/jhawthorn/fzy) (faster and shows better results than many fuzzy finders)
- [skim](https://github.com/lotabout/skim)
- [fzf](https://github.com/junegunn/fzf)
- [peco](https://github.com/peco/peco)
- [percol](https://github.com/mooz/percol)
- [pick](https://thoughtbot.com/blog/announcing-pick)
- [icepick](https://github.com/felipesere/icepick)
- [selecta](https://github.com/garybernhardt/selecta/)
- [sentaku](https://github.com/rcmdnk/sentaku)
- [zf](https://github.com/natecraddock/zf)
- [dmenu](https://tools.suckless.org/dmenu/)
- [rofi](https://github.com/davatorium/rofi)
- [wofi](https://sr.ht/~scoopta/wofi/)

Examples:

- `ls -1 ~ | createmenu`
- `echo -e "Jen\nTom\nJoe Bob\nAmy\nPat" | sort | createmenu`
- `cat "menuitems.txt" | createmenu`
- `echo "You picked: $(command ls -A -1 ~ | createmenu)"`
- `_TMUX_SESSION="$(tmux ls -F '#{session_name}' 2> /dev/null | createmenu)"`
- `createmenu 'Option 1' 'Option 2' 'Option 3'`
- `createmenu --picker=rofi "Option 1" "Option 2" "Option 3"`
- `echo -e "Red\nGreen\nBlue" | createmenu --picker=dmenu`

Creates a picker menu for selecting an item from a list using input from either piped in multi-line text or command line arguments

It is intended to be used in scripts and more complex commands and returns a single item selected as a string

ALL dependencies are optional and not required

# `createuser`

Syntax: `createuser [optional_username]`

Interactively create, configure, and test a new Linux user

Also see: [`deleteuser`](#deleteuser) and [`wipeuser`](#wipeuser)

# `csvview`

Syntax: `csvview [filename.csv]`

Example: `csvview ~/.config/birthdays.csv`

View any CSV file in the terminal

# `d` or `download`

Requires: [`axel`](https://github.com/axel-download-accelerator/axel) or [`aria2c`](https://aria2.github.io/) or [`wget`](https://www.gnu.org/software/wget/) or [`curl`](https://github.com/curl/curl)

Supported optional dependencies:

- [yt-dlp](https://github.com/yt-dlp/yt-dlp)
- [youtube-dl](https://github.com/ytdl-org/youtube-dl)
- [spotdl](https://github.com/spotDL/spotify-downloader)
- [tidal-dl-ng](https://github.com/exislow/tidal-dl-ng)
- [tidal-dl](https://github.com/yaronzz/Tidal-Media-Downloader)
- [scdl](https://github.com/scdl-org/scdl)

Syntax: `d "[url]"`

Example: `d https://example.net/file.png`

Example: `download "https://sourceforge.net/projects/archlinux/files/latest/download"`

Automatically downloads based on URL by dynamically choosing the appropriate command including from services like Youtube, Spotify, Tidal, and SoundCloud.

# `db`

Requires: [Distrobox](https://github.com/89luca89/distrobox)

Shortcut alias for `distrobox`

# `dbc`

Requires: [Distrobox](https://github.com/89luca89/distrobox)

No parameters

Checks the status of Distrobox docker containers

Also see: [`distrobox-check`](#distrobox-check)

# `dbe`

Requires: [Distrobox](https://github.com/89luca89/distrobox)

Syntax: `dbe [optional_container_name]`

Enter a Distrobox (if one isn't specified then shows a menu picklist of installed containers to choose from)

# `dbhe`

Requires: [Distrobox](https://github.com/89luca89/distrobox)

Syntax: `dbhe [container_name] [command]`

Shortcut to run the `distrobox-host-exec` command

Also see: [distrobox-host-exec](https://github.com/89luca89/distrobox/blob/main/docs/posts/execute_commands_on_host.md)

# `dbl`

Requires: [Distrobox](https://github.com/89luca89/distrobox)

No parameters

List all Distrobox containers

# `dbls`

Requires: [Distrobox](https://github.com/89luca89/distrobox)

No parameters

List only the Distrobox container names (useful for scripts)

Also see: [`distrobox-list-simple`](#distrobox-list-simple)

# `dbs`

Requires: [Distrobox](https://github.com/89luca89/distrobox)

Syntax: `dbs [container_name]`

Stops a Distrobox container

# `dbsa`

Requires: [Distrobox](https://github.com/89luca89/distrobox)

No parameters

Stops all Distrobox containers

# `dbup`

Requires: [Distrobox](https://github.com/89luca89/distrobox)

Syntax: `dbup [optional_container_name]`

Upgrade a Distrobox container or all containers if one is not specified

# `decrypt`

Requires: [GnuPG (GPG)](https://gnupg.org/)

Syntax: `decrypt [encrypted_file.gpg]`

Decrypt an [encrypted file](#encrypt) using GPG AES 256bit symmetric encryption

Also see: [`encrypt`](#encrypt)

# `deleteuser`

Syntax: `deleteuser [username]`

Remove a user from the system

Also see: [`createuser`](#createuser) and [`wipeuser`](#wipeuser)

# `df`

Requires one of: [duf](https://github.com/muesli/duf) or [df](https://www.geeksforgeeks.org/df-command-linux-examples/)

Provides valuable information on disk space utilization

# `diff`

Requires one of: [`delta`](https://github.com/dandavison/delta) (with or without [`bat-extras diff`](https://github.com/eth-p/bat-extras)), [`Icdiff`](https://github.com/jeffkaufman/icdiff), [`colordiff`](https://www.colordiff.org), [`neovim`](https://neovim.io), [`vim`](https://www.vim.org), or the [built-in `diff` command](https://man7.org/linux/man-pages/man1/diff.1.html)

Syntax: `diff [file1] [file2]`

Aliases to use the best terminal diff application depending on what is installed (Use `\diff` to bypass)

The application is chosen in the following order based off the first one found:

- [`delta`](https://github.com/dandavison/delta) (word-level side-by-side highlighting using Levenshtein inference algorithm)
- [`bat-extras diff`](https://github.com/eth-p/bat-extras) (also requires [`delta`](https://github.com/dandavison/delta))
- [`Icdiff`](https://github.com/jeffkaufman/icdiff)
- [`colordiff`](https://www.colordiff.org)
- [`neovim`](https://neovim.io)
- [`vim`](https://www.vim.org)
- [built-in `diff` command](https://man7.org/linux/man-pages/man1/diff.1.html)

# `dirsclear`

No parameters

Clears the directory stack from `pushd`

`dirsclear` is simply an alias for `dirs -c` which clears the directory stack instead of listing it

The `dirs` command shell builtin is used to display the list of currently remembered directories and, by default, it includes the directory you are currently in

A directory can get into the list via `pushd` or `p` command followed by the directory name and can be removed via `popd` or `p-` command

Also see: [`dirsdedup`](#dirsdedup). [`p`](#p), and [`p-`](#p-)

# `dirsdedup`

No parameters

Removes duplicates from the directory stack from `pushd`

Also see: [`dirsclear`](#dirsclear), [`p`](#p), and [`p-`](#p-)

# `diskspace`

Supported optional dependencies:

- [`dua`](https://github.com/Byron/dua-cli) - parallel disk space analyzer in interactive mode TUI/GUI (in color)
- [`gdu`](https://github.com/dundee/gdu) - fast parallel disk usage analyzer written in Go
- [`Ncdu`](https://dev.yorhel.nl/ncdu) - disk usage analyzer with an ncurses interface
- [`diskonaut`](https://github.com/imsnif/diskonaut) - visual treemap of what is taking up your disk space
- [`Dust`](https://github.com/bootandy/dust) - like du written in Rust and more intuitive
- [`du`](https://man7.org/linux/man-pages/man1/du.1.html) - summarize device usage recursively for directories

Syntax: `diskspace [optional_directory]`

This command will help you find out which directories are taking up the most (or least) space

`du` is used if none of the optional dependencies are found

# `distrobox-check`

Requires: [Distrobox](https://github.com/89luca89/distrobox)

No parameters

Checks the status of Distrobox docker containers

Also see: [`dbc`](#dbc)

# `distrobox-list-simple`

Requires: [Distrobox](https://github.com/89luca89/distrobox)

No parameters

List only the Distrobox container names (useful for scripts)

Also see: [`dbls`](#dbls)

# `distrobox-pick`

Requires: [Distrobox](https://github.com/89luca89/distrobox)

No parameters

Shows a menu to choose a Distrobox container (useful for scripts)

# `download-dircolors`

Requires: [dircolors](https://www.gnu.org/software/coreutils/manual/html_node/dircolors-invocation.html)

Alias for downloading the extensive LS_COLORS file `.dircolors` for color directory listings from https://github.com/ahmadassaf/dircolors to the user's home directory

# `e` or `edit`

Syntax: `e [filename]` or `edit [filename]`

Example: `e ~/.bashrc`

Example: `edit /etc/ssh/sshd_config`

An advanced file editing command that enhances security and convenience by automatically handling permissions, symlinks, and immutable files. It can auto-find and edit scripts in your `$PATH`, supports tab renaming with Tmux and other terminals, and performs post-edit actions like prompting to restart services when modifying relevant configuration files—all using your default editor specified in `$EDITOR` (or auto-detected based on installed editors).

Features:

- Easy Access Through Aliasing: Quickly accessible via the `e` alias, streamlining the editing process.
- Automatic Privilege Management: Seamlessly switches between normal editing and `sudoedit` based on file permissions, ensuring secure editing of system files without manual intervention.
- Intelligent Symlink Handling: Automatically detects and resolves symlinks to edit the actual target files, preventing unintended edits to symlink pointers.
- Immutable File Support: Detects files with the immutable attribute (`chattr +i`), prompts to temporarily remove the attribute for editing, and reapplies it after saving changes.
- Auto-Find and Edit Scripts in `$PATH`: If you provide a filename without a path and it exists in your system's `$PATH`, the script locates and opens it for editing.
- Dynamic Tab Management: Integrates with terminal multiplexers and emulators like Tmux, Kitty, WezTerm, Konsole, and many more to rename tabs with the name of the file being edited, enhancing navigation and multitasking.
- Adaptive Editor Selection: Uses the editor specified in the `$EDITOR` environment variable ensuring consistency with your preferred tools. If `$EDITOR` is not set, it is auto-detected based on what's installed.
- Transparent Editing Mode Indication: Clearly indicates when elevated privileges are used (e.g., when using `sudoedit` or `visudo`), keeping you aware of privilege escalations.
- Color-Coded Visual Feedback: Provides colored messages and prompts for better readability and user interaction.
- Security Features: Includes specific procedures for safely editing critical files like `sudoedit` or `/etc/sudoers` by automatically using `visudo` preventing errors that could lock you out.
- Automated Service Management: Recognizes edits to specific configuration files and offers to perform related actions, such as:
	- Reloading shell profiles after editing `~/.bash_profile` or `~/.bashrc`
	- Updating GRUB configuration after editing `/etc/default/grub`
	- Testing and restarting Apache or Nginx after editing their respective configuration files
	- Restarting SSH service after changes to `/etc/ssh/sshd_config`
	- Rebuilding the initial ramdisk with `mkinitcpio` after editing `/etc/vconsole.conf`
	- Refreshing Tmux configuration
	- Merging X resources when relevant files are edited
- Environment Variable Preservation: Maintains your environment variables during elevated editing sessions, preserving local custom settings and configurations.
- Graceful Handling of Non-Existent Files: Attempts to create new files with appropriate permissions, using `sudo` if necessary.
- Extensive Code Comments and Clean Code: The source code is well-documented for ease of customization and understanding, making it ideal for advanced users and developers.

The default editor is the `EDITOR` environment variable usually set in the `~/.bashrc` file, [but can be overridden](#environment-variables-and-settings) in `~/.env` or `~/.envrc` or `~/.config/bashrc/config` like this:

```
#######################################################
# Set the default editor
# Examples: vim, nvim, emacs, nano, micro, helix, pico
#######################################################
export EDITOR=nano
```

# `ebrc`

No parameters

Edit the `.bashrc` file using the default editor. Any parameters passed in does a search in the ~/.bashrc file instead.

Also see: [`findbashrc`](#findbashrc)

# `encrypt`

Requires: [GnuPG (GPG)](https://gnupg.org/)

Syntax: `encrypt [file_to_encrypt]`

Encrypt a file using GPG AES 256bit symmetric encryption

The output file is the original filename with an appended `.gpg` extension

Also see: [`decrypt`](#decrypt)

# `ext3check`

No parameters

Check and repair Ext3 filesystem

# `ext3stats`

No parameters

Show statistics for Ext3 filesystem

# `ext3trim`

No parameters

Trim unused blocks on Ext3 filesystem

# `ext4check`

No parameters

Check and repair EXT4 filesystem

# `ext4stats`

No parameters

Show statistics for EXT4 filesystem

# `ext4trim`

No parameters

Trim unused blocks on EXT4 filesystem

# `extract`

Syntax: `extract [archive_filename]`

Extract any archive(s) into the current directory

Supports:

- `.bz2` - requires [bunzip2](https://sourceware.org/bzip2/)
- `.rar` - requires [rar](https://www.tecmint.com/how-to-open-extract-and-create-rar-files-in-linux/)
- `.gz` - requires [gunzip](https://www.linux.org/docs/man1/gzip.html)
- `.tar` - requires tar
- `.tar.bz2` - requires tar
- `.tar.gz` - requires tar
- `.tbz2` - requires tar
- `.tgz` - requires tar
- `.zip` - requires [unzip](https://www.tecmint.com/install-zip-and-unzip-in-linux/)
- `.Z` - requires [uncompress](https://www.linuxfordevices.com/tutorials/linux/uncompress-z-file)
- `.7z` - requires [7z](https://www.fosslinux.com/43270/how-to-install-and-use-7-zip-in-linux.htm)

# `f`

Supported optional dependency: [`fdfind`](https://github.com/sharkdp/fd)

Syntax: `f [text]`

Syntax: `f --sudo [text]`

Syntax: or use the alias `findfile [text]`

Search filenames in the current folder

Some text may need to be surrounded by quotes - especially if it contains spaces

The --sudo parameter will search as sudo ignoring permissions

# `f2fscheck`

No parameters

Check and repair F2FS filesystem

# `f2fsstats`

No parameters

Show statistics for F2FS filesystem

# `f2fstrim`

No parameters

Trim unused blocks on F2FS filesystem

# `failed`

Requires: [systemd](https://systemd.io/)

No parameters

Show any services that have failed

# `fastping`

Syntax: `fastping [server]`

Some as the ping command except the ping interval is only 1 second

# `fatcheck`

No parameters

Check and repair FAT filesystem

# `fatstats`

No parameters

Show information about FAT filesystem

# `file2asc`

Requires one of: [wl-clipboard](https://github.com/bugaevc/wl-clipboard) for Wayland or, [xclip](https://github.com/astrand/xclip) for X11, [xsel](https://github.com/kfish/xsel) for X11, or [pbcopy](https://ss64.com/osx/pbcopy.html) for Mac

Usage: `file2asc [filename]`

Compress any file to the clipboard as base64 text (see `asc2file`)

Also see: [`asc2file`](#asc2file)

# `file2cb`

Requires one of: [wl-clipboard](https://github.com/bugaevc/wl-clipboard) for Wayland or, [xclip](https://github.com/astrand/xclip) for X11, [xsel](https://github.com/kfish/xsel) for X11, or [pbcopy](https://ss64.com/osx/pbcopy.html) for Mac

Usage: `file2cb [filename]`

Load the contents of a file to the clipboard.

Also see: [`cb2file`](#cb2file)

# `filetimenow`

Syntax: `filetimenow [filename]`

Change a file's (or files using a wildcard) accessed and modified time to now

There is no file creation date in Unix, only access, modify, and change

# `find24`

No parameters

Recursively find all files in the current directory that have been modified in the last 24 hours

# `findalias`

Usage: `findalias "[text]"`

List available aliases with optional filter parameter

# `findapps`

Requires: Graphical desktop environment

Usage: `findapps "[text]"`

Does a text search for installed graphical application in a desktop environment

# `findbashrc`

Usage: findbashrc "[pattern]"

Usage: findbashrc "[pattern1]" "[pattern2]" ...

Example: `findbashrc pkg pacman`

Searches for text inside the ~/.bashrc file

# `findcode`

Usage: `findcode "[text]"`

Usage: `findcode "[regex]"`

Usage: `findcode --sudo "[text]"`

Recursively searches the current directory for text (or regex) in only source code files for 74 different programming languages

Lines longer than 1,000 characters will be cut off because of issues with large files like, for example, minified javascript

The --sudo parameter will search as sudo ignoring permissions

# `findfunction`

Usage: `findfunction "[text]"`

List available functions with optional filter parameter

# `findlinks`

Usage: `findlinks "/backup"`

Recursively find all the symlinks containing search text in the current directory

# `findlog`

Requires: [fzf](https://github.com/junegunn/fzf)

No parameters

Shows all log files in `/var/log` with previews and returns the full filename path of the log chosen

# `findtext`

Usage: `findtext "[text]"`

Usage: `findtext "[regex]"`

Usage: `findtext --sudo "[text]"`

Recursively searches for text in all files in the current folder

Lines longer than 1,000 characters will be cut off because of issues with very large files

The --sudo parameter will search as sudo ignoring permissions

# `firmwareupdate`

Requires: [fwupdmgr](https://fwupd.org/)

Install: `pkginstall fwupdmgr`

No parameters

Update the firmware on Linux automatically and safely using `fwupdmgr` which is used by many companies like Corsair, Dell, HP, Intel, Logitech, etc.

# `fixinvalidexecutepermissions`

Usage: `fixuserhome [optional_directory]`

Remove unneeded and invalid execute permissions from strictly non-executable file types recursively like:

- Archive Files
- Audio Files
- Backup and Temporary Files
- Checksum and Security Files
- Configuration Files
- Cryptographic Key and Certificate Files
- Database Files
- Documents and Text Files
- Font Files
- Gaming and Emulation Files
- Image Files
- Markup and Markdown Files
- Non-Executable Code (should never contain a shebang like CSS or HTML)
- Subtitle Files
- Video Files
- And More

It is good practice to remove execute permissions from data files to enhance security, as script or executable files masquerading as these types could potentially be malicious

# `fixuserhome`

Usage: `fixuserhome [optional_user_name]`

Repairs and sets proper permissions of the home directory (optionally specify a user)

WARNING: This could cause a problem on certain servers. Use with caution!

# `flatpakclean`

Requires: [Flatpak](https://flatpak.org/)

No parameters

Removes orphans and unused Flatpak packages

# `flatpakhas`

Requires: [Flatpak](https://flatpak.org/)

Usage: `flatpakhas [package]`

Show if a Flatpak package is installed and it's information and version

# `flatpakinstall`

Requires: [Flatpak](https://flatpak.org/)

Usage: `flatpakinstall [packages separated by spaces]`

Install a Flatpak package

# `flatpaklist`

Requires: [Flatpak](https://flatpak.org/)

No parameters

List all installed Flatpak packages

# `flatpakmakeicons`

Requires: [Flatpak](https://flatpak.org/)

No parameters

Make icons for all installed Flatpak packages

# `flatpakremotes`

Requires: [Flatpak](https://flatpak.org/)

No parameters

Show all Flatpak repos/remotes

# `flatpakremove`

Requires: [Flatpak](https://flatpak.org/)

Usage: `flatpakremove [package]`

Remove a Flatpak package

# `flatpaksearch`

Requires: [Flatpak](https://flatpak.org/)

Usage: `flatpaksearch [search_text]`

Search for a Flatpak package

# `flatpaksize`

Requires: [Flatpak](https://flatpak.org/)

No parameters

List all installed Flatpak packages and their disk space size

# `flatpakupdate`

Requires: [Flatpak](https://flatpak.org/)

Usage: `flatpakupdate [package]`

Update a Flatpak package

# `flatpakupdateall`

Requires: [Flatpak](https://flatpak.org/)

No parameters

Update all Flatpak packages

# `flatpakwipe`

Requires: [Flatpak](https://flatpak.org/)

Usage: `flatpakwipe [package]`

Remove a Flatpak package and delete all it's data

# `flushcache`

No parameters

Clear RAM memory cache, buffer and swap space

# `flushdns`

Requires: [systemd](https://systemd.io/) (found on most Linux distributions)

Syntax: `flushdns`

No parameters

Clears the DNS (domain name system) cache in order to refresh and update stored domain name resolution information ensuring accurate and up-to-date results

DNS is used to translate human-readable domain names (like `www.example.com`) into IP addresses (like `192.168.1.1`) that networking can understand

# `folders`

No parameters

Recursively list disk space of immediate directories one level deep starting in the current directory

# `free`

No parameters

Display amount of free and used memory in MB

# `fstab`

No parameters

Edit your Linux system's file system table (requires root)

# `fullpath`

Syntax: `fullpath [file]`

Shows full path of file or wildcard

# `gdiff`

Requires one of: [Meld](https://meldmerge.org/), [Kompare](https://apps.kde.org/kompare/), [KDiff3](https://kdiff3.sourceforge.net/), or [XXDiff](http://furius.ca/xxdiff/)

Syntax: `gdiff [file1] [file2]`

Open a diff in a graphical environment using the first graphical UI diff tool found installed

The application is chosen in the following order based off the first one found:

- [Meld](https://meldmerge.org/)
- [Kompare](https://apps.kde.org/kompare/)
- [KDiff3](https://kdiff3.sourceforge.net/)
- [XXDiff](http://furius.ca/xxdiff/)

# `genpw`

Syntax: `genpw [optional_length] [+/-s]`

Example: `genpw`

Example: `genpw 8`

Example: `genpw 128 +s`

Example: `genpw 20 -s`

Generate passwords takes an optional parameter for length and -s or +s for symbols but the user is prompted if not specified

# `getfunctions`

Syntax: `showfunctions [filename]`

Example: `showfunctions ~/.bashrc`

List and sort all function names with line numbers from source code files of most languages

# `gitalias`

Requires: [Git Alias](https://github.com/GitAlias/gitalias) and [Git](https://git-scm.com/)

No parameters

Updates/installs the latest Git aliases

"Git Alias is a collection of git version control alias settings that can help you work faster and better. Git Alias provides short aliases such as s for status, command aliases such as chart and churn, lookup aliases such as whois and whatis, workflow aliases such as topic-begin for feature branch development, and more."

If you install this and the gitalias.txt is located in the user's home folder, it will automatically be sourced and included by the Extreme Ultimate .bashrc File.

# `gitbranch`

Requires: [Git](https://git-scm.com/)

Syntax: `gitbranch [optional_branch_name]`

Changes the current branch

Shows and interactive menu if no branch specified

This command can use following optional pickers and are used in the following order:
- [fzy](https://github.com/jhawthorn/fzy)
- [skim](https://github.com/lotabout/skim)
- [fzf](https://github.com/junegunn/fzf)
- [peco](https://github.com/peco/peco)
- [percol](https://github.com/mooz/percol)
- [pick](https://thoughtbot.com/blog/announcing-pick)
- [icepick](https://github.com/felipesere/icepick)
- [selecta](https://github.com/garybernhardt/selecta/)
- [sentaku](https://github.com/rcmdnk/sentaku)
- [zf](https://github.com/natecraddock/zf)

# `getbranchhelp`

Requires: [Git](https://git-scm.com/)

No parameters

Assist in generating [structured branch names](https://mirocommunity.readthedocs.io/en/latest/internals/branching-model.html) with options for project codes and ticket numbers

It prompts for input step-by-step to form branch names like:

- `prefix/12345-put-description-here`
- `prefix/PROJ-12345-put-description-here`
- `prefix/put-description-here`

The new branch name is also placed on the clipboard if supported

# `gitcommithelp`

Requires: [Git](https://git-scm.com/)

No parameters

Generate standardized [semantic Git commit messages](https://gist.github.com/joshbuchea/6f47e86d2510bce28f8e7f42ae84c716) automatically (with emoji icons) and copy them to the clipboard

This function facilitates the creation of commit messages following [semantic conventions](https://gist.github.com/joshbuchea/6f47e86d2510bce28f8e7f42ae84c716)

[Conventional commits](https://sparkbox.com/foundry/semantic_commit_messages) are a specification for adding human and machine readable meaning to commit messages in order to provide simple navigation through git history and logs

This command prompts for input step-by-step to form commits like:

- 🔧 chore: updating grunt tasks etc; no production code change
- 📝 docs: changes to the documentation
- ✨ feat: new feature for the user, not a new feature for build script
- 🐛 fix: bug fix for the user, not a fix to a build script
- ♻️ refactor: refactoring production code, eg. renaming a variable
- 💅 style: formatting, missing semi colons, etc; no production code change
- 🧪 test: adding missing tests, refactoring tests; no production code change

The new commit message is also placed on the clipboard if supported

# `gitfixsettings`

Requires: [Git](https://git-scm.com/)

Set Git defaults like user name, email, pager, and diff

# `gitls`

Requires: [Git](https://git-scm.com/)

No parameters

List files in the current directory and show each file status in Git

# `gitmodifieddate`

Requires: [Git](https://git-scm.com/)

No parameters

List files in the current directory by Git last modified date

# `gitrepos`

Requires: [Git](https://git-scm.com/)

No parameters

Find all Git repos in the current directory recursively

# `gitresetbranch`

Requires: [Git](https://git-scm.com/)

No parameters

Forces Git to overwrite local files and resets the branch in the current directory

WARNING: This will remove all changes made since the last check-in

# `gitupdaterepos`

Requires: [Git](https://git-scm.com/)

Syntax: `totalsize [optional_levels_deep]`

Update all Git repositories in the current directory. Works only one level deep by default, or the number of levels deep can be specified as a parameter.

# `gpu`

Requires: [NVTOP](https://github.com/Syllo/nvtop)

Runs the NVTOP command if installed. NVTOP stands for Neat Videocard TOP, a (h)top like task monitor for GPUs and accelerators. It can handle multiple GPUs and print information about them in a htop-familiar way.

# `grabvideo`

Requires: [FFmpeg](https://ffmpeg.org/)

Syntax: `encrypt [/path/output_file.mpg]`

Video capture the Linux desktop

# `h`

Syntax: `h [search_text]`

Search command line history (also `CTRL-S` and `CTRL-R`)

# `has`

Syntax: `has [package]`

Show if a package is installed and it's information and version

# `hascommand`

Syntax: `hascommand [--strict] [command-name]`

Example: `[[ hascommand --strict grep ]] && echo "Yes" || echo "No"`

Check if a command or alias exists. If `--strict` is set as a parameter, only accept commands and not aliases.

# `hlp`

No parameters

Show full color help information

# `home`

No parameters

Go to your home folder

# `hoststoggle`

Optional Dependency: [hBlock](https://github.com/hectorm/hblock)

No parameters

Toggle the hosts file off and back on

# `ipexternal`

No parameters

Get outside external IP addresses

# `iplocal`

No parameters

Get local IP addresses

# `json`

Requires: [fx](https://github.com/antonmedv/fx) or [jless](https://jless.io/) or [jq](https://itsfoss.com/pretty-print-json-linux/)

Displays a formatted JSON file in the terminal

# `l.`

Same parameters as `ls`

Directory listing - only show hidden files

# `labc`

Same parameters as `ls`

Directory listing - alphabetical sort

# `lc`

Same parameters as `ls`

Directory listing - sort by change time

# `ldir`

Same parameters as `ls`

Directory listing - directories only

# `les`

Same parameters as `less`

Less with no line numbers showing

# `lfile`

Same parameters as `ls`

Directory listing - files only

# `lines`

Syntax: `lines <FILENAME> <LINE_NUMBER> [OPTIONAL_LINE_NUMBERS...]`

Example: `lines filename.txt 123`

Example: `lines filename.txt 123 456 78`

Example: `lines filename.txt 50-100`

Example: `lines filename.txt 10 20 30-40`

Display specific lines or line ranges from a file

# `lk`

Same parameters as `ls`

Directory listing - sort by size

# `ll`

Same parameters as `ls`

Directory listing - long listing format with full column color

# `lll`

Requires one of: [duf](https://github.com/muesli/duf) or [vizex](https://github.com/bexxmodd/vizex) or [df](https://www.geeksforgeeks.org/df-command-linux-examples/)

Provides valuable information on disk space utilization for local disks

# `llfs`

No parameters

List all files larger than a given size in the current directory

# `lm`

Same parameters as `ls`

Directory listing: pipe through 'more'

# `locount`

Requires: [mlocate](https://www.geeksforgeeks.org/locate-command-in-linux-with-examples/)

Syntax: `locount [part_of_filename_search]`

Display the number of matching filename search entries using the `locate` command

# `logout`

No parameters

Log out the current user out if in a desktop environment

# `logs`

Requires: [tail](https://www.howtogeek.com/481766/how-to-use-the-tail-command-on-linux/)

No parameters

Show all logs in `/var/log`

# `logview`

Requires one of [lnav](https://github.com/tstack/lnav) or [multitail](https://www.vanheusden.com/multitail/) or [tail](https://www.gnu.org/software/coreutils/manual/html_node/tail-invocation.html)

Syntax: `logview [/var/log/filename.log]`

Use sudo to view log files in real time

# `lr`

Same parameters as `ls`

Directory listing: recursive ls

# `lt`

Same parameters as `ls`

Directory listing: sort by date

# `ltree`

Directory listing: tree format

# `lu`

Same parameters as `ls`

Directory listing: sort by access time

# `lw`

Same parameters as `ls`

Directory listing: wide listing format

# `lx`

Same parameters as `ls`

Directory listing: sort by extension

# `m`

Same parameters as `mount`

A short alias to mount a file system

# `mc`

Requires: [Midnight Commander](https://midnight-commander.org/)

Same parameters as `mc`

Alias for Midnight Commander (mc) to exit into current directory if the script is present (usually comes with mc).

It also disables the subshell since this causes problems for many reasons:

- https://unix.stackexchange.com/questions/57439/slow-start-of-midnight-commander
- https://midnight-commander.org/ticket/3580

If you need the subshell, use `mcc` instead or `\mc`.

Also see: [`mcc`](#mcc)

# `mcc`

Requires: [Midnight Commander](https://midnight-commander.org/)

Same parameters as `mc`

Alias for Midnight Commander (mc) to exit into current directory if the script is present (usually comes with mc).

This uses the subshell feature but can take longer to load on some systems.

Also see: [`mc`](#mc)

# `mkdirg`

Same parameters as `mkdir`

Create and go to the directory

# `mostused`

No parameters

See what command you are using the most

# `mvg`

Syntax: `mvg [file(s)_to_move] [new_directory_location/]`

Move and go to the directory

# `mx`

Syntax: `mx [file_or_wildcards]`

Make files executable

# `mysqlconfig`

No parameters

Attempt to automatically locate and edit the MySQL configuration file

# `mysqldatadir`

No parameters

Show MySQL's data directory location

# `netwatch`

Requires: [nethogs](https://github.com/raboof/nethogs) or [iftop](https://www.tecmint.com/iftop-linux-network-bandwidth-monitoring-tool/) or [lsof](https://www.howtogeek.com/426031/how-to-use-the-linux-lsof-command/)

No parameters

Watch real time network activity

# `new`

No parameters

Directory listing showing recently created/updated files in the current directory

# `ngconfig`

No parameters

Automatically find the Nginx web server configuration file and edit it.

# `ngrestart`

No parameters

Restart the Nginx web server (requires Nginx to be installed)

# `now`

No parameters

Show the time

# `ntfscheck`

No parameters

Check and repair NTFS filesystem

# `ntfsstats`

No parameters

Show information about NTFS filesystem

# `open`

Syntax: `open [filename]`

Open any document in it's default window manager application

# `p-`

Quick alias for `popd`

The `popd` command changes the current directory to the directory that was most recently stored by the `pushd` command

Every time you use the `pushd` command, a single directory is stored for your use. However, you can store multiple directories by using the `pushd` command multiple times. The directories are stored sequentially in a virtual stack or list, so if you use the `pushd` command once, the directory in which you use the command is placed at the bottom of the stack. If you use the command again, the second directory is placed on top of the first one. The process repeats every time you use the `pushd` command.

If you use the `popd` command, the directory on the top of the stack is removed and the current directory is changed to that directory. If you use the `popd` command again, the next directory on the stack is removed.

Also see: [`p`](#p), [`dirsclear`](#dirsclear), and [`dirsdedup`](#dirsdedup)

# `p`

Quick alias for `pushd` that now has a deduped directory stack

`pushd` is a shell built-in command which allows us to easily manipulate the directory stack

This appends a directory to the top of the directory stack, or rotates the stack, making the new top of the stack the present working directory. The `d` in `pushd` stands for the directory as it pushes the directory path onto the stack. The directory stack increases in size after each `pushd` command. This stack is based on the Last In First Out (LIFO) principle. This command has an exit status 0 i.e, it returns success unless an invalid argument is supplied or the directory change fails.

Here is an example of how it works:

```
>> dir3 $ p ~/dir2
Directory Stack:
 1  ~/dir2  <-- We just added this to the stack (0 is current directory)
 2  ~/dir3
>> dir2 $ p ~/dir1
Directory Stack:
 0  ~/dir1  <-- We just added this to the stack
 1  ~/dir2
 2  ~/dir3  <-- Now let's go to entry 2 in the list
>> dir1 $ p +2 <-- Go to stack list index 2 which is dir3
Directory Stack:
 0  ~/dir3  <-- Now this directory moved to the top
 1  ~/dir1
 2  ~/dir2
>> dir3 # p
 0  ~/dir1  <-- This is the same as p +1 and swaps location
 1  ~/dir3
 2  ~/dir2
>> dir1 $ dirs  <-- Now we are in ~/dir1, let's list the dirs
Directory Stack:
 0  ~/dir1
 1  ~/dir3
 2  ~/dir2  <-- Let's remove this one by it's index
>> dir1 $ p- +2
Directory Stack:
 0  ~/dir1
 1  ~/dir3  <-- Now ~/dir2 is gone from the stack
>> dir1 $ p-
 0  ~/dir3  <-- Now ~/dir1 is gone from the stack
>> dir3 $   <-- And we switched to the next directory
```

Normally, you would use the `cd` command to move from one directory to another. However, if you spend a lot of time on the command line, `pushd` and `popd` commands will increase your productivity and efficiency.

We can navigate between the dictionaries using the `cd` command. But suppose, you are in the fourth directory. Then to navigate to the second directory, the `cd` command has to be used twice. But by using `pushd` command, it can be achieved in one step. In one step, we can navigate from any directory in the stack to another directory in the stack. Directory manipulation becomes easier and efficient.

Also see: [Directory Navigation Using the `pushd` and `popd` Commands](https://opensource.com/article/19/8/navigating-bash-shell-pushd-popd)

Also see: [`p-`](#p-), [`dirsclear`](#dirsclear), and [`dirsdedup`](#dirsdedup)

# `pacman-clean-cache`

Requires: [Pacman](https://archlinux.org/pacman/) from [Arch Linux](https://archlinux.org/) or [Arch based distros](https://github.com/PandaFoss/Awesome-Arch)

No parameters

Clean the pacman and helper package caches `yay` and `paru` if installed

# `pacmanfix`

Requires: [Pacman](https://archlinux.org/pacman/) from [Arch Linux](https://archlinux.org/) or [Arch based distros](https://github.com/PandaFoss/Awesome-Arch)

No parameters

Fixes most pacman errors

# `pacmanfixkeys`

Requires: [Pacman](https://archlinux.org/pacman/) from [Arch Linux](https://archlinux.org/) or [Arch based distros](https://github.com/PandaFoss/Awesome-Arch)

No parameters

Fix problematic pacman keys

# `pacnew`

Requires: [Pacman](https://archlinux.org/pacman/) from [Arch Linux](https://archlinux.org/) or [Arch based distros](https://github.com/PandaFoss/Awesome-Arch)

No parameters

Check for default configuration file backups

# `path`

No parameters

List the PATH environment variable directories

Normally, to execute a custom program or script, we need to use its full path unless it is found in one of these directories

# `pathappend`

Syntax: `pathappend [directory]`

Add directories to the end of the path (last in the search order)

Also see: [`pathprepend`](#pathprepend)

# `pathprepend`

Syntax: `pathprepend [directory]`

Add directories to the beginning of the path (first in the search order)

Also see: [`pathappend`](#pathappend)

# `pci`

No parameters

Show the PCI device tree

# `phpcheck`

Requires: [PHP](https://www.php.net/)

Syntax: `phpcheck [filename.php]`

Check the syntax of a PHP file for errors

# `phpconfig`

Requires: [PHP](https://www.php.net/)

No parameters

Edit the PHP configuration

# `pkg`

Requires: [pacseek](https://github.com/moson-mo/pacseek) and [Pacman](https://archlinux.org/pacman/) from [Arch Linux](https://archlinux.org/) or [Arch based distros](https://github.com/PandaFoss/Awesome-Arch)

Same parameters as `pacseek`

Launch `pacseek` if installed

# `pkgcheck`

Requires: [pacman-contrib](https://github.com/archlinux/pacman-contrib) and [Pacman](https://archlinux.org/pacman/) from [Arch Linux](https://archlinux.org/) or [Arch based distros](https://github.com/PandaFoss/Awesome-Arch)

Check for updates without root access

# `pkgclean`

No parameters

Removes orphans or unused packages for most distributions

# `pkgdependencies`

Requires: [pacman-contrib](https://github.com/archlinux/pacman-contrib) and [Pacman](https://archlinux.org/pacman/) from [Arch Linux](https://archlinux.org/) or [Arch based distros](https://github.com/PandaFoss/Awesome-Arch)

Syntax: `pkgdependencies [package]`

Add aliases to find dependencies for a package

# `pkgforcereinstall`

Requires: [Pacman](https://archlinux.org/pacman/) from [Arch Linux](https://archlinux.org/) or [Arch based distros](https://github.com/PandaFoss/Awesome-Arch)

Syntax: `pkgforcereinstall [package]`

Force remove a package ignoring required dependencies and then reinstall the package

# `pkgforceremove`

Requires: [Pacman](https://archlinux.org/pacman/) from [Arch Linux](https://archlinux.org/) or [Arch based distros](https://github.com/PandaFoss/Awesome-Arch)

Syntax: `pkgforceremove [package]`

Force remove a package ignoring required dependencies

# `pkginstall`

Syntax: `pkginstall [package]`

Installs a package on most distributions

# `pkginstallregex`

Requires: [Pacman](https://archlinux.org/pacman/) from [Arch Linux](https://archlinux.org/) or [Arch based distros](https://github.com/PandaFoss/Awesome-Arch)

Syntax: `pkginstallregex [regex]`

Install a list of packages using regular expressions (does not include the AUR)

# `pkglist`

No parameters (except on Arch which includes a search text parameter)

List all installed packages on most distributions

# `pkglistmore`

No parameters

List all packages explicitly installed and all dependent packages that are not explicitly installed on most distributions

# `pkglocalpackagefiles`

Requires: [Pacman](https://archlinux.org/pacman/) from [Arch Linux](https://archlinux.org/) or [Arch based distros](https://github.com/PandaFoss/Awesome-Arch)

Syntax: `pkglocalpackagefiles [package]`

List all the local files in an installed package

# `pkgmarkasdependency`

Requires: [Pacman](https://archlinux.org/pacman/) from [Arch Linux](https://archlinux.org/) or [Arch based distros](https://github.com/PandaFoss/Awesome-Arch)

Syntax: `pkgmarkasdependency [package]`

Mark a package as only a dependency

# `pkgmarkasexplicit`

Requires: [Pacman](https://archlinux.org/pacman/) from [Arch Linux](https://archlinux.org/) or [Arch based distros](https://github.com/PandaFoss/Awesome-Arch)

Syntax: `pkgmarkasexplicit [package]`

Mark a package as explicitly installed or only a dependency

# `pkgremove`

Syntax: `pkgremove [package]`

Removes a package on most distributions

# `pkgsearch`

Syntax: `pkgsearch [package]`

Searches for a package on most distributions

# `pkgsearchcontainingfile`

Requires: [Pacman](https://archlinux.org/pacman/) from [Arch Linux](https://archlinux.org/) or [Arch based distros](https://github.com/PandaFoss/Awesome-Arch)

Syntax: `pkgsearchcontainingfile [/path/filename]`

Search for a package containing a file

# `pkgupdate`

Syntax: `pkgupdate [package]`

Updates an installed package on most distributions

# `pkgupdateall`

No parameters

Update the system and all packages on the vast majority of distributions

# `pkgverifyall`

Requires: [Pacman](https://archlinux.org/pacman/) from [Arch Linux](https://archlinux.org/) or [Arch based distros](https://github.com/PandaFoss/Awesome-Arch)

No parameters

Verify all installed packages

# `pkgverifylocalpackage`

Requires: [Pacman](https://archlinux.org/pacman/) from [Arch Linux](https://archlinux.org/) or [Arch based distros](https://github.com/PandaFoss/Awesome-Arch)

Syntax: `pkgverifylocalpackage [package]`

Verify the presence of the files installed by a package

# `pkgwhatuses`

Requires: Ubuntu requires `apt-rdepends` and Arch requires `pacman-contrib`

Find the programs that requires a dependent package (only supported by some package managers/distros)

# `ports`

Requires: [netstat](https://www.howtogeek.com/513003/how-to-use-netstat-on-linux/)

No parameters

Show all open ports

# `preview`

Requires: [fzf](https://github.com/junegunn/fzf)

No parameters

Shows all files recursively in the current directory with previews to open for editing

# `pwcheck`

Requires: [cracklib](https://www.cyberciti.biz/security/linux-password-strength-checker/)

Syntax: `pwcheck [password]`

Check password strength

# `pwd-`

No parameters

Show the previous directory

# `pwdtail`

No parameters

Returns the last 2 fields of the current working directory

# `r`

Also can be called with `ranger`

Requires: [ranger](https://github.com/ranger/ranger)

Same parameters as `ranger`

Launches the ranger application if installed and maintains the last selected directory on exit.

Also see: [`ranger`](#ranger)

# `ranger`

Also can be called with `r`

Requires: [ranger](https://github.com/ranger/ranger)

Same parameters as `ranger`

Launches the ranger application if installed and maintains the last selected directory on exit.

Also see: [`r`](#r)

# `rebootforce`

No parameters

Force a reboot

# `rebootlater`

Syntax: `rebootlater [MILITARY_TIME]`

Example: `rebootlater '02:30'`

Example: `rebootlater '23:00'`

Schedule the computer to auto reboot at a specified time

# `rebootsafe`

No parameters

Reboot safely

# `regexformat`

Syntax: `regexformat "Text to make safe for regex."`

Format and escape text to make it safe for a regular expression search

# `repeat`

Syntax: `repeat [count] [command]`

Example: `repeat 3 echo "test"`

Repeat a command n times

# `resolvesymlink`

Syntax: `resolvesymlink [symlink-or-directory]`

Example: `resolvesymlink ~/.steampath`

Cross-platform realpath equivalent for resolving symlinks to an absolute path

# `rmd`

Syntax: `rmd [directory]`

Remove a directory and all contents and subdirectories

# `rot13`

Syntax: `rot13 "text"`

Run the same command to encrypt or decrypt English text

ROT13 (rotate by 13 places) replaces a letter with the letter 13 letters after it in the alphabet

It has been described as the "Usenet equivalent printing an answer to a quiz upside down" as it provides virtually no cryptographic security

# `runwithfeedback`

Syntax: `runwithfeedback [description] [command]`

Parameters:
1. [description] - Text description to display while the command is running
2. [command] - The command to execute

Example: `runwithfeedback "Hello ${USER}" "sleep 2"`

Example: `runwithfeedback 'This will fail' false`

This function automates the process of executing a command and providing visual feedback. It displays an hourglass symbol next to the provided description while the command is running. Upon successful execution, the hourglass is replaced with a green checkmark. If the command fails, a red cross symbol is displayed instead.

# `runfree`

Syntax: `runfree [command]`

Example: `runfree firefox`

Start a program but immediately disown it and detach it from the terminal

# `say`

Requires one of: [RHVoice](https://rhvoice.org) or [espeak](https://espeak.sourceforge.net/)

Syntax: `say "Hello World"` or `say "I love $(uname --kernel-name)"`

Speak text in a female voice

# `sayclipboard`

Also can be called with `saycb`

Requires one of: [RHVoice](https://rhvoice.org) or [espeak](https://espeak.sourceforge.net/)

Speak the text on the clipboard in a female voice

# `scanscripts`

No parameters

Show all scripts in the current directory and show which shell it uses

# `servicedisable`

Requires: [systemd](https://systemd.io/) (found on most Linux distributions)

Syntax: `servicedisable [service_name]`

Disables a service and prevents startup on boot

# `serviceenable`

Requires: [systemd](https://systemd.io/) (found on most Linux distributions)

Syntax: `serviceenable [service_name]`

Start a service and enable automatic startup at boot

# `servicekill`

Requires: [systemd](https://systemd.io/) (found on most Linux distributions)

Syntax: `servicekill [service_name]`

Force terminate a service

# `servicereload`

Requires: [systemd](https://systemd.io/) (found on most Linux distributions)

Syntax: `servicereload [service_name]`

Reload a service's configuration files

# `servicerestart`

Requires: [systemd](https://systemd.io/) (found on most Linux distributions)

Syntax: `servicerestart [service_name]`

Stop and restart a service

# `services`

Requires: [systemd](https://systemd.io/) (found on most Linux distributions)

No parameters

List all running or failed services

# `servicesall`

Requires: [systemd](https://systemd.io/) (found on most Linux distributions)

No parameters

List all services

# `servicestart`

Requires: [systemd](https://systemd.io/) (found on most Linux distributions)

Syntax: `servicestart [service_name]`

Start a service

# `servicestatus`

Requires: [systemd](https://systemd.io/) (found on most Linux distributions)

Syntax: `servicestatus [service_name]`

Show the status of a service

# `servicestop`

Requires: [systemd](https://systemd.io/) (found on most Linux distributions)

Syntax: `servicestop [service_name]`

Stop a service

# `smash`

Syntax: `smash [firefox]`

Kill process by name with prompt

# `snapclean`

Requires: [Snap](https://ubuntu.com/core/services/guide/snaps-intro)

No parameters

Removes orphans or unused Snap packages

# `snaphas`

Requires: [Snap](https://ubuntu.com/core/services/guide/snaps-intro)

Syntax: `snaphas [package]`

Show if a Snap package is installed and it's information and version

# `snapinstall`

Requires: [Snap](https://ubuntu.com/core/services/guide/snaps-intro)

Syntax: `snapinstall [package]`

Install a Snap package

# `snaplist`

Requires: [Snap](https://ubuntu.com/core/services/guide/snaps-intro)

No parameters

List all installed Snap packages

# `snapremove`

Requires: [Snap](https://ubuntu.com/core/services/guide/snaps-intro)

Syntax: `snapremove [package]`

Remove a Snap package

# `snapsearch`

Requires: [Snap](https://ubuntu.com/core/services/guide/snaps-intro)

Syntax: `snapsearch [text]`

Search for a Snap package

# `snapsize`

Requires: [Snap](https://ubuntu.com/core/services/guide/snaps-intro)

No parameters

List all installed Snap packages and their disk space size

# `snapupdate`

Requires: [Snap](https://ubuntu.com/core/services/guide/snaps-intro)

Syntax: `snapupdate [package]`

Update a Snap package

# `snapupdateall`

Requires: [Snap](https://ubuntu.com/core/services/guide/snaps-intro)

No parameters

Update all Snap packages

# `sparkbars`

No parameters

Draw spark "EQ" type bars across the terminal

# `sshrestart`

No parameters

Restart the SSH service

# `sshstart`

No parameters

Start the SSH service

# `sshstatus`

No parameters

Show if the SSH service is running or not

# `sshstop`

No parameters

Stop the SSH service

# `stopwatch`

No parameters

Command line stop watch timer

# `swapindent`

Syntax: `snapremove [filename]`

Example: `swapindent /path/codefile.sh`

Example: `cat "/path/codefile.sh" | swapindent`

Swaps tab and spaces indentation in the provided file or in standard input

- If a file is provided, it modifies the file in-place
- If no file is provided, it reads from standard input and writes to standard output

# `sync2ssh`

Requires: [rsync](https://rsync.samba.org/)

Syntax: `sync2ssh [LOCAL_DIR] [REMOTE_USER@REMOTE_HOST[:PORT]] [REMOTE_DIR] [OPTIONAL: SSH_PASS]`

Example: `sync2ssh ~/local/folder/ user@example.com /path/on/remote"`

Example with password: `sync2ssh ~/local/folder/ user@example.com /path/on/remote password123"`

Example with custom port: `sync2ssh ~/local/folder/ user@example.com:2222 /path/on/remote"`

Synchronize files using rsync over SSH

# `timeelapsed`

Syntax: `timeelapsed [YYYY-MM-DD] [optional_reason]`

Example: `timeelapsed 1991-08-25 "Linux was announced"`

Shows the amount of time that has elapsed since a date

# `tmattach`

Requires: [Tmux](https://github.com/tmux/tmux/wiki)

Syntax: `tmattach [optional_session_name]`

Attach to an existing Tmux session (shows a menu)

# `tmclients`

Requires: [Tmux](https://github.com/tmux/tmux/wiki)

No parameters

List all Tmux clients

# `tmd`

Requires: [Tmux](https://github.com/tmux/tmux/wiki)

No parameters

Detach from a Tmux session but leave the session running

# `tmkill`

Requires: [Tmux](https://github.com/tmux/tmux/wiki)

Syntax: `tmkill [session_name]`

Kill a Tmux session

# `tmlist`

Requires: [Tmux](https://github.com/tmux/tmux/wiki)

No parameters

List all Tmux sessions

# `tmlistkeys`

Requires: [Tmux](https://github.com/tmux/tmux/wiki)

No parameters

List all the Tmux key bindings

# `tmnew`

Requires: [Tmux](https://github.com/tmux/tmux/wiki)

Syntax: `tmnew [session_name]`

Create a new session

# `tmrename`

Requires: [Tmux](https://github.com/tmux/tmux/wiki)

Syntax: `tmrename [new_session_name]`

Rename a Tmux session

# `tmreset`

Requires: [Tmux](https://github.com/tmux/tmux/wiki)

No parameters

Kill all Tmux sessions

# `tmsessiongroup`

Requires: [Tmux](https://github.com/tmux/tmux/wiki)

Syntax: `tmsessiongroup [session_name]`

Create a new session group (good for multiple monitors)

# `today`

No parameters

Show the date only

# `toiletfont`

No parameters

Shows toilet fonts if toilet is installed

# `toiletfontlist`

No parameters

Shows toilet fonts if toilet is installed

# `top`

Requires one of: [btop](https://github.com/aristocratos/btop), [bpytop](https://github.com/aristocratos/bpytop), [bashtop](https://github.com/aristocratos/bashtop), [nmon](http://nmon.sourceforge.net/pmwiki.php), [glances](https://nicolargo.github.io/glances/), [ytop](https://github.com/cjbassi/ytop), [gtop](https://github.com/aksakalli/gtop), or [htop](https://htop.dev/)

Runs an installed system monitor application with the most or best features.

The application is chosen in the following order based off the first one found:

- [btop](https://github.com/aristocratos/btop)
- [bpytop](https://github.com/aristocratos/bpytop)
- [bashtop](https://github.com/aristocratos/bashtop)
- [nmon](http://nmon.sourceforge.net/pmwiki.php)
- [glances](https://nicolargo.github.io/glances/)
- [ytop](https://github.com/cjbassi/ytop)
- [gtop](https://github.com/aksakalli/gtop)
- [htop](https://htop.dev/)

# `totalsize`

Syntax: `totalsize [optional_directory]`

Show the size of the current or specified directory

# `trash`

Optional Dependencies: [Trash-cli](https://www.tecmint.com/trash-cli-manage-linux-trash-from-command-line/)

Syntax: `trash [filename]`

Send file(s) to the trash (works with most desktop environments)

Also see: [`trashempty`](#trashempty) and [`trashlist`](#trashlist)

# `trashempty`

Optional Dependencies: [Trash-cli](https://www.tecmint.com/trash-cli-manage-linux-trash-from-command-line/)

No parameters

Empty and permanently delete all the files in the trash

Also see: [`trash`](#trash) and [`trashlist`](#trashlist)

# `trashlist`

Optional Dependencies: [Trash-cli](https://www.tecmint.com/trash-cli-manage-linux-trash-from-command-line/)

No parameters

Display the contents of the trash

Also see: [`trash`](#trash) and [`trashempty`](#trashempty)

# `treed`

Requires: [tree](https://www.tecmint.com/linux-tree-command-examples/)

Syntax: `tree [optional_directory]`

List folders recursively in a tree

# `trim`

Syntax: `trim "  text "`

Example: `echo "$(trim '  text ')"`

Trim leading and trailing characters

# `trimcb`

Requires one of: [wl-clipboard](https://github.com/bugaevc/wl-clipboard) for Wayland or, [xclip](https://github.com/astrand/xclip) for X11, [xsel](https://github.com/kfish/xsel) for X11, or [pbcopy](https://ss64.com/osx/pbcopy.html) for Mac

No parameters

Trim leading and trailing characters on the clipboard and replace the clipboard text

# `ttymouseoff`

Requires: [gpm](https://github.com/telmich/gpm) (preinstalled on most distributions)

No parameters

Turns off mouse support in TTY terminals (may require reboot)

# `ttymouseon`

Requires: [gpm](https://github.com/telmich/gpm) (preinstalled on most distributions)

No parameters

Turns on mouse support in TTY terminals

# `ttymousestatus`

Requires: [gpm](https://github.com/telmich/gpm) (preinstalled on most distributions)

No parameters

Determine if mouse support is activated in TTY terminals

# `typefile`

No parameters

Type text straight into a file - press `CTRL-d` when done

# `ui`

No parameters

If in a desktop environment, launch the default file manager in the current directory

# `ulocate`

Requires: [mlocate](https://www.geeksforgeeks.org/locate-command-in-linux-with-examples/)

Syntax: `ulocate [part_of_filename_search]`

Using `mlocate` but update the database before locating a file

# `um`

Same parameters as `umount`

Quick alias to un-mount a file system

# `up`

Syntax: `up 3`

Go up a specified number of folders

# `usb`

Requires: (lsusb)[https://www.howtogeek.com/devops/how-to-use-lsusb-in-linux-with-a-practical-example/]

No parameters

Show the USB device tree

# `ver`

No parameters

Show the version of the OS and kernel

# `whichdisplay`

No parameters

Shows the current display server (e.g. X11 or Wayland)

# `whichtty`

No parameters

Alias to show the current TTY (CTRL-ALT-1 through 7)

# `windowinfo`

Requires: [xprop](https://gitlab.freedesktop.org/xorg/app/xprop) from the X Window system

Change the cursor to a crosshair to select a window for information like geometry, class name, etc.

# `wipeuser`

Syntax: `wipeuser [optional_username]`

Remove a user and all traces (including their home directory) from the system

Also see: [`createuser`](#createuser) and [`deleteuser`](#deleteuser)

# `xfscheck`

No parameters

Check and repair XFS filesystem

# `xfsstats`

No parameters

Show information about XFS filesystem

# `xfstrim`

No parameters

Trim unused blocks on XFS filesystem

# `yt`

Requires: [ytfzf](https://github.com/pystardust/ytfzf)

Syntax: `yt [search_text]`

Play YouTube videos in the terminal

# `ytd`

Requires: [yt-dlp](https://github.com/yt-dlp/yt-dlp) or [youtube-dl](https://github.com/ytdl-org/youtube-dl)

Syntax: `ytd [youtube_video_url]`

Download a YouTube video

# `zattach`

Requires: [Zellij](https://zellij.dev/)

Syntax: `zattach [optional_session_name]`

Attach to an existing Zellij session (shows interactive menu of sessions if not specified)

# `zfscheck`

No parameters

Check and repair ZFS pool

# `zfsdefragdir`

No parameters

Defrag a directory (snapshot-based)

# `zfsdefragfile`

No parameters

Defrag a file (snapshot-based)

# `zfspause`

No parameters

Pause a scrub on ZFS pool

# `zfsresume`

No parameters

Resume a paused scrub on ZFS pool

# `zfsscrub`

No parameters

Start a scrub on ZFS pool

# `zfsscrubstatus`

No parameters

Show status of ZFS pool scrub

# `zfsstats`

No parameters

Show ZFS pool statistics

# `zfsstatus`

No parameters

Check status of ZFS pool

# `zfstrim`

No parameters

Trim unused blocks on ZFS pool

# `zj`

Requires: [Zellij](https://zellij.dev/)

Syntax: `zj [optional_session_name]`

Launch Zellij and create a new session if needed

# `zkill`

Requires: [Zellij](https://zellij.dev/)

Syntax: `zkill [session_name]`

Kill a Zellij session

# `zlist`

Requires: [Zellij](https://zellij.dev/)

No parameters

List all the Zellij sessions

# `znew`

Requires: [Zellij](https://zellij.dev/)

Syntax: `znew [session_name]`

Create a new Zellij session

# `zreset`

Requires: [Zellij](https://zellij.dev/)

No parameters

Kill all Zellij sessions

[Go to the top](#table-of-contents)

---

# License

## [The MIT License (MIT)](https://mit-license.org/)

Copyright © 2024

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the “Software”), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED “AS IS”, WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
