{ config, lib,pkgs, ... }:

 # unstable derivative
  let
    unstableTarball =
      fetchTarball
        https://github.com/NixOS/nixpkgs/archive/nixos-unstable.tar.gz;
in
{
  imports =
    [
      ./hardware-configuration.nix
    ];

  # Bootloader.
  boot.loader.timeout = 1;
  boot.initrd.kernelModules = [ "amdgpu" ];
  boot.loader.systemd-boot = {
  enable = true;
	};
  boot.loader.efi.canTouchEfiVariables = true;
  boot.supportedFilesystems = [ "ntfs" ];
  boot.plymouth.theme = "bgrt";
  boot.plymouth.enable = true;
  boot.plymouth.logo = pkgs.fetchurl {
            url = "https://nixos.org/logo/nixos-hires.png";
            sha256 = "1ivzgd7iz0i06y36p8m5w48fd8pjqwxhdaavc0pxs7w1g7mcy5si";
          };
  boot.plymouth.font = "${pkgs.dejavu_fonts.minimal}/share/fonts/truetype/DejaVuSans.ttf";
  networking.hostName = "nixos"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Asia/Shanghai";

  # default locale
  i18n.defaultLocale = "en_US.UTF-8";

  # use ibus now.
    i18n.inputMethod = {
    enabled = "ibus";
    ibus.engines = with pkgs.ibus-engines; [
      libpinyin
      rime
    ];
  };

  fonts = {
    fontDir.enable = true;
    fonts = with pkgs; [
      noto-fonts
      noto-fonts-cjk-sans
      noto-fonts-cjk-serif
      source-han-sans
      source-han-serif
      sarasa-gothic  #更纱黑体
      source-code-pro
      hack-font
      fira-code
      jetbrains-mono
       (nerdfonts.override { fonts = [ "FiraCode" "DroidSansMono" ]; })
    ];
  };

    fonts.fontconfig = {
      defaultFonts = {
        emoji = [ "Noto Color Emoji" ];
        monospace = [
          "Noto Sans Mono CJK SC"
          "Sarasa Mono SC"
          "DejaVu Sans Mono"
        ];
        sansSerif = [
          "Noto Sans CJK SC"
          "Source Han Sans SC"
          "DejaVu Sans"
        ];
        serif = [
          "Noto Serif CJK SC"
          "Source Han Serif SC"
          "DejaVu Serif"
        ];
      };
    };

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "zh_CN.UTF-8";
    LC_IDENTIFICATION = "zh_CN.UTF-8";
    LC_MEASUREMENT = "zh_CN.UTF-8";
    LC_MONETARY = "zh_CN.UTF-8";
    LC_NAME = "zh_CN.UTF-8";
    LC_NUMERIC = "zh_CN.UTF-8";
    LC_PAPER = "zh_CN.UTF-8";
    LC_TELEPHONE = "zh_CN.UTF-8";
    LC_TIME = "zh_CN.UTF-8";
  };

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Enable the GNOME Desktop Environment.
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;
  services.xserver.displayManager.gdm.wayland = true;
  environment.gnome.excludePackages = (with pkgs; [
                gnome-photos
                gnome-tour]);
  # Enable OpenSSH
  services.openssh.enable = true;
  services.openssh.settings.PermitRootLogin = "yes";
  # Configure keymap in X11
  services.xserver = {
    layout = "us";
    xkbVariant = "";
  };

  # Enable clickhouse
  # services.clickhouse.enable = true;

  # Enable CUPS to print documents.
  services.printing.enable = true;
  # Disable Passwd for sudo
  security.sudo.extraRules= [
      {
        users = [ "arthur19q3" ];
        commands = [
          { command = "ALL" ;
            options= [ "NOPASSWD" ];
          }
        ];
      }
    ];

  # Enable sound with pipewire.
  sound.enable = true;
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.arthur19q3 = {
    isNormalUser = true;
    description = "Arthur Z";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [
      firefox
      flatpak
      gnome.gnome-software
      thunderbird
    ];
  };

  users.defaultUserShell = pkgs.fish;
  # programs
  programs.xwayland.enable = true;

  programs.clash-verge.enable = true;
  programs.clash-verge.autoStart = true;
    programs.fish ={
        # this is for root user
        enable = true;
        shellAliases = {
        rm = "rm -i";
        cp = "xcp";
        mv = "mv -i";
        mkdir = "mkdir -p";
        rebuild = "sudo nixos-rebuild switch --flake /etc/nixos/#arthur19q3";
        clean = "sudo nix-collect-garbage -d";
        ls = "exa -l";
        bkup = "xcp /etc/nixos/configuration.nix /opt/";
        config="sudo micro /etc/nixos/configuration.nix";
        c = "clear";
    };
  };
  programs.starship.interactiveOnly = false;
  programs.starship.enable = true;
  programs.fish.shellInit = lib.mkAfter "zoxide init fish | source";
  #programs.clash-verge.autoStart = true;
  # Enable automatic login for the user.
  services.xserver.displayManager.autoLogin.enable = true;
  services.xserver.displayManager.autoLogin.user = "arthur19q3";
  systemd.services."getty@tty1".enable = false;
  systemd.services."autovt@tty1".enable = false;
  # Enable neovim
  programs.neovim = {
    enable = true;
    defaultEditor = true;
  };
  # enable flatpak
  services.flatpak.enable = true;

  # Redis Server
      services.redis.servers = {
        redis-server = {
          enable = true;
          port =6379;
          requirePass="the17th";
          databases=5;
        };
      };

  # HIP

  systemd.tmpfiles.rules = [
      "L+    /opt/rocm/hip   -    -    -     -    ${pkgs.hip}"
    ];

  # OpenCL
  hardware.opengl.extraPackages = with pkgs; [
    rocm-opencl-icd
    rocm-opencl-runtime
  ];

  # Vulkan
  hardware.opengl.driSupport = true;

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # Allow unstable
  nixpkgs.config = {
      packageOverrides = pkgs: {
        unstable = import unstableTarball {
          config = config.nixpkgs.config;
        };
      };
    };

  # To turn on automatic optimisation for newer derivations
  nix.settings.auto-optimise-store = true;

  #  Nix Related
  nix = {
    package = pkgs.nixFlakes;
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
  };


  # Samba
  services.gvfs.enable = true;
  services.samba.enable = true;
  services.samba.enableNmbd = true;


  # Package list
  environment.systemPackages = with pkgs; [
  alacritty
  bat
  blender
  bottom
  broot
  cargo
  cifs-utils
#  clickhouse
#  clickhouse-cli
  clash
  clash-verge
  discord
  direnv
  docker
  docker-compose
#  dragonflydb
  electron
  element-desktop
  epson-escpr
  exa
  fd
  fish
  flatpak
  fzf
  fishPlugins.forgit
  tmuxPlugins.tmux-fzf
  fishPlugins.fzf
  fishPlugins.done
  fishPlugins.sponge
  fishPlugins.autopair
  any-nix-shell
  ibus
  ibus-engines.table-chinese
  lapce
  libpinyin
  libtorch-bin
  gnome3.gvfs
  git
  gitea
  gcc13
  gccgo13
  glibc
  gnome.gnome-tweaks
  go
  google-chrome
  gst_all_1.gstreamer
  home-manager
  htop
  httpie
  huniq
  hyperfine
  jetbrains.clion
  jetbrains.goland
  jetbrains.pycharm-professional
  joplin-desktop
  kodi
  mattermost-desktop
  micro
  neofetch
  netease-cloud-music-gtk
  nushell
  neovim
  nixfmt
  nixos-option
  nixos-grub2-theme
  neovim-gtk
  neovide
  vimPlugins.coc-rust-analyzer
  pods
  podman
  podman-compose
  podman-desktop
  (python311.withPackages(ps: with ps; [ pandas requests polars numpy]))
  rargs
  redis
  ripgrep
  rocm-core
  rocm-smi
  rustc
  rustup
  rustfmt
  samba
  samba4Full
  starship
  rofi
  tmux
  tokei
  tldr
  vscode
  wl-clipboard
  wpsoffice
  xcp
  yarn
  zoxide
  ];

  # system version state
  system.stateVersion = "23.05"; # Did you read the comment?
  # nix repo change
  nix.settings.substituters = [ "https://mirror.sjtu.edu.cn/nix-channels/store" ];
  # Home Manger
  home-manager.useGlobalPkgs = true;
}
