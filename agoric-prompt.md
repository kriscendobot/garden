# Handoff: PR Agoric/agoric-sdk#11540 (Endo sync) CI shepherding

You are continuing a stalled monitoring task for PR Agoric/agoric-sdk#11540
("chore: Sync Agoric SDK with Endo 2025-06-17"), branch
`kris-sync-endo-2025-06-27-00-30-49`. Local worktree:
`/home/kris/agoric-sdk/.claude/worktrees/agent-a4ffe0c830de54e38/`. Work on
local branch `parallel-upgrade-tests` (mirrors origin PR head with one patched
extra commit) and push from it into the PR ref.

PR URL: https://github.com/Agoric/agoric-sdk/pull/11540

## Current state (frozen since 2026-05-05)

- PR head: `3cfa057673404e37ed93c96c4f927c3cbb5becb9`
  (parallel-upgrade-tests synthetic-chain patch landed)
- master:  `c3f7b857740d511e7fac79df0c9b22f68442733b`
  (1 commit ahead of last attempted rebase; CI-only)
- Owner: kriskowal. Last human comment: 2025-06-27. No new reviews.

## CI failure set — same five jobs for ~8 days

1. **`test-dapp (node-new)`** — EXPECTED, leave failing.
   Known-broken Docs test on `@agoric/documentation@workspace:.` linkage with
   newer Endo from PR; awaiting follow-up in another repo. The loop's success
   condition is "all checks green except this one."

2. **`test-boot (node-new, 2, 4)`** — 40m `timeout-minutes` cap; consistent
   perf regression in shard 2 even after the `bootTestOrder` rebalance.
   Failed on first run AND rerun. Master baseline ~22 min for the same shard.

3. **`deployment-test`** — 30m apt-get can't reach
   `archive.ubuntu.com`/`security.ubuntu.com` from depot runners. Transient
   infra failure; failed on both run and rerun with same error mode. Not
   caused by us, can't fix from code.

4. **`test-docker-build`** — 90m `timeout-minutes` cap. The parallel patch
   works: 7 of 8 proposals finish in ~98 seconds combined. But `z:acceptance`
   (which has a host script and runs sequentially after) hangs at
   *"Waiting for 'ready' message from follower"* for ~70 minutes, then the
   job is cancelled. Chain inside the container is healthy (blocks every 1s);
   host-side loadgen-runner started by
   `a3p-integration/proposals/z:acceptance/host/before-test-run.sh` never
   writes `ready` to `MESSAGE_FILE_PATH`. Looks pre-existing rather than
   caused by the parallel patch — same hang in earlier runs without the patch.

5. **`integration-test-result`** — derived from `test-docker-build`.

## What's already pushed

Commit `3cfa057673`:
`ci(a3p-integration): parallelize upgrade tests via synthetic-chain patch`

Patches `@agoric/synthetic-chain` 0.6.1 (`a3p-integration/.yarn/patches/`)
to add `--parallel <N>` to its `test` command. All test images bake
sequentially (chain dep), then proposals without host scripts run via
`docker run` concurrently with bounded concurrency N. Proposals with host
scripts (only `z:acceptance` ships one) still run sequentially after, to
avoid host-side resource conflicts. `a3p-integration/package.json` `test`
script passes `--parallel ${A3P_TEST_PARALLEL:-4}`.

The parallel patch IS NOT the cause of test-docker-build still failing. It
substantially reduced wall time for 7 of 8 proposals; the residual blocker
is the z:acceptance loadgen handshake.

## Loop rules — strict, don't deviate

- **Branch / cwd**: stay on `parallel-upgrade-tests` (or checkout
  origin/kris-sync-endo-2025-06-27-00-30-49 fresh). Do NOT touch the older
  stale `kris-sync-endo-2025-06-06-01-23-47` branch — the local repo defaults
  to checking out that branch but it's not the PR branch.

- **Master rebase**: Attempted twice; aborted both times on PR-internal
  type-suppression conflicts. Conflicting files were
  `packages/zone/src/durable.js` and
  `packages/async-flow/{bijection,log-store,replay-membrane,log-store.test}.js`.
  The PR is ~30+ commits behind master with ~58 commits to apply; conflicts
  dominated by `@ts-ignore` vs `@ts-expect-error` style. Memory note flags
  this as "too contentious to autonomously rebase without user input."
  If master moves, attempt once, then abort and report. Do NOT use
  `--ours`/`--theirs` flags — user explicit instruction. Manual judgment
  only. `git checkout origin/master -- <file>` is acceptable for files
  where master has clearly superseded (yarn.lock, package.json with newer
  Endo ranges) but use sparingly.

