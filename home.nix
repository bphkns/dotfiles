{ pkgs, ... }:

{
  home.username = "bikash";
  home.homeDirectory = "/home/bikash";
  home.stateVersion = "24.05";

  programs.home-manager.enable = true;

  home.packages = with pkgs; [
    # Shell & prompt
    zsh
    starship

    # File navigation & search
    fzf
    fd
    ripgrep
    eza
    bat
    zoxide
    yazi

    # Git
    git
    lazygit
    delta
    gh

    # Terminal
    tmux

    # Editors (Mason handles LSP/formatters inside nvim)
    neovim

    # Node.js ecosystem
    nodejs_22
    corepack_22
    pnpm
    bun

    # Rust toolchain (for bob-nvim, cargo-installed tools)
    rustup

    # Version manager
    mise

    # Docker
    docker
    docker-compose
    lazydocker

    # Cloud
    google-cloud-sdk

    # Utils
    jq
    curl
    wget
    unzip
    stow
    gnumake
    gcc

    # Python (for node-gyp native module compilation)
    python3

    # Nix tools
    direnv
    nix-direnv
    alejandra
  ];

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };

  home.sessionVariables = {
    EDITOR = "nvim";
    npm_config_nodedir = "${pkgs.nodejs_22}";
  };
}
