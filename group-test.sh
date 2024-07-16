gcloud projects list --format="value(projectId)"


GROUP_EMAIL="xxxxxxxxxxxxx.com"

for project in $(gcloud projects list --format="value(projectId)"); do
    echo "Project: $project"
    gcloud projects get-iam-policy $project --flatten="bindings[].members" --filter="bindings.members:$GROUP_EMAIL" --format="table(bindings.role)"
done