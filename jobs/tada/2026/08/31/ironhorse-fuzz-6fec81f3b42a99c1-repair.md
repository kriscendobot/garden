Job complete. Writing report.

---

## Completion report — fuzz finding `6fec81f3b42a99c1` (`differential_regexp_surface`)

**Reproduced (finding SHA `38ca1d18`).** The 4-byte minimized input `2c 2c 2c 64` (sha256 `ddd9481301bd…4c8f`, verified) folds via `gen_stage3b_regexp_program` into a nested `new RegExp(<pattern>, "").source` program (trailing byte `0x64 % 12 = 4` selects the `.source` surface). At `38ca1d18` `differential_check_with_symbols` panicked with a **result** divergence: the XS oracle returned a value truncated at its former fixed 1024-byte capture buffer, while the port (`ironhorse-vm`) returned the correct, complete 1101-byte source string.

**Root cause & fix status.** Same class as already-fixed findings `493390fc03979205` (`.toString()`), `2276f4edebdcb3bb`/`a136f9038a1001fb` (`.source`): an **oracle-side** capture-buffer truncation manufacturing a false divergence — the port was never wrong. The causal fix (grow the buffer + honest `oracle.result_truncated` skip) already landed on the standing branch; verified the exact program now returns agreement at branch HEAD (oracle captures the full 1101-byte result untruncated). **No new engine code change was required.**

**Load-bearing deliverable landed.**
- `rust/engine/ironhorse-vm/tests/finding_6fec81f3b42a99c1_regexp_source.rs` + 4 committed fixtures (`.input.bin`, `.bytecode.bin`, `.symbols.bin`, `.expected-result.txt`). Replays the exact oracle-emitted bytecode+symbols and asserts the VM completes and renders the whole `>1023`-byte `.source` string bit-exact. Builds **without** the XS oracle or `c/moddable` submodule (`cargo test -p ironhorse-vm`), so it's a permanent regression (corpus/artifacts are gitignored).

**Verification.** New test passes; full `ironhorse-vm` suite green (126 tests, 0 failures). CI `test-ironhorse` on the PR passed (56s); no checks failing.

**Branch/PR.** Committed as `test(ironhorse-fuzz): regression-lock regexp .source truncation (fuzz 6fec81f3b42a99c1)` (`4890a0a92`), rebased CAS onto the latest fork tip (`92a7cb9cc`, picking up a peer's `284de587` commit), pushed to `kriscendobot:ironhorse-fuzz-findings`. Standing PR **#1088** adopted (already existed via the `<!-- garden-job: ironhorse-fuzz-findings -->` marker); appended a documentation section for finding `6fec81f3b42a99c1`. PR remains draft (rolling findings PR).

**Notes / follow-ups.** The deployed garden root's `ensure-project-worktree.sh` lags main2 and lacks the garden-fork branch-resolution fix (`07a7d19802`) — I ran my worktree's copy to check out the fork-only `ironhorse-fuzz-findings` branch. A deploy of the root would remove that friction for future ironhorse-fuzz repair jobs. No other follow-ups.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/ironhorse-fuzz-6fec81f3b42a99c1-repair.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 104 tokens (4206403 cached reads)
- Output: 33709 tokens
- Cost: $4.009404499999999
- Wall-clock: 616s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
