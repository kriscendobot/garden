Fix round 1 for endojs/endo-but-for-bots#1517 is done. I applied the panel's must-fix items as one follow-up commit, `b9c751e8b` (`docs(daemon): address invitation-enclosures panel review`), and pushed it to the PR head `design/invitation-enclosures` with `safe-push-pr-head.sh`. CI finished green: `ci-wait-merge.sh` returned 0 with 30 checks and 0 failures.

**`designs/invitation-enclosures.md`:**
- **Re-drive after acceptance (critic, decomplector):** acceptance releases the edge that kept the pending invitation alive, so a later `already-joined` could not read the enclosures from it. The guest-native `accepted` state record now also stores the enclosure snapshot, written in the same transaction as the consume. I call this the acceptance receipt and gave it rules for writing, replay and discard. `already-joined` answers from the receipt, including after either daemon restarts. The ownership section and its restart tests now say this too.
- **Enclosure lifetime (decomplector):** the receipt now holds the edges that keep local enclosures alive, so accepting an invitation no longer makes them collectible. The design now states that only retention is tied to the invitation. Releasing it revokes nothing, and design decision 7 says so.
- **Rollback on creation (skeptic):** the existing code writes the correspondent name before persisting the formula, and that write already cancels any earlier pending invitation under the same name. The revised order persists the formula and its edges first and makes the name write the single commit point. I spelled out the rollback for each failure point and for a crash, and added fault-injection tests.
- **Fresh minion.town visitor (skeptic):** the coupon identifier points at minion.town's own daemon, which also serves `redeemCoupon`. The visitor passes it as data over minion.town's entry channel, so it needs no peer route. A coupon pointing at another node fails closed. I checked this against minion.town#144, and the integration test now covers a client with an empty peer table.
- **Record key types (critic, ergonomist):** the public records are now keyed by plain strings, and names are validated when they reach the daemon. The branded name type is internal only.
- **Unclear terms (novice):** the design now defines local versus remote identifiers and links that to which ones the invitation keeps alive. It also explains how the inviter tells the same agent re-driving from a different agent, by comparing the accepting handle with the bound one.
- **Wording (copyeditor, pedant):** I replaced the vague "today" with a precise reference and fixed the awkward "race two accepts" sentence. I shortened the over-long source row and rewrote the two wide tables as lists.

**`designs/README.md`:** I recounted the summary table. The original numbers were correct: the buckets sum to 250, and the two qualified rows bring the total to 252. The copyeditor misread them, so I reworded the paragraph to show the sum.

**Not changed:**
- The pedant flagged the `—` placeholder in the new README row as a comment-only finding. I kept it because the table's 12 other rows use the same placeholder.
- The dependency table's lines are still over 80 columns; no juror flagged them.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1517-gauntlet-fix-1.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 42 tokens (1407429 cached reads)
- Output: 17186 tokens
- Cost: $1.2583098
- Wall-clock: 1026s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
