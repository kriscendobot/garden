CI is green. Fix pushed successfully.

## Completion report

**Job:** Gauntlet FIX round 5 — endojs/endo-but-for-bots PR #1157 (design doc: `designs/npm-registry-indelible-guest-inventory.md`).

This is a docs-only design PR. I applied the six blocking (should-fix) items from the round-5 panel (critic ×2, skeptic ×2, novice ×2); the remaining items were comment-only/advisory.

**Changes (commit `4041fd590a`, pushed to PR head `design/npm-registry-indelible-guest-inventory`):**
- **critic-1:** Scoped § Migration to "The Node daemon runs…" (was "Both daemons run…"), resolving the contradiction with the parity section that stages Endor's inventory projection as deferred.
- **critic-2:** Named the minimal shape of the per-guest-root seating hook (an optional cancellation-wiring callback alongside the root override) in § Placement and name, so the escape-hatch claim in § Persistence no longer rests on an admittedly-unspecified API; updated that claim to reference the named hook.
- **skeptic-1:** Fixed the root-rotation "reconvergence path" claim — write-once means Phase 2's rewrite fills only an absent field and skips a seated guest, so reconvergence is a *fresh* guest formulation (the broken-root recovery path), not an in-place rewrite.
- **skeptic-2:** Added a test-catalog entry gating the seated root's aggregate origin-traffic bound (a lookup exceeding a size/concurrency/cancellation limit is refused/canceled at the root), and cross-referenced it from § Authority and attenuation so the "required property of the backend" is asserted by a test, not prose alone.
- **novice-1:** Signposted the two forward Phase-2 references at first use.
- **novice-2:** Pulled a one-sentence Endor description into the Summary, ahead of the Goals/Non-goals that reference it.

No forbidden code points introduced. **CI: GREEN** (5/5 checks, 0 failed; ci-wait-merge rc 0, `--no-merge`).

Per stage contract, I did not re-run the panel — the driver re-posts panel-6.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1157-gauntlet-fix-5.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 44 tokens (1262671 cached reads)
- Output: 9904 tokens
- Cost: $1.5014794999999999
- Wall-clock: 650s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
