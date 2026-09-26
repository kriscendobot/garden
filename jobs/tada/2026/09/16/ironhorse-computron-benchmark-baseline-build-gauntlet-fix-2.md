FIX round 2 complete for endojs/endo-but-for-bots PR #1283 (design PR: benchmark-established computron baseline regime).

## What happened

**Concurrency note:** a prior claimant of this same job had already pushed a partial panel-2 fix (`05722230a`) covering the officially-designated blocking set — critic's two findings (honest merge-hold scoping; gate-3 non-regression bound for `known_divergent` loads) and decomplector's fitted-model determinism (exact rational arithmetic). Rather than duplicate, I re-parented onto their head and layered the **remaining** request-changes and should-fix items from the *other* round-2 panel comment that they had not addressed.

**My commit (`ae42c8dc9`) added:**
- **Class-band table** (skeptic, request-changes): band centers for the size-dependent classes (`log n`, `n*log n`) now derived per ladder step from the closed-form asymptotic — a single static two-sided row false-fails a correct implementation at a ladder extreme.
- **Schema field marking** (decomplector, request-changes): each `computron-cost-model.json` field tagged gate-input (authoritative) vs provenance (descriptive-only).
- **Hold sequencing** (skeptic): the `blocked_on` hold is now phased-execution step 1, not a late step.
- **Ergonomist should-fixes:** split boolean `known_divergent` from `divergence_ref` string; named gate 3's harness (`computron_faithfulness_bench`); reconciled the CLI to a single `--write-baseline` verb; renamed `computron-baseline.json` → `computron-cost-model.json`; defined `C(n)` vs `C_model(n)` at first use.
- **Skeptic premise fix:** corrected the `golden_computrons.rs` claim; **novice:** glossed "oracle" at first use; **staleness signal** for `known_divergent`; copyeditor/pedant prose (README relative pronoun, comma fixes); markdown-link design citations; typist-friendly code points.

**Push:** advanced `origin/design/ironhorse-computron-benchmark-baseline` `05722230a` → `ae42c8dc9` via `safe-push-pr-head.sh`.

**CI:** GREEN for head `ae42c8dc9` — 7 SUCCESS, 22 SKIPPED, 0 failed (code lanes correctly skip on a design-only change).

**Follow-up:** none. Stopped here per the fix-stage contract (did not re-run the panel; the driver re-posts panel-3).

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/ironhorse-computron-benchmark-baseline-build-gauntlet-fix-2.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 174 tokens (10295325 cached reads)
- Output: 60673 tokens
- Cost: $8.203465500000002
- Wall-clock: 1456s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
