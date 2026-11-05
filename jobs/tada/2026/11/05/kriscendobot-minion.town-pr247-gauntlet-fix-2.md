Applied every finding from the latest panel verdict (review 5779456509, seven seats) to `designs/ordered-gutter-context-menu.md` in one follow-up commit, `aaaad640` on `design/ordered-gutter-context-menu`. It was pushed with `safe-push-pr-head.sh` and `ls-remote` confirms the head.

**Verification**
- **CI:** `ci-wait-merge` returned rc 0 (GREEN, 1 of 1 run). The bot PAT can't read `statusCheckRollup`, so this comes from the Actions runs API; commit statuses and non-Actions checks weren't visible.
- **Gates:** `pre-push-gates --probes-only` passed all 10 stages. A full gates run printed nothing and I didn't capture its exit code, so only the probes count as evidence.
- **Not executed:** this is a design-only change, so nothing in it has been run. The new test obligations are in § 7 for the builds.

**Must-fix items**
- **critic (Freeze):** Freeze is now #201's existing New Clip power, with no new lifecycle right, ladder rung, or freezer facet. A table specifies its effect on the space, upgrade, attenuation, clone, rename, and destroy, and it ships in increment 5. I also replaced the invented "clone/destroy rights" with a table of what each action needs.
- **skeptic (serialization):** a per-owner daemon formula, the catalog, now serializes all per-tab sessions. It keeps one queue, at most one durable intent, and a durable `version`, and § 7 adds simultaneous-tab and restart tests.
- **skeptic (registration):** `@sites.register` is now in the create protocol, as stage, intent, register, bind, finish. A crash rolls forward; a definite refusal discards. Destroy ordering is specified too.
- **decomplector:** a table separates who owns each operation from each store's commit point and who resumes it. `entryId` is now exactly the registration id.
- **ergonomist:** added an always-visible, keyboard-operable More actions button, a confirmed Freeze... flow naming target and consequence, and a full alternate-powers dialog covering selection, cancel, empty or unreadable inventory, and failure.
- **novice:** added a Problem and goals section, and the transport table now gives reasons in words and links the rubric.

**Should-fix and style items**
- New § 5.1 reconciles this design with #230's hash-based methods.
- Legacy order migration is now idempotent, with a marker, and reports ambiguous entries.
- `operationId` and receipts are defined.
- "eject" is removed from the order rules, because #230 rung 7 only changes the view.
- CapTP is expanded on first use, and the em dashes and middle dot are gone.

**For the next panel and the maintainer**
- **Freeze scope:** Freeze is narrower than the old text implied. It doesn't stop a #142 controller holder from upgrading.
- **Clone shares Freeze:** because rung 2 clones `back` by reference, a clone shares the New Clip's space, so freezing one freezes both. The confirmation dialog states how many clips share it.
- **Unproven assumptions:** two claims are design assumptions that the new tests must prove: re-registering a directory reaches the same registration, and a formula incarnates once per daemon.
- **#230 not updated:** #230 is still open and its text is unchanged. This design records the supersession on its side only, so #230 should be reconciled when it next moves.
- **Parked builds:** the parked `ordered-gutter` inc2 to inc5 jobs read the design from this PR, so they will pick up the larger scope, including the catalog in inc2 and inc3.

I didn't re-run the panel; the driver posts panel-3.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr247-gauntlet-fix-2.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 30 tokens (1247251 cached reads)
- Output: 35173 tokens
- Cost: $1.8807502
- Wall-clock: 807s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
