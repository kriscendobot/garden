PR #1075 is left exactly as found (head `de2f852a891f`, base `llm`, OPEN, unmerged).

## Weave report — endojs/endo-but-for-bots PR #1075

**Outcome: HALTED — branch premise no longer holds. PR #1075 is already fully landed on `llm`; a rebase produces an empty diff. No remote mutation made (rebase aborted; no force-push, no merge, no base change).**

### What I did
- Provisioned an isolated project worktree on the PR head `de2f852a8` and fetched current `llm` (tip `4c061e2f`; head is 4 ahead / 108 behind).
- Started the rebase onto `origin/llm`. It stopped with the exact conflicts the conductor reported: 18 `hardened262/baseline/{sesNode,sesXs,xs}/lockdown*{skipped,passed}.txt` files (UU) plus `test/intrinsics/AsyncFunction/intrinsic-metadata.js` (add/add).
- Read both sides before resolving — and found the conflicts were trunk-drift noise around content `llm` already contains.

### What I found (why the premise is void)
- **Both PR test files are byte-identical on `llm`** — `intrinsics/AsyncFunction/intrinsic-metadata.js` and `inert-stand-in.js`. They landed via squash commit `17dfcee8f` `test(hardened262): cover %AsyncFunction% intrinsic metadata (#1075)` (Kriscendo Bot, 2026-08-28 14:31Z).
- **All 90 baseline lines the PR adds are already present on `llm`** (verified line-by-line across sesNode/sesXs/xs/ironhorse/sesIronhorse: present=90, missing=0). The PR is purely additive (244 insertions, 0 deletions), so every one of its contributions is already on trunk → a resolved rebase drops all 4 commits as empty.
- **PR timeline:** head force-pushed 14:05Z, closed 15:12Z, reopened 15:29Z (all kriscendobot, 2026-08-28). The reopen left a redundant PR whose %AsyncFunction% coverage is already green on `llm`.

Per the weaver operating norm ("if the rebase reveals the branch's premise no longer makes sense on the new base … stop and surface the question"), I did not force an empty rebase or merge.

### Surfaced / recorded
- Messaged the maintainer (via liaison inbox `20260831T071931Z-f0685e`) with the evidence and recommendation: **close PR #1075 as already-landed** — no conductor/merge job, nothing to merge. The `%AsyncFunction%` coverage is not lost.
- Recorded memory `endo-pr1075-already-landed` so a future weaver/conductor on this PR won't re-run the analysis.

### Follow-ups
- Maintainer decision: close endojs/endo-but-for-bots#1075. No garden `main2` changes were needed (nothing pushed).
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1075-weave-20260831.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 2 on 1 host(s)
- Input: 50 tokens (1733091 cached reads)
- Output: 20276 tokens
- Cost: $2.1857055
- Wall-clock: 348s
- Model(s): claude-opus-4-8 ×2

<!-- garden-usage-end -->
