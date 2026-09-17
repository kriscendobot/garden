Work complete. Final report:

## Completion Report — `ironhorse-fuzz-3310b49d21f64878-repair`

**Finding 3310b49d21f64878** (target `differential_source`) is a re-discovery of the known **large-integer dtoa-spelling class** — no port defect; the causal fix already exists in the harness.

### What I did
- **Recovered & verified the input** from the journal `input_base64` (`JAAbGw==` → 4 bytes `24 00 1b 1b`, sha256 matches `8052cd0f…`).
- **Traced the generated program** (replicated the pure `gen_program`/`gen_expr`/`gen_atom` generator in a throwaway binary): `((((true*true)+(true*true)) * ((226492416+true)*(301989888*true))) + <same again>)`, where `226492416`/`301989888` are the generator's `27<<23`/`36<<23` atoms.
- **Computed the value analytically**: `4 * (226492417 * 301989888)` = the exactly-representable double **273593678570717184** (`0x438e600002400000`). XS's `fx_dtoa` prints the exact 18-digit integer; IronHorse prints the ECMA-262 shortest round-tripping decimal `273593678570717200` — **same f64**. The current harness `results_agree` compares parsed doubles, so it does not diverge at head; the crash reproduced only at the older fuzzed SHA `38ca1d18` (pre-`d99d263fcf6ca7a7` byte-comparison).

### What changed (commit on standing branch, amending PR #1298)
- `rust/engine/ironhorse-vm/tests/finding_3310b49d21f64878_large_integer_dtoa.rs` — submodule-free regression pinning `number_to_ecma_string(273593678570717184.0) == "273593678570717200"`. **Verified passing on Rust 1.91.1** (`cargo test -p ironhorse-vm --test …`).
- `rust/engine/ironhorse-fuzz/src/lib.rs` — added the oracle-linked `_agrees` lock mirroring the sibling findings.
- Both rustfmt-clean; committed, **rebased CAS**, pushed to `kriscendobot:ironhorse-fuzz-findings`; **standing PR #1298 amended** (commit now in its history). No engine/meter code changed (correctly — this class needs no port fix).

### Caveats (reported honestly)
- **Did not build the XS oracle / run `cargo fuzz`**: the `c/moddable` submodule is unpopulated on this host and the continuous-fuzz lane is paused (`kriscendobot/garden#91`). Reproduction was analytical + the submodule-free regression; the oracle-linked `_agrees` lock is validated by the standing PR's gauntlet/CI, exactly like its siblings.
- **PR comment/body not posted**: this follower host's (`oros-studio-garden-ce242c49`) fine-grained PAT has push+triage but lacks issue/PR write on `endojs/endo-but-for-bots` (GraphQL "Resource not accessible" on both `addComment` and `updatePullRequest`). I routed the full finding comment to the maintainer via `message-user` for posting from a capable host (the leader, where prior sibling comments originated). The finding is not lost regardless — it is fully documented in the commit message and both test files' doc comments, which are part of PR #1298.

### Follow-up
- Maintainer (or leader host) to post the prepared per-finding comment to `endojs/endo-but-for-bots#1298`.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/ironhorse-fuzz-3310b49d21f64878-repair.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 5 on 3 host(s) (4 unmetered)
- Input: 124 tokens (5245770 cached reads)
- Output: 48083 tokens
- Cost: $4.946420000000001 (4 engagement(s) unpriced)
- Wall-clock: 1597s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
