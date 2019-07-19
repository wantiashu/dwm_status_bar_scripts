#!/bin/bash

# This script depends on the other three scripts
# in the system_monitoring folder.
# These three scripts read and calculate cpu,
# ram, and disk utilization and output them to
# the cache dir.
# This script read their output from cache dir
# and display them on the dwm status bar.

# Display interval in second, this is the interval between two displays.
export display_interval="0.36"
# cpu sample interval in second, default 1.
export cpu_sample_interval="0.6"
# ram sample interval in second, default 1.
export ram_sample_interval="0.6"
# dsk sample interval in second, default 1.
export dsk_sample_interval="1.2"
# At most two disk can be displayed. 
# If you want to display only one disk,
# set the two variable to the same value.
# root_disk label in sdX
export root_disk="sda"
# root_disk label in sdX
export home_disk="sdb"
# Configure the cache dir
# where you want to put cache in 
# default $HOME/.cache/dwm_status_bar.
export cache_dir="$HOME/.cache/dwm_status_bar"

[ -d $cache_dir ] || mkdir -r $cache_dir

path=$(realpath $0)
export script_dir=${path%/*}
$script_dir/system_monitoring/cpu_perc.sh &
$script_dir/system_monitoring/ram_perc.sh &
$script_dir/system_monitoring/dsk_util.sh &

while true;do
# Edit the output format:
# cpu_perc for cpu usage;
# ram_perc for ram usage;
# root_disk_util home_disk_util for disk usage.
# If you choose to display only one disk, 
# and have followed the instruction above, use either one.
  output=$(printf\
    "[vol%3s] [cpu%3s] [ram%3s] [dsk%3s%3s] %s %s"\
    $(pamixer --get-volume)\
    $(cat $cache_dir/cpu_perc)\
    $(cat $cache_dir/ram_perc)\
    $(cat $cache_dir/root_disk_util)\
    $(cat $cache_dir/home_disk_util)\
    $(date +"%F %T"))
  xsetroot -name "$output"
  sleep $display_interval
done
