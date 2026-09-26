Everything is landed and verified. Both halves are delivered, tests pass, the change is on `main2`, and the cluster is closed.

## Completion report

**Job:** `review-improve-architectural-boundary-ownership` — close the `architectural-boundary-ownership` review-miss cluster (member `endojs/endo-but-for-bots#1018`, review 5069628663), where a design assigned engine/supervisor/persistence/crank responsibilities ambiguously and six design-panel rounds checked local consistency without ever assembling a cross-boundary ownership map.

### (a) Prevention in producing work
- **New reusable, checkable artifact** `skills/ownership-map/SKILL.md`: a `## Ownership map` design section — one table row per boundary with columns **mechanism / policy / durable state / lifecycle-commit authority / value crossing**, followed by the four ownership questions (who owns persistent state, commit/discard, restart/replay, execution classification) and the **inner/outer naming check** (an inner mechanism must not be named for an outer-layer lifecycle concept — `CrankOutcome` → `ExecutionOutcome`).
- `roles/designer/AGENT.md` now **requires** that map, before review, for any design spanning ≥2 components/layers (Skills list + a new Operating norm). It is a checkable artifact, not a memory aid.

### (b) Durable review-cycle sensing
- **Deterministic design-panel pre-pass** `scripts/jobs/gardening/ownership-map-signal.sh`: detects a design spanning ≥2 architectural layers, reports whether an ownership-map section is present, and surfaces fused inner/outer name candidates (the `CrankOutcome` shape). Mirrors `related-design-state.sh`/`detect-banners.sh` discipline (no LLM; fires the lens, never infers "clean"; fail-toward-review on undetermined). Fixed a real `pipefail`+`SIGPIPE` bug (`printf | grep -q` → here-strings) found during bring-up.
- `panel.sh` wires it as a design-panel pre-pass that hands the evidence to the **decomplector** and guarantees the seat runs (mirrors the integrator/related-design and archivist/banner injections).
- `roles/jurors/decomplector/AGENT.md` gains an **Ownership-map reconstruction** operating norm (reconstruct the map, answer the four ownership questions, run the inner/outer naming check; must-fix on a two-owner responsibility, an unowned durable datum, or an inner type named for an outer concept; do not fault a coherent explicit map merely for naming layers).
- `skills/panel-hints/SKILL.md` § Design-panel routing documents the sensor.

### Re-litigation evidence
Against the historical PR #1018 design at `efcf04a26d1114d1d1c90f52895eec7e8f49fc54` (`designs/ironhorse-panic.md`), the sensor **fires**:
```
ownership-map layers=4 groups=[engine,supervisor,persistence,lifecycle] map_present=no fused_candidates=[CrankOutcome] flag=yes
ownership-map-verdict=attention   (exit 10)
```
The exact catch: the **design-panel ownership-map pre-pass** injects evidence into the **decomplector seat's Ownership-map reconstruction check**. The evidence deterministically identifies the engine-side `CrankOutcome` as a fused outer-into-inner name candidate and directs the seat to the transcript/embargo/commit ownership conflict via the four ownership questions. **Negative control:** a multi-component design carrying an explicit coherent `## Ownership map` and no fused name still engages the seat (exit 10) but is `map_present=yes flag=no` with confirm-coherence evidence — it does not fail merely for naming multiple layers.

### Tests run (all green)
- `ownership-map-signal-test.sh` — 14/14 (files-mode relitigation, worktree/diff-mode replay, negative control, single-layer, undetermined, and a bonus assertion against the **real** efcf04a file).
- `panel-ownership-map-trigger-test.sh` — 6/6 (end-to-end: pre-pass force-adds the decomplector with evidence; inert on a single-layer design).
- Regression: `panel-empty-diff` (14), `panel-single-round` (14), `related-design-sensing` (21), `panel-banner-trigger` (6), `library-link-scan` (25), `library-link-check` (42), `library-slug-prefix-check` (12), `test_claude_md_inventory_drift` (9), `test_double_space_sentence_separator` (8) — all pass. `shellcheck -S warning` clean on both new scripts. `bash -n` clean on `panel.sh`.

### Landed & closed
- Commit `5ba8b6f06a` pushed to `main2` (rebase-CAS, first attempt).
- Cluster closed: `review-miss-record.sh cluster-status architectural-boundary-ownership closed --improved-by "…"` → `status=closed` (verified on journal2). The historical miss record was not touched.

### Follow-ups (out of scope, noted)
- The `claude-md-inventory-drift` gate reports **pre-existing** drift unrelated to this job: `roles/americanizer`, `skills/american-english-normalization`, and `skills/claude-usage-dashboard-scrape` are on disk but absent from CLAUDE.md's inventory index. My `ownership-map` skill is correctly indexed; I deliberately did not fix the unrelated drift.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/review-improve-architectural-boundary-ownership.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 164 tokens (10271130 cached reads)
- Output: 65773 tokens
- Cost: $8.450693999999997
- Wall-clock: 1427s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
