Fix round 2 for endojs/endo-but-for-bots#667 is pushed and CI is green: `ci-wait-merge` returned rc 0, 36/36 checks with no failures, on head `2bb8c7e6c7`.

I took the must-fix items from the latest panel verdict (review 5731543354, "Must-fix before merge"). The job body had no pre-pass block. I applied all five must-fix items plus the cheap should-fix items. Four follow-up commits went onto `feat/genie-stdio-jsonl-rpc-bridge` (`79f210a961..2bb8c7e6c7`) through `safe-push-pr-head.sh`:

1. **`e77323003c` fix(agentry): drain an in-flight RPC round at end of input**
   - **EOF drain (assessor must-fix; breaker):** the bridge now has an `idle()` promise, and `serveRpc` waits on it before unsubscribing. A host that closes stdin right after a `prompt` now gets the whole round.
   - **Throwing `write` (assessor and saboteur should-fix):** the event listener updates round state before writing, and a failing write (EPIPE) is logged instead of thrown into the agent's event dispatch. A failed write can no longer leave the bridge stuck busy.
   - **Throwing session call (breaker should-fix):** this now becomes an `error` event tagged with the command's `id`, instead of ending the serving loop.
   - **Smaller bridge surface (locksmith should-fix):** `handleCommand` is no longer exposed; the bridge returns only `handleLine`, `idle` and `close`.
   - Four new tests cover: EOF with a round in flight, a throwing session call, a throwing write at `agent_end`, and `idle()` semantics.
2. **`ebaef99fad` fix(agentry): guard the RPC session as an exo** (locksmith must-fix)
   - `makeRpcSession` now returns a `makeExo('RpcSession', …)` whose `M.interface` guards check the shape of every argument.
   - `@endo/exo` and `@endo/patterns` are now dependencies (`@endo/patterns` moved from devDependencies), and the composite tsconfig was regenerated.
   - A new test checks that off-shape arguments are rejected.
3. **`72e7475924` docs(agentry): correct the RPC bridge docs and changeset**
   - **Harness exports (archivist must-fix):** I restored the README's `./harness` export list. The PR had wrongly added `toolResultToSmallcaps` and the SmallCaps codec to it.
   - **`readline` claim (archivist must-fix):** I removed the false statement that Node's `readline` splits on `U+2028`/`U+2029` from the README, the changeset and `framing.js`. It splits only on a bare `\r` and `\n`.
   - **README additions:** the reply events (`endo:ack`, `models`, `status`, `error`), what happens to a `steer` sent while idle, the EOF drain, and the fact that the line buffer has no size cap (so the host must be trusted). I also trimmed the duplicated text the pruner flagged.
   - **Other fixes:** a wrong attribution in a `types.d.ts` comment and the speculative remark about adding guards later; the changeset rewritten as three sentences, one per line, with no design-path reference; the design status set to In Progress, with a note on which phases have shipped.
4. **`2bb8c7e6c7` chore: Update yarn.lock**, as a separate commit.

**PR body (integrator and pruner must-fix):** I rewrote it in template order and added the missing *Upgrade considerations* section. It now names `packages/agentry` / `@endo/agentry/rpc` instead of the old `packages/genie` paths, and it is cut down to about 300 words.

**Checks run locally:**
- The RPC tests pass (50/50).
- Package `tsc` and the root `tsc -p tsconfig.json` (with `checkJs`) are clean.
- eslint is clean on `src/rpc` and `test/rpc`.
- In the full package suite, one test failed: `eval › conflict-rebase › outcome assertion fails when conflicted worktree is left mid-rebase` (`git rebase integration` failed). This PR doesn't touch `test/eval`, and CI passed.

**Not done (should-fix or comment-only, for panel-3 to judge):**
- A late `agent_end` from an aborted round can still clear the next round's state, and an `abort` can arrive before the prompt starts.
- No size cap on a single line in the decoder (documented instead).
- No allowlist to limit which models `set_model` can select.
- The `types.d.ts` → `types-index` restructure, which also needs the `.gitignore` exception dropped.
- Squashing the earlier fixup-style commits.

The first 3600 s CI wait was killed by the tool's 10-minute background limit. I re-ran the wait in the foreground in chunks of under 10 minutes until it returned rc 0. The slow `test (22.x, macos-15)` leg finished green at about 04:10Z.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr667-gauntlet-20261102-7e7e4481b830-fix-2.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 98 tokens (4911212 cached reads)
- Output: 22352 tokens
- Cost: $2.409698400000001
- Wall-clock: 5458s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
