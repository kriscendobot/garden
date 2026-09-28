Finding `bc3d0df623811a38` was a fault in the test harness, not the engine. The Ironhorse port gives the right answer, so there was no engine defect to fix and no engine code changed. I added two regression tests to the standing branch and documented the finding on PR #1298.

**What I checked**
- The prior attempt had left no commits and no PR comment for this finding, so I started from scratch.
- I rebuilt the 4-byte input from the journal's `input_base64`; its sha256 matched `b2e8860d…c1e5`.
- **At the finding SHA `38ca1d18`, it reproduces.** `cargo +nightly-2026-08-15 fuzz run differential_regexp_surface <input> -- -runs=1` panics with a result mismatch against the XS reference ("oracle") build. The input produces a `new RegExp("…", "").source` read of a nested `\s{1,3}`/`\W{1,3}`/`\n{1,3}`/`b{1,3}` alternation, which returns 1036 bytes. The oracle's string is exactly the first 1023 bytes of Ironhorse's. This is the known 1 KiB truncation problem: the old XS shim copied results into a fixed 1024-byte buffer.
- **At the standing branch tip, the same command exits 0.** The branch already contains the oracle fix, `7fae4aea2f` (a larger buffer plus a `result_truncated` flag).

**What changed** (commit `f221f47b09`, pushed to `kriscendobot:ironhorse-fuzz-findings`)
- `ironhorse-vm/tests/finding_bc3d0df623811a38_regexp_source.rs`: replays the saved bytecode and symbols for this input without needing the XS submodule. It checks that the program completes and returns the full 1036-byte result exactly.
- The fixtures are `ironhorse-vm/tests/fixtures/finding-bc3d0df623811a38.{input.bin,bytecode.bin,symbols.bin,expected-result.txt}`.
- `ironhorse-fuzz/tests/finding_bc3d0df623811a38_regexp_source.rs`: runs the exact input through the XS oracle. It checks that the oracle no longer truncates the result and that both sides agree.
- Both tests pass locally, and `cargo fmt --check` is clean.

**PR and review**
- `ensure-pr.sh --find-only` found the standing PR endojs/endo-but-for-bots#1298 already open, so nothing new was created.
- I posted a comment on it describing the finding and its disposition: https://github.com/endojs/endo-but-for-bots/pull/1298#issuecomment-5865280989
- For the required review, I didn't post a new gauntlet. `endojs-endo-but-for-bots-pr1298-gauntlet-panel-3` is already queued in `jobs/todo` and not yet claimed. When it runs it checks out the live PR head, which includes this commit.

No follow-ups are needed.

## Panel-head freshness

Disposition: **review required**. The last completed panel reviewed `558a9b7d`; this job presented `f221f47b092db0d178f8edf669b4afbdf8df2060`. The old panel verdict does not cover the current head. No gauntlet was staged; the maintainer received a deduplicated stale-review action.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/ironhorse-fuzz-bc3d0df623811a38-repair.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 15 on 3 host(s) (9 unmetered)
- Input: 42 tokens (1315445 cached reads)
- Output: 9816 tokens
- Cost: $1.019953 (9 engagement(s) unpriced)
- Wall-clock: 1952s
- Model(s): claude-opus-4-8 ×4, claude-opus-5-5 ×2

<!-- garden-usage-end -->
