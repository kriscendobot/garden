I recorded this retrospective as **not a review miss**. The review was new direction from the maintainer, so no cluster was touched and no improvement job was posted.

**What the review was.** kriskowal's CHANGES_REQUESTED review on endojs/endo-but-for-bots#1340 (2026-09-30) has a body that only says "rsvp". Its five inline comments all sit on the four "Open Questions" that the design `designs/agent-confined-application-makers.md` asked the maintainer to decide:
- **Mounts:** require a hoisted `node_modules` layout when reading from a mount, and post a follow-up design for a mount that shows only chosen roots.
- **Archives and bundles:** keep every option reachable, and move away from precompiled artifacts where possible.
- **Trees:** keep live tree references; callers who want immutability pass a snapshot.
- **Guests:** guests may make guests, under the same metering by default.
- **Recent work:** re-check `llm` for progress on guests inviting guests.

Picking among options the design itself laid out is the maintainer's call. No seat brief, skill or standing rule encodes these answers, so no panel could have given them.

**Review history.** No gauntlet ran before this review. The designer held it back until the maintainer answered, and the viability stage ran afterwards. A panel can't answer questions addressed to the maintainer, so the missing panel didn't cause this feedback.

**One near-miss, noted but not filed as a miss.** The last comment's pointer was fair. Guest invite and accept (#1305 and #1310) merged on 09-19 and 09-21, before the design was written on 09-24, so its question about guest makers ignored work that had already landed. The maintainer only asked the bot to "consider" it, and the first-loop job scoped it out. The dismissal record says to join the `related-design-contract-cross-check` or `stale-related-design-direction` cluster if this pattern comes up again.

**The first-loop job's work checks out:**
- Commit f871ea6737 turned the four questions into design decisions, and the rsvp commit 341d74cd0 is on `llm`.
- All five inline comments got replies, and the PR is merged.
- The requested follow-up job `design-mount-root-attenuation-controller` exists, is done, and became PR #1402.

**Store change.** `review-misses/dismissed/endojs-endo-but-for-bots-pr1340-review-85c8bc95.md` is written; `review-miss-record.sh` pushed it to journal2. No garden code changed.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1340-review-85c8bc95-retro.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 28 tokens (837438 cached reads)
- Output: 6113 tokens
- Cost: $0.7913955999999999
- Wall-clock: 81s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
