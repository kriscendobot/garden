The fix for PR #249 round 5 is pushed, but CI hasn't finished. On head `de1e42ba`, `Claude harness (amd64)` was still queued for a runner after about an hour, so `ci-wait-merge.sh` kept returning rc 4. Every other job has passed: the clip frame browser gate, `changes`, `test`, and `Claude harness (arm64)`. The driver should re-post this stage to wait for that job.

**Source of the fixes:** no pre-pass block was attached, so I worked from the latest panel verdict, review 5780936703 on `e90919d2`.

**Must-fix items**
- **Stale create request (saboteur, breaker):** after an unconfirmed create, the form now shows the kept request and its provider and locks its fields. A final refusal unlocks it.
- **Wake switch focus (spec-keeper, engine-realist):** focus is restored after the switch is re-enabled, unless the owner has moved it elsewhere.
- **Grant moves (wire-watcher):** a grant claimed by a factory record that is deleting, deleted, in an unknown lifecycle, or active on another provider is now refused. Locksmith withdrew its similar finding because the pinned `list()` returns no `deleting` records, so this only matters for a factory that reports them.

**Should-fix items also applied**
- **Committed retries:** a retry of a committed replacement now returns the new provider and reports moves it can't make as `reattachFailed`. A grant no provider lists any more goes to the registry, which answers from the move's key. Only a `committed` operation adds a source provider.
- **`operationId`:** it is now optional on the replace route, and the UI no longer sends it.
- **Smaller fixes:**
  - `lowered` limits are filtered like the other limits.
  - Agents that aren't active list by name and don't open.
  - Late wake and reattach replies no longer paint over another agent.
  - The reattach `try` now covers only the request.
  - `operation-in-progress` counts as an unknown outcome.
- **Docs:**
  - The changeset and doc comment say `attachedAgents` and an agent's `grantId` don't exist at the cited upstream revision `2dd07fe5`, so only `agentIds` can move against it.
  - The new refusal is listed as breaking.
  - The PR title and body are updated.

**Commits and summary:** the fixes are in `8cd0eca4` and `de1e42ba`, pushed with `safe-push-pr-head.sh`. The [round summary](https://github.com/kriscendobot/minion.town/pull/249#issuecomment-6654345337) on the PR lists what was declined and why.

**Verification**
- `tsc` passes, and the pre-push gates exit 0 with one non-blocking advisory.
- The four affected test suites pass locally, on Chromium only; WebKit and Firefox run only in CI. The focus test and the other browser tests added this round haven't passed on those two engines yet: those jobs are behind the queued harness job.
- With the old production code restored, the new tests fail, except the unlock-after-refusal test, which passes there because the old form never locked.

**Not done, left for the next panel**
- Pinned retry for limits save and delete.
- A shared helper for the retry cycle.
- Two decomplector simplifications, declined with reasons in the PR comment.
- Commit-history redistribution, which needs a retcon rather than this add-only stage.

<!-- gauntlet-stage-result: fix=still-pending -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr249-gauntlet-fix-5.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 50 tokens (2753911 cached reads)
- Output: 43068 tokens
- Cost: $2.5014302000000006
- Wall-clock: 4895s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
