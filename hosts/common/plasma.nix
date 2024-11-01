{ pkgs
, inputs
, config
, isUser
, lib
, ...
}:{
  imports = [
    ../../overlays/colloid-kde-overlay.nix
    ../../overlays/kde-material-you-colors-overlay.nix
  ];

  options = {
    custom.plasma = {
      enable = lib.mkEnableOption "Plasma Desktop config";
    };
  };

  config = lib.mkIf config.custom.plasma.enable {
    services.desktopManager.plasma6.enable = true;

    # only needed because before 24.11, plasma-manager did not offer a separate stable and unstable branch
    nixpkgs.overlays = [
      (final: prev: {
        application-title-bar = (import inputs.nixpkgs-unstable { system = final.system; }).application-title-bar;
      })
      (final: prev: {
        plasma-panel-colorizer = (import inputs.nixpkgs-unstable { system = final.system; }).plasma-panel-colorizer;
      })
      (final: prev: {
        kara = (import inputs.nixpkgs-unstable { system = final.system; }).kara;
      })

    ];

    environment = {
      plasma6.excludePackages = with pkgs.kdePackages; [
        ark
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
          colloid-kde
          (callPackage ../../pkgs/yaru-unity-plasma-icons.nix {})
          (callPackage ../../pkgs/flatpak-xdg-utils.nix {})
          kde-rounded-corners
        ];
        unstable = with pkgs.unstable; [
          application-title-bar
          kara
          plasma-panel-colorizer
          python312Packages.kde-material-you-colors
          plasma-plugin-blurredwallpaper
          inputs.kwin-effects-forceblur.packages.${pkgs.system}.default
          kdePackages.krohnkite
        ];
      in
        stable ++ unstable;
    };

    qt = {
      enable = true;
      platformTheme = "kde";
      style = "kvantum";
    };

    home-manager = {
      sharedModules  = [
        inputs.plasma-manager.homeManagerModules.plasma-manager
      ];
      users.${isUser} = {
        #xdg.configFile = {
        #  "Kvantum/kvantum.kvconfig".text = "[General]\ntheme=ColloidDark";
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
          };
          kwin = {
            titlebarButtons = {
              right = [  ];
              left = [  ];
            };
            borderlessMaximizedWindows = true;
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
                #{
                #  plasmaPanelColorizer = {};
                #}
                #{
                #  name = "org.kde.plasma.pager";
                #  config.General = {
                #    displayedText = "Name";
                #    showWindowsIcons = true;
                #  };
                #}
                {
                  name = "org.dhruv8sh.kara";
                  config = {
                    appearance = {
                      defaultAltTextColors = false;
                      plasmaTxtColors = true;
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
                "org.kde.plasma.appmenu" 
                "org.kde.plasma.panelspacer" 
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
          configFile = {
            "kwinc" = {
              "org.kde.kdecoration2" = {
                BorderSize = "None";
                BorderSizeAuto = false;
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
            };
          };
          dataFile = {
            "dolphin/view_properties/global/.directory" = {
              Settings.HiddenFilesShown = true;
            };
          };
          shortcuts = {
            "services/org.wezfurlong.wezterm.desktop"."_launch" = "Meta+T";
            "services/org.kde.krunner.desktop"."_launch" = "Search\tAlt+F2\tAlt+Space\tMeta+O";
          };
        };
      };
    };
  };
}
