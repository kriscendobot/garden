Fix round 5 for kriscendobot/minion.town#236 is pushed and CI is green.

The job had no deterministic pre-pass block, so I worked from the latest panel-5 review (5773773406). The only item marked must-fix was the decomplector's #1: the code kept adding checks to a verifier that re-sent the daemon's hint text as written. I took its suggested fix: build the hint from data the app owns instead of checking the daemon's text.

**What changed** (commit `2a0e08f3`, pushed to `feat/remote-invitation-hints` with `safe-push-pr-head.sh`, moving the head from `7c8abacf`):

- **`src/endo/guest-locator.ts`:** `hintIsServed` is replaced by `servedHint`. It still picks out a daemon hint only when it matches a configured route, names the hosting node, and its location dials the route's own host and port.
  - It then builds a new hint from the route. From the daemon it keeps only the designator and the optional `network`/`transport` names. The keys are in the daemon's order, so a hint the daemon minted comes back byte-for-byte unchanged.
  - The byte-exact `href` check, the `JSON.stringify` round-trip, the `LOCATION_KEYS` allow-list and the exact-transport rule are deleted.
  - The JSDoc that sat on the wrong symbol (raised by curator and spec-keeper) is gone with them.
- **Behavior change:** a `ws:url` that sits beside the TCP hints is now dropped rather than causing a 503. Starting a WebSocket listener therefore no longer makes guest reveals and invitations answer 503, which removes the cost the decomplector pointed out. I updated `DEPLOYMENT.md` § Served dialect to match.
- **Tests:**
  - Tests that fed the old verifier odd spellings now check that only the newly built hint comes out. Those spellings were a trailing `#`, a trailing newline, userinfo, a path, extra keys, a repeated key, and an extra transport.
  - Hints that have no designator, a non-string host or port, a different location type, or a repeated `loc` or `node` are still refused.
  - I added a designator to the fixture in `guest-web-socket-faults.test.ts`, because one is now required.
- **Smaller panel items:**
  - The changeset is now one sentence per line and describes the new hint behavior.
  - "cancelled" is now "canceled" in `DEPLOYMENT.md` and in the console message.
  - I trimmed the comments the pruner flagged in `guest-web-socket-service.ts` and `guest-web-router.ts`.
  - I replaced the PR body's sentence that only pointed at a `DEPLOYMENT.md` section.

**Checks:**
- `tsc` passes.
- Locally, 1,705 of 1,706 vitest tests ran green. The one failure is `test/git-remote/capability.test.ts` › "propagates a git failure", which this PR doesn't touch; it matches the known local git-wrapper false failure.
- `ci-wait-merge.sh --no-merge` returned 0: 7 of 7 checks green, with none failed.

**Not done (left for panel-6):**
- Decomplector's should-fix #2: invitations still take the hosting node from the locator itself rather than from `getPeerInfo()`.
- Decomplector's should-fix #3: the name reservation in `withNamesReserved` still sits beside the existing serialization rather than being folded into it or split into its own PR.
- The pruner's broader cut of the PR body's "What changes" section.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr236-gauntlet-fix-5.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 46 tokens (1856851 cached reads)
- Output: 13211 tokens
- Cost: $1.3195262
- Wall-clock: 482s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
