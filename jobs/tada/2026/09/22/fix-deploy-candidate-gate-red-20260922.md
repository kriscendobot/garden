The deploy candidate gate is now green on the pushed HEAD (`44902550569`, which is `origin/main2`). Job complete.

## Completion report

**Root cause — one cause, not three.** The three `rc=1` suites (`signal-kill-classifier`, `retry-narrowing`, `provider-cooldown`) all broke on the *same* change: `feat(budget): key quota controls by subscription` (`5aca28371fa`) made the claim gate **fail closed** on an unrecognized inference source, with a deliberate hermetic-fixture escape hatch in `claim-job.sh` that keys the bypass off `GARDEN_TEST=1`. Each of these three tests spawns a **real** gardener/claim subprocess, but first scrubs all ambient `GARDEN_*` vars for hermeticity — and that scrub regex (`^GARDEN_`) also unset `GARDEN_TEST`, the positive test-context sentinel the deploy gate itself exports (`deploy-garden.sh:387` runs each suite under `env GARDEN_TEST=1`). With the sentinel scrubbed away, the escape hatch never fired, the fixture's synthesized `unknown:PROVIDER:host:kind` pool was refused with `exit 3`, the stub handler never ran, and the classifier/retry/cooldown assertions failed. It surfaced as three unrelated-looking failures but is one contract change reaching one shared hermetic pattern.

**Fix.** Re-establish `export GARDEN_TEST=1` immediately after the env scrub in all three tests, so the spawned claim path takes the intended hermetic bypass. This is a **test-only** fix that restores a sentinel the scrub should never have stripped (it's test context, not fleet state). The product's fail-closed behavior is correct and untouched; **no assertion was weakened**.

**rc=124 cluster — load artifact, confirmed not a defect.** That cluster was on candidate `024f3a012a53`, which *predates* the budget gate. I ran every suite in it (`terminal-handler-failure-reap`, `policy-refusal-quarantine`, `codex-policy-refusal-resume`, `retry-narrowing`): all pass and finish in ≤25s against the 60s per-suite budget. They were starved by the since-fixed runaway-load leak, not genuinely slow — **no budget change is warranted.**

**Verification.** Ran the full 11-suite `GARDEN_DEPLOY_TEST_SUITES` gate exactly as `deploy-garden.sh` does (`env GARDEN_TEST=1 bash <suite>`, 60s each) on the pushed HEAD: **0 failures**, every suite within budget.

**Changed / pushed.** `scripts/jobs/test/{signal-kill-classifier,retry-narrowing,provider-cooldown}-test.sh` (+19 lines, comments included). Committed and pushed to `main2` as `44902550569` (now `origin/main2` HEAD).

**Follow-ups.** None required for the gate. The fleet's deploy monitors should now advance past this candidate and unfreeze the 29–35-commit backlog. One latent hazard worth noting for future test authors: any hermetic test that scrubs `^GARDEN_` and then spawns a real claim/gardener subprocess will hit the same fail-closed refusal unless it re-exports `GARDEN_TEST=1` — the scrub regex and the sentinel collide by construction.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/fix-deploy-candidate-gate-red-20260922.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 78 tokens (2909235 cached reads)
- Output: 24381 tokens
- Cost: $2.9674385
- Wall-clock: 536s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
