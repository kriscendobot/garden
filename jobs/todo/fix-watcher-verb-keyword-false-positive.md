# fix: comment/mention-watcher verb-keyword false-positive on review subject matter

## What's wrong

`classify()` in `scripts/jobs/comment-watcher.sh` (and the sibling logic feeding
`scripts/jobs/mention-watcher.sh`) maps a review to a deterministic verb by a bare
word-boundary grep over the WHOLE lowercased body:

    for v in rebase retcon refresh shepherd; do
      if printf '%s' "$lc" | grep -Eq "(^|[^a-z])$v([^a-z]|\$)"; then VERB="$v"; return 0; fi
    done

This fires whenever the verb appears ANYWHERE in the prose, including when it is
the PR's SUBJECT MATTER rather than a directive. Confirmed false-positive:
endojs/endo-but-for-bots PR #526 ("feat(agentry): add clean-rebase git code-mode
eval scenario"). The reviewer's CHANGES_REQUESTED body discusses the *rebase eval
scenario design* (folder-per-eval structure, deeper scenarios) and never asks for
a git rebase. The classifier saw the word "rebase" and minted a
`...-pr526-rebase` job: "rebase the PR branch on its base." The branch is ahead_by:1,
behind_by:0, mergeStateStatus CLEAN — there was nothing to rebase. The actual ask
(design feedback) was lost to the misclassification.

## Fix shape (fixer's discretion)

The fixed verb table is meant to catch imperative directives ("please rebase",
"rebase this"), not mentions of the verb as a topic. For the `pr-review-body`
surface especially, a bare keyword hit should NOT short-circuit to a verb. Suggested:
gate the verb scan so a hit only counts as a directive when it co-occurs with a
directive cue (the existing `reads_as_directive` imperative test) or an @-mention of
the bot; otherwise fall through to the existing `[CHANGES_REQUESTED]` → return 2
(ambiguous → triager/claude reads the body) path. Add a regression test to
`scripts/jobs/test/comment-watcher-test.sh` using a body that mentions "rebase"/
"shepherd"/"refresh" as subject matter with no imperative, asserting it does NOT
classify to that verb. Keep true directives ("please rebase #N") classifying as
before. Apply the same guard to mention-watcher if it shares the pattern.

## Constraints

Garden-infra change under scripts/jobs/. Build in an isolated worktree off
origin/main2 (the shared /home/kris main2 tree is concurrently mutated); commit
explicit pathspecs; push HEAD:main2. Do not `git reset --hard`.

Source PR for the false-positive: https://github.com/endojs/endo-but-for-bots/pull/526
