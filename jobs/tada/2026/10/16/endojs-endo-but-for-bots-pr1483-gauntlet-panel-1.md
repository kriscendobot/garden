**Panel round 1 for endojs/endo-but-for-bots#1483: pass.**

**What I did**
- Made an isolated checkout of the PR head, `endojs/endo-but-for-bots@build/ocapn-noise-heartbeat-capability` at `9cc41693a6`.
- Ran `GARDEN_PANEL_SINGLE_ROUND=1 panel.sh` against the base merge SHA `9376e7e05b`. The PR is stacked on `build/ocapn-noise-session-reconnect-crossed-hellos-9376e7e`. The run exited 0 with disposition `pass`.
- Of the 33 seats: 7 approved, 23 were comment-only and 3 requested changes (prover, integrator, pruner). All three raised only should-fix or summary-fix items, and the decider found nothing must-fix.
- Posted a COMMENT review (pass) on head `9cc41693a6` with the `<!-- garden-panel-verdict: round=1 disposition=pass -->` marker and a summary of the non-blocking items.
- The full seat output was 77 KB, over GitHub's body limit, so it went into two follow-up PR comments (issuecomment-6225853703 and -6225855251).
  - The gh wrapper refused part 2 at first because it had a bare `#1483` next to a reference to another repo. I changed it to `endojs/endo-but-for-bots#1483` and reposted.

**Non-blocking items left for the author**
- **Tests (prover, corner-prober):** test the case where A has `heartbeat: false` and B has it on.
- **Silent-peer test (prover):** confirm the test really stays silent within A's 500 ms window.
- **Wire format (prover):** confirm another test still checks the `op:ping`/`op:pong` encoding that the removed test covered.
- **Interval mismatch (breaker):** the capability bit carries no interval, so a peer with a long `intervalMs` can be declared lost by a peer using the default timeout.
- **Design doc (integrator, archivist):** reconcile it with the new default-on behavior. The changeset request is disputed: changeset-auditor notes both packages are private, so no changeset is owed.
- **PR body (pruner):** at 605 words it's too long, and the negotiation rule is restated in four comments.
- **Typing nits (typist, assessor):** small issues in `types.d.ts` and `normalizeHeartbeatOptions`.

No garden code changed and nothing was committed.

<!-- gauntlet-stage-result: panel=pass -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1483-gauntlet-panel-1.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 36 tokens (1123852 cached reads)
- Output: 5522 tokens
- Cost: $0.8970343999999999
- Wall-clock: 186s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
