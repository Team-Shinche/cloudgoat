#!/bin/bash

DIRS=("16" "17")

OUTPUT_DIR="filtered_logs"

EVENTS=(
    "ListUsers" "ListRoles" "ListPolicies" "GetUserPolicy" "GetRolePolicy"
    "GetPolicy" "GetPolicyVersion" "InvokeFunction" "AttachUserPolicy"
    "UpdateFunctionConfiguration"
)

containsElement() {
  local element
  for element in "${@:2}"; do [[ "$element" == "$1" ]] && return 0; done
  return 1
}

mkdir -p "$OUTPUT_DIR"

for dir in "${DIRS[@]}"; do
    for file in "$dir"/*.json; do
        matched_events=()
        
        for event in $(jq -r '.Records[].eventName' "$file" 2>/dev/null); do
            if containsElement "$event" "${EVENTS[@]}" && ! containsElement "$event" "${matched_events[@]}"; then
                matched_events+=("$event")
            fi
        done

        if [[ ${#matched_events[@]} -ne 0 ]]; then
            base_file_name=$(basename "$file")
            new_filename="${OUTPUT_DIR}/${base_file_name}_$(IFS=_; echo "${matched_events[*]}").json"
            cp "$file" "$new_filename"
            echo "Saved to: $new_filename"
        fi
    done
done
