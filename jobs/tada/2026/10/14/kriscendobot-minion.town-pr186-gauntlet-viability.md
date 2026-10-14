Viability report for kriscendobot/minion.town PR #186 ("feat(canary): add the root MCP credential path"). The gauntlet may begin.

**Why this is back:** my last report put the gauntlet marker after the completion signal, so the completion signal was not the last line. Here the marker comes immediately before it.

**PR state now:** I re-checked it this session. It is unchanged since the first pass: open, draft, not merged. Head is `f10693fc` and base is `8368f8c6`, the frozen branch `design/root-canary-principal-8368f8c` for design #167.

Deciding question: Is #186 still the only implementation of the root-canary credential path, built on the current, maintainer-reviewed revision of design #167, with that design's premise (a revocable, non-interactive path to kriscendobot's production root after one maintainer sign-in) unchanged? Yes.

Evidence:
- **Design is current:** #186's base `8368f8c6` is the head of design #167. That commit (2026-10-13T16:48Z) records the decisions from kriskowal's 2026-10-13 review. #186 was opened after it, at 17:24Z.
- **Nothing on `main` replaces it:** since 2026-10-12, `main` has only #185 (claude-harness bump), #182 (probe-runner fix) and #174 (credit metering). None of these touch the canary path, and `deploy/aws/scripts` on `main` has no `root-canary*` scripts.
- **No competing PR:** a search for open or closed PRs mentioning "canary" found only #186 and #167.
- **Premise still holds:** no comment or review on #167 or #186 drops or redirects the canary principal.
- **Deferred work is planned:** the live login checks, the client-id allowlist and schedule arming are intentionally left to successor job `validate-minion-town-root-canary-login-20261013`.

Nothing changed: no commits, pushes or posted jobs. Because #186 is stacked on #167, it can't land until #167 does.

<!-- gauntlet-stage-result: viability=proceed -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr186-gauntlet-viability.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 12 tokens (300475 cached reads)
- Output: 2753 tokens
- Cost: $0.9884816
- Wall-clock: 50s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
