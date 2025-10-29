#!/bin/bash

# Auto-restart script
# Usage: ./auto_restart.sh <command> [args...]
# Single Ctrl+C kills child and restarts
# Double Ctrl+C (within 2 seconds) exits script

if [ $# -eq 0 ]; then
    echo "Usage: $0 <command> [args...]"
    exit 1
fi

COMMAND=("$@")
CHILD_PID=""
INTERRUPT_COUNT=0
LAST_INTERRUPT=0

cleanup() {
    if [ ! -z "$CHILD_PID" ]; then
        kill $CHILD_PID 2>/dev/null
        wait $CHILD_PID 2>/dev/null
    fi
    exit 0
}

handle_interrupt() {
    local current_time=$(date +%s)
    
    # If this is within 2 seconds of the last interrupt, exit
    if [ $((current_time - LAST_INTERRUPT)) -le 2 ] && [ $INTERRUPT_COUNT -gt 0 ]; then
        echo ""
        echo "Double Ctrl+C detected. Exiting..."
        cleanup
    fi
    
    INTERRUPT_COUNT=$((INTERRUPT_COUNT + 1))
    LAST_INTERRUPT=$current_time
    
    if [ ! -z "$CHILD_PID" ]; then
        echo ""
        echo "Stopping child process (PID: $CHILD_PID)..."
        kill $CHILD_PID 2>/dev/null
        wait $CHILD_PID 2>/dev/null
        CHILD_PID=""
    fi
    
    # Reset interrupt count after 3 seconds
    (sleep 3; INTERRUPT_COUNT=0) &
}

trap handle_interrupt SIGINT

echo "Auto-restart script started. Command: ${COMMAND[*]}"
echo "Press Ctrl+C once to restart, twice quickly to exit."
echo ""

while true; do
    echo "Starting: ${COMMAND[*]}"
    "${COMMAND[@]}" &
    CHILD_PID=$!
    
    wait $CHILD_PID
    EXIT_CODE=$?
    CHILD_PID=""
    
    if [ $EXIT_CODE -eq 0 ]; then
        echo "Command exited successfully (code: $EXIT_CODE)"
    else
        echo "Command failed (code: $EXIT_CODE)"
    fi
    
    echo "Restarting in 1 second..."
    sleep 1
done