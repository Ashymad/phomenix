{ pkgs, ... }: {
  home = {
    packages = with pkgs; [
      htop
      ncdu
      git
    ];
    stateVersion = "26.11";
  };

  programs.bash = {
    enable = true;
    shellAliases = {
      ":e" = "emacsclient";
      ":q" = "exit";
    };
  };

  programs.emacs = {
    package = pkgs.emacs-nox;
    enable = true;
    extraPackages = epkgs: [
      epkgs.evil
      epkgs.nix-mode
    ];
    extraConfig = ''
          ;; (package-initialize)  -*- lexical-binding: t; -*-

          ;; Sane amount of scroll
          (setq mouse-wheel-scroll-amount '(3))
          (setq mouse-wheel-progressive-speed nil)
          
          ;; Relnum
          (setq display-line-numbers-type 'relative)
          (global-display-line-numbers-mode)
          
          ;; Turn off menu
          (menu-bar-mode -1)
          
          (use-package evil
            :config
            (evil-mode 1))
	'';
  };

  services.emacs = {
    enable = true;
    defaultEditor = true;
    socketActivation.enable = true;
  };
}
