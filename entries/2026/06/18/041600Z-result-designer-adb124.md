---
ts: 2026-06-18T04:16:00Z
kind: result
role: designer
host: endolinbot
repo: endojs/endo-but-for-bots
project: endo
short_id: adb124
refs:
  - entries/2026/06/17/203500Z-result-scout-6224bd.md
  - entries/2026/06/17/204534Z-result-scholar-302d34.md
  - projects/endo/drafts/resequencing-2026-06.md
prs:
  - { repo: endojs/endo-but-for-bots, pr: 463, role: opened }
  - { repo: endojs/endo-but-for-bots, pr: 410, role: cited }
  - { repo: endojs/endo-but-for-bots, pr: 412, role: cited }
  - { repo: endojs/endo-but-for-bots, pr: 413, role: cited }
  - { repo: endojs/endo-but-for-bots, pr: 356, role: cited }
  - { repo: endojs/endo-but-for-bots, pr: 400, role: cited }
---

# result: designer adb124 — gateway-aws-marketplace-publishing-path

Landed `designs/gateway-aws-marketplace-publishing-path.md` as a DRAFT PR (#463) against `llm`.
The design is a sequencing-and-gaps document, not a packaging design: the OS substrate and AWS deployment topology already exist in flight as PRs #410, #412, #413, #356; the new design composes those with the resequencing draft's blocker gaps into a calendar-bound publishing path for the AWS Marketplace AMI listing.

## What landed

One file: `designs/gateway-aws-marketplace-publishing-path.md`, 493 lines, single commit on `design/gateway-aws-marketplace-publishing-path`.

Structure: Problem Statement -> Background -> Architectural Shape (mermaid) -> Sequenced Plan (Phase O1.a months 0-3 / O1.b months 3-5 / O1.c months 5-8 / O2 months 8+) -> MVP Single-AMI Artifact Composition (file list table, cloud-init hooks, four systemd units, G-tls-firstboot sketch) -> AWS Marketplace Submission Checklist (8-step sequence + fee table + customer onboarding flow) -> Cross-design Coordination (PR #400's four gaps + resequencing's three gaps, with blocker/follow-up disposition) -> Decision Points (5 stances) -> Open Questions for the maintainer (7 from scout + 5 additional) -> Dependencies + Affected Designs.

## Headline sequencing claim

- **O1.a (months 0-3): single AWS AMI listing.**
  Gateway phases 2-11 to master, M6 P1 (MCP termination), three blocker gaps designed and implemented, Packer AMI build, GitHub OAuth adapter, AWS scanner pass, 2-4 week marketplace review.
- **O1.b (months 3-5): Azure VHD + GCP GCE listings in parallel.**
  Same `.deb` substrate, per-cloud metering adapters behind `PaymentProcessor`, G-state-custody + G-observability designs.
- **O1.c (months 5-8): TUF signed-update channel.**
  G-upgrade design + on-node TUF client + vendor-side repository.
- **O2 (months 8+): Capability Hub** as SaaS listings alongside the per-cloud Bridge images.

## Three-gating-gaps reconciliation

Reconciled the three resequencing-draft blocker gaps against the four PR #400 gaps:

| Gap | Blocker for AWS submission? |
|---|---|
| `gateway-resource-classes` (G-resource-classes) | **Yes** (MeterUsage dimensions lock at publication) |
| `gateway-first-boot-ceremony` (G-firstboot) | **Yes** (AWS forbids hardcoded secrets) |
| `gateway-bundled-tls` (G-tls-firstboot) | **Yes** (gateway refuses TLS by design) |
| `gateway-oauth-bonding` | No (v1.1 follow-up) |
| `gateway-key-recovery` | No (depends on OAuth bonding) |
| `gateway-stripe-adapter` | No (different billing channel) |
| `gateway-marketplace-listing` (G-marketplace) | Subsumed by this design |

## Decisions the designer takes a stance on

1. **Single-AMI at launch, AMI+CFT as graduation.** Ratifies scout.
2. **Custom Metering at launch, not Paid Hourly.** Four conservative dimensions (`computrons`, `cogitrons`, `bytes_stored`, `bytes_network`; all within the 15-char limit).
3. **GitHub as first service adapter.** Pre-positions v11 §3.2 narrative.
4. **Commercial-entity seller identity, distinct from maintainer personal identity.** Hard blocker on submission.
5. **Accept the non-custodian-spirit contradiction for vendor-delegated DNS.** Bring-your-own-domain mode is a v1.1+ opt-in.

## Open questions surfaced

The 7 from the scout report carry forward, with this design's recommended answers attached.
Additional 5 surfaced during drafting:

8. First-boot bearer delivery channel (recommend AWS instance console output).
9. Limited-state validation duration (recommend 7 days).
10. Continuous-compliance re-submission cadence (recommend 12-month).
11. APN enrollment timing (recommend during O1.a regardless of commercial-entity timeline).
12. AMI architecture: ARM64-only vs both (recommend ARM64-only for O1.a, x86-64 as v1.1).

## Self-improvement

The dispatch prompt named this designer with the researcher-precedence step skipped because a scout + scholar pair had already shelved the directly-relevant material the day before, and the dispatch prompt explicitly directed me to treat their result entries as the inlined-refinement equivalent.
That shape worked cleanly: the scout's 7-question framing, AWS / Azure / GCP product-shape comparison, and recommendation table gave me a strong starting trellis; the scholar's fee-table + identity-bonding gap-fills supplied the AWS-fee numbers and the per-cloud metering shape comparison.
The design grew to 493 lines, one and a half screens longer than the role file's 1-3 screens target, but I judged the length necessary because the sequencing covers 8+ months and the cross-design reconciliation covers seven distinct gap files; splitting would have produced a fragmented set of siblings whose dependency graph would need its own design.
The role file's *Editorial-pass directives mean structural cut* norm did not apply (no editorial pass was directed); the design retains its sequencing, gap-reconciliation, and decision-point sections in full.

Single observation worth surfacing: when a scout + scholar pair has already shelved the substantive research within 24 hours of the designer dispatch, the researcher-precedence skip is the right shape; reading the scout's result entry directly is denser than re-summarizing it through a researcher dispatch.
The dispatch prompt's explicit "READ DIRECTLY as the inlined-refinement equivalent" framing made this discoverable.
Below the gardener-threshold for a hard rule; surfacing here as a note for future designer dispatches with adjacent scout / scholar output.

Self-improvement: nothing this time.
