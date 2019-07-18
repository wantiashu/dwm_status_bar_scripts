#!/bin/bash

#sampleinterval, sample interval in s
if [[ -z "$cache_dir" ]];then
  export cache_dir="$HOME/.cache/dwm_status_bar"
fi
if [[ -z "$cpu_sample_interval" ]];then
  export cpu_sample_interval="1"
fi
[ -d "$cache_dir" ] || mkdir "$cache_dir" 

export cpu_total_time_cache=""
export cpu_nonidle_time=""
export cpu_perc=""

while true;do
# useful fields from the output of proc/stat
# 2:user 3:nice 4:system 5:idle 6:iowait 7:irq 8:softirp 9:steal
  read user2 nice3 system4 idle5 iowait6 irq7 softirp8 steal9 <<< $(cat /proc/stat | head -n 1 | tr -s ' ' |cut -d ' ' -f 2,3,4,5,6,7,8,9)
    cpu_total_time=$((user2 + nice3 + system4 + idle5 + iowait6 + irq7 + softirp8 + steal9))
    cpu_nonidle_time=$((user2 + nice3 + system4 + irq7 + softirp8 +steal9))
  if [[ -z "$cpu_total_time_cache" || -z "$cpu_nonidle_time_cache" ]]; then
    cpu_total_time_cache=$cpu_total_time
    cpu_nonidle_time_cache=$cpu_nonidle_time
    echo "NA1" > "$cache_dir/cpu_perc"
    continue
  fi
  if (( "$cpu_total_time_cache" > "$cpu_total_time" || "$cpu_nonidle_time_cache" > "$cpu_nonidle_time" ));then
    cpu_total_time_cache=$cpu_total_time
    cpu_nonidle_time_cache=$cpu_nonidle_time
    echo "NA2" > "$cache_dir/cpu_perc"
    continue
  fi 	
    cpu_perc=$(($((cpu_nonidle_time - cpu_nonidle_time_cache)) * 100 / $((cpu_total_time - cpu_total_time_cache))))
    cpu_total_time_cache=$cpu_total_time 
    cpu_nonidle_time_cache=$cpu_nonidle_time 
    echo "$cpu_perc" > "$cache_dir/cpu_perc"
  sleep  $cpu_sample_interval
done
