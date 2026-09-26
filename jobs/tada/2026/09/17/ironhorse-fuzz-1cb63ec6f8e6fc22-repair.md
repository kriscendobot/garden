## Completion report — finding `1cb63ec6f8e6fc22` (`differential_regexp_surface`)

**Diagnosis: not a port defect — advisory computron-only surface class, no code fix warranted.**

Recovered the 2-byte reproducer `32 eb` (sha256 verified `bbb90f36…`). It folds, via `gen_stage3b_regexp_program`, into `"0a0a".search(new RegExp("(((\s{2}a?\s{2})?…)?…)?", ""))` — a `String.prototype.search` over a deeply nested optional-group whitespace-alternation pattern.

Built the full oracle stack in an isolated worktree (symlinked pinned `c/moddable` @ `23b4d6b0` from `.garden-state/ironhorse-fuzz/project`, `CARGO_TARGET_DIR` under the job worktree) and ran the exact differential body directly. Both engines complete with the byte-identical value `"0"` (pattern matches empty at offset 0 → `search` returns 0); the only disagreement is the computron count (oracle 485 vs port 540). Under meter-v4 an XS-computron gap is **advisory**, so `differential_check_meter_v4` returns `Ok(())` — the fuzz target exits 0 at the current tip. Same class as sibling surface findings `2cc2ac67ba7e9b9f` / `c6c71d428a37088c`. No meter constant was touched (that would rewrite a pinned `ironhorse-meter` release digest).

**What changed** (commit `f231f70266` on `ironhorse-fuzz-findings`, remote tip confirmed):
- `rust/engine/ironhorse-vm/tests/finding_1cb63ec6f8e6fc22_regexp_surface_meter.rs` + 4 fixtures (input/bytecode/symbols/expected-result) — submodule-free, **CI-visible** regression pinning completion + byte-identical result `"0"`; computron count deliberately not pinned (advisory). Passes.
- `finding_1cb63ec6f8e6fc22_regexp_search_cost_gap_is_advisory` in `ironhorse-fuzz` — oracle-linked `_agrees` lock (local; oracle crates are excluded from CI). Passes.
- Amended standing PR **endojs/endo-but-for-bots#1298** (fetch/rebase/CAS, clean on attempt 1) and posted a documenting comment for the finding.

**Notes/follow-ups:** No gauntlet staged (manual-gauntlet regime — maintainer-triggered). An unrelated warm-cache edit to `packages/floot/package.json` was left uncommitted. Memory updated with this seventh re-discovery of the advisory-surface class.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/ironhorse-fuzz-1cb63ec6f8e6fc22-repair.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 4 on 2 host(s) (3 unmetered)
- Input: 94 tokens (3420671 cached reads)
- Output: 24232 tokens
- Cost: $3.1971235 (3 engagement(s) unpriced)
- Wall-clock: 750s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
