# terraform-offboarding-alerts

This repository provisions an alert rule and action group resources which monitor for "disabled user" log entries in Azure Monitor. 
## Alert rule
Monitors hmcts-prod log analytics workspace at regular intervals by running a query against Auditlogs searching for "Disable Account".
## Action Group
Points to Azure Devops using webhook endpoint. We consume this with a service connection (called '[userOffboardingWebhook](https://dev.azure.com/hmcts/PlatformOperations/_settings/adminservices?resourceId=e60677d0-66c4-4337-869b-5f5ad503d7c8)') of type 'incoming webhook' in Azure Devops.
## Pipelines

Any pipeline with access to the service connection can consume this alert, the current pipelines are:
 - https://github.com/hmcts/github-management/blob/main/azure-pipelines-offboard.yml
 - https://github.com/hmcts/launchdarkly-terraform/blob/master/azure-pipelines-launchdarkly-offboard.yml

## Diagram

Shows the flow for offboarding users from GitHub, other flows are very similar:
![FlowChart](images/offboarduser.png)

[source file](https://github.com/hmcts/terraform-offboarding-alerts/images/offboarduser.xml), created with https://app.diagrams.net.
