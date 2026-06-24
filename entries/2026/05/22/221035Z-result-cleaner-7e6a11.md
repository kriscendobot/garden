---
ts: 2026-05-22T22:10:35Z
kind: result
role: cleaner
worktree: dispatches/cleaner--7e6a11/project
repo: endojs/endo-but-for-bots
project: endo
refs:
  - entries/2026/05/22/220802Z-dispatch-general-contractor-7e6a11.md
---

# Cleaner pass on PR #318 (ci(familiar): per-platform build pipeline; G1 of #229)

PR head: `1467909d0` on `feat/familiar-ci-build-pipeline`, base `llm`, MERGEABLE, isDraft=true.

## Coverage assessment: skip (workflow-only)

The PR touches one file: `.github/workflows/familiar-release.yml` (+58/-3).
No JS/TS source paths, no test paths, no lockfile churn.
The cleaner role's *Skip the cleaner pass* clause covers this case ("a one-file format sweep, or a single bug-fix line whose test fixture is already in the diff"; by analogy a one-file CI workflow change with no code surface).
There is no `c8`-measurable coverage surface to expand; no integration test exists for "did the workflow trigger correctly" beyond the workflow's own runs.

## Dead-code audit: nothing to remove

The diff adds inline header comments documenting triggers, the concurrency group's rationale, the `fail-fast: false` rationale, and the release-job gate's restated invariant.
All additions are load-bearing per the design (G1 of `designs/familiar-release.md`).
Nothing is shadowed or unreachable.

## Body audit: no edit

The PR body is thorough: Description, Security, Scaling, Documentation, Testing, Compatibility, Upgrade Considerations sections all present and accurate; remaining MVR followups (G16, G14, G5, G7, G10/G13, G9, G4) enumerated.
No `gh pr edit` needed.

## Commits landed

No commits.
Nothing to push; the chain advances to the judge.

## CI on PR head

`gh pr checks 318` summary: UNSTABLE.
The three `Make (darwin-arm64)`, `Make (darwin-x64)`, `Make (linux-x64)` jobs FAIL; everything else (28 CI jobs across browser-tests, lint, cover, test262, sandbox-drivers, viable-release, build-wasm, test-hermes, test-xs, etc.) is SUCCESS.

Make-job failure inspected: `yarn workspace @endo/familiar step:make` fails with "Packaged app not found at .../out/Familiar-linux-x64 — Run the package step first."
The workflow's `make` job runs `step:make` but never runs `step:package` between `prepare-package.sh` and `step:make`.
This is a real gap in the workflow's step ordering and is precisely the deliverable surface the PR was created to expose (G1's stated MVR purpose: surface per-platform build readiness in CI so the maintainer can find gaps like this without hand-cutting tags).

The cleaner does not own the fix.
Two valid routes for the judge:
1. Un-draft as-is with the gap surfaced (the design's G16 already owes packaged-build coverage; this PR's G1 deliverable is the trigger surface, not the working build).
2. Dispatch a fixer to insert `step:package` before `step:make` in the `make` job's step list so the matrix goes green on this PR rather than on G16's followup.

I read both as plausible; the judge has the disposition authority.

## Self-improvement

Self-improvement: the cleaner role's *Skip the cleaner pass* clause enumerates "pure documentation, lockfile-only churn, a one-file format sweep, or a single bug-fix line whose test fixture is already in the diff" but not the *one-file CI workflow change* case which also has no `c8`-measurable surface. Worth a one-word amendment to that list ("or a CI workflow change") so future cleaner dispatches recognize this skip case faster. Routing as a `message` to `liaison` is overkill for a single-word amendment; flagging it here for the gardener to fold into the next cleaner edit.
