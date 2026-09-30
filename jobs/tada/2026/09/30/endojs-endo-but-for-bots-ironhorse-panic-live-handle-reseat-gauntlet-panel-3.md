Round 3 of the panel on endojs/endo-but-for-bots #1380 came back **must-fix**, and I've posted the verdict to the PR as a review.

**What I did**
- Checked out the PR head in an isolated worktree: `endojs/endo-but-for-bots@llm-ironhorse-panic-live-handle-reseat`, head `623378a55b66`.
- Ran `GARDEN_PANEL_SINGLE_ROUND=1 panel.sh` against the PR's current base, `1706e63247fb` (`llm-1706e63`). It exited 0 with the disposition `must-fix`.
- Two automatic pre-checks ran before the seats:
  - **Phase/evidence gate: blocked.** The PR does not yet meet the acceptance evidence required by `designs/ironhorse-panic.md` (`acceptance-not-satisfied:partial`). This alone forces must-fix.
  - **PR description too long.** It is 985 words against a 300-word limit, and 8 bullets start with a code span.
- Seat verdicts: 32 seats — 10 request-changes, 11 comment-only, 11 approve.
  - **Request-changes:** assessor, stylist, curator, saboteur, breaker, wire-watcher, engine-realist, integrator, pruner, orthographer.
  - **Examples from the assessor:**
    - A failed `attach` in `host_ledger.rs` leaves native handles registered while `LEDGER` is unset.
    - A second envelope drained during the same reactive pump is never written to the transcript.
    - A refused `begin_crank` in `begin_delivery` is only logged, and the delivery goes ahead anyway.
    - `supervisor.rs` `retire` removes the worker before recording its outcome, so a caller can briefly see neither.
- **Posted the review.** The full aggregate is 202KB, which is over GitHub's review size limit. I posted a 57KB version in the same format as round 2:
  - the pre-check findings
  - all 10 request-changes seat reports in full
  - the 11 comment-only seat reports, cut to about 1.8KB each
  - the list of approving seats
  - the marker `<!-- garden-panel-verdict: must-fix round=3 head=623378a5… -->`

  GitHub doesn't allow request-changes on your own PR, so it went up as COMMENTED at 2026-09-30T10:50:47Z, as rounds 1 and 2 did.

**Changes:** none. I made no fixes, left the PR in draft, and made no garden commits.

**Follow-ups**
- The next fix round has to add the acceptance evidence from `designs/ironhorse-panic.md`. Until it does, the gate will keep forcing must-fix whatever the seats say.
- The PR description needs trimming.
- There is no helper that shortens an oversized aggregate into a postable review, so it gets rebuilt by hand each round. A small script could do it.

<!-- gauntlet-stage-result: panel=must-fix -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-ironhorse-panic-live-handle-reseat-gauntlet-panel-3.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 40 tokens (1181916 cached reads)
- Output: 7820 tokens
- Cost: $0.8975112000000001
- Wall-clock: 652s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
