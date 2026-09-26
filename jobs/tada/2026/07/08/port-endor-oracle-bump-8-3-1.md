HEAD matches origin/xs2rust-endor; the only working-tree change is the intentionally-uncommitted `c/moddable` local checkout (a build artifact, gitlink deliberately not bumped). All tasks complete.

---

## Completion report

**Job:** `port-endor-oracle-bump-8-3-1` — bump the endor-oracle `c/moddable` pin from 8.2.3 (`48ee02d8cfe0`) to 8.3.1 (`23b4d6b0a65f`) and mirror the post-8.2.3 engine deltas onto the port (endojs/endo-but-for-bots, branch `xs2rust-endor`, `rust/engine`).

**What I did**

*Step 1 — bumped the oracle pin (the gate).* Populated `c/moddable` at `23b4d6b0a65f` (seeded locally from a sibling checkout at 8.2.3, then fetched the `public` delta from GitHub — verified the target sha *is* the current `public` tip). Built the C-XS oracle at 8.3.1 (compiles clean, warnings only) and **re-ran the full byte-identity / differential bar**, re-based onto the 8.3.1 oracle:
- stage-1 harness **86/86** bit-exact (result + computron)
- `compile-diff` curated corpora **1711/1711** identical, 0 divergent
- `language/expressions` **8204** identical / **0 divergent** (of 9446)
- `language/statements` **7249** identical / **0 divergent** (of 8531)
- `statements/for-await-of` **1141/1141**; `module-code` **35/35** (`top-level-await` 15/15)
- `cargo test --workspace` EXIT=0 (all suites incl. metering/computron and the module bar)

The only already-ported construct the 8.2.3→8.3.1 range touched is item 2; no other regressions surfaced.

*Step 2 — mirrored item 2 (surgical, surface existed now).* moddable `c41a35d165` (xsSyntaxical.c) sets `parser->flags |= mxAwaitingFlag` right after the `ForAwaitOf` node so a top-level `for await` marks its module awaiting (compiles async). Mirrored in `for_statement` (`endor-compile/src/parser/stmt.rs`) as `self.flags |= flags::AWAITING;`. **Proved load-bearing** per regression-evidence discipline: added `corpora-modules/top-level-await.js` (two top-level `for await` module programs); with the fix they're byte-identical to the 8.3.1 oracle, and reverting the one line makes the module byte-identity bar **fail** (2 divergent, `byte-length/endor-shorter` — the missing async-module machinery).

*Docs.* Updated `README.md` § Building the oracle (new pin + reproduction; the pin is again the current `public` tip so the shallow sha-fetch works; frictions re-pinned, API drift re-verified to still hold at 8.3.1), § Upstream moddable delta tracking (title/intro re-based to 8.3.1, item 2 flipped **Follow-up → Mirrored**, deferred items now measured against the 8.3.1 oracle, Net rewritten); `designs/xs2rust-endor-engine.md` § Ground Truth + resolved-question 9; and the `endor-oracle/build.rs` bootstrap error message. Left the ~45 metering-calibration provenance comments in `interp.rs`/`lib.rs` unchanged — they honestly record the original 8.2.3 calibration pin, and the bar confirms computron agreement still holds at 8.3.1 (rewriting them would falsely claim 8.3.1 calibration).

**What changed / where it landed**

One atomic commit `c88a1f923` pushed to `xs2rust-endor` (PR #600 head, still DRAFT): 5 files (README, design doc, stmt.rs, build.rs, new corpus file). The `c/moddable` submodule gitlink was **deliberately not** bumped (correcting it needs the separate xsnap `ffi.rs` `fxInitializeSharedCluster` arity fix); the oracle checks out the pin locally per the README. Read-only on Moddable upstream and endo; no upstream PRs or comments posted (per the job directive — the commit is self-documenting).

**Follow-ups (unchanged, now gated only on port staging, measured against 8.3.1):** items 1 (disposal-protocol runtime), 3 (immutable ArrayBuffer/DataView/Atomics), 5 (`Array.from`/`fromAsync` undefined-mapFn guard), 6 (private property in a module namespace object) remain future VM-stage surfaces the port hasn't reached; item 8 (`String.prototype.trim` fast path) is behavior-neutral / no action. All are tracked in the README delta table and land with the stage that reaches them.
