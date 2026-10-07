---
title: pi-shell session and run execution contract
source: crates/pi-shell/src/shell.rs
source_repo: can1357/oh-my-pi
source_commit: 53f253fb709fe890adf1fa37f0bc69cf02a5d86c
source_date: 2026-10-07
source_authors: [can1357, roboomp, Brit, CoderTCY, oldschoola]
ingested: 2026-10-07
ingested_by: scholar
topics: [shell-runtimes, agent-workspaces]
status: current
notes: shell.rs is ~7.4k lines with a one-line module header ("Runtime-agnostic brush shell execution."). This section records only the documented public contracts and the Git-environment isolation constant; the brush wiring, output pump, Windows pipe handling, and builtin registration internals are deliberately deferred.
---

> Abstract: `pi_shell::Shell` is a persistent brush session. Its runs are serialized on one session lock and may each replace the session filesystem. `pids()` lists a live run's external children without taking that lock, and `live_background_job_count()` tells the host whether `&` children would be killed if the shell were dropped. `execute_shell` and `execute_shell_streams` are the one-shot forms; the streaming form delivers raw stdout and stderr bytes and disables the minimizer. The host environment is copied in with Git repository-location variables (`GIT_DIR` and five others) removed, so `git` rediscovers the repository from the run's `cwd`.

## Session versus run

- `ShellOptions` configure a session: `session_env`, `snapshot_path` (a snapshot sourced during setup, which belongs to the creating run, so its provider calls stop with that run's cancellation), `minimizer`, and `filesystem` ("Filesystem backing every run of the session (native by default)").
- `ShellRunOptions` configure one run: `command`, `cwd`, `env`, `timeout_ms`, and `filesystem` ("Filesystem for this run only; the session filesystem when `None`").
- `ShellRunResult` reports `exit_code`, `cancelled`, `timed_out`, an optional `minimized` record (`filter`, `text`, `original_text`, input/output byte counts), and the final `working_dir`.
- The session core is created lazily under a Tokio mutex held for the whole command, so concurrent `run` calls queue. Sessions start with `do_not_inherit_env`, skip profile and rc files, and use the Bash-mode builtin set.

The [N-API shell binding](oh-my-pi--crates-pi-natives-src-shell--napi-shell-sessions-and-filesystem-injection.md) exposes these fields to JavaScript, and its `filesystem` field is the [`ShellFilesystem` bridge](oh-my-pi--crates-pi-natives-src-shell-vfs--routing-lifetime-and-consumers.md).

## Observing a live run

- `pids()`: "Pids of the processes spawned by the in-flight `Shell::run` that are still alive, in spawn order. Covers every external child the run started — foreground commands, pipeline stages, and `&` background jobs — but not builtins, which run in-process. Empty when no run is executing (including one still waiting for a previous run to release the session). Never blocks on the session lock held by a running command." The spawn registry is published in a separate slot that a drop guard clears on return, error, cancellation, or task abort.
- `live_background_job_count()` reaps completed jobs silently, then counts live `&`/`nohup` children. "The host uses this to decide whether to retain a per-call shell whose background children are still running instead of dropping it (which would SIGKILL them on kill-on-drop)."
- `abort()` aborts the session's in-flight run.

## One-shot execution

- `execute_shell(options, on_chunk, cancel)` runs one command in a fresh session, with the same session and run fields flattened into `ShellExecuteOptions`.
- `execute_shell_streams(options, sinks, cancel)` delivers stdout and stderr "as raw byte chunks … on separate channels with no UTF-8 decoding and no merging." A stream whose sink is `None` is still drained so the child never blocks, but its bytes are dropped. "The minimizer is intentionally disabled — its `MinimizerResult.text` contract presumes a single merged transcript."

## Cancellation wind-down

A cancelled run gets a grace period to wind down before its task is aborted and any output still queued in the pipe readers is discarded: 2 seconds on Unix, 5 on Windows. On Windows the longer wait exists because in-process pipeline stages cannot observe cancellation from a blocked pipe read. Each hop needs a separate thread wakeup, and under load a 2-second grace "discarded the consumer's final output mid-flight (`yes x | tail -5` lost its 5 lines)."

## Git repository-location isolation

`GIT_REPO_LOCATION_ENV_VARS` = `GIT_DIR`, `GIT_COMMON_DIR`, `GIT_WORK_TREE`, `GIT_INDEX_FILE`, `GIT_OBJECT_DIRECTORY`, `GIT_ALTERNATE_OBJECT_DIRECTORIES`. "Forwarding them into a shell makes `git` ignore the command's working directory and mutate the wrong worktree or index, so the shell rediscovers the repository from `cwd` instead." These variables are dropped both when the host process environment is copied into the session and when `session_env` is applied. The match is case-insensitive on Windows. The list mirrors the `env_remove` list in `crates/pi-vcs/src/git/cli.rs`.

This is the same failure class as the garden's 2026-07-17/07-21 root-repo corruption, where Git run with the wrong enclosing repository mutated the shared root. The garden answers it with `GIT_CEILING_DIRECTORIES` and a prohibition on running Git in the root; oh-my-pi answers it by stripping location overrides so discovery always starts from `cwd`.

## Deferred

The remaining ~7k lines (brush session construction, output pumping and decoding, minimizer integration points, the `PI_SMART_GIT` builtin hook, Windows-specific pipe handling) carry few doc comments beyond those above. They are not ingested; a future cycle should read them only if a concrete question needs them.

Source: [crates/pi-shell/src/shell.rs](https://github.com/can1357/oh-my-pi/blob/53f253fb709fe890adf1fa37f0bc69cf02a5d86c/crates/pi-shell/src/shell.rs) at commit `53f253fb`.
