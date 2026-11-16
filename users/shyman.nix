{ inputs, config, lib, pkgs, ... }:
let
  authorizedKeys = inputs.ssh-keys.packages.${pkgs.stdenv.hostPlatform.system}.authorizedKeys;
  dotfiles = inputs.dotfiles.packages.${pkgs.stdenv.hostPlatform.system};
  dotfile = name: {
    source = dotfiles."${name}";
    target = "${name}/..";
    recursive = true;
  };
in
{
  programs.zsh = {
    enable = true;
    enableCompletion = false;
  };

  users.users.shyman = {
    isNormalUser = true;
    extraGroups = [ "wheel" ]; # Enable ‘sudo’ for the user.
    openssh.authorizedKeys.keyFiles = [ authorizedKeys.outPath ];
    shell = pkgs.zsh;
  };

  home-manager.users.shyman = {config, pkgs, ...}: {
    home = {
      packages = with pkgs; [
        htop
        ncdu
        envsubst
        emacs-nox
        zoxide
        vivid
        mcfly
      ];
      stateVersion = "26.11";
    };

    programs.git = {
      enable = true;
      settings = {
        user = {
          name = "Szymon Mikulicz";
          email = "szymon.mikulicz@posteo.net";
        };
      };
    };

    home.file = {
      scripts = dotfile "scripts";
      global = dotfile "global";
      zsh = dotfile "zsh";
      emacs = dotfile "emacs";
    };

    systemd.user.services.emacs.Service.Environment = "COLORTERM=truecolor";
    services.emacs = {
      enable = true;
      package = pkgs.emacs-nox;
      socketActivation.enable = true;
    };
  };
}
