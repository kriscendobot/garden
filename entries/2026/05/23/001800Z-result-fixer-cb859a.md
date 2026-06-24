---
ts: 2026-05-23T00:18:00Z
kind: result
role: fixer
project: endo-but-for-bots
host: endolinbot
slot: 3
refs:
  - entries/2026/05/23/001301Z-dispatch-general-contractor-cb859a.md
  - entries/2026/05/23/001000Z-result-solicitor-f4fcd9.md
prs:
  - repo: endojs/endo-but-for-bots
    pr: 356
    role: target
---

# Result: fixer cb859a — addressed 7 must-fix + 18 summary-fix on PR #356

PR `endojs/endo-but-for-bots#356`. One commit (30d13d963) on branch
`design/gateway-packaging-aws-stack`, pushed to origin. Design-only
PR; no source code touched; no CI to drive.

## Must-fix-loop items addressed (7)

1. **Feature 1 decomplecting (gateway-package.md).** Rewrote § Feature
   1 as three sub-features: 1a (Chat hosting), 1b (resource ledger,
   deferred), 1c (payment adapter, deferred). The `ResourceLedger`
   exo is removed from the Capability Surface until a follow-up
   design settles the gateway-vs-daemon trust boundary for metering.
   Phase 2 and 4 of the package's roadmap updated accordingly.
   Design Decision 8 rewritten to record the deferral rather than
   the original "ledger lives in the gateway" claim.

2. **Nitro Enclave key custody (gateway-aws-attuned.md).** Settled
   the ephemeral-vs-durable confusion by naming two distinct keys:
   a durable signing key stored in AWS KMS with attestation-gated
   release, and a per-instance ephemeral KMS-handshake key used
   only to wrap the KMS-returned durable-key material in transit.
   The durable key backs bearer tokens and survives EC2 rotation.
   Rotation flow rewritten around KMS key versions with a grace
   period during which both versions verify.

3. **Multi-user virtual-host allocation race (gateway-package.md
   Feature 2).** Pinned two deployment profiles. First-bind-wins is
   acceptable only on mutually-trusting deployments;
   mutually-distrusting multi-user deployments require the
   `authenticated-allocation` sub-mode (operator-pinned namespace
   per user). The AWS-attuned DNS-namespace resolution is named as
   the AWS-only solution; the non-AWS multi-user case uses the
   new `authenticated-allocation` profile.

4. **Dual-accept Git auth (gateway-package.md Feature 3).** Picked
   HTTP Basic as the primary scheme; HTTP Bearer is a tolerated
   fallback recognized but not advertised. The gateway logs a
   single info line per Bearer session; a future tightening that
   removes Bearer is non-breaking.

5. **Novice bridge paragraph (gateway-package.md).** Added the
   bridge paragraph between "five deployment shapes" and "extract
   the daemon's web-server-node.js" so a new reader follows the
   thread without prior knowledge of the daemon's `@apps` formula.

6. **Novice bridge paragraph (gateway-aws-attuned.md).** Added the
   "what changes from the deployment-only design" preamble before
   the five-row contrast table, so a reader landing on this design
   directly can read it as a standalone framing.

7. **(Implicit second Feature 1 framing from decomplector.)** Item 1
   above also addresses the decomplector's parallel must-fix on
   Feature 1; the three-feature split is the standalone-surface
   resolution they asked for.

## Summary-fix items addressed (18)

All 18 bundled into the same commit:

- Feature 9 acknowledges Feature 2 interaction (X-Forwarded-Host
  trust under multi-user routing).
- Feature 4 UDS bootstrap clarifies proof-of-possession authenticates
  the registering key, not the `relayTarget` capability.
- Signing-model asymmetry rationale (sigstore-keyless Docker vs.
  GPG-secret apt/yum is structural to per-ecosystem tooling, not a
  design choice).
- DynamoDB single-table § Design Decisions 3 acknowledges the
  physical-vs-logical schema trade-off.
- Per-feature toggles: named profiles (`developer`, `system-service`,
  `familiar-bundled`, `public-relay`) layered over the 10-flag
  matrix.
- Capability Surface reconciles `GatewayBootstrap.getApps` (admin-tool
  convenience) vs. `E(agent).lookup('@apps')` (canonical user path).
- "What the package guarantees" invariant table added to
  gateway-packaging-ci.md § Per-Distribution Conventions.
- Awkward parallel "shapes ... to support" recast on line 18.
- Antecedent ambiguity in the old Feature 1 "validated by" clause
  resolved by the Feature 1 rewrite (clause removed).
- AUR x86_64-only overstatement softened.
- "vs" -> "vs." in body text (two non-hyphenated occurrences).
- `${aws:PrincipalTag/tenant-id}` IAM variable explained as a
  policy-evaluation-time expansion.
- Debian `|` alternates clarifier added.
- `cbor`, `np`, `cbors` defined inline at first use in Feature 8.
- Topic sentence added to gateway-packaging-ci.md § Build Topology's
  three-reasons list.
- "design names X" verb varied to "records X" / "picks X" where
  repetitive.
- gateway-aws-deployment.md NAT cost-reduction bullet reframed:
  S3 VPC Gateway Endpoints are AWS-attuned-relevant, not
  pre-attunement.
- Per-doc `Updated` metadata bumped to 2026-05-23; designs/README.md
  summary-table rows synced.

## Items not touched

- Three `follow-up`-disposition items (cross-doc phase map, deploy-repo
  identity story, WebletFormula.s3Mode rename) untouched per dispatch
  brief.
- Three `acknowledge`-disposition items untouched per brief.
- Heading-case consistency sweep: H2 is uniformly Title Case across
  the four files; H3 is mostly sentence case (the AWS-* docs) with
  gateway-package.md Feature N descriptors mixed. Did not normalize
  the whole raft; would risk renaming many headings without panel
  re-run to validate.

## Submission

- Commit: 30d13d963 on `design/gateway-packaging-aws-stack`.
- Pushed to `origin/design/gateway-packaging-aws-stack`.
- No PR comments posted (dispatch did not authorize a top-level
  summary post). The orchestrator's next dispatch (re-solicitor on
  the new SHA) is the natural venue.

Self-improvement: nothing this time.
