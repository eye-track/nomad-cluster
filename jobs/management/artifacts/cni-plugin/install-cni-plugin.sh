#!/bin/bash

echo "[START] Unzip CNI plugin to /opt/cni/bin..."
sudo mkdir -p /opt/cni/bin
sudo tar -C /opt/cni/bin -xzf local/cni-plugins.tgz
echo "[END] Unzip CNI plugin to /opt/cni/bin..."

while true; do
  echo "Still waiting..."
  sleep 60
done