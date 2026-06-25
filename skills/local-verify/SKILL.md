---
created: 2026-06-25
updated: 2026-06-25
author: gardener
---

# Skill: local-verify

The deterministic, no-LLM pre-PR verification harness. A builder, fixer, or the
gardening state machine runs it in the project worktree right before pushing a
change for a pull request. It runs the project's real verification steps, in
order, so the work is **offloaded from the CI server**: a change that passes
here is far more likely to be green on the first CI push, which shortens (or
eliminates) the shepherd loop and spends fewer tokens on remote test discovery.

The executable is `scripts/jobs/gardening/local-verify.sh`; this skill is the
contract it implements. It is the default body of the gardening state machine's
"evaluation gate (always)" (`scripts/jobs/gardening/garden-pr.sh`, wired as
`GARDEN_EVAL`); see [gardening-state-machine](../../designs/gardening-state-machine.md).

## Why it exists

CI is the slow, expensive place to discover a format nit, a lint error, a type
break, or a failing test. Every such discovery on CI costs a round trip and a
shepherd loop, and the shepherd then pulls the failure log into an agent's
context to read it. Running the same steps locally first, deterministically and
silently, moves that discovery off the CI server and out of the agent's context:
the shepherd's job shrinks to confirming CI, not discovering failures.

## The steps (in order)

`format -> lint -> build -> test -> docgen`

Run in that order against the project worktree. The harness errs toward running
the project's **full** suite: false positives (a wasted check) are fine, false
negatives (a regression that slips to CI) are not. Steps are not sense-gated,
matching the gardening state machine's "evaluation gate (always)" discipline.

## When to use

- **Before any push to a PR branch** (initial create or follow-up): run it; if it
  exits non-zero, fix the failing step and re-run until it is silent; then push.
- **As the gardening state machine's eval gate**: it is the default `GARDEN_EVAL`,
  so a supervised `garden-pr.sh` run already invokes it. A project that needs a
  different runner overrides `GARDEN_EVAL` with a command taking the worktree as
  its single argument.

It is **not** an orchestrator concern. The liaison and the panel do not run it;
their work is at the journal and review surfaces, not the project working tree.

## Inputs

`local-verify.sh [<worktree>]`

- `<worktree>`: the project tree to verify; defaults to the current directory
  (the gardening `project/` tree).

Per-step command discovery (each step, in order, first match wins):

1. An explicit override env var `LOCAL_VERIFY_<STEP>` (uppercased step name:
   `LOCAL_VERIFY_FORMAT`, `LOCAL_VERIFY_LINT`, `LOCAL_VERIFY_BUILD`,
   `LOCAL_VERIFY_TEST`, `LOCAL_VERIFY_DOCS`):
   - set to a command string: run that command in the worktree;
   - set to `-` (or empty): skip the step.
2. A `package.json` `scripts` entry matching the step's candidate names, run as
   `<yarn> run <script>`. Candidates (check-variant first so the harness verifies
   rather than mutates where a project offers the choice):

   | Step    | package.json script candidates                 |
   | ------- | ---------------------------------------------- |
   | format  | `format:check`, `check:format`, `format-check`, `format` |
   | lint    | `lint:check`, `lint`, `eslint`                  |
   | build   | `build`, `compile`, `build:js`                  |
   | test    | `test`, `test:unit`                            |
   | docs    | `docs`, `build:types`, `generate-docs`         |

3. Otherwise the step is skipped (recorded, silent).

The package runner defaults to `yarn` when present, else `npx corepack yarn`
(plain `yarn` is often absent in a fresh worktree; see
[pre-pr-checklist](../pre-pr-checklist/SKILL.md) § Pitfalls). Override with
`GARDEN_YARN`. A project with no `package.json` and no overrides verifies nothing
and exits 0; wire the real commands per project via package.json scripts or the
overrides. The candidate lists are deliberately small and extensible: add a
project's script name to the table rather than hardcoding one project's commands.

Discovering the real commands per project draws on `package.json` scripts, the
repo's CI workflow, and the [pre-pr-checklist](../pre-pr-checklist/SKILL.md) /
[pre-push-gates](../pre-push-gates/SKILL.md) skills.

## State

The harness is stateless. Each invocation reads the worktree, runs each
discovered step, and exits. Re-running is idempotent and deterministic: identical
inputs hash to identical SHAs, so a recurring failure is recognizable by its
content address. The harness does **not** commit, push, or mutate tracked files
(beyond whatever a project's own `format`/`build` script does when no check
variant exists). It writes only unreferenced git blobs into the worktree's object
store for failure captures, which `git gc` collects.

## Procedure (what the harness does)

For each step, in order:

1. Discover the command (overrides, then `package.json`, then skip).
2. Run it in the worktree, capturing **combined stdout+stderr** to a temp file.
3. **On success: emit nothing** and discard the temp file. The blob is not even
   hashed (nobody needs it); the step silently passed.
