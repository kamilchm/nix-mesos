{
  mesos-vm = { config, pkgs, ... }:
  {
    deployment.targetEnv = "virtualbox";
    deployment.virtualbox = {
      memorySize = 2048;
      headless = true;
    };
  };
}
