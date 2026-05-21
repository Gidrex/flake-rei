{
  programs.nushell = {
    configFile.source = ./config.nu;
    shellAliases = {
      "!!" = "eval doas (history | head -n1 | string trim)";
      ls = "eza";
      la = "ls -al";
      "..." = "cd ../../";
      "...." = "cd ../../../";
      "....." = "cd ../../../../";
      # md = "mkdir -p";

      # custom fzf scripts
      # zz = '' z $(find . -type d | fzf --preview "eza --icons=always {}" --preview-window=right:30%:wrap --exact)'';
      # zx = '' z $(zoxide query -l | fzf --preview "eza -T --level 2 --icons=always {}" --preview-window=right:30%:wrap)'';
    };
  };
}
