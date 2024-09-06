#!/usr/bin/env bash

# Brian Francisco
# Personal use case packages
# April 19 2024

#   《˘ ͜ʖ ˘》
#
#  ██╗  ██╗██████╗ ███████╗    ██████╗ ██╗  ██╗ ██████╗ ███████╗
#  ██║ ██╔╝██╔══██╗██╔════╝    ██╔══██╗██║ ██╔╝██╔════╝ ██╔════╝
#  █████╔╝ ██║  ██║█████╗      ██████╔╝█████╔╝ ██║  ███╗███████╗
#  ██╔═██╗ ██║  ██║██╔══╝      ██╔═══╝ ██╔═██╗ ██║   ██║╚════██║
#  ██║  ██╗██████╔╝███████╗    ██║     ██║  ██╗╚██████╔╝███████║
#  ╚═╝  ╚═╝╚═════╝ ╚══════╝    ╚═╝     ╚═╝  ╚═╝ ╚═════╝ ╚══════╝
#
# https://patorjk.com/software/taag/#p=display&c=bash&f=ANSI%20Shadow&t=KDE%20Pkgs


# Meta package for KDE accessibility applications

  KDE_accessibility=(
      kmag         # Screen Magnifier
      kmousetool   # Clicks the mouse for you, reducing the effects of RSI
      kmouth       # Speech Synthesizer Frontend
      kontrast     # Tool to check contrast for colors that allows verifying that your colors are correctly accessible
  )

# Meta package for KDE education applications'
  KDE_education=(
      artikulate   # Improve your pronunciation by listening to native speakers
      blinken      # Memory Enhancement Game
      cantor       # KDE Frontend to Mathematical Software
      kalgebra     # Graph Calculator
      kalzium      # Periodic Table of Elements
      kanagram     # Letter Order Game
      kbruch       # Exercise Fractions
      kgeography   # Geography Trainer
      khangman     # Hangman Game
      kig          # Interactive Geometry
      kiten        # Japanese Reference/Study Tool
      klettres     # Learn The Alphabet
      kmplot       # Mathematical Function Plotter
      ktouch       # Touch Typing Tutor
      kturtle      # Educational Programming Environment
      kwordquiz    # Flash Card Trainer
      marble       # Desktop Globe
      minuet       # A KDE Software for Music Education
      parley       # Vocabulary Trainer
      rocs         # Graph Theory IDE
      step         # Interactive Physical Simulator
  )

# Meta package for KDE games'
  KDE_games=(
      bomber         # A single player arcade game
      bovo           # A Gomoku like game for two players
      granatier      # A clone of the classic Bomberman game
      kajongg        # The ancient Chinese board game for 4 players
      kapman         # A clone of the well known game Pac-Man
      katomic        # A fun and educational game built around molecular geometry
      kblackbox      # A game of hide and seek played on a grid of boxes
      kblocks        # The classic falling blocks game
      kbounce        # A single player arcade game with the elements of puzzle
      kbreakout      # A Breakout-like game
      kdiamond       # A single player puzzle game
      kfourinline    # A four-in-a-row game
      kgoldrunner    # A game of action and puzzle solving
      kigo           # An open-source implementation of the popular Go game
      killbots       # A simple game of evading killer robots
      kiriki         # An addictive and fun dice game
      kjumpingcube   # A simple tactical game
      klines         # A simple but highly addictive one player game
      klickety       # An adaptation of the Clickomania game
      kmahjongg      # A tile matching game for one or two players
      kmines         # The classic Minesweeper game
      knavalbattle   # A ship sinking game
      knetwalk       # Connect all the terminals to the server, in as few turns as possible
      knights        # Chess board by KDE with XBoard protocol support
      kolf           # A miniature golf game with 2d top-down view
      kollision      # A simple ball dodging game
      konquest       # The KDE version of Gnu-Lactic
      kpat           # Offers a selection of solitaire card games
      kreversi       # A simple one player strategy game played against the computer
      kshisen        # A solitaire-like game played using the standard set of Mahjong tiles
      ksirk          # A computerized version of a well known strategy game
      ksnakeduel     # A simple snake duel game
      kspaceduel     # Each of two possible players controls a satellite spaceship orbiting the sun
      ksquares       # A game modeled after the well known pen and paper based game of Dots and Boxes
      ksudoku        # A logic-based symbol placement puzzle
      ktuberling     # A simple constructor game suitable for children and adults alike
      kubrick        # Based on the famous Rubik's Cube
      lskat          # Lieutenant Skat is a fun and engaging card game for two players
      palapeli       # A single-player jigsaw puzzle game
      picmi          # A nonogram logic game for KDE
  )

