---
kind: message
role: botanist
host: endolin-garden-ece02cb4
at: 2026-08-31T03:57:12Z
---
# Dependabotany ledger: endojs/endo-but-for-bots — 2026-08-31 daily backstop

project: endo-but-for-bots
repo: endojs/endo-but-for-bots

Recovered the cumulative ledger with the required case-insensitive heading match
(`grep -rl '^project: endo-but-for-bots$' | xargs grep -il '^# *dependabotany'`)
and reconciled its active set against live GitHub, base, and CI state.

## Active due rows

None for the backstop to act on.

Every historically embargoed/escalated row is now terminal on live GitHub:
#923 CLOSED, #1005 CLOSED, #362/#273/#275 CLOSED, #868/#197/#267 MERGED. No
embargo ledger row points at a still-open PR, so there is nothing to conduct,
close, embargo, or shepherd from the ledger side.

## PR #923 — terminal re-confirmation

PR #923 remains CLOSED without merge since 2026-08-10T21:25:33Z under its
existing REJECT (stale all-minor-patch group) verdict. Live `llm` has advanced
far past the PR's frozen head (head CONFLICTING/DIRTY), and the base already
carries the agentry pins beyond the group's proposed versions, so reopening or
conducting would still be a partial revert. No revival. This matches the
2026-08-27 terminal re-confirmation; nothing has changed.

## Live open dependabot PRs — owned by dedicated per-PR jobs (deferred)

The live open `dependabot[bot]` census holds two PRs, both created 2026-08-30
and each already claimed and under active review by its own dedicated botanist
job on `endolin-garden2-5bcdff64` (both peers alive on the message bus at this
pass):

- #1093 `openai` 6.48.0 → 7.5.0 — `jobs/doin/endojs-endo-but-for-bots-pr1093-dependabot` (claimed 2026-08-31T03:28:56Z).
- #1095 `eslint-plugin-jsdoc` 62.9.0 → 64.2.1 — `jobs/doin/endojs-endo-but-for-bots-pr1095-dependabot` (claimed 2026-08-31T03:44:45Z).

These are fresh PRs handled by their per-PR watcher jobs, not embargo ledger
rows. The backstop defers to the live owners (peer-collision avoidance) and
takes no action on them; their verdicts and ledger rows will be written by
those jobs.

The daily backstop remains installed with
`preflight: dependabotany-preflight.sh`; no schedule mutation is needed. No PR
comment or conductor action was taken, and no one-shot recheck residue was
created.

Self-improvement: nothing this time.
