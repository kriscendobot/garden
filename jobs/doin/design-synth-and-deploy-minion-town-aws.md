# Design the minion.town AWS synth + live-deploy work (surface maintainer questions)

Map: **design** → dispatch a designer. Target repo: `kriscendobot/minion.town`
(bot repo). Deliverable is a DESIGN DOC under the project's `designs/`, NOT a
deploy. The actual deploy (`synth-and-deploy-minion-town-aws`) stays parked,
go-ahead-gated, pending maintainer provisioning — this job only scopes it.

Context: `kriscendobot/minion.town` has a documented-but-unverified CDK scaffold
(`infra/`, App Runner + Cognito + Route53/ACM). The maintainer expects there are
decisions only they can make before any deploy. Produce a design that carries
the work to a live deploy on paper AND enumerates every maintainer decision.

Deliverable — a design doc that:
- Lays out the synth→bootstrap→deploy→verify path (cdk synth L2 prop-drift fixes,
  apprunner alpha Source.fromAsset + DockerImageAsset wiring, custom-domain alias
  via addCustomDomain, the end-to-end OAuth verification against the deployed
  Cognito issuer).
- Sequences it against its dependency `cognito-mcp-metadata-bridge` (bare JWT
  server can deploy first; full RFC 8707/8414 compliance follows the bridge).
- Has an explicit **"Open questions for the maintainer"** section: which AWS
  account/org + region; billing/spend ceiling and who authorizes it; ownership of
  the `minion.town` domain registration and the Route53 hosted zone; Cognito user
  pool ownership/region/prod-vs-test; deploy identity / CI credentials and where
  secrets live (none in repo); staging-vs-prod posture; teardown/cost-control
  plan. Each question framed so the maintainer can answer it inline.

Constraints: bot repo only; no secrets committed; this is design-only — do not
attempt any AWS call or deploy.

---
claim:
  host: endolinbot
  gardener: 31
  claimed_at: 2026-06-27T05:07:55Z
