{
  pkgs,
  inputs,
  config,
  globals,
  isConfig,
  isUser,
  lib,
  ...
}:
{
  imports = [

  ];

  options = {
    custom.plasma = {
      enable = lib.mkEnableOption "Plasma Desktop config";
    };
  };

  config = lib.mkIf config.custom.plasma.enable {
    services.desktopManager.plasma6 = {
      enable = true;
      enableQt5Integration = false;
    };

    nixpkgs.overlays = [
      (final: prev: {
        plasma-panel-spacer-extended = (
          pkgs.callPackage ../../pkgs/kde-panel-spacer-extended-widget.nix { }
        );
      })
    ];

    environment.persistence."/persist" = {
      users.${isUser} = {
        directories = [
          ".local/share/kwalletd"
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
        krdp
        okular
        plasma-browser-integration
        spectacle
        xwaylandvideobridge
      ];
      systemPackages =
        let
          stable = with pkgs; [
            (callPackage ../../pkgs/kde-material-you-colors-widget.nix { })
            (callPackage ../../pkgs/kde-wallpaper-effects-widget.nix { })
            (callPackage ../../pkgs/pywal16-libadwaita.nix { })
            (callPackage ../../pkgs/yaru-unity-plasma-icons.nix { })
            application-title-bar
            kara
            kdePackages.krohnkite
            kdePackages.qtstyleplugin-kvantum
            kdePackages.sddm-kcm
            kde-rounded-corners
            inputs.kwin-effects-forceblur.packages.${pkgs.system}.default
            inputs.kvlibadwaita.packages.${pkgs.system}.default
            fusuma # requires adding user to inputs group, which is insecure, bin wont be needed when KDE allows rebinding of gestures
            plasma-panel-colorizer
            python312Packages.kde-material-you-colors
            pywal16
            (pkgs.writeShellApplication {
              name = "plasma-random-wallpaper";
              runtimeInputs = [ pkgs.kdePackages.qttools ];
              text = ''
                WALLPAPER=$(find /home/${isUser}/Drive/Wallpapers -type f | shuf -n 1)
                if [ -f "$WALLPAPER" ]; then
                  if [ ! -f "/home/${isUser}/.config/kde-material-you-colors/.ran" ]; then
                    if [ ! -f "/home/${isUser}/.config/kscreenlockerrc" ]; then
                      touch /home/${isUser}/.config/kscreenlockerrc
                    fi

                    touch /home/${isUser}/.config/kde-material-you-colors/.ran
                    qdbus org.kde.plasmashell /PlasmaShell org.kde.PlasmaShell.evaluateScript "
                      desktops().forEach((d) => {
                          d.currentConfigGroup = [
                            'Wallpaper',
                            'org.kde.image',
                            'General'
                          ]
                          d.writeConfig('Image', 'file://$WALLPAPER')
                          d.reloadConfig()
                      })
                    "
                    kwriteconfig6 --file kscreenlockerrc --group Greeter --group Wallpaper --group org.kde.image --group General --key Image "file://$WALLPAPER"
                  else
                    exit
                  fi
                else
                  exit 1
                fi
              '';
            })
            wl-clipboard-rs
          ];
          unstable = with pkgs.unstable; [

          ];
        in
        stable ++ unstable;
    };

    services.printing.enable = false;

    qt = {
      enable = true;
      platformTheme = "kde";
      #style = "kvantum";
    };

    home-manager = {
      sharedModules = [
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
            #wallpaper = "${pkgs.kdePackages.plasma-workspace-wallpapers}/share/wallpapers/ScarletTree/contents/images/5120x2880.png";
          };
          kwin = {
            titlebarButtons = {
              right = [ ];
              left = [ ];
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
          window-rules = [
            {
              description = "Open Steam in Gaming Desktop";
              match = {
                window-class = {
                  value = "steam";
                  type = "regex";
                };
              };
              apply = {
                desktops = {
                  value = "Desktop_3";
                  apply = "initially";
                };
              };
            }
          ];
          fonts = {
            general = {
              family = "Inter Variable";
              pointSize = 11;
            };
            fixedWidth = {
              family = "FiraCode Nerd Font Mono";
              pointSize = 10;
            };
            small = {
              family = "Inter Variable";
              pointSize = 9;
            };
            toolbar = {
              family = "Inter Variable";
              pointSize = 11;
            };
            menu = {
              family = "Inter Variable";
              pointSize = 11;
            };
            windowTitle = {
              family = "Inter Variable";
              pointSize = 11;
            };
          };
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
                        "org.kde.plasma.systemmonitor"
                      ];
                      hidden = [
                        "org.kde.plasma.bluetooth"
                        "org.kde.plasma.brightness"
                        "luisbocanegra.kdematerialyou.colors"
                        "kando"
                        "steam"
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
                      (if config.custom.wezterm.enable then "applications:org.wezfurlong.wezterm.desktop" else "")
                      "preferred://browser"
                      (if config.custom.obsidian.enable then "applications:md.obsidian.Obsidian.desktop" else "")
                      (if config.custom.keepassxc.enable then "applications:org.keepassxc.KeePassXC.desktop" else "")
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
            "breezerc" = {
              "Windeco Exception 0" = {
                BorderSize = 0;
                Enabled = true;
                ExceptionPattern = ".*";
                ExceptionType = 0;
                HideTitleBar = true;
                Mask = 0;
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
                InactiveCornerRadius = 15;
                Size = 15;
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
            "kwalletrc" = {
              "Wallet" = {
                "Default Wallet" = "kdewallet";
                Enabled = true;
              };
            };
            "plasmanotifyrc" = {
              "Notifications" = {
                LowPriorityHistory = true;
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
                State = "AAAA/wAAAAD9AAAAAwAAAAAAAAC4AAACAPwCAAAAAvsAAAAWAGYAbwBsAGQAZQByAHMARABvAGMAawAAAAAAAAAA+QAAAAAA////+wAAABQAcABsAGEAYwBlAHMARABvAGMAawEAAAAAAAACAAAAAFMA////AAAAAQAAAMAAAAIA/AIAAAAB+wAAABAAaQBuAGYAbwBEAG8AYwBrAAAAAAAAAAIAAAAAAAD///8AAAADAAACiAAAAED8AQAAAAH7AAAAGAB0AGUAcgBtAGkAbgBhAGwARABvAGMAawAAAAAAAAACiAAAAAAA////AAACEQAAAgAAAAAEAAAABAAAAAgAAAAI/AAAAAEAAAABAAAAAQAAABYAbQBhAGkAbgBUAG8AbwBsAEIAYQByAwAAAAD/////AAAAAAAAAAA=";
              };
            };
          };
          shortcuts = {
            "kwin"."plasma-kando" = "Meta+Space";
            "services/org.wezfurlong.wezterm.desktop"."_launch" = "Meta+T";
            "services/org.kde.krunner.desktop"."_launch" = "Search\tAlt+F2\tAlt+Space\tMeta+O";
          };
        };
      };
    };

    systemd.services."generate-fusuma-autostart-and-config" = {
      description = "Generate Fusuma Autostart";
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        Type = "oneshot";
        User = "${isUser}";
        Group = "users";
      };
      script = ''
                mkdir -p ~/.config/autostart
                cat << 'EOF' > ~/.config/autostart/fusuma.desktop
        [Desktop Entry]
        Exec=fusuma -d
        Icon=
        Name=fusuma
        Type=Application
        X-KDE-AutostartScript=true
        EOF

                mkdir -p ~/.config/fusuma
                cat << 'EOF' > ~/.config/fusuma/config.yml
        hold:
          3:
            command: "flatpak run menu.kando.Kando --menu Plasma"
            interval: 0.5
        EOF
      '';
    };

    systemd.services."generate-mimeapps-file" = {
      description = "Generate mimeapps.list file";
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        Type = "oneshot";
        User = "${isUser}";
        Group = "users";
      };
      script = ''
                mkdir -p ~/.config
                cat << 'EOF' > ~/.config/mimeapps.list
        [Default Applications]
        ${if config.custom.brave.enable then "x-scheme-handler/https=com.brave.Browser.desktop" else ""}
        ${if config.custom.brave.enable then "x-scheme-handler/http=com.brave.Browser.desktop" else ""}
        ${if config.custom.brave.enable then "x-scheme-handler/unknown=com.brave.Browser.desktop" else ""}
        image/*=org.gnome.Loupe.desktop
        video/*=org.videolan.VLC.desktop
        audio/*=org.videolan.VLC.desktop
        application/pdf=org.kde.okular.desktop
        text/*=org.kde.kate.desktop
        application/x-torrent=org.kde.ktorrent.desktop
        application/x-bittorrent=org.kde.ktorrent.desktop
        x-scheme-handler/magnet=org.kde.ktorrent.desktop
        [Added Associations]
        x-scheme-handler/https=${if config.custom.brave.enable then "com.brave.Browser.desktop" else ""},${
          if config.custom.nyxt.enable then "engineer.atlas.Nyxt.desktop" else ""
        }
        x-scheme-handler/http=${if config.custom.brave.enable then "com.brave.Browser.desktop" else ""},${
          if config.custom.nyxt.enable then "engineer.atlas.Nyxt.desktop" else ""
        }
        [Removed Associations]
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
                cat << 'EOF' > ~/.config/kde-material-you-colors/config.conf
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
        on_change_hook=/run/current-system/sw/bin/plasma-random-wallpaper
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

    systemd.services."generate-dolphin-toolbar" = {
      description = "Generate Dolphin Toolbar file";
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        Type = "oneshot";
        User = "${isUser}";
        Group = "users";
      };
      script = ''
                mkdir -p ~/.local/share/kxmlgui5/dolphin
                cat << 'EOF' > ~/.local/share/kxmlgui5/dolphin/dolphinui.rc
        <!DOCTYPE gui>
        <gui name="dolphin" translationDomain="kxmlgui6" version="40">
         <MenuBar alreadyVisited="1">
          <Menu alreadyVisited="1" name="file" noMerge="1">
           <text translationDomain="kxmlgui6">&amp;File</text>
           <Action name="file_new"/>
           <Separator weakSeparator="1"/>
           <Action name="new_menu"/>
           <Action name="file_new"/>
           <Action name="new_tab"/>
           <Action name="file_close"/>
           <Action name="undo_close_tab"/>
           <Separator/>
           <Action name="add_to_places"/>
           <Separator/>
           <Action name="renamefile"/>
           <Action name="duplicate"/>
           <Action name="movetotrash"/>
           <Action name="deletefile"/>
           <Separator/>
           <Action name="show_target"/>
           <Separator/>
           <Action name="properties"/>
           <Separator weakSeparator="1"/>
           <Action name="file_close"/>
           <Separator weakSeparator="1"/>
           <Action name="file_quit"/>
          </Menu>
          <Menu alreadyVisited="1" name="edit" noMerge="1">
           <text translationDomain="kxmlgui6">&amp;Edit</text>
           <Action name="edit_undo"/>
           <Separator weakSeparator="1"/>
           <Action name="edit_cut"/>
           <Action name="edit_copy"/>
           <Action name="edit_paste"/>
           <Separator weakSeparator="1"/>
           <Action name="edit_select_all"/>
           <Separator weakSeparator="1"/>
           <Action name="edit_find"/>
           <Separator weakSeparator="1"/>
           <Action name="edit_undo"/>
           <Separator/>
           <Action name="edit_cut"/>
           <Action name="edit_copy"/>
           <Action name="copy_location"/>
           <Action name="edit_paste"/>
           <Separator/>
           <Action name="show_filter_bar"/>
           <Action name="edit_find"/>
           <Separator/>
           <Action name="toggle_selection_mode"/>
           <Action name="copy_to_inactive_split_view"/>
           <Action name="move_to_inactive_split_view"/>
           <Action name="edit_select_all"/>
           <Action name="invert_selection"/>
          </Menu>
          <Menu alreadyVisited="1" name="view" noMerge="1">
           <text translationDomain="kxmlgui6">&amp;View</text>
           <Action name="view_zoom_in"/>
           <Action name="view_zoom_out"/>
           <Separator weakSeparator="1"/>
           <Action name="view_redisplay"/>
           <Separator weakSeparator="1"/>
           <Action name="view_zoom_in"/>
           <Action name="view_zoom_reset"/>
           <Action name="view_zoom_out"/>
           <Separator/>
           <Action name="sort"/>
           <Action name="view_mode"/>
           <Action name="additional_info"/>
           <Action name="show_preview"/>
           <Action name="show_in_groups"/>
           <Action name="show_hidden_files"/>
           <Action name="act_as_admin"/>
           <Separator/>
           <Action name="split_view_menu"/>
           <Action name="popout_split_view"/>
           <Action name="split_stash"/>
           <Action name="redisplay"/>
           <Action name="stop"/>
           <Separator/>
           <Action name="panels"/>
           <Menu icon="edit-select-text" name="location_bar" noMerge="1">
            <text context="@title:menu" translationDomain="dolphin">Location Bar</text>
            <Action name="editable_location"/>
            <Action name="replace_location"/>
           </Menu>
           <Separator/>
           <Action name="view_properties"/>
          </Menu>
          <Menu alreadyVisited="1" name="go" noMerge="1">
           <text translationDomain="kxmlgui6">&amp;Go</text>
           <Action name="go_up"/>
           <Action name="go_back"/>
           <Action name="go_forward"/>
           <Action name="go_home"/>
           <Separator weakSeparator="1"/>
           <Action name="bookmarks"/>
           <Action name="closed_tabs"/>
          </Menu>
          <Menu alreadyVisited="1" name="tools" noMerge="1">
           <text translationDomain="kxmlgui6">&amp;Tools</text>
           <Action name="open_preferred_search_tool"/>
           <Action name="open_terminal"/>
           <Action name="open_terminal_here"/>
           <Action name="focus_terminal_panel"/>
           <Action name="compare_files"/>
           <Action name="change_remote_encoding"/>
          </Menu>
          <Menu name="settings" noMerge="1">
           <text translationDomain="kxmlgui6">&amp;Settings</text>
           <Action name="options_show_menubar"/>
           <Merge name="StandardToolBarMenuHandler"/>
           <Merge name="KMDIViewActions"/>
           <Action name="options_show_statusbar"/>
           <Separator weakSeparator="1"/>
           <Action name="switch_application_language"/>
           <Action name="options_configure_keybinding"/>
           <Action name="options_configure_toolbars"/>
           <Action name="options_configure"/>
          </Menu>
          <Separator weakSeparator="1"/>
          <Menu name="help" noMerge="1">
           <text translationDomain="kxmlgui6">&amp;Help</text>
           <Action name="help_contents"/>
           <Action name="help_whats_this"/>
           <Action name="open_kcommand_bar"/>
           <Separator weakSeparator="1"/>
           <Action name="help_report_bug"/>
           <Separator weakSeparator="1"/>
           <Action name="help_donate"/>
           <Separator weakSeparator="1"/>
           <Action name="help_about_app"/>
           <Action name="help_about_kde"/>
          </Menu>
         </MenuBar>
         <ToolBar alreadyVisited="1" name="mainToolBar" noMerge="1">
          <Action name="hamburger_menu"/>
          <text context="@title:menu" translationDomain="dolphin">Main Toolbar</text>
          <Action name="go_back"/>
          <Action name="go_forward"/>
          <Action name="toggle_search"/>
          <Spacer name="spacer_0"/>
         </ToolBar>
         <State name="new_file">
          <disable>
           <Action name="edit_undo"/>
           <Action name="edit_redo"/>
           <Action name="edit_cut"/>
           <Action name="renamefile"/>
           <Action name="movetotrash"/>
           <Action name="deletefile"/>
           <Action name="invert_selection"/>
           <Separator/>
           <Action name="go_back"/>
           <Action name="go_forward"/>
          </disable>
         </State>
         <State name="has_selection">
          <enable>
           <Action name="invert_selection"/>
          </enable>
         </State>
         <State name="has_no_selection">
          <disable>
           <Action name="delete_shortcut"/>
           <Action name="invert_selection"/>
          </disable>
         </State>
         <ActionProperties scheme="Default">
          <Action name="go_back" priority="0"/>
          <Action name="go_forward" priority="0"/>
          <Action name="go_up" priority="0"/>
          <Action name="go_home" priority="0"/>
          <Action name="stop" priority="0"/>
          <Action name="icons" priority="0"/>
          <Action name="compact" priority="0"/>
          <Action name="details" priority="0"/>
          <Action name="view_zoom_in" priority="0"/>
          <Action name="view_zoom_reset" priority="0"/>
          <Action name="view_zoom_out" priority="0"/>
          <Action name="edit_cut" priority="0"/>
          <Action name="edit_copy" priority="0"/>
          <Action name="edit_paste" priority="0"/>
          <Action name="toggle_search" priority="0"/>
          <Action name="toggle_filter" priority="0"/>
         </ActionProperties>
        </gui>
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
           <GroupState-Remote-IsHidden>true</GroupState-Remote-IsHidden>
           <GroupState-Devices-IsHidden>false</GroupState-Devices-IsHidden>
           <GroupState-RemovableDevices-IsHidden>false</GroupState-RemovableDevices-IsHidden>
           <GroupState-Tags-IsHidden>false</GroupState-Tags-IsHidden>
           <withRecentlyUsed>true</withRecentlyUsed>
           <GroupState-RecentlySaved-IsHidden>true</GroupState-RecentlySaved-IsHidden>
           <withBaloo>true</withBaloo>
           <GroupState-SearchFor-IsHidden>false</GroupState-SearchFor-IsHidden>
          </metadata>
         </info>
         <bookmark href="file:///home/${isUser}">
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
         <bookmark href="file:///home/${isUser}/Desktop">
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
         <bookmark href="file:///home/${isUser}/Documents">
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
         <bookmark href="file://${globals.${isConfig}.persistFlakePath}/${globals.meta.flakePath}">
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
         <bookmark href="file:///home/${isUser}/Downloads">
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
         <bookmark href="file:///home/${isUser}/Drive">
          <title>Drive</title>
          <info>
           <metadata owner="http://freedesktop.org">
            <bookmark:icon name="inode-directory"/>
           </metadata>
           <metadata owner="http://www.kde.org">
            <ID>1733769851/0</ID>
           </metadata>
          </info>
         </bookmark>
         <bookmark href="file:///home/${isUser}/Games">
          <title>Games</title>
          <info>
           <metadata owner="http://freedesktop.org">
            <bookmark:icon name="inode-directory"/>
           </metadata>
           <metadata owner="http://www.kde.org">
            <ID>1733769857/1</ID>
           </metadata>
          </info>
         </bookmark>
         <bookmark href="file:///home/${isUser}/Music">
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
         <bookmark href="file:///home/${isUser}/Pictures">
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
         <bookmark href="file:///home/${isUser}/Videos">
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
        </xbel>
      '';
    };
  };
}
