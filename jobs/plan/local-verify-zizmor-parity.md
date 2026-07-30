---
model: gpt-5.6-terra
tier: minion
gate: deferred
priority: low
role: builder
posted_by: shepherd
posted_at: 2026-07-30T01:20:17Z
---

---
tier: minion
dispatch: automatic
---
# local-verify: cover the zizmor workflow audit (CI parity gap)

Parity follow-up from job endojs-endo-but-for-bots-pr778-shepherd.

CI on endojs/endo-but-for-bots gates on zizmor at `persona: pedantic` +
`min-severity: low` (`.github/workflows/zizmor.yml`). PR #778's head
aac89e41e failed zizmor at push time: three stale
`actions/checkout@34e11487 # v4` pins whose version comment no longer
matched the commit the `v4` tag resolves to (the `stale-action-refs`
time-bomb; see roles/shepherd/AGENT.md field note 2026-07-20).

A local zizmor run would have flagged this before the push — verified:
`zizmor --persona pedantic --min-severity low .` reproduces and
validates the check locally (zizmor 1.25.2 is on the garden host PATH at
~/.local/bin/zizmor) — but `skills/local-verify` has no zizmor coverage
(grep for 'zizmor' in skills/local-verify/ and scripts/ is empty).

Extend local-verify so repos that gate on zizmor run the same audit
locally before push (detect `.github/workflows/zizmor.yml`, mirror its
persona/min-severity inputs), closing the coverage gap per the
maintainer's 2026-07-20 parity policy: any lint/test CI failure is a
defect in our anticipation automation.
