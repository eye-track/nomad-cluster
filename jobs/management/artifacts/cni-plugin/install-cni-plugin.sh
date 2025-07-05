#!/bin/bash

echo "[START] Unzip CNI plugin to /etc/cni/bin..."
mkdir -p /etc/cni/bin
tar -C /etc/cni/bin -xzf local/cni-plugins.tgz
echo "[END] Unzip CNI plugin to /etc/cni/bin..."

while true; do
  echo "Still waiting..."
  sleep 60
done