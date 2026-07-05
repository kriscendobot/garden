The supervisor inbox was already completed, so my note was dead-lettered and will be auto-promoted (intent preserved). All charter work is committed, pushed, and green.

---

## Completion report

**Job: stage-3b child 5/9 — global string→id intern table + Object statics/verifyProperty (PR #600, `endojs/endo-but-for-bots` branch `xs2rust-endor`)**

Resumed after a reaper requeue. Reconciled the carried-forward uncommitted state, validated it (found the earlier session had committed the `in` work before validating — a stale-binary false pass; re-verified green), then finished the remaining charter item (`defineProperty`). All increments are bit-exact vs the C-XS pin `48ee02d8cfe0`, divergent=0, each its own green commit pushed to `origin/xs2rust-endor`.

**Delivered (HEAD `b2771da76`):**
- **Interning `at`/`at_2`** — computed string member access `o[k]` for any string key. A program-symbol key resolves exactly as its `o.name` static access; a genuinely-novel name interns one `fxNewSlot` and reads bit-exact `undefined`; an index string meters XS's two extra code units. Sound-gate: a boot default-key name the program never symbol-referenced self-names (unlinked-inherited ambiguity) rather than risk a wrong value.
- **`in` false-answers** — a genuinely-novel key answers a sound `false`, with per-prototype-hop metering (`fxOrdinaryHasProperty` charges one `XS_CODE_METERING` per level). Same default-key soundness gate.
- **`Object.defineProperty`** — new own data property from the canonical verifyProperty descriptor `{value, writable, enumerable, configurable}`, storing the booleans as XS's flag byte (`DONT_SET`/`DONT_ENUM`/`DONT_DELETE`). Attributes **ripple through**: `Object.keys` now filters non-enumerable properties; `getOwnPropertyDescriptor` renders the three attributes from the flag byte instead of assuming all-true. Native-body cost (`fxDescriptorToSlot` field reads + `fxOrdinaryDefineOwnProperty`) calibrated raw-exact as a single residual (622024).

**Bar met:** `built-ins/Object` dual-run **48→63 covered, divergent=0**; `language/expressions` **1064→1066, divergent=0**; verifyProperty-shaped `getOwnPropertyDescriptor`/`defineProperty` tests now covered. Curated corpus + differential fuzz arm for each new grammar; covered-grammar CI gate + all prior corpora green; `#![forbid(unsafe_code)]` intact (no unsafe added). README evidence block updated.

**Honest named skips (documented in README, not bar items — follow-on work):** `defineProperty` redefine of an existing key, partial/accessor descriptors, index/exotic keys, non-boolean attributes; `Object.keys` rendering of a `defineProperty`'d *enumerable* runtime-interned (non-program-symbol) key; `hasInstance` for built-in/literal names.

**Follow-ups / caveats:**
- The **Miri GC suite** was not run in-handler (too slow for the wall); changes are pure safe Rust reusing existing slot-allocation patterns, so CI should confirm it stays green.
- Supervisor note (`port-xs-to-rust-memory-safe-engine-s7`) was dead-lettered (inbox completed) and will be auto-promoted — intent preserved.
- The `c/moddable` gitlink was checked out to the design pin `48ee02d8cfe0` for the oracle; the superproject records `5516726…` — pre-existing discrepancy, deliberately **not** committed.
