---
gate: go-ahead
priority: normal
doomed: true
doom_signature: deadline-overrun
doom_count: 1
requeue_cycles: 1
deadline_overruns: 1
doomed_at: 2026-08-01T09:13:09Z
doomed_on: endolin-garden2-5bcdff64
posted_by: reaper:endolin-garden2-5bcdff64
posted_at: 2026-08-01T09:13:09Z
---
handler-timeout: 7200
<!-- liaison 2026-08-06: this job was DOOMED by the reaper after a
     deterministic deadline overrun at the 2400s default. It carried no
     handler-timeout: header and its role does not qualify for the 7200s
     builder default (landed 2026-08-01), so it was SIGTERM-killed at the
     wall on every requeue. The budget is the fix; the work is wanted.
     If it overruns 7200s too, that is a REAL overrun -- diagnose it, do
     not raise the budget again. -->

<!-- garden-promoted-from-plan: gate=orchestrated priority=normal at=2026-08-01T08:28:04Z cleared=none -->

---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
Repo: endojs/endo-but-for-bots (base `llm`)
PR: https://github.com/endojs/endo-but-for-bots/pull/882 (DRAFT, restore-xs-bootstrap-generators)

Land #882. It is load-bearing and blocks review of the whole npm-via-CAS gap family:
`rust/endo` does NOT build standalone at `llm` HEAD because the generated XS bootstraps
(`ses_boot.js`, `worker_bootstrap.js`) are missing, and their generators exist ONLY on this
branch. Two separate press ticks (2026-07-29, 2026-07-30) had to hand-generate stubs to build
at all. No CI job builds the xsnap crate, so this regresses silently.

Task: rebase onto current `llm` if needed, drive CI green, un-draft, and land.

Known gap recorded by the 07-30 press tick — report it, do not silently fix it beyond scope:
`daemon_bootstrap.js` still stubs because `bundle-bus-daemon-rust-xs.mjs` fails on Node-only
static imports (`@endo/git`, `@endo/host-spawner`); it needs the inject-backend treatment.
If that is out of scope for landing #882, say so in your report and leave it for a follow-up.

Consider whether a CI job that builds the xsnap crate is worth proposing, since its absence is
what let this regress unnoticed.

<!-- garden-deadline-overrun: 1 -->