- **Push**: SSH is blocked by SAML SSO. Use HTTPS+token bypass only:
  ```bash
  GIT_CONFIG_NOGLOBAL=1 git push --force-with-lease \
    "https://x-access-token:$(gh auth token)@github.com/Agoric/agoric-sdk.git" \
    <local-branch>:kris-sync-endo-2025-06-27-00-30-49
  ```
  Token has `workflow` scope (already refreshed by the user). If
  `--force-with-lease` returns "stale info" on first try, fetch
  the remote ref and retry with explicit lease:
  `--force-with-lease=kris-sync-endo-2025-06-27-00-30-49:<expected-remote-sha>`.

- **No CI workflow edits**: User explicitly forbade bumping `timeout-minutes`
  in `.github/workflows/test-all-packages.yml` (40m for test-boot) or
  `.github/workflows/integration.yml` (90m for test-docker-build).

- **Push only with explicit user direction** for new content. The loop's
  per-cycle push is for re-pushing existing content after rebase, not for
  trying new fixes uninvited.

- **Don't fabricate progress**. If the user fires the same `/loop` prompt
  again, do one fetch + one `gh pr checks` and report "no change" succinctly.
  Don't invent investigation findings without new data or new direction.

## The real blocker — needs user direction

The loop's success condition (all checks green except `test-dapp`) is
UNREACHABLE on the current PR head. Three options await user decision:

(a) **Investigate z:acceptance loadgen hang.** Compare master's behavior to
    PR's — was the `ready` handshake broken pre-existing on master, or
    introduced by this PR? Check
    `a3p-integration/proposals/z:acceptance/host/before-test-run.sh` and the
    `MESSAGE_FILE_PATH` semantics. The host script forks `loadgen-runner` to
    background; the in-container `test.sh` waits for the runner to write
    `ready` via `wait-for-follower.mjs`. Loadgen runs on the host but the
    test container's RPC port (26657) isn't exposed via `-p`, so how the
    runner ever reached the chain on master is itself unclear — start there.

(b) **Fix test-boot shard-2 perf.** Current rebalancing
    (commits `ed6a5e8b43` + `cb5967c142`) is insufficient. Either move more
    work out of shard 2 (`packages/boot/ava.config.mjs` `bootTestOrder`
    array) or chase the underlying SES 2.0 hardening / Endo perf regression.

(c) **Accept these as out-of-scope** for the PR and adjust the success
    condition. test-dapp + test-boot shard 2 + deployment-test +
    test-docker-build + integration-test-result all stay red.

I already presented this analysis to the user (cycle 295 onward, with full
log evidence at cycle 300 showing the 7 parallelizable proposals finishing
in 98s and z:acceptance stuck at 05:14:28 onward). User has not responded
with direction; the most recent input was 2026-05-07 confirming
"wrong chat" on an unrelated message.

## Original loop spec (verbatim, from user's /loop prompt)

```
(1) Make sure local branch / cwd is on kris-sync-endo-2025-06-27-00-30-49 —
    note the cumulative branch was pushed to that ref; the cumulative work
    lives in worktree /home/kris/agoric-sdk/.claude/worktrees/agent-a4ffe0c830de54e38/.
(2) git fetch origin master kris-sync-endo-2025-06-27-00-30-49.
(3) Check `gh pr checks 11540 --repo Agoric/agoric-sdk` for failing or
    pending checks; investigate any non-test-dapp failure. The known-broken
    Docs test is test-dapp (node-new) — leave it failing.
(4) Check `gh pr view 11540 --repo Agoric/agoric-sdk --json reviews,comments`
    for new human review feedback (filter out cloudflare-workers-and-pages
    and socket-security bots) and respond to actionable items.
(5) If origin/master has new commits and remote PR head is unchanged since
    last cycle, attempt `git rebase origin/master` (without --ours/--theirs);
    abort and report if conflicts are too many to resolve confidently.
(6) Push only via the HTTPS+token bypass:
    GIT_CONFIG_NOGLOBAL=1 git push --force-with-lease \
      "https://x-access-token:$(gh auth token)@github.com/Agoric/agoric-sdk.git" \
      <local-branch>:kris-sync-endo-2025-06-27-00-30-49.
    The token now has the `workflow` scope.
(7) Stop when all checks pass except test-dapp (node-new) — this is the
    success condition for the loop.
```

The loop is currently fired every 10 minutes by a slash command in the
caller's session. The next agent runs in a different environment without
that schedule — it should expect to be invoked manually per-cycle or set
its own cadence via `/loop` / cron.

## Inlined project memory (point-in-time, verify before asserting)

The prior agent maintained an auto-memory file
(`pr_11540_endo_sync.md`). Reproduced here verbatim because the next agent
will not have access to that filesystem path:

