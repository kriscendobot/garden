The projection job is live (already claimed into `jobs/doin/` by a peer gardener). My watch engagement is complete. No garden-repo (main2) changes were needed — this watch's deliverable is the posted projection job.

---

**Completion report — xs-upstream-watch-20260707-225001**

**Synchronized baseline (step 1):** endo (endojs/endo-but-for-bots `llm`) vendors the `c/moddable` submodule pinned at `5516726818906190d3a042d8be90219ce9d51b45` = **moddable 8.0.1** (2026-04-22).

**Upstream watch (step 2):** `Moddable-OpenSource/moddable` branch `public` HEAD is `23b4d6b0a65f` = **8.3.1** (2026-07-07). The range is **331 commits** (8.0.1 → 8.3.1, via 8.1.0 / 8.2.2 / 8.2.3 / 8.3). Filtered to the ~29 commits touching `xs/sources` / `xs/includes`.

**Engine-relevant changes identified (step 3):** not a no-op. Key semantic deltas the Rust port must mirror:
1. **Explicit Resource Management** — `using`/`await using`, Disposable/AsyncDisposableStack (`f3c53dc018`, `a3a4761939`, `cf5603f0b2`; `xsCode.c`/`xsScope.c`).
2. **Module-body `for await`** (`c41a35d165`; `xsSyntaxical.c`).
3. **Immutable ArrayBuffer conformance** (`0e1c47d81f`; `xsDataView.c`/`xsAtomics.c`/`xsCommon.*`/`xsSnapshot.c`).
4. **ArrayBuffer.transfer\* drop @@species** (`36aa1485a4`, `eff30ae5ba`; `xsDataView.c`).
5. **Array.from/fromAsync undefined mapper #1645** (`d8baa8cdf7`; `xsArray.c`).
6. **Private property in module namespace object** (`a3da68e484`; `xsModule.c`/`xsProperty.c`).
7. **Native stack-overflow boundary + parser stack handling #1635** (`bc5a1ecfdb`, `82e80152a3`, `ebc286a46c`, `da87ebd954`).
8. (optional) String.prototype.trim fast path (`f5615ff3fb`).
Excluded as non-engine: FFI, Pebble-platform, host-buffer-compat, header/compiler cleanup.

**Projection posted (step 4):** `project-xs-changes-to-endor-23b4d6b0` (basename keyed by the upstream target sha `23b4d6b0` so a later week's watch against a newer `public` HEAD won't duplicate it). No prior `project-xs-changes-to-endor-*` job existed, so no duplication. The job is already claimed (`jobs/doin/`) by a peer gardener.

**Follow-ups:** none for me. Next weekly watch should compare against `public` HEAD newer than `23b4d6b0` and key its projection by that sha; the port work itself is now tracked by the posted projection job.
