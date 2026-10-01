## Completion report: `minion-town-pr140-endo-cancel`

I opened draft PR **https://github.com/kriscendobot/minion.town/pull/146**, which replaces the `AbortController` in the Claude agent's `infer` with the `@endo/cancel` cancel-kit idiom. I also replied on kriskowal's inline thread on #140 with the link: https://github.com/kriscendobot/minion.town/pull/140#discussion_r4156217407. The PR's base is a frozen snapshot of `main` at `af7af61`, branch `main-af7af61`.

**What changed**
- **`src/endo/claude/agents.ts`:** `infer` now gets its cancellation from `makeCancelKit()`. The cleanup entry each in-flight inference stores now calls `cancel(new Error("Claude agent torn down"))`, so teardown still cancels every inference that is running.
- **`@endo/cancel` could not be added as a dependency:** it isn't published on npmjs.com or on `npm.minion.town`. Instead, `src/endo/cancel-kit.ts` is a TypeScript port of `makeCancelKit` copied from endo-but-for-bots `llm` at `86c1d25744`. Its header records that source and says to swap in the real package once a release exists.
- **One deliberate behavior difference:** the old code resolved the cancellation promise with `undefined`, even though it is typed as never resolving. The cancel kit rejects it instead. The code that consumes it (`@endo/claude`'s `harness.js` and `launch.js`) treats either outcome as a cancel, so production behavior is the same.
- **Test fake updated:** one fake in `claude-delegation-durability.test.ts` was waiting for the promise to resolve, so it now waits for it to resolve or reject.
- **Sweep of `src/`:** the only other use is `AbortSignal.timeout(10_000)` on the webhook `fetch` in `wiring.ts`. `fetch` itself requires that signal, which is the kind of platform boundary the review allows, so I left it as is. The PR description says so.
- **New tests:** `test/endo-cancel-kit.test.ts` covers the cancel kit itself, and a new case in `test/claude-delegation.test.ts` checks that dismissing a child cancels its in-flight inference.

**Verification**
- `npm run typecheck` passes.
- `npm test`: 716 passed, 1 failed. The failure is `test/git-remote/capability.test.ts > projectPartition > propagates a git failure…`, and it also fails on `main` without my changes in this environment.

**Process note:** I made a mistake and ran `git stash push` in the project checkout; the stash list is shared with other workers. I gave the entry a unique tag, restored it by SHA within a minute, and dropped it. Nothing was lost and no other worker's stash was touched.

**Follow-ups**
- Once `@endo/cancel` is published (for example to `npm.minion.town`), replace `src/endo/cancel-kit.ts` with the real dependency.
- PR #146 still needs the usual review and CI.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/minion-town-pr140-endo-cancel.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 58 tokens (2144242 cached reads)
- Output: 13110 tokens
- Cost: $1.3438004
- Wall-clock: 197s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
