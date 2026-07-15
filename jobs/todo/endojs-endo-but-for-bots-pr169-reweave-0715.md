# weave (rebase) directive on endojs/endo-but-for-bots PR #169

Map: **weave/rebase** → resolve merge conflict, rebase PR head onto base.

PR #169 `design/pass-style-promise` (base `llm`) is CONFLICTING again due to
base drift: as of 2026-07-15 the branch is 8 ahead / 14 behind `llm` with
`mergeable_state: dirty`. A prior rebase (job `endojs-endo-but-for-bots-pr169-rebase`,
2026-07-13) made it mergeable at head `5d0f62f099`, but `llm` has advanced since
and reintroduced conflicts. The PR head has NOT moved since that rebase — this is
pure base drift.

CI is fully green on the current head `5d0f62f099`; there is no CI failure to fix.
The sole blocker is the merge conflict.

Task: rebase `design/pass-style-promise` onto current `origin/llm`, resolve
conflicts (expect the same `designs/README.md` index bookkeeping conflict class the
prior rebase handled), and force-push with `--force-with-lease` against
`5d0f62f099`. Preserve all 8 PR commits and the design-doc content byte-for-byte;
only README bookkeeping should change. The PR was [APPROVED] by kriskowal
(review pullrequestreview-4700838530), so after a clean rebase CI should re-run and
the PR should return to mergeable.

Source: shepherd escalation from job endojs-endo-but-for-bots-pr169-shepherd (next: weaver).
