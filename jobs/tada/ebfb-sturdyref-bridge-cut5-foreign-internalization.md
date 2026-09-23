Inbox empty. The job is complete. Let me write the completion report.

---

## Completion Report — Bridge cut 5: foreign-SturdyRef internalization

**PR:** [endojs/endo-but-for-bots#703](https://github.com/endojs/endo-but-for-bots/pull/703) — **DRAFT**, base `build/sturdyref-bridge-4-ocapn-singleton`, head `build/sturdyref-bridge-5-foreign-internalization`. Commit `3cd5aca1d`.

### What I built (cut 5 of design #697, verbatim)
Replaced PR #541's facet-seam rejection with the design's foreign-internalization pipeline (§2), the daemon acting as B:

- **`ocapn-peer` / `ocapn-sturdyref` formula types** (mirroring the `peer` stack): the `ocapn-peer` holds the foreign session; the `ocapn-sturdyref` enlivens over it and `thisDiesIfThatDies(peer)`, so a session loss drops the cached presence and the next use re-dials.
- **`known-sturdyrefs-store`** dedup index keyed on `locationId + sha256(swissNum)` (peers on `locationId`) — repeated internalizations of one foreign grant converge on ONE formula id; never holds a swiss-num.
- **Facet-seam fallback** `resolveSturdyRefToIdWith`: local #541 binding → injected foreign internalizer → forged rejection, wired through the directory/guest/host `lookup`/`identify`/eval-endowment seams (converted to async).
- **`acceptSturdyRefUri`** on the host-only `sturdyRefs` facet + interface guard.
- The **`ocapn` identity's dial+serve client** (built only when armed): `reveal` (normalized to `string|Uint8Array`), `enliven`, `provideSession`, `materializeFromUri`, `formatUri`; `locationToLocationId` promoted onto the `@endo/ocapn` surface.

### Confinement property preserved (load-bearing)
- **No-location:** the OCapN capability/client/netlayer are a daemon-core singleton, never vended through a facet; `acceptSturdyRefUri` is host-only (a confined guest has no `sturdyRefs` method); `locate` returns only the `endo://…?type=ocapn-sturdyref` locator, never the foreign peer locator or secret; cross-peer enliven is daemon-side only.
- **No-identification:** random, location-free local formula ids; the dedup index is daemon-private. Secrets never appear in any rejection.

### Real-execution evidence
- **`ocapn.test.js` (10/10 pass locally):** an **armed OCapN identity dials a foreign peer over a real `tcp-test-only` netlayer and fetches** the exported value (`ping → pong`); missing/revoked swiss-num rejects **without naming the secret**; unarmed `enliven`/`provideSession` reject; URI accept/export round-trips (string + byte swiss-nums).
- **`known-sturdyrefs-store.test.js` (6)** + **`foreign-sturdyref.test.js` (7)** pass: dedup convergence, self/foreign/forged/revoked branches, secret-free rejection.
- **`endo.test.js`** full-daemon test added (accept → dedup → identify → name-write → locate, no foreign-locator leak; guest confinement) — runs in CI.
- **`tsc` clean (0 errors); `eslint` adds 0 errors.**

### Scope boundary / follow-up
The daemon threads no production netlayer yet, so its own client stays **unarmed by default** (cut-4's provisional default; *which netlayers arm* is the maintainer's open question). All durable machinery is wired and tested; the live dial+fetch is proven at the OCapN-identity layer. **Daemon-side netlayer arming is the tracked follow-up** cut 6 (three-party round-trip) will need. The full-daemon suite could not boot in this sandbox (better-sqlite3 native build blocked + unix-socket path-length limit on the deep worktree path) — CI runs it.
