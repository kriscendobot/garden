---
kind: result
role: prosecutor
host: endolin-garden-ece02cb4
at: 2026-07-10T20:42:14Z
---
refs: endojs/endo-but-for-bots#650:review:4673371396:retro
primary_job: endojs-endo-but-for-bots-pr650-review-d4abc76c
verdict: miss
category: naming
cluster: avoid-name-abbreviations

# Retrospective on #650 review 4673371396 — naming miss recorded, held below floor

Prosecutor second-loop on kriskowal's **APPROVAL** review `4673371396` of
`endojs/endo-but-for-bots` #650 (PR A of the #127 mount-revocation
reconstruction). Idempotency pre-check clean (no existing
`misses|dismissed/endojs-endo-but-for-bots-pr650-review-d4abc76c.md`).

**Enumerated the whole review (untrusted text treated as data):**
- Body: a rebase/retcon/conduct-onto-`llm` merge directive → **not a miss**
  (normal garden finalization chain; the primary job dispatched a conductor).
- One inline comment on the new `packages/daemon/test/mount-revocation.test.js`:
  spell out the abbreviation in `makeTempRoot` → `makeTemporaryRoot` → **a miss**.

**Verdict — naming miss.** Grounded in the PR's review history: the
mount-revocation gauntlet ran the 19-seat code panel including the always-on
`stylist` naming seat (which even edited this file), yet a plain, unambiguous
abbreviation (`Temp` for `Temporary`) reached the maintainer. Same pattern and
same seat-gap as the `dir`→`directory` miss already recorded on this PR
(`…-pr650-review-35ff43ca`); joined the `avoid-name-abbreviations` cluster.

**Threshold — held below floor, no dispatch.** Writer reported
`count=2 status=open prs=650 recurrence=0`. The cluster now holds two members but
both are on **PR #650**, so the floor (K≥3 across **≥2 distinct PRs**) is not met
— exactly the one-messy-PR-masquerading-as-systemic case the two-PR rule guards.
Severity bypass N/A: no garden seat/skill/gate encodes identifier-abbreviation
avoidance yet, so this is a prevention gap to be created, not a standing rule that
failed to bind, and the nit is `severity: minor`. Rationale recorded in the miss
body's threshold section. No recurrence to escalate. A future panelled
abbreviation miss on a **different** PR would trip the cluster for a
`review-improve-avoid-name-abbreviations` dispatch.

Self-improvement: nothing this time.
