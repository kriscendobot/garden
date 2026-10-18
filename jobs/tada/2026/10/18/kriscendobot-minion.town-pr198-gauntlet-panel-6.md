## Panel round 6: kriscendobot/minion.town PR #198, disposition **must-fix**

Panel round 6 ran once in single-round mode against PR head `ab339862` (base `main-bda7739`). `panel.sh` exited 0 with **must-fix**, and the verdict is now on the PR. Nothing was fixed and the PR is still a draft.

**What I did**
- Made an isolated project checkout with `ensure-project-worktree.sh` at `/Users/dom/garden/scratch/project-wt-kriscen-0550f7afac35-2fe40460`.
- Ran `GARDEN_PANEL_SINGLE_ROUND=1 panel.sh … 198 main-bda7739`. My first launch had a 10-minute background timeout, which was too short. I stopped it, killed its orphaned processes, cleared its partial run directory and relaunched it detached, polling in the foreground. The rerun itself was clean.
- The second run finished cleanly with no seat or decider errors:
  - 34 seats ran: 7 approve, 21 comment-only, 6 request-changes (assessor, breaker, locksmith, procurer, pruner, saboteur).
  - The decomplector was seated by the new-mechanism probe.
  - The repeated-mechanism check fired: the last two rounds also raised must-fix on `waitlist.ts`, `waitlist-cli.ts` and `http.ts`.
- Posted the aggregate as 3 comment reviews, using the same layout as earlier rounds (GitHub refuses REQUEST_CHANGES from the PR's own author account). I confirmed the head had not moved before posting.
  - Parts 1 and 2 (reviews 5562584702 and 5562584794) hold the non-blocking seats.
  - Part 3 (review 5562584896), "round 6 verdict: **must-fix**", holds the six blocking seats and a summary.

**Blocking finding:** the invitation accept handler in `src/web/guest-web-router.ts` checks whether an invitation is already taken only for authenticated requests. An unauthenticated retry can therefore take over an invitation that another guest already connected or half-finished, so one invitation connects two invitees. Breaker and locksmith both rated this must-fix; saboteur raised the same gap as a should-fix.

**Should-fix items worth folding into the same fix:**
- **Assessor:** if the recovery call fails on return from login, a visitor with a valid stored guest is shown the waitlist instead of their guest.
- **Procurer:** `makeRateLimiter` duplicates the one in `@endo/http-confine`.
- **Pruner:** `designs/closed-beta-waitlist.md` repeats its rationale and includes coordination notes about a sibling PR.

**Follow-up:** the decomplector suggests the maintainer decide whether one global signup limit should replace the per-network limiter. That limiter keeps getting patched round after round, and the switch would remove about 60 lines. This is comment-only, but it is worth surfacing before the next fix round.

<!-- gauntlet-stage-result: panel=must-fix -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr198-gauntlet-panel-6.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 44 tokens (1272091 cached reads)
- Output: 8416 tokens
- Cost: $0.9279222000000003
- Wall-clock: 393s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
