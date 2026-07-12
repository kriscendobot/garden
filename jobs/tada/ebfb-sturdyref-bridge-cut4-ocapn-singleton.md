The work is complete. Let me compose the completion report.

---

## Completion report

**Job:** Bridge cut 4 — the closely-held `ocapn` singleton (design `sturdy-refs-cross-peer-bridge`, PR endojs/endo-but-for-bots#697), repo `endojs/endo-but-for-bots`.

**Delivered:** DRAFT PR **endojs/endo-but-for-bots#702** — `feat(daemon): the ocapn identity singleton (SturdyRef bridge cut 4)`. Base `build/sturdyref-bridge-3-daemon-mint-export` (stacked on cut 3), head `build/sturdyref-bridge-4-ocapn-singleton`. **Kept DRAFT** per instructions. Affected package: **`@endo/daemon`**.

**What changed:**
- New **`ocapn` singleton formula type** (`packages/daemon/src/ocapn.js`): a distinct Ed25519 keypair generated at formulation and persisted in daemon key/value state (so the identity survives restart), the self peer-locator derived from it (`designator` = base32 public key, `transport` = configured netlayer), and the daemon's OCapN client EXPORT surface (the cut-3 exporter) built over that real self-location. Wired into `daemon.js` (preformulate + root + `make` entry + exporter now sourced from the identity); `#541`'s placeholder location removed; local-tier `mintSturdyRef` untouched. Registered in `formula-type.js` and `types.d.ts`.

**Maintainer gate:** Both cut-4 open questions were unanswered (PR #697 no comments, inbox empty), so I adopted the conservative provisional defaults, stated them prominently in the PR body, and messaged the maintainer via the liaison: **(a) distinct-by-default identity** (no `endo://` node-key reuse) and **(b) no production netlayer armed by default** (tcp-test-only stays test-only). Both reversible while draft.

**Confinement preserved (no-location):** the `ocapn` formula is a daemon-core singleton with no pet name and no host/guest facet accessor — no worker or guest can reach the OCapN capability or a netlayer handle; minting still crosses only an opaque grant handle.

**Real-execution evidence:**
- `test/ocapn.test.js` — 5 unit tests / 10 assertions, all passing (self-location round-trips a keypair-derived designator + transport, defaults to the unarmed marker, self-minted SturdyRef enlivens locally, identity persists across restart, distinct-by-default).
- `test/sturdyref-store.test.js` (cut 3) still green; `test/formula-type.test.js` (alphabetical-order check) green.
- `tsc` clean; `eslint` clean on the new module (the `safe-await-separator` warning was fixed).
- The `endo.test.js` confinement sweep and persistence path were exercised end-to-end against the **real daemon** via a short-path harness (the deep worktree path exceeds the AF_UNIX `sun_path` limit locally; CI paths are short) — mint through the real `ocapn` singleton succeeds, confinement holds, and the grant/identity survives a restart and still serves.

**Follow-ups:** Cut 5 (foreign internalization, arming a netlayer) and cut 6 (three-party round-trip) remain in the design's cut table. Sent the liaison a self-improvement note capturing three reproducible daemon-test environment walls (native-dep build via prebuild-install, `.bin` exec denial → invoke via node, AF_UNIX path-length workaround) for a possible builder directive or skill.