# Meta package for KDE graphics applications'
  KDE_graphics=(
      arianna                    # EPub Reader for mobile devices
      colord-kde                 # Interfaces and session daemon to colord for KDE
      gwenview                   # A fast and easy to use image viewer
      kamera                     # KDE integration for gphoto2 cameras
      kcolorchooser              # Color Chooser
      kdegraphics-thumbnailers   # Thumbnailers for various graphics file formats
      kimagemapeditor            # HTML Image Map Editor
      koko                       # Image gallery application
      kolourpaint                # Paint Program
      kruler                     # Screen Ruler
      okular                     # Document Viewer
      skanlite3                  # Image Scanning Application
      spectacle                  # KDE screenshot capture utility
      svgpart                    # A KPart for viewing SVGs
  )

# Meta package for KDE multimedia applications
  KDE_multimedia=(
      audiocd-kio    # Kioslave for accessing audio CDs
      audiotube      # Client for YouTube Music
      dragon         # A multimedia player where the focus is on simplicity, instead of features
      elisa          # A simple music player aiming to provide a nice experience for its users
      ffmpegthumbs   # Fmpeg-based thumbnail creator for video files
      juk            # A jukebox, tagger and music collection manager
      k3b            # Feature-rich and easy to handle CD burning application
      kamoso         # A webcam recorder from KDE community
      kasts          # Kirigami-based podcast player
      kdenlive       # A non-linear video editor for Linux using the MLT video framework
      kmix           # KDE volume control program
      kwave          # A sound editor
      plasmatube     # Kirigami YouTube video player based on QtMultimedia and youtube-dl
  )

# Meta package for KDE network applications
  KDE_network=(
      alligator                # Kirigami-based RSS reader
      angelfish                # Web browser for Plasma Mobile
      falkon                   # Cross-platform QtWebEngine browser
      kdeconnect               # Adds communication between KDE and your smartphone
      kdenetwork-filesharing   # Properties dialog plugin to share a directory with the local network
      kget                     # Download Manager
      kio-extras               # Additional components to increase the functionality of KIO
      kio-gdrive               # KIO Slave to access Google Drive
      kio-zeroconf             # Network Monitor for DNS-SD services (Zeroconf)
      konqueror                # KDE File Manager & Web Browser
      konversation             # A user-friendly and fully-featured IRC client
      krdc                     # Remote Desktop Client
      krfb                     # Desktop Sharing
      ktorrent                 # A powerful BitTorrent client for KDE
      neochat                  # A client for matrix, the decentralized communication protocol
      tokodon                  # A Mastodon client for Plasma
  )

# Meta package for KDE office applications
  KDE_office=(
      ghostwriter  # Aesthetic, distraction-free Markdown editor
  )

# Meta package for KDE PIM applications
  KDE_pim=(
      akonadiconsole           # Akonadi management and debugging console
      akregator                # A Feed Reader by KDE
      akonadi-calendar-tools   # CLI tools to manage akonadi calendars
      grantlee-editor          # Editor for Grantlee themes
      itinerary                # Itinerary and boarding pass management application
      kaddressbook             # KDE contact manager
      kalarm                   # Personal alarm scheduler
      kleopatra                # Certificate Manager and Unified Crypto GUI
      kmail                    # KDE mail client
      knotes                   # Popup notes
      kontact                  # KDE Personal Information Manager
      korganizer               # Calendar and scheduling Program
      kdepim-addons            # Addons for KDE PIM applications
      merkuro                  # A calendar application using Akonadi to sync with external services
      zanshin                  # To-do management application based on Akonadi
  )

