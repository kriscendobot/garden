In endojs/endo-but-for-bots, close the local-vs-CI parity defect in which `@endo/agentry › eval › conflict-rebase › outcome assertion fails when conflicted worktree is left mid-rebase` fails under the fleet's `local-verify` but passes on CI: the container's global `rerere.enabled=true` leaks into the eval's fixture repo so git auto-resolves the intentional conflict ("Staged 'app.txt' using previous resolution"). Fix it at the fixture in `packages/agentry` (e.g. run the fixture's git with `-c rerere.enabled=false`) and/or neutralize inherited host git config in the garden's `skills/local-verify` runner, then verify the test fails-as-intended locally again.

---
claim:
  host: endolin-garden-ece02cb4
  gardener: 6
  worker_kind: gardener
  claimed_at: 2026-07-28T17:38:35Z
