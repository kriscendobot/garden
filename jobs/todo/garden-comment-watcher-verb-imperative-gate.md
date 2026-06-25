# Gate comment-watcher's fixed verb table on an imperative cue

`scripts/jobs/comment-watcher.sh` `classify()` (the fixed verb table, lines
~199-201) matches the bare words `rebase|retcon|refresh|shepherd` anywhere in a
comment body via a word-boundary regex, with **no imperative-cue gate**. This
fires a directive job when the verb appears as subject matter rather than as a
command.

## Evidence (real false positive)

endojs/endo-but-for-bots PR #513, issue-comment 4800685785 (by kriscendobot)
explained a base situation and concluded: "a subsequent **rebase** of this PR
onto a fresh `llm` snapshot will pick it up. **No action needed here until #528
merges.**" The bare word "rebase" (future-tense noun) matched the table and the
watcher posted `endojs-endo-but-for-bots-pr513-rebase` — an immediate rebase
directive whose source comment explicitly says to *wait*. A gardener verified
#528 is still open/draft, #513 is already MERGEABLE with green CI and does not
depend on `@endo/cancel`, and closed the job no-op.

## Fix

Apply the same discipline commit 194b0a49 ("gate verb table on imperative cue")
applied to the watchers table: require an imperative cue near the matched verb
before setting VERB in the fixed table. The `reads_as_directive()` helper
already encodes the imperative-cue heuristic (leading/near "please", "apply",
"address", "finish" plus imperative openings); reuse it, or require the verb to
appear in imperative position (sentence-initial or after "please"/"can you"/
"could you"/"go ahead and"). A future-tense or conditional mention ("a
subsequent rebase ... will", "once X merges", "no action needed") must not fire.

Keep the existing `@`-mention and CHANGES_REQUESTED fall-throughs (return 2)
untouched. Add a regression note to the watcher referencing comment 4800685785
as the canonical verb-as-subject-matter case for the fixed table (the prior fix
covered a different table).

Build in an isolated worktree off origin/main2 per garden infra-job convention.
