## v1.4
- Removes the [ ! -w "$path" ] || [ -w "$path" ] condition as it is not needed.
- Combines the conditions [ ! -w "$path" ] and chmod +w "$path" into one elif block.
- Using single brackets [ ] for conditions
- Removed the use of if !echo "$data" > "$path" 2> /dev/null and replaced it with echo "$data" > "$path" || { ... } . This allows us to handle errors better and return an exit code of 1 if the write fails.
- Combines the chmod +w "$path" 2>/dev/null command with a return of 1 using the || operator. If the chmod command fails, then exit code 1 will be returned immediately.

'''bash
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
'''

- Dalam pengaturan ini, kami menggunakan scheduler "noop" yang merupakan scheduler yang sederhana dan efisien untuk performa IO. Kami juga mengatur beberapa nilai lainnya untuk meningkatkan performa, seperti mengaktifkan penggabungan (merging) request IO dengan mengatur "nomerges" menjadi 1, mengatur "read_ahead_kb" menjadi 4096 untuk membaca lebih banyak data sekaligus, dan meningkatkan jumlah "nr_requests" menjadi 512 untuk mengizinkan lebih banyak permintaan IO secara bersamaan.

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
