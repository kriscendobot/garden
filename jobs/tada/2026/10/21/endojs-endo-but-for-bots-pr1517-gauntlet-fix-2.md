I applied the panel's round-2 must-fixes to PR #1517 and pushed them as one follow-up commit. CI is green: `ci-wait-merge` returned rc 0 with 30 checks and 0 failures. I did not re-run the panel.

**What I worked from:** No deterministic pre-pass block came with the job. I used the latest panel verdict, the "Must-fix before merge" review posted 2026-10-21T06:17Z.

**Commit `dbceb3987`** (pushed to `endojs/endo-but-for-bots` `design/invitation-enclosures` via `safe-push-pr-head.sh`), touching `designs/invitation-enclosures.md` and `designs/README.md`:

- **novice (must-fix):** Added a "Retention model" section before "Creation and authority". It defines formulas, durable retaining edges, transient pins, and the collector (which is off by default), and says which mechanism the design uses for which job.
- **skeptic (must-fix):** The new invitation formula now stays pinned until the correspondent slot write gives it its first incoming edge. Pins are released only after that commit. Added a test that forces collection in between with collection enabled.
- **critic (must-fix, crash after persistence):** Creation now writes a durable creation intent in the same synchronous transaction as the formula and its edges. On restart, the daemon either deletes the intent (the slot committed) or removes the orphan formula, its edges and the intent. This works with collection off. Added fault-injection tests for crashes on both sides of the slot write.
- **critic (must-fix, re-drive comparison):** The authoritative check moved into the inviter's consume step. `Invitation.accept(handleLocator, expectedEnclosures?)` compares in the same transaction as the consume check, against the formula while pending and against the acceptance receipt once accepted. A mismatch fails with `enclosure mismatch` and changes no state. Older acceptors that omit the argument skip the check. `enclosures()` is now inspection only.
- **decomplector (must-fix, ownership and lifetime):** The receipt and the acceptor's `accepting` record are now plain data that keep nothing alive. Only the pending invitation's edges retain enclosures, and that ends on consume, cancel or supersede. The `accepting` record must drop the locator once it reaches `joined` or a refusal. The ownership map now has a table giving each durable copy its owner and release condition, and the Goals, "Design decisions" #5 and #7, and the test plan were updated to match.
- **decomplector (should-fix):** Added a paragraph explaining what minion.town's fragment-envelope path cannot provide: a possession check, retention while pending, and a tamper-checked acceptance.
- **copyeditor:** The README arithmetic was actually right. I re-derived the table: twelve buckets sum to 250, and the two qualified rows bring it to 252. The juror counted thirteen terms, so I spelled out the twelve-term sum to remove the ambiguity. I also applied the three wording fixes.
- **novice (should-fix):** Added a sentence separating the invitation route from minion.town's bootstrap entry channel.
- **pedant (comment-only):** Replaced the em dashes in this PR's two README rows. The rest of the table still uses em dashes, so the new rows are now the odd ones out. I turned the wide dependency table into a list and shortened an over-long row in the new ownership table.

The orthographer and thesaurus style checks found 0 candidates.

**Follow-ups:**
- The driver re-posts panel-3.
- This design now requires a guest-native behavior that `guest-native-invitations.md` does not yet state: the acceptor's `accepting` record drops the locator at its terminal transition. The two designs should be reconciled if that one is revised.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1517-gauntlet-fix-2.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 56 tokens (2164069 cached reads)
- Output: 23382 tokens
- Cost: $1.6166938000000002
- Wall-clock: 1424s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
