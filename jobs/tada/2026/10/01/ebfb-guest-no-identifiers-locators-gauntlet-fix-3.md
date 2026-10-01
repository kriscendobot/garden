Fix round 3 for PR #1404 is pushed and CI is green: all 33 checks finished with no failures (`ci-wait-merge` rc 0). The new head is `90b4f72604`.

**What I fixed, in five follow-up commits on top of `4614dd5d99`:**
- **Guest `copy`/`move` (warden), `b34f3d3df4`:** a guest's own `copy` and `move` used the same daemon code that swaps any guest on a path for its full directory. A guest that held a name for another guest could therefore identify a value in that guest's namespace, or write a new name into it. Guest-facing `copy` and `move` no longer make that swap, so a path through another guest is refused. The same applies to the guest-facing view of a directory. When a host traverses into its own guest, it still works as before. A new test covers six refusal routes and the host case.
- **`request` result (wire-watcher), same commit:** a directory that resolves a guest's `request` now arrives in the guest-facing form, without the identifier and locator methods. A new test covers this.
- **Type exports (surfacer), `e9f65a60bb`:** `@endo/daemon` now exports `GuestNameChange` and `GuestMessageRevision`.
- **Stale comments (purist #3), `d9e96303f2`:** removed references to the deleted guest `invite`/`accept` in `manager.js` and `host.js`.
- **claude-sandbox factories (migrator), `de0ba385f0`:** the session and credentials factories called guest methods this PR removes. They now recognize their own form by `@self` in `fromNames` and read the submitted value with `adopt`. Their test mocks were updated to match.
- **Changeset (packager, changeset-auditor), `90b4f72604`:** added `@endo/jaine` (minor) and `@endo/claude-sandbox` (patch). It also covers the `copy`/`move`/`request` changes and the new type exports, and states that the invariant covers only the guest's own methods, mail, and the directories it reaches.
- **lal `test:xs` stub (coverage-auditor):** the PR body now explains why lal has no XS tests. The coverage-auditor accepted a written rationale in place of real XS tests.

**Checks run locally:**
- Daemon tests (`endo.test.js` and `guest-redaction.test.js`): 272 pass.
- claude-sandbox factory tests: 24 pass.
- `tsc` for the daemon package, claude-sandbox, and the repo root is clean.
- ESLint has no errors (warnings only), and prettier is clean.

**Not fixed, with reasons in a PR comment** ([#issuecomment-5938245962](https://github.com/endojs/endo-but-for-bots/pull/1404#issuecomment-5938245962)):
- **Breaker:** a guest given its host as `host-agent` gets the full host. That is how lal, fae and jaine set up their agents, so limiting it is a design decision rather than a fix.
- **Purist #1 / wire-watcher #2:** channel messages still carry raw identifiers for a guest that joins a channel. This is a design question of the same kind.
- **Purist #2:** I kept the two lookup tables. After the `copy`/`move` fix, one serves guest-side calls and the other host-side calls, so they no longer do the same job.
- **Packager:** I did not reword the subject of commit `9809f6d979` to `fix(fae,floot)`, because that would mean rewriting already-pushed history.

**Follow-up:** the breaker and channel items are now the design job `design-ebfb-guest-delegated-host-channel-confinement`. I had first attributed them to `ebfb-guest-designation-consumers`, but that job has already finished, so I corrected the PR body and comment.

The panel has not re-run yet. Per the job, the driver posts panel-4 next.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/ebfb-guest-no-identifiers-locators-gauntlet-fix-3.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 140 tokens (7808916 cached reads)
- Output: 33918 tokens
- Cost: $3.3242552
- Wall-clock: 3266s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
