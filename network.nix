{ config, pkgs, ... }:

{
  networking = {
    nat = {
      enable = true;
      externalInterface = "wlp1s0";  # 替换为你的外部网络接口
      internalInterfaces = [ "vmnet8" "virbr0" "vmnet1" ];  # 替换为你的内部网络接口
      forwardPorts = [
        { destination = "172.16.100.130:3389"; sourcePort = 3389; }  # 替换为你的内部 IP 和端口
      ];
    };
  };

  services.samba = {
    enable = true;
    shares = {
      "vmshare" = {
        path = "/home/ykh/Public";
        guestOk = false;
        "valid user" = ["ykh"];
        "create mask" = "0700";
        "directory mask" = "0700";
      };
    };
  };

  networking.firewall = {
    enable = true;
    # for remote rdp
    allowedTCPPorts = [ 3389 ];
    # libvirtd and vmware SMB services enable
    interfaces.virbr0.allowedUDPPorts = [ 137 138 ];
    interfaces.virbr0.allowedTCPPorts = [ 139 445 8000 ];
    interfaces.vmnet1.allowedUDPPorts = [ 137 138 ];
    interfaces.vmnet1.allowedTCPPorts = [ 139 445 8000 ];
    interfaces.vmnet8.allowedUDPPorts = [ 137 138 ];
    interfaces.vmnet8.allowedTCPPorts = [ 139 445 8000 ];
  };
   
  programs.proxychains.enable = true;
  programs.proxychains.proxies = {
    myproxy = {
      type = "http";
      host = "127.0.0.1";
      port = 7890;
    };
  };

}
