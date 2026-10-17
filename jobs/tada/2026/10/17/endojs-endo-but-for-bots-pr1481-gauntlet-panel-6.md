Panel round 6 on endojs/endo-but-for-bots#1481 finished with a **must-fix** verdict, and the review is posted on the PR.

**What I did**
- Made an isolated checkout of the PR head (`endojs:build/ocapn-noise-session-reconnect-rekey` at `d1647d38f0`). The base is `build/ocapn-noise-session-queue-2a16357` (`2a16357eaa`).
- Ran `GARDEN_PANEL_SINGLE_ROUND=1 scripts/jobs/gardening/panel.sh … 1481 origin/build/ocapn-noise-session-queue-2a16357`. It exited 0 and returned `code-panel single-round — must-fix`. A record of the run is in the journal at `panel-runs/endojs-endo-but-for-bots-1481/8d61d1df2263.md`.
- Seat verdicts:
  - **Request changes (5):** packager, prover, breaker, pruner, releaser.
  - **Approve (8):** locksmith, benchmarker, gateway, transplanter, orthographer, thesaurus, procurer, reexport-auditor.
  - **Comment only:** the other 21 seats.
- Found a problem the panel keeps hitting: the last two rounds also raised must-fix items on the same reconnect/replay code (`unacked`, `outbound`, `receivedFrames`, `backoffMaxMs`, `SESSION_HARD_TIMEOUT`, …). Because of that, the panel also asked whether that mechanism is needed at all.
- The prover's main must-fix item: the cap on resume handshakes per peer (`resumeAttempts`, `network.js:490` and `:2114-2119`) has no test. Deleting it would leave every test passing.

**Posting**
- GitHub refused a request-changes review ("Can not request changes on your own pull request"), so I posted it as a comment review, the same way round 5 was posted: https://github.com/endojs/endo-but-for-bots/pull/1481#pullrequestreview-5557500493 (commit `d1647d38f0`).
- The full aggregate is about 93 KB, which is over GitHub's limit for a review body. The review therefore has a header with the reviewed head and every seat's verdict, plus the complete text of the 5 request-changes seats. Comment-only and approve text is left out, so the comment-only seats' should-fix notes are not on the PR.

**Follow-ups:** none from this stage; the gauntlet's fix stage comes next.

<!-- gauntlet-stage-result: panel=must-fix -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1481-gauntlet-panel-6.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 34 tokens (980636 cached reads)
- Output: 4766 tokens
- Cost: $0.7376392
- Wall-clock: 243s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
