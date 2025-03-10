#!/bin/bash
LOCK_FILE="lock.json"
OUTPUT_FILE="changes_output.json"
# Function to track changes and update JSON files
track_changes() {
    local changed_files=("$@")
    local updated_at=$(date -u +"%Y-%m-%dT%H:%M:%SZ")
    # Create lock data
    local lock_data=$(jq -n --argjson files "$(printf '%s\n' "${changed_files[@]}" | jq -R . | jq -s .)" \
        --arg updatedAt "$updated_at" '{modifiedFiles: $files, updatedAt: $updatedAt}')
    echo "$lock_data" > "$LOCK_FILE"
    # Create log data
    local log_data=$(jq -n --argjson files "$(printf '%s\n' "${changed_files[@]}" | jq -R . | jq -s .)" \
        --arg updatedAt "$updated_at" '{changedFiles: $files, updatedAt: $updatedAt}')
    echo "$log_data" > "$OUTPUT_FILE"
}
# Create a post-commit hook
echo -e "#!/bin/bash\n\n$(declare -f track_changes)\n\ntrack_changes_after_commit() {\n    local changed_files=(\$(git diff --name-only HEAD^ HEAD))\n    if [ \${#changed_files[@]} -gt 0 ]; then\n        track_changes \"\${changed_files[@]}\"\n    fi\n}\n\ntrack_changes_after_commit" > .git/hooks/post-commit
# Make the post-commit hook executable
chmod +x .git/hooks/post-commit
echo "Post-commit hook created. Changes will be tracked automatically after each commit."