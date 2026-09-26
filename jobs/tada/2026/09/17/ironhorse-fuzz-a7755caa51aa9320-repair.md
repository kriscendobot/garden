Job complete. My commit is the standing branch tip.

## Completion report — finding `a7755caa51aa9320` (`differential_source`)

**Disposition: already-suppressed dtoa large-integer spelling class — no port change needed.**

**What I did**
1. Verified the 3-byte reproducer `2d f7 60` (sha256 matches `8e9d2a47…f7cf31`) against both the decoded artifact and the durable leader-host copy.
2. Decoded it through `ironhorse_fuzz::gen_program` to the program `((~((~2071986176) * (~2071986176))) * (~((~2071986176) * (~2071986176))))` (`2071986176 = 247 << 23`), evaluating (JS Number/ToInt32 semantics) to the exactly-representable double `22799472811573248` (bits `43543ffffb800000`), which exceeds 2⁵³.
3. Confirmed the divergence is spelling-only: XS `fx_dtoa` → `22799472811573248`; ironhorse → the ECMA-262/V8 shortest form `22799472811573250`; both parse to the same double. Same class as `d99d263fcf6ca7a7` / `4658b8adc7bdd428` / `3310b49d21f64878`.
4. Built the **full XS oracle** (symlinked the pinned `c/moddable` from `.garden-state`, `CARGO_TARGET_DIR`+`TMPDIR` under the worktree for noexec /tmp) and ran `cargo +nightly-2026-08-15 fuzz run differential_source <input> -- -runs=1` → **exit 0** directly. Confirmed `results_agree` already compares numeric completions by f64 bits, so the finding reproduces only at the old fuzzed SHA `38ca1d18`.

**What changed (commit `d92733049f` on `ironhorse-fuzz-findings`)**
- `rust/engine/ironhorse-vm/tests/finding_a7755caa51aa9320_large_integer_dtoa.rs` — submodule-free, CI-visible; pins `number_to_ecma_string(value) == "22799472811573250"`. Passes.
- `finding_a7755caa51aa9320_large_integer_dtoa_agrees` in `ironhorse-fuzz/src/lib.rs` — oracle-linked `differential_check` lock (local; oracle crates excluded from CI). Passes.
- Fetch/rebase/CAS pushed clean on attempt 1 (`11d3bc1866` → `d92733049f`); confirmed remote tip.
- Adopted the standing PR **endojs/endo-but-for-bots#1298** (open, draft, frozen base `llm-387ea66`) via `ensure-pr.sh --find-only`; posted a documenting comment for this finding.

**Notes / follow-ups**
- Did **not** stage a gauntlet — maintainer-triggered under the manual-gauntlet regime (matching sibling repairs).
- The warm worktree left an unrelated yarn-dirtied `packages/floot/package.json` (unicode-escape → em-dash); not mine, autostashed by the rebase, never committed.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/ironhorse-fuzz-a7755caa51aa9320-repair.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 2 on 1 host(s) (1 unmetered)
- Input: 78 tokens (3035479 cached reads)
- Output: 27970 tokens
- Cost: $3.1428115 (1 engagement(s) unpriced)
- Wall-clock: 949s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
