---
ts: 2026-06-03T00:16:40Z
kind: dispatch
role: liaison
host: endolinbot
repo: kriskowal/garden
project: garden
to: fixer
dispatch_root: /home/kris/dispatches/fixer--ab6f0e
prs:
  - repo: kriskowal/garden
    pr: 3
    role: target
refs:
  - https://github.com/kriskowal/garden/pull/3
  - https://github.com/kriskowal/garden/pull/3#pullrequestreview-4414266979
  - https://github.com/endojs/endo/pull/3294#discussion_r3342643104
---

# dispatch: fixer — garden #3 implement pre-dispatch grep-gate pattern

User explicit ask:

> Please dispatch a fixer to address
> https://github.com/kriskowal/garden/pull/3/changes#pullrequestreview-4414266979

kriskowal review `4414266979` (CHANGES_REQUESTED, 2026-06-02T23:07:15Z),
body verbatim:

> We should be able to anticipate feedback like this automatically,
> without using agent tokens unless there is a possibility of a
> violation:
> https://github.com/endojs/endo/pull/3294#discussion_r3342643104
>
> That is, if we do a recursive grep for the offending pattern and
> dispatch an agent only if we detect it, we will never make the
> same error again.
>
> Our subagents should be primed to not only respond to feedback,
> but perform self-improvement like this, extending the automation
> to include guards for common hints and dispatch an agent to
> specifically address them. This would likely be a sequence of
> `git` commands that exit non-zero if matches are found, followed
> by a `claude` prompt command with very focused instructions.
>
> This, presumably could also be used to detect common symptoms of
> forgetting the line wrapping rules, like the introduction of ". "
> or ".  " in a comment or markdown file, except for initialisms
> and salutations. Maybe we dispatch an agent only if these
> patterns are found in the diff, so that we do not relitigate
> salutations.

Pre-dispatch sweep done (per memory
`feedback_sweep_mirror_pr_before_carry_dispatch.md`): only this
one new review since the prior 1c7e27a2 builder dispatch; no
inline comments; no issue comments. Single ask.

## What to land

Implement the pattern as named: each "common hint" / historical
review point becomes a (git command, claude prompt) pair. The
dispatcher runs the git command; if it exits non-zero (match
found), the dispatcher invokes claude with the focused prompt.
Otherwise it's a no-op (no LLM tokens burned).

Land both example gates the maintainer named:
1. **The `.engines` rename mistake** (from endo#3294 discussion
   `r3342643104`, which the steward misinterpreted twice today
   on PR #387; the second attempt cost a force-push to reverse).
2. **Line-wrap rule violation: double-space sentence separator**
   (introduction of `. ` or `.  ` mid-line in comments / markdown,
   except after initialisms and salutations).

### Proposed layout

Under the newly-landed `scripts/` top level (PR #3's main
contribution):

```
scripts/checks/
  README.md                                  # pattern overview + how to add a gate
  run-all.sh                                 # runner: iterates each gate subdirectory,
                                             # runs check.sh, on non-zero invokes claude
                                             # with prompt.md
  bench-engines-rename/
    check.sh                                 # git grep -F '.bench-engines' --
                                             # (or equivalent; matches both source and
                                             # the historical-mistake artifact)
    prompt.md                                # focused prompt: revert .bench-engines to
                                             # .engines, with the maintainer's reasoning
                                             # ("Nothing limits us from using engines
                                             # for other workflows.")
    README.md                                # what this gate catches; the historical
                                             # incident; how to disable if irrelevant
  double-space-sentence-separator/
    check.sh                                 # git grep -nE '\.  ?[A-Z]' or equivalent;
                                             # excludes initialisms (e.g., e.g., i.e.)
                                             # and common salutations (Dr., Mr., Ms.)
    prompt.md                                # focused prompt: rewrap the affected
                                             # comment / markdown to one-sentence-per-
                                             # line, per the garden's wrap style
    README.md                                # what this catches; the wrap rule's source
                                             # (existing em-dash and relative-paths
                                             # skills are nearby precedents)
```

A skill that documents the pattern at large:

```
skills/pre-dispatch-grep-gate/SKILL.md       # the contract every gate implements;
                                             # how to write check.sh + prompt.md;
                                             # how the runner orchestrates them;
                                             # how this composes with the driver's
                                             # pre-CI validation gauntlet
```

### Wiring

`scripts/checks/run-all.sh` is the gate runner. The maintainer
named the shape: "a sequence of `git` commands that exit
non-zero if matches are found, followed by a `claude` prompt
command with very focused instructions."

Sketch:

```sh
#!/bin/sh
set -eu
checks_dir="$(dirname "$0")"
for gate_dir in "$checks_dir"/*/; do
  [ -f "$gate_dir/check.sh" ] || continue
  if ! "$gate_dir/check.sh"; then
    echo "[gate fired] $gate_dir" >&2
    claude -p "$(cat "$gate_dir/prompt.md")"
  fi
done
```

(Refine: include `--output-format json`, lane discrimination,
exit-code propagation per the design's prompt-on-failure
pattern. Use judgment.)

### Integration with the driver

The driver's pre-CI validation gauntlet (§ Driver-run pre-CI
validation in `designs/driver.md`, currently a six-step list
ending with `yarn docs`) gains a new step: **0. Run
`scripts/checks/run-all.sh`** before the existing gauntlet
runs. Pre-dispatch grep gates run first because:

