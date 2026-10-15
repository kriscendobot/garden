Fix round 4 for kriscendobot/minion.town PR #190 is pushed, and CI passed on the new head `9ff4210`.

**Fixes**, in two follow-up commits pushed to `clip-gutter-reorder` with `safe-push-pr-head.sh` (`2290d9d..9ff4210`):
- **`6b92679` (shell):**
  - **Assessor's should-fix:** a 400 from `PUT /account/clips/order` (the order names a clip the owner no longer holds) is now handled like a 409. The shell re-reads the clip list and drops the queued save instead of resending the same rejected order forever.
  - **Pruner:** deleted three test comments that restated the assertion below them, and extended the sink test to cover 400, 409 and 503.
- **`9ff4210` (docs):**
  - The full rules for the two routes (request body and the 200/400/409/503 responses) now appear once, in the `src/auth/guest-self-endpoint.ts` header.
  - `DEPLOYMENT.md` is down to one sentence with a pointer to that header, and the design doc's gutter bullet is down to one clause.
  - Removed a repeated sentence from the route header and a speculative sentence from the `clip-order.ts` header.
- **PR body:** cut from 374 to 148 words (pruner).
- **Summaries (scribe):** posted completion summaries for fix rounds 2, 3 and 4 on the PR. The round-2 summary says that `bc5a1b6` implements the owner-bound clip-order change that round 1 had deferred to the maintainer.

**Declined, with reasons in the round-4 summary:**
- Logging order-store write failures differently from daemon outages: the response is a 503 either way, so only the operator's log label changes.
- One shared admission wrapper for the GET and PUT routes: the GET route's unguarded admission predates this PR.
- The borderline doc comment on `MAX_CLIP_ORDER_LENGTH`: kept, as the pruner allowed.

**Checks:**
- **Local:** the three affected vitest files pass (81 tests) and `tsc --noEmit` is clean.
- **CI:** the run on `9ff4210` passed ([run 38772200203](https://github.com/kriscendobot/minion.town/actions/runs/38772200203)), and `ci-wait-merge.sh --no-merge` returned rc 0.

**Follow-ups:** the two declined assessor items could become a small follow-up job. The panel was not re-run; the driver posts panel round 5.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr190-gauntlet-fix-4.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 56 tokens (1790366 cached reads)
- Output: 13474 tokens
- Cost: $1.1859052
- Wall-clock: 1032s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
