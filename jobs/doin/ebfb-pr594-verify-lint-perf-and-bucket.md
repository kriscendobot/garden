# PR #594 — verify lint performance; bucket the lint jobs if per-package regresses (maintainer directive)
Repo: endojs/endo-but-for-bots (bot). PR #594 — *chore(lint): lint per package to avoid the
typescript-eslint project-service ceiling* — DRAFT, base `master`, MERGEABLE/CLEAN —
https://github.com/endojs/endo-but-for-bots/pull/594.
kriskowal (2026-07-02T04:04Z, comment 4862087129):
> Please verify, but this will likely be a big step backward for performance since tsc will do a lot of
> duplicative effort. Perhaps we can group the lint jobs into reasonably sized buckets?
Task:
1. **VERIFY the performance — actually MEASURE.** Time the **per-package** lint (this PR's approach) vs the
   baseline (pre-PR whole-tree lint), and quantify the duplicative `tsc`/project-service effort per-package
   incurs. Verification-integrity: real numbers from real runs, not an assertion (this is exactly the kind
   of claim that must be measured).
2. If per-package **regresses** (as kriskowal expects), **revise to group packages into reasonably-sized
   BUCKETS** — batches large enough to amortize tsc/project-service startup, small enough to stay under the
   typescript-eslint **project-service ceiling** that motivated the PR. Tune the bucket size empirically;
   report the sweet spot. If per-package turns out fine, say so with the numbers.
3. Update #594 to the chosen approach (per-package vs bucketed) and confirm CI/lint still passes.
4. Reply on #594 with the **measurements** (baseline vs per-package vs bucketed timings, the ceiling
   behavior) and the decision. Base `master`; bot fork; no upstream contact.

---
claim:
  host: endolinbot2
  gardener: 98
  claimed_at: 2026-07-02T04:06:17Z
