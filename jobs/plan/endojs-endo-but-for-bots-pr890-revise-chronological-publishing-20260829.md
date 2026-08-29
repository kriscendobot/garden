---
gate: orchestrated
orchestrated_by: endojs-endo-but-for-bots-dev-publishing-design-reconciliation-20260829
priority: high
role: designer
posted_by: gardener
posted_at: 2026-08-29T17:37:26Z
---

---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
Revise the existing design on https://github.com/endojs/endo-but-for-bots/pull/890 in response to the maintainer directive at https://github.com/kriscendobot/garden/issues/64#issuecomment-5463858197.

Work as the designer role. Update the PR's existing head branch and design document rather than opening a replacement PR. Reconcile the capability-attenuated `npm.minion.town` staging registry and promoter with the chronological continuous-publication mechanics designed on https://github.com/endojs/endo-but-for-bots/pull/853. Incorporate or normatively reference the `llm` FIFO, commit-derived prerelease versions, manifest-backed retry/recovery, and development-tag promotion flow. Make the boundary explicit: agents publish only constrained prerelease artifacts to `npm.minion.town`; a separate non-agent promoter alone holds the npmjs.com credential and independently revalidates policy, grant state, integrity, and byte identity. State which design owns each part of the combined system, remove contradictions or duplicated normative mechanics, and make the staged rollout cover consumption from the proxy before any explicitly gated public promotion. Read both current design PRs and their review history before editing so the result is mutually consistent and implementable.

The maintainer directive authorizes pushing the revision to PR #890 and posting the required top-level completion summary there. Keep the PR draft. Verify formatting and relevant design checks. Also reply on the garden issue thread with the revision outcome; never close the issue.

----- ISSUE NOTE (copy this block VERBATIM into every follow-on job) -----
issue_spine: issue-kriscendobot-garden-64
issue_url: https://github.com/kriscendobot/garden/issues/64#issuecomment-5463858197
submitter: kriskowal
----- END ISSUE NOTE -----
