{
  network.description = "Mesos Single VM Sandox";
  
  mesos-vm = { config, pkgs, ... }:
  {
    networking.firewall.enable = false;

    virtualisation.docker.enable = true;

    services = { 
      zookeeper.enable = true;

      mesos = {
        master = {
          enable = true;
          zk = ''zk://mesos-vm:2181/mesos'';
        };

        slave = {
          enable = true;
          master = ''mesos-vm:5050'';
          withDocker = true;
        };
      };

      marathon = {
        enable = true;
        master = ''mesos-vm:5050'';
      };
    };

    environment.systemPackages = with pkgs; [
      python
    ];
  };
}
