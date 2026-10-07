# Completion report: review-improve-builder-pr-gauntlet-bypass

Both parts are done. A build PR can no longer skip the panel because another job owns its design's later phases, and a requested gauntlet on such a PR can now finish instead of failing on the same check every round. Pushed to main2 as `bcecceb0c80`, and cluster `builder-pr-gauntlet-bypass` is now **closed**.

## (a) Prevention
- **New ledger disposition `orchestrated-slice`.** It requires `Successor: <job or orchestration base>`, written as a single token. The author-time gate accepts a slice only as a draft. It blocks a slice with no successor, a successor written as prose, a missing phase row, or a slice opened non-draft.
- **The slice still goes through the gauntlet.** The panel reviews the code. Only the un-draft waits until the successor supplies its evidence and changes the ledger to `deliverable`. A slice can never be un-drafted or merged as the deliverable, so the protection from cluster `phase-slice-substitutes-for-production-evidence` stays in place.
- **Guidance updated** in `roles/builder/AGENT.md` (the ordered-design rule), `skills/pr-formation` (ledger fields), `skills/orchestration` (what to tell build and canary children) and `roles/jurors/integrator`. `non-deliverable-probe` is now reserved for `probe #N` jobs, which are still the only panel-exempt shape.

## (b) Sensing (all deterministic)
1. **Handoff.** `auto-gauntlet-handoff.sh` stages the panel for a build PR whose ledger says `non-deliverable-probe` and logs that decision. A gauntlet that ended held-draft would normally block a new run under the same name. So once the ledger turns `deliverable`, the handoff re-stages under a dated name. Tests are in `auto-gauntlet-handoff-test.sh`.
2. **Panel.**
   - `phase-evidence-gate.sh` in panel mode no longer emits `probe-must-remain-draft`. For a well-formed probe or slice it exits 30 (`hold-draft`) and reports the open phases once.
   - `panel.sh` passes that to the integrator without forcing must-fix. In loop mode it never calls the un-draft hook on a held PR.
   - After a passing panel, `gauntlet.sh` re-reads the live ledger. On a probe or slice ledger it finishes `held-draft`, with one PR comment and one maintainer notice, instead of un-drafting. If the PR body can't be read, it waits for the next tick rather than guessing.
   - Tests are in `phase-evidence-gate-test.sh` and `gauntlet-test.sh` SUBTEST 18.

## Re-checking each member
- **minion.town#148** (current path). I replayed its ledger (`non-deliverable-probe`, phases 1–2 partial, 3–6 not-started):
  - (i) the handoff stages a gauntlet for it;
  - (ii) the panel gate returns `hold-draft` with all six open phases listed and no must-fix finding;
  - with approving seats, the panel's last line is `pass`;
  - the driver finishes `held-draft` and posts no un-draft stage.

  Relabeled `orchestrated-slice`, the same ledger passes the author-time gate. I also found why no gauntlet was staged on 2026-10-03: `is_probe_job` still matched the bare word "probe" in the build job body. That was fixed separately in de50427 on 10-05.
- **endo-but-for-bots #1015 and #1097** (from the 2026-08 era, before automatic staging was retired). Both were "draft PR finished, no gauntlet staged." Automatic staging was restored on 2026-09-29, and since 10-05 any bot-authored draft PR named in a completion report is staged, whatever role produced it. The new handoff test covers the remaining way around that, a ledger probe label. Nothing else about them needs action.

## Tests
- All passing: `phase-evidence-gate-test` (30), `gauntlet-test` (77), `auto-gauntlet-handoff-test`, `assert-producer-pr-draft-test`, `draft-guardrail-terminalization-test`, `panel-seat-retry-test`, `panel-decider-retry-test`. shellcheck is clean on the edited scripts.
- `gauntlet-test.sh` was already failing at its first assertion on unmodified origin/main2. Its fixtures wrote completed-job reports flat, and `tada_find` now only looks in dated subdirectories. I fixed both fixture helpers.

## Follow-ups (none blocking)
- The dated re-stage handles one re-review per day per PR. A second held-draft finish on the same day would silently skip the next re-stage until the following day.
- The local `journal/` checkout was stale: it didn't have the #148 miss record. The producer clone did.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/review-improve-builder-pr-gauntlet-bypass.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 138 tokens (10351980 cached reads)
- Output: 53956 tokens
- Cost: $4.787596
- Wall-clock: 943s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
