#!/bin/bash
echo "setting up ARP flow entry"
ovs-ofctl -O OpenFlow13 add-flow s1 priority=65001,dl_type=0x0806,nw_dst=10.0.0.2,actions=output:2
