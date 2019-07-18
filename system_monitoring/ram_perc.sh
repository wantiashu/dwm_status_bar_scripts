#!/bin/bash

#sampleinterval, sample interval in s
if [[ -z "$cache_dir" ]];then
  export cache_dir="$HOME/.cache/dwm_status_bar"
fi
if [[ -z "$ram_sample_interval" ]];then
  export ram_sample_interval="1"
fi

export ram_perc=""

while true;do
# useful fields from the output of /proc/meminfo
# Buffers Cached MemAvailable MemFree MemTotal 
  abc=$(cat -A /proc/meminfo | grep -e ^Buffers: -e ^Cached: -e ^MemAvailable: -e ^MemFree: -e ^MemTotal: | tr -s " " | sort -k 1 | cut -d " " -f 2)
  read buffers cached memavailable memfree memtotal <<< $(echo $abc)
  ram_perc=$(($((memtotal - memfree - buffers - cached)) * 100 / memtotal))
  echo "$ram_perc" > "$cache_dir/ram_perc"
  sleep $ram_sample_interval
done
