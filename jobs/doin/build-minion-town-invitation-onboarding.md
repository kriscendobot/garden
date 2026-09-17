<!-- garden-promoted-from-plan: gate=blocked priority=normal at=2026-09-17T21:51:10Z cleared=none -->

<!-- garden-promoted-from-plan: gate=blocked priority=normal at=2026-09-04T00:21:20Z cleared=none -->

# Build invitation-only guest onboarding for minion.town

Re-run the capability-first invitation-only guest onboarding build from
`designs/invitation-only-guest-onboarding.md` after the Endo prerequisite lands.

Gate evidence captured 2026-09-02 against `endojs/endo-but-for-bots` branch
`llm` at `1956e545d`: `EndoGuest` still has neither `invite` nor `accept` in
`packages/daemon/src/interfaces.js`, `packages/daemon/src/types.d.ts`, or
`packages/daemon/src/guest.js`; those methods remain exclusive to `EndoHost`.
The retained multiplayer and daemon tests still exercise only host-level
`invite`/`accept` calls. Do not implement or emulate an app-mediated or
host-authority fallback.

Blocked on Endo builder job
`minion-town-remote-guest-endo-cli-endo-invite-primitive`, which owns the
guest-safe invitation primitive and its two-daemon guest round-trip test.

<!-- garden-transient-elapsed: kind=signature through=0 values=2 -->

<!-- garden-reaped: 1 -->
<!-- garden-plain-retry-not-before: 2026-09-17T22:03:09Z -->

---
claim:
  host: endolin-garden2-5bcdff64
  gardener: 1
  worker_kind: monk
  tier: 
  provider: anthropic
  model: 
  claimed_at: 2026-09-17T22:03:25Z
