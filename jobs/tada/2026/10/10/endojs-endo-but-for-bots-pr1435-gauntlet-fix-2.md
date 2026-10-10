Round-2 fixes are pushed to PR #1435 and CI is green: `ci-wait-merge.sh --no-merge` returned rc 0, with 28 checks and none failed. I did not re-run the panel.

**What changed.** One follow-up commit, `831cf71351`, edits `designs/moddable-10-0-0-ironhorse-port-plan.md` and `designs/README.md`. It went through `safe-push-pr-head.sh` and moved the head forward from `7d2d6f8d12`. It answers the panel-2 review (5478421583):

- **Items table (ergonomist, novice):**
  - Every row now has a stable ID, R01 to R26, and the table is sorted by owning child.
  - Each child's scope cell lists its row IDs, and the Summary table names them too.
  - A short reading guide now precedes the table.
  - Child 3 now notes that R16 has a partner oracle check in child 6.
- **Provisional verdicts (skeptic, decomplector):** the 12 `already-conformant` verdicts are marked provisional until their probes land.
- **Shared artifacts (critic):** the "disjoint children" claim is replaced by a rule for each shared generated artifact:
  - **Snapshot goldens.** Children 1 and 5 can both bump the format version and regenerate `state_golden*.tsv` and the inline digests. These files are regenerated, never hand-merged; whichever child merges second rebases and regenerates.
  - **Byte-identity fixtures.** Only child 2 touches them.
  - **Per-directory expectations.** If two children flip rows in the same file, the second to merge regenerates it.
- **Rows the 8.3.1 oracle gets wrong (skeptic):** a child records the row as the run reports it and lists it in its PR as an expected oracle divergence. It never changes the engine toward the oracle.
- **Unaudited pin range (critic, skeptic):** moving from 8.3.1 to 10.0.0 pulls in more XS changes than the audited window. Child 6 now triages "unclassified oracle drift" into three verdicts, and acceptance waits until every entry has one. A case that drops out only because the 10.0.0 oracle now fails it is reported there, not counted silently.
- **Barrier (skeptic, decomplector, critic):** I confirmed in the garden code that `promote-plan.sh --require-tada` accepts `complete-with-failures`. Child 6 now starts with a deterministic self-check of the ports completion record, on top of the maintainer's check.
- **Child 5 (critic):** it must open with a short design note on representation, detached/immutable check order, and persistence before any write-path code.
- **`Math.round` (critic):** added `Math.round(0.49999999999999994)` is `+0`.
- **Prose (copyeditor, novice, ergonomist):** all six copyedits applied, plus a terms paragraph for the garden vocabulary, the reasoning behind the work order in the problem statement, and a sample expectation output line.
- **Ranges (pedant):** en-dash ranges added by this PR are now written with "to", in both files.

**Board sync.** The parked children's bodies were stale, so I annotated them with `annotate-plan.sh` (key `pr1435-panel2`):
- **Children 1 and 5:** the golden rule and the oracle-divergence rule.
- **Child 5:** also the design-note requirement.
- **Child 3:** its row IDs and the `Math.round` case.
- **Child 6:** the self-check and the drift triage.

Children 2 and 4 needed no change.

**Follow-ups:**
- Child 5's original body still says it runs last and moves the pin. Annotations from round 1 and round 2 override that, but a full rewrite of the body would be cleaner.
- The sample expectation line includes the `«»` characters from the tool's real output. The pedant might flag them next round.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1435-gauntlet-fix-2.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 56 tokens (2744005 cached reads)
- Output: 27444 tokens
- Cost: $2.0245770000000003
- Wall-clock: 867s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
