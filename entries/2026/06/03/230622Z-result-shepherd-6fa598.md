---
ts: 2026-06-03T23:06:22Z
kind: result
role: shepherd
host: endolinbot
repo: endojs/endo-but-for-bots
project: endo-but-for-bots
dispatch_root: /home/kris/dispatches/shepherd--6fa598
prs:
  - repo: endojs/endo-but-for-bots
    pr: 411
    role: target
refs:
  - entries/2026/06/03/225417Z-dispatch-liaison-6fa598.md
  - https://github.com/endojs/endo-but-for-bots/pull/411
  - https://github.com/endojs/endo-but-for-bots/pull/411#issuecomment-4617436086
next: fixer
---

# result: shepherd — #411 zizmor + test 24.x triage

PR head: `58c53d5a0`. Maintainer directive (kriskowal, comment
`4617327154`): "Please also look into the zizmor failure."

## Per-failure classification

### `test (24.x, ubuntu-latest)` — flake, cleared

- **Evidence**. First attempt (job `79410986995`, run `26917657305/1`)
  produced "Timed out while running tests. 13 tests were pending in
  `test/encodePassable.test.js`" at 22:48:29Z. The same
  `encodePassable.test.js` file passed in two prior ses-ava configs
  in the same job (22:46:18 and 22:46:23) and again in the
  post-timeout config (22:48:33), so the failure is per-config and
  not a real regression. Master CI at `ba26f4cdb` (run
  `26857880654`, 01:37-01:42Z) passed the same job in 5m.
- **Action taken**. `gh run rerun 26917657305 --failed` from this
  shepherd dispatch. Attempt 2 completed at 23:03:57Z with
  conclusion `success`.
- **Verdict**: operational flake on the ava worker for the middle
  ses-ava config of `encodePassable.test.js`. Cleared by re-run; no
  PR-side change needed.

### `zizmor` — real, not introduced by this PR, fixer-fixable on master

- **Evidence**. Job `79410987077`, run `26917657304/1`:

  > `##[warning]release.yml:63: action's hash pin has mismatched or
  > missing version comment: points to commit a45c4d594aa4`
  >
  > `##[error]Process completed with exit code 13.`

  zizmor settings: persona pedantic, min-severity low, version
  v1.24.1 (same as master). The flagged pin is
  `changesets/action@63a615b9cd06ba9a3e6d13796c7fbcb080a60a0b # v1`
  at `release.yml:63`.

- **Root cause: upstream tag drift, not a PR-diff change.**
  - The pinned SHA `63a615b9...` is `changesets/action` **v1.8.0**
    (committed 2026-05-07T09:48:08Z).
  - The upstream `v1` floating tag was moved on
    **2026-06-03T07:05:44Z** to point at `a45c4d594aa4...` (v1.9.0).
  - Master CI at 01:19Z on 2026-06-03 (run `26857880651`) was green
    on zizmor because the tag had not yet drifted; this PR's CI at
    22:43Z (~15h after the drift) hit the mismatch.
  - The PR's own diff (`58c53d5a0` vs `ba26f4cdb`) touches only
    `.github/workflows/browser-test.yml`; `release.yml` is
    untouched. `git diff ba26f4cdb..58c53d5a0 --
    .github/workflows/release.yml` is empty.

- **Re-run confirmation, not transient.** `gh run rerun
  26917657304` from this shepherd dispatch produced the same
  warning at 23:00:47Z on attempt 2 (job `79413388093`,
  conclusion `failure`). The tag-drift mismatch persists across
  runs because zizmor's online audit reads the live tag-to-SHA
  mapping from GitHub each run.

- **Fix scope (single line, single file)**. Two equivalent shapes:
  1. Pin the version comment to the resolved version:
     `# v1` → `# v1.8.0`.
  2. Bump the SHA and the comment together:
     `@63a615b9cd06ba9a3e6d13796c7fbcb080a60a0b # v1` →
     `@a45c4d594aa4e2c509dc14a9f2b3b67ba3780d0d # v1.9.0`.
  Both fit fixer scope (≤ 5 files, ≤ public-API).

- **Routing question, surfaced for the orchestrator.** The failure
  exists on master HEAD (`ba26f4cdb`); the next push to master will
  hit the same red. The natural place for the fix is a separate
  fixer dispatch against master, not as a commit on PR #411's
  `ci/cache-playwright-browsers` branch (which would mix scope with
  the browser-test workflow change and obscure the diff for review
  on the upstream re-ferry). PR #411 remains gated only on
  upstream-side decision of how to treat the zizmor failure on a
  PR that did not introduce it.

## Per-failure rollup at end of dispatch

```
SUCCESS	build
SUCCESS	check-action-pins
SUCCESS	cover
SUCCESS	lint
SUCCESS	test (22.x, macos-15)
SUCCESS	test (22.x, ubuntu-latest)
SUCCESS	test (24.x, macos-15)
SUCCESS	test (24.x, ubuntu-latest)
SUCCESS	test-hermes
SUCCESS	test-ocapn-python
SUCCESS	test-xs
SUCCESS	test262 (22.x, ubuntu-latest)
SUCCESS	test262 (24.x, ubuntu-latest)
SUCCESS	viable-release
FAILURE	zizmor
```

14 green, 1 red (the master-side zizmor tag-drift issue).

## Comment posted

`https://github.com/endojs/endo-but-for-bots/pull/411#issuecomment-4617436086`
(per dispatch authorization "Post a classification comment on
#411. Authorized.")

## Escalation

`next: fixer`. Fixer task: repair the `changesets/action` pin in
`.github/workflows/release.yml:63` on master so the version comment
matches the resolved SHA. Single-file, single-line change. The
steward's auto-pickup chain reads this verdict as the authorization
to dispatch the fixer without re-asking the maintainer.

Note for the orchestrator: the fix target is **master**, not the
PR #411 branch. The fixer dispatch should be prepared against
endojs/endo-but-for-bots@master with a small chore-style branch,
not against `ci/cache-playwright-browsers`. PR #411 itself can be
un-gated on the zizmor failure since the failure is not in its
diff and would clear on master once the fixer's master-side fix
lands and #411 is rebased.

## Self-improvement

Worth a note in `skills/pr-ci-watch/SKILL.md` § Notes from the
field: a persistent zizmor `action's hash pin has mismatched or
missing version comment` failure that did not exist on a recent
master CI run is almost certainly an upstream floating-tag-drift
issue (the upstream maintainer published a new release and moved
the `vN` floating tag, but the consumer's pin still points at the
older SHA tagged at the prior release). Diagnostic recipe:
`curl -s "https://api.github.com/repos/<owner>/<action>/commits/<pinned-sha>"`
returns the original tagged version; `curl
"https://api.github.com/repos/<owner>/<action>/git/refs/tags/<vN>"`
returns the now-drifted tip. The fix is a single-line update of
the version comment (or both the SHA and the comment). This
pattern will recur whenever any pinned `@<sha> # vN`-style action
upstream cuts a new minor release; logging it once saves the next
shepherd / fixer the lookup.

A separate `message` entry to `liaison` will carry the lesson; the
subagent does not commit skill changes itself.

Self-improvement: one structural lesson on upstream floating-tag
drift surfacing as zizmor `mismatched version comment` failures;
routing a `message` to `liaison` for landing into
`skills/pr-ci-watch/SKILL.md` § Notes from the field.
