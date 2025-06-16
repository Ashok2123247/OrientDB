
DUMP_PID=$!

# Step 3: Monitor progress
while kill -0 $DUMP_PID 2>/dev/null; do
    CURRENT_SIZE=$(du -sb "$DUMP_DIR" | awk '{print $1}')
    PERCENT=$(( CURRENT_SIZE * 100 / TOTAL_SIZE ))
    FILLED=$(( PERCENT * BAR_WIDTH / 100 ))
    EMPTY=$(( BAR_WIDTH - FILLED ))
    printf "\r[%-${BAR_WIDTH}s] %3d%%" "$(printf '#%.0s' $(seq 1 $FILLED))" "$PERCENT"
    sleep 1
done

# Final bar
printf "\r[%-${BAR_WIDTH}s] 100%%\n" "$(printf '#%.0s' $(seq 1 $BAR_WIDTH))"
echo "Backup completed."
