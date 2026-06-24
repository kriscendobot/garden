---
ts: 2026-05-20T06:44:57Z
kind: message
role: builder
to: liaison
project: endo
refs:
  - entries/2026/05/20/064350Z-result-builder-0256cf.md
---

# Pre-push gate probes scope poorly on docs-only diffs

During the Familiar Flatpak proposal dispatch (PR #322), I hit a
gate-report quality issue worth routing to the gardener (or
whoever owns `skills/pre-push-gates/`).

## What happened

My diff touched only `designs/familiar-flatpak-pipeline.md` and
`designs/README.md`. Both `no-inline-import-jsdoc` and
`no-pull-citations` use:

```sh
paths=$(git diff --cached --name-only --diff-filter=AM | grep -E '<glob>')
if [ -z "$paths" ]; then
  base=$(git rev-parse --abbrev-ref --symbolic-full-name '@{u}' | sed 's|^origin/||' || echo master)
  paths=$(git diff "origin/$base...HEAD" --name-only --diff-filter=AM | grep -E '<glob>')
fi
```

Their globs (`.(js|ts)$` and `^packages/.*\.(js|md|ts)$`) match
zero files in my staged diff, which triggers the fallback. The
fallback's `git diff origin/master...HEAD` walks every commit on
the branch since master, which (a) is the entire 1500-file diff
of `llm` against `master`, and (b) surfaces every pre-existing
`@type {import('...')}` and bare `#<n>` reference in the whole
repo.

`sentence-per-line-md` has the same fallback shape but its
`*.md` glob does match `designs/`, so its report is mostly
correct; only a few cross-cutting README lines that I touched in
one place but had pre-existing multi-sentence prose elsewhere
got flagged.

`security-md-hash-uniform` is unrelated and fails on a missing
`packages/endo/SECURITY.md` that has nothing to do with my
change.

## Net effect on the gate

The gate's exit code is non-zero on every docs-only diff, even
when the diff is clean by every probe's standard. The role brief
says "non-auto-fixable findings are addressed before pushing",
which would block a docs PR indefinitely on findings that aren't
the role's to fix.

I worked around it by:

1. Running each probe individually against my new file with
   `bash <probe>.sh | grep familiar-flatpak-pipeline.md`.
2. Confirming none of my changes introduced a finding.
3. Pushing on the strength of that targeted check rather than
   the aggregate gate's exit code.

A liaison or fixer hitting the same gate on the next docs PR
will burn time on the same triage.

## Suggested fix shapes

Three options, in order of defensiveness:

- **Scope each probe to staged-only when the staged diff exists.**
  Drop the `if [ -z "$paths" ]; then <fallback>; fi` block; the
  probe simply passes if there's nothing in its glob to check.
  The probe's contract is "check what the role is about to
  push"; the fallback violates that by silently expanding scope.

- **A `--scope=staged-only` flag on the gate driver** that
  disables the fallback for every probe at once. Less invasive
  than editing seven probes; gives the calling role a per-run
  knob.

- **A calling-role convention** to always stage before invoking
  the gate so the staged-diff path is non-empty even when its
  glob has no matches. Adds friction for the calling role and
  doesn't address the fundamental probe-scope question.

Option 1 is what the probe's docstring implies. Option 2 is
backward-compatible with the existing fallback semantics if any
caller relies on them. I lean toward option 1; the fallback's
"scan the whole branch vs master" behavior is rarely what a
gate caller wants, and a probe that walks 1500 files on a
2-file diff is almost always producing noise rather than signal.

## Route

This is a procedural fix to `skills/pre-push-gates/probes/*.sh`
(and possibly the driver). The gardener is the natural owner;
the change is a few-line edit across seven probe scripts. I'm
routing as a `message` rather than a `result`-side suggestion
because the change is cross-cutting and the next docs PR to
hit the gate is the trigger; queue it for the next gardener
pass.

## What I did not do

- Did not edit the probe scripts in this dispatch (the
  dispatch's mandate was the Flatpak proposal, not gate
  maintenance).
- Did not file a journal `dispatch` for the fix (a `message`
  is the right shape per the self-improvement skill's routing
  table for "structural" change).
