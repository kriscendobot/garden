---
kind: message
role: gardener
host: endolin-garden2-5bcdff64
at: 2026-08-07T16:09:27Z
---
project: endo-but-for-bots
repo: endojs/endo-but-for-bots
prs:
  - https://github.com/endojs/endo-but-for-bots/pull/923
  - https://github.com/endojs/endo-but-for-bots/pull/867
  - https://github.com/endojs/endo-but-for-bots/pull/868
  - https://github.com/endojs/endo-but-for-bots/pull/912
  - https://github.com/endojs/endo-but-for-bots/pull/913
  - https://github.com/endojs/endo-but-for-bots/pull/914
  - https://github.com/endojs/endo-but-for-bots/pull/915
  - https://github.com/endojs/endo-but-for-bots/pull/916

# Dependabotany ledger: endojs/endo-but-for-bots — 2026-08-07 daily backstop sweep

Daily backstop (job `dependabotany-recheck-endo-but-for-bots-20260807-160502`).
Recovered the cumulative ledger newest-first with the case-insensitive heading
match. Re-evaluated every open row against live GitHub state; **no row is
terminally due today**, so no merge/close/embargo verdict changed. Open dependabot
PR set (`gh pr list --author app/dependabot --state open`) is exactly the eight
ledger'd rows below — no un-triaged new dependabot PR appeared.

## The one embargoed row — PR #923 — HOLDS (floor not yet reached)

- Verdict: **EMBARGO-2026-08-10** (unchanged).
- Head `d2635dcead1f15a4e3909a0559c0b01f9bc04b76` — **byte-identical** to the
  2026-08-05 embargo head and the 2026-08-06 sweep head, so the 36-update moved
  set and the maturity floor do not reset.
- Maturity floor **2026-08-10T20:37:45.880Z** (freshest moved release
  `ws@8.21.2`, published 2026-08-03T20:37:45.880Z, +7d). Today 2026-08-07 is
  ~3 days short of the floor, so no MERGE-NOW is available and no re-enumeration
  is owed; the disposition is to hold.
- Not superseded: it is the sole open npm group / `ws` PR; no newer sibling.
- **Still `mergeable=CONFLICTING / mergeStateStatus=DIRTY`** — the conflict noted
  on the 08-06 sweep persists and Dependabot has **not** yet auto-rebased the head
  (head unchanged since 08-05). The PR is ~3 days old, so auto-rebase remains
  enabled; the **08-10 one-shot recheck must re-fetch and re-enumerate the moved
  set** (a rebase can move the freshest-version instant and the floor with it)
  rather than trusting today's head.
- Recheck wiring verified present and correct: precise one-shot
  `schedules/dependabotany-recheck-endo-but-for-bots-pr923.md` fires
  **2026-08-10T21:15:00Z** (floor ceil-to-hour + 15m epsilon); daily backstop
  `schedules/dependabotany-recheck-endo-but-for-bots.md` active.

## Held MERGE-NOW rows — re-attempted through the deterministic approval gate

Seven open dependabot PRs carry terminal **MERGE-NOW** verdicts from prior runs,
each blocked **solely** at the maintainer-approval gate. Re-ran the deterministic
gate (`scripts/jobs/handlers/pr-maintainer-approval-gh.sh`, the operative leg of
the conductor spine) on every one at its current head; **all seven still block** —
no current APPROVED review by a journal maintainer exists on any head. None
conducts today; they wait on a human approval, which is not a schedulable recheck.
All heads are unchanged since the 08-06 sweep.

- #867 `@noble/curves` 2.2.0 — head `057f7e26`, now `mergeable=MERGEABLE/CLEAN`.
  (kriskowal APPROVED exists but on the **stale** commit `5b7d79eb`, 2026-07-29;
  the head has since moved, so the gate correctly treats it as superseded.)
- #868 `eslint-plugin-unicorn` 72.0.0 — head `d48bde2f`. **Now
  `mergeable=CONFLICTING/DIRTY`** (was MERGEABLE/CLEAN on 08-05): base `llm`
  advanced under its head, which carries the hand-authored fixer migration commit
  (`fractionGroupLength: 3`). When a maintainer approval lands this PR needs a
  conflict resolution (`next: weaver`) before the conduct; no action taken now
  because it is blocked on the human approval regardless, and a rebase now risks
  clobbering the migration commit (Dependabot auto-rebase still enabled at ~12
  days old). Flagged for the eventual approval/merge pass.
- #912 `actions/setup-node` 7.0.0 — head `6cc9687c`, `MERGEABLE/BLOCKED`.
- #913 `dorny/paths-filter` 4.0.2 — head `5879e463`, `MERGEABLE/BLOCKED`.
- #914 `actions/cache` 6.1.0 — head `2a655a0d`, `MERGEABLE/BLOCKED`.
- #915 `actions/setup-python` 7.0.0 — head `718c2971`, `MERGEABLE/BLOCKED`.
- #916 `softprops/action-gh-release` 3.0.2 — head `352196b8`, `MERGEABLE/CLEAN`.

Rows retained (not terminal): the merges have not completed. On a maintainer
approval landing on a head, the next backstop/conductor pass merges (after a
weave for #868) and removes that row.

## Terminal (closed) rows — no action

#918 (`@babel/types` 8.0.4, REJECT/CLOSED) and #919 (`eslint-plugin-jsdoc`
63.3.0, REJECT/CLOSED) remain terminal; not re-opened, no action.

Self-improvement: nothing this time.
