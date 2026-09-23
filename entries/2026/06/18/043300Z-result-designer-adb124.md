---
ts: 2026-06-18T04:33:00Z
kind: result
role: designer
host: endolinbot
repo: endojs/endo-but-for-bots
project: endo-but-for-bots
to: "*"
short_id: adb124
prs:
  - { repo: endojs/endo-but-for-bots, pr: 463, role: new }
refs:
  - entries/2026/06/18/034256Z-dispatch-designer-adb124.md
  - entries/2026/06/18/041600Z-result-designer-adb124.md
---

# result: designer — PR #463 AWS Marketplace publishing path

PR #463 DRAFT, base llm, head
design/gateway-aws-marketplace-publishing-path. Single file
`designs/gateway-aws-marketplace-publishing-path.md` (493
lines). Researcher precedence skipped per scout 4ed554 +
scholar 302d34 reports as effective research walk.

## Headline sequencing

- **O1.a (0-3 mo)**: single AMI listing. Gateway phases
  2-11 → master, M6 P1 (MCP), three blocker-gap designs +
  impls, Packer AMI build, GitHub OAuth adapter, AWS
  scanner pass, 2-4 week review.
- **O1.b (3-5 mo)**: Azure VHD + GCP GCE in parallel
  (same `.deb` substrate, per-cloud PaymentProcessor
  adapters, G-state-custody + G-observability).
- **O1.c (5-8 mo)**: TUF signed-update channel (G-upgrade).
- **O2 (8+ mo)**: Capability Hub SaaS listings.

## Gating-gaps reconciliation

All THREE resequencing-draft gaps are AWS-submission
blockers: `gateway-resource-classes` (MeterUsage lock at
publication), `gateway-first-boot-ceremony` (AWS forbids
hardcoded secrets), `gateway-bundled-tls`.

Of PR #400's four gaps, only `gateway-resource-classes` is
a marketplace blocker; `gateway-oauth-bonding`,
`gateway-key-recovery`, `gateway-stripe-adapter` ship as
v1.1 (MCP MVP runs on bearer-token auth; AMI bills via
MeterUsage NOT Stripe). `gateway-marketplace-listing` is
subsumed by THIS design.

## Five decisions designer took stances on

1. **Single-AMI at launch**, AMI+CFT as graduation
   (ratifies scout).
2. **Custom Metering at launch** (not Paid Hourly). Four
   dimensions: `computrons`, `cogitrons`, `bytes_stored`,
   `bytes_network` (all ≤15 char alphanumeric).
3. **GitHub as first service adapter** (pre-positions v11
   §3.2; faster OAuth client registration than Gmail).
4. **Commercial-entity seller identity** distinct from
   maintainer's personal identity (hard submission
   blocker).
5. **Accept non-custodian-spirit contradiction** for
   vendor-delegated DNS (publisher runs DNS provisioning
   for every issued node's lifetime; bring-your-own-domain
   mode is v1.1+ opt-in).

## Twelve open questions

7 from scout's report (companion-scholar gap now resolved)
plus 5 additional:
8. First-boot bearer delivery channel (recommend AWS
   instance console output).
9. Limited-state validation duration (recommend 7 days).
10. Continuous-compliance re-submission cadence (recommend
    12 months).
11. APN enrollment timing.
12. AMI architecture: ARM64-only at O1.a vs both at launch.

Dispatch root torn down.
