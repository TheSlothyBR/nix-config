{ pkgs
, inputs
, config
, isUser
, lib
, ...
}:{
  imports = [
    
  ];

  options = {
    custom.plasma = {
      enable = lib.mkEnableOption "Plasma Desktop config";
    };
  };

  config = lib.mkIf config.custom.plasma.enable {
    services.desktopManager.plasma6.enable = true;

    environment.persistence."/persist" = {
      users.${isUser} = {
        directories = [
          ".local/share/icons" #only klassy needs this, probably can be changed
        ];
      };
    };

    environment = {
      sessionVariables = {
        GTK_USE_PORTAL = 1;
      };
      plasma6.excludePackages = with pkgs.kdePackages; [
        ark
        discover
        elisa
        gwenview
        kate
        khelpcenter
        konsole
        okular
        print-manager
      ];
      systemPackages = let
        stable = with pkgs; [
          kdePackages.qtstyleplugin-kvantum
          kdePackages.sddm-kcm
          inputs.kvlibadwaita.packages.${pkgs.system}.default
          (callPackage ../../pkgs/kde-material-you-colors-widget.nix {})
          (callPackage ../../pkgs/kde-panel-spacer-extended-widget.nix {})
          (callPackage ../../pkgs/kde-wallpaper-effects-widget.nix {})
          (callPackage ../../pkgs/yaru-unity-plasma-icons.nix {})
          (callPackage ../../pkgs/flatpak-xdg-utils.nix {})
          kde-rounded-corners
          kara
          kando
          application-title-bar
          plasma-panel-colorizer
          python312Packages.kde-material-you-colors
          inputs.kwin-effects-forceblur.packages.${pkgs.system}.default
          kdePackages.krohnkite
        ];
        unstable = with pkgs.unstable; [
        
        ];
      in
        stable ++ unstable;
    };

    qt = {
      enable = true;
      platformTheme = "kde";
      #style = "kvantum";
    };

    home-manager = {
      sharedModules  = [
        inputs.plasma-manager.homeManagerModules.plasma-manager
      ];
      users.${isUser} = {
        #xdg.configFile = {
        #  "Kvantum/kvantum.kvconfig".text = "[General]\ntheme=KvLibadwaita"; #KvLibadwaitaDark, this implementation creates reaad-only symlink
        #};

        programs.plasma = {
          enable = true;
          overrideConfig = true;
          workspace = {
            #theme = "Colloid-dark";
            #colorScheme = "ColloidDark";
            #windowDecorations = {
            #  library = "org.kde.kwin.aurorae";
            #  theme = "__aurorae__svg__Colloid-dark-round";
            #};
            #splashScreen = {
            #  theme = "Colloid-dark";
            #};
            #cursor = {
            #  theme = "breeze_cursors";
            #};
            #iconTheme = "YaruPlasma-Dark";
            soundTheme = "ocean";
            clickItemTo = "select";
            wallpaper = "${pkgs.kdePackages.plasma-workspace-wallpapers}/share/wallpapers/ScarletTree/contents/images/5120x2880.png";
          };
          kwin = {
            titlebarButtons = {
              right = [  ];
              left = [  ];
            };
            borderlessMaximizedWindows = true;
            effects = {
              blur.enable = false;
            };
            virtualDesktops = {
              number = 3;
              rows = 1;
              names = [
                "Leisure"
                "Productivity"
                "Gaming"
              ];
            };
          };
          #window-rules = [
          #  {
          #    description = "Name";
          #    match = {
          #      text
          #    };
          #    apply = {
          #      text
          #    };
          #  }
          #];
          desktop = {
            widgets = [
              {
                name = "luisbocanegra.desktop.wallpaper.effects";
                config = {
                  General = {
                    hideWidget = true;
                  };
                };
                position = {
                  horizontal = 1200;
                  vertical = 700;
                };
                size = {
                  width = 60;
                  height = 60;
                };
              }
            ];
          };
          panels = [
            {
              location = "top";
              floating = true;
              alignment = "left";
              lengthMode = "fill";
              height = 34;
              hiding = "none";
              widgets = [
                {
                  kickoff = {
                    icon = "nix-snowflake";
                    sortAlphabetically = false;
                    compactDisplayStyle = false;
                    favoritesDisplayMode = "list";
                    showButtonsFor = "power";
                    pin = false;
                    sidebarPosition = "left";
                  };
                }
                {
                  name = "org.dhruv8sh.kara";
                  config = {
                    appearance = {
                      defaultAltTextColors = false;
                      plasmaTxtColors = true;
                    };
                    mouseActions = {
                      tooltipOnHover = true;
                    };
                    general = {
                      animationDuration = 40;
                      highlightOpacityFull = false;
                      highlightType = 1;
                      type = 0;
                    };
                    type1.t1activeWidth = 30;
                  };
                }
                "luisbocanegra.panel.colorizer"
                "org.kde.plasma.appmenu" 
                "luisbocanegra.panelspacer.extended"
                "org.kde.plasma.mediacontroller"
                {
                  applicationTitleBar = {
                    layout = {
                      widgetMargins = 5;
                      spacingBetweenElements = 3;
                      showDisabledElements = "hide";
                      elements = [
                        "windowIcon"
                        "windowMinimizeButton"
                        "windowMaximizeButton"
                        "windowCloseButton"
                      ];
                    };
                    windowControlButtons = {
                      #iconSource = "aurorae";
                      #auroraeTheme = "Colloid-dark-round";
                      buttonsMargin = 2;
                    };
                  };
                }
                {
                  systemTray = {
                    pin = false;
                    icons = {
                      spacing = "small";
                      scaleToFit = false;
                    };
                    items = {
                      showAll = false;
                      shown = [
                        "org.kde.plasma.networkmanagement"
                        "org.kde.plasma.volume"
                        "org.kde.plasma.battery"
                        "org.kde.plasma.systemMonitor"
                      ];
                      hidden = [
                        "org.kde.plasma.bluetooth"
                        "org.kde.plasma.brightness"
                        "luisbocanegra.kdematerialyou.colors"
                        "org.kandomenu.kando"
                        "org.kde.plasma.notifications"
                        "org.kde.plasma.devicenotifier"
                        "org.kde.plasma.cameraindicator"
                        "org.kde.plasma.mediacontroller"
                        "org.kde.plasma.clipboard"
                        "org.kde.plasma.kscreen"
                      ];
                      configs = {
                        systemMonitor = {
                          displayStyle = "org.kde.ksysguard.barchart";
                          title = "System Resources";
                          showTitle = true;
                          showLegend = true;
                          sensors = [
                            {
                              name = "cpu/all/usage";
                              color = "87, 118, 182";
                              label = "CPU";
                            }
                            {
                              name = "gpu/all/usage";
                              color = "181, 150, 87";
                              label = "GPU";
                            }
                            {
                              name = "memory/physical/usedPercent";
                              color = "168, 101, 157";
                              label = "Memory";
                            }
                            {
                              name = "memory/swap/usedPercent";
                              color = "92, 177, 107";
                              label = "Swap";
                            }
                          ];
                        };
                      };
                    };
                  };
                }
                {
                  digitalClock = {
                    date = {
                      enable = true;
                      position = "belowTime";
                    };
                    time = {
                      showSeconds = "onlyInTooltip";
                      format = "24h";
                    };
                    timeZone = {
                      selected = [ "Local" ];
                      format = "code";
                      alwaysShow = false;
                    };
                  };
                }
                {
                  name = "org.kde.plasma.lock_logout";
                  config.General = {
                    showShutdown = true;
                    showRestart = true;
                    showLock = false;
                    showSwitchUser = false;
                    showLogout = false;
                    showSleep = false;
                    showSuspend = false;
                    showHibernate = false;
                  };
                }
              ];
            }
            {
              location = "bottom";
              floating = true;
              alignment = "center";
              lengthMode = "fit";
              height = 54;
              hiding = "dodgewindows";
              widgets = [
                {
                  iconTasks = {
                    launchers = [
                      "preferred://filemanager"
                      "applications:org.wezfurlong.wezterm.desktop"
                      "preferred://browser"
                      "applications:md.obsidian.Obsidian.desktop"
                      "applications:org.keepassxc.KeePassXC.desktop"
                      "applications:rclone-browser.desktop"
                    ];
                    appearance = {
                      showTooltips = true;
                      highlightWindows = true;
                      indicateAudioStreams = true;
                      fill = true;
                      rows = {
                        multirowView = "never";
                      };
                      iconSpacing = "small";
                    };
                    behavior = {
                      grouping = {
                        method = "byProgramName";
                        clickAction = "cycle";
                      };
                      sortingMethod = "none";
                      minimizeActiveTaskOnClick = true;
                      middleClickAction = "newInstance";
                      wheel = {
                        switchBetweenTasks = true;
                        ignoreMinimizedTasks = true;
                      };
                      showTasks = {
                        onlyInCurrentScreen = false;
                        onlyInCurrentDesktop = true; 
                        onlyInCurrentActivity = true; 
                        onlyMinimized = false;
                      };
                      unhideOnAttentionNeeded = true;
                      newTasksAppearOn = "right";
                    };
                  };
                }
                "luisbocanegra.panel.colorizer"
              ];
            }
          ];
          powerdevil = {
            AC = {
              autoSuspend = {
                action = "sleep";
                idleTimeout = 600;
              };
              turnOffDisplay = {
                idleTimeout = 300;
                idleTimeoutWhenLocked = 30;
              };
              dimDisplay.enable = false;
              whenLaptopLidClosed = "hibernate";
              whenSleepingEnter = "standbyThenHibernate";
            };
            battery = {
              autoSuspend = {
                action = "sleep";
                idleTimeout = 300;
              };
              turnOffDisplay = {
                idleTimeout = 180;
                idleTimeoutWhenLocked = 30;
              };
              dimDisplay.enable = false;
              whenLaptopLidClosed = "turnOffScreen";
              whenSleepingEnter = "standbyThenHibernate";
            };
            lowBattery = {
              autoSuspend = {
                action = "hibernate";
                idleTimeout = 300;
              };
              turnOffDisplay = {
                idleTimeout = 180;
                idleTimeoutWhenLocked = 30;
              };
              dimDisplay.enable = false;
              whenLaptopLidClosed = "hibernate";
              whenSleepingEnter = "standbyThenHibernate";
            };
          };
          input = {
            keyboard = {
              options = [
                "compose:ctrl"
              ];
            };
          };
          configFile = {
            "kdeglobals" = {
              "General" = {
               TerminalApplication = "wezterm";
               TerminalService = "org.wezfurlong.wezterm.desktop";
              };
            };
            "kwinrc" = {
              Plugins = {
                contrastEnabled = false;
                forceblurEnabled = true;
                krohnkiteEnabled = true;
              };
              "Script-krohnkite" = {
                ignoreVDesktop = "Leisure, Gaming";
                keepFloatAbove = false;
              };
              "Effect-blurplus" = {
                BlurMatching = false;
                BlurNonMatching = true;
                BlurStrength = 3;
                NoiseStrength = 7;
                TransparentBlur = false;
              };
              "Round-Corners" = {
                InactiveCornerRadius=15;
                Size=15;
              };
              "PrimaryOutline" = {
                ActiveOutlineUseCustom = false;
                ActiveOutlineUsePalette = true;
                InactiveOutlineThickness = "1.5";
                InactiveOutlineUseCustom = false;
                InactiveOutlineUsePalette = true;
                OutlineThickness = "1.5";
              };
              "SecondOutline" = {
                ActiveSecondOutlineUseCustom = false;
                ActiveSecondOutlineUsePalette = true;
                InactiveSecondOutlineUseCustom = false;
                InactiveSecondOutlineUsePalette = true;
              };
            };
            "powerdevilrc" = {
              "AC/Display" = {
                UseProfileSpecificDisplayBrightness = true;
                DisplayBrightness = 90;
              };
              "Battery/Display" = {
                 UseProfileSpecificDisplayBrightness = true;
                 DisplayBrightness = 15;
              };
              "LowBattery/Display".DisplayBrightness = 15;
            };
            "dolphinrc" = {
              "ContentDisplay" = {
                UseShortRelativeDates = false;
              };
              "ContextMenu" = {
                ShowCopyMoveMenu = true;
                ShowSortBy = false;
                ShowViewMode = false;
              };
              "DetailsMode" = {
                ExpandableFolders = false;
                IconSize = 32;
                PreviewSize = 32;
              };
              "General" = {
                BrowseThroughArchives = true;
                ModifiedStartupSettings = false;
                ShowFullPath = true;
                ShowStatusBar = false;
                SortingChoice = "CaseSensitiveSorting";
                Version = 202;
                ViewPropsTimestamp = "2024,10,31,15,9,28.469";
              };
              "KFileDialog Settings" = {
                "Places Icons Auto-resize" = false;
                "Places Icons Static Size" = 16;
              };
              "MainWindow" = {
                ToolBarsMovable = "Disabled";
              };
              "MainWindow/Toolbar mainToolBar" = {
                ToolButtonStyle = "IconOnly";
              };
              "PlacesPanel" = {
                IconSize = 16;
              };
              PreviewSettings = {
                Plugins = "appimagethumbnail,audiothumbnail,blenderthumbnail,comicbookthumbnail,cursorthumbnail,djvuthumbnail,ebookthumbnail,exrthumbnail,directorythumbnail,fontthumbnail,imagethumbnail,jpegthumbnail,kraorathumbnail,windowsexethumbnail,windowsimagethumbnail,mobithumbnail,opendocumentthumbnail,gsthumbnail,rawthumbnail,svgthumbnail,ffmpegthumbs";
              };
              "Toolbar mainToolBar" = {
                ToolButtonStyle = "IconOnly";
              };
            };
          };
          dataFile = {
            "dolphin/view_properties/global/.directory" = {
              Dolphin = {
                ViewMode = 1;
                VisibleRoles = "Icons_text,Icons_size,Icons_type,CustomizedDetails,Details_text,Details_type,Details_size,Details_permissions,Details_modificationtime,Details_destination,Details_artist,Details_album,Details_duration,Details_dimensions,Details_pageCount";
              };
              Settings.HiddenFilesShown = true;
            };
          };
          file = {
            ".local/state/dolphinstaterc" = {
              State = {
                State = "AAAA/wAAAAD9AAAAAwAAAAAAAAC4AAACAPwCAAAAAvsAAAAWAGYAbwBsAGQAZQByAHMARABvAGMAawAAAAAAAAAA+QAAAAAA////+wAAABQAcABsAGEAYwBlAHMARABvAGMAawEAAAAAAAACAAAAAFwA////AAAAAQAAAMAAAAIA/AIAAAAB+wAAABAAaQBuAGYAbwBEAG8AYwBrAAAAAAAAAAIAAAAAAAD///8AAAADAAACiAAAAED8AQAAAAH7AAAAGAB0AGUAcgBtAGkAbgBhAGwARABvAGMAawAAAAAAAAACiAAAAAAA////AAACAAAAAgAAAAAEAAAABAAAAAgAAAAI/AAAAAEAAAABAAAAAQAAABYAbQBhAGkAbgBUAG8AbwBsAEIAYQByAwAAAAD/////AAAAAAAAAAA=";
              };
            };
          };
          shortcuts = {
            "services/org.wezfurlong.wezterm.desktop"."_launch" = "Meta+T";
            "services/org.kde.krunner.desktop"."_launch" = "Search\tAlt+F2\tAlt+Space\tMeta+O";
          };
        };
      };
    };

    systemd.services."generate-kando-autostart" = {
      description = "Generate Kando Autostert";
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        Type = "oneshot";
        User = "${isUser}";
        Group = "users";
      };
      script = ''
        mkdir -p ~/.config/autostart
        cat << 'EOF' > ~/.config/autostart/kando.desktop
[Desktop Entry]
Categories=Utility
Comment=The Cross-Platform Pie Menu
Exec=kando %U
GenericName=Pie Menu
Icon=kando
Name=Kando
Type=Application
Version=1.4
EOF
      '';
    };

    systemd.services."generate-material-you-autostart" = {
      description = "Generate Material You Widget Autostert";
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        Type = "oneshot";
        User = "${isUser}";
        Group = "users";
      };
      script = ''
        mkdir -p ~/.config/autostart
        cat << 'EOF' > ~/.config/autostart/kde-material-you-colors.desktop
[Desktop Entry]
Exec=kde-material-you-colors
Icon=color-management
Name=KDE Material You Colors
Comment=Starts/Restarts background process
Type=Application
X-KDE-AutostartScript=true
EOF
      '';
    };

    systemd.services."generate-material-you-colors-config" = {
      description = "Generate Material You colors Config";
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        Type = "oneshot";
        User = "${isUser}";
        Group = "users";
      };
      script = ''
        mkdir -p ~/.config/kde-material-you-colors
        cat << 'EOF' > ~/.config//config.conf
