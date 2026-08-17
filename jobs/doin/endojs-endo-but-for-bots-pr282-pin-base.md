---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
handler-timeout: 3600

Repo: endojs/endo-but-for-bots
PR: https://github.com/endojs/endo-but-for-bots/pull/282 (endor dependency walk, Phase 5)

NARROW SCOPE, deliberately. This is the one outstanding half of maintainer review
https://github.com/endojs/endo-but-for-bots/pull/282#pullrequestreview-4945588548
("Please pin the merge base to llm-xxxxx and rebase"). The RECONCILE half is
already done and pushed: sibling weave 04f03efe98 landed the flag-gated dispatch
(registry-cache resolver as the default, node_modules walker behind
`--node-modules`), and commit 86745db2b0 updated designs/endor-run-expanded.md to
match. Do NOT redo that work.

What is left: the base is still `llm`. It was never repointed to a pinned
`llm-<sha>` branch. Task:
1. Follow skills/verify-upstream-state-before-pinning before choosing the sha, so
   the pin is against a verified upstream state rather than an assumed one.
2. Create the pinned base branch in the repo's existing convention (see the live
   set: llm-da209e5, llm-e9564f0, llm-eb64412, etc. — short-sha suffix), per
   skills/frozen-base-branch.
3. Retarget https://github.com/endojs/endo-but-for-bots/pull/282 onto it and
   rebase the head onto that base, resolving any conflicts by honoring both sides
   (never `--ours`/`--theirs`).
4. Confirm CI stays green. The PR was 26/26 green at head 09e5736da before this
   change, so a red result after the rebase is a regression you introduced, not a
   pre-existing condition.

DO NOT merge and do not un-block the review: the maintainer's CHANGES_REQUESTED
stands and only they can clear it. Report the new base branch name, the new head
sha, and the CI result.

Note for whoever claims this: a PRIOR job on this same work
(`endojs-endo-but-for-bots-pr282-pin-rebase-reconcile`) was doomed with signature
`elapsed-constancy` after 4 requeue cycles, failing fast at a near-constant
elapsed time far below its 7200s budget. That job is parked in jobs/plan/ and is
NOT to be promoted. If you hit a fast deterministic failure too, STOP and report
the failure mode with evidence rather than retrying: that reproduction is more
valuable than the pin.

<!-- garden-reap-now -->
---
claim:
  host: endolin-garden2-5bcdff64
  gardener: 1
  worker_kind: cleric
  tier: 
  provider: openai
  model: 
  claimed_at: 2026-08-17T04:14:36Z
