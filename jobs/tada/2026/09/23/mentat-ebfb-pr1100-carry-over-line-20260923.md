---
handed-off: ebfb-exo-stream-pr1100-gauntlet-20260923
deliverable-complete: false
---
## Completion report — `mentat-ebfb-pr1100-carry-over-line-20260923`

**Supersession verdict: NOT superseded.** Unlike #1089/#1097, current `origin/llm` (`f9cbcfc4`) has `packages/exo-stream` byte-identical to the old pinned base and `streamBase64` still live at every platform call site — PR #1100 remains the sole vehicle for the change. Proceeded with the rebase.

**New base & rebase:** pinned `llm-f9cbcfc` (= live `llm` tip, verified fresh), repointed the PR base, rebased all 18 head commits across 174 commits of drift (~23 conflict hunks in 18 files). The substantive weave: llm's range-attenuation work had added `isFull`/selected-bytes branches and a `bytes()`/`byteRange()`/`textRange()` surface to every `streamBase64` responder — I kept llm's attenuation structure, applied the rename, and converted the drift-side responders to `bytesReaderFromIterator`. One reconciliation commit on top; head pushed via `safe-push-pr-head.sh --mode rewrite`, now `f8c369ddf5`, delta verified our-files-only (97 files).

**Fix work:** the halted fix-6 stage's must-fix items were **already pushed** as `4e0815c8` before the 09-17 fleet outage doomed the claimant mid-CI-watch — I verified all round-6 items (HttpResponse `stream()`→`body()` + `!status` clause dropped, browser-tree producer cap removed, typist asserts-widening, prover discriminator test, prose sweep, bench spellouts) are in the rebased head. Locally: exo-stream 156, platform 371, daemon mount 132, 9p 57, asset-server 25, git 15, exo-git 56, explorer 80, http-client 37 tests pass; lint+tsc clean in six packages (found and fixed one stray base64 pump in `mount.js` tsc caught).

**Board ops:** withdrew the dead `…-fix-6` stage; posted gauntlet `ebfb-exo-stream-pr1100-gauntlet-20260923`. Two explanatory PR comments posted (rebase summary + CI triage).

**Unfinished — CI is red, and I ran out of budget:** `packages/platform` `cas`/`cached-fs` **ava snapshots don't round-trip under the immutable-arraybuffer shim this PR introduces** (recording run passes; the next plain run throws `Buffer.from(undefined)` in `t.snapshot` compare; re-recording doesn't fix it) — fails on both CI OSes; plus a `lint` failure in a workspace outside the six I verified. Diagnosis + fix-shapes are on the PR (comment 5803479341) and in a memory note. Two host-local failures were proven environmental (socket-path >107 chars; base-side git-identity flake) — documented so nobody chases them. The posted gauntlet's clean/fix loop owns driving CI green from here.

<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/mentat-ebfb-pr1100-carry-over-line-20260923.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 236 tokens (19670003 cached reads)
- Output: 78428 tokens
- Cost: $28.345402999999987
- Wall-clock: 2552s
- Model(s): claude-fable-5 ×1

<!-- garden-usage-end -->
