## Fix round 4 for endojs/endo-but-for-bots PR #1412

The fix commit is pushed and CI is green, but the PR body edit and the summary comment are not on the PR yet. This host's bot token gets a 403 on endojs PR writes (`updatePullRequest`/`addComment`), so I posted a successor job to do both from a host that can.

**What panel-4 asked for.** Two seats requested changes:
- **pruner:** trim the PR body (findings 1–5 and 7) and cut the README's "Inference backends" export bullets down (finding 6).
- **scribe:** post one catch-up comment covering post-weave rounds 1–3 and naming the new head.

**What changed.** One commit, `bade55a5b2`, pushed with `safe-push-pr-head.sh` (advanced from `279a9b3c75`):
- **`packages/claude/README.md`:** each subpath bullet now gives only the module's purpose and its export names. The recipe and plumbing detail is gone. Every export is still named, which rounds 1–2 (archivist and surfacer) asked for.
- **`designs/endo-claude-inference-backends.md`:** the PR body's "Why parallel modules stay separate" reasoning moved here as a Known Gaps item, including the deferred shared `runTurn(transport)` refactor.

No source or test files changed.

**CI:** `ci-wait-merge.sh --no-merge` returned 0, with 33 of 33 checks passing and none failing.

**Successor job:** `endojs-endo-but-for-bots-pr1412-panel4-pr-body-and-summary` is pinned with `requires: host=endolin-garden-ece02cb4`. Its body carries the exact replacement PR body and catch-up comment. The comment covers:
- what each of post-weave rounds 1–4 changed;
- the round-4 should-fix items I did not apply (closing the SDK MCP server on a normal turn, reaping the process group on `close`, more boundary tests);
- that only documentation changed and CI is the check.

**Follow-ups:**
- If panel-5 runs before the successor finishes, scribe and pruner will probably repeat their PR-body and comment findings.
- The round-4 should-fix items above were not applied. Three seats flagged the SDK MCP-server leak, so it is the strongest candidate for a later fix.
- Getting the job posted took several tries because the shared journal clone on this host was locked by other processes. The project checkout also timed out at 120s. I posted through a private clone (`GARDEN_PRODUCER_CLONE`) and then deleted it.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1412-post-weave-gauntlet-fix-4.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 92 tokens (3662807 cached reads)
- Output: 15721 tokens
- Cost: $1.8118773999999997
- Wall-clock: 6216s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
