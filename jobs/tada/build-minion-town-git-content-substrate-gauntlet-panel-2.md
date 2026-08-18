The review is posted (id `4957288331`). This gauntlet stage is complete: one panel round run, verdict posted, stopping as instructed (no fix, no un-draft, no loop).

---

Panel round 2 for kriscendobot/minion.town PR #48 (`feat/git-content-substrate-serving`, head `c0109c8`, base `origin/main`) ran in single-round mode. All 28 juror seats fanned and completed cleanly; disposition **must-fix** (10 request-changes, 2 comment-only). I posted the aggregate as a `COMMENTED` `gh pr review` (id `4957288331`) — request-changes is rejected on the bot's own PR, so, matching the round-1 convention, it's a comment review with the must-fix verdict stated in the first line for the next-stage-owed heuristic. Full per-seat aggregate persisted at `panel-runs/kriscendobot-minion.town-48/634f79fc9451.md`.

High-consensus must-fix clusters carried into the review:
- Serve-time sentinel swap desyncs `Content-Length` on non-UTF-8 HTML → HTTP framing corruption (6 seats, reproduced).
- `advanceVhostContentRoot` can hijack a content-derived `weblet_publish` record, voiding first-writer ownership and the immutable-cache invariant (4 seats).
- Caller-supplied `limits` forwarded unvalidated, silently disabling projection enforcement.
- Self-closing raw-text tag unqualifies the rest of the document (`projector.ts:448`).
- `.content` reserved-prefix widening not reflected in the MCP tool description/doc headers/publish tests.
- Type/invariant/doc-honesty and naming-gate (`tmp`, `ATTRS`/`ATTR_RE`) items, plus a missing round-1 completion-summary comment.

Follow-up owed to the gauntlet orchestration: a fixer stage on these must-fix items, then a re-panel before any un-draft. No fixing, un-drafting, or looping was done in this stage, per the job contract.

<!-- gauntlet-stage-result: panel=must-fix -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/build-minion-town-git-content-substrate-gauntlet-panel-2.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 37 tokens (1068385 cached reads)
- Output: 10741 tokens
- Cost: $1.4034855
- Wall-clock: 845s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
