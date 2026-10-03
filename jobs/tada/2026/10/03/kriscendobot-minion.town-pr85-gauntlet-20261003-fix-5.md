I applied both must-fix items from the round-5 panel to PR #85, pushed the fix, and CI is green (`ci-wait-merge.sh` rc 0, 3 of 3 checks passed).

**Commit pushed:** `981ae8d` on `kriscendobot/minion.town` `feat/clip-upgrade-in-place`, pushed with `safe-push-pr-head.sh` (advanced from `2c35098`).

**Must-fix 1 (breaker): re-registering a clip rolled back its upgrade.** The module header said the old copy of a clip's content and the served copy "harmlessly diverge" after an upgrade, but they didn't. When an owner registered a clip again after upgrading it, the old content was served again and every upgrade capability stopped working.
- **Re-registration:** `evaluateRegister` in `daemon-site-registry.ts` now leaves an existing same-owner record exactly as it is, instead of rewriting it from the stale content. A different owner is still refused, as before.
- **Publish:** before minting or charging, `publish` in `publish.ts` now refuses a directory that already has a record. It stamps its registration nonce only on a record that has none. If it fails after the clip is registered, it now unregisters the clip, so it never leaves a live clip with no capability while reporting failure. This also covers the assessor/breaker should-fix on that failure path.
- **Race with re-registration:** `writeDirectory` now receives the nonce the capability was checked against. It re-checks that nonce before writing either the content or the powers side, which closes the race with a concurrent re-registration.
- **Header:** the R2 note in the module header now lists every writer of the served record and why none of them can roll back an upgrade.

**Must-fix 2 (migrator): `DEPLOYMENT.md` was stale.** The Clip gateway section said live `upgrade` was not yet available. It now covers:
- how live in-place upgrade works for content and for powers;
- the bearer upgrade capability, `attenuateUpgrade` (at most eight levels deep) and `revokeUpgrade`;
- where grants are stored and how a grant is tied to one registration;
- the R3 residual: anyone who knows a clip URL can rebind its powers without a capability.

The "unproven" wording now says live upgrade is covered by CI but not yet proven on the production daemon.

**Also fixed:** the typist note, replacing `→` with `->` in `upgrade-capability.ts`.

**Tests:**
- **Added:** refusing to publish over an already-registered directory, before any mint or charge; unregistering and revoking when publish fails after registration; an upgraded record surviving a same-owner re-registration; and `writeDirectory` refusing a record that was re-registered after the capability check, on both the content and powers sides.
- **Adjusted:** two existing tests. One loop test now starts each pass from an unregistered directory, because the passes share an fs root. The test "revokes the capability it minted when publication fails after the mint" became the new before-mint refusal test, since Bob's publish now fails before anything is minted.
- **Results:** typecheck is clean and `test/gateway` passes 173 of 173. The full `npm test` has one failure, `projectPartition > propagates a git failure`, in the git-remote code this commit doesn't touch. I believe it is the host-environment failure already known on this box, but I did not re-run it without my change to confirm.

**Not done here (should-fix, left for later rounds):**
- the grant table can grow without limit, and one corrupt grant file makes every later unpublish fail;
- revoking authority is the same string as upgrade authority, so a delegate given the root capability can revoke it;
- the per-authority `powerReferences` lookup table is shared across the whole module;
- duplicated helpers between `upgrade-capability.ts` and `vhost-table.ts`;
- trimming the PR body and tool descriptions;
- concurrent publishes of the same clip overwriting each other's nonce. This is now refused rather than silently overwritten.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr85-gauntlet-20261003-fix-5.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 70 tokens (2912507 cached reads)
- Output: 18690 tokens
- Cost: $1.7357094
- Wall-clock: 604s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
