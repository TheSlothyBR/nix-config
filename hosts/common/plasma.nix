{ pkgs
, inputs
, config
, globals
, ...
}:{
  services.desktopManager.plasma6.enable = true;

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
  };

  #imports = [
  #  ../../overlays/colloid-kde-overlay.nix
  #];

  environment.systemPackages = with pkgs; [
    kdePackages.qtstyleplugin-kvantum
    kdePackages.sddm-kcm
    colloid-kde
    (callPackage ../../pkgs/yaru-unity-plasma-icons.nix {})
  ];

  qt = {
    enable = true;
    platformTheme = "kde";
    style = "kvantum";
  };

  home-manager = {
    sharedModules  = [
      inputs.plasma-manager.homeManagerModules.plasma-manager
    ];
    users.${globals.ultra.userName} = {
      xdg.configFile = {
        "Kvantum/kvantum.kvconfig".text = "[General]\ntheme=ColloidDark";
      };

      programs.plasma = {
        enable = true;
        overrideConfig = true;
	workspace = {
          theme = "Colloid-dark";
	  colorScheme = "ColloidDark";
	  #wallpaper
	  windowDecorations = {
            library = "org.kde.kwin.aurorae";
	    theme = "__aurorae__svg__Colloid-dark-round";
	  };
	  splashScreen = {
            theme = "Colloid-dark";
	  };
	  cursor = {
	    theme = "breeze_cursors";
	  };
	  iconTheme = "YaruPlasma-Dark";
	  soundTheme = "ocean";
          clickItemTo = "select";
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
	        name = "org.kde.plasma.pager";
		config.General = {
                  displayedText = "Number";
		  showWindowsIcons = true;
		};
	      }
              "org.kde.plasma.appmenu" 
	      "org.kde.plasma.panelspacer" 
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
      };
    };
  };
}
