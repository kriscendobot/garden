---
ts: 2026-06-14T09:00:13Z
kind: result
role: fixer
host: endolinbot
repo: endojs/endo-but-for-bots
project: endo-but-for-bots
prs:
  - repo: endojs/endo-but-for-bots
    pr: 379
    role: target
refs:
  - entries/2026/06/14/080300Z-dispatch-fixer-188902.md
  - entries/2026/06/14/081000Z-dispatch-fixer-71b7f5.md
  - https://github.com/endojs/endo-but-for-bots/pull/379
  - https://github.com/endojs/endo-but-for-bots/pull/379#pullrequestreview-4492610183
  - https://github.com/endojs/endo-but-for-bots/pull/379#issuecomment-4701163259
  - https://github.com/endojs/endo-but-for-bots/pull/379#issuecomment-4701261441
---

# result: fixer — merged cycle-rename-tdz SES + Node-parity tests into single module on PR #379

Reincarnation of fixer dispatch `188902` (rate-limited at start)
under dispatch root `/home/kris/dispatches/fixer--385fe4`.
Addressed kriskowal review `4492610183` per the original brief.

## Branch tips

- Pre: `b7e77cf38` (test(compartment-mapper): drop issue-number references
  from the cycle-rename-tdz matrix files).
- Post: `ca17e11e4` (test(compartment-mapper): merge cycle-rename-tdz
  SES+Node parity tests into single module per kriskowal review).
- One commit, append push.

## Consolidated shape

Single file `packages/compartment-mapper/test/cycle-rename-tdz-matrix.test.js`
with the SCENARIOS table inlined and both treatments registered
back-to-back per row:

```js
for (const scenario of SCENARIOS) {
  scaffold(`cycle-rename-tdz ${scenario.name} (ses)`, test, fixture, assertFixture, 1);
  test(`cycle-rename-tdz ${scenario.name} (node parity)`, async t => { ... });
}
```

Rationale for the single-file shape over the per-scenario-file
alternative: kriskowal's review wording (\"all usage will be in one test
module\") hints at the single-module shape, and the table-driven shape
that the prior fixer landed already collapsed the seven scenarios into
two table walkers; the legibility win is moving the parity walker into
the same loop body rather than into a sibling file.

## File-by-file changes

- `packages/compartment-mapper/test/cycle-rename-tdz-matrix.test.js` —
  rewrote to inline `SCENARIOS`, `assertCycleRenameTdz`, and the
  Node.js parity loop. Module-level prose updated to describe the
  paired registration.
- `packages/compartment-mapper/test/cycle-rename-tdz-matrix-node-parity.test.js` —
  deleted (folded into the consolidated module).
- `packages/compartment-mapper/test/_cycle-rename-tdz-assertions.js` —
  deleted (only consumer was the deleted parity sibling and the
  consolidated module that now owns the table inline).
- `packages/ses/test/import-gauntlet.test.js` — updated the prose
  comment that pointed readers at the prior split-file shape to point
  at the consolidated module instead. No assertion changes.

Net: `4 files changed, 203 insertions(+), 238 deletions(-)`.

## Test result

- `corepack yarn workspace @endo/compartment-mapper test` — 1014 pass,
  6 known failures (pre-existing). The matrix's 7 scenarios each
  produce one `(node parity)` line and a 9-line `(ses) / loadLocation`,
  `(ses) / importLocation`, `(ses) / makeArchive ...` cluster.
- `corepack yarn workspace ses test` — 511 pass, 2 known failures, 2
  skipped (prose-only edit to `import-gauntlet.test.js` did not
  perturb assertions).

## pre-push-gates result

Probes against my consolidation alone (after dropping unrelated
`yarn format` / `yarn lint --fix` drift on `evasive-transform/src/index.js`
and `ses/src/compartment.js`):

```
filename-no-stutter            pass
no-ascii-banners               pass
no-inline-import-jsdoc         pass
no-non-ascii-in-source         pass
no-pull-citations              pass
sentence-per-line-md           pass
test-package-no-main           pass
security-md-hash-uniform       fail (pre-existing on master; out of scope)
```

The `security-md-hash-uniform` divergence on master is unchanged and
out of the fixer's lane. The lint/format drift the gate flagged in
`evasive-transform/src/index.js` and `ses/src/compartment.js` is also
pre-existing and unrelated to this consolidation; reverted those
auto-fix changes so the commit stays scoped to the review ask.

## Reply, CI note, and re-request

- Top-level summary reply (consolidation):
  https://github.com/endojs/endo-but-for-bots/pull/379#issuecomment-4701163259
- Top-level CI-state note:
  https://github.com/endojs/endo-but-for-bots/pull/379#issuecomment-4701261441
- Re-request review (kriskowal added back to `requested_reviewers`):
  via `POST repos/endojs/endo-but-for-bots/pulls/379/requested_reviewers`
  with body `{"reviewers":["kriskowal"]}`. Response confirms
  `requested_reviewers` contains `kriskowal` again.

## CI state on ca17e11e4

15 of 16 checks pass (lint, build, all node tests on 22.x and 24.x
ubuntu and macos, test262, test-hermes, test-xs, test-ocapn-python,
cover, check-action-pins, viable-release, zizmor). The single red is
`browser-tests`, which timed out after 30 minutes on the
`Install Playwright Browsers` step before `Run Playwright tests`
could start. I reran the failed job once; the rerun is stuck on the
same step (infrastructure stall on Playwright's browser download,
unrelated to a compartment-mapper test-file refactor). Surfaced the
CI state in the second top-level comment so the maintainer reads the
\"browser-tests red\" against that context rather than against the
diff. If the rerun also times out and a shepherd is needed for a
more substantive CI nudge, the orchestrator can dispatch one.

Self-improvement: nothing this time.
