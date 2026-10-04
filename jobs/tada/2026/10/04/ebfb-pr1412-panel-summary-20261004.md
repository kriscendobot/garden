## Completion report: ebfb-pr1412-panel-summary-20261004

I sent the maintainer one message about endojs/endo-but-for-bots#1412 through `message-user.sh` (msg `msg-ebfb-pr1412-panel-summary-20261004-9a7c9045a542`). I did not push to the PR or stage another gauntlet.

**Recommendation sent:** merge as is on substance, but only after endojs/endo-but-for-bots#1403 (phase 1) merges and a weave shrinks the stack. The PR is stacked on #1403, which is still an open draft, and the PR body itself says to stay draft until then.

**State of the PR:**
- **Status:** draft; head `aa09ea465a`; CI green.
- **Gauntlet:** stopped at its review budget after 6 rounds.
- **Panel coverage:** the latest head has not been reviewed. Round 6 reviewed `0674323ba9`, and three commits came after it (about 300 lines, mostly tests and docs). I read the main code change, the termination-race fix in `f4fae43852`, by hand, and it is correct.
- **Round-6 must-fixes:**
  - **Fixed (four):**
    - **Breaker:** a fast message stream could outrun termination.
    - **Saboteur:** a fractional turn limit made `infer()` reject instead of returning a result.
    - **Prover:** the retention fix had no test that would fail without it.
    - **Archivist:** the design's Status row contradicted its Status section.
  - **Documented, not fixed:** the integrator's endojs/endo-but-for-bots#1369 Gap 2.

**Objections still open, by class:**
- **Follow-up-worthy:**
  - **Gap 2:** the guest's MCP server process inherits the credential. It is now recorded as acceptable only for a single-principal deployment, so it should block any multi-principal deployment until the broker delivery closes it.
  - **Memory spike:** the SDK backend serializes a whole message before checking the byte limit, so one huge message can spike memory.
  - **Cross-realm errors:** an `instanceof Error` check drops the message of errors thrown from another realm.
  - **Untested cycle handling:** the byte counter's cycle handling has no direct tests.
- **Taste/noise:**
  - Property-based tests and adding `fast-check` to `@endo/inference`.
  - The `./types.js` export lacks a `default` condition.
  - One test spawns its fixture in a POSIX-only way.

**Follow-ups:**
- If the maintainer wants panel coverage of the final head before un-drafting, the post-#1403 weave is the natural point for one more round.
- The four follow-up-worthy items need follow-up issues or jobs if the maintainer agrees.
- One unverified detail in the message: I called the broker delivery "phase-3" without checking which phase the design actually assigns it to.

## Panel-head freshness

Disposition: **review required**. The last completed panel reviewed `0674323ba92d1c678a62f65524147fef5af07ef6`; this job presented `aa09ea465a4efb43e9b3e5fd3e0efaf20530d3cb`. The old panel verdict does not cover the current head. No gauntlet was staged; the maintainer received a deduplicated stale-review action.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/ebfb-pr1412-panel-summary-20261004.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 18 tokens (516566 cached reads)
- Output: 4359 tokens
- Cost: $0.7072451999999999
- Wall-clock: 64s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
