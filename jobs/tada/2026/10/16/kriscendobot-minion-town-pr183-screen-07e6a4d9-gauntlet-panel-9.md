## Completion report: gauntlet panel round 9, kriscendobot/minion.town#183

**Verdict: must-fix.** The panel ran one round with no errors (`panel.sh` exited 0), and the review is posted on the PR.

**What I did**
- Made an isolated project checkout of `kriscendobot/minion.town@build/inference-phase3-secrets` at head `dff1ff8`.
- Ran `GARDEN_PANEL_SINGLE_ROUND=1 scripts/jobs/gardening/panel.sh <wt> 183 main-bc11010`. All 32 seats returned. The last line of output was `code-panel single-round — must-fix`.
  - request-changes (9): archivist, locksmith, migrator, procurer, pruner, saboteur, surfacer, typist, wire-watcher
  - comment-only (15)
  - approve (8)
- Checks before the seats ran:
  - **Phase/evidence = HOLD-DRAFT.** This is an orchestrated slice of the design. Phases 3–6 are deferred and phase 1 is partial; the successor job `minion-town-claude-kriscendobot-canary-after-connect-20261006` owns them. The code verdict stands, and the PR stays draft.
  - The **decomplector** seat was forced because the same must-fix keeps recurring around `secrets-credential-vault.ts`, `types.ts` and `vendor-endo-claude.sh`. The PR-body length check forced the **pruner** seat.
- Posted the review: https://github.com/kriscendobot/minion.town/pull/183#pullrequestreview-5542417611 (on commit `dff1ff8`).
  - It is a COMMENTED review, not request-changes. GitHub won't let the bot request changes on its own PR, and rounds 6 and 8 were posted the same way.
  - The body follows the panel-verdict layout of earlier rounds: header, seat counts, the pre-pass notes, then each seat's full text.
  - **Not every seat's text is in the review.** GitHub caps a review body at about 65k characters and the full panel output is about 96k. I included every request-changes seat, the forced decomplector seat, and as many comment-only seats as fit. The text of 6 comment-only and all 8 approve seats is left out; the review lists them by name.

**Main must-fix themes for the fixer**
- Some docs don't match the code:
  - The design doc says a legacy record migrates "on a read that reaches the daemon".
  - The release note gives the wrong shape for the `needs-containment` result.
  - The title and docs cite phase and gate numbers that don't match the design.
- The `InferOutcome` and MCP `infer` tool-description unions don't include the new `needs-containment` arm.
- The deployed CLI backend has `containFacets: true` hard-coded, which makes every facet-held `infer` refuse. That is a breaking change to a documented surface.
- Should-fix (decomplector): question whether the legacy-migration pass is needed at all, and stop growing inline JS in `tools/vendor-endo-claude.sh` since the maintainer asked for JavaScript-only scripts on #150.

**Follow-ups:** None from this stage. I didn't fix anything, un-draft the PR, or start another round. The next stage belongs to the gauntlet driver.

<!-- gauntlet-stage-result: panel=must-fix -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion-town-pr183-screen-07e6a4d9-gauntlet-panel-9.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 30 tokens (806240 cached reads)
- Output: 5979 tokens
- Cost: $0.7772600000000001
- Wall-clock: 558s

<!-- garden-usage-end -->
