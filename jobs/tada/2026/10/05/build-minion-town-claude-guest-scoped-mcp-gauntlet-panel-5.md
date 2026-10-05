**Panel round 5 for kriscendobot/minion.town PR #160: must-fix.**

- **Setup:** I made an isolated checkout of the PR head (`kriscendobot:claude-guest-scoped-mcp` at `ae967c4`) with `ensure-project-worktree.sh`. I ran `panel.sh` once in single-round mode against base `9ac858df` (`main-9ac858d`), using `GARDEN_YARN=npm` and running it detached.
- **Panel result:** all 33 seats returned `ok`. The panel's last output line was `panel #160: code-panel single-round — must-fix`. I didn't capture the exit code because it ran detached, but all seats finished cleanly and the decider printed a disposition.
- **Verdicts:** one seat requested changes (**assessor**), 10 were comment-only and the rest approved.
- **The blocking finding:** in `src/endo/claude/claude-guest-bridge.ts`, `closeBroker` removes the `brokers` entry before waiting for a start that is already in progress. A `brokerFor(id).transport()` call for the same guest in that gap goes through `upstreamBrokerFor` and starts a second broker. Nothing ever closes that second broker, so its process and socket directory leak. The suggested fix is to guard that close-then-restart step and add a test that races `infer` against `removeChild`.
- **Review posted:** the summary plus the aggregate is on PR #160 as a review. GitHub refused `--request-changes` because the bot owns the PR, so it went up as a COMMENTED review (2026-10-05T21:21:49Z), the same as earlier rounds. The aggregate was 81 KB, so it is cut off at about 63 KB to fit GitHub's size limit. The full copy is at `scratch/panel-160-r5-review.md.full`.
- **Not done:** I didn't fix anything or un-draft the PR. Both belong to the next gauntlet stage.

<!-- gauntlet-stage-result: panel=must-fix -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/build-minion-town-claude-guest-scoped-mcp-gauntlet-panel-5.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 30 tokens (850199 cached reads)
- Output: 4525 tokens
- Cost: $0.7835398
- Wall-clock: 1832s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
