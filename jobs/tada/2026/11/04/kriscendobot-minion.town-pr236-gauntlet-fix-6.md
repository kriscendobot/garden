Round-6 fixes for PR #236 are pushed (head `6ac2f61f`, `feat/remote-invitation-hints`), and CI is green on all 7 checks.

The `test` job failed twice before passing. Both failures were in the live-daemon B1 suite, each a different test, both when the daemon restarts:
- **First run:** "RootHost: the same adapter as the admin cap provisions + records durably" timed out after 90s.
- **Second run:** "reincarnates a guest-pinned Claude inbox responder after restart" failed.

That test file doesn't use any code this PR changes, and this suite is known to flake on main too. I reran only the failed job each time, and the third run passed.

**What changed, by juror:**
- **locksmith / purist:** a remote invitation request (`inviteRemote`) now answers 503 before minting when no federation routes are configured. Before, it handed out the daemon's locator unfiltered.
- **wire-watcher:** an invitation must carry a 64-hex `fromNode`, and each kept hint must have a 64-hex designator.
- **breaker:** a hint is dropped if it names a `network` or `transport` other than the served `np` dialect, and the rebuilt hint writes `np` itself rather than copying the daemon's value.
- **corner-prober:** new fault test where `cancel` also fails after a failed `locate`. The next invite under that name gets 409 and nothing is minted again.
- **archivist / surfacer:** the design (§ 5) now says hints are rebuilt from the route, not just filtered. `DEPLOYMENT.md` now describes the 503 when federation is off.
- **migrator:** changeset bumped to `major`, since 409 on a name already in use breaks existing clients.
- **stylist:** renamed `params`, `locs`, `out`, `wsHint` and `loc` to full words.
- **pruner:** trimmed the PR body. I kept the phase/evidence ledger because garden tooling reads it. I dropped the open question about the federation-off case, since this round settles it.
- **scribe:** posted a summary comment on the PR: https://github.com/kriscendobot/minion.town/pull/236#issuecomment-6644904561

Locally, 195 tests passed (in `test/endo-guest-locator.test.ts` and `test/web/`) and `tsc --noEmit` is clean. Prettier was already failing on two of the changed files before this round, and CI doesn't run it.

**Not done:**
- **decomplector** asked to remove the filter entirely. That contradicts the locksmith/purist fail-closed requirement and the design's served-route policy, so I kept it.
- **purist** asked to use Endo's own locator code instead of the local copy. There's no published `@endo/*` export to depend on, so this is left for later.
- **corner-prober's** second case (two concurrent `acceptLocal` calls on the same name) was marked summary-fix only. It isn't added; it could be a small follow-up.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr236-gauntlet-fix-6.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 56 tokens (2440823 cached reads)
- Output: 16992 tokens
- Cost: $1.5981566
- Wall-clock: 1138s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
