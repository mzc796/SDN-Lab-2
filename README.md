# SDN-Lab-2
Connect OpenDaylight with mininet

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
## Build a complete SDN testbed
1. Install OpenDaylight
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
2. Run OpenDaylight. In a system terminal:
  ```
  sudo ./karaf
  ```
3. Connect Mininet to OpenDaylight
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
> NOTE: If ```tcp *:6653 (LISTEN)``` and ```tcp *:8181 (LISTEN)``` do not show, shut down OpenDaylight with ```Control+D``` and restart ```sudo ./karaf```
> 
> (4) Check Listening Ports again.
  ```
  sudo lsof -i -P -n | grep LISTEN
  ```
> (5) Re-run Mininet:
  ```
  sudo mn --custom ~/lab-1/topo-2sw-2host.py --topo mytopo --switch ovsk,protocols=OpenFlow13 --controller remote,ip=127.0.0.1,port=6653
  ```
> Question: Is the connection successful this time?
> 
4. Capture OpenFlow messages
> ```
> sudo wireshark
> ```
> Question: Which interface do we monitor?
> 
5. Read network statistics from the northbound API of OpenDaylight
>
> (1) Create `data` folder
> 
> ```mkdir data```
> 
> (2) Read nodes (switches)
> 
> Refer to `read_nodes.sh`
> 
> ```sudo vim data/nodes.sh```
> In vim, press `Ctrl`+`:`, then type `%!jq .` for better json file reading.
> 
> (3) Read topology
> 
> Refer to `read_topo.sh`
>
> (4) Read operational data store
> 
> Refer to `read_operational_table.sh`
> 
> (5) Read config data store
> 
> Refer to `read_config_table.sh`
>
