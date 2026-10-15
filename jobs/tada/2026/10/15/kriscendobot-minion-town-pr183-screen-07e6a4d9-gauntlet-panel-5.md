Panel round 5 on kriscendobot/minion.town PR #183 came back **must-fix**, and the verdict is posted on the PR.

- **Run:** `GARDEN_PANEL_SINGLE_ROUND=1 scripts/jobs/gardening/panel.sh` ran against head `bf575c0` (base `main-bc11010`) in an isolated checkout. It exited 0 and all 34 seats returned. The decomplector got the forced "is it needed?" question because the same mechanism (`containment.ts`, `needs-auth`, `secrets-credential-vault.ts`) drew must-fix findings in the last two rounds. The pruner was forced over the PR description.
- **Seat verdicts:**
  - **request-changes (6):** archivist, curator, migrator, breaker, purist, pruner.
  - **approve (7):** warden, spec-keeper, wire-watcher, benchmarker, thesaurus, procurer, reexport-auditor.
  - **comment-only (21):** everyone else.
- **Must-fix findings include:**
  - The move of legacy credentials onto `@secrets` is one-way, with no rollback path.
  - Facet `infer` on agents created by the root silently changes its contract.
  - The `credential-vault.ts` header comment ("WHERE IT LIVES") is now stale.
- **Review:** posted as a COMMENT, not request-changes, because GitHub rejects request-changes on the bot's own PR. Rounds 12–14 were posted the same way: https://github.com/kriscendobot/minion.town/pull/183#pullrequestreview-5529532514. The body is headed "Panel verdict — round 15 … **must-fix**". It has the request-changes seats and the decomplector in full, then other seats until GitHub's size limit. 17 comment-only and approve seats were cut for length and are named in the body.
- No fixes and no un-draft, as the job specified. The aggregate is in the panel run directory, `scratch/tmpexec/garden-panel-project-wt-kriscen-3ff3bc062531-50ebdcbf-183/round-1.md`.

<!-- gauntlet-stage-result: panel=must-fix -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion-town-pr183-screen-07e6a4d9-gauntlet-panel-5.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 22 tokens (531680 cached reads)
- Output: 3903 tokens
- Cost: $0.582692
- Wall-clock: 650s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
