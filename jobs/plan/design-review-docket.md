---
gate: orchestrated
orchestrated_by: review-docket-20261008
priority: normal
arc: garden-upkeep
posted_by: producer
posted_at: 2026-10-08T04:17:00Z
---

---
role: designer
tier: mentor
fallback-tier: minion
arc: garden-upkeep
dispatch: automatic
---
**Role: designer.** Child 1/3 of orchestration `review-docket-20261008`: design the garden's **review docket**, a dedicated, automatically maintained review queue for the maintainer. Write it as `designs/review-docket.md` in kriscendobot/garden (main2).

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

**The design must settle:**
1. **Role and name.** The maintainer suggested "secretary (or more thematic role name)". The garden's review machinery is judicial (panel, jurors, solicitor, barrister, justice, appellate), so consider names in that theme, such as **clerk** of the court keeping the **docket**. Recommend one.
   - Decide whether it is a deterministic script, like the sysop and orchestrate.sh, with no LLM in the regeneration loop, or a role. Prefer deterministic. If summaries need prose, keep that out of the hot path.
2. **Intake.** A dedicated address, such as an inbox doer `inbox/clerk/` or a bus kind, that every producer of review requests uses: conductor "needs maintainer approval", review-budget-reached, the stale-panel-head disposition, changes-requested verification, design PRs with open questions.
   - Name every current producer and how each switches over.
   - **Exempt docket entries from the proxy's PR-comment auto-clear by construction**, so they never sit in the maintainer inbox for auto-clear to touch.
3. **Retirement.** "Receiving a review automatically drops the review from the review board." Detect a maintainer review (APPROVED, CHANGES_REQUESTED or COMMENTED by a journal maintainer, or merge/close) using the existing approval-reconciler/receipt-watcher signals, and drop the entry.
   - Say how a review that requests changes routes back to a fixer, and how the PR re-enters the docket after the fix.
4. **Regeneration.** Every intake or retirement rebuilds ONE summary document of all open review requests. Order it by the accountant's arc ranks and milestones, then by what each review **unblocks for the foreman** (for example, a merge that releases a blocked plan, a milestone gate, a dependent stack).
   - Each entry shows: the PR URL, arc and milestone, what it unblocks, the ask (approve / decide / re-review), CI state, a one-line summary, and age.
5. **Placement.** A prominent document at the **journal root**, shared by the clerk and the accountant (for example `PRIORITIES.md`). It holds the priority stack, arc slices and milestones (from the accountant's config), plus the review docket, or links one sibling root doc to the other. Decide which and say why.
6. **Archive.** `priorities-archive/<YYYY-MM-DD>.md` (or similar), one per date, holding a snapshot of each superseded document plus the prior hand-curated docs, with an index.
7. **Foreman link.** How a review the docket marks as unblocking feeds back into the foreman, and whether review state should affect arc headroom.

Follow the designer's open-questions rule: if real maintainer decisions remain, land via the open-questions PR per roles/designer/AGENT.md; otherwise land it bare on main2. **Do not build.** Child 2 builds from your design.
