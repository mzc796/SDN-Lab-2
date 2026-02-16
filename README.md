# SDN-Lab-2
Connect OpenDaylight with mininet

Continue with what we had on previous lab, we will install OpenDaylight as the SDN controller to connect with Mininet to read the network statistics. 
## Virtual Machine Summary
Memory: >= 8GB

Storage: 50GB

CPU: 2 cores, AMD64 Architecture

Installation Disc: [ubuntu-22.04.4-desktop-amd64.iso](https://old-releases.ubuntu.com/releases/22.04/)

## References
[An Instant Virtual Network on your Laptop (or other PC)](https://mininet.org/)

[PICOS 4.4.3 Configuration G](https://pica8-fs.atlassian.net/wiki/spaces/PicOS443sp/overview?homepageId=10453009)

[OpenDaylight Flow Examples](https://docs.opendaylight.org/projects/openflowplugin/en/latest/users/flow-examples.html)
## Build a complete SDN testbed
1. Install and Configure Java
> (1) Install Java
  ```
  sudo apt-get install openjdk-17-jdk
  ```
> (2) Configure JAVA_HOME to /etc/profile

  ```
  sudo vim /etc/profile
  ```
> (3) Add the following to the end of /etc/profile
  ```
  JAVA_HOME=/usr/lib/jvm/java-17-openjdk-amd64
  PATH=$PATH:$HOME/bin:$JAVA_HOME/bin
  export JAVA_HOME
  export JRE_HOME
  export PATH
  ```
> (4) Make JAVE_HOME valid and Test JAVA Version
  ```
  source /etc/profile
  java -version
  ```

2. Install OpenDaylight
> (1) Download OpenDaylight Calcium
  ```
  wget https://nexus.opendaylight.org/content/repositories/opendaylight.release/org/opendaylight/integration/karaf/0.20.1/karaf-0.20.1.zip
  ```
> (2) Extract it to $HOME
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
3. Run OpenDaylight. In a system terminal:
  ```
  sudo ./karaf
  ```
4. Connect Mininet to OpenDaylight
> (1) Run Mininet with Customized Topology and Connect to Controller
  ```
  sudo mn --custom ~/lab-1/topo-2sw-2host.py --topo mytopo --switch ovsk,protocols=OpenFlow13 --controller remote,ip=127.0.0.1,port=6653
  ```
> NOTE: We can also have a remote controller building in another VM. If so, we connect Mininet to the remote controller with the $IP_ODL of that VM.
  The $IP_ODL can be known with the command ```ifconfig``` on the OpenDaylight VM.
  
> Question: Is the connection successful?
> 
> If the connection between ODL and mininet is successful, the mininet terminal shows: 
  ```
  *** Creating network
  *** Adding controller
  *** Adding hosts:
  ...
  ```
> Otherwise, there will be ``Unable to connect the remote controller at $IP_ODL`` after ``*** Adding controller``
> How to debug?
> 
> (2) Check Listening Ports. Open another terminal
  ```
  sudo lsof -i -P -n | grep LISTEN
  ```
> Question: What do you observe?
> 
> (3) Install OpenFlow Plugins in OpenDaylight terminal `opendaylight-user@root>`:
  ```
  feature:install odl-openflowplugin-app-topology-lldp-discovery odl-openflowplugin-app-table-miss-enforcer odl-openflowplugin-flow-services odl-openflowplugin-flow-services-rest odl-openflowplugin-app-topology-manager odl-openflowplugin-app-lldp-speaker
  ```
>
> (4) Check Listening Ports again.
  ```
  sudo lsof -i -P -n | grep LISTEN
  ```
> NOTE: If ```tcp *:6653 (LISTEN)``` and ```tcp *:8181 (LISTEN)``` do not show, shut down OpenDaylight with ```Control+D``` and restart ```sudo ./karaf```
> 
> (5) Re-run Mininet:
  ```
  sudo mn --custom ~/lab-1/topo-2sw-2host.py --topo mytopo --switch ovsk,protocols=OpenFlow13 --controller remote,ip=127.0.0.1,port=6653
  ```
> Question: Is the connection successful this time?
> 
5. Capture OpenFlow messages
> ```
> sudo wireshark
> ```
> Question: Which interface do we monitor?
> 
6. Read network statistics from the northbound API of OpenDaylight
> 
> (1) Create `data` folder. In a terminal,
> 
> ```
> mkdir data
> ```
> 
> (2) Request nodes (switches)
> 
> Refer to `read_nodes.sh`
> 
> Read nodes file:
> ```
> sudo vim data/nodes.sh
> ```
> 
> In vim, press `Ctrl`+`:`, then type `%!jq .` for better json file reading.
> 
> (3) Request topology
> 
> Refer to `read_topo.sh`
>
> Read topology file
>
7. Config Data Store & Nonconfig Data Store
> (1) Request the data store of a switch
> 
> Refer to `read_flows.sh`
> 
> Question: What value do we put as the variable?
>
> Read the `flows.json` file, keep in mind what you see.
> 
> (2) Request the nonconfig data store of a switch
> 
> Refer to `read_nonconfig_flows.sh`
> 
> Read the `nonconfig_flows.json` file, keep in mind what you see.
> 
> (3) Request the config data store of the same switch
> 
> Refer to `read_config_flows.sh`
> 
> Read the `config_flows.json` file, keep in mind what you see.
> 
> Question: Why?
>
> (4) Configure a flow entry on the mininet end, repeat (1)(2)(3) steps, reason about the config data store & nonconfig data store design of OpenDaylight.
