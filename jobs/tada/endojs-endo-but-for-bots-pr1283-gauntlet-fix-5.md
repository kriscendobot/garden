FIX round 5 complete — the panel-5 must-fix items are applied, pushed, and CI is green.

## What I did

**PR:** endojs/endo-but-for-bots #1283 (design: *ironhorse computron benchmark baselines*), a docs-only design PR on head `design/ironhorse-computron-benchmark-baseline`.

**Concurrency note:** on first push my branch had diverged — a prior claimant/peer had already pushed a panel-5 commit (`9ebbddd07`). That commit addressed the panel's *should-fix / naming* items (renamed tolerance knobs to `*_radius`, collapsed the class-band center derivation, added `divergence_baseline_commit`) but **left every explicit must-fix item open**. I reset onto it and re-applied the outstanding must-fix items on top (fast-forward, no clobber), so both bodies of work are preserved. Final commit `1cb12d817`, one file changed (`designs/ironhorse-computron-benchmark-baseline.md`; the README em-dash the pedant flagged was already swept by the peer).

**Must-fix items applied:**
- **critic/skeptic (fidelity band was an absolute cross-host timing comparison):** gate 3(b) now asserts a *dimensionless* computrons-per-second ratio against the baseline revision remeasured same-host in the same nightly run (reusing the F4 part-(ii) `divergence_baseline_commit` rebuild discipline); added `provenance.commit` as the fidelity remeasure's rebuild target; corrected the "only wall-clock gate input" claim.
- **skeptic (gate 2(b) off-ladder exactness):** off-ladder probes restricted to powers of two beyond the ladder, so `C_model(n)` stays exact-integer (an irrational `log2(n)` off-ladder would forfeit cross-host bit-reproducibility).
- **copyeditor/novice (F4 count three-vs-four):** reconciled to three loads — named-property insertion is the `for..in` load's divergence mechanism, not a fourth roster entry; standardized the `Map`/`Set` bulk-insertion load name.
- **pedant (Latin shorthand):** `e.g.`/`vs.` → plain English (11 sites).
- **novice (forward-reference ordering):** moved § The three gates ahead of § Where the baseline lives.
- **novice (no worked example):** added a worked `computron-cost-model.json` (ordinary + `known_divergent` record) making the gate-input/provenance boundary concrete.
- Plus supporting cleanups: routed the same-host remeasures through `run.py` (a bare `cargo test` can't build a reference revision — critic #4); fixed the arch-review citation path; dropped `-ly`-adverb hyphens; `host-relative` → `host-independent`; `for-in` → `for..in`.

**CI:** `ci-wait-merge.sh` → **rc 0 / GREEN** (29 checks terminal, 0 failed; `lint`, `zizmor`, change-detection pass, heavy jobs skip as docs-only).

**Follow-ups:** none for this stage. Per the gauntlet protocol I applied the must-fix items once and stopped; the driver re-posts panel-6. Several *should-fix* items remain open by design (e.g. ergonomist's fixture-home / `--write-cost-model` naming, decomplector's `computron_class`/`time_class` field split) for a future round or the implementation PR.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1283-gauntlet-fix-5.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 2 on 1 host(s)
- Input: 186 tokens (12941986 cached reads)
- Output: 77938 tokens
- Cost: $10.446523000000003
- Wall-clock: 1333s
- Model(s): claude-opus-4-8 ×2

<!-- garden-usage-end -->