1. They short-circuit before any heavyweight `yarn` invocation.
2. They are the cheapest way to catch historical mistakes:
   ~no token cost when no match.
3. The gate's claude invocation, when it fires, runs with the
   focused prompt (small context, fast).

Update `designs/driver.md` § Driver-run pre-CI validation to
name the gate-runner step explicitly.

### Tests

Each gate needs a smoke test:

```
tests/checks/
  test_bench_engines_rename.sh                # creates a file with .bench-engines,
                                              # runs check.sh, asserts non-zero exit
  test_double_space_sentence_separator.sh     # creates a file with ". " mid-line,
                                              # runs check.sh, asserts non-zero exit;
                                              # also asserts initialisms (e.g.) don't
                                              # trigger
  test_run_all.sh                             # asserts run-all enumerates the gate
                                              # subdirectories and invokes them
                                              # (mock claude binary captures the
                                              # invocation)
```

Add to the existing `tests/driver/run.sh` harness (or a sibling
`tests/checks/run.sh` that the existing `.github/workflows/
driver-tests.yml` can also call).

## Procedure

1. From `project/`, create the `scripts/checks/` tree per the
   layout above. Pick reasonable regex / git-grep invocations
   for each check.sh — the maintainer's two examples are
   guidance, not strict spec; use your judgment on edge cases
   (e.g., line-wrap check excluding `e.g.`, `i.e.`, `Dr.`,
   `Mr.`, `Ms.`, `St.`, `etc.`).
2. Write the focused prompt.md for each gate. Keep small (the
   point is low-token-cost). Each prompt should:
   - Name the pattern that fired.
   - Give the maintainer's reasoning (from the original review
     where applicable).
   - Tell the agent exactly what to fix.
3. Write the skill at `skills/pre-dispatch-grep-gate/SKILL.md`
   documenting the contract: what `check.sh` must do (exit 0 if
   no match, non-zero if match); what `prompt.md` must contain
   (the focused-fix instructions); how `run-all.sh` orchestrates
   them.
4. Update `designs/driver.md` § Driver-run pre-CI validation:
   add step 0 (run pre-dispatch grep gates) before the existing
   six steps.
5. Write `tests/checks/` smoke tests + add a `tests/checks/
   run.sh` runner. Update `.github/workflows/driver-tests.yml`
   to include the new check tests.
6. Run all gates against the current repo state to confirm:
   - `bench-engines-rename/check.sh` exits 0 (no `.bench-engines`
     in the tree currently).
   - `double-space-sentence-separator/check.sh` may legitimately
     fire on existing files; if it does, EITHER refine the regex
     to skip them (initialisms list expansion) OR fix the
     genuine violations as a small follow-up commit (use judgment
     on volume; if too many, just refine the regex to ignore
     them for now and surface the false-positive count in your
     report).
7. Run the test suite: `tests/driver/run.sh` and `tests/checks/
   run.sh`.
8. Shellcheck clean on new scripts.
9. Commit (multiple commits OK for review-friendly granularity):
   - `feat(scripts/checks): pre-dispatch grep-gate harness + bench-engines and double-space gates (#3)`
   - `test(checks): smoke tests for the two example gates (#3)`
   - `design(driver): pre-dispatch grep-gate step in pre-CI gauntlet (#3)`
   - One-or-many commits per your judgment.
10. Push regular-append: `git push origin HEAD:design/driver`.
11. Top-level PR comment on garden #3 (`gh pr comment 3 --repo
    kriskowal/garden`) listing the new artifacts, naming each
    gate, and explaining the runner integration.

## Per-action authorizations

- Create files under `scripts/checks/`, `skills/pre-dispatch-grep-
  gate/`, `tests/checks/`. Authorized.
- Edit `designs/driver.md` to add the pre-CI step 0. Authorized.
- Edit `.github/workflows/driver-tests.yml` to include the new
  check tests. Authorized.
- One or more commits + regular-append push to
  `kriskowal/garden:design/driver`. Authorized.
- Top-level PR comment on garden #3. Authorized.

## Not authorized

- Touching anything outside the paths named in authorizations
  (no scope creep into other roles / skills).
- Refactoring the existing driver code, watchers, daemons, or
  systemd units.
- Un-drafting or re-drafting the PR.
- Force-pushing.
- Merging.

## Dispatch protocol

Read in order:

1. `/home/kris/dispatches/fixer--ab6f0e/garden/roles/COMMON.md`
2. `/home/kris/dispatches/fixer--ab6f0e/garden/roles/fixer/AGENT.md`
3. Other skills referenced just-in-time.

Project worktree at `project/` on `design/driver` (head
`1c7e27a2`). Base is `main`.

**Important**: the journal-side daemon resets
`/home/kris/journal/` every 30s. Use your own
`dispatches/fixer--ab6f0e/journal/` sub-worktree for journal
writes (safe per memory `feedback_journal_poll_daemon_race.md`).

## Report

A `result` journal entry. Include:

- New head SHA after push.
- Per-commit subject + file count.
- The gates landed (names + regex sketches).
- Local test exit codes.
- Shellcheck results.
- Top-level PR comment ID.
- Any genuine double-space violations you fixed (one-line summary
  per file) versus false-positives the regex now ignores.
- Notes on judgment calls (e.g., initialism list contents, the
  `run-all.sh` shape).
