All clear: inbox empty, tree clean (bundles stay gitignored), and PR #600 remains **DRAFT/OPEN** with head at my F2 tip `402b3f7b0e`. Job complete.

## Completion report — xs2rust-endor-stage10g-findings-fixer

**Both s37 review findings fixed, verified, and pushed as separate bar-green commits to `endojs/endo-but-for-bots` branch `xs2rust-endor` (PR #600, kept DRAFT).** Remote advanced `408ef16683 → 5e7929e70f (F1) → 402b3f7b0e (F2)`, both clean CAS pushes, no peer races.

**Setup:** isolated project worktree keyed by job base; seeded `rust/engine/target/` (`cp -al`) and the pinned `c/moddable` submodule (`23b4d6b0a6…`) from same-commit sibling `stage10f-live-captp-eval`; seeded the 3 gitignored ROOT bundles after confirming `packages/` content-identity (empty diff). The named probe file lives on host endolin-garden2 (not this host), so I reconstructed its 4 scenarios from the findings comment as proper dual-run suites.

**REPRODUCE-FIRST (done before finalizing):** stashed each fix and ran the new suites against the pre-fix binary — all four scenarios wrong-completed (endor `Return`, `result_agrees=false`; oracle throws TypeError / completes correctly): frozen-target, nonwritable-own, accessor-target, sort-shrink-len. Then restored the fixes and confirmed all flip to honest named skips.

**F1 (`5e7929e70f`) — `Object.assign` target integrity + accessors.** Routed each per-key write in `NativeMethod::ObjectAssign` through the flag machinery the `XS_CODE_SET_PROPERTY` opcode already models: an accessor governing the key (`accessor_in_chain`) or a rejected `[[Set]]` (`ordinary_write_rejected` — non-writable own data, or new key on non-extensible target) now self-names `Unsupported`. Fresh writable-data overwrite/create path unchanged (bit-exact). **Doctrine sweep completed:** enumerated every `set_own_unmetered`/`set_own_flagged_unmetered` caller — `ObjectCopy`'s target is a fresh literal, `ObjectFromEntries`/iterator/generator/JSON results are fresh, error instances and bootstrap intrinsics and the compartment `child_global` are host-controlled/fresh; **`Object.assign` was the sole guest-reachable gap.** Tests: `object_assign.rs` §5 (4 cases).

**F2 (`402b3f7b0e`) — `sort` receiver-mutating comparator.** Snapshot receiver length + present-element density before the comparator loop; at write-back, self-name `Unsupported("sort:receiver-mutated-during-sort")` on any change (or vanished entry). Snapshot reads are unmetered → unmutated path and all default sorts stay bit-exact (landed calibration undisturbed). Density half catches a constant-length hole (shrink-then-regrow). Tests: `array_sort_comparator.rs` §7 (shrink, grow, density-only).

**Bars green before EVERY push (measured at each commit):**
- Engine workspace `cargo test --workspace -- --test-threads=1`: **F1 824/0**, **F2 825/0**, EXIT=0, 61 binaries (821 baseline + 3 assign + 1 sort test fn)
- `./target/debug/compile-diff`: **1909/1909 + SYMB 1909/1909**, EXIT=0 (compiler untouched — invariant)
- Boot gate `boot_bundle_gate`: **30/0**
- ROOT `cargo test -p endo --lib`: **110/0**, EXIT=0 (real bundles, `packages/` content-identical, never committed)
- Zero new non-oracle warnings; `forbid(unsafe_code)` 7 crate roots + oracle exempt intact; VARIANT_COUNT 35 unchanged.

**Grounding:** all four probe scenarios flip from wrong completion to honest named skip vs the C-XS oracle at the pin. Inbox empty; PR #600 confirmed `isDraft:true, state:OPEN` at head `402b3f7b0e`; no PR comments or state changes made.

**Follow-ups (for the next supervisor stage, s38):** F1/F2 could later be tightened from honest-skip to full fidelity — faithfully re-entering the accessor setter and constructing the oracle's catchable `TypeError` with bit-exact metering for the frozen/non-writable throw — but that is out of this doctrine-compliant slice. Independent re-verification of both fixes via the s38 probes remains owned by the parked supervisor per its spec.
