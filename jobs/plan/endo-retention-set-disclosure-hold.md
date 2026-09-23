---
gate: go-ahead
priority: normal
posted_by: producer
posted_at: 2026-08-16T05:57:00Z
---

---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
HOLD — do not act without explicit maintainer authorization. This is a tracker for a security disclosure decision, parked deliberately so the hold is visible rather than living only in an archived inbox message.

Defect: unbound `followRetentionSet` in `packages/daemon/src/daemon.js`, confirmed on `endojs/endo` branch `llm` at `33311ae9a41d0b12ba6f0367717352b67d9032bc`. Upstream `master` (`d9923b927e9be5d158c5d003de52a3540d2c5d5c`) does NOT yet contain retention following.

Status as of 2026-08-16: reported privately to the maintainer, who asked that upstream coordination precede any public fork PR. A branch is pushed. NO PR exists on endojs/endo and none may be opened under this hold. Verified 2026-08-16: no garden-authored PR is open on endojs/endo.

Maintainer decision 2026-08-16 (liaison inbox review): KEEP HOLDING. Promote this job only when the maintainer judges upstream coordination sufficient and says so explicitly.

Related fork-side work already in flight, tracked here so it is not re-originated:
- https://github.com/endojs/endo-but-for-bots/pull/978 — fix(daemon): bind gateway followRetentionSet to the authenticated peer (OPEN, DRAFT)
- https://github.com/endojs/endo-but-for-bots/pull/979 — fix(daemon): bind the outbound gateway to the dialed peer (OPEN, DRAFT)

Residual requirement to carry into whatever lands: host `gateway()` must carry authenticated peer identity across ALL transports, so an outbound dialed peer cannot follow a third peer's retained formula numbers and then provide those cross-peer capabilities.

Provenance: carried forward by deadmail from job `ebfb-ocapn-gateway-retention-set-peer-binding`, whose doer had already completed. Inbox message 20260812T233130Z-dee31a.
