{ config, ... }:
{
  sops = {
    defaultSopsFile = ../../secrets/secrets.yaml;
    defaultSopsFormat = "yaml";
    
    # Use SSH keys for decryption if available, or age
    age.keyFile = "${config.home.homeDirectory}/.config/sops/age/keys.txt";
    # age.sshKeyPaths = [ "${config.home.homeDirectory}/.ssh/id_ed25519" ];

    secrets = {
      # Example secret
      # "some_password" = { };
    };
  };
}
