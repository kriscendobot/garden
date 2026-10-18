Fix round 4 for kriscendobot/minion.town PR #202 is done. All three failing prepass probes now pass, the fix is pushed, and CI is green.

**What changed** (one follow-up commit, `b193ec3`, pushed to `feat/chat-clip` with `safe-push-pr-head.sh`, moving it on from `c56cbca`):
- **Bare `Far` in `test/chat-clip-power.test.ts`:** the fake `Invitation` is now built with `makeExo` and guarded by an `InvitationInterface` (`M.interface`). `Far` is still passed into the Compartment because it mirrors the daemon's endowments, and the probe no longer flags it.
- **Abbreviated `dir` in `test/chat-clip-power.test.ts`:** renamed the helper to `directory`.
- **`numRuns` in `test/chat-clip.test.ts`:** that is fast-check's own option name, so it can't be renamed. I added a `spell-out-exempt` header with that reason, as other test files in the repo already do.
- **Hand-rolled promise kit in `test/chat-clip-page.test.ts`:** I first switched it to `@endo/promise-kit`, but that broke 2 tests. The package needs SES's global `assert`, and this happy-dom test deliberately mocks out `@endo/init`, so SES never loads. I put the local deferred back and marked the file `prefer-endo-primitives-exempt` with that reason, which the probe allows for a justified case. A reviewer may still prefer a different fix here.
- **Ellipsis in `designs/chat-clip.md`:** replaced `…` with `...`.
- **Advisory comment at `clips/new-clip/main.js:455`:** left as is. It is non-blocking and states something you can't see from the code next to it: the power narrows the owner's mailbox to the named peer.

**Checks:**
- The three probes, run against the PR base, all pass.
- The vitest run of the three chat-clip test files passes (29/29), and `tsc --noEmit` is clean.
- CI on `b193ec3` ("test (typecheck + vitest)") succeeded.

**How CI was watched:** the run sat queued for about 55 minutes because the runners were saturated. My first `ci-wait-merge.sh` call ran into a 10-minute background limit and was stopped. I then polled the Actions runs API in the foreground until the run finished, and ran `ci-wait-merge.sh --no-merge` once more, which returned rc 0 (CI GREEN). As expected on this host, the token can't read `statusCheckRollup`, so it used the Actions runs API.

**Follow-ups:** none. The driver re-posts panel-5.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr202-gauntlet-fix-4.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 70 tokens (2122510 cached reads)
- Output: 12935 tokens
- Cost: $1.1786179999999997
- Wall-clock: 3769s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
