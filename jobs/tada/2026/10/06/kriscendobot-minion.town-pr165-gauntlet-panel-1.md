Panel round 1 on kriscendobot/minion.town PR #165 finished last session with a **must-fix** verdict, and the review is on the PR. The previous report put the stage-result marker after the completion signal, so the job was not recorded as done. This report fixes that order; I did not redo any work.

- **Checkout:** I ran the panel on an isolated checkout of the PR head (branch `feat/claude-pinned-responder`, commit `775d9bdb`), at `scratch/project-wt-kriscen-9f31079a281e-bf7ee5cb`.
- **Panel run:** `GARDEN_YARN=npm GARDEN_PANEL_SINGLE_ROUND=1 scripts/jobs/gardening/panel.sh <wt> 165 be0edb8fa1fd…`, using the PR's base commit hash.
  - It printed `panel #165: code-panel single-round — must-fix`.
  - All 33 seats reported `ok` and the decider wrote nothing to stderr.
  - I didn't capture panel.sh's exit code because it ran detached, so I took it as exit 0 from that output.
- **Review posted:** at 2026-10-06T16:52:22Z. It shows as COMMENTED because GitHub won't let the bot request changes on its own PR. The body starts with the disposition header and a `<!-- garden-panel: … disposition=must-fix -->` marker. The aggregate is cut at 63,000 of about 91,000 bytes to fit GitHub's review size limit, with a note saying so.
- **Main must-fix findings:**
  1. **Leaked child on failure:** in `agents.ts`, a `create(..., {watchInbox:true})` whose inbox responder fails to set up leaves a live child holding a quota slot, with no handle returned to the caller.
  2. **Revoked subjects keep inference:** `inferForInboxResponder` and the restore loop skip the `rootSubjects` check, so a subject removed from the root list can still run inference through its saved token.
  3. **No rate cap on the stored handle:** the child guest keeps a `claude-inbox-agent` handle it can call without the responder's rate limit.
  4. **Untested guard:** no test sends `watchInbox` through the real `guardedFar` path.
  5. **Silent errors:** a bare `catch {}` in `inbox-responder-endpoint.ts` returns a 503 with no log.
  6. **Abbreviated names:** `windowMs`/`maxPerWindow` should be spelled out.
  7. **Unbacked claim:** the "item 6" acceptance claim has no evidence in the PR.
- **Follow-ups:** the fix-loop stage owns these findings. I made no garden commits, did not edit the PR, and did not take it out of draft.

<!-- gauntlet-stage-result: panel=must-fix -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr165-gauntlet-panel-1.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 28 tokens (734159 cached reads)
- Output: 5525 tokens
- Cost: $1.3397086000000002
- Wall-clock: 1005s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
