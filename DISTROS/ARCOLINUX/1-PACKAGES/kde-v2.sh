#!/usr/bin/env bash
# Tolga Erok
# For
# Brian


# Define colors
ORANGE='\033[0;33m'
NC='\033[0m' # No Color

# Function to display Brians ASCII art
display_ascii_art() {
    echo -e "
   《˘ ͜ʖ ˘》

  ██╗  ██╗██████╗ ███████╗    ██████╗ ██╗  ██╗ ██████╗ ███████╗
  ██║ ██╔╝██╔══██╗██╔════╝    ██╔══██╗██║ ██╔╝██╔════╝ ██╔════╝
  █████╔╝ ██║  ██║█████╗      ██████╔╝█████╔╝ ██║  ███╗███████╗
  ██╔═██╗ ██║  ██║██╔══╝      ██╔═══╝ ██╔═██╗ ██║   ██║╚════██║
  ██║  ██╗██████╔╝███████╗    ██║     ██║  ██╗╚██████╔╝███████║
  ╚═╝  ╚═╝╚═════╝ ╚══════╝    ╚═╝     ╚═╝  ╚═╝ ╚═════╝ ╚══════╝

     https://patorjk.com/software/taag/#p=display&c=bash&f=ANSI%20Shadow&t=KDE%20Pkgs
    "
}

# Function to install Brians packages
install_packages() {
    local category="$1"
    echo -e "${ORANGE}Installing $category packages${NC}"
    sudo pacman -Sy --needed "${KDE_PACKAGES[$category]}"
    if [ $? -eq 0 ]; then
        echo "Package installation for $category completed."
    else
        echo "Failed to install packages for $category."
    fi
}

# Define Brians package categories
declare -A KDE_PACKAGES=(
    [Accessibility]="kmag kmousetool kmouth kontrast"
    [Education]="artikulate blinken cantor kalgebra kalzium kanagram kbruch kgeography khangman kig kiten klettres kmplot ktouch kturtle kwordquiz marble minuet parley rocs step"
    [Games]="bomber bovo granatier kajongg kapman katomic kblackbox kblocks kbounce kbreakout kdiamond kfourinline kgoldrunner kigo killbots kiriki kjumpingcube klines klickety kmahjongg kmines knavalbattle knetwalk knights kolf kollision konquest kpat kreversi kshisen ksirk ksnakeduel kspaceduel ksquares ksudoku ktuberling kubrick lskat palapeli picmi"
    [Graphics]="arianna colord-kde gwenview kamera kcolorchooser kdegraphics-thumbnailers kimagemapeditor koko kolourpaint kruler okular skanlite3 spectacle svgpart"
    [Multimedia]="audiocd-kio audiotube dragon elisa ffmpegthumbs juk k3b kamoso kasts kdenlive kmix kwave plasmatube"
    [Network]="alligator angelfish falkon kdeconnect kdenetwork-filesharing kget kio-extras kio-gdrive kio-zeroconf konqueror konversation krdc krfb ktorrent neochat tokodon"
    [Office]="ghostwriter"
    [PIM]="akonadiconsole akregator akonadi-calendar-tools grantlee-editor itinerary kaddressbook kalarm kleopatra kmail knotes kontact korganizer kdepim-addons merkuro zanshin"
    [SDK]="cervisia dolphin-plugins kde-dev-scripts kde-dev-utils kapptemplate kcachegrind kdesdk-kio kirigami-gallery kompare lokalize poxml kdesdk-thumbnailers umbrello"
    [System]="dolphin kcron kde-inotify-survey khelpcenter kio-admin kjournald ksystemlog partitionmanager"
    [Utilities]="ark filelight isoimagewriter kalk kate kbackup kcalc kcharselect kclock kdebugsettings kdf kdialog keditbookmarks keysmith kfind kgpg kongress konsole krecorder kteatime ktimer ktrip kwalletmanager kweather markdownpart skanpage sweeper telly-skout yakuake"
    [Development]="kdevelop kdevelop-php kdevelop-python"
)

# Main function to install packages for each Brians category
main() {
    display_ascii_art
    echo -e "${ORANGE}Starting package installation${NC}"
    for category in "${!KDE_PACKAGES[@]}"; do
        install_packages "$category"
    done
    echo "All package installations completed."
}

# Execute main function for Brian
main
