Done. All work is complete and verified.

## Completion report

**Finding `407764ab1120ed1a`** (`differential_regexp`, 3 bytes `14 7f 5c`) — reproduced, classified, regression-locked, and documented on the standing PR.

**What I found**
- Reproduced the crash at the fuzz SHA `38ca1d189` (the `llm` base) from the durable artifact file (sha256 verified, never inlined): `regexp differential divergence vs XS pin: match meter ironhorse=21629566976 pin=154730496`.
- The bytes fold into a 1067-char, **backreference-heavy** pattern (`\2`,`\4`,`\8`,`\11`… to optional/unset capture groups), flag `s`, over `"abbab"@1`. Matching dispatches **330041** steps → raw meter `330041·65536 = 21_629_566_976`, past `2³²`.
- Diagnosis: `ironhorse − pin = 21_474_836_480 = exactly 5·2³²`, and `pin == ironhorse & 0xFFFFFFFF`. This is the **oracle's 32-bit match-meter truncation** — the *same class* as finding `5d122a6fc10babd9`, already fixed on the standing branch by `c8497fd8` (widening the oracle meter fields to 64-bit end to end). The port was always correct.
- Built a probe against the **standing branch** head (which carries `c8497fd8`): both engines report the identical full-width meter, **DELTA = 0**. The fuzzer re-found the class only because it fuzzes the `llm` base, which predates the fix. **No new engine or oracle change is warranted.**

**What changed**
- Added a load-bearing regression: `rust/engine/ironhorse-vm/tests/finding_407764ab1120ed1a_regexp_meter_overflow.rs` — replays the exact generated pattern through the port's `compile`+`match_regexp`, asserting no panic and the full-width meter pinned bit-exact (a 32-bit wrap would fail it). Builds without the oracle or the `c/moddable` submodule. Distinct in shape from the `5d12` regression (non-capturing groups only) — this one guards the **backreference dispatch path**. Embedded pattern sha verified against the generator output.
- Committed, rebased over a peer's concurrently-landed finding (`7289e31`), pushed to `kriscendobot:ironhorse-fuzz-findings` with `--force-with-lease` CAS.
- Adopted standing PR **#1088** via `ensure-pr.sh` (marker verified present) and posted a finding writeup as a PR comment.

**Verification**
- Local: 106 ironhorse-vm lib tests + all 7 finding regressions pass.
- CI: `test-ironhorse` on the push **passed** (54s).

**Follow-ups (not blocking)**
- Systemic: the campaign keeps re-discovering already-fixed harness classes because it fuzzes `llm`, not the standing branch. Dedup by finding-id prevents re-posting the same input, so it's bounded, but merging the standing branch's oracle fixes toward `llm` (or fuzzing the standing head) would stop the re-discoveries. Out of scope for this repair job.
- Memory updated: added the match-meter 32-bit-truncation sub-class to `ironhorse-fuzz-oracle-truncation-class`.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/ironhorse-fuzz-407764ab1120ed1a-repair.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 120 tokens (5594641 cached reads)
- Output: 46417 tokens
- Cost: $5.2199975
- Wall-clock: 943s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
