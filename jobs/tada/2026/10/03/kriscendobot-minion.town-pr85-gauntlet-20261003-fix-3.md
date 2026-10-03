Fix round 3 for kriscendobot/minion.town#85 is pushed and CI is green: all 3 checks passed (`ci-wait-merge` rc 0).

**Commit `93d20dc`** on `feat/clip-upgrade-in-place` (head moved from `16aa123`, pushed with `safe-push-pr-head.sh --mode advance`). It addresses the panel-3 items:
- **locksmith (must-fix):** each grant now records the owner it was registered for. `upgrade` refuses it once the live record names another owner, and `unpublish` deletes every grant for the clip via a new `deleteClip`. A capability therefore stops working when its registration ends, even if the same directory is registered again later.
- **locksmith (should-fix), revocation:** added `revokeUpgrade` to the publisher, the facet and a new MCP tool. Grants carry the digests of the capabilities they were attenuated from, so revoking one also revokes everything attenuated from it. Attenuation depth is capped at 8.
- **saboteur / breaker, unheld power:** the daemon `resolvePowerReference` now checks `guest.has(name)`, so an unheld power is rejected before any charge or intern. `assertPowerName` also moved ahead of the capability lookup.
- **assessor / saboteur / breaker, combined upgrade not atomic:** the daemon `writeDirectory` now writes content first and powers last. If the powers rebind fails after the content was applied, the error says the new content stays served. The tool description and `UpgradeInput` docs state this.
- **assessor, orphaned grant:** if publish fails after minting, it now revokes the capability it minted.
- **purist, mutable rights:** grants and their `rights` arrays are frozen in `validateGrant`. The header now records why `unpublish` and `list` stay owner-gated.
- **curator:** the header explains why this does not share the git-remote token table: both modules keep a boundary that imports nothing from the rest of `src/`, and the grant shapes differ.
- **stylist:** renamed `makeFsUpgradeCapabilityTable` to `makeFilesystemUpgradeCapabilityTable`, including the call site in `http.ts` and the tests.
- **pruner:** trimmed the module header so it points to R3 instead of repeating it. Also dropped the host path from the corrupt-grant error message.
- **integrator / pruner, PR body:** rewrote it to cover both sides of the upgrade, cut the #88 section to one paragraph and the residuals hedging, removed the revision history and test tally, and made § Tests describe the integration coverage accurately.

**Tests:** added daemon-path tests for:
- an unheld power with content, rejected with no charge, intern or evaluate;
- a failed powers rebind reported after the content was applied;
- grants ending at unpublish even after the same directory is re-registered;
- a grant refused once the record's owner changes;
- revoking a capability and what was attenuated from it;
- publish revoking its capability after a failed registration.

There are also unit tests for revocation, `deleteClip` and frozen grants. Tool-name snapshots were updated for `revokeUpgrade`. Typecheck is clean. `npm test` gave 744 passed, 9 skipped and 1 failed; the failure is `test/git-remote/capability.test.ts > propagates a git failure`, which also failed before this round and comes from the host environment.

**Not done (should-fix or comment-only):**
- Purist's request to give the power reference its own type parameter.
- Integrator's retcon to regroup the commits: that is a separate maintainer-requested step and still to do.
- The note about the R2 label changing meaning.
- Letting `unpublish` skip the per-clip FIFO queue.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr85-gauntlet-20261003-fix-3.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 64 tokens (3451715 cached reads)
- Output: 30934 tokens
- Cost: $2.392671
- Wall-clock: 595s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
