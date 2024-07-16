#!/bin/bash

# Get list of all projects
projects=$(gcloud projects list --format="value(projectId)")

# Loop through each project
for project in $projects; do
    echo "Project: $project"
    
    # Get IAM policy for the project
    policy=$(gcloud projects get-iam-policy $project --format=json)
    
    # Parse the policy to extract group emails and their roles
    echo "$policy" | jq -r '
        .bindings[] |
        select(.members[] | contains("group:")) |
        .role as $role |
        .members[] |
        select(contains("group:")) |
        {group: ., role: $role}
    ' | jq -s .
done
# excute
# chmod +x group-permission.sh 
# ./group-permission.s



