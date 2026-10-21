## Gauntlet fix round 4: endojs/endo-but-for-bots PR #1517

I applied every finding from the latest panel verdict (review 5596598557) and pushed one follow-up commit. CI is green: all 30 checks finished with no failures, and `ci-wait-merge.sh` returned rc 0. No pre-pass block came with this job, so the panel review was the source. Per the job spec, I did not re-run the panel.

**Commit `95bd5f655`** on `design/invitation-enclosures` ("docs(daemon): address invitation-enclosures panel round 4"), pushed with `safe-push-pr-head.sh` in advance mode (3362ab16f → 95bd5f655).

Changes to `designs/invitation-enclosures.md`:
- **Locality (critic and skeptic):** an enclosure now counts as "local" when the daemon's `isLocalId` check accepts it. That covers both the daemon's own node and agent keys registered with this daemon, so a guest's coupon is local. The design no longer compares nodes directly. The test plan now covers retention for both local cases and confirms that remote enclosures add no retention link.
- **One durable commit (decomplector):** I removed the "creation intent" record, its rollback steps and the startup recovery scan. The formula table and the pet-name table live in the same SQLite database, so creation is now one transaction that writes the invitation formula and the correspondent's name binding together. Both database backends can do this through `exec`. In-memory and graph updates follow the commit, and cancelling the replaced invitation comes after that. I updated the rollback text, the ownership table, the implementation-ownership list (adding `manager-database.js`) and the fault-injection tests to match.
- **Atomic resolve-and-pin (skeptic):** the design now looks up each enclosure name and pins the result inside the formula-graph lock. Edge removal and collection take that same lock, so a concurrent `remove` either makes the lookup fail or finds the formula already pinned. A new test removes the source name at each point around the lookup.
- **Unshipped prerequisite (skeptic):** the text no longer says the guest-native design "already records" invitation state. It now says that durable state machine and the `{ status }` results are planned but not yet shipped. The phasing section requires slice 3 to land after them (or after commits that deliver them in the same PR). Slices 1 and 2 depend only on code that has already landed.
- **State sketch (novice):** I added a diagram showing the records on each daemon as an invitation goes from pending, to accepted with a receipt, to a re-drive after restart. It appears before the re-drive discussion.
- **Copyedits:** I named the input record (`InvitationEnclosureNames`) separately from the output record (`InvitationEnclosures`) and defined "invitation incarnation" where it first appears. In `designs/README.md` line 612, "Its 2-3 days" now reads "The invitation-enclosures estimate of 2-3 days fits…".

The British-spelling and cliché checks found nothing in the new commit. No follow-ups beyond the panel-5 run, which the driver posts.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1517-gauntlet-fix-4.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 52 tokens (1933854 cached reads)
- Output: 15646 tokens
- Cost: $1.3937868000000002
- Wall-clock: 1100s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
