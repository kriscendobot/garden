## Finding baad1f22ef053213: done (the Ironhorse port was already correct; regression tests added)

**Reproduction.** I rebuilt the fuzz target at project SHA `38ca1d18`, and `cargo +nightly-2026-08-15 fuzz run differential_regexp_surface <input> -- -runs=1` panicked there. The input's sha256 matched `acb62697…d284a`. The already-built binary the fuzz service keeps did *not* crash on this input, so I did not rely on it.

**Diagnosis: a bug in the XS reference oracle, not in Ironhorse.** The 6-byte input generates `new RegExp(<nested a{1,3}/b{1,3}/\s{1,3} alternation>, "").source`, which returns a 1278-byte string. At the old SHA, the XS oracle captured its result in a fixed 1024-byte buffer, so its string was cut off at about 1023 bytes. Ironhorse's complete, correct value was then reported as a mismatch. This is the same class as the earlier findings `af5b4a677483eac3` and `bc9529ac5818aa24`.

**Fix.** No Ironhorse change was needed. Commit `7fae4aea2f`, which enlarged the oracle buffer and made it report any remaining overflow explicitly, is already on the standing branch `ironhorse-fuzz-findings`. The same fuzz command exits 0 at the branch tip.

**Regression tests** (commit `dc7be5904f`, pushed to `kriscendobot:ironhorse-fuzz-findings`):
- `rust/engine/ironhorse-vm/tests/finding_baad1f22ef053213_regexp_source.rs` runs in CI because it doesn't need the `c/moddable` submodule. It replays saved bytecode and symbols from the generated program and checks the complete 1278-byte result.
- `rust/engine/ironhorse-fuzz/tests/finding_baad1f22ef053213_regexp_source.rs` needs the oracle, so it runs locally only, not in CI. It checks that the exact input still generates this `.source` case of 1307 bytes and that `differential_check_meter_v4` finds no mismatch.
- New fixtures in `ironhorse-vm/tests/fixtures/finding-baad1f22ef053213.{input.bin,bytecode.bin,symbols.bin,expected-result.txt}`.
- Both tests pass, and `rustfmt --check` is clean.

**Standing PR.** `ensure-pr.sh --find-only` found the existing PR https://github.com/endojs/endo-but-for-bots/pull/1298 (draft, base `llm-387ea66`) and created nothing new; its head is now `dc7be5904f`. I posted a comment there describing this finding and how it was resolved: https://github.com/endojs/endo-but-for-bots/pull/1298#issuecomment-5863867783

**Follow-ups:**
- **Review pass not started by me:** a review job for #1298 (`pr1298-gauntlet-panel-2`) was already on the job board, so I didn't queue another.
- **Inbox not checked at the end:** my last inbox check failed because the journal clone was offline.
- **Local-only change left alone:** `packages/floot/package.json` in the project checkout was already modified by a package install before I started. It was set aside and restored during the rebase, and I did not commit it.

## Panel-head freshness

Disposition: **review required**. The last completed panel reviewed `558a9b7d`; this job presented `dc7be5904fe7537806672425149824d82baea78b`. The old panel verdict does not cover the current head. No gauntlet was staged; the maintainer received a deduplicated stale-review action.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/ironhorse-fuzz-baad1f22ef053213-repair.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 6 on 3 host(s) (2 unmetered)
- Input: 42 tokens (1422407 cached reads)
- Output: 10621 tokens
- Cost: $1.1208294 (2 engagement(s) unpriced)
- Wall-clock: 595s
- Model(s): claude-opus-4-8 ×1, claude-opus-5-5 ×3

<!-- garden-usage-end -->
