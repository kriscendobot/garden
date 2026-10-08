---
role: builder
tier: mentor
arc: garden-upkeep
handler-timeout: 10800
---
<!-- garden-promoted-from-plan: gate=orchestrated priority=normal at=2026-10-08T04:28:37Z cleared=none -->

---
role: builder
tier: mentor
fallback-tier: minion
arc: garden-upkeep
handler-timeout: 10800
dispatch: automatic
---
**Role: builder.** Child 2/3 of orchestration `review-docket-20261008`: build the review docket exactly as `designs/review-docket.md` specifies (child 1's output, on main2). If that design landed as an open-questions PR still awaiting the maintainer, build only the parts its open questions don't touch, and list what you deferred.

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

**Deliverables (garden repo, push to main2 directly):**
- the intake address and the deterministic regenerator
- the retirement detector
- the journal-root priorities/docket document and its generator
- the date-indexed archive layout
- producer switch-over for every current review-request producer
- the proxy auto-clear exemption
- any systemd unit/timer, wired leader-only via `is-main-host.sh` and the deploy unit reconciler
- tests, an operator page under `context/operations/`, and inventory updates in CLAUDE.md and README if a role or skill is added

`/tmp` is noexec on these hosts, so tests need an exec-capable `TMPDIR`. Deploys roll through the canary. **Don't touch maintainer inbox contents yet;** child 3 does the migration.
