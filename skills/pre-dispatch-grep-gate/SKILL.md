---
created: 2026-06-03
updated: 2026-06-03
author: fixer
---

# Skill: pre-dispatch-grep-gate

The pattern every gate under `scripts/checks/` implements. A gate is a
pair: a recursive grep (`check.sh`) that exits non-zero only when a
known historical mistake is present, and a focused claude prompt
(`prompt.md`) the runner dispatches when the grep fires. The
deterministic check is the cheap path; the LLM dispatch is the
expensive path; the grep is the gate that keeps the expensive path
from running on a clean tree.

The pattern lands the kriskowal PR #3 review `4414266979` directive:
"if we do a recursive grep for the offending pattern and dispatch an
agent only if we detect it, we will never make the same error again
... a sequence of `git` commands that exit non-zero if matches are
found, followed by a `claude` prompt command with very focused
instructions."

## When to use

- **Adding a new gate**: a maintainer review surfaces a class of
  mistake the garden made (or could make) more than once, and the
  mistake has a deterministic textual signature. The signature plus
  the fix become a new gate under `scripts/checks/<gate-name>/`.
- **Running the gauntlet**: the driver's pre-CI validation step 0 is
  `scripts/checks/run-all.sh`. The runner iterates every installed
  gate, runs each `check.sh`, and on non-zero invokes `claude -p`
  with the corresponding `prompt.md`. Step 0 runs before the
  heavyweight `yarn format / lint / typecheck / test / docs`
  gauntlet because grep is cheap and a fired gate may rewrite files
  the heavyweight gauntlet would then have to re-check.
- **Manually before push**: a fixer or builder can run
  `scripts/checks/run-all.sh --dry-run` before opening a PR to
  surface any gate that would fire without paying for the agent
  dispatch.

## Inputs

The runner `scripts/checks/run-all.sh` takes:

- `--dry-run`: report which gates would fire without invoking claude.
- `--list`: list installed gate names and exit.
- `--gate <name>`: run only the named gate (repeatable).
- `--base <ref>`: git ref to diff against for diff-aware gates.
- `--repo <path>`: project root to operate on.

Each gate's `check.sh` honors two environment variables the runner
exports:

- `GATE_REPO_ROOT`: project root the gate scans.
- `GATE_BASE_REF`: ref for diff-aware probes (default: merge-base
  HEAD main, fall back to HEAD).

## State

Stateless. Each invocation reads the working tree (and optionally the
diff against a base), reports, and exits. The runner does not commit
or push; the dispatched agent (when a gate fires) does that work.

The gate's idempotence shape: a clean tree exits 0 immediately. A
dirty tree fires the gate, the agent fixes the offender, and the next
invocation exits 0. No persistent state between invocations.

## Procedure

### Authoring a gate

1. **Decide the scope**: whole-tree (a literal-string antipattern,
   like `bench-engines-rename`) or diff-scoped (a wrap rule that
   should only apply to new content, like
   `double-space-sentence-separator`).
2. **Pick the signature**: a `git grep`, `grep -RnE`, or `awk` over a
   diff that exits 0 on absence and non-zero on presence. Keep it
   small: a gate is a one-screen script.
3. **Carve out the gate's own files** from the match. The gate's
   README and prompt name the antipattern by example; without the
   exclusion the gate fires on its own documentation.
4. **Write `prompt.md`**: the focused brief for the dispatched
   agent. Sections to include:
   - The pattern (what fired).
   - The maintainer's reasoning (link to the originating review or
     discussion).
   - What to do (re-run the gate, fix, re-run, commit).
   - Out of scope (what the agent should not change).
   Keep it short. The point of the gate is low token cost; a long
   prompt defeats the design.
5. **Write `README.md` for the gate**: what it catches, the
   historical incident that motivated it, how to disable.
6. **Add a smoke test** under `tests/checks/test_<gate_name>.sh` per
   `tests/checks/README.md`.

### Running the gates

The runner enumerates by directory glob (`scripts/checks/*/check.sh`)
and does not require a central registration step. Adding a gate is
purely additive: a new subdirectory and a new test file.

The runner's exit code:

- `0`: every gate exited 0.
- `1`: at least one gate fired. In `--dry-run`, that is the whole
  story. Without `--dry-run`, each fired gate triggers a `claude -p`
  invocation with its `prompt.md`; the runner still exits 1 so the
  caller knows a follow-up dispatch happened.
- `64`: usage error.

### Wiring into the driver

The pre-CI validation gauntlet (designs/driver.md § Driver-run pre-CI
validation) names `scripts/checks/run-all.sh` as **step 0**, before
`yarn format`. The ordering matters:

1. Grep gates run first because they short-circuit before any
   heavyweight `yarn` invocation runs.
2. If a gate fires, the dispatched agent may modify files; the
   heavyweight gauntlet then sees the modified tree and is the
   appropriate place to re-format / re-lint / re-test.
3. If no gate fires, the cost is one `find` plus one grep per gate;
   negligible compared to `yarn` startup.

## Output shape

For each invocation, the runner emits:

- For each gate that exited 0: silent.
- For each gate that exited non-zero: a `[gate fired] <name>` line
  on stderr, followed by the gate's own diagnostic output (the
  matching lines), followed by the `claude -p` invocation (unless
  `--dry-run`).
- A final summary line on stdout: either "pre-dispatch grep gates:
  all N clean." or "pre-dispatch grep gates: M of N fired:
  <names>."

The dispatched agent's output (when a gate fires) is whatever the
gate's `prompt.md` instructs it to produce: typically a small
committed fix.

## Notes

- The gate runner does not splice the matching lines into the
  prompt; the prompt instructs the agent to re-run the grep itself.
  This keeps the prompt small and lets the agent see the current
  state of the tree (which may have moved since the gate fired).
- A gate's `check.sh` runs in its own subshell so a `set -e` inside
  it cannot taint the runner.
- The gate set is project-agnostic in shape but project-specific in
  content: each gate catches a mistake the garden made (or could
  make) on a specific repo. Gates that only apply to one repo can
  scope themselves by inspecting `GATE_REPO_ROOT`'s remote URL or
  by including a `git remote get-url origin` check at the top.
- The complementary skill `skills/pre-push-gates/SKILL.md` runs a
  broader, file-scoped set of probes inside the builder / fixer's
  `yarn`-anchored stage; this skill's diff-scoped grep gates run
  before that stage. The two are intentionally separate: pre-push
  gates assume a working tree the builder is about to push;
  pre-dispatch grep gates assume a working tree the driver is
  about to validate.
