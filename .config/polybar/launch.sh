#!/bin/bash
# Kill existing polybar instances
killall -q polybar
# Wait for processes to shut down
while pgrep -u $UID -x polybar >/dev/null; do sleep 0.2; done
# Launch
polybar main 2>&1 | tee /tmp/polybar.log & disown
