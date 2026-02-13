# SDN-Lab-2
Connect OpenDaylight with mininet to configure flow entries

Continue with what we had on previous lab, we install OpenDaylight as the SDN controller 
## Virtual Machine Summary
Memory: >= 8GB

Storage: 50GB

CPU: 2 cores, AMD64 Architecture

Installation Disc: [ubuntu-22.04.4-desktop-amd64.iso](https://old-releases.ubuntu.com/releases/22.04/)

## References
[An Instant Virtual Network on your Laptop (or other PC)](https://mininet.org/)
[PICOS 4.4.3 Configuration G](https://pica8-fs.atlassian.net/wiki/spaces/PicOS443sp/overview?homepageId=10453009)
[OpenDaylight Flow Examples](https://docs.opendaylight.org/projects/openflowplugin/en/latest/users/flow-examples.html)
## Install OpenDaylight as the SDN controller


1. Install mininet and Wireshark
  ```
  sudo apt-get update
  sudo apt-get install mininet
  sudo apt-get install wireshark
  ```
2. Understand flow entry
   
   (1) Run mininet with the default topology in the system terminal:
   ```
   sudo mn
   ```
   (2) In the mininet terminal:
   ```
   pingall
   ```
   Question: What is the result?
   
   (3) Check the flow entries of each switch (e.g., s1). In another system terminal: 
   ```
   sudo ovs-ofctl -O OpenFlow13 dump-flows s1
   ```
   Question: Why do you think the `ping` works?
   
   (5) Stop mininet. In the mininet terminal:
   ```
   exit
   ```
3. Understand `ping` process
   
   (1) Run mininet with a tree topology
   ```
   sudo mn --topo tree,depth=3,fanout=2
   ```
   (2) Run Wireshark to prepare for capturing the "ping" packets. Question: Which interface do we select to monitor?
   ```
   sudo wireshark
   ```
   (3) Check ARP table on each host. On the mininet terminal:
   ```
   h1 arp
   ```
   Keep in mind what you have observed.
   
   (4) In the mininet terminal:
   ```
   pingall
   ```
   (5) Check ARP table on each host again. In the mininet terminal:
   ```
   h1 arp
   ```
   What do you observe?
   
   (6) Question: When we do `ping`, what packets have been exchanged in a sequence? Why?

   (7) Stop mininet. In the mininet terminal:
   ```
   exit
   ```
   
4. Manually configure flow entries to make `ping` work
   ```
   mkdir lab-1
   cd lab-1
   ```
   (1) Customize your topology, create a file named "topo-2sw-2host.py", and copy the code below into the file.
   ```
   from mininet.topo import Topo
   class MyTopo( Topo ):
    "Simple topology example."

    def build( self ):
        "Create custom topo."

        # Add hosts and switches
        leftHost = self.addHost( 'h1' )
        rightHost = self.addHost( 'h2' )
        leftSwitch = self.addSwitch( 's1' )
        rightSwitch = self.addSwitch( 's2' )

        # Add links
        self.addLink( leftHost, leftSwitch )
        self.addLink( leftSwitch, rightSwitch )
        self.addLink( rightSwitch, rightHost )
   topos = { 'mytopo': ( lambda: MyTopo() ) }
   ```
   (2) Run mininet with the customized topology. In a system terminal:
   ```
   sudo mn --custom ~/lab-1/topo-2sw-2host.py --topo mytopo --switch ovsk,protocols=OpenFlow13 --controller remote,ip=127.0.0.1,port=6653
   ```
   (3) In the mininet terminal:
   ```
   h1 ping h2
   ```
   Question: What is the result of `ping`?
   
   (3) Check the flow entries of each switch (e.g., s1). In another system terminal: 
   ```
   sudo ovs-ofctl -O OpenFlow13 dump-flows s1
   ```
   Question: Why do you think the `ping` doesn't work this time?
   
   (4) Make ```h1 ping h2``` work

   Hint: Refer to the bash scripts of `icmp.sh` and `arp.sh` in this repository.
