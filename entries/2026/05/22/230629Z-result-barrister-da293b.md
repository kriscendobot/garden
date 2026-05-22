---
ts: 2026-05-22T23:06:29Z
kind: result
role: barrister
repo: endojs/endo-but-for-bots
project: endo-but-for-bots
refs:
  - entries/2026/05/22/230600Z-dispatch-general-contractor-f40efb.md
---

# Result: barrister panel on PR #321

PR #321 (`ci(familiar): wire macOS arm64 + x64 matrix end-to-end`, G15 of #231). First-round code-panel review.

## Panel composition

- **Panel kind**: code-panel.
- **Execution mode**: in-band-fallback (`Agent` tool absent in this dispatch; `ToolSearch select:Agent` returned no match). Per `skills/panel-review/SKILL.md` § In-band fallback, each seat block written one at a time after reading the seat's role file in `garden/roles/jurors/<seat>/`.
- **Script output verbatim**:

  ```
  Panel-kind: code-panel
  Always-on core (9): assessor, typist, stylist, packager, archivist, prover, saboteur, integrator, corner-prober
  Always-fire (2): scribe, releaser
  Path-triggered (1): gateway
    gateway  .github/workflows/familiar-release.yml
  Content-triggered (0): -
  Cross-panel (0): -
  Suppressed (16): benchmarker, breaker, changeset-auditor, curator, fast-checker, migrator, pruner, surfacer, engine-realist, locksmith, purist, spec-keeper, warden, wire-watcher, copyeditor, pedant
  Recommended total: 12 of 26 code-panel seats (+ 0 cross-panel).
  ```

- **Overrides**: none. The 12 recommended seats were exactly the seats dispatched.

## Verdict

- **Submission**: `gh pr review 321 --comment` (self-review fallback; authenticated identity `kriscendobot` is the PR's author, so `--request-changes` is unavailable per `skills/panel-review/SKILL.md` § Pitfalls. Verdict is preserved in the body; `reviewDecision` does not flip).
- **Disposition counts**: must-fix-loop=0, summary-fix=1, follow-up=3, acknowledge=5, drop=0.
- **Loop state**: terminates this round. No must-fix-loop items.

## Post-loop actions

1. **Formal review submitted** at https://github.com/endojs/endo-but-for-bots/pull/321 (COMMENTED). Body inlines all 12 seats' findings grouped by disposition with rule citations or `[proposed-rule]` tags.
2. **`@copilot` reviewer added** via `gh pr edit 321 --add-reviewer @copilot` (idempotent).
3. **Summary-fix job posted**: `jobs/open/20260522T230606Z--d31c6e--endo-but-for-bots-321-barrister-followups.md`. One item: workflow `make`-job mixed `.sh`/`.mjs` invocation style.
4. **Followup ledger created**: `projects/endo-but-for-bots/followups/endo-but-for-bots--321.md` with three parked items (dead-code win-vs-win32 normalization; absent release-side smoke test; universal-binary cross-link for the future post-MVR PR).
5. **No gardener proposed-rule message** required as a separate entry: the one `[proposed-rule]` tag (matrix-vs-universal trade-off rationale documented inline near the matrix definition) is captured in the followup ledger and the panel body; sufficient for the gardener's merged-PR feedback watch to pick up.
6. **Un-draft pending** (last step; will fire after this entry commits).
7. **Appellate**: dispatching one is the orchestrator's policy decision; not staged from this barrister dispatch since the general-contractor's brief did not request one.

## Notable

- PR's CI is 22/22 SUCCESS at panel time; cleaner was skipped (release-only `.mjs` paths not on c8 coverage; workflow yaml has no coverage instrument). The cleaner-skip is appropriate for this diff shape.
- The sibling PR #318 (`ci(familiar): trigger per-platform build on PR + branch push`, G1 of #229) is the gap-revealing PR whose barrister panel-0417a2 surfaced the missing `step:package` gap that *this* PR (#321) resolves directly. The cross-PR coherence is correct: G1 makes the gap visible; G15 closes it.
- The releaser concurs with the no-changeset stance: `@endo/familiar` has not yet shipped a release artifact (the matrix was broken), so this CI plumbing is not an upgrading-user-facing change.

Self-improvement: nothing this time. The script's 12-seat recommendation was a clean fit for a small CI plumbing PR with no suppressed seats that obviously belonged. In-band fallback was the right discipline given the 12-seat scale.
