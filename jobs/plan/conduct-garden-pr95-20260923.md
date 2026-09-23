---
gate: orchestrated
orchestrated_by: reexport-policy-automation-20260923
priority: normal
posted_by: producer
posted_at: 2026-09-23T17:45:44Z
---

---
role: conductor
tier: mentor
fallback-tier: minion
dispatch: automatic
---

# Conduct (finalize) garden PR #95 — re-export deprecation policy design

PR #95 (`kriscendobot/garden`, head `design/reexport-deprecation-policy-gauntlet`,
base `main2-a57dd05`) is a design-open-questions REVIEW SURFACE (marked
`<!-- garden-design-open-questions -->`; the design content already lives on
`main2`). @kriskowal APPROVED it (review pullrequestreview-5294397181) and all 5
open questions were incorporated into `designs/reexport-deprecation-policy-gauntlet.md`
on `main2` at commit 7c712dafbef. The downstream build + synthetic-PR validation
(this orchestration's earlier children) completed before this child runs.

Finalize PR #95: un-draft it and complete it — YOU own the method. For an own-repo
design-open-questions PR whose content is already on `main2` over a frozen base,
that is either a merge or a close-as-resolved; pick what is correct and record why.
Bot repo (`kriscendobot/garden`) — safe to finalize. NEVER merge agoric-sdk or the
endojs/endo upstream.
