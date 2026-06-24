---
ts: 2026-05-22T02:58:48Z
kind: result
role: designer
project: endo-but-for-bots
refs:
  - entries/2026/05/22/024134Z-dispatch-liaison-9ecbfc.md
  - entries/2026/05/21/000222Z-result-designer-600eb4.md
---

# Result: designer drafts stacked sibling-design set on @endo/gateway package (#343)

## Deliverables

- **PR**: <https://github.com/endojs/endo-but-for-bots/pull/356> (DRAFT, base `llm`, head `design/gateway-packaging-aws-stack`).
- **Head SHA**: `64313361d6b75cbe467e4ed39095a07d56130341`.
- **Design files on `llm` (post-merge of #343 + #356)**:
  - `designs/gateway-packaging-ci.md` (Design 1, 470 lines).
  - `designs/gateway-aws-deployment.md` (Design 2, 510 lines).
  - `designs/gateway-aws-attuned.md` (Design 3, 460 lines).
- **`designs/README.md` synced**: 3 new rows in summary table, M1 milestone assignments with per-design size estimates, Remote Access subgraph extended with `gpkgci`, `gawsdep`, `gawsatt` nodes plus stacked edges (`gpkg → gpkgci → gawsdep → gawsatt` + `gpkg → gawsdep` direct edge), totals updated to 12 Proposed / 108 designs.
- **Branch base**: rooted at `origin/design/gateway-package` (PR #343's head) so the diff against `llm` shows both the parent design and the new stack. Rebases cleanly onto `llm` after #343 merges.

## Dependency edges declared

| Design | Depends on |
|--------|------------|
| `gateway-packaging-ci.md` | `gateway-package.md` |
| `gateway-aws-deployment.md` | `gateway-packaging-ci.md`, `gateway-package.md` |
| `gateway-aws-attuned.md` | `gateway-aws-deployment.md`, `gateway-package.md` |

## Design 3 decision

**Sibling design**, not folded into Design 2's Out-of-scope. The maintainer named five distinct AWS services (S3, EC2, Nitro Enclaves, Route53, sqlite analogue) to attune to; a single Out-of-scope bullet would have collapsed into a hand-wave. Each substitution is a substantial design decision (DynamoDB single-table schema, Nitro Enclave attestation-gated KMS key release, per-tenant Route53 + ACM custom-domain shape, S3 lifecycle policies with DynamoDB ref-counted dedup).

## Open questions from `gateway-package.md` newly addressed

| OQ | Status | Resolved by |
|----|--------|-------------|
| 1 (payment-token mechanism) | Still open | Deferred; orthogonal to AWS-attunement |
| 2 (public-relay abuse prevention) | Still open | Operator policy choice |
| 3 (virtual-host allocation across users) | **Partially resolved** | `gateway-aws-attuned.md` § Route53 — per-tenant subdomain reduces cross-user collisions to per-tenant first-bind-wins |
| 4 (formula-identifier bearer-token rotation) | **Mechanism resolved** | `gateway-aws-attuned.md` § Nitro Enclaves — Enclave-issued tokens with PCR-gated KMS key release; user-visible workflow (grace period vs. immediate cutover) still open |
| 5 (multi-tenant CAS isolation) | **Resolved** | `gateway-aws-attuned.md` § S3 — per-tenant prefix + DynamoDB reference-counted dedup-by-hash |
| 6 (package naming `@endo/gateway` vs `@endo/web-gateway`) | Still open | Maintainer pick |
| 7 (migration timing for in-daemon `web-server-node.js`) | Still open | Builder-level question |

## Open questions newly surfaced

From `gateway-packaging-ci.md`: keyring distribution for first contact (apt signed-by directive), GPG key long-term storage migration to Secrets Manager, graceful restart via systemd socket activation, per-distribution post-install systemd defaults uniformity, release cadence frequency, `nightly` channel security implications.

From `gateway-aws-deployment.md`: `/healthz` endpoint specification (ready vs. live), multi-region active-active building blocks, bastion vs. SSM Session Manager, sqlite backup strategy (EBS snapshot vs. WAL streaming), OIDC role permissions scope tightening, cost-control budget thresholds, AWS account credentials bootstrap.

From `gateway-aws-attuned.md`: operator-onboarding API shape (provisioning exo), per-tenant cost attribution, migrating self-hosted to AWS-attuned mode, per-tenant rate limits, Lambda/Fargate data-plane variant, compliance regimes (SOC 2 / GDPR / HIPAA).

## Phased-rollout / milestone placement

All three designs assigned to **M1** (Remote Access and Coding Capabilities), inheriting the parent design's milestone.

Per-design size estimates:

| Design | Size | Estimate |
|--------|------|----------|
| `gateway-packaging-ci` | M-L | 1.5-2 weeks (alongside `gateway-package` Phase 4) |
| `gateway-aws-deployment` | L | 3-4 weeks (downstream of `gateway-packaging-ci`) |
| `gateway-aws-attuned` | XL | 8-14 weeks (Nitro Enclave subsystem + multi-tenant operator-onboarding tool are each substantial pieces of work) |

Phase structure inside each design:

- **`gateway-packaging-ci`**: Phase A (deb + Docker) → Phase B (rpm) → Phase C (PKGBUILD) → Phase D (hosting moves from GitHub Pages to S3 + CloudFront, depends on Design 2).
- **`gateway-aws-deployment`**: Phase A (manual deploy) → Phase B (ASG + instance refresh) → Phase C (CloudWatch) → Phase D (Secrets Manager rotation) → Phase E (staging environment).
- **`gateway-aws-attuned`**: Phase A (storage seam in code) → Phase B (Nitro Enclave skeleton) → Phase C (Route53 per-tenant) → Phase D (CloudFront for public weblets) → Phase E (operator-onboarding tool).

## Self-improvement

`Self-improvement: nothing this time.` The dispatch brief named the parent design's open questions explicitly, so the new designs' resolutions could be cross-referenced precisely (rather than the designer guessing at what the parent had left unanswered). The em-dash sweep before commit caught a handful of em-dashes in `designs/README.md` additions that the prose style rule prohibits; running `git diff | grep '—'` on the staged hunk before commit was the right hygiene step and is already covered by the existing em-dash-style skill.
