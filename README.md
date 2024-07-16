To list groups and their permissions across multiple projects in your Google Cloud Platform (GCP) account, you can use a combination of gcloud commands and IAM policy bindings. Below is a step-by-step guide to achieve this.

Steps
List all projects:
First, list all projects you have access to:

sh
Copy code
gcloud projects list --format="value(projectId)"
Get IAM policy for each project:
For each project, retrieve the IAM policy which includes roles and their members:

sh
Copy code
for project in $(gcloud projects list --format="value(projectId)"); do
    echo "Project: $project"
    gcloud projects get-iam-policy $project --format=json > ${project}_iam_policy.json
done
Extract groups and their roles:
Parse the IAM policy to extract group emails and their associated roles. You can use a script to automate this.

Example Script
Here’s an example Bash script to list groups and their permissions for each project:

sh
Copy code
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
Explanation
gcloud projects list --format="value(projectId)": Lists all project IDs you have access to.
gcloud projects get-iam-policy $project --format=json: Retrieves the IAM policy for the specified project in JSON format.
jq: A lightweight and flexible command-line JSON processor. The script uses jq to filter and extract groups and their roles from the IAM policy.
Requirements
gcloud: Ensure the Google Cloud SDK is installed and configured on your system.
jq: Install jq for parsing JSON. You can install it using your package manager, for example, sudo apt-get install jq on Debian-based systems.
Running the Script
Save the script to a file, for example, list-gcp-groups.sh, give it execute permissions, and run it:

sh
Copy code
chmod +x list-gcp-groups.sh
./list-gcp-groups.sh
Output
The output will be a list of projects with the groups and their corresponding roles, formatted in JSON for readability:

json
Copy code
Project: my-first-project
[
  {
    "group": "group:admins@example.com",
    "role": "roles/owner"
  },
  {
    "group": "group:developers@example.com",
    "role": "roles/editor"
  }
]
Project: another-project-123
[
  {
    "group": "group:admins@example.com",
    "role": "roles/owner"
  },
  {
    "group": "group:viewers@example.com",
    "role": "roles/viewer"
  }
]
This approach ensures you get a detailed list of groups and their permissions across all your GCP projects.