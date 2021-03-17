# terraform-offboarding-alerts

This repository provisions an alert rule and action group resources which monitor for "disabled user" log entries in Azure Monitor. 
## Alert rule
Alert monitors hmcts-prod log analytics workspace at regular intervals by running a query against Auditlogs searching for "Disable Account".
## Action Group
Action Group points to Azure Devops using webhook endpoint. This enables us to create a service connection[userOffboardingWebhook] of type 'incoming webhook' in Azure Devops.
## Pipeline
https://github.com/hmcts/github-management/blob/main/azure-pipelines-offboard.yml

## Diagram
![FlowChart](images/offboarduser.png)
