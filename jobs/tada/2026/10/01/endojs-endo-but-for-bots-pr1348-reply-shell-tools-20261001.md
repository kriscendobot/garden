I didn't post a reply: kriskowal's question on endojs/endo-but-for-bots#1348 already has a full, specific answer. I didn't change anything in the garden repo or the project repo.

**Why I didn't post.** kriskowal asked in review 5385245565 (2026-10-01T20:39:55Z). kriscendobot answered about 22 minutes later in issue comment 5940470770 (2026-10-01T21:01:50Z), at the current head `cb763267fc`. A second reply from this job would just repeat it on the PR.

**Checking that answer against the code.** I checked out `build/daemon-agent-tools-explicit-harness` at `cb763267fc`, read the diff against `llm-54d6540`, and read the shell code it relies on. The answer's main claims match the code:
- **Allowlist before spawn:** `exo-shell/src/shell.js:166`.
- **No shell string:** commands run as argv with `shell: false` (`shell.js:180-185`).
- **Timeout:** a per-call timeout can only shorten the policy timeout (`shell.js:173-176`). Expiry sends SIGTERM, then SIGKILL after a grace period (`shell.js:198-204`), to the whole process group (`daemon/src/manager.js:3660-3664`, `host-spawner.js:190`).
- **Environment:** the child gets only `{ PATH: searchPath, LC_ALL: 'C' }` plus the policy's `env` (`manager.js:3650-3655`). If `searchPath` is omitted, it defaults to the daemon's `PATH` at construction time (`daemon/src/host.js:144`).
- **Read-only mounts are refused:** `manager.js:3641-3650`, `shell.js:106`.
- **`inspect()` hides host paths:** it returns only the allowlist, timeout and output cap (`shell.js:152`).
- **The reject options are advisory only:** `agent-tools/src/json-tools/shell.js:20-66`.
- **What it does not confine:** a started command is an ordinary host process with no filesystem, network or resource limits. Kernel-level confinement waits on Phase 2c, the sandbox spawner, which isn't built. This matches the `exo-shell` README's "The honest boundary" section.
- **What this PR adds:** it only exposes the existing Shell tools. It renames `inspect` to `inspectShell` in the combined catalog (`agent-tools/src/workspace.js:97-101`) and adds `defineWorkspaceAgent`, which uses only the grants the caller passes in.

**One minor point is already partly covered.** The existing reply flags that `readOnly: true` combined with a `shell` grant isn't rejected. The PR's `packages/agentry/README.md` already says `readOnly` only drops the file tools' write slice. That isn't documented on `makeWorkspaceTools` in `@endo/agent-tools`, and the combination is still accepted. The reply already offered a follow-up for this, so it's kriskowal's call.

**For the liaison.** This job asked the same thing as the job that posted comment 5940470770, so the comment watcher may have posted the review question twice (possibly a dedup gap between review bodies and issue comments). Worth checking if it happens again.

## Manual gauntlet handoff

The completion guard found https://github.com/endojs/endo-but-for-bots/pull/1348 ready without gauntlet coverage. A deduplicated maintainer action was recorded; the PR was not re-drafted and no gauntlet was staged.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1348-reply-shell-tools-20261001.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 26 tokens (814971 cached reads)
- Output: 5393 tokens
- Cost: $0.8857022000000001
- Wall-clock: 69s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
