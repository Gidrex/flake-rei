{ pkgs, ... }:

let
  wgConfigFile = "/etc/wireguard/Lon.conf";
in
{
  systemd.services.udp2raw = {
    description = "udp2raw service";
    wants = [ "network-online.target" ];
    after = [ "network-online.target" ];
    serviceConfig = {
      ExecStart = "${pkgs.udp2raw}/bin/udp2raw -s -l0.0.0.0:4096 -r127.0.0.1:51820 --raw-mode faketcp -a";
      Restart = "on-failure";
    };
    wantedBy = [ "multi-user.target" ];
  };

  systemd.services.wireguard = {
    description = "WireGuard service";
    wants = [ "network-online.target" "udp2raw.service" ];
    after = [ "network-online.target" "udp2raw.service" ];
    serviceConfig = {
      ExecStart = "${pkgs.wireguard-tools}/bin/wg-quick up ${wgConfigFile}";
      ExecStop = "${pkgs.wireguard-tools}/bin/wg-quick down ${wgConfigFile}";
      Restart = "on-failure";
    };
    wantedBy = [ "multi-user.target" ];
  };
}
