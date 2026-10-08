---
gate: orchestrated
orchestrated_by: review-docket-20261008
priority: normal
arc: garden-upkeep
posted_by: producer
posted_at: 2026-10-08T04:17:24Z
---

---
role: fixer
tier: mentor
fallback-tier: minion
arc: garden-upkeep
dispatch: automatic
---
**Role: fixer.** Child 3/3 of orchestration `review-docket-20261008`: **migrate everything onto the review docket and tell the maintainer.** Wait until child 2's build is DEPLOYED on the leader: check the leader's `fleet/deployed/<leader>` sha contains it. If it isn't deployed yet, exit for retry without changing anything.

**Maintainer directive (kriskowal, liaison session 2026-10-08), verbatim:**
> I think we instead need a more sophisticated system for surfacing the review inbox. I think this means having automation that either intercepts review requests or a dedicated inbox to which review requests get dispatched, such that receiving a review automatically drops the review from the review board, and also that each additional review request triggers recreation of a summary document of all review requests prioritized according to the garden's priorities and milestones, such that reviews unblock the foreman. We can reuse the priorities designated for the accountant. It may be that this shared document between this "secretary" (or more thematic role name) and the accountant should be more prominent, at the root of the journal. Please post a job to organize this effort and consolidate the existing review requests accordingly. Send the maintainer a message with the resulting review priorities document URL. This should replace all prior review priorities documents in the journal. Prior documents should be consolidated and archived. We can create a document priorities archive indexed by date, for future reference.

**Why now:** at 2026-10-08T03:50Z the proxy's PR-comment auto-clear (`scripts/jobs/proxy.sh` § 1c; directive kriskowal 2026-07-11) archived 49 maintainer messages in journal commit `b3c8be85227`, including **26 `review-request-*` messages** a muster had just produced, and minion.town#169's request. A review request is not a dismissable PR notice. Today a request lives as one inbox message among hundreds, and nothing reorders it as priorities change or retires it when the review happens.

**Existing artifacts to supersede and consolidate:**
- journal `projects/garden/review-priorities.md` (hand-curated; last edit 2026-10-06)
- journal `pr-review-sequence.md` (journal root)
- journal `reports/maintainer-priorities-2026-09-28.md`
- the accountant's priorities: `config/apportionment` and `config/foreman-mandate` (arcs, ranks, milestones; designs/accountant-arc-apportionment.md). **Reuse these as the ordering source.** Don't invent a second priority scheme.
- the `review-request-*` messages (in `inbox/maintainer/read/` since `b3c8be85227`)
- `stale-panel-head-*` and `*-review-budget-reached` notices
- the readiness audit (`scripts/jobs/design-pr-gauntlet-coverage-audit.sh`)

**Steps:**
1. **Consolidate the existing review requests** into the docket through its intake. This includes every `review-request-*` that `b3c8be85227` (and later auto-clears) moved to `inbox/maintainer/read/`, plus live `stale-panel-head-*` and `*-review-budget-reached` items, and minion.town#169's request.
   - Re-verify each PR's live state first. Don't docket a PR that merged, closed, or already has the maintainer's review on its current head.
   - Make sure each entry ends up in exactly one place: archive any maintainer-inbox copy that the docket now owns.
2. **Fold in** `projects/garden/review-priorities.md`, `pr-review-sequence.md` and `reports/maintainer-priorities-2026-09-28.md`: carry forward any still-live ordering intent or notes.
   - Then **archive** each into the date-indexed priorities archive (dated by its last edit), and replace the original path with a one-line pointer to the new root document, or remove it per the design.
3. Regenerate the root priorities/docket document and check that its ordering follows `config/apportionment`/`config/foreman-mandate` and what each item unblocks.
4. **Send ONE maintainer message** (`send-msg.sh maintainer`, key `review-docket-live`) with the **full GitHub URL** of the root document on journal2 (`https://github.com/kriscendobot/garden/blob/journal2/<path>`). Include counts per arc, the top 5 reviews and what each unblocks, and the archive index URL.
