Job complete. Report follows.

---

## Completion report: `improve-monk-node-reap`

**Problem.** `handlers/monk-claude.sh` ran `claude -p` in a foreground subshell and simply `exit`ed with its return code — it never itself waited for the Claude node runtime tree (MCP servers, tool subprocesses) to terminate. Children that `setsid` into their own process group escaped both the handler and gardener.sh's group reap, surviving headless until the *next* worker start's cgroup sweep noticed them: the recurring `garden-monk@N repeatedly starts with left-over node` symptom.

**What I changed** (committed `9905c4b1f2c`, pushed to `main2`):

- **`scripts/jobs/handlers/monk-claude.sh`** — launch `claude -p` under `set -m` so it leads its own **managed process group**, capture its pgid, and arm an `EXIT`/`TERM`/`INT`/`HUP` cleanup trap that reaps the whole runtime tree and **blocks until it drains** before the handler returns. On the gardener timeout-wall `SIGTERM` the trap fires while the runtime is still alive (so a `setsid` child is captured by its intact ppid link before it reparents), and the handler exits the conventional `143`. The `rc` contract, envelope/usage capture, and completion-marker/sentinel logic are unchanged.
- **`scripts/jobs/common.sh`** — two new reusable, defensive helpers:
  - `process_tree_pids <root>` — enumerate a process and all transitive descendants via `/proc` PPid links (finds a `setsid` child a bare group signal misses).
  - `reap_process_tree <root> [grace] [drain]` — `SIGTERM→grace→SIGKILL` over both the pid set *and* the process group (seeding the root's own group so it reaches members that outlive the leader), then a bounded drain loop that waits for the tree to disappear. Refuses unsafe roots and never signals the caller's own tree/group.
- **`scripts/jobs/test/monk-claude-tree-reap-test.sh`** — new suite (20 assertions, all pass): unit coverage of `process_tree_pids` (incl. a setsid child), `reap_process_tree` (guards, setsid-child sweep, leaderless-group sweep, blocks-to-drain), and an integration test driving the real handler with a fake `claude` — proving the normal-exit path sweeps the in-group child and the wall-`SIGTERM` path sweeps the whole live tree including the setsid child.

**Verification.** New suite 20/20. No regressions: `gardener-worktree-test` 44/44, `handler-orphan-reap-test` 15/15, `monk-worker-kind-compat-test` 25/25, `terminal-handler-failure-reap-test` 6/6. `bash -n` clean on all three files; shellcheck shows only house-style `SC2015`/`SC2046` info matching existing siblings.

**Scope note / honest limitation.** gardener.sh's unconditional post-return group reap and the cgroup startup sweep remain as backstops — this is defence in depth at the handler boundary, not a replacement. On a *clean* claude exit, a setsid grandchild that already reparented is inherently beyond a post-hoc reach (the cgroup sweep owns that residual); the high-value case fixed here is the timeout/kill path where claude is still alive.

**Follow-up (not done, out of scope):** the sibling claude-backed handlers (`mentor`, `watchman`, `triager`, `foreman`, `proxy`, `follow-up`, `bulletin`, `self-heal`) each have their own `claude -p` invocation and could adopt the same `reap_process_tree` cleanup; the helper is now available for that.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/improve-monk-node-reap.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 96 tokens (5813755 cached reads)
- Output: 72729 tokens
- Cost: $6.397774500000001
- Wall-clock: 1043s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
