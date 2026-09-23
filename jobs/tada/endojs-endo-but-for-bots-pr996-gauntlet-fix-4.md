The fix is pushed and CI is terminal-green. The job is complete.

## Completion report

**Stage:** Gauntlet FIX round 4 for endojs/endo-but-for-bots PR #996 (`design(daemon): worker constraint model`), head `kriscendobot:design-worker-constraint-model`.

**What I did:** Read the panel-4 request-changes verdict and applied its must-fix items once to the design doc (`designs/worker-constraint-model.md`) plus this design's own index entries, committed as one review-feedback follow-up (`2f0fddf75`), pushed via `safe-push-pr-head.sh` (advance mode, `ce058dd01..2f0fddf75`), and watched CI to terminal GREEN (5/5, 0 failed).

**Must-fix items addressed:**
- **Endor reconciliation (critic, skeptic):** rewrote the `daemon-endor-architecture.md` bullet to state plainly that endor is Active and *supersedes/deletes* `WorkerFormula.kind` (remapping to `platform`), colliding with this design's zero-churn `kind` preservation. Added an ownership decision (runtime axis = `kind`'s engine successor; endor's `platform` = supervision sub-axis), stated `kind`/`runtime`/`platform` are three mutually-exclusive spellings of one on-disk slot, and added **Open Question 8** for the land-order sequencing.
- **Fail-closed serviceability (skeptic):** injected `daemonEnv.serviceableRuntimes` (assembled at bring-up from the backends that act on the runtime axis) as the named fact the gate closes on, with the resolver (pre-`formulate`) as the locus. Threaded through the seam bullet, mermaid, Passability item 3, and the `ResolvedWorkerRuntime` comment.
- **Four-axis reuse rule (ergonomist):** stated worker reuse per axis uniformly (reuse iff every supplied axis satisfied, else mint or reject) in `provideWorkerId`.
- **Gate placement (copyeditor, novice):** recast § The Seam to run `resolveWorkerConstraints` *before* `formulate`, removing the contradiction with Open Question 3.
- **Em-dashes / typist glyphs (pedant):** removed all 119 em-dashes and the arrow/ellipsis glyphs from the design and its README/ARCHIVE index entries.

**High-consensus should-fixes folded in:** defined `canonicalize` as the projection `encode` inverts (so the round-trip property holds over its own generator); reworded `metered`/`retention` as input-only rather than a formula-carried capability bit; restated the host-independence property over the real write path so it no longer contradicts the one-arg `encodeWorkerConstraints` signature.

**Changed:** `designs/worker-constraint-model.md` (+271/-170 across the three files), `designs/README.md`, `designs/ARCHIVE.md`.

**Follow-ups:** Per the stage contract I did not re-run the panel; the driver re-posts panel-5. Open Question 8 (endor vs. this design land-order) is a genuine maintainer/PR-sequencing decision now recorded for the next round.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr996-gauntlet-fix-4.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 3 on 2 host(s)
- Input: 154 tokens (10490600 cached reads)
- Output: 63817 tokens
- Cost: $10.0568955
- Wall-clock: 1516s
- Model(s): claude-opus-4-8 ×3

<!-- garden-usage-end -->
