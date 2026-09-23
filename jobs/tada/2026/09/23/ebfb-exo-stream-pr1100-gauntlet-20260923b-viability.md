**Gauntlet viability report: endojs/endo-but-for-bots#1100** ("feat(exo-stream)!: use one stream method for byte streams")

**Verdict: proceed.** The PR is still needed and nothing on `llm` has replaced it, so the gauntlet can start. I spent no clean, panel, fix, CI-wait or un-draft budget.

**PR state:** open, unmerged, still a draft, and GitHub reports it `MERGEABLE`. The head branch is `kriscendobot-exo-stream-drop-base64` at `aeba1a3f81`. The base is the pinned `llm-f9cbcfc` at `f9cbcfc426`.

**Deciding question:** Does current `llm` still ship the transitional bytes-only `streamBase64()` Exo method, with no newer PR or commit that removes it? Answering yes shows both that the PR is not superseded and that its motivating need still holds.

**Evidence:**
- **The base is current.** Comparing `llm...f9cbcfc` returns `identical` (0 ahead, 0 behind), so the pinned base is today's `llm` tip.
- **The method is still on `llm`.** `packages/exo-stream/type-guards.js` still declares `streamBase64: M.call(M.any()).returns(M.promise())` for both the reader and the writer guards (lines 103 and 126). The file's own doc comments call it a stepping stone toward a future move to `stream()`, which is exactly the migration this PR completes.
- **Code search agrees.** A GitHub code search found 74 files on the repo that still mention `streamBase64`, so no replacement has landed.
- **The PR was checked for being overtaken at the last rebase.** On 2026-09-23 a bot comment explicitly checked whether `llm` had overtaken this PR (as happened to #1089 and #1097) and found it had not. It then rebased the head onto the current `llm` tip.
- **Known work remains, but none of it is about supersession.** The PR has been through three panel and fix rounds. The latest CI triage on 2026-09-23 found `packages/platform` snapshot fixtures (`cas.test.js` and `cached-fs.test.js`) that don't round-trip; that is ordinary fix-loop work for the gauntlet.

**One check didn't run:** my search for other PRs mentioning `streamBase64` failed because the GitHub API rate limit was exhausted.

<!-- gauntlet-stage-result: viability=proceed -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/ebfb-exo-stream-pr1100-gauntlet-20260923b-viability.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 8 tokens (165404 cached reads)
- Output: 1673 tokens
- Cost: $0.40890080000000006
- Wall-clock: 24s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
