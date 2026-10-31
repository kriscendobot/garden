PR #1543 was already out of draft at the head the panel passed, so this stage made no change and I did not run `gh pr ready`.

**The un-draft check:**
- **Before any action:** state OPEN, isDraft false, headRefOid `2866a26dbfe791e9a0ed771d52ad727e826d32da` (the head the panel passed).
- **After the advisory review:** isDraft false and the same head.

**Advisory appellate pass:** I ran a light Sonnet review (`claude -p`) over the PR diff. It is advisory only and did not block anything. It found these possible gaps:
1. **Evidence overstated.** The docs say the subscription route is "closed" and that tokens are "rejected", but the only test used a fake token.
2. **Old "subscription" wording left behind.**
   - The README row for `endo-claude-inference-backends` still describes subscription mode.
   - The new adapter is modeled on `subscription-share.js`, which the course correction says to delete.
3. **Sandbox requirement dropped without comment.** Lal and Fae now run in-process on mail from any sender. The design never addresses the OS sandbox the older docs require (`endo-claude` Decision 6) or the `@endo/inference` check on where a prompt came from.
4. **Mail can drain the budget.**
   - There is no sender allowlist or per-sender limit.
   - The deferred queue has no bound except retry exhaustion.
   - All of an owner's agents share one cap, so mail to one agent can starve the others.
5. **Revocation is described two ways.** "Reattach" waits for in-flight turns to finish before revoking, while "Durable grant identity" cancels in-flight requests.
6. **The subagent-spawning permission is undefined.** It is checked by default but relies on a spawner from a separate, unwritten design. It may also amount to the implicit provider sharing the doc says it forbids.
7. **Request allowlist gaps.**
   - Built-in server tools that bill separately are not excluded.
   - The doc doesn't say whether `count_tokens` counts against limits.
   - Dollar reservations use pinned prices, so a stale price list under-reserves.
8. **Dates and numbers don't match.**
   - README and doc dates disagree.
   - The M8 window overlaps M7.
   - The week totals don't add up.
   - The M3 "4–5 weeks" line was annotated but not corrected.
9. **Migration order and leftover links.**
   - Migration tooling (phase 7) comes after the go-live steps.
   - Owners with no API key leave records parked with no expiry.
   - The README still treats the stdio MCP server as live.

**Follow-ups:** Most worth acting on are the sandbox omission (3) and the mail-driven budget drain (4). Fixing those needs a new fixer job on #1543, which is the maintainer's call. I posted nothing to the PR.

<!-- gauntlet-stage-result: undraft=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1543-rereview-20261031-2866a26dbfe7-gauntlet-undraft.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 8 tokens (178485 cached reads)
- Output: 1855 tokens
- Cost: $0.43150900000000003
- Wall-clock: 97s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