[CUSTOM]
chroma_multiplier=1
color=
color_last=#d0265c
custom_colors_list=
custom_colors_list_last=#d0265c #74e448 #eece4f #66a3ef #532066 #297d81 #ccc1c1
dark_brightness_multiplier=1
dark_saturation_multiplier=1
darker_window_list=
disable_konsole=true
gui_custom_exec_location=
iconsdark=
iconslight=
klassy_windeco_outline=false
konsole_opacity=100
konsole_opacity_dark=100
light=false
light_brightness_multiplier=1
light_saturation_multiplier=1
main_loop_delay=1
monitor=0
ncolor=0
on_change_hook=
once_after_change=false
pause_mode=false
plasma_follows_scheme=false
pywal=false
pywal_follows_scheme=false
pywal_light=false
qdbus_executable=
scheme_variant=5
screenshot_delay=900
screenshot_only_mode=false
sierra_breeze_buttons_color=false
startup_delay=0
titlebar_opacity=100
titlebar_opacity_dark=100
tone_multiplier=1
toolbar_opacity=100
toolbar_opacity_dark=100
use_startup_delay=false
EOF
      '';
    };

    systemd.services."generate-dolphin-user-places" = {
      description = "Generate User Places Dolphin file";
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        Type = "oneshot";
        User = "${isUser}";
        Group = "users";
      };
      script = ''
        mkdir -p ~/.local/share
        cat << 'EOF' > ~/.local/share/user-places.xbel
