#!/bin/bash
LOG="/var/log/resource_monitor.log"
mkdir -p "$(dirname "$LOG")"
TS=$(date '+%Y-%m-%d %H:%M:%S')
CPU=$(top -bn1 | grep "Cpu(s)" | awk '{print int($2+$4)}')
MEM=$(free | awk '/Mem:/{printf "%.0f",$3/$2*100}')
DISK=$(df / | awk 'NR==2{print int($5)}')
echo "$TS | CPU:${CPU}% MEM:${MEM}% DISK:${DISK}%" >> "$LOG"
[ "$CPU" -gt 85 ] && echo "$TS [ALERT] CPU ${CPU}%" >> "$LOG"
[ "$MEM" -gt 85 ] && echo "$TS [ALERT] MEM ${MEM}%" >> "$LOG"
[ "$DISK" -gt 85 ] && echo "$TS [ALERT] DISK ${DISK}%" >> "$LOG"
