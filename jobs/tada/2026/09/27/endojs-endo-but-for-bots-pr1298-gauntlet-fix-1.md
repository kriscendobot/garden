## Gauntlet fix round 1: endojs/endo-but-for-bots #1298

I applied the panel's only must-fix and five should-fixes, pushed them as follow-up commits, and CI went green (34 checks, 0 failed) on head `76502b591`, which includes all my commits.

**Must-fix (integrator):** the PR title and description now say the differential check compares Numbers by their exact double rather than by string. The new title is "Ironhorse continuous-fuzz findings (regression locks; differential compares Numbers by exact double)". The description has a new "Behavior change" section covering the `xs-oracle` fields and `results_agree`, and notes that the test262 runner is not yet converted.

**Should-fixes applied** (pushed to `kriscendobot:ironhorse-fuzz-findings` with `safe-push-pr-head.sh`):
- **Spell-check against the spec (spec-keeper, corner-prober, archivist):** when the oracle reports an exact double, `results_agree` now requires IronHorse's output to match the spec spelling of that double exactly. Before, it only checked that the output parsed back to the same number, so `"-0"`, exponent-form and non-minimal spellings slipped through. New tests cover those cases plus `Number.MAX_VALUE` and the smallest subnormal. The oracle tuple layout is now documented.
- **CI constraint:** CI compiles `comparison.rs` alone with a bare `rustc --test`, so it can't import other crates. My first version did, and `format-ironhorse` failed. The fix computes the spec spelling in `lib.rs` (`oracle_spec_spelling`) and passes it in.
- **Fixture names (purist, integrator):** renamed the five `finding-<id>-input.bin` fixtures this branch added to `finding-<id>.input.bin`. The one hyphenated fixture that was already on the base is left alone.
- **Prose (thesaurus, typist):** dropped "load-bearing" from three test headers. Ellipses in numeric and byte-string truncations are now ASCII `...`. Ellipses inside quoted regex sources stay as `…`, because `...` there would read as three wildcard characters and change the meaning.
- **Formatting:** applied the pinned rustfmt to formatting drift in the fuzz loop's newest commits.

Before pushing, the pinned `fmt --check` (1.88) and clippy (`-D warnings`) were clean. The ironhorse-fuzz lib tests passed (90), as did all ironhorse-vm `finding_*` tests and the standalone `rustc --test` of `comparison.rs`. I posted a summary comment on the PR (issuecomment-5855268910).

**Follow-ups (should-fix, not done this round):**
- Move the ~15 copied regexp/dtoa generators into `ironhorse-vm/tests/common`.
- Collapse the program `(226492416 * 226492416)`, which is locked three times.
- Squash and regroup the commits. That isn't safe while the continuous-fuzz loop keeps appending to this branch.
- Switch `ironhorse-262`'s `build_dual_run` to the exact-double comparison; it still compares by raw string.

**Note for the driver:** the fuzz loop pushes to this branch every few minutes, and each push cancels the in-flight CI run. Later panel and CI rounds will keep hitting the same moving head.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1298-gauntlet-fix-1.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 134 tokens (6762684 cached reads)
- Output: 29421 tokens
- Cost: $2.9140528
- Wall-clock: 4830s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
