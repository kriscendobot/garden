## Gauntlet FIX round 2: kriscendobot/minion.town PR #85

I fixed the panel's three must-fix items, pushed one commit to the PR head, and CI is green.

**Commit:** `16aa123` on `feat/clip-upgrade-in-place` (a9d7b3e → 16aa123), pushed with `safe-push-pr-head.sh` and no history rewrite.

**Fixes**
1. **saboteur: bare `catch {}` in the fs grant table** (`src/endo/gateway/upgrade-capability.ts`). `makeFsUpgradeCapabilityTable().get` now returns `undefined` in two cases only:
   - the grant file is missing (ENOENT);
   - the key is not a digest. This is checked before the file path is built.

   Any other read error (EACCES, EIO, EISDIR and so on) is rethrown. If a grant file can't be parsed as JSON, it now throws `corrupt upgrade capability grant file <path>` with the original error attached as `cause`. A stored grant that parses but has the wrong shape is still treated as "no capability".
2. **typist: stale `resolvePowerReference` comment** (`src/endo/gateway/publish.ts`). The interface comment now says the reference belongs to the authority that made it and the publisher can't read it. The publisher passes it back unchanged as `writeDirectory`'s `changes.back` to that same authority, and it must never go to a different one. The memory and degraded authorities return the power itself. The daemon authority returns a deferred pet-name reference instead. `changes.back` has a matching note.
3. **fast-checker: property tests for grant validation** (`test/gateway/upgrade-capability.test.ts`). I added fast-check property tests for two paths:
   - minting succeeds only for well-formed input and puts the rights in canonical order;
   - a malformed grant stored on disk never resolves to a capability.

   The generators include near-miss clip ids: padded, one character short or long, and uppercase. To check the tests actually catch bugs, I temporarily removed the anchors from `CLIP_ID_PATTERN`. With the first version of the generator that change still passed, so I added the near-miss cases, and then 2 tests failed against it. I added a test for corrupt and unreadable grant files and changed the old test that expected a corrupt file to count as "no capability".

**Checks**
- `tsc --noEmit` passes.
- `npm test`: 735 passed, 1 failed. The failure is `test/git-remote/capability.test.ts`, which is outside this change and is the same host-environment failure seen on this box before. I did not re-run it on the base commit to confirm.
- CI on head 16aa123: `ci-wait-merge.sh --no-merge` returned 0, with 3 of 3 checks green.

**Follow-ups:** none from me. The should-fix themes are still open and the next panel round will see them:
- the claim in the `attenuateUpgrade` text is not enforced on the live path (R3);
- a powers+content upgrade can be left half-applied;
- grants pile up and are never cleaned up;
- grants are not frozen;
- on the daemon path, a power name the caller doesn't hold gets charged before it is rejected;
- the `selfId` check for a missing `:` builds a malformed id;
- an unpublish can wait forever behind a stalled daemon upgrade.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr85-gauntlet-20261003-fix-2.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 50 tokens (1535266 cached reads)
- Output: 11282 tokens
- Cost: $1.0557011999999997
- Wall-clock: 438s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
