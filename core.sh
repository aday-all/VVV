#!/bin/bash

echo "Current Path: $PWD"
fi

echo "Start Clash Core Download !"
#core download url
core_dir="${2:-files/etc/openclash/core}"
ARCH_1="${3:-$ARCH_1}"
if [[ "${4:-$ARCH_2}" == "x86_64" ]]; then
  clash_meta="$(meta_api="https://api.github.com/repos/MetaCubeX/mihomo/releases/latest" && meta_file="mihomo-linux-$ARCH_1-compatible" && curl -s ${meta_api} | grep "browser_download_url" | grep -oE "https.*${meta_file}-v[0-9]+\.[0-9]+\.[0-9]+\.gz" | head -n 1)"
#  clash_meta="https://github.com/MetaCubeX/mihomo/releases/download/v1.17.0/mihomo-linux-$ARCH_1-compatible-v1.17.0.gz"
else
  clash_meta="$(meta_api="https://api.github.com/repos/MetaCubeX/mihomo/releases/latest" && meta_file="mihomo-linux-$ARCH_1" && curl -s ${meta_api} | grep "browser_download_url" | grep -oE "https.*${meta_file}-v[0-9]+\.[0-9]+\.[0-9]+\.gz" | head -n 1)"
#  clash_meta="https://github.com/MetaCubeX/mihomo/releases/download/v1.17.0/mihomo-linux-$ARCH_1-v1.17.0.gz"
fi

mkdir -p $core_dir
echo "Downloading clash_meta.gz..."
if wget --no-check-certificate -nv -O $core_dir/clash_meta.gz $clash_meta; then
   gzip -d $core_dir/clash_meta.gz
   echo "clash_meta.gz downloaded successfully."
else
   echo "Failed to download clash_meta.gz."
fi

ls -l $core_dir
echo "All Core Downloaded succesfully"
