Inbox empty, cleanup done. Work complete.

---

## Completion report — `design-synth-and-deploy-minion-town-aws`

**Deliverable:** a design doc carrying the minion.town CDK scaffold to a live AWS deploy *on paper*, with every maintainer decision enumerated. Design-only — **no AWS call, no `cdk` invocation, no provisioning** was made.

**What I did**
- Cloned `kriscendobot/minion.town`, read the existing scaffold (`infra/` CDK stack, `Dockerfile`, `infra/README.md`) and the existing design doc (`designs/mcp-oauth.md`) to ground the work and avoid duplicating its §9 *architecture* open questions.
- Authored `designs/aws-synth-and-deploy.md` (the runbook), covering exactly what the job asked:
  - **Phases 0–4:** `cdk synth` clean (with the specific L2 prop-drift fixes the scaffold likely needs — `DockerImageAsset` top-level import vs the inline `require`, `apprunner-alpha` `Source.fromAsset` prop shape, App Runner↔ECR access role, `HostedZone.fromLookup` env requirement) → `cdk bootstrap` → first deploy (App Runner default URL, scope-enforcing) → `service.addCustomDomain` apex alias + ACM (flagging the two-pass validation reality) → end-to-end PKCE verification against the **deployed Cognito issuer**.
  - **Sequencing vs `cognito-mcp-metadata-bridge`:** bare-JWT deploy first (signature/issuer/scopes work out of the box, audience check relaxed); full RFC 8707/8414 compliance + DCR follow the bridge — with a capability table showing what works before the bridge lands and why "deploy-first, comply-second" is correct.
  - **Cost & teardown posture** so the spend questions are concrete.
  - **§7 "Open questions for the maintainer"** — 8 inline-answerable questions covering account/org+region, spend ceiling + authorizer + budget alarm, `minion.town` registration ownership + Route53 zone/delegation, Cognito pool posture (test-vs-persistent, region, `removalPolicy`), deploy identity + where credentials live (no keys in repo), staging-vs-prod, teardown/lifecycle owner, plus the IdP carry-over pointer to `mcp-oauth.md` §9.
- Cross-linked the new runbook from `README.md` and `infra/README.md`.

**What changed** — branch `design/aws-synth-and-deploy-runbook` (commit `e261263`), pushed to `kriscendobot/minion.town`; opened **PR #1**: https://github.com/kriscendobot/minion.town/pull/1 (1 new file + 2 cross-ref edits). Committed/pushed as the `kriscendobot` bot identity (gh active account, repo owner). Temp clone removed.

**Follow-ups**
- The deploy job `synth-and-deploy-minion-town-aws` stays parked in `jobs/plan/` and should only be promoted once the maintainer answers PR #1 §7 (account, spend ceiling, domain, deploy identity are the hard gates).
- Phase 0 (`cdk synth` clean + `tsc --noEmit`) is local and free and could be run now to confirm the predicted L2 fixes ahead of any provisioning — a candidate cheap next job if desired.
