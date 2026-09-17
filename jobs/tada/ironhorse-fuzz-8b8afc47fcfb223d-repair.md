Everything is complete and verified. The remote standing branch tip is my commit `2470d91b5a`.

---

## Completion report — finding `8b8afc47fcfb223d` (target `differential_regexp`)

**Diagnosis: already-fixed oracle-harness artifact, not a port bug.**

- **Reproduced the finding.** Recovered the 2-byte input (`80 c7`, sha256 verified `cea5043…`) to a file without inlining it. Extracted the pure-Rust `gen_regexp` generator: the bytes fold into a deeply nested `.*`-alternation pattern (nine `(.*.*.*)(?:[a-c][a-c])(.*.*.*)` copies in three groups), flags `i`, subject `"babababa"` at offset 1. Built and ran `cargo +nightly-2026-08-15 fuzz run differential_regexp` at the fuzzed base SHA `38ca1d18` — it **reproduced** with divergence `match meter ironhorse=4357881856 pin=62914560`.
- **Root cause = regexp match-meter 32-bit truncation.** `4357881856 − 62914560 = 2³²` exactly and `pin == ironhorse & 0xFFFFFFFF`. The pattern backtracks 66496 metered steps → raw 16.16 meter `4357881856` (> `u32::MAX`). The port meters into `u64` and is **correct** (`matched=false`); the pre-`c8497fd8` XS oracle truncated the pin's 64-bit `meterIndex` into a 32-bit field. Same class as findings `5d122a6f`/`8275793b`/`407764ab`/`637d760b`.
- **The oracle fix is already merged.** Current `origin/llm` `xs-oracle` already carries `match_meter_raw: u64` (via `c8497fd8` / merged PR #1088). The finding does **not** reproduce on the standing branch or on current llm — only at the stale fuzzed SHA. **No port change is needed or warranted.**

**Deliverable landed:**
- Added the load-bearing, submodule-free regression `rust/engine/ironhorse-vm/tests/finding_8b8afc47fcfb223d_regexp_meter_overflow.rs`, pinning the port's full-width meter (`4357881856`) for this exact case. Test passes; the full `ironhorse-vm` test suite compiles clean.
- Committed with a thorough analysis message and pushed via fetch/rebase CAS to the active standing branch `ironhorse-fuzz-findings` — commit **`2470d91b5a`**, on top of a peer's concurrent test (`f3d8863981`) added 3 minutes earlier. Remote tip confirmed.

**Why no PR was adopted/opened:** there is currently **no open standing PR**. Gen-1 PR #1088 merged 2026-08-31; the journal bumped to `generation: 2`/`ironhorse-fuzz-findings-2` but that branch/PR were never created — active work continues on the re-cut gen-1 branch, and `ensure-pr.sh` refuses to open one because base `llm` is floating (needs a frozen `<base>-<sha>` snapshot). I documented the finding via the commit message and **messaged the maintainer** with the resolution plus this state inconsistency and the 2026-09-09 IronHorse-pause context.

**Follow-ups (for the maintainer / fuzz-service owner, surfaced via message-user):**
1. Reconcile `standing.md` generation state vs the actual branch (`ironhorse-fuzz-findings-2` doesn't exist; work is on `ironhorse-fuzz-findings`).
2. Decide whether to open a frozen-base gen-2 standing PR — regression tests are currently accumulating on a PR-less branch, invisible to CI/review.
3. Note that `-repair` jobs are being dispatched despite the nominal all-IronHorse pause (kriscendobot/garden#91).

Memory updated with this fourth re-discovery and the standing-PR/generation state trap. Scratch worktrees cleaned up.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/ironhorse-fuzz-8b8afc47fcfb223d-repair.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 3 on 1 host(s) (2 unmetered)
- Input: 98 tokens (4163315 cached reads)
- Output: 51019 tokens
- Cost: $4.532161500000001 (2 engagement(s) unpriced)
- Wall-clock: 1221s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
