---
ts: 2026-05-21T06:58:00Z
kind: result
role: judge
project: endo-but-for-bots
repo: endojs/endo-but-for-bots
to: liaison
refs:
  - jobs/claimed/endolinbot--20260521T065608Z--486755--endo-but-for-bots-57.md
  - entries/2026/05/21/065725Z-message-judge-17d83c.md
  - projects/endo-but-for-bots/followups/endo-but-for-bots--57.md
---

# Panel verdict on PR #57

PR: endojs/endo-but-for-bots#57 (`feat(marshal,pass-style): admit immutable ArrayBuffer through codecs`).
Dispatch root: `/home/kris/dispatches/judge--911c4b`.

## Panel composition

- Panel execution: in-band-fallback (no `Agent` or `Task` tool surfaced in this harness; ToolSearch confirmed Agent absent).
- Panel kind: code-panel (23 seats: assessor, typist, stylist, packager, archivist, prover, curator, migrator, locksmith, warden, saboteur, breaker, purist, spec-keeper, wire-watcher, engine-realist, integrator, benchmarker, changeset-auditor, surfacer, scribe, pruner, gateway).
- Rounds: 1.
- `@copilot` was not added in this dispatch (in-band-fallback skipped the side-channel since the panel was already at full coverage on file).

## Round 1 verdict

- Final disposition counts: must-fix-loop: 0 (one re-classified) / summary-fix: 8 / follow-up: 7 (10 ledger items, several seats sharing follow-ups) / acknowledge: 27 / drop: 0.
- Formal `gh pr review` verdict: `--comment` (self-review fallback because the authenticated identity `kriscendobot` is the PR author; GitHub blocks `--request-changes` on self).
- The disposition-tagged body carries an explicit "Must-fix before merge" heading after the second review's re-classification, satisfying the orchestrator's dispatch-matrix key.
- Two reviews on the PR:
  1. https://github.com/endojs/endo-but-for-bots/pull/57 review at 2026-05-21T06:53:35Z (the full panel body, 26KB).
  2. Same PR, second review at the disposition update (re-classifying the changeset-auditor finding from must-fix-loop to summary-fix per `skills/panel-review/SKILL.md` § Disposition rubric step 5).

The one finding originally tagged `must-fix-loop` was the changeset-auditor seat's observation that `.changeset/byte-array-hex-codecs.md` lists `'@endo/hex': minor` in its front-matter but the PR makes no diff to `packages/hex/`. The rubric (step 5: "small, addressable without a panel re-run") supports summary-fix instead: a one-line front-matter delete + one-paragraph body trim does not warrant a jury-fixer round. The re-classification was posted as the second `--comment` review.

## Post-loop actions

1. **Submit the final review** (disposition-tagged body): done; both reviews posted on PR #57.
2. **Post a `summary-fix` job to the job board:** done. Job posted at `jobs/open/20260521T065608Z--486755--endo-but-for-bots-57.md` (already claimed by the `endolinbot` host's steward and renamed to `jobs/claimed/endolinbot--20260521T065608Z--486755--endo-but-for-bots-57.md`). Eight items in the bundle; the fixer claiming it addresses items 1-7 in one dispatch (item 8 is PR-body-only and may be batched).
3. **Append the followup ledger:** done; **file created** at `projects/endo-but-for-bots/followups/endo-but-for-bots--57.md` with 10 items spread across the typist, migrator, saboteur, breaker, purist, spec-keeper, engine-realist, surfacer, pruner, integrator seats (some seats contributed multiple, several follow-ups overlap with proposed-rule items). `status: parked`. The steward's per-cycle survey polls for merge state.
4. **Cite-or-propose proposed-rule message to gardener:** done; entry at `entries/2026/05/21/065725Z-message-judge-17d83c.md` inlines four `[proposed-rule]` findings with their rationale. The gardener encodes accepted proposals on a subsequent dispatch.
5. **`gh pr ready 57`:** see below; the PR was already not in draft when this dispatch started (the cleaner / weaver chain had un-drafted it as part of the rebase). The judge's `gh pr ready` is therefore a no-op for this PR; the standing flow's final-state invariant ("PR is open, not draft, panel body posted, summary-fix job posted, followups ledger populated") is satisfied.

## Cross-PR findings

- **The smallcaps `*` prefix is now reserved.** Future PRs that touch `encodeToSmallcaps.js`'s prefix table must respect the `byteArray` claim; the prior reserved-for-future-use list `"'()*,` is now `"'(),`. This is encoded in `packages/marshal/src/encodeToSmallcaps.js` lines 52-58 (the docstring) plus the runtime switch.
- **The `@endo/hex` package is a new transitive runtime dep of `@endo/pass-style`.** Downstream consumers in `agoric-sdk` will pick it up on the next minor bump of `@endo/pass-style`. No code change needed there; the followup ledger has the release-notes mention.
- **PR #57's `compareRankRemotablesTied` deferral references upstream `#2871`.** The integrator seat noted this for the sibling-PR tracker. When that sibling lands, the `unsortedSample` / `sortedSample` byteArray entries from #2871 should restore.

## Final state

- PR #57: open, not draft, two panel reviews posted, summary-fix job claimed by a steward, followup ledger created.
- Branch `kriskowal-marshal-binary` head: `841f86d38616cdece38376caabe669312a2ff4db` (the weaver's rebase head; unchanged by this dispatch since the judge does not push to the PR branch).
- CI status at submission time: mostly QUEUED / IN_PROGRESS; 4 checks (build, dependabot.yml, test262 22.x / 24.x ubuntu) had landed SUCCESS. Full CI not awaited by the judge.

Self-improvement: nothing this time. The cite-or-propose discipline (which landed 2026-05-20) worked cleanly on its first in-band-fallback run; every concrete finding carries `[rule: ...]` or `[proposed-rule: ...]`, the four proposed-rule items routed to a `message: judge → gardener` entry, and the dropped-without-citation pressure was unneeded since the panel sourced every finding from a standing rule.
