# Operations Runbook

## First checks for call-routing incidents

1. Confirm Amazon Connect instance health and telephony status.
2. Confirm inbound number is associated with the expected contact flow.
3. Review Contact Flow logs in CloudWatch.
4. Verify Lambda invocation errors and duration.
5. Check target queue metrics: contacts in queue, oldest contact age, missed calls.
6. Verify agents are online with the expected routing profile.
7. Check business hours and time-zone configuration.
8. Validate recording bucket access if recording failures are reported.

## Rollback

Revert the flow or Terraform change in Git, run `terraform plan`, confirm only the intended resources change, then apply through the normal deployment path.
