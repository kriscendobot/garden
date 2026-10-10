Fix round 3 for endojs/endo-but-for-bots#1435 is pushed, and CI is green on the new head `9867b28114` (`ci-wait-merge.sh` returned 0: 6 checks passed, 22 skipped, none failed).

**The must-fix item.** Only one reviewer, the pedant, requested changes: the problem heading's capitalization. I renamed it to `## What is the Problem Being Solved?`, the form that `designs/AGENTS.md` prescribes and that 135 other designs use. The pedant's suggested full title case isn't what this repo uses; the doc's other headings are sentence case.

**Should-fix items I also applied**, in `designs/moddable-10-0-0-ironhorse-port-plan.md`:
- **Gate for child 6 (critic, skeptic, decomplector):** child 6's self-check is now the only thing that enforces the gate. The `--require-tada` flag and the maintainer's look at the record are only advisory.
  - The check now accepts a later clean completion report for each re-run of a failed child, which fixes the dead end where a re-run could never unblock child 6.
  - It also requires every port PR to be merged.
  - The maintainer gets a one-line `grep` to inspect the record before promoting.
- **Child 3 and probe failures (critic, skeptic):**
  - Child 3 is re-rated from S to M.
  - New probe-failure limit for children 3 and 4: from the third failed probe, the child stops and each failure becomes its own parked follow-up job.
  - Each row's "(provisional)" label is now removed when its probe lands.
- **Spec readings (skeptic):** every expected value in a port child's tests must cite the spec step or XS diff hunk it comes from. Child 6's drift triage gets a fourth verdict, "port mismatch".
- **R08/R13 probes (critic):** they now cover revoked proxies and are re-run after child 1 merges, since child 1 changes the predicate they depend on.
- **R16 ASan check (critic):** I dropped the unsized AddressSanitizer build of the oracle. Child 6 instead compares the 10.0.0 oracle's output for that case with IronHorse's pinned output. A sanitizer build would be a separate job if the maintainer wants it.
- **Readability (ergonomist, novice, copyeditor, pedant):**
  - The children table's "Order" column is now "Child", with short names, and a note says children 1 to 5 run in parallel.
  - The garden glossary moved to the top of § Orchestration.
  - Added a generic form of the evidence `grep` and a note on what a `fail:` line means.
  - Fixed the two prose items they flagged.
- **`designs/README.md`:** the critic said the README integration was incomplete, but the milestone, graph, estimate and totals entries were already there. I only changed the estimate row from "Four S/M" to "Four M" children to match child 3's new size.

Not changed: the decomplector's suggestion to split child 6 at the pin boundary, the novice's engine-term glossary, and the other comment-only notes. None were must-fix.

The change went in as one follow-up commit, pushed with `safe-push-pr-head.sh` (`831cf71351` → `9867b28114`). The panel was not re-run; the driver posts panel-4 next.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1435-gauntlet-fix-3.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 38 tokens (1480414 cached reads)
- Output: 13779 tokens
- Cost: $1.2657668
- Wall-clock: 1462s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
