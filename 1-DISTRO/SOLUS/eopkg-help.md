EOPKG(1)                                        General Commands Manual                                       EOPKG(1)

NAME
       eopkg - Solus package manager

SYNOPSIS
       eopkg [options] <command> [arguments]

DESCRIPTION
       eopkg  is the package manager for the Solus operating system. It is used to manage installed software packages,
       search for available software and to apply updates to the system.

OPTIONS
       The following options are applicable to eopkg(1).

       ○   -D, --destdir

           Change the system root for eopkg commands

       ○   -y, --yes-all

           Assume yes in all yes/no queries

       ○   -u, --username

           Set username used when connecting to Basic-Auth repositories. Rarely required.

       ○   -p, --password

           Set password used when connecting to Basic-Auth repositories. Rarely required.

       ○   -L, --bandwidth-limit

           Keep bandwidth usage under the specified (numeric) KBs

       ○   -R, --retry-attempts

           Set the max number of retry attempts in case of connection timeouts

       ○   -v, --verbose

           Detailed output

       ○   -d, --debug

           Enable full debug information and backtraces

       ○   -h, --help

           Print the command line options for eopkg(1) and exit.

       ○   --version

           Print the eopkg(1) version and exit.

       ○   -N, --no-color

           Disable the use of ANSI escape sequences for colourisation by eopkg.

