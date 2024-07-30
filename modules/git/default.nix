{
programs.git = {
  enable = true;
  userName = "Alexander";
  userEmail = "Desench@proton.me";
  extraConfig = {
    init.defaultBranch = "main";
    pull.rebase = true;
    rebase.autostash = true;
    rebase.autosquash = true;
    push.autoSetupRemote = true;
    commit.gpgsign = false;
    rerere.enabled = true;
    gpg.format = "ssh";
    user.signingkey = "~/.ssh/id_rsa.pub";
    core.whitespace = "trailing-space,space-before-tab";
    core.editor = "nvim";
  };
};
}
