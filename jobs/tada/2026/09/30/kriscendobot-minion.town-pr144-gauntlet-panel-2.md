The round 2 panel on kriscendobot/minion.town#144 came back **must-fix**, and I posted the verdict on the PR.

- **Checkout and panel run:** I made an isolated checkout of the PR head `design/guest-coupons` at `d81a2fe`. I ran `panel.sh` in single-round mode against the PR's frozen base (`main-7fb38ed`, base commit `7fb38ed4b4d9`). Because the diff is design-only, it ran the design panel: 9 seats, all returned ok. `panel.sh` exited 0 with disposition `must-fix`, and the panel run was recorded in the journal at `panel-runs/kriscendobot-minion.town-144/5665f8479e65.md`.
- **Seat verdicts:**
  - Request changes: critic, skeptic, decomplector, ergonomist, copyeditor, pedant.
  - Comment only: novice.
  - Approve: orthographer, thesaurus.
- **Must-fix items:**
  - **decomplector:** the design gives the issuer more authority than § 3 says it has. § 4 and § 8 have it doing root-level work (`send`, `evaluate`, `makeDirectory`, `remove`), but § 3 says it holds only `provideGuest` and `identify`.
  - **skeptic:** in the § 6 branch where there is no guest but a coupon is present, just opening the link spends a unit of capacity. That breaks onboarding § 3.2, which says opening a link has no side effects. There is also no test for this case.
  - **copyeditor:** a sentence after a colon should start with a capital letter.
- **Should-fix items:**
  - The `redeemed` count never goes down, even after a guest is revoked.
  - It's unclear which layer runs the expiry sweep and who replays its work.
  - If a crash lands between writing the ledger row and binding the coupon's name, nothing is named to recover it.
  - `bookId` is keyed on the calendar day, so a second air-drop to the same guest that day is silently skipped.
- **Review posted:** https://github.com/kriscendobot/minion.town/pull/144#pullrequestreview-5363320324. It starts with the `<!-- garden-panel-verdict round=2 -->` marker, gives the headline items, then includes every seat's full review. It went up as a comment rather than a request-changes review because GitHub doesn't allow request-changes on your own PR; round 1 was posted the same way.

I made no garden repo changes and did no fixing or un-drafting. The next stage, the fixer, is owed.

<!-- gauntlet-stage-result: panel=must-fix -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr144-gauntlet-panel-2.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 24 tokens (652528 cached reads)
- Output: 3950 tokens
- Cost: $0.6499376
- Wall-clock: 270s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
