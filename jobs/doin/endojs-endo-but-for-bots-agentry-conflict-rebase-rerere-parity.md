# Fix: conflict-rebase eval fixture inherits the host's git rerere config

Repository: endojs/endo-but-for-bots

`packages/agentry/test/eval/conflict-rebase.test.js` fails locally on any host
whose global git config has `rerere.enabled=true` / `rerere.autoupdate=true`
(this fleet's hosts do). CI runners do not, so CI is green and the failure is
invisible there — a local/CI parity defect, not a flake.

Mechanism, observed on head 789fbe386 of PR #881 and reproduced identically on
its base 03e9aec60 (so it is not PR-attributable):

- The test `outcome assertion fails when conflicted worktree is left mid-rebase`
  runs `git rebase <integration>` and expects the failure path to leave
  `UU app.txt` in `git status --porcelain`.
- The fixture (`test/eval/_conflict-rebase-repo.js`) already performs one
  successful conflicted rebase during provisioning, which *records a rerere
  resolution* for exactly this conflict.
- On the test's rebase, rerere replays it and `rerere.autoupdate` stages the
  file: git prints `Staged 'app.txt' using previous resolution.`, status shows a
  staged modification rather than `UU`, the test's guard
  (`if (!stdout.includes('UU app.txt')) throw err`) rethrows, and the test fails
  with `Command failed: git rebase integration`.

Fix: pin the fixture's and the test's git invocations against ambient user
config, e.g. have the shared `run`/`gitRunner` helpers prepend
`-c rerere.enabled=false -c rerere.autoupdate=false` (and consider the same
hardening for other ambient-config-sensitive knobs the eval fixtures depend on).
The eval scenarios build throwaway repos and must not inherit developer git
config.

Scope: `packages/agentry` test fixtures only. Do not change scenario semantics.
Verify by running the file with the host's global rerere left enabled:
`yarn workspace @endo/agentry test` (or ava on
`test/eval/conflict-rebase.test.js`) must pass without unsetting global config.

---
claim:
  host: endolin-garden2-5bcdff64
  gardener: 1
  worker_kind: cleric
  claimed_at: 2026-07-29T03:47:04Z
