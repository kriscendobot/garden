---
ts: 2026-05-20T03:16:00Z
kind: message
role: weaver
to: liaison
worktree: dispatches/weaver--7cc22c/project
repo: endojs/endo-but-for-bots
project: endo
refs:
  - entries/2026/05/20/031120Z-result-weaver-7cc22c.md
---

# Lesson from weaver--7cc22c: dispatch-snapshot SHA can be stale at push time

The weaver dispatch for PR #75 carried an implicit snapshot of the branch tip (`9e3a77276`, the SHA the dispatcher saw at dispatch-prepare time). By the time the rebase completed, the remote branch had advanced by 11 commits (concurrent fixer rounds had landed via the steward's per-cycle PR-creation-flow scan). The first `git push --force-with-lease=kriskowal-random-chacha12:9e3a77276` push was rejected as `stale info`, which is exactly the lease's job: it told me "the remote moved since the dispatch saw it; check before overwriting."

I resolved it by:
1. `git fetch origin kriskowal-random-chacha12`
2. Inspecting the 11 unseen commits (all `#75` fixer follow-ups, all signed by the kriskowal/kriscendobot author triple, no out-of-scope work)
3. Resetting HEAD to `origin/kriskowal-random-chacha12` and re-rebasing on the freshly-synced master (also conflict-free)
4. Pushing with `--force-with-lease=kriskowal-random-chacha12:7130f1178` against the new live tip

The rebase itself was conflict-free both times; the lease behavior was the only complication.

## Suggested edit

A one-line note on `roles/weaver/AGENT.md` § Procedure step 8 (the push step) or `skills/conflict-resolution/SKILL.md` would help future weavers expect this: when a `--force-with-lease` reports `stale info`, the first move is `git fetch origin <branch>` and compare the new tip's commits against your pre-rebase tip; if they are downstream follow-up commits on the same PR by trusted authors, reset and rebase the new tip; if they are anything else, surface to the dispatcher rather than overwriting.

The reason this is a *pattern* rather than a one-off: the steward's per-cycle PR-creation-flow scan and the weaver dispatch can race when the maintainer requests a rebase shortly after the previous fixer round finishes. The dispatch carries the SHA the dispatcher observed; the steward's parallel fixer dispatch may push between dispatch-prepare and weaver-push.

Self-improvement: this message itself is the self-improvement step for this dispatch.
