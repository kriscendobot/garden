I ran round 6 of the review panel on kriscendobot/minion.town PR #190 (head `c99ca91`). It came back **must-fix**, and I posted the verdict on the PR.

**How it ran**
- **Checkout:** a separate project copy of `kriscendobot/minion.town` at `clip-gutter-reorder`, at `/Users/dom/garden/scratch/project-wt-kriscen-14888d68c99f-c6234323`.
- **Panel:** single-round mode against `origin/main-ad0257e`; `panel.sh` exited 0.
- **Restart:** my first launch was cut off ("Terminated") before it finished, so I ran it again detached and waited on it in the foreground. Only the second run produced the verdict.
- **Seats:** of 32, 14 approved, 14 left comments only and 4 asked for changes.

**What the 4 request-changes seats want fixed**
1. **engine-realist:** the drop handler in `shell.js` re-renders and removes the button being dragged, so the browser may never send `dragend` and `draggedId` stays set. A later unrelated drag could then reorder the clips and save without the user meaning to. Fix: clear `draggedId` inside `drop`, and add a test where a drag with no `dragstart` doesn't reorder.
2. **purist:** only the new `PUT /account/clips/order` route catches failures from `admit`. `GET /account/clips`, `/account/guest-formula-id` and `/account/guest-locator` have the same crash risk. Fix: catch them inside `admit` (or a shared helper), or wrap the GET too and say why the older routes are left alone.
3. **spec-keeper:** `isClipOrder` checks for duplicates before folding case, so a mixed-case hash is accepted (204) and then silently never matches. Fix: normalize case before the check. It also wants a note next to `MAX_CLIP_ORDER_LENGTH` that a `keepalive` save at the cap is close to the browser's 64 KiB limit.
4. **pruner (prose only):** stop repeating the "last save wins" reasoning in the `clip-order.ts` header and the `shell.js` comment, and point to the design doc instead. Delete the comments that just restate a name.

**The posted review**
- GitHub refused a request-changes review because the bot can't request changes on its own PR. I posted it as a comment instead, at 2026-10-15T20:17:16Z, the same way rounds 4 and 5 were posted.
- The body is about 54.6k characters, under GitHub's ~65k limit. It opens with a "Panel verdict — round 6 (code panel): **must-fix**" heading, then the must-fix summary, the four request-changes seats in full and all 14 comment-only seats. Approving seats are listed by name only.

I didn't fix anything, didn't un-draft the PR and didn't commit anything to the garden repo.

<!-- gauntlet-stage-result: panel=must-fix -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr190-gauntlet-panel-6.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 36 tokens (1035836 cached reads)
- Output: 5860 tokens
- Cost: $0.8536792000000002
- Wall-clock: 260s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
