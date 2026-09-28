# Completion report: ironhorse-fuzz-50834e82d3af453d-repair

Finding `50834e82d3af453d` was a fault in the test harness's XS reference engine (the oracle), not in the Ironhorse port. The oracle fix is already on the standing branch, so no engine change was needed. I added two regression tests to `ironhorse-fuzz-findings`, which updates standing PR endojs/endo-but-for-bots#1298, and posted a comment there explaining the case.

**Reproduction**
- I recovered the input from the durable artifact and its sha256 matched `d1902d4a…532cb7` (4 bytes).
- The prebuilt fuzz binary on the service host did not reproduce it. It also ran clean on the earlier sibling finding `bc9529ac5818aa24`, which crashed it on 2026-09-27. It may no longer match the project SHA, so I did not rely on it.
- I built a separate checkout at `38ca1d18` and ran `cargo +nightly-2026-08-15 fuzz run differential_regexp_surface <input> -- -runs=1`. It **reproduces**: a `result:` divergence panic with exit 77.

**Cause**
- The input generates `new RegExp(<nested \s{1,3}/.{1,3}/[a-c] alternation>, "s").source`.
- The correct result is **exactly 1024 bytes**. At that SHA the oracle stored results in a fixed 1024-byte buffer and kept only 1023 bytes. Its reference value was therefore one byte short of the port's correct output, and the check reported a false divergence.
- This is the same 1 KiB truncation problem as sibling finding `baad1f22ef053213`, landing just past the old limit.
- The oracle fix, commit `7fae4aea2f` (a larger buffer plus a `result_truncated` flag), is already on the standing branch. There, the fuzz target exits 0 on this input and the oracle and port results are byte-identical.

**What changed** (commit `10394a2f3c`, pushed to `kriscendobot:ironhorse-fuzz-findings`; the fetch/rebase/push went through on the first attempt)
- `rust/engine/ironhorse-vm/tests/finding_50834e82d3af453d_regexp_source.rs`: runs in CI and doesn't need the submodule. It replays frozen bytecode and symbols and checks that the program completes with the full 1024-byte result.
- `rust/engine/ironhorse-fuzz/tests/finding_50834e82d3af453d_regexp_source.rs`: needs the oracle, so it runs locally only. It checks that the oracle captures all 1024 bytes without truncation and that the differential check agrees.
- Fixtures `ironhorse-vm/tests/fixtures/finding-50834e82d3af453d.{input,bytecode,symbols}.bin` and `.expected-result.txt`.
- Both tests pass locally.

**PR**
- `ensure-pr.sh --find-only` found the existing PR #1298, so no new PR was opened. It is a draft, based on the frozen branch `llm-387ea66`, and its head is now `10394a2f3c`.
- The explanation is posted at https://github.com/endojs/endo-but-for-bots/pull/1298#issuecomment-5864191000.

**Follow-ups**
- **Gauntlet not run:** the job asked for one, but under the manual-trigger rule only the maintainer starts gauntlets, so I didn't post one — the same call earlier jobs on this PR made.
- **Uncommitted local change:** the project checkout has a yarn-created change to `packages/floot/package.json` that isn't mine. I left it uncommitted.
- **Memory note:** I recorded that the prebuilt binary is no longer a reliable way to reproduce at the base SHA.

## Panel-head freshness

Disposition: **review required**. The last completed panel reviewed `558a9b7d`; this job presented `10394a2f3c5ba9ef85c112b92cf784d9bdf722f4`. The old panel verdict does not cover the current head. No gauntlet was staged; the maintainer received a deduplicated stale-review action.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/ironhorse-fuzz-50834e82d3af453d-repair.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 7 on 2 host(s) (4 unmetered)
- Input: 58 tokens (2060775 cached reads)
- Output: 15420 tokens
- Cost: $1.344859 (4 engagement(s) unpriced)
- Wall-clock: 909s
- Model(s): claude-opus-5-5 ×3

<!-- garden-usage-end -->
