from_host: endolin-garden-ece02cb4
from: gauntlet:kriscendobot-minion.town-pr180-gauntlet-review-budget-reached
msg_key: kriscendobot-minion.town-pr180-gauntlet-review-budget-reached
notice_count: 1
first_seen: 2026-10-17T04:55:56Z
last_seen: 2026-10-17T04:55:56Z
sent_at: 2026-10-17T04:55:56Z
---
Gauntlet kriscendobot-minion.town-pr180-gauntlet REVIEW-BUDGET-REACHED: Applied 16 panel/fix round(s); fix round 16 completed with its changes pushed and CI green. The subjective review did not converge within max_iterations=16, so the PR is left improved for a human merge/review decision. To grant more rounds: scripts/jobs/gauntlet.sh --resume-from-stage kriscendobot-minion.town-pr180-gauntlet panel --add-rounds N

**Unaddressed must-fix: 20** · verdict: moving target · rounds spent: 16/16 · cost so far: $34.65
Trend: r1 raised 20; r2 n/a; r3 raised 20; r4 raised 2 (fixed 20, carried 0); r5 raised 0 (fixed 2, carried 0); r6 n/a; r7 n/a; r8 n/a; r9 n/a; r10 n/a; r11 n/a; r12 n/a; r13 raised 14; r14 n/a; r15 n/a; r16 raised 20
Classes: 0 persistent, 20 new in last round, 0 addressed-then-reintroduced
```text
[new, since r16] breaker: should-fix: A read-only holder can lock the readwrite holder out of minting. proposed-rule: a per-resource cap t...
[new, since r16] breaker: Invariant: the mint cap (maxTokensPerPartition) exists so a holder looping over mint cannot grow the sidecar unbo...
[new, since r16] breaker: Attack: hand a readOnly() facet to a lesser party. That party calls mintUrl 256 times and fills partition-store....
[new, since r16] breaker: Why the readwrite holder cannot recover: revoking needs the tokenHash, and /mint returns it only to the minter. N...
[new, since r16] breaker: So an attenuated capability can deny the stronger one a function the attenuation was meant to leave intact.
[new, since r16] breaker: Fix: a lower cap for read bindings, a separate read-binding budget, or a readwrite-only "revoke all read" or list route.
[new, since r16] breaker: The same pattern holds in miniature for createCapped: the per-owner cap is a lifetime quota with no delete route. A...
[new, since r16] breaker: should-fix: The /hello proof is not bound to the channel, so a relaying squatter would pass it. proposed-rule:...
[new, since r16] breaker: Invariant: control.ts and control-keys.ts claim the proof "authenticates the listener without revealing anything" a...
[new, since r16] breaker: Attack: any process able to answer a caplet request, for example at a different loopback alias or after the real list...
[new, since r16] breaker: This needs a path to the real listener, so it is low likelihood.
[new, since r16] breaker: Cheap hardening: include the origin or port in the proof input. Otherwise state the limit in the control.ts header.
… and 8 more
```
Severity: this list is every request-changes seat bullet. The panel blocks only on real defects (wrong behavior, security or authority errors, data loss, broken contracts, failing or missing tests for changed behavior, comments false enough to invite an unsafe change); comment or JSDoc wording, identifier spelling or style, commit-history tidiness, PR-description completeness, and test-style items are should-fix and never block (skills/panel/SKILL.md § Finding severity).

To add budget and resume: scripts/jobs/gauntlet.sh --resume-from-stage kriscendobot-minion.town-pr180-gauntlet panel --add-rounds 2
--add-rounds 2 grants 2 more panel/fix round(s): max_iterations 16 -> 18 (N is yours to choose).
