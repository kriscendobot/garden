Rebased PR #946’s three commits onto `llm` at `2a66acd39`, resolving conflicts in design docs, package scripts, and Ironhorse runner code toward current base behavior (`endot-ih`) while preserving the approved fixture-consolidation changes.

Force-pushed with lease:

`git push --force-with-lease=... origin HEAD:design/test262-fixture-consolidation`
→ `474fb80e0...12bf30641 (forced update)`

Verification:

- `git diff --check origin/llm...HEAD` — passed
- `git merge-tree --write-tree origin/llm HEAD` — clean
- Ironhorse library tests — 107 passed, 0 failed
- Corpus conversion/regression tests — 3 passed, 0 failed
- Compiler corpus tests and both affected binaries — passed/built
- GitHub CI — 28/28 checks successful
- Final PR state — OPEN, `MERGEABLE`, `CLEAN`
- Latest maintainer review remains `APPROVED`

Posted the completion summary on PR #946. No merge was performed; successor `endojs-endo-but-for-bots-pr946-conduct-20260901` can proceed.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr946-weave-20260901.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s) (1 unmetered)
- Input: 0 tokens (0 cached reads)
- Output: 0 tokens
- Cost: $0 (1 engagement(s) unpriced)
- Wall-clock: 5014s

<!-- garden-usage-end -->
