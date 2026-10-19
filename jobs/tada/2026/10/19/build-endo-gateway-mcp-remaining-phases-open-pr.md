I opened the draft PR **endojs/endo-but-for-bots#1499**: https://github.com/endojs/endo-but-for-bots/pull/1499

**What I did:**
- Got an isolated project checkout of `build/endo-gateway-mcp-remaining-phases` and confirmed it is still at `cbbc9e09d71f5fd12ca70c91274e273dc145fda2` on origin. The frozen base `build/endo-gateway-mcp-termination-e7e6316` is at `e7e63160d`, which matches the job spec.
- Wrote the PR body from the job spec, word for word, and ran `ensure-pr.sh` from inside that checkout so the phase-evidence gate could find the `designs/` paths. I used the original job base `build-endo-gateway-mcp-remaining-phases`, so the PR carries that job's marker.
- Checked the result: the PR is a draft, its head is `cbbc9e09d`, its base is `build/endo-gateway-mcp-termination-e7e6316`, and the body contains the marker `<!-- garden-job: build-endo-gateway-mcp-remaining-phases -->`.
- No code changed.

**Follow-ups:**
- **No "Stacked on" line yet.** The predecessor's PR (head `build/endo-gateway-mcp-termination`, job `build-endo-gateway-mcp-termination-open-pr`) does not exist yet: searching PRs by that head branch, in any state, returns nothing. So #1499 does not have the `Stacked on #<N>.` line. Whoever opens the predecessor's PR should add that line to the top of #1499's body.
- **The board does not link #1499 to its job yet.** `ensure-pr.sh` reported "no work/build-endo-gateway-mcp-remaining-phases record on the board", because this handoff job, not the original, was the one claimed. The PR is open and carries the original job's marker, but staging the gauntlet depends on this report naming #1499.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/build-endo-gateway-mcp-remaining-phases-open-pr.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 10 tokens (235409 cached reads)
- Output: 3574 tokens
- Cost: $0.49060980000000004
- Wall-clock: 54s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
