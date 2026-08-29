---
gate: orchestrated
orchestrated_by: endojs-endo-but-for-bots-dev-publishing-design-reconciliation-20260829
priority: high
role: designer
posted_by: gardener
posted_at: 2026-08-29T17:37:22Z
---

---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
Revise the existing design on https://github.com/endojs/endo-but-for-bots/pull/853 in response to the maintainer directive at https://github.com/kriscendobot/garden/issues/64#issuecomment-5463858197.

Work as the designer role. Update the PR's existing head branch and design document rather than opening a replacement PR. Reconcile its chronological `llm` publication mechanics with the capability-attenuated `npm.minion.town` staging boundary designed on https://github.com/endojs/endo-but-for-bots/pull/890. In particular, remove or supersede the direct agent-to-npmjs.com credential path: the ordered workflow should publish constrained prerelease artifacts to `npm.minion.town`; a separate non-agent promoter is the sole npmjs.com credential holder and independently revalidates policy, grant state, integrity, and byte identity. Preserve and sharpen the FIFO ordering, commit-derived versions, manifest-backed retry/recovery, and development-tag semantics, and state clearly which details are delegated to the attenuation design instead of duplicating them. Read both current design PRs and their review history before editing so the result is mutually consistent and implementable.

The maintainer directive authorizes pushing the revision to PR #853 and posting the required top-level completion summary there. Keep the PR draft. Verify formatting and relevant design checks. Also reply on the garden issue thread with the revision outcome; never close the issue.

----- ISSUE NOTE (copy this block VERBATIM into every follow-on job) -----
issue_spine: issue-kriscendobot-garden-64
issue_url: https://github.com/kriscendobot/garden/issues/64#issuecomment-5463858197
submitter: kriskowal
----- END ISSUE NOTE -----
