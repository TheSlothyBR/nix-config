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

  environment.systemPackages = with pkgs.kdePackages; [
    qtstyleplugin-kvantum
    sddm-kcm
  ] ++ [
    #kde-rounded-corners
  ];
  
  home-manager = {
    sharedModules  = [
      inputs.plasma-manager.homeManagerModules.plasma-manager
    ];
    users.${globals.ultra.userName} = {
      programs.plasma = {
        enable = true;
        overrideConfig = true;
	workspace = {
          theme = "breeze-dark";
	  colorScheme = "BreezeDark";
	  soundTheme = "ocean";
	};
	panels = [
          {
            location = "top";
	    floating = true;
	    alignment = "left";
	    lengthMode = "fill";
	    height = 36;
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
	      "org.kde.plasma.pager"
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
                    shown = [
	              "org.kde.plasma.battery"
	              "org.kde.plasma.brightness"
	              "org.kde.plasma.cameraindicator"
	              "org.kde.plasma.clipboard"
	              "org.kde.plasma.devicenotifier"
	              "org.kde.plasma.manage-inputmethod"
	              "org.kde.plasma.mediacontroller"
	              "org.kde.plasma.kscreen"
	              "org.kde.plasma.bluetooth"
	              "org.kde.plasma.notifications"
	              "org.kde.plasma.keyboardlayout"
	              "org.kde.plasma.keyboardindicator"
	              "org.kde.plasma.networkmanagement"
	              "org.kde.plasma.volume"
		    ];
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
		    "/etc/profiles/per-user/${globals.ultra.userName}/share/applications/org.wezfurlong.wezterm.desktop"
		    "preferred://browser"
		    "/run/current-system/sw/share/applications/org.keepassxc.KeePassXC.desktop"
		    "/run/current-system/sw/share/applications/rclone-browser.desktop"
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
        #resetFilesExclude = [];
        #file = { "file/relative/to/home" = ''explicit settings'' };
        # kwinoutputconfig.json has refresh and resolution info, has to be manualy set
        #configFile = {}; #same pourpose as home-manager options
        #dataFile = {};
      };
    };
  };
}
