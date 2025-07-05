#!/bin/bash

CONSUL_DIR="/usr/local/bin/"
echo "[START] Install Consul to $CONSUL_DIR ..."
unzip -o local/consul.zip consul -d $CONSUL_DIR
cmd_version="nomad -v"
eval $cmd_version

CNI_PLUGING_DIR="/opt/cni/bin"
echo "[START] Install CNI plugins to $CNI_PLUGING_DIR ..."
mkdir -p $CNI_PLUGING_DIR
tar -C $CNI_PLUGING_DIR -xzf local/cni-plugins.tgz
echo "[DONE] Install CNI plugins to $CNI_PLUGING_DIR !"
cmd_version="$CNI_PLUGING_DIR/bridge -v"
eval $cmd_version

echo "[START] Install consul-cni plugin to $CNI_PLUGING_DIR ..."
mkdir -p $CNI_PLUGING_DIR
unzip -o local/consul-cni.zip consul-cni -d $CNI_PLUGING_DIR
echo "[DONE] Install consul-cni plugin to $CNI_PLUGING_DIR !"
cmd_version="$CNI_PLUGING_DIR/consul-cni -v"
eval $cmd_version