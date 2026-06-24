---
ts: 2026-06-11T05:26:22Z
kind: result
role: designer
repo: endojs/endo-but-for-bots
project: endo
refs:
  - entries/2026/06/11/*dispatch-liaison-d4cf94.md
  - entries/2026/06/11/045739Z-result-scout-8f5fb7.md
---

# Result: Workstream A resequencing proposal (O1/O2)

Authored the resequencing DRAFT at
`journal/projects/endo/drafts/resequencing-2026-06.md` per brief Workstream A.
DRAFT for maintainer triage; no ledger edits applied (maintainer-gated per
brief §6), no project/ commit, no PR.

## Key resequencing moves

- **O1 critical path re-derived (§1).** The binding constraint to "deploy
  from a marketplace in one sitting" is the **packaging-and-listing track**
  (gateway phases 9/10/11a → bundled-TLS → AWS hosting → 2-4 week listing
  review), NOT MCP termination. P1 (MCP) parallelizes off phases 2/7/8 and is
  not on the longest chain. Confirmed scout correction 1 (P1 gated on phases
  2/7/8, not 10/11). Verified Feature 9 (phase 10) is proxy-*compatibility*,
  not TLS termination: the gateway refuses TLS by design, so a marketplace
  appliance needs a bundled-proxy + ACME first-boot story that the ledger
  does not name (new gap G-tls-firstboot).
- **P4 (OAuth + key recovery) reconciled (§1.4).** Brief co-prioritizes;
  ledger sequences last for churn-containment. Reconciled along the
  design/implementation seam: design P4 now (design-forward, brief §2),
  schedule implementation flexibly (ledger's intent). The brief-vs-ledger
  conflict is narrower than the scout framed it (implementation scheduling,
  not a flat contradiction).
- **O2 placed (§2).** Proposed a **dedicated M7 "Community Hub" milestone**
  inserted after M6, shifting current M7-M11 to M8-M12. Spine =
  `endo-gateway.md` Open Question 2 (virtual-users mode), the most precise
  ledger description of O2, which the brief did not cite. Dependency invariant
  preserved via a member-isolation slice that does not forward-reference M10's
  full capability bank.

## Gap inventory (15 design files across 12 problem areas)

1. G-oauth-bonding (M5) — bond OAuth identity to node public-key identity; uncovered.
2. G-key-recovery (M5) — bearer re-issue on OAuth proof; partial (OQ1, MCP rotate).
3. G-stripe-adapter (M5) — verifyPaymentProof Stripe verifier; partial (iface defined).
4. G-resource-classes (M5) — computron/cogitron/storage/network taxonomy; partial; cogitrons new vocab; unfolds from stripe-adapter per brief.
5. G-marketplace (M5) — AWS AMI hardening + listing; partial (docker-selfhost); AMI/listing undesigned.
6. G-tls-firstboot (M5) — bundled proxy + DNS-01 vendor-delegated ACME; uncovered (BEYOND seed list).
7. G-firstboot (M5) — out-of-band bearer bootstrap before any trust channel; uncovered.
8. G-state-custody (M5) — backup/restore/cloud-to-cloud migration; uncovered (substrate in CAS/checkin-checkout).
9. G-upgrade (M5) — TUF-shaped signed updates for headless gateway; uncovered (familiar-release is desktop + not on llm).
10. G-observability (M5) — metrics without surveillance; uncovered.
11. G-hub-invitation (O2/M7) — hub-membership invitation; partial (deep-link covers peer variant only).
12. G-multitenancy + G-hub-economics + G-abuse-moderation + G-operator-liability (O2/M7) — four files; member isolation slice, member-vs-operator billing, moderation-given-E2E-encryption, liability survey (Reference, survey-only).

Beyond the brief's 11 seed areas: split G-tls-firstboot out of packaging
(the gateway's no-TLS decision makes it a distinct seam), and split O2
multi-tenancy's one seed bullet into four design files.

## Open decisions for the maintainer (7, §5)

1. Is P4 (OAuth bonding impl) in O1's exit criterion, or bearer-token MVP + fast-follow?
2. Dedicated O2 milestone at M7, or O2 distributed across M5/M11?
3. Member-isolation slice split (preserve invariant, O2 follows O1) vs all isolation in M11.
4. Confirm gateway-resource-classes as its own design (reverses ledger hedge).
5. Stripe vs AWS MeterUsage billing channel for the marketplace AMI (dimension-name lock).
6. Operator-liability survey authored in O2 window to feed B4 essay; posture stays maintainer's call.
7. The three absent-from-llm references (PR #356 gateway designs, familiar-release): merge to llm or correct the ledger's status claims. The §1 critical path assumes the packaging-track designs land on llm; they currently do not.

## Canon discrepancies (all four scout-reported, verified at tip; no new ones)

Verified all four scout discrepancies against the ledger at tip 72d1c764c and
confirmed each. No discrepancies beyond the four. Directly confirmed
discrepancy 2 by listing project/designs/: only endo-gateway.md,
endo-gateway-mcp.md, gateway-bearer-token-auth.md exist; gateway-package,
gateway-packaging-ci, gateway-aws-deployment, gateway-aws-attuned,
familiar-release are NOT on llm (they live on PR #343/#356/#231 branches).
One framing refinement on discrepancy 4 (recorded in draft §0): the brief-vs-
ledger P4 conflict is about implementation scheduling, reconcilable along the
design/implementation seam, not a flat contradiction needing arbitration.

Ready-for-triage bulletin item recommended (liaison to post).

Self-improvement: nothing this time. Worked cleanly within the designer role's
draft-deliverable override; no recurring lesson warrants a role/skill change.
