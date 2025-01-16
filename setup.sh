#!/bin/bash
### #!/usr/bin/env bash

# Brian Francisco
# Personal use case packages
# 27 Feb 2024

#   《˘ ͜ʖ ˘》
#
#  ██████╗ ██╗███████╗████████╗██████╗  ██████╗      ██████╗██╗  ██╗███████╗ ██████╗██╗  ██╗
#  ██╔══██╗██║██╔════╝╚══██╔══╝██╔══██╗██╔═══██╗    ██╔════╝██║  ██║██╔════╝██╔════╝██║ ██╔╝
#  ██║  ██║██║███████╗   ██║   ██████╔╝██║   ██║    ██║     ███████║█████╗  ██║     █████╔╝
#  ██║  ██║██║╚════██║   ██║   ██╔══██╗██║   ██║    ██║     ██╔══██║██╔══╝  ██║     ██╔═██╗
#  ██████╔╝██║███████║   ██║   ██║  ██║╚██████╔╝    ╚██████╗██║  ██║███████╗╚██████╗██║  ██╗
#  ╚═════╝ ╚═╝╚══════╝   ╚═╝   ╚═╝  ╚═╝ ╚═════╝      ╚═════╝╚═╝  ╚═╝╚══════╝ ╚═════╝╚═╝  ╚═╝
#
#  https://patorjk.com/software/taag/#p=display&c=bash&f=ANSI%20Shadow&t=Distro%20Check

# Check distribution type (Arch, Debian, Fedora, Nix or Solus) and call respective function from above

declare -a arch_packages=(
    # Add Arch Linux packages here
)

declare -a fedora_packages=(
    # Add Fedora packages here
)

declare -a solus_packages=(
    # Add Solus packages here
)

declare -a ubuntu_packages=(
    # Add Ubuntu packages here
)

declare -a porn_hub_packages=(
    # Add Porn Hub packages here
)

if [ -f /etc/debian_version ]; then
    echo ""
    echo -e "\e[34mDebian-based distribution detected.\e[0m"  # Blue color
    echo ""
#    install_debian_packages "${ubuntu_packages[@]}"
    ( exec "$HOME/GitHub/brian-everything/MX-LINUX/1-PACKAGES/1-PKGS.sh" )
elif [ -f /etc/redhat-release ]; then
    echo ""
    echo -e "\e[34mFedora-based distribution detected.\e[0m"  # Blue color
    echo ""
#    install_fedora_packages "${fedora_packages[@]}"
    ( exec "$HOME/GitHub/brian-everything/ULTRAMARINE/mushroom-magic/1-PACKAGES/packages.sh" )
elif [ -f /usr/bin/eopkg ]; then
    echo ""
    echo -e "\e[34mSolus-based distribution detected.\e[0m"  # Blue color
    echo ""
#    install_solus_packages "${solus_packages[@]}"
    ( exec "$HOME/GitHub/brian-everything/SOLUS/1-PACKAGES/packages.sh" )
elif [ -f /etc/lsb-release ]; then
    # Ubuntu uses /etc/lsb-release
    echo ""
    echo -e "\e[34mUbuntu-based distribution detected.\e[0m"  # Blue color
    echo ""
#    install_ubuntu_packages "${ubuntu_packages[@]}"
    ( exec "path/to/script" )
elif [ -f /etc/arch-release ]; then
    # Arch Linux uses /etc/arch-release
    echo ""
    echo -e "\e[34mArch Linux-based distribution detected.\e[0m"  # Blue color
    echo ""
#    install_arch_packages "${arch_packages[@]}"
    ( exec "$HOME/GitHub/brian-everything/ARCH/1-PACKAGES/packages.sh" )
else
    echo "Unsupported distribution."
fi
