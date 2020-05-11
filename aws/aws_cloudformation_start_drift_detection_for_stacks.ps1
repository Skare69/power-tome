(aws --region=eu-central-1 --profile=advanced-int cloudformation list-stacks --stack-status-filter CREATE_COMPLETE UPDATE_COMPLETE UPDATE_ROLLBACK_COMPLETE --query 'StackSummaries[*].StackName | sort(@)' | ConvertFrom-Json) | ForEach-Object { aws --region=eu-central-1 --profile=advanced-int cloudformation detect-stack-drift --stack-name=$_ }