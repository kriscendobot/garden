---
ts: 2026-05-13T21:44:19Z
kind: dispatch
role: liaison
project: agoric-sdk
to: "*"
prs:
  - repo: Agoric/agoric-sdk
    pr: 11540
    role: source
---

# Dispatch: builder mirrors agoric-sdk PR #11540 in our fork and posts advised-next-steps comment

Dispatch root: `dispatches/builder--agoric-pr-findings--20260513-214419--3fdcd2/`. Project worktree at `kriscendobot/agoric-sdk@master`.

**Per-action authorization (forwarded)**: kriskowal in this session asked to "create a workspace in our fork of agoric-sdk and mirror the PR described in agoric-prompt.md" and "comment on the PR for advised next steps." Authorizes pushing branches to `kriscendobot/agoric-sdk` and posting one comment on `Agoric/agoric-sdk#11540`.

## Hand-off source

The detailed task lives at `/home/kris/agoric-prompt.md` (host-level state; read directly). The prompt describes a stalled CI-shepherding loop on PR #11540 (`kris-sync-endo-2025-06-27-00-30-49`) with three real blockers: z:acceptance loadgen hang, test-boot shard-2 perf regression, deployment-test depot-apt-get infra failure. The maintainer's framing in the prompt's "Bottom line": "Don't run more cycles without new direction." The deliverable for THIS dispatch is the **advised-next-steps comment**, not the loop's per-cycle work.

## Task

1. Mirror the PR head into our fork:
   - `gh pr view 11540 -R Agoric/agoric-sdk --json headRefOid,headRefName,headRepositoryOwner,baseRefName`. The head was `3cfa057673404e37ed93c96c4f927c3cbb5becb9` at the prompt's freeze time; verify it has not advanced.
   - From your project worktree, add upstream and fetch the PR head: `git -C project remote add upstream https://github.com/Agoric/agoric-sdk.git && git -C project fetch upstream pull/11540/head:pr-11540`.
   - Branch on `kriscendobot/agoric-sdk`: `git -C project checkout -b parallel-upgrade-tests pr-11540` and push: `git -C project push origin parallel-upgrade-tests:refs/heads/parallel-upgrade-tests`. This is the workspace the maintainers can pull from.
   - **Do NOT attempt to rebase onto master.** The prompt explicitly says the rebase is too contentious to autonomously do (~58 commits to apply, type-suppression conflicts dominant). Mirror as-is.

2. Do NOT push any new commits to `kriscendobot/agoric-sdk`'s topic branch beyond the mirror. The deliverable is reading-and-thinking, not building.

3. Post one comment on `Agoric/agoric-sdk#11540` framed as **advised next steps for the maintainers**. Body draws from agoric-prompt.md § "The real blocker — needs user direction" plus the other technical context the prompt records. Cover:
   - Current state (PR head, master delta, frozen since 2026-05-05) — one paragraph.
   - The five-job failure pattern, with the prompt's classification (test-dapp expected-fail; test-boot shard-2 perf; deployment-test infra; test-docker-build z:acceptance loadgen; integration-test-result downstream).
   - The three options (a) / (b) / (c) the prompt enumerates, framed as choices for the maintainers:
     - (a) Investigate z:acceptance loadgen hang (with the prompt's specific entry points: `before-test-run.sh`, `MESSAGE_FILE_PATH`, `wait-for-follower.mjs`, RPC port 26657 exposure question).
     - (b) Fix test-boot shard-2 perf (the SES-2.0 hardening / Endo perf regression angle; the existing `bootTestOrder` rebalance commits `ed6a5e8b43` + `cb5967c142`).
     - (c) Accept these as out-of-scope and adjust the success condition.
   - A short closing paragraph noting the parallel-synthetic-chain patch worked (commit `3cfa057673`, 7 of 8 proposals parallelized) but does not unblock the loop.
   - A pointer to the mirror branch on `kriscendobot/agoric-sdk` for the maintainers to pull from if they want a working copy.
   - One-shot: no follow-up replies in this dispatch.

4. Use `gh pr comment 11540 -R Agoric/agoric-sdk --body "$(cat <<'EOF' ... EOF )"`.

## Out of scope

- Do NOT rebase the PR.
- Do NOT push new investigation commits.
- Do NOT run CI watchers (the prompt explicitly says don't fabricate progress).
- Do NOT make follow-up comments.
- Do NOT edit CI workflows (the prompt forbids bumping timeout-minutes).

## Result entry

`journal/entries/2026/05/13/<HHMMSS>Z-result-builder-<short-id>.md`: mirror branch push SHA, comment URL, one-paragraph summary of the comment's framing (which of the three options got most emphasis), self-improvement.

## Return

≤ 350 words: mirror branch SHA, comment URL, which of (a)/(b)/(c) the comment recommended (or balanced), self-improvement.
