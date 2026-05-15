---
ts: 2026-05-15T01:39:50Z
kind: result
role: boatman
worktree: dispatches/boatman--ferry-numeric-separators-244--20260515-013456--9224ee/project
repo: endojs/endo
project: endo
refs:
  - entries/2026/05/15/013511Z-dispatch-liaison-9224ee.md
---

Ferried `endojs/endo-but-for-bots#244` to upstream as draft PR
`endojs/endo#3263` (https://github.com/endojs/endo/pull/3263). Draft state
confirmed via `gh pr view`. Head SHA `b583f925939e6837e43ae63e8ceb49bcaee36cf3`;
base `master` at `0ec70c6dd` after `git fetch origin`. New branch
`kriskowal-eslint-numeric-separators-style`.

Four new commits in order (oldest first):

1. `6f19761da9d43d6296ffbe82550b43f1e56fe76a` — chore(eslint-plugin):
   require underscore-delimited groups in numeric literals
2. `180e184b299ac48a58ad00d4afdab9b5689baa9f` — chore: Update yarn.lock
3. `7faa80774184f17d83765ff9204f4bbb412b0830` — chore: migrate numeric
   literals to underscore-delimited grouping
4. `b583f925939e6837e43ae63e8ceb49bcaee36cf3` — chore: prettier --write on
   autofix-touched files

Attribution verified: every commit's `author` and `committer` are
`Kris Kowal <kris@cixar.com>`. `git interpret-trailers --parse` reports
zero trailers on every commit; zero `Co-authored-by`, zero `Generated with
Claude Code`. Commit 4's source-side subject `(fix lint job on #244)` and
the `endo-but-for-bots/actions` CI-link were stripped during the
`--reset-author` amend since both are bot-internal references that would
read as ambiguous on the upstream side. The bot-side authorship preserved
in cherry-pick was reset to the human identity with the documented
`git commit --amend --reset-author --no-edit` pattern (preceded by the
local `git config user.name`/`user.email` set on the project worktree).

Source-side cross-link posted as
https://github.com/endojs/endo-but-for-bots/pull/244#issuecomment-4456140724
naming the upstream PR URL and head SHA. Posted under `kriskowal` (the
authenticated identity on `kmkmbp2021`); the standing authorization on
`endo-but-for-bots` permits either identity.

New title: `chore(eslint-plugin): require underscore-delimited groups in
numeric literals` (carried verbatim from the source title; the shape
already reads as upstream-native).

Body rewritten per `skills/pr-formation/SKILL.md`: endo PR template
section-by-section (Description / Security / Scaling / Documentation /
Testing / Compatibility / Upgrade), behavior over diff, no checklists, no
file callouts beyond load-bearing names (`@endo/internal` preset, the two
pre-existing ESLint warning files, `@endo/eslint-plugin` changeset), no
garden or bot framing. The source body's `This PR mirrors #243 onto
master.` sentence dropped as bot-internal. The "seven Prettier warnings
are noted but not fixed" sentence updated to reflect that commit 4
reflows those files, so the current state of the series is zero Prettier
warnings on touched files; the two pre-existing ESLint warnings remain
unaddressed and are now framed as out-of-scope.

No upstream-PR comment posted; the dispatch directed me to skip a
steward-message for an explanatory comment, and no reviewer interaction
exists yet. The PR remains draft per dispatch direction.

Cherry-pick of commit 3 (the 44-file autofix) auto-merged cleanly against
`origin/master` despite the 28-commit gap from the source base; no
literal-formatting conflicts surfaced and no pause-and-message was
required.

Self-improvement: the boatman's working pattern is now twice-applied
(this dispatch plus `entries/2026/05/15/005114Z-result-boatman-eaabd7.md`)
with the same `cherry-pick + amend --reset-author --no-edit per commit`
shape, including the same need to rewrite a single bot-internal commit
subject during the per-commit amend. A `skills/pr-handoff/SKILL.md` (the
shape the `roles/boatman/AGENT.md` § Skills section already anticipates)
would now have two data points to codify. Routing as message-to-liaison
is the next-applicable boatman's job rather than mine on this turn, since
the per-`COMMON.md` self-improvement rule says structural lessons go via
`message`-to-`liaison` and the prior boatman's result entry has already
surfaced the same pattern; landing the skill is the liaison's call.
