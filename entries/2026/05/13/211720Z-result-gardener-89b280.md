---
ts: 2026-05-13T21:17:20Z
kind: result
role: gardener
refs:
  - entries/2026/05/13/210114Z-dispatch-liaison-4ab036.md
---

Added the base-branch outer-grouping sub-rule to `roles/journalist/AGENT.md` § Section layout: *Pending kriskowal reviews* now partitions rows into three outer groups (Endo master, Endo-but-for-bots llm, Remaining) by `baseRefName` + `repo`, with the existing milestone-bin + per-repo-fallback layout repeating inside each group. The within-bin topo sort note was extended to clarify that the outer grouping partitions before the sort, and a blocker in a different outer group has effective in-degree zero for the sort within its dependent's group. Empty outer groups omit; a fully empty section keeps the `(none)` body.

`baseRefName` was missing from `/tmp/garden-review-queue/current.json` at dispatch start, so the daemon was extended. The first attempt added `baseRefName` to `gh search prs --json`; gh rejected it as an unknown field (the GitHub search API does not expose the base ref). The fix fetches `baseRefName` per row via `gh api repos/<repo>/pulls/<n> --jq .base.ref`, caching by `(repo, number)` from the previous `current.json` so the steady-state cost is one REST call per ADD line, not per row. The skill's *State files* and *Procedure* sections were updated accordingly.

The daemon was respawned twice: once after the first commit (where it errored on every poll because `gh search` rejected the field), then again after the fix commit. The current `current.json` now carries `baseRefName` for every row; `endojs/endo` rows show `master`, `gibson-3046-narrow-rankcover`, and `markm-no-trapping-shim`, while `endojs/endo-but-for-bots` rows show `llm`, `master`, `kriskowal-random-chacha12`, and two `stack-ocapn-noise/*` branches. The new pid is in `/tmp/garden-review-queue.pid`.

Three commits on `main`:

- `7e579c0` — journalist: Pending kriskowal reviews outer-grouped by base branch (endo master, endo-but-for-bots llm, remaining)
- `801aa39` — review-queue-poll: include baseRefName in the canonical set (first attempt, broken on `gh search`)
- `e279244` — review-queue-poll: fetch baseRefName per-PR (gh search prs does not expose it)

All three are pushed to `origin/main` and the host main checkout at `/home/kris/` is fast-forwarded.

Self-improvement: nothing structural. The two-step push-then-fix sequence on the daemon was a verification gap, not a rule gap: I should have run the new daemon code once in a one-shot mode before committing it, but the daemon's design makes that awkward (it loops). A `--once` mode for the daemon would let a gardener test a daemon change end-to-end before pushing; logging this as a possible future skill-refinement note, not as a journal-message-worthy rule for liaison.
