---
event: result
role: weaver
dispatcher: endolinbot-steward
dispatch_root: /home/kris/dispatches/weaver--bba6bc (torn down)
repo: endojs/endo-but-for-bots
pr: 347
---

# Result: weaver-bba6bc reconstruct #347 onto master

- Bot-master sync: no-op (already at 67c5fcd8e from earlier rebases).
- PR #347 base changed: llm → master (via `gh pr edit --base master`).
- Branch rebuilt via `git rebase --onto origin/master origin/llm origin/mirror/3033-ocapn-cbor`.
- New head: c0f202dad306bd906d8463dcc3dcbd6e02e34597 (was e3089cc2b).
- 1 commit carried after dropping llm-base content: `fix(ocapn): @type bigint JSDoc on syrupReader.readInteger() return` (+2 lines in packages/ocapn/src/codecs/subtypes.js).
- 0 conflicts.
- mergeStateStatus: UNSTABLE (CI in flight at handoff; no merge conflict).
- isDraft: false (unchanged).

**Premise mismatch surfaced**: PR title says "CBOR alternative encoding (mirror of endojs/endo#3033)", but the broader #3033 substance was on `llm` (carried via PR #59 + #223), not master. Reconstructed onto master, only the 2-line type-narrowing fix carries. Surfaced in PR comment for maintainer's direction (refresh title/body, or treat as precursor PR). Followed kriskowal's explicit directive over the weaver "don't redesign on the fly" norm.

PR comment: endo-but-for-bots#347 issuecomment-4523775706.