> PR https://github.com/Agoric/agoric-sdk/pull/11540 — branch
> `kris-sync-endo-2025-06-27-00-30-49` (NOT
> `kris-sync-endo-2025-06-06-01-23-47` which is a stale similarly-named
> branch). The local repo defaults to checking out
> `kris-sync-endo-2025-06-06-01-23-47` — switch to the right branch before
> doing PR work.
>
> **Why:** PR is the active sync of Endo into agoric-sdk. Owner is
> kriskowal; user wants CI green except the "Docs test" (test-dapp).
>
> **How to apply:**
> - Always `git checkout kris-sync-endo-2025-06-27-00-30-49` (qualify with
>   `origin/` if ambiguous; the `town` remote also has it).
> - The user's instruction "rebase on origin/master" applies to *that*
>   branch.
> - When resolving conflicts during rebase, do NOT use `--ours`/`--theirs`
>   flags. Manual judgment only. `git checkout origin/master -- <file>` is
>   acceptable for files where master has clearly superseded the branch's
>   intent (e.g. yarn.lock, package.json with newer Endo ranges).
> - Known-broken CI: `test-dapp (node-new)` — fails on
>   `@agoric/documentation@workspace:.` linkage with newer Endo from PR;
>   awaiting follow-up in another repo. Treat as expected fail.
> - test-boot (node-new, 2, 4) and test-boot (xs, 2, 4) hit the workflow's
>   40m `timeout-minutes` (`.github/workflows/test-all-packages.yml:676`) —
>   confirmed regression caused by the Endo upgrade itself (master's same
>   shard finishes in ~22min). Possible mitigations: bump `timeout-minutes`
>   to 60, re-shard, or optimize SES 2.0 hardening hot paths. Don't push a
>   workflow change without checking with the user first.
> - `test-docker-build`: had a Depot image cache miss after the 3-day-old
>   workflow rerun. Triggering a *full* workflow rerun (`gh run rerun <id>`
>   without `--failed`) rebuilds the image. The Float64Array fixes are
>   already in the PR (`controller.js:362`, `evalContractCode.js`, vat
>   workers, bridgeCoreEval).
> - Git push: SSH is blocked by SAML SSO. Use
>   `GIT_CONFIG_NOGLOBAL=1 git push "https://x-access-token:$(gh auth token)@github.com/Agoric/agoric-sdk.git" <ref>`
>   to bypass the global SSH rewrite.
> - Backup tag conventions: use `pre-rebase-pr-<timestamp>` before
>   destructive ops.
> - Rebase scope: branch is ~30+ commits behind master with ~58 commits to
>   apply. Conflicts are dominated by type-suppression style (`@ts-ignore`
>   vs `@ts-expect-error`) and yarn.lock churn — too contentious to
>   autonomously rebase without user input.

## Worth-knowing technical context from earlier sessions

These are the substantive findings the prior agent gathered, useful if you
want to investigate without re-running the experiments:

- **The Float64Array endowment fixes** were the first concrete fixes
  required after Endo 2.0's `@endo/marshal` started using Float64Array in
  `encodePassable`. Fixed at four sites: `controller.js:362-367`
  (kernel importBundle), `evalContractCode.js` (Zoe contract bundle),
  vat-supervisor worker (xsnap and node), `bridgeCoreEval` (vats), and
  `SwingSet/src/kernel/kernel.js:1886` (device-bundle importBundle, found
  later — commit `20dcccb4d2`).

- **The babel parser perf regression** (7.26 → 7.28) inflates GC pressure
  in bundle-source / module-source. A pin-back to 7.26.10 via root
  `package.json` `resolutions` was validated (-5s wall via -4.5s GC) but
  the user said "eschew options that provide very small gains" so it was
  not pushed.

- **The compartment-mapper "perf regression"** was a profiling artifact
  — bundle-source actually uses nested compartment-mapper 1.6.3 on both
  master and PR; the real cost is `@endo/module-source` 1.3.3 → 1.4.1's
  babel bump.

- **The bootTestOrder rebalancing** moved
  `runutils-snapshots.test.ts` ↔ `configs.test.js` (commit `ed6a5e8b43`)
  and `contract-upgrade.test.ts` from index 9 → 21 (commit `cb5967c142`).
  Not enough — shard 2 still hits the 40m cap consistently.

- **The boot-proposal-build CI cache** (`.github/workflows/test-all-packages.yml`,
  commit `a847f08fe2`) and **yarn dedupe across all lockfiles** (commit
  `2cf25ec826`) were validated and pushed.

- **The parallel synthetic-chain patch** (commit `3cfa057673`) works for
  the 7 of 8 proposals that lack host scripts. The patched cli.js lives in
  `a3p-integration/.yarn/patches/@agoric-synthetic-chain-npm-0.6.1-f801222832.patch`.
  The pre-existing g:ymax1-local patch (separate, with the same patch
  filename in `proposals/g:ymax1/.yarn/patches/`) is unaffected.

## Bottom line

The PR's three real blockers (loadgen, shard-2 perf, depot apt-get) are
known and explained. The loop has been treadmilling since the parallel
patch landed. Don't run more cycles without new direction unless the user
explicitly asks; if the user does ask, the right next action is to ask them
which of options (a)/(b)/(c) to pursue, not to start blind investigation.
