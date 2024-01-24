## v1.5
- Change Sheduler I/O To cfq
- Sdcard Tweaks (read_ahead_kd)
- Optimize Other Code

## v1.4
- Removes the [ ! -w "$path" ] || [ -w "$path" ] condition as it is not needed.
- Combines the conditions [ ! -w "$path" ] and chmod +w "$path" into one elif block.
- Using single brackets [ ] for conditions
- Removed the use of if !echo "$data" > "$path" 2> /dev/null and replaced it with echo "$data" > "$path" || { ... } . This allows us to handle errors better and return an exit code of 1 if the write fails.
- Combines the chmod +w "$path" 2>/dev/null command with a return of 1 using the || operator. If the chmod command fails, then exit code 1 will be returned immediately.

for scheduler in /sys/block/*/queue; do
write $scheduler/scheduler "noop"
write $scheduler/iostats "0"
write $scheduler/add_random "0"
write $scheduler/nomerges "1"
write $scheduler/rq_affinity "0"
write $scheduler/rotational "0"
write $scheduler/read_ahead_kb "4096"
write $scheduler/nr_requests "512"
done
 
for iosched in /sys/block/*/iosched; do
write $iosched/slice_idle "0"
write $iosched/slice_idle_us "0"
write $iosched/group_idle "0"
write $iosched/group_idle_us "0"
write $iosched/low_latency "1"
done

- In this setting, we use the "noop" scheduler which is a simple and efficient scheduler for IO performance. We also set some other values to improve performance, such as enabling IO request merging by setting "nomerges" to 1, setting "read_ahead_kb" to 4096 to read more data at once, and increasing the number of "nr_requests" to 512 to allow more IO requests simultaneously.

- In the code in the refactored uninstall.sh file, I added a few small changes to ensure a successful uninstall. I used the -r option in the rm command to recursively delete directories if they are empty after deleting the files in them. I also added quotes to the LINE variable to avoid problems with spaces or special characters in file paths.

## v1.3

- Fix Double Process ro.sys.fw.bg_apps_limit
- Multithread & Hyperthread true
- Delete Dalvik Settings (Not Work)

## v1.2

- Set Touch Boost
- Force GPU Touch RenderRender
- Google Service Reduce Drain Tweaks
- CPU Perf

## v1.1

- Add Ram Management
- I/O Optimization RAM
- VM Setting
- OOM (Out Of Memory)
- Entropy
- Optimization Activity Manager
- Low Memory Killer

## v1.0

- Initial Release