SUBCOMMANDS
       All available subcommands are listed below by their primary name and their alias, if available.  Most  commands
       in eopkg support a short form.

       add-repo (ar) <repo-name> <repo URI>

           Add a new repository to the system with the given name and URI. Note
           that a valid eopkg index file will start with `eopkg-index.xml` and
           typically is compressed with `.xz` or similar.

       --ignore-check:

       --no-fetch:

       --at:

       autoremove (rmf) <package1> <package2> ...

           Remove a package from the system, along with reverse dependencies and
           any automatically installed packages related to this package that are
           now no longer required. This ensures a full removal for direct
           runtime dependencies instead of just reverse dependencies.

       --ignore-dependency:

       --ignore-comar:

       --ignore-safety:

       -n, --dry-run:

       -p, --purge:

       blame (bl) <packagename>

           Show history entry for a given package to show the packages
           changelog. This will integrate automatically with `solbuild(1)`
           git changelog support for official Solus packages, and allow
           inspecting each change.

           By default `blame` will show the information on the highest available
           release.

       -r, --release:

       -a, --all:

       build (bi) <path to pspec.xml>

           Consult `eopkg ? bi` for further details. The legacy `eopkg` format
           is no longer supported by Solus and is only currently used behind
           the scenes in the third party mechanism. New packages should only
           use `package.yml(5)` via `ypkg(1)` and `solbuild(1)`

       check <package?>

           Check the installation status (corruption, etc) of all packages,
           or the provided package names. This subcommand will check the hashes
           for all installed packages to ensure integrity.

       -c, --component:

       --config:

       clean

           Forcibly delete any stale file locks held by previous instances
           of eopkg. This should only be used if the package manager refuses
           to operate due to a stale lockfile, perhaps caused by a previous
           power failure.

       configure-pending (cp)

           Perform any system configuration if any packages are in a pending
           state. This will only invoke `usysconf(1)` and clear the pending
           state. It is also safe to invoke `usysconf run` directly as root.

       delete-cache (dc)

           Clear out any temporary caches still held by `eopkg` for downloads
           and package files. These are automatically cleared when using the
           Software Centre but you must manually invoke `dc` if you only use
           the CLI approach to software management.

       delta (dt) <oldpackage1> <newpackage>

           Construct a delta package between the given packages. Delta packages
           are used to create smaller updates and reduce bandwidth consumption
           for users. Typically deltas are constructed by `ferryd(1)` - however
           for manual repo management you can use this command. A `.delta.eopkg`
           will be constructed in the current working directory.

       -t, --newest-package:

       -O, --output-dir:

       -F, --package-format:

       disable-repo (dr) <name>

           Disable a system repository. It will no longer be accounted for
           in any operation, including search, install, and updates.

       emerge (em) <name>

           Consult `eopkg ? em` for further details. The legacy `eopkg` format
           is no longer supported by Solus and is only currently used behind
           the scenes in the third party mechanism. New packages should only
           use `package.yml(5)` via `ypkg(1)` and `solbuild(1)`

       enable-repo (er) <name>

           Enable a previously disabled repository by name. This will allow
           the repo to be accounted for in all operations (search,
           updates, etc.)

       fetch (fc) <name>

           Download the package file for the named package, into the current
           working directory.

       -o, --output-dir:

       help (?) <subcommand?>

           Display help topics, or help for the given subcommand. Without
           any arguments the main help topic will be displayed, along with
           an overview for all subcommands.

       history (hs)

           Manage the eopkg transaction history. Every operation via `eopkg`
           will cause a new transaction to be recorded, which can be replayed
           through the log or rolled back to.

           Note that rolling back to older snapshots has a limited shelflive
           due to the rolling nature of Solus, and that old packages may
           disappear that were previously installed as part of an older
           transaction.

           Without arguments, this command will just emit the history into the
           `less(1)` pager.

       -l, --last:

       -s, --snapshot:

       -t, --takeback:

       index (ix) <directory>

           Produce an `eopkg-index` repository in the given directory
           containing information on all discovered `eokpg` files living
           recursively under that directory.

           For more advanced repository management, please see `ferryd(1)`

       -a, --absolute-urls:

       -o, --output:

       --compression-types:

       --skip-sources:

       --skip-signing:

       info

           Show information about the given package name or package file.

       -f, --files:

       -c, --component:

       -F, --files-path:

       -s, --short:

       --xml:

       install (it) <name>

           Install a named package or local `.eopkg` directly onto the system.

       --ignore-dependency:

       --ignore-comar:

       --ignore-safety:

       -n, --dry-run:

       --reinstall:

       --ignore-check:

       --ignore-file-conflicts:

       --ignore-package-conflicts:

       -c, --component:

       -r, --repository:

       -f, --fetch-only:

       -x, --exclude:

       --exclude-from <filename>:

       list-available <la> <repo name?>

           List all available packages in all repositories, or just in the
           repositories specified.

       -l, --long:

       -c, --component:

       -U, --uninstalled:

       list-components (lc)

           Show all available components in the combined indexes of all
           installed repositories. Each package may belong to only one
           component, and these are the enforced level of categorisation
           within a Solus repository.

       l, --long:

       r, --repository:

       list-installed (li):

           Show a list of all installed packages.

       -a, --automatic:

       -b, --build-host:

       -l, --long:

       -c, --component:

       -i, --install-info:

       list-newest (ln) <repo?>

           List the newest packages in the repository. With no arguments,
           this will show the newest packages in all configured
           repositories.

       -s, --since:

       -l, --last:

       list-pending (lp)

           Show all packages currently in a state of required configuration.
           This is rarely the case and is nowadays only reserved for the
           building of images, where `configure-pending` is invoked after
           all required packages are installed, due to the incremental nature
           of `usysconf(1)`.

       list-repo (lr)

           List all currently tracked repositories, and emit their
           status (enabled or not)

       list-sources (ls)

           This is only supported with source repositories using the
           legacy `pspec.xml` ormat and is no longer recommeneded or
           supported. When invoked, this will output all source packages
           available for `emerge` operations.

       -l, --long:

       list-upgrades (lu)

           List all package upgrades that are currently available.

       -l, --long:

       -c, --component:

       -i, --install-info:

       rebuild-db (rdb)

           Rebuild all `eopkg` databases. This may be required if eopkg
           is interrupted or killed during an operation, and complains
           that database recovery is required (DB5 errors). Running this
           command will reassemble the database from all the installed
           packages.

       -f, --files:

       remove (rm) <package1> <package2> ...

           Remove packages from the system. Unless `--ignore-dependency`
           is specified, any reverse dependencies will also be removed
           from the system. This does not remove packages that are
           dependencies of the package being removed, however. For those
           packages, use `rmf` or later invoke `rmo`.

       --ignore-comar:

       --ignore-safety:

       -n, --dry-run:

       -p, --purge:

       -c, --component:

       remove-orphans (rmo)

           Remove any packages that were automatically installed and
           no longer have any dependency relationship with non
           automatically installed packages on the system.

           Note that in Solus terminology an orphan is a proveable
           concept, not an automatic heuristic. Thus, the only
           candidates in the algorithm are those packages that
           were marked automatic as dependencies of another operation,
           and are no longer required by other packages on the system
           that aren´t automatically installed.

       --ignore-comar:

       --ignore-safety:

       -n, --dry-run:

       -p, --purge:

       search (sr) <term>

           Finds packages using the specified search term, which can
           be a regular expression when quoted.

       -l, --language:

       -r, --repository:

       -i, --installdb:

       -s, --sourcedb:

       --name:

       --summary:

       --description:

       search-file (sf) <path>

           Locate the package which is considered to be the owner of
           the specified path on disk. Currently only locally installed
           packages are supported.

       -l, --long:

       -q, --quiet:

       update-repo (ur) <reponame?>

           With no arguments this command will update all repository
           indexes by fetching them from their origin if a change
           has occurred. This will then synchronise the remote
           data with the local data so that changes to the repository
           are now visible to eopkg.

           You may optionally specify a repository name to only
           update that repository.

       -f, --force:

       upgrade (up) <package-name?>

           With no arguments this command will perform a full system
           upgrade, otherwise it will update the specified packages
           along with any resulting dependencies.
           Initially the remote repositories will be updated to ensure
           all metadata is up to date.

           During an upgrade, any packages marked as `Obsolete` will
           automatically be removed from the system. Any package
           replacements for packages that have been replaced with
           different upstreams, or indeed name changes, will
           be applied too. Thus, package removals are a normal
           part of the upgrade experience.

       --ignore-comar:

       --ignore-safety:

       -n, --dry-run:

       --security-only:

       -b, --bypass-update-repo:

       --ignore-file-conflicts:

       --ignore-package-conflicts:

       -c, --component:

       -r, --repository:

       -f, --fetch-only:

       -x, --exclude:

       --exclude-from <filename>:

EXIT STATUS
       On success, 0 is returned. A non-zero return code signals a failure.

COPYRIGHT
       ○   This documentation is Copyright © 2018 Ikey Doherty, License: CC-BY-SA-3.0

SEE ALSO
       usysconf(1), solbuild(1), ferryd(1), ypkg(1), package.yml(5)

       ○   https://github.com/solus-project/package-management

       ○   https://wiki.solus-project.com/Packaging

NOTES
       Creative Commons Attribution-ShareAlike 3.0 Unported

       ○   http://creativecommons.org/licenses/by-sa/3.0/

                                                     February 2022                                            EOPKG(1)
