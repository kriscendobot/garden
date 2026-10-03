Fix round 6 for kriscendobot/minion.town#85 is pushed and CI is green: `ci-wait-merge.sh` returned rc 0 at head `3f2671e`. I applied both panel-6 must-fix items, three of the other items, and deferred three.

**Must-fix**
- **assessor, rollback could take down another publish's site** (`804dc9c`): when a publish fails, its rollback in `src/endo/gateway/publish.ts` now runs in the clip's queue and removes the registration only if the record has no nonce or this call's own nonce. A publish that loses a race no longer deletes a concurrent publish's live, already-returned registration. The rollback is keyed by the clip id the publish checked, not by the hash the registration returned.
  - The panel suggested having `evaluateRegister` report created-vs-existing. I used the nonce instead, because two concurrent first registrations can both see "no record", so only the nonce shows whose record it is.
  - Tests: the existing rollback test now injects a failure after registration, and a new test checks that a record a concurrent publish already stamped stays served.
- **integrator, stale description of re-registration** (`3f2671e`): the `upgrade-capability.ts` header and the PR body § Authorization now match how it works since 981ae8d:
  - a same-owner re-registration changes nothing;
  - a registration by another owner is refused;
  - a new nonce comes only from a fresh publish after unpublish.

  I also fixed the matching stale comment in `unpublishClip`.

**Other items applied**
- **integrator/archivist** (`3f2671e`): the contradictory paragraph in `designs/clip-shell-framework.md` now says #85 lands the stable-id interim and only #88 is still a different direction.
- **corner-prober** (`0993b8f`): new tests check that capabilities can be narrowed 8 levels deep but not a 9th, and that a malformed registration nonce is refused when minting and does not resolve when stored.
- **scribe**: posted this round's top-level completion-summary comment (issuecomment-5973941648). Rounds 1–5 still have none; I did not backfill them.

**Deferred** (listed with reasons in the PR comment)
- purist: a nominal `PowerReference` type brand. It is a typing change with no behavior change.
- engine-realist: one unreadable grant file makes unpublish report failure, and the temp-file-then-rename writes have no `fsync`. These belong in a follow-up because they also apply to the existing vhost table.
- integrator comment-only notes: commit regrouping and one unwrapped line in `DEPLOYMENT.md`.

**Checks**
- `tsc --noEmit` is clean.
- The publish, upgrade-capability and daemon-site-registry test suites pass (85 tests).
- The full vitest run has three failing files, none touched by this PR: one test in `test/git-remote/capability.test.ts` (a known failure in this host's environment), and two node:test `.mjs` files under `tools/claude-harness/` that vitest picks up and reports as having no test suite.

Next: the driver posts panel round 7; I did not re-run the panel.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr85-gauntlet-20261003-fix-6.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 62 tokens (2336354 cached reads)
- Output: 14853 tokens
- Cost: $1.4400028
- Wall-clock: 431s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