<?xml version="1.0" encoding="UTF-8"?>
<xbel>
 <info>
  <metadata owner="http://www.kde.org">
   <kde_places_version>4</kde_places_version>
   <GroupState-Places-IsHidden>false</GroupState-Places-IsHidden>
   <GroupState-Remote-IsHidden>false</GroupState-Remote-IsHidden>
   <GroupState-Devices-IsHidden>false</GroupState-Devices-IsHidden>
   <GroupState-RemovableDevices-IsHidden>false</GroupState-RemovableDevices-IsHidden>
   <GroupState-Tags-IsHidden>false</GroupState-Tags-IsHidden>
   <withRecentlyUsed>true</withRecentlyUsed>
   <GroupState-RecentlySaved-IsHidden>false</GroupState-RecentlySaved-IsHidden>
   <withBaloo>true</withBaloo>
   <GroupState-SearchFor-IsHidden>false</GroupState-SearchFor-IsHidden>
  </metadata>
 </info>
 <bookmark href="file:///home/ultra">
  <title>Home</title>
  <info>
   <metadata owner="http://freedesktop.org">
    <bookmark:icon name="user-home"/>
   </metadata>
   <metadata owner="http://www.kde.org">
    <ID>1733523249/0</ID>
    <isSystemItem>true</isSystemItem>
   </metadata>
  </info>
 </bookmark>
 <bookmark href="file:///etc/nixos/dotfiles">
  <title>dotfiles</title>
  <info>
   <metadata owner="http://freedesktop.org">
    <bookmark:icon name="inode-directory"/>
   </metadata>
   <metadata owner="http://www.kde.org">
    <ID>1733524838/0</ID>
   </metadata>
  </info>
 </bookmark>
 <bookmark href="file:///home/ultra/Desktop">
  <title>Desktop</title>
  <info>
   <metadata owner="http://freedesktop.org">
    <bookmark:icon name="user-desktop"/>
   </metadata>
   <metadata owner="http://www.kde.org">
    <ID>1733523249/1</ID>
    <isSystemItem>true</isSystemItem>
   </metadata>
  </info>
 </bookmark>
 <bookmark href="file:///home/ultra/Documents">
  <title>Documents</title>
  <info>
   <metadata owner="http://freedesktop.org">
    <bookmark:icon name="folder-documents"/>
   </metadata>
   <metadata owner="http://www.kde.org">
    <ID>1733523249/2</ID>
    <isSystemItem>true</isSystemItem>
   </metadata>
  </info>
 </bookmark>
 <bookmark href="file:///home/ultra/Downloads">
  <title>Downloads</title>
  <info>
   <metadata owner="http://freedesktop.org">
    <bookmark:icon name="folder-downloads"/>
   </metadata>
   <metadata owner="http://www.kde.org">
    <ID>1733523249/3</ID>
    <isSystemItem>true</isSystemItem>
   </metadata>
  </info>
 </bookmark>
 <bookmark href="file:///home/ultra/Music">
  <title>Music</title>
  <info>
   <metadata owner="http://freedesktop.org">
    <bookmark:icon name="folder-music"/>
   </metadata>
   <metadata owner="http://www.kde.org">
    <ID>1733523249/6</ID>
    <isSystemItem>true</isSystemItem>
   </metadata>
  </info>
 </bookmark>
 <bookmark href="file:///home/ultra/Pictures">
  <title>Pictures</title>
  <info>
   <metadata owner="http://freedesktop.org">
    <bookmark:icon name="folder-pictures"/>
   </metadata>
   <metadata owner="http://www.kde.org">
    <ID>1733523249/7</ID>
    <isSystemItem>true</isSystemItem>
   </metadata>
  </info>
 </bookmark>
 <bookmark href="file:///home/ultra/Videos">
  <title>Videos</title>
  <info>
   <metadata owner="http://freedesktop.org">
    <bookmark:icon name="folder-videos"/>
   </metadata>
   <metadata owner="http://www.kde.org">
    <ID>1733523249/8</ID>
    <isSystemItem>true</isSystemItem>
   </metadata>
  </info>
 </bookmark>
 <bookmark href="remote:/">
  <title>Network</title>
  <info>
   <metadata owner="http://freedesktop.org">
    <bookmark:icon name="folder-network"/>
   </metadata>
   <metadata owner="http://www.kde.org">
    <ID>1733523249/4</ID>
    <isSystemItem>true</isSystemItem>
   </metadata>
  </info>
 </bookmark>
 <bookmark href="trash:/">
  <title>Trash</title>
  <info>
   <metadata owner="http://freedesktop.org">
    <bookmark:icon name="user-trash"/>
   </metadata>
   <metadata owner="http://www.kde.org">
    <ID>1733523249/5</ID>
    <isSystemItem>true</isSystemItem>
   </metadata>
  </info>
 </bookmark>
 <bookmark href="recentlyused:/files">
  <title>Recent Files</title>
  <info>
   <metadata owner="http://freedesktop.org">
    <bookmark:icon name="document-open-recent"/>
   </metadata>
   <metadata owner="http://www.kde.org">
    <ID>1733523249/9</ID>
    <isSystemItem>true</isSystemItem>
   </metadata>
  </info>
 </bookmark>
 <bookmark href="recentlyused:/locations">
  <title>Recent Locations</title>
  <info>
   <metadata owner="http://freedesktop.org">
    <bookmark:icon name="folder-open-recent"/>
   </metadata>
   <metadata owner="http://www.kde.org">
    <ID>1733523249/10</ID>
    <isSystemItem>true</isSystemItem>
   </metadata>
  </info>
 </bookmark>
 <separator>
  <info>
   <metadata owner="http://www.kde.org">
    <UDI>/org/freedesktop/UDisks2/block_devices/sda2</UDI>
    <isSystemItem>true</isSystemItem>
    <uuid>88649295-f767-4828-b107-695d28c4c52b</uuid>
   </metadata>
  </info>
 </separator>
 <separator>
  <info>
   <metadata owner="http://www.kde.org">
    <UDI>/org/freedesktop/UDisks2/block_devices/dm_2d1</UDI>
    <isSystemItem>true</isSystemItem>
    <uuid>3126df7f-fa2c-4e1b-887d-3d22ab77af06</uuid>
   </metadata>
  </info>
 </separator>
</xbel>
      '';
    };
  };
}
