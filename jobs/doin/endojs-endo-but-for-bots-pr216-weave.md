# weave (rebase) endojs/endo-but-for-bots PR #216 onto base `llm`

PR #216 (`feat/endor-tui-bot` → `llm`, author kriscendobot) is CONFLICTING
(`mergeable_state: dirty`), so GitHub is not dispatching `pull_request`
workflows on new pushes — `statusCheckRollup` is stale and CI cannot go
green until the conflict is resolved. Handed off by the PR #216 shepherd.

## Diagnosis
- Base `llm` is ~1196 commits ahead of the PR's merge-base; the PR is only
  3 commits ahead.
- Exactly ONE textual conflict: `designs/README.md` (the design-index
  table). `yarn.lock` auto-merges. All the PR's other 14 files (the new
  `packages/tui`, `packages/tui-xs`, `rust/endo/src/bin/endor.rs`, etc.)
  are net-new and do not conflict.
- The `designs/README.md` conflict is semantic: `llm` has marked many
  designs Complete and added new rows (patterns-diagnostic-feedback,
  cli-http-client). The PR's own edit sets the `endor-bus-tui` row to
  `In Progress` (updated 2026-05-11), while `llm` has it as `Not Started`
  (2026-04-23). Resolution: take `llm`'s table wholesale, then re-apply the
  PR's `endor-bus-tui` status change (In Progress + its updated date) on
  top so the PR's intent survives.

## Ask
Rebase `feat/endor-tui-bot` onto current `origin/llm`, resolving the
`designs/README.md` table conflict per above, and force-push-with-lease.
Because `llm` moved ~1196 commits, run a rebase-hygiene / net-diff audit:
confirm the new tui packages still align with any convention changes on
`llm`, and that the net diff is only the intended TUI feature. After the
push, CI should dispatch; the shepherd's prettier fix (commit b99b99738,
`packages/tui/src/tui.types.d.ts`) is already on the branch and clears the
prior red `lint` check. Verify CI reaches green (or re-hand-off to shepherd
if a fresh red surfaces post-rebase).

<!-- garden-reaped: 1 -->

---
claim:
  host: endolinbot2
  gardener: 70
  claimed_at: 2026-07-02T01:04:31Z
