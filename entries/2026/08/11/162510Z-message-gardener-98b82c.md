---
kind: message
role: gardener
host: endolin-garden-ece02cb4
at: 2026-08-11T16:25:12Z
---
project: endo-but-for-bots
repo: endojs/endo-but-for-bots
prs:
  - https://github.com/endojs/endo-but-for-bots/pull/867
  - https://github.com/endojs/endo-but-for-bots/pull/868
  - https://github.com/endojs/endo-but-for-bots/pull/912
  - https://github.com/endojs/endo-but-for-bots/pull/913
  - https://github.com/endojs/endo-but-for-bots/pull/914
  - https://github.com/endojs/endo-but-for-bots/pull/915
  - https://github.com/endojs/endo-but-for-bots/pull/916

# Dependabotany ledger: endojs/endo-but-for-bots — 2026-08-11 daily backstop sweep

Daily backstop job `dependabotany-recheck-endo-but-for-bots-20260811-162001`.
Recovered the cumulative ledger with the required case-insensitive heading match
and reconciled every open row against live GitHub, base-ref, advisory, and CI
state at 2026-08-11T16:24Z. No terminal disposition was available at this tick.

## PR #923 is CLOSED — the embargo row is retired

The job spec still names PR #923, but its precise one-shot
(`dependabotany-recheck-endo-but-for-bots-pr923`) already fired at its maturity
floor and reached a **terminal REJECT (stale group)** on 2026-08-10T21:25:33Z
(`#issuecomment-5246221502`; ledger `2026/08/10/212613Z-message-gardener-db881f`).
Live state confirms the PR is closed. The reject was **not** a defect finding: the
head fell 127 commits behind `llm` and `CONFLICTING/DIRTY`, and base `llm` had
advanced `@earendil-works/pi-agent-core` and `@earendil-works/pi-ai` to `^0.84.0`
while the PR still proposed `^0.82.1`, so a merge would have partially reverted
both manifests. Closing freed Dependabot to regenerate a fresh, non-reverting
`all-minor-patch` group; as of this sweep no replacement npm-group PR has been
opened yet (the dependabot-watcher will auto-post a fresh botanist job when one
appears). The one-shot self-deleted on fire; nothing to unwire.

## The open Dependabot set is exactly seven approval-held MERGE-NOW rows

`gh pr list --author app/dependabot --state open` returns exactly #867, #868,
#912, #913, #914, #915, #916 — no new sibling PR, and no npm group replacing
#923 yet. Every head is **unchanged** from the 2026-08-10 sweep, and every one
re-verified this tick:

- **CI terminal-green** at each head via `/commits/<sha>/check-runs` (25, 24, 26,
  23, 24, 23, 23 check-runs respectively; 0 pending / 0 failed), matching the
  prior sweep exactly.
- **No supersession by the base.** Each head is now 118–287 commits behind `llm`
  (the tell that a base census is load-bearing), so I re-censused the live base.
  Every target is still **ahead** of the base and a genuine forward update — none
  has been reached or passed by the base, so none flips to REJECT-superseded:
  - #912 `actions/setup-node` → v7.0.0: base at v6.2.0/v6.5.0, target unreached.
  - #913 `dorny/paths-filter` → v4.0.2: base at v4.0.1, target unreached.
  - #914 `actions/cache` → v6.1.0: base at v5.0.5, target unreached.
  - #915 `actions/setup-python` → v7.0.0: base at v6.2.0, target unreached.
  - #916 `softprops/action-gh-release` → v3.0.2: base at v3.0.1, target unreached.
  - #867 `@noble/curves` → 2.2.0 (npm): still `MERGEABLE/CLEAN`.
  - #868 `eslint-plugin-unicorn` → 72.0.0 (npm): still `CONFLICTING/DIRTY`; needs
    a weave after approval before it can be conducted.
- **Approval gate fails closed on all seven.** Ran
  `scripts/jobs/handlers/pr-maintainer-approval-gh.sh` (the conductor spine's
  deterministic maintainer-review gate) against every current head; each returned
  exit 1 — "no current APPROVED review on head". `reviewDecision` is empty and
  `autoMergeRequest=null` on all seven. No merge or auto-merge was issued.

These remain terminal MERGE-NOW rows awaiting a current maintainer approval;
approval is not a schedulable maturity recheck, so no one-shot is placed for them.
The daily backstop remains the standing verification surface.

## Recheck wiring

The per-project daily backstop schedule `dependabotany-recheck-endo-but-for-bots`
remains active (this job is its dispatch). PR #923's one-shot self-deleted on
fire; no other precise one-shot is outstanding (a stale **paused** #868 one-shot
from 2026-08-02 remains parked in `paused-schedules/` and correctly does not
fire — #868 is tracked by the daily backstop as a MERGE-NOW row). No schedule
change was needed.

Self-improvement: nothing this time.
