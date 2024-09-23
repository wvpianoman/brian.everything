#!/usr/bin/env bash

# Brian Francisco

#  ███╗   ██╗██╗██╗  ██╗     ██████╗ ██╗  ██╗ ██████╗ ███████╗
#  ████╗  ██║██║╚██╗██╔╝     ██╔══██╗██║ ██╔╝██╔════╝ ██╔════╝
#  ██╔██╗ ██║██║ ╚███╔╝█████╗██████╔╝█████╔╝ ██║  ███╗███████╗
#  ██║╚██╗██║██║ ██╔██╗╚════╝██╔═══╝ ██╔═██╗ ██║   ██║╚════██║
#  ██║ ╚████║██║██╔╝ ██╗     ██║     ██║  ██╗╚██████╔╝███████║
#  ╚═╝  ╚═══╝╚═╝╚═╝  ╚═╝     ╚═╝     ╚═╝  ╚═╝ ╚═════╝ ╚══════╝
#
# https://patorjk.com/software/taag/#p=display&c=bash&f=ANSI%20Shadow&t=Nix-Pkgs

export NIXPKGS_ALLOW_UNFREE=1

nix-env -iA nixpkgs.cowsay
nix-env -iA nixpkgs.direnv
nix-env -iA nixpkgs.fanctl
nix-env -iA nixpkgs.figlet
export NIXPKGS_ALLOW_UNFREE=1 && nix-env -iA nixpkgs.megasync

# nix-env -iA nixpkgs.fortune
# nix-env -iA nixpkgs.gum
# nix-env -iA nixpkgs.haveged
# nix-env -iA nixpkgs.codec2
# nix-env -iA nixpkgs.uim
# nix-env -iA nixpkgs.gtk-engine-murrine
# nix-env -iA nixpkgs.mbpfan
# nix-env -iA nixpkgs.p7zip
# nix-env -iA nixpkgs.cron
# nix-env -iA nixpkgs.cronutils
# nix-env -iA nixpkgs.cifs-utils
# nix-env -iA nixpkgs.gnome.dconf-editor
# nix-env -iA nixpkgs.dnsutils
# nix-env -iA nixpkgs.ugrep
# nix-env -iA nixpkgs.nettools
# nix-env -iA nixpkgs.profile-sync-daemon
# nix-env -iA nixpkgs.exfat
# nix-env -iA nixpkgs.apfs-fuse
# nix-env -iA nixpkgs.hfsprogs
# nix-env -iA nixpkgs.jfsutils
# nix-env -iA nixpkgs.nilfs-utils
# nix-env -iA nixpkgs.reiser4progs
# nix-env -iA nixpkgs.apfsprogs

