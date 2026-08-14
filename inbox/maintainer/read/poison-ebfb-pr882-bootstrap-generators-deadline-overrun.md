from_host: endolin-garden2-5bcdff64
from: reaper:endolin-garden2-5bcdff64
sent_at: 2026-08-01T09:13:18Z
poison_base: ebfb-pr882-bootstrap-generators
poison_signature: deadline-overrun
notice_count: 1
first_seen: 2026-08-01T09:13:18Z
last_seen: 2026-08-01T09:13:18Z
---
POISON job PARKED in jobs/plan/ (held, gate=go-ahead) after 1 DEADLINE-OVERRUN cycles on endolin-garden2-5bcdff64.
Its handler hit its OWN wall-clock budget every cycle (rc=124, elapsed≈GARDEN_HANDLER_TIMEOUT=2400s):
this job EXCEEDS THE HANDLER BUDGET and would be killed identically on every requeue,
so the reaper surfaced it after 1 overrun cycles (not the full 5-cycle poison threshold).
The work is preserved at jobs/plan/ebfb-pr882-bootstrap-generators; it stays HELD until a human promotes it
(promote-plan.sh ebfb-pr882-bootstrap-generators) or removes it. Triage: split the job, raise GARDEN_HANDLER_TIMEOUT
for this work, or fix what makes it run long.
Original job base: ebfb-pr882-bootstrap-generators

--- original job body ---
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
