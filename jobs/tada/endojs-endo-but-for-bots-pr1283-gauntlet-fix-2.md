CI is GREEN (rc 0). The bounded waiter confirmed `total=29 failed=0 → CI GREEN`. The fix stage is complete.

## Completion report

**Job:** endojs-endo-but-for-bots-pr1283-gauntlet-fix-2 — gauntlet FIX round 2 for PR #1283 (`design(ironhorse): benchmark-established computron baseline regime`), a design-doc PR.

**Panel verdict applied:** The round-2 panel aggregation (2026-09-16T06:31:59Z, disposition **must-fix**) named exactly three concrete blocking items: critic's two findings and decomplector's finding 1 (echoed by skeptic/copyeditor). I applied all three to `designs/ironhorse-computron-benchmark-baseline.md`, once, then stopped (did not re-run the panel).

1. **F4 exception (critic, finding 1)** — Gate 3 previously *fully suppressed* its time-class-equals-computron-class check for `known_divergent` loads, leaving zero wall-clock coverage on the three worst-metered loads. Replaced total suppression with a **non-regression bound**: the record now pins the currently-measured already-bad per-doubling time ratio, and gate 3 asserts the measured ratio must not exceed it beyond the noise margin — so a *fresh* time-side regression stacking on F4 is still caught. Propagated to Design-decision #7 and Phased-execution step 4.

2. **Mechanical hold (critic, finding 2)** — The doc claimed a `blocked_on` edge "or a GitHub hold label" **guarantees** no coverage gap; the label mechanism doesn't exist in this repo and neither blocks a human GitHub-UI merge. Rewrote the section to scope honestly: the `blocked_on` edge binds only the fleet's automated conductor path, the human-merge window is closed by the body note plus maintainer awareness, and a hard human-merge guarantee would need a branch-protection required-check this repo lacks (out of scope). Propagated to Open-questions and Phased-execution step 7.

3. **Fitted-model determinism (decomplector, finding 1)** — The "bit-for-bit reproducible on any host" claim rested only on exact-integer *inputs*. Added an explicit requirement that the fit use **exact rational/integer arithmetic, not `f64` regression** (committing the reduced rational), and cross-referenced it from § Design.

**Push:** Committed `05722230a` (design file only; unrelated warm-cache noise left untouched) and pushed to the PR head `design/ironhorse-computron-benchmark-baseline` via `safe-push-pr-head.sh` (advance mode, `be68d13ca..05722230a`).

**CI:** Bounded wait (`GARDEN_CI_DEADLINE_SECS=3600`, `--no-merge`) returned **rc 0 — CI GREEN** (total=29, failed=0; docs-only change so 22 skipped by path filters, `lint`/`zizmor`/`changes` passed).

**Follow-ups:** None from this stage. The driver re-posts panel-3 next; remaining should-fix/comment-only items (copyeditor grammar nits, pedant citation-form/heading consistency, novice orientation glosses) were not in the must-fix set and were left for a later round if the panel escalates them.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1283-gauntlet-fix-2.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 58 tokens (2401268 cached reads)
- Output: 15881 tokens
- Cost: $2.532172
- Wall-clock: 961s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
