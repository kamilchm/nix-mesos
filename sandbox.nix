with import <nixpkgs> {}; {
  mesosEnv = stdenv.mkDerivation {
    name = "mesos-sandbox";
    buildInputs = [ screen jdk zookeeper mesos marathon ];
    shellHook = ''
      mkdir -p tmp

      screen -dmLS zookeeper \
      ${jdk.jre}/bin/java \
        -cp "${zookeeper}/lib/*:${zookeeper}/${zookeeper.name}.jar:." \
        -Dzookeeper.datadir.autocreate=true \
        org.apache.zookeeper.server.quorum.QuorumPeerMain zoo.cfg

      export MESOS_ZK=zk://127.0.0.1:2181/mesos
      export MESOS_QUORUM=1
      export MESOS_CLUSTER=sandbox
      export MESOS_WORK_DIR=tmp/mesos 
      screen -dmLS mesos-master \
      mesos-master

      export MESOS_MASTER=zk://127.0.0.1:2181/mesos
      export MESOS_CONTAINERIZERS=docker,mesos
      export MESOS_PORT=5051
      export MESOS_RESOURCES="ports(*):[11000-11999]"
      screen -dmLS mesos-slave \
      mesos-slave

      screen -dmLS marathon \
      marathon --master zk://127.0.0.1:2181/mesos

      tail -f screenlog.0
    '';
  };
}

