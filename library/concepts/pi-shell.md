---
id: pi-shell
aliases: [pi-shell, oh-my-pi shell, pi_shell::Shell, terminate_tree, kill_tree, CancelToken, GIT_REPO_LOCATION_ENV_VARS]
topics: [shell-runtimes, agent-workspaces]
kind: concept
---

# pi-shell

`pi-shell` is oh-my-pi's Rust shell-execution crate over the vendored brush interpreter. It provides persistent and one-shot shell sessions whose filesystem can be injected per session or per run, PID-reuse-safe process references with a terminate-then-kill tree shutdown that spares the harness, a deadline-plus-reason cancel token, and environment hygiene that keeps Git from being pinned to the launch checkout. Output compaction is a separate concept, [[pi-shell-output-minimizer]].

## Sections that touch this concept

| Section | What it contributes |
|---------|---------------------|
| [embedded shell public surface](../sections/oh-my-pi--crates-pi-shell-src-lib--embedded-shell-public-surface.md) | The crate's module map and brush/pi-builtins re-exports. |
| [session and run execution contract](../sections/oh-my-pi--crates-pi-shell-src-shell--session-and-run-execution-contract.md) | Session vs run options, live pids, background-job retention, raw streaming, cancellation grace, Git env stripping. |
| [identity-pinned process references](../sections/oh-my-pi--crates-pi-shell-src-process--identity-pinned-process-references.md) | pidfd, start-time, and handle-pinned process identity per platform; `signal` and `kill_tree`. |
| [graceful tree termination and harness protection](../sections/oh-my-pi--crates-pi-shell-src-process--graceful-tree-termination-and-harness-protection.md) | `terminate_tree`'s two waves and the protected-subtree pruning (#7452). |
| [cancel token](../sections/oh-my-pi--crates-pi-shell-src-cancel--deadline-and-abort-reason-token.md) | `CancelToken`/`AbortToken` semantics and the deadline-vs-explicit-abort distinction. |
| [N-API shell sessions and filesystem injection](../sections/oh-my-pi--crates-pi-natives-src-shell--napi-shell-sessions-and-filesystem-injection.md) | How the JavaScript layer exposes these sessions. |

## See also

- [[brush-shell]] for the interpreter underneath.
- [[pi-vfs]] for the filesystem a session runs against.
- [[pi-builtins]] for the in-process utilities a session registers.
