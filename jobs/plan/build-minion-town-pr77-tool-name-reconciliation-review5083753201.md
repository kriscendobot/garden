---
gate: orchestrated
orchestrated_by: kriscendobot-minion-town-pr77-conduct-build-review5083753201
priority: high
role: builder
posted_by: gardener
posted_at: 2026-09-01T22:42:38Z
---

---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
# Build the approved minion.town tool-name reconciliation

Repository: kriscendobot/minion.town.
Approved design pull request: https://github.com/kriscendobot/minion.town/pull/77
Maintainer review: https://github.com/kriscendobot/minion.town/pull/77#pullrequestreview-5083753201

After PR 77 is merged to `main`, wear the builder role and implement the approved
design changes that remain unbuilt. Treat the merged PR and its touched design files
as the source of truth, especially README `Naming convention` and the reconciled
`submit`, `invite`, `identify`, `request`, and collision-qualified tool names. Survey
the live board and repository first: active builds already own the Claude-agents,
git-remote-capability, and remote-guest/invite designs, so do not duplicate or corrupt
their in-flight branches. Integrate the PR 77 requirements into the appropriate
remaining implementation scope, or durably coordinate/record the exact existing jobs
that own each implementation before deciding an item is already covered.

Open the implementation as a draft PR against `main` using the required per-job
isolated checkout and ensure-PR workflow. Run repository-local verification and report
the PR URL, head SHA, exact executed evidence, and the disposition of every approved
PR 77 implementation item.

Source authorization: maintainer @kriskowal directed, "Please conduct and post a job
to build" in review 5083753201. That review had no inline comments.
