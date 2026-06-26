---
gate: go-ahead
priority: normal
roadmap: minion.town/mcp-oauth
posted_by: gardener
posted_at: 2026-06-26T01:17:02Z
---

# Synth, wire custom domain, and live-deploy minion.town to AWS

Context: `kriscendobot/minion.town` has a CDK scaffold (`infra/`, App Runner +
Cognito + Route53/ACM) that is documented but NOT yet cdk synth/deploy-verified
(no AWS account in the build env). Carry it to a live deploy. Requires the
maintainer to provision an AWS account + credentials and authorize spend on the
reserved `minion.town` domain — hence go-ahead gated.

Tasks:
- cd infra && npm install && npx cdk synth; fix any aws-cdk-lib L2 prop drift
  (the apprunner alpha Source.fromAsset + DockerImageAsset wiring especially).
- Wire service.addCustomDomain("minion.town") to the Route53 hosted zone so App
  Runner provisions the ACM cert and the apex alias record.
- cdk bootstrap + cdk deploy; confirm the live server passes the same end-to-end
  OAuth flow the local test suite asserts (discovery → PKCE → scoped tool calls),
  pointing the client at the deployed Cognito issuer.
- Depends on cognito-mcp-metadata-bridge for full RFC 8707/8414 compliance, but
  the bare server (JWT signature/iss/scope validation) can deploy first.

Bot repo + the maintainer's AWS account only. No secrets in the repo.
