---
kind: message
role: botanist
host: endolin-garden-ece02cb4
at: 2026-08-13T16:37:15Z
---
project: endo-but-for-bots
repo: endojs/endo-but-for-bots

# Dependabotany ledger: endojs/endo-but-for-bots — 2026-08-13 daily backstop sweep (clean confirmation)

Daily backstop job `dependabotany-recheck-endo-but-for-bots-20260813-163502`
(dispatched 16:35Z). Recovered the cumulative ledger with the required
case-insensitive heading match
(`grep -rl '^project: endo-but-for-bots$' entries/ | xargs grep -il '^# *dependabotany'`)
and reconciled every row against live GitHub, base-ref, advisory, and CI state at
2026-08-13T16:3xZ. **No open Dependabot PR remains and no ledger row is due**; the
tick is a clean confirmation, not a disposition.

## The open Dependabot set is empty (re-verified live)

`gh pr list --repo endojs/endo-but-for-bots --author app/dependabot --state open`
returns `[]`. The 2026-08-12 sweeps had already conducted and verified merged all
seven approval-held MERGE-NOW rows; re-verified terminal this tick via
`gh pr list --state all`:

- #867 `@noble/curves` → 2.2.0 — MERGED 2026-08-12T14:27:44Z
- #868 `eslint-plugin-unicorn` → 72.0.0 — MERGED 2026-08-12 (rebased head, conducted)
- #912 `actions/setup-node` → v7.0.0 — MERGED 2026-08-12T14:27:35Z
- #913 `dorny/paths-filter` → v4.0.2 — MERGED 2026-08-12T14:27:05Z
- #914 `actions/cache` → v6.1.0 — MERGED 2026-08-12T14:27:13Z
- #915 `actions/setup-python` → v7.0.0 — MERGED 2026-08-12T14:27:20Z
- #916 `softprops/action-gh-release` → v3.0.2 — MERGED 2026-08-12T14:27:27Z

No new `dependabot[bot]` PR has been opened since. `gh pr list --state all` shows
the newest Dependabot PR by creation date is still #923 (created 2026-08-04); the
`all-minor-patch` group has not yet been regenerated after #923's close. When it is,
the dependabot-watcher auto-posts a fresh botanist job.

## PR #923 (named in the job spec) is terminally closed

#923 (`all-minor-patch` group, 36 updates) reached a terminal **REJECT (stale
group)** and was CLOSED 2026-08-10T21:25:33Z — the head fell ~127 commits behind
`llm` while base `llm` had advanced `@earendil-works/pi-agent-core`/`pi-ai` to
`^0.84.0` against the PR's `^0.82.1`, so a merge would have partially reverted both
manifests (ledger `2026/08/10/212613Z-message-gardener-db881f`). Live state confirms
CLOSED. Its precise one-shot fired at the maturity floor and self-deleted; nothing to
unwire. The close was **not** a defect finding against the upgrade.

## Schedule state

- Active daily backstop `dependabotany-recheck-endo-but-for-bots` remains in place as
  the project-wide safety net (this job is its dispatch; `last_dispatched`
  2026-08-13T16:35:02Z). Retained.
- No precise per-PR one-shot is outstanding in `schedules/`.
- Residue: inert **paused** files `dependabotany-recheck-endo-but-for-bots-pr868` and a
  paused copy of the backstop sit in `paused-schedules/` (the scheduler reads only
  `schedules/`, so neither can fire). #868 is now terminally MERGED, so the paused
  `-pr868` file is dead residue removable on a future journal-maintenance pass; left
  in place this tick to avoid a manual journal mutation, consistent with the
  2026-08-11/08-12 sweeps' decision.

The project's open Dependabot set and active ledger rows are both empty. No terminal
action was available or required at this tick.

Self-improvement: nothing this time.
