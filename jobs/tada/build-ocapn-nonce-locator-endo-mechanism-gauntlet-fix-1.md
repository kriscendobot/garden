CI is green (rc 0). All work for this fix stage is complete.

## Completion report

**Job:** FIX round 1 — endojs/endo-but-for-bots PR #1124 (OCapN formula nonce locator mechanism).

**State on resume:** A prior attempt of this same job had already applied the panel-1 must-fix items, committed them as `53af1a483` ("fix(daemon,ocapn): enforce the session miss bound, not just fire abort"), and pushed to the PR head branch `build/ocapn-nonce-locator-mechanism`. Nothing was left uncommitted; my task was to verify completeness and drive CI to terminal.

**Must-fix items and their disposition (all covered by the pushed fix commit + PR body):**
- **Miss-bound enforcement inert** (saboteur/breaker/wire-watcher/locksmith): two-layer fix — `sessionGet` now returns `undefined` before any lookup once `aborted` is set (enforcement in the locator, not in disconnect timing), and the ocapn client binds `abortSession` to the session core's real `abort()` (unplug → close → `isDestroyed`, deferred one turn so the bound-crossing miss still flushes its uniform rejection). Tests added: unit suite presents a valid id after the bound and asserts refusal; wire suite asserts the teardown callback is reached.
- **typist** (`sessionGet` `@param`): widened to `string | Uint8Array` to match the `get` it wraps; `NonceLocator.get` kept string-only with a doc note.
- **surfacer/archivist** (README): `makeLocatorForSession` documented in the `@endo/ocapn` README Quick start.
- **stylist/archivist** (stray comment): dropped the orphaned `spell-out-exempt: swissNum` header.
- **integrator** (phantom `designs/ocapn-nonce-locator.md`): the PR body now cites the real design `designs/daemon-ocapn-external-connectivity.md` §2 — integrator's own offered fix (a).

**CI:** bounded wait returned rc 0 — 28 checks, 0 failed, CI GREEN on head `53af1a483`.

**Follow-ups (not blocking, left for panel-2/embedder work):** cross-reconnect miss aggregation keyed on `remoteDesignator` (only per-connection today; module is inert/unwired into `daemon.js`); timing-parity of fast-reject vs slow-path misses; fast-check property tests (fast-checker, follow-up disposition); coverage report not verifiable in-panel.

No new commit or push was needed — the fix was already durably on the PR head and CI is green.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/build-ocapn-nonce-locator-endo-mechanism-gauntlet-fix-1.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 4 on 2 host(s)
- Input: 168 tokens (8058217 cached reads)
- Output: 57023 tokens
- Cost: $7.209457999999999
- Wall-clock: 907s
- Model(s): claude-opus-4-8 ×4

<!-- garden-usage-end -->
