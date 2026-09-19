---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
role: fixer
handler-timeout: 10800
---
Fix the Endo daemon test suite's process leak in `packages/daemon` on
`endojs/endo-but-for-bots`. Two compounding defects were measured directly on a
garden host on 2026-09-18/19; a single gauntlet stage drove a 32-CPU box to load
168 and killed unrelated systemd units by starvation.

MAINTAINER DIAGNOSIS (kriskowal): "There seem to be a lot more endo daemons running
under a single job than ava should be able to drive. The integration tests should
run serially. I suspect that branch has an issue with graceful teardown." Both
halves were confirmed. Evidence below.

## Defect 1 — the `--serial` guarantee is dropped by the invocation

`packages/daemon/package.json` declares:

    "test": "ava --serial"

But the process actually observed running was:

    node .../packages/daemon/node_modules/ava/entrypoints/cli.js \
         --config test/_ava-ses.config.js

with NO `--serial` flag. Two problems:
- Whatever drives this lane calls `ava` DIRECTLY rather than through `yarn test`,
  so the `--serial` in the package script is bypassed and ava falls back to
  concurrent file execution. On a 32-CPU host that fans out hard: ~190 daemon
  processes appeared within roughly the first 70 seconds of the run.
- `test/_ava-ses.config.js` DOES NOT EXIST in the checkout. A repo-wide search
  outside `node_modules` found no such file. So the `--config` argument points at a
  missing path.

TASK: find the invoker (check the package scripts, any CI workflow, and any
`local-verify`-style harness that runs this suite) and make the serial guarantee
non-bypassable. Preferred shape: the suite should be serial BY CONFIGURATION —
`concurrency`/`serial` set in the ava config that actually resolves — so that
calling `ava` directly cannot silently lose it. A flag in one package script is not
a guarantee; it is a convention that the next caller breaks. Also resolve or remove
the dangling `--config test/_ava-ses.config.js`.

## Defect 2 — daemons are not torn down, and ignore SIGTERM

Measured, and this is the more serious defect:

- After the `ava` run EXITED, **211 daemon processes remained alive** in that
  worktree (110 `manager-node.js` + 99 `worker-node.js`).
- **110 of them had `PPID=223`** — reparented to `/usr/lib/systemd/systemd --user`
  because their parents had died. Ages 3913s-7254s, i.e. up to **two hours old**,
  while the `ava` run that spawned them was 2191s and had already exited.
- They were **self-sustaining**: with NO `ava` process running anywhere on the host,
  the youngest daemon was **0 seconds old**. Orphaned managers were still spawning
  fresh workers, so the population GREW (190 -> 212) with no test driving it.
- `SIGTERM` to the managers reclaimed only 9 of 110. The rest **ignored SIGTERM
  entirely** and required `SIGKILL`.

TASK:
1. Ensure every spawned daemon is terminated when its test finishes, pass or fail —
   an `t.teardown()` / `after.always` that actively kills the daemon, not reliance
   on process exit or parent death. A test that leaks a daemon should fail loudly
   rather than leak silently.
2. Fix the SIGTERM handling so a daemon shuts down gracefully on TERM. A process
   that ignores TERM cannot be managed by systemd, by a supervisor, or by an
   operator, and forces SIGKILL — which is what "graceful teardown" precisely is
   not. Investigate why TERM is ignored (handler installed but blocked on an await?
   an uninstalled handler? a detached child that never receives the signal?).
3. Stop the respawn loop. An orphaned manager must NOT continue spawning workers
   once its supervisor is gone. Decide the right shape — parent-death detection, a
   session/process-group kill, or refusing to respawn when the controlling socket is
   closed — and justify it.
4. Consider spawning daemons in their own process GROUP or session so a test (or an
   operator) can reliably tear down the whole tree in one signal, rather than
   chasing reparented children.

## Verification

Run the suite and assert the process count returns to baseline after it exits.
That assertion is the real fix: without it this regresses invisibly. Include a
regression test or a CI check that fails when the suite leaks processes.

## Context for whoever picks this up

The garden host required manual `SIGKILL` intervention to recover. Do NOT treat
this as a garden infrastructure problem — the garden is separately adding
load/memory/IO back pressure at the dispatch edge
(`design-cpu-back-pressure-job-dispatch-20260918`), but back pressure only limits
the blast radius. The leak itself is a defect in this branch's test suite and must
be fixed here.

Do not touch `agoric/agoric-sdk`. Follow the normal build/PR flow and the pre-push
gates. If the work does not fit one handler, split it along the two defects and say
so rather than overrunning.

---
claim:
  host: endolin-garden2-5bcdff64
  gardener: 2
  worker_kind: monk
  tier: 
  provider: anthropic
  model: 
  claimed_at: 2026-09-19T00:55:10Z
