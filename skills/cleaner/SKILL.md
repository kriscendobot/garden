---
created: 2026-06-01
updated: 2026-06-01
author: builder
---

# Skill: cleaner

The cleaner's per-role executable for the script-orchestrated worker-pool model from [`designs/driver.md`](../../designs/driver.md).
Phase 1 ships a skeleton that demonstrates the worker-pool handshake end to end: a job posted to either board shape (flat `jobs/{open,claimed}/` or per-role `jobs/cleaner/{open,claimed}/`) is picked up and moved to the matching `done/` with a completion stamp.

The role's full operating brief is at [`roles/cleaner/AGENT.md`](../../roles/cleaner/AGENT.md).
This skill is the bash-process side of the cleaner role; the AGENT.md is the LLM-subagent side.
Phase 3 lands the real coverage-driven-testing body inside this script; phase 1 leaves it as a no-op so the worker-pool wiring can be exercised end to end without dragging in the full cleaner machinery.

## When to use

- The driver posts a `clean` job (per `skills/driver-pr-creation-state-machine/SKILL.md` § `clean` state).
- A worker daemon polling either the flat board (`jobs/open/` with `eligible_roles:` containing `cleaner`) or the per-role board (`jobs/cleaner/open/`) claims the job and invokes this script with the claimed path.
- The script does the work (phase 1: no-op stub; phase 3: coverage-driven-testing pass) and moves the job to `done/` or `abandoned/`.

## Inputs

`cleaner.sh <job-path>` where `<job-path>` is relative to the journal worktree (e.g. `jobs/open/<UTC>--<short-id>--<slug>.md` or `jobs/cleaner/open/<UTC>--<short-id>--<slug>.md`).

`GARDEN_ROLE=cleaner` should be set by the caller (the worker daemon's bootstrap; the skeleton tolerates it being unset but expects the caller to set it for downstream identity discipline).

Environment overrides:

- `GARDEN_ROOT`: defaults to the script-location-relative parent (`skills/cleaner/../..`).
- `CLEANER_JOURNAL_DIR`: defaults to `$GARDEN_ROOT/journal`. The test harness overrides this to a mock journal tree.
- `CLEANER_WORK_HOOK`: optional executable invoked with the job's full path; if it exits non-zero the job moves to `abandoned/` instead of `done/`. Used by the test harness to exercise the negative path.

## Output

- The job file is moved from its `open/` or `claimed/` directory to the matching `done/` or `abandoned/` directory under the same board prefix.
- The script prints the destination path (relative to the journal worktree) on stdout.
- Exit code 0 on `done`, 1 on `abandoned`, 64 on usage error.

The script does **not** commit-and-push the move. The supervisor or driver is responsible for the journal sync cadence (the existing `skills/job-board/job-board-poll.sh` daemon handles the read side; the cleaner's caller handles the write side after the worker returns).

## Both board shapes

Phase 1 supports both shapes because the design names per-role boards as the layout but the current driver implementation uses the flat board with an `eligible_roles:` filter:

- **Flat board**: `jobs/open/<...>.md` with `eligible_roles: [- cleaner]`. The cleaner worker is one of several roles that may claim from `jobs/open/`; the filter prevents non-cleaner workers from claiming.
- **Per-role board**: `jobs/cleaner/open/<...>.md`. Only cleaner workers poll `jobs/cleaner/open/`.

The skill accepts either path on argv; the maintainer's preferred layout is a design-level decision the script can follow once it converges.

## Self-test

A quick self-test sits next to the script at [`test-cleaner.sh`](./test-cleaner.sh).
It builds a tiny mock journal in a tempdir, posts one job in each board shape, runs the cleaner on each, and asserts the resulting done-file has the completion stamp.

```sh
skills/cleaner/test-cleaner.sh
```

Exit code 0 iff both shapes pass.

## Notes from the field

(Append; terse and dated.)

- _2026-06-01_: initial skeleton landed as part of phase 1 of the driver migration (PR #3 § Migration plan). Phase 3 lands the real coverage-driven-testing body; until then `CLEANER_WORK_HOOK` is the only way to exercise the negative path.