4. **On failure**: hash the captured output into the worktree's object store via
   `git hash-object -w` (the `capture_blob` helper from `scripts/jobs/common.sh`)
   and emit **only**:

   ```
   STEP <name> FAILED: output blob <sha> (<n> lines) inspect: git -C <wt> cat-file -p <sha>
     <last non-empty line of the captured output>
   ```

   The raw output never reaches stdout. The harness runs **all** steps (it does
   not stop at the first failure) so the final report enumerates every failing
   step, then exits non-zero.

## Output

- Exit 0, no output: every discovered step passed (or was skipped). The caller
  proceeds to push with confidence.
- Exit non-zero: one block per failing step (step name + blob SHA + one-line
  tail + inspect command). The caller hands the SHAs to a debugging agent.

The exit code is the harness's sole machine-readable signal; the per-failure
blocks are the human/agent-readable surface.

## The debugging-agent contract (selective inspection)

This is the token-efficiency core. A debugging agent handed a failure block reads
**only the slices it needs** from the blob, never the whole log:

```sh
# the failing test's assertion and the lines around it
git -C <worktree> cat-file -p <sha> | grep -n -A5 -B2 'FAIL\|Error\|✗'
# just the first error
git -C <worktree> cat-file -p <sha> | grep -m1 -i error
# the tail (a stack trace, the summary line)
git -C <worktree> cat-file -p <sha> | tail -40
# a specific failing file's section
git -C <worktree> cat-file -p <sha> | sed -n '/packages\/foo/,/^$/p'
```

The full log is in git, content-addressed and immutable, but it enters the
agent's context only one narrowed slice at a time. This generalizes the gardening
state machine's diverted `GARDEN_TRACE` (trace to a file a debug subagent reads,
not to the supervisor's stdout) and the
[prompt-on-failure-capture](../prompt-on-failure-capture/SKILL.md) pattern
(hash a failure log into git, pass the SHA, inspect on demand). The shared
primitives are `capture_blob` / `inspect_note` / `anchor_blob` in
`scripts/jobs/common.sh`.

Cross-host note: `git hash-object -w` writes the blob into the **local** object
store of the worktree only. A same-host debugging agent (the usual case: the
gardener supervising this PR) reads it directly. To make a capture inspectable
from another host, anchor it under a ref and push it
(`anchor_blob`), per [prompt-on-failure-capture](../prompt-on-failure-capture/SKILL.md)
§ Cross-host reachability.

## How it plugs into the shepherd/builder flow

- The gardening state machine (`garden-pr.sh`) runs it as the eval gate before
  the CI push. A failing gate fails loud with the emitted SHAs; the supervising
  gardener runs the **capture → hash → debugging-agent → fix → re-verify loop**
  locally until the gate is silent, then pushes. CI then sees a pre-vetted change.
- The shepherd's role shrinks accordingly: it confirms CI converged rather than
  discovering failures CI surfaces. A change that cleared the local gate is the
  short (or empty) shepherd loop the harness is built to produce.

## Composition with other skills

- [pre-push-gates](../pre-push-gates/SKILL.md): the deterministic *style/probe*
  gate (Prettier/eslint auto-fix, garden-specific probes, typecheck). It runs
  auto-fixers and re-stages; `local-verify` runs the project's *verification*
  suite read-only and captures failures by SHA. They are complementary: the
  push path runs the style gate (mutating auto-fixes) and then `local-verify`
  (read-only full suite) before pushing.
- [pre-pr-checklist](../pre-pr-checklist/SKILL.md): the broader human-facing
  review-yourself list; `local-verify` is the deterministic full-suite subset
  that runs without an LLM.
- [prompt-on-failure-capture](../prompt-on-failure-capture/SKILL.md): the
  capture-by-SHA escalation primitive `local-verify` reuses for its failure path.

## Tests

`scripts/jobs/test/local-verify-test.sh` exercises the contract against throwaway
git repos with a stubbed runner (`GARDEN_YARN`): a full pass is silent and exits
0; a failing step emits only the step name + SHA + one-line tail (no raw body);
`git cat-file -p <sha>` returns the captured output; discovery picks the
check-variant; overrides skip and replace; a repo with no `package.json` exits 0;
and the same failure hashes to the same SHA (determinism). `bash -n` and
`shellcheck` clean.

## Pitfalls

- **A project's `format` (no check variant) mutates the tree.** When only the
  mutating `format` script exists, the harness runs it; the auto-fix lands in the
  working tree like the style gate's. Prefer a `format:check` script where the
  project offers one; the candidate order already favors it.
- **Per-project specialization belongs in the project's scripts**, not the
  harness. The harness is the contract; the project's `package.json` scripts
  implement. Extend the candidate table for a new script name rather than
  branching on a project.
- **Do not inline a failure log into a prompt.** The whole point is the SHA: pass
  it, inspect slices. A debugging agent that `cat-file`s the whole blob into
  context has defeated the harness.

## Notes from the field

(Append; terse and dated.)

- _2026-06-25_: initial build (job `build-local-prepr-verification`). Wired as the
  default `GARDEN_EVAL` in `garden-pr.sh`, replacing the `true` no-op placeholder.
  Reuses `capture_blob` from `common.sh` (the audit-self-healing-wrappers
  primitive). Hashes only on failure (success needs no blob), a deliberate read
  of the "hash then discard on success" contract that avoids creating GC'able
  loose objects on the common path.
