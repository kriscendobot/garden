---
role: weaver
dispatch: automatic
tier: mentor
fallback-tier: minion
---

# Weave (rebase + resolve conflicts) endojs/endo-but-for-bots PR #1000

Rebase PR #1000 onto the live `llm` trunk and resolve the conflict.

The conductor (job `endojs-endo-but-for-bots-pr1000-conduct`) reached this PR
green + approved, but `safe-rebase.sh` REFUSED: rebasing the head
`fix/pin-node-24x-ci-teardown-crash` onto live `llm` (a59021f8ae3) produces a
NON-lockfile code conflict in `.github/workflows/ci.yml` — `llm` advanced its
own CI-matrix changes while this PR pins the Node 24.x matrix to 24.18.0. Only a
lockfile-only conflict is auto-recoverable; this needs a weave by hand.

Task: weave the head onto live `llm`, resolving `.github/workflows/ci.yml` so the
Node 24.x matrix pin (24.18.0, worker-teardown-crash fix) is preserved on top of
`llm`'s current CI config, then lease-push the rewritten head.

Note: the rebase makes kriskowal's 2026-08-17 approval (on old head
a5882399ca) STALE. After the weave, the PR needs a fresh maintainer approval on
the new head before it can be merged; do not merge from this job.

PR: https://github.com/endojs/endo-but-for-bots/pull/1000
Head: endojs/endo-but-for-bots fix/pin-node-24x-ci-teardown-crash (bot-pushable)
Base: llm (live trunk)

---
claim:
  host: endolin-garden-ece02cb4
  gardener: 2
  worker_kind: gardener
  tier: 
  provider: anthropic
  model: 
  claimed_at: 2026-08-17T04:55:42Z
