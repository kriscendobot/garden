I ran panel round 1 on endojs/endo-but-for-bots#1403 against head `7cc7cc3fe7`, and it came back **must-fix**: 4 of 36 seats requested changes (curator, breaker, surfacer and releaser).

**How it was posted.**
- **Review:** GitHub won't let the bot request changes on its own PR, so the verdict went up as a COMMENTED review on head `7cc7cc3fe7` with a must-fix header. It matches the earlier round-6 panel review on this PR, which was also posted that way.
- **Overflow comment:** the per-seat aggregate was 87 KB, over GitHub's 65,536-character limit. I split it at seat boundaries and posted the rest as a follow-up comment (#issuecomment-6094013863).
- I didn't fix anything or un-draft the PR.

**Must-fix items (3):**
1. **Cancellation reaction not disarmed** (breaker), `packages/inference/src/limits.js:81-91`: if arming the timer throws, the catch only rethrows. A cancellation that is already rejected can still call `terminate()` on an enforcer the caller never received. The fix is to set `stopped = true` before rethrowing, and add a test.
2. **Changeset contradicts `package.json`** (curator, releaser; packager agrees): the changeset says `major`, but the package is `private: true` at `0.1.0` with a public `publishConfig`. Pick one publish intent; releaser also wants a user-facing changeset body.
3. **Type declarations aren't shipped** (surfacer): `./types.js` resolves to `.d.ts` re-exports of `src/types.js`, but nothing generates the declarations and they aren't in `files`.

**Should-fix items worth carrying into the fix stage:**
- `abort` calls `stop()` outside the try that guards `terminate()`.
- Counts that arrive after `stop()` still return `true`.
- No test pins the `turns` guard in `usage-recorder.js`.
- The exported surface is wider than a provider plugin needs.
- `SECURITY.md:21` has the British spelling "acknowledgement".

**Notes:**
- The panel's repeat check flagged that the two previous rounds (heads aef833b9 and 6be2a3cb) also raised must-fix findings on the same files: `guards.js`, `limits.js`, `types-index.types.d.ts` and `usage-recorder.js`. In response it put the decomplector's "is this mechanism needed at all?" question to the panel.
- The project worktree is clean.
- GitHub's REST API was rate-limited for the bot account during this run; GraphQL still worked, so posting wasn't affected.

<!-- gauntlet-stage-result: panel=must-fix -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1403-gauntlet-20261007-panel-1.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 40 tokens (1276211 cached reads)
- Output: 6213 tokens
- Cost: $0.9352221999999999
- Wall-clock: 291s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
