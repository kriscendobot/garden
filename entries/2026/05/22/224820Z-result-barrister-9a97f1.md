---
ts: 2026-05-22T22:48:20Z
kind: result
role: barrister
project: endo-but-for-bots
repo: endojs/endo-but-for-bots
refs:
  - entries/2026/05/22/224500Z-dispatch-general-contractor-9a97f1.md
---

Barrister code-panel round 1 on PR #320 (`feat(familiar): consolidate daemon stop/purge via CapTP control helper (#231 G8)`), against frozen base `origin/llm-b1c3f4d`. Cleaner-12a8b9 landed bug fix `97ad09532` (timer-not-cleared on settle), captured as branch HEAD `b95d00637`. CI's three failing checks (lint, cover 20.x, cover 24.x) are base-side ocapn rename (`makeClient` to `makeOcapn`); per dispatch brief, not classified as must-fix on #320.

## Panel-hints output

```
Panel-kind: code-panel
Always-on core (9): assessor, typist, stylist, packager, archivist, prover, saboteur, integrator, corner-prober
Always-fire (2): scribe, releaser
Path-triggered (2): changeset-auditor, gateway
  changeset-auditor  .changeset/familiar-consolidated-stop-purge.md
  gateway            yarn.lock
Content-triggered (2): engine-realist, warden
  engine-realist  matched: ephemeral
  warden          matched: @endo/init
Suppressed (13): benchmarker, breaker, curator, fast-checker, migrator, pruner, surfacer, locksmith, purist, spec-keeper, wire-watcher, copyeditor, pedant
Recommended total: 15 of 26 code-panel seats.
```

No barrister overrides (additions or subtractions). 15 seats dispatched.

## Panel execution

- **Mode**: in-band-fallback. `Agent` tool was not in scope on this dispatch (deferred-tool list contained no Agent entry); ran each seat as a single block sequentially per `skills/panel-review/SKILL.md` § In-band fallback.
- **Panel kind**: code-panel.

## Per-seat dispositions (15 seats)

| Seat | Verdict | Concrete findings |
|---|---|---|
| assessor | comment-only | 1 acknowledge (restart-verb dead but symmetric), 1 follow-up (reconcile restart shapes) |
| typist | approve | 2 acknowledge (precise literal-union JSDoc, correct `NodeJS.Timeout \| undefined`) |
| stylist | comment-only | 2 acknowledge (root-level entry-point sibling consistency; rename `runEndoCommand` → `runDaemonControl`) |
| packager | comment-only | 3 acknowledge (3-commit shape, changeset present, dep promotion internally consistent) |
| archivist | comment-only | 3 acknowledge (header rewrites match code; changeset reads to upgrading user) |
| prover | request-changes (downgraded) | 1 follow-up (verb-allowlist unit test); 1 follow-up (timer-clear regression guard). The PR body's G16 deferral is the rationale for not classifying must-fix |
| saboteur | comment-only | 3 acknowledge (argv closure, no shell interpolation, timer-cleanup correctness) |
| integrator | approve | 2 acknowledge (resource-path threading, `@endo/daemon` exports verified) |
| corner-prober | comment-only | 4 acknowledge (empty-argv, extra-argv, race-on-settle, spawn-error double-settle) |
| scribe | comment-only | 2 acknowledge (knowledge captured on both PR body and code site) |
| releaser | approve | 2 acknowledge (private package; changeset audience appropriate) |
| changeset-auditor | comment-only | 2 acknowledge (single-package scope, well-formed) |
| gateway | comment-only | 2 acknowledge (yarn.lock chore split; no root-config touch) |
| engine-realist | comment-only | 2 acknowledge (ephemeral hit is content-trigger false-positive; lockdown footprint correct) |
| warden | comment-only | 3 acknowledge (SES lockdown in subprocess; no new wire surface; closed verb allowlist) |

## Aggregated verdict

- 0 `must-fix-loop`.
- 0 `summary-fix`.
- 3 `follow-up` (prover #1, prover #2, assessor #1; appended to per-PR ledger).
- 2 `acknowledge` at the aggregated-disposition layer (restart-symmetry; base-side CI fail context).
- 0 `drop`.

Submission verb: `--comment` (no must-fix-loop; bot-authored PR; the few non-drop dispositions are follow-up/acknowledge so request-changes would not match the verdict).

Formal review URL: https://github.com/endojs/endo-but-for-bots/pull/320#pullrequestreview-4349169087

## Post-loop actions

- Formal `gh pr review --comment` submitted (state: COMMENTED).
- Follow-up ledger appended at `journal/projects/endo-but-for-bots/followups/endo-but-for-bots--320.md` (3 items, status: parked).
- One `[proposed-rule]` tag in finding #3: "when a helper exposes a verb and the calling site has an in-process equivalent, document the divergence or fold one into the other". Recorded in the ledger; gardener-message routing deferred to the contractor's post-cycle policy.
- `gh pr ready 320`: **not run by this barrister**. The PR-creation-flow chain on this branch was launched by the general-contractor; the contractor's next cycle decides whether to un-draft now (no must-fix-loop, only follow-ups) or dispatch an appellate first (the appellate appeals follow-up/acknowledge dispositions into summary-fix per `roles/appellate/AGENT.md`). Leaving the un-draft to the contractor preserves the chain's discriminator.

## Contractor's next-cycle reads

- Zero must-fix-loop items: the jury-fixer loop **terminates** on this round. Per `skills/pr-creation-flow/SKILL.md`, the next stage is appellate (if the contractor's policy dispatches one on every first-round termination) followed by `gh pr ready 320`. The barrister did not un-draft.
- Three follow-up items are parked in the ledger; the steward's per-cycle survey will revisit at merge time (and at upstream-mirror merge time when the boatman ferries this PR).
- Base-side CI failure (lint + cover 20.x + cover 24.x) is the `makeClient` → `makeOcapn` rename on `origin/llm-b1c3f4d`; not this PR's regression. The shepherd dispatch is **not** indicated by this barrister; the failure will clear when the base branch's ocapn-rename PR lands or a separate base-side shepherd dispatch addresses it.

Self-improvement: nothing this time. The panel-hints script's recommended set was well-sized for the diff (15 of 26 seats), the in-band fallback path was already documented in `skills/panel-review/SKILL.md`, and the disposition rubric handled the test-deferral case (prover finding rerouted from must-fix to follow-up via the G16 deferral rationale) without rule strain.
