# Architecture

## Design goals

The platform is organized around repeatability, separation of concerns, environment promotion, operational visibility, and controlled change management.

## Enterprise support routing model

The routing model separates general enterprise support, cloud platform support, and priority escalations. The inbound contact flow can invoke a customer-lookup Lambda, capture returned data as contact context, and use that context alongside caller input to route the contact to the appropriate queue.

## Component responsibilities

- `modules/connect` manages the Amazon Connect instance, hours of operation, queues, routing profile, Lambda association, recording storage configuration, and inbound contact flow.
- `modules/lambda` packages and deploys the customer-lookup function used by the contact flow.
- `modules/observability` provides supporting storage and a CloudWatch alarm for missed calls.
- `contact-flows` stores the contact-flow definition as a version-controlled Terraform template.
- `envs/dev` and `envs/prod` compose the reusable modules for each environment.

## Deployment model

Changes should move through source control, Terraform formatting and validation, plan review, environment testing, and controlled promotion. Production implementations should use remote state with locking, least-privilege deployment roles, short-lived credentials, and explicit approval controls.

## Production extensions

Common extensions include CRM- or DynamoDB-backed customer lookup, Amazon Lex integration, SSO/SAML for agents, Kinesis or EventBridge-based event processing, CloudWatch dashboards and SLOs, Contact Lens analytics, workforce-management integration, and policy-as-code checks in CI.
