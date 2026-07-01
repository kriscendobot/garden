# scripts/checks/

Pre-dispatch grep gates. Each subdirectory is one gate: a deterministic
recursive grep that fires only when a known historical mistake is
present, paired with a focused `claude -p` prompt that gets dispatched
to fix it.

The pattern lands the maintainer's directive on PR #3 review
`4414266979` verbatim: "if we do a recursive grep for the offending
pattern and dispatch an agent only if we detect it, we will never make
the same error again ... a sequence of `git` commands that exit
non-zero if matches are found, followed by a `claude` prompt command
with very focused instructions."

The contract every gate implements is documented in
`skills/pre-dispatch-grep-gate/SKILL.md`.

## Layout

```
scripts/checks/
  README.md                          # this file
  run-all.sh                         # the runner: enumerates gates, runs
                                     # check.sh, on non-zero invokes claude
                                     # with prompt.md
  <gate-name>/
    check.sh                         # exit 0 if clean; exit non-zero if
                                     # the pattern is present
    prompt.md                        # focused prompt: names the pattern,
                                     # the maintainer's reasoning, the fix
                                     # the agent should land
    README.md                        # what the gate catches; the historical
                                     # incident; how to disable if irrelevant
```

## Installed gates

| Gate                                | Catches                                                                                          |
| ----------------------------------- | ------------------------------------------------------------------------------------------------ |
| `bench-engines-rename`              | The `.bench-engines` rename that the steward misapplied twice on PR #387. Endo's actual path is `.engines`. |
| `double-space-sentence-separator`   | Multi-sentence physical lines in markdown / comment files, violating the sentence-per-line wrap rule, modulo a small allowlist of initialisms and salutations. |
| `maintainer-inbox-information-hiding`| An issue/PR-scoped role -- or a skill it loads -- that references the maintainer inbox. Scoped roles communicate via PR/issue comments only; only free-standing roles may name the inbox. |
| `claude-md-inventory-drift`          | A role (`roles/<r>/AGENT.md`) or skill (`skills/<s>/SKILL.md`) present on disk but absent from CLAUDE.md's "## Current inventory" roster. Indexing the roster is a liaison-only meta-doc edit, so authoring jobs drift it; the gate makes the missing row deterministic. |
| `verified-claim-requires-evidence`  | The always-read reporting norm (`roles/COMMON.md`, `roles/gardener/AGENT.md`) or a juror seat (`saboteur`, `skeptic`) having lost the discipline that a "verified" claim must cite real-execution evidence and a UI criterion needs an actual browser run. Provenance: `endojs/endo-but-for-bots` #58 (2026-07-01). |

Run `scripts/checks/run-all.sh --list` to see the installed set
programmatically.

## Running the gates

From any project root:

```sh
scripts/checks/run-all.sh                       # run every gate
scripts/checks/run-all.sh --dry-run             # report which would fire
scripts/checks/run-all.sh --list                # list gate names
scripts/checks/run-all.sh --gate bench-engines-rename
scripts/checks/run-all.sh --base origin/main    # override the diff base
```

The runner reads:

- `GATE_REPO_ROOT`: the project root the gates operate on. Defaults to
  the runner's grandparent (the garden root in the canonical layout).
- `GATE_BASE_REF`: the git ref the diff-aware probes use as a base.
  Defaults to `merge-base HEAD main`, falling back to `HEAD` when
  `main` is absent.

Both are exported to each gate's `check.sh`.

## Where the runner fits

The runner is **step 0** of the pre-CI validation gauntlet. It runs before
the heavyweight `yarn` invocations because:

1. It short-circuits before any heavyweight step burns time.
2. It is the cheapest way to catch historical mistakes: zero token
   cost when no match.
3. The gate's claude invocation, when it fires, runs with the
   focused prompt (small context, fast).

The runner is also wired into `tests/checks/run.sh`, which the
`.github/workflows/checks.yml` workflow exercises on every push to
`main` and on every PR against `main`.

## Adding a gate

1. Create `scripts/checks/<gate-name>/`.
2. Write `check.sh` as a small bash / awk / grep program that exits
   0 when the pattern is absent and non-zero when present. Honor
   `GATE_REPO_ROOT` and (if relevant) `GATE_BASE_REF`.
3. Write `prompt.md`: the focused brief for the dispatched agent.
   Keep it short (the point is low token cost). Name the pattern,
   the maintainer's reasoning, and the fix.
4. Write `README.md` for the gate: what it catches, the historical
   incident that motivated it, how to disable if irrelevant.
5. Add a smoke test under `tests/checks/test_<gate_name>.sh`.

`run-all.sh` enumerates by glob; no central registration step.
