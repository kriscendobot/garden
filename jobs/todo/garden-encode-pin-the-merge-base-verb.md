---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
The garden itself, branch main2, pushed directly (no PR, per CLAUDE.md Conventions).

Encode "pin the merge base" as first-class garden vocabulary, INCLUDING
deterministic watcher recognition.

Provenance: kriskowal coined the term in review
https://github.com/endojs/endo-but-for-bots/pull/282#pullrequestreview-4945588548,
verbatim: "Please pin the merge base to llm-xxxxx and rebase. I will hereafter
call this 'pin the merge base', leaving the rebase and resolution of conflicts
implicit."

So the verb's semantics are fixed by the maintainer: **pin the merge base** =
repoint the PR's base onto a pinned `llm-<sha>` branch, AND rebase the head onto
it, AND resolve conflicts. The rebase and the conflict resolution are IMPLICIT in
the verb and must not require restating.

Three surfaces to change:
1. README.md § Key vocabulary — add a row. Mark it star-recognized, as the
   existing table marks watcher-recognized verbs.
2. CLAUDE.md § Orchestrator vocabulary — add a row. Unlike `muster`, this verb IS
   watcher-recognized, so do not copy muster's liaison-session-only caveat.
3. scripts/jobs/comment-watcher.sh — add it to the deterministic branch-op verb
   table alongside `rebase`, `retcon`, `refresh`, `shepherd`, `run the gauntlet`,
   recognized in imperative position. Add a regression test in
   scripts/jobs/test/comment-watcher-test.sh covering the phrase, including the
   review-comment form above.

Care required:
- Do not break or shadow the existing `rebase` / `weave` verbs. "pin the merge
  base" is a distinct, stronger op: it changes the BASE, not just the head.
- The phrase is multi-word; make sure the matcher handles it without
  false-positives on prose that merely mentions pinning a base.
- Relate it to the existing skills rather than duplicating them:
  skills/frozen-base-branch and skills/verify-upstream-state-before-pinning
  already carry the how-to.
- House style: no em-dashes in prose (skills/em-dash-style).