# Meta package for KDE SDK applications
  KDE_skd=(
      cervisia               # CVS Frontend
      dolphin-plugins        # Extra Dolphin plugins
      kde-dev-scripts        # Scripts and setting files useful during development of KDE software
      kde-dev-utils          # Small utilities for developers using KDE/Qt libs/frameworks
      kapptemplate           # KDE Template Generator
      kcachegrind            # Visualization of Performance Profiling Data
      kdesdk-kio             # KDE SDK KIO-Slaves
      kirigami-gallery       # Gallery application built using Kirigami
      kompare                # Graphical file differences tool
      lokalize               # Computer-Aided Translation System
      poxml                  # Translates DocBook XML files using gettext po files
      kdesdk-thumbnailers    # Plugins for the thumbnailing system
      umbrello               # UML modeller
  )

# Meta package for KDE system applications
  KDE_system=(
      dolphin              # KDE File Manager
      kcron                # Configure and schedule tasks
      kde-inotify-survey   # Tooling for monitoring inotify limits and informing the user when they have been or about to be reached
      khelpcenter          # Application to show KDE Applications documentation
      kio-admin            # Manage files as administrator using the admin:// KIO protocol
      kjournald            # Framework for interacting with systemd-journald
      ksystemlog           # System log viewer tool
      partitionmanager     # A KDE utility that allows you to manage disks, partitions, and file systems
  )

# Meta package for KDE utilities applications
  KDE_utilities=(
      ark              # Archiving Tool
      filelight        # View disk usage information
      isoimagewriter   # Program to write hybrid ISO files onto USB disks
      kalk             # A powerful cross-platform calculator application built with the Kirigami framework
      kate             # Advanced text editor
      kbackup          # A program that lets you back up any directories or files
      kcalc            # Scientific Calculator
      kcharselect      # Character Selector
      kclock           #
      kdebugsettings   # An application to enable/disable qCDebug
      kdf              # View Disk Usage
      kdialog          # A utility for displaying dialog boxes from shell scripts
      keditbookmarks   # Bookmark Organizer and Editor
      keysmith         # OTP client for Plasma Mobile and Desktop
      kfind            # Find Files/Folders
      kgpg             # A GnuPG frontend
      kongress         # Companion application for conferences
      konsole          # KDE terminal emulator
      krecorder        # Audio recorder for Plasma Mobile and other platforms
      kteatime         # A handy timer for steeping tea
      ktimer           # Countdown Launcher
      ktrip            # Public Transport Assistance for Mobile Devices
      kwalletmanager   # Wallet management tool
      kweather         # Weather application for Plasma Mobile
      markdownpart     # KPart for rendering Markdown content
      skanpage         # Utility to scan images and multi-page documents
      sweeper          # System Cleaner
      telly-skout      # Convergent TV guide based on Kirigami
      yakuake          # A drop-down terminal emulator based on KDE konsole technology
  )

# Meta package for KDevelop'

  KDevelop=(
      kdevelop         # C++ IDE using KDE technologies
      kdevelop-php     # PHP language and documentation plugin for KDevelop
      kdevelop-python  # Python language and documentation plugin for KDevelop
  )

# Iinstall packagess...
install_packages() {
    echo -e "${ORANGE}$1${NC}"
    sudo sudo pacman -Sy --needed  "${@:2}"
    echo "Package installation completed."
}

# Install KDE accessibility paclages...
install_packages "Installing Essential Software Packages" "${KDE_accessibility[@]}"

# install KDE Education packages...
install_packages "Installing Software Packages" "${KDE_education[@]}"

# Install KDE Games...
install_packages "Installing utilities for different file system access" "${KDE_games[@]}"

# Install KDE graphics packages...
install_packages "Installing utilities for different file system access" "${KDE_graphics[@]}"

# Install KDE multimedia packages...
install_packages "Installing utilities for different file system access" "${KDE_multimedia[@]}"

# Install KDE network utilities...
install_packages "Installing utilities for different file system access" "${KDE_network[@]}"

# Install KDE office packages...
install_packages "Installing utilities for different file system access" "${KDE_office[@]}"

# Install KDE pim packages...
install_packages "Installing utilities for different file system access" "${KDE_pim[@]}"

# Install KDE SDK packages...
install_packages "Installing utilities for different file system access" "${KDE_sdk[@]}"

# Install KDE system utilities...
install_packages "Installing utilities for different file system access" "${KDE_system[@]}"

# Install KDE utilities...
install_packages "Installing utilities for different file system access" "${KDE_utilities[@]}"

# Install KDE Development packages...
install_packages "Installing utilities for different file system access" "${Kdelevop[@]}"

echo "Package installation completed."

sleep 3
