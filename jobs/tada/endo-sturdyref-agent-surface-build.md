Implemented and pushed PR https://github.com/endojs/endo-but-for-bots/pull/871 (draft), stacked on `build/sturdyref-bridge-6-three-party-roundtrip` at `470dbc91`.

Changed `@endo/daemon`, `@endo/agent-tools`, Lal, Fae, and Genie:
- Restricted SturdyRef inputs to lookup, maybeLookup, list, and evaluation slots; identifier/locator methods remain pet-name-only.
- Added per-turn opaque SturdyRef escrow with unknown-handle rejection and no cross-turn retention.
- Added confinement and escrow regression tests.

Real execution passed: daemon 13 tests, agent-tools 3, Lal 16, Fae 21, Genie 30 across three SES modes, plus agent-tools typecheck. Regression breaks confirmed tests fail if list/identify guards are weakened, unknown handles are accepted, or escrow clearing is removed.

Follow-up: review draft PR; Phase 4 retention/revocation remains out of scope.

Self-improvement: nothing this time.
