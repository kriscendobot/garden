# Builder: create @endo/hex on endo-but-for-bots master — best-on-all-platforms by default + benchmark table

**Role:** builder. **Repo:** `endojs/endo-but-for-bots` (the bot's Endo fork; bot identity; direct
push). **Base: `master`** (the upstream-endojs/endo mirror) — **build on CURRENT master**: sync
endo-but-for-bots `master` to upstream `endojs/endo@master` first if stale (the standard
sync-bot-master-to-upstream step), then branch off it. `@endo/hex` is a real Endo package, so it
belongs on `master`, not the `llm` bot-branch.

**Origin of the directive:** Richard Gibson (gibson042) nudged, on the mirror-of-record, to port the
agoric hex implementation into `@endo/hex` rather than keep it in agoric-sdk. The maintainer now
directs: back-port the **benchmark for `@agoric/internal/hex.js`** to `@endo/hex`, build it, and make
the package pick the **best behavior on all platforms by default**.

**HARD SCOPE LINES:**
- Read `@agoric/internal`'s `hex.js` + its XS benchmark as a **reference only** (it exists on the
  agoric-sdk fork `kriscendobot/agoric-sdk#7` / `packages/internal`). Do **NOT** link to or comment
  on **upstream Agoric/agoric-sdk** or **upstream endojs/endo**; all artifacts on `endo-but-for-bots`.
- A future ferry upstream is a separate, human/boatman step — not part of this job.

**Build `packages/hex/` = `@endo/hex`:**
- Export `fromHex` (hex string → `Uint8Array`) and `toHex` (`Uint8Array` → hex string).
- **Best-on-all-platforms by default:** runtime-select the fastest available implementation, in
  preference order:
  1. **Native** `Uint8Array.fromHex()` / `uint8array.toHex()` (TC39 Uint8Array hex methods) where present;
  2. **`Buffer`** (`Buffer.from(hex,'hex')` / `buf.toString('hex')`) — fastest on **old Node.js**;
  3. the **"map [char-pair]"** table approach — fastest on **Moddable XS**.
  The package detects capability and uses the optimal path with **no caller configuration** required.
- Keep it SES/XS-safe (bounded loops; no engine-specific assumptions beyond the capability checks).
  Standard Endo package scaffolding (package.json, README, LICENSE, types, tests).

**Back-port the benchmark + produce the table:**
- Port the comparative benchmark from `@agoric/internal`'s hex benchmark (incl. the XS path — drive
  the XS worker via the **`@agoric/xsnap` `xsnap()` export**, Richard's preferred form, not a
  hand-rolled worker-path).
- Run it across platforms (Node-new, Node-old, XS) and input sizes, and **produce a table with
  columns: platform / size / speed / approach** — showing each approach's speed and the winner per
  cell (substantiating that Buffer wins on Node for non-trivial sizes and "map" wins on XS, and where
  native wins). Put the table in the PR description.

**Deliverable:** a **DRAFT PR on `endo-but-for-bots` (base `master`)** adding `@endo/hex` with the
default-optimal selection + the back-ported benchmark and the **platform/size/speed/approach table**.
Run local-verify (format/lint/build/test). Tests must cover each platform path's correctness and the
capability-selection fallback. Report the PR number and the table.

---
claim:
  host: endolinbot2
  gardener: 79
  claimed_at: 2026-06-30T23:29:35Z
