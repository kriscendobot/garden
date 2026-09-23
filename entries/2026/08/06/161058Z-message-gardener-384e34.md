---
kind: message
role: gardener
host: endolin-garden-ece02cb4
at: 2026-08-06T16:11:00Z
---
project: endo-but-for-bots
repo: endojs/endo-but-for-bots
prs:
  - https://github.com/endojs/endo-but-for-bots/pull/923

# Dependabotany ledger: endojs/endo-but-for-bots — 2026-08-06 daily backstop sweep

Daily backstop (job `dependabotany-recheck-endo-but-for-bots-20260806-160502`).
Recovered the cumulative ledger newest-first with the case-insensitive heading
match. Re-evaluated every open row against live GitHub state; **no row is
terminally due today**, so no merge/close/embargo verdict changed.

## The one embargoed row — PR #923 — HOLDS (floor not yet reached)

- Verdict: **EMBARGO-2026-08-10** (unchanged).
- Head `d2635dcead1f15a4e3909a0559c0b01f9bc04b76` — **byte-identical** to the
  2026-08-05 embargo head, so the 36-update moved set and the maturity floor do
  not reset.
- Maturity floor **2026-08-10T20:37:45.880Z** (freshest moved release
  `ws@8.21.2`, published 2026-08-03T20:37:45.880Z, +7d). Today 2026-08-06 is
  ~4 days short of the floor, so no MERGE-NOW is available and no re-enumeration
  is owed; the disposition is to hold.
- Not superseded: it is the sole open npm group / `ws` PR; no newer sibling.
- CI: 24/24 check-runs success at head.
- **Live observation for the 08-10 recheck:** the PR is now
  `mergeable=CONFLICTING / mergeStateStatus=DIRTY` — base `llm` advanced since
  the embargo. The PR is only ~2 days old, so Dependabot auto-rebase is still
  enabled and will likely regenerate the head before the floor; the 08-10
  one-shot recheck must therefore re-fetch and **re-enumerate the moved set**
  (a rebase can move the freshest-version instant and the floor with it) rather
  than trusting today's head.
- Recheck wiring verified present and correct: precise one-shot
  `schedules/dependabotany-recheck-endo-but-for-bots-pr923.md` fires
  **2026-08-10T21:15:00Z** (floor ceil-to-hour + 15m epsilon); daily backstop
  `schedules/dependabotany-recheck-endo-but-for-bots.md` active
  (`last_dispatched: 2026-08-06T16:05:02Z`, this dispatch).

## Held MERGE-NOW rows — re-attempted through the conductor's approval gate

Seven open dependabot PRs carry terminal **MERGE-NOW** verdicts from prior runs,
each blocked **solely** at the maintainer-approval gate. Re-ran the deterministic
gate (`handlers/pr-maintainer-approval-gh.sh`, the operative leg of the conductor
spine) on every one at its current head; **all seven still block** — no current
APPROVED review by a journal maintainer exists on any head. None conducts today;
they wait on a human approval, which is not a schedulable recheck.

- #867 `@noble/curves` 2.2.0 — head `057f7e26`. (kriskowal APPROVED exists but on
  the **stale** commit `5b7d79eb`, 2026-07-29; the head has since moved, so the
  gate correctly treats it as superseded.)
- #868 `eslint-plugin-unicorn` 72.0.0 — head `d48bde2f`.
- #912 `actions/setup-node` 7.0.0 — head `6cc9687c`.
- #913 `dorny/paths-filter` 4.0.2 — head `5879e463`.
- #914 `actions/cache` 6.1.0 — head `2a655a0d`.
- #915 `actions/setup-python` 7.0.0 — head `718c2971`.
- #916 `softprops/action-gh-release` 3.0.2 — head `352196b8`.

Rows retained (not terminal): the merges have not completed. On a maintainer
approval landing on a head, the next backstop/conductor pass merges and removes
that row.

## Schedule hygiene note

`paused-schedules/` still holds an inert stale duplicate of the daily
(`dependabotany-recheck-endo-but-for-bots.md`) and the moot #868 one-shot
(`dependabotany-recheck-endo-but-for-bots-pr868.md`, its PR now terminal MERGE-NOW).
Both are inert (the scheduler reads `schedules/`, not `paused-schedules/`); left
untouched. The active daily and #923 one-shot in `schedules/` are the live legs.

Self-improvement: nothing this time.
