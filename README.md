# dwm_status_bar_scripts

"dwm status bar scripts"用于dwm, dynamic window manager, https://dwm.suckless.org/.

"dwm status bar scripts" is for dwm, i.e dynamic window manager, https://dwm.suckless.org/.

## 工作原理 How it works

这几个脚本用于在dwm的状态栏显示cpu，内存和硬盘使用百分数。

This set of scripts could show cpu， ram and disk usage on dwm status bar.

也可以显示时间，日期或音量等。

Other items such as time, date or volume could also be displayed.

dwm_status_bar.sh 依赖于system_monitoring_folder 中的其它三个脚本。

dwm_status_bar.sh depends on the other three scripts in the system_monitoring folder.

这三个脚本读取cpu，ram和硬盘使用量，并将他们输出到cache文件夹。

These three scripts read and calculate cpu, ram, and disk utilization and output them to the cache dir.

dwm_status_bar.sh 从cache读取这些信息，并将它们显示在dwm的状态栏上。

dwm_status_bar.sh read their output from cache dir and display them on the dwm status bar.

## 使用方法 To use it

将dwm_status_bar.sh 和 system_monitoring folder 拷贝到你的home目录。

Copy dwm_status_bar.sh and the system_monitoring folder to anywhere in you home directory.

运行 dwm_status_bar.sh 就可以。

Run dwm_status_bar.sh

可以把它加进 .xinitrc 以在dwm启动时运行。

you could add it in .xinitrc to run it when dwm starts.
