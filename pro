| grep -E 'progress|finished' | while read line; do
    # Extract and display percentage
    if [[ $line =~ ([0-9]+)%.*([0-9]+) ]]; then
        echo -ne "Restore progress: ${BASH_REMATCH[1]}%\r"
    elif [[ $line =~ finished ]]; then
        echo -ne "Restore complete: 100%"
        echo ""
    fi
done
