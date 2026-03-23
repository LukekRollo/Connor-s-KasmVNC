#!/bin/bash

# Don't start twice
if ss -tlnp | grep -q 6901; then
    echo "VNC already running"
    exit 0
fi

# Start VNC
bash /opt/start-vnc.sh > /tmp/vnc-startup.log 2>&1

# Wait until port 6901 is actually listening
echo "Waiting for KasmVNC to be ready..."
for i in $(seq 1 30); do
    if ss -tlnp | grep -q 6901; then
        echo "✅ KasmVNC ready on port 6901"
        exit 0
    fi
    sleep 1
done

echo "❌ KasmVNC failed to start in 30 seconds"
cat /tmp/vnc-startup.log
exit 1