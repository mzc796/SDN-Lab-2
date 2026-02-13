# SDN-Lab-2
Connect OpenDaylight with mininet to configure flow entries

Continue with what we had on previous lab, we will install OpenDaylight as the SDN controller to connect with Mininet to configure the network. 
## Virtual Machine Summary
Memory: >= 8GB

Storage: 50GB

CPU: 2 cores, AMD64 Architecture

Installation Disc: [ubuntu-22.04.4-desktop-amd64.iso](https://old-releases.ubuntu.com/releases/22.04/)

## References
[An Instant Virtual Network on your Laptop (or other PC)](https://mininet.org/)
[PICOS 4.4.3 Configuration G](https://pica8-fs.atlassian.net/wiki/spaces/PicOS443sp/overview?homepageId=10453009)
[OpenDaylight Flow Examples](https://docs.opendaylight.org/projects/openflowplugin/en/latest/users/flow-examples.html)
## Install OpenDaylight

(1) Download OpenDaylight Calcium
  ```
  wget https://nexus.opendaylight.org/content/repositories/opendaylight.release/org/opendaylight/integration/karaf/0.20.1/karaf-0.20.1.zip
  ```
>  (2) Extract it to $HOME
  ```
  unzip karaf-0.20.1.zip
  ```
> (3) Configure ODL-0.20.1 Environment
  ```
  cd karaf-0.20.1/bin
  vim setenv
  ```
> (4) Add the following to the setenv file
  
  ```
  export JAVA_HOME=/usr/lib/jvm/java-17-openjdk-amd64
  ```
4. Run OpenDaylight and Install OpenFlow Plugins
> (1) Run OpenDaylight
  ```
  sudo ./karaf
  ```
> (2) Install OpenFlow Plugins
  ```
  opendaylight-user@root>feature:install odl-openflowplugin-app-topology-lldp-discovery odl-openflowplugin-app-table-miss-enforcer odl-openflowplugin-flow-services odl-openflowplugin-flow-services-rest odl-openflowplugin-app-topology-manager odl-openflowplugin-app-lldp-speaker
  ```
> (3) Check Listening Ports
>
> Open another terminal
> 
  ```
  sudo lsof -i -P -n | grep LISTEN
  ```
  NOTE: If ```tcp *:6653 (LISTEN)``` and ```tcp *:8181 (LISTEN)``` do not show, shut down OpenDaylight with ```Control+D``` and restart ```sudo ./karaf```
