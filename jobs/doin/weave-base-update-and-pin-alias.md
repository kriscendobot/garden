---
tier: minion
model-burned: mentor
fallback-tier: 
dispatch: automatic
---
Fold "pin the merge base" into `weave` as an alias, and correct weave's documented definition to state the base update it already performs.

Maintainer decision, liaison session 2026-08-16: weaving means **update the merge base to the current hash and rebase with conflict resolution**. The newly coined term "pin the merge base" is an ALIAS for weave, not a new verb and not a composition of two verbs. Do not add a third branch-op verb.

Provenance to quote: kriskowal, CHANGES_REQUESTED review on https://github.com/endojs/endo-but-for-bots/pull/282, 2026-08-16T06:28:34Z — "Please pin the merge base to llm-xxxxx and rebase. I will hereafter call this 'pin the merge base', leaving the rebase and resolution of conflicts implicit."

IMPORTANT — the behavior already exists; this is mostly a documentation correction. skills/frozen-base-branch/SKILL.md, cited from roles/weaver/AGENT.md § Skills, already specifies: every fork-side PR uses a frozen base named `<base>-<short-sha>`; when the weaver rebases it creates a NEW frozen base at upstream's current tip, rebases the head onto it, force-pushes the head, and updates the PR's `base` field, both refs moving together. Verify that is still true in the weaver's procedure before writing any docs, and if the implementation has drifted from it, fix the implementation to match rather than documenting the drift.

Work:
1. README.md § Key vocabulary — the `weave #N` row currently reads only "rebase and resolve conflicts", which understates it. Restate it as: update the merge base to the current base-branch hash (a new frozen `<base>-<short-sha>`), rebase the head onto it, resolve conflicts, force-push, and move the PR's base field. Add "pin the merge base" as an explicit alias on that row.
2. CLAUDE.md § Orchestrator vocabulary — same correction and alias in that verb table.
3. roles/weaver/AGENT.md — make the base update part of the role's stated purpose, not only an implication of a linked skill. A reader of the role brief alone should know weave moves the base.
4. scripts/jobs/comment-watcher.sh — recognize "pin the merge base" in IMPERATIVE position and map it to the SAME job the existing `weave`/`rebase` directives mint. It is a multi-word phrase, so take care with the machinery around BRANCH_OP_VERBS (line ~721) and the verb table (lines ~760-830): preserve the existing verb-as-subject-matter and future-tense guards, and make sure the phrase used as subject matter (someone describing this policy, as this job body does) mints nothing.

This is a tested hot path. Extend the comment-watcher tests: the imperative alias hit maps to weave; the subject-matter mention misses; no regression in existing single-verb recognition or distinct-imperative-verb counting.

Do not change what `rebase`, `retcon`, `shepherd` or `conduct` do. If `rebase #N` and `weave #N` should now be distinguished differently given weave's clarified definition, say so in your report as a recommendation; do not act on it in this job.

<!-- garden-reaped: 0 -->

<!-- garden-reap-now -->
---
claim:
  host: endolin-garden2-5bcdff64
  gardener: 1
  worker_kind: hermit
  tier: 
  provider: local
  model: 
  claimed_at: 2026-08-16T06:45:40Z
