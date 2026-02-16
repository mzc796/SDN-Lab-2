#!/bin/bash
echo "setting up icmp flow entry"
ovs-ofctl -O OpenFlow13 add-flow s1 priority=65001,dl_type=0x0800,nw_proto=1,nw_dst=10.0.0.2,actions=output:2
