---
gate: blocked
blocked_on: endo-but-for-bots-upstream-master-pin-20261006
priority: normal
posted_by: producer
posted_at: 2026-10-06T02:43:29Z
---

---
gate: blocked
blocked_on: endo-but-for-bots-upstream-master-pin-20261006
priority: normal
posted_by: producer
posted_at: 2026-10-06T00:00:00Z
tier: mentor
fallback-tier: minion
dispatch: automatic
---

---
role: shepherd
tier: mentor
fallback-tier: minion
dispatch: automatic
---

# Shepherd upstream endojs/endo's master CI to green (pinned on endo-but-for-bots)

Your predecessor (`endo-but-for-bots-upstream-master-pin-20261006`) pinned
upstream `endojs/endo`'s `master`
(`356d6e70affc5adfd35cd65adda758119521ec5f`) to a frozen branch
`master-356d6e7` on `endojs/endo-but-for-bots` and opened a draft PR against
it. Read its completion report for the exact PR URL and head SHA — do not
assume, confirm the PR's live state first.

**Known failures to chase** (from the real check-runs on the pinned commit,
confirmed before this chain started): `viable-release`, `test (22.x,
macos-15)`, and `lint`. Everything else was already green on that commit.
Per `roles/shepherd/AGENT.md`: pursue all tests passing by whatever means
necessary until green or a genuine impasse; fix small things inline; escalate
(`next: fixer`/`weaver`/`designer`/`liaison`, per the role's classification)
only at a real impasse, not merely because the fix touches several files.

This is upstream `endo`'s own codebase, not this fleet's usual `llm` work —
expect unfamiliar per-package conventions; that alone is not an impasse, keep
going. If a failure turns out to need a design/public-API decision only
upstream's own maintainers could make, that's a genuine `next: designer`/
`next: liaison` escalation — say so plainly rather than forcing a fix.

Once green, report the green run URL and state clearly that this is parked on
the pinned fork branch, not merged or ferried anywhere — carrying this back
to the real `endojs/endo` is a separate, later, explicitly-authorized step
this job does not take.
