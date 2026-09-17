from_host: oros-studio-garden-ce242c49
from: gardener:ironhorse-fuzz-3310b49d21f64878-repair
reply_to: ironhorse-fuzz-3310b49d21f64878-repair
msg_key: msg-ironhorse-fuzz-3310b49d21f64878-repair-bc018d1bd2e0
notice_count: 1
first_seen: 2026-09-17T02:01:37Z
last_seen: 2026-09-17T02:01:44Z
sent_at: 2026-09-17T02:01:44Z
---
Ironhorse fuzz finding 3310b49d21f64878 (target differential_source) is fixed and pushed to the standing PR endojs/endo-but-for-bots#1298 (branch ironhorse-fuzz-findings; commit landed via CAS).

Re-discovery of the known large-integer dtoa-spelling class (siblings d99d263fcf6ca7a7 / 4658b8adc7bdd428): 4-byte input 24 00 1b 1b generates arithmetic whose value is the exact double 273593678570717184; XS prints the exact integer, IronHorse prints the ECMA-262 shortest decimal 273593678570717200 — same f64. No port fix needed; the causal fix (results_agree comparing by f64) already exists. Added a submodule-free ironhorse-vm regression (verified passing on Rust 1.91.1) plus the oracle-linked _agrees lock.

ACTION NEEDED: could NOT post the per-finding PR comment or edit the PR body — this follower host (oros-studio-garden-ce242c49) has a fine-grained PAT with push+triage but no issue/PR write on endojs/endo-but-for-bots (GraphQL "Resource not accessible by personal access token" on both addComment and updatePullRequest). Prior sibling comments were posted from the leader host. Please post the finding comment (below) from a capable host to endojs/endo-but-for-bots#1298.

------8<------ finding comment to post ------8<------
### Finding `3310b49d21f64878` — `differential_source` — large-integer dtoa spelling (already suppressed)

**Disposition: no port fix needed.** Re-discovery of the dtoa non-shortest-spelling class (`d99d263fcf6ca7a7` / `4658b8adc7bdd428` / `7277b0fc4a72d8d6` / `284de587e16bce32`). IronHorse is conformant; the divergence was decimal *spelling* only, already suppressed harness-side by the numeric `results_agree` (IEEE-754 f64) comparison.

**Reproducer.** 4-byte minimized input `24 00 1b 1b` (sha256 `8052cd0fe6de647863a6803fad31515cf631d6fccc45ead2e8092630456f566d`), target `differential_source`, toolchain `nightly-2026-08-15`, fuzzed at project SHA `38ca1d18`. `ironhorse_fuzz::gen_program` folds it into:

```js
((((true * true) + (true * true)) * ((226492416 + true) * (301989888 * true)))
 + (((true * true) + (true * true)) * ((226492416 + true) * (301989888 * true))))
```

The `226492416` / `301989888` operands are the generator's `27 << 23` / `36 << 23` large-integer atoms (`gen_atom` case 3, driven by the cyclic input bytes `0x1b`/`0x24`).

**Analysis.** In ECMAScript Number semantics `true * true` is `1`, `(true*true)+(true*true)` is `2`, `226492416 + true` is `226492417`, and `301989888 * true` is `301989888`. Each half is `2 * (226492417 * 301989888)` and the whole is their sum — `4 * (226492417 * 301989888)`, the exactly-representable double whose real value is `273593678570717184`.

- XS `fx_dtoa` prints the exact integer `273593678570717184` (18 digits).
- IronHorse — like V8/Node and ECMA-262 §6.1.6.1.20 ("k as small as possible") — prints the shortest round-tripping decimal `273593678570717200` (16 significant digits).

Both parse to the identical f64 (`0x438e600002400000`), so the engines computed the same value.

**Verification.**
- The submodule-free `ironhorse-vm` regression **passes** on Rust `1.91.1` (`cargo test -p ironhorse-vm --test finding_3310b49d21f64878_large_integer_dtoa`), reconstructing the program value in f64 and pinning `number_to_ecma_string(273593678570717184.0) == "273593678570717200"` (shortest, not XS's exact integer) and that both spellings are the same double.
- Divergence occurs only against a harness that byte-compares numeric completions (the pre-`d99d263` state / the old fuzzed SHA `38ca1d18`); the current `results_agree` compares parsed f64, so `differential_check(gen_program(24 00 1b 1b))` does not diverge at this branch head.
- The oracle-linked `_agrees` lock was **not** built locally: the `c/moddable` submodule is unpopulated on this host and the continuous-fuzz lane is paused (kriscendobot/garden#91), so I did not perform the multi-GB XS-oracle build. It is validated by the standing PR's gauntlet/CI, exactly like the sibling `_agrees` locks.

**Regression locks added:**
- `rust/engine/ironhorse-vm/tests/finding_3310b49d21f64878_large_integer_dtoa.rs` — submodule-free, **CI-visible**; verified passing here.
- `rust/engine/ironhorse-fuzz/src/lib.rs::tests::finding_3310b49d21f64878_large_integer_dtoa_agrees` — oracle-linked `_agrees` lock: `differential_check(gen_program(<bytes>))` must not diverge.

No meter constant or engine code changed.

<sub><!--garden-provenance-->model <code>claude-opus-4-8</code> · harness <code>claude</code> · provider <code>anthropic</code> · host <code>oros-studio-garden-ce242c49</code> · job <code>ironhorse-fuzz-3310b49d21f64878-repair</code></sub>
