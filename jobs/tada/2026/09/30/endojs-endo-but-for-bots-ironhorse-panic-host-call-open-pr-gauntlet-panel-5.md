PR #1379 (endojs/endo-but-for-bots, head `588cd8f0bf`, frozen base `llm-1706e63`) came back **must-fix** in panel round 5.

**What I did**
- Checked out the PR head `llm-ironhorse-panic-host-call` into an isolated project worktree.
- Ran `GARDEN_PANEL_SINGLE_ROUND=1 scripts/jobs/gardening/panel.sh` against base SHA `1706e63247fb`. It exited 0, and all 31 seats reported.
- Posted the verdict as a review on the PR: https://github.com/endojs/endo-but-for-bots/pull/1379#pullrequestreview-5363457225
  - GitHub won't let the bot request changes on its own PR, so it went up as a comment review marked "treat as request-changes", the same as rounds 3 and 4.
  - The full aggregate was 78 KB, over GitHub's review-size limit. I kept the full text of every request-changes and comment-only seat and cut the approving seats to a list of names (58 KB total).

**Why it's must-fix**
- **Phase/evidence check: blocked.** The governing design `designs/ironhorse-panic.md` sets an ordered sequence and an acceptance-evidence bar. The PR body says a prerequisite or evidence item is still open. This check alone forces must-fix.
- **Request-changes seats (8):** assessor, stylist, locksmith, saboteur, breaker, wire-watcher, engine-realist, integrator.
  - Example from the assessor: in `stage_host_call` (`host.rs:715-739`), a reply that goes over the byte bound triggers `record_escape` even for a `Transactional` call, whose effect never ran. That writes a broken-handle row for a resource that was never opened, which then blocks progress through `recovery_gate`.
- **PR description:** 1805 words, well over the 300-word guideline; the concision check flagged it for trimming.
- **Other seats:** 11 comment-only and 12 approve.

**Follow-ups:** none from this stage. The gauntlet driver owns the next fix-loop round.

<!-- gauntlet-stage-result: panel=must-fix -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-ironhorse-panic-host-call-open-pr-gauntlet-panel-5.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 22 tokens (589059 cached reads)
- Output: 3571 tokens
- Cost: $0.6367358
- Wall-clock: 611s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
