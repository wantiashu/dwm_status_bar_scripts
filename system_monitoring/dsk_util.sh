#!/bin/bash

#sampleinterval, sample interval in s
if [[ -z "$cache_dir" ]];then
  export cache_dir="$HOME/.cache/dwm_status_bar"
fi
if [[ -z "$dsk_sample_interval" ]];then
  export dsk_sample_interval="1"
fi
if [[ -z "$root_disk" ]];then
  export root_disk="sdc"
fi
if [[ -z "$home_disk" ]];then
  export home_disk="sdd"
fi
[ -d "$cache_dir" ] || mkdir "$cache_dir" 

export root_disk_io_time_cache=""
export root_disk_util=""
export home_disk_io_time_cache=""
export home_disk_util=""
export dskinterval=$(bc <<< "1000 * $dsk_sample_interval" | sed 's/\.[[:digit:]]*//g')
#export USERHZ=$(getconf CLK_TCK || "100")

while true;do
# useful fields from the output of /proc/meminfo
# miliseconds doing I/O
  root_disk_io_time=$(cat /proc/diskstats | grep $root_disk' ' | tr -s ' ' | cut -d ' ' -f 14)
  home_disk_io_time=$(cat /proc/diskstats | grep $home_disk' ' | tr -s ' ' | cut -d ' ' -f 14)
  if [[ -z "$root_disk_io_time_cache" || -z "$home_disk_io_time_cache" ]]; then
    root_disk_io_time_cache=$root_disk_io_time
    home_disk_io_time_cache=$home_disk_io_time
    root_disk_util="NA1"
    home_disk_util="NA1"
    continue
  elif (( "$root_disk_io_time_cache" > "$root_disk_io_time" || "$home_disk_io_time_cache" > "$home_disk_io_time" ));then
    root_disk_io_time_cache=$root_disk_io_time
    home_disk_io_time_cache=$home_disk_io_time
    root_disk_util="NA2"
    home_disk_util="NA2"
  #elif [[ -z "$cputimeinterval" ]];then
    #root_disk_util="NA3"
    #home_disk_util="NA3"
    #return 1
    continue
  fi
    #root_disk_util=$(($((root_disk_io_time - root_disk_io_time_cache)) * 100 / $((cputimeinterval * $((1000 / USERHZ ))))))
    #home_disk_util=$(($((home_disk_io_time - home_disk_io_time_cache)) * 100 / $((cputimeinterval * $((1000 / USERHZ ))))))
    root_disk_util=$(($((root_disk_io_time - root_disk_io_time_cache)) * 100 / dskinterval))
    home_disk_util=$(($((home_disk_io_time - home_disk_io_time_cache)) * 100 / dskinterval))
    root_disk_io_time_cache=$root_disk_io_time
    home_disk_io_time_cache=$home_disk_io_time
    echo "$root_disk_util" > "$cache_dir/root_disk_util"
    echo "$home_disk_util" > "$cache_dir/home_disk_util"
    sleep $dsk_sample_interval
done
