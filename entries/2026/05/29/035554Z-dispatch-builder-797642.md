---
ts: 2026-05-29T03:55:54Z
kind: dispatch
role: builder
host: endolinbot
repo: endojs/endo
project: endo
to: "*"
dispatch_root: /home/kris/dispatches/builder--797642
short_id: 797642
refs:
  - https://github.com/endojs/endo/issues/3289
  - https://github.com/endojs/endo/actions/runs/26615801253/job/78431122540
---

# dispatch: builder — harden install-engines.sh against flaky engine downloads (#3289)

## Task

Open a draft PR against `endojs/endo:master` that hardens
`packages/benchmark/install-engines.sh` so the test-xs job's "Install
engines" step survives the intermittent network failure documented in
issue #3289.

## Underlying failure

- erights filed #3289 (2026-05-28) reporting the `test-xs` "Install
  engines" step flakes frequently. phoddie's comment confirms the
  externally-hosted XS release file is fine when manually downloaded;
  the conclusion is GitHub release CDN flakiness (two hops through
  GitHub's servers per the redirect).
- CI failure on PR #3277, run 26615801253, job 78431122540 shows
  `yarn dlx esvu install xs` then `yarn dlx esvu install v8` both
  emit "esvu ✖ Some engines were not installed." after attempted
  downloads from
  `https://github.com/Moddable-OpenSource/moddable/releases/download/8.1.1/xst-lin64.zip`
  and
  `https://storage.googleapis.com/chromium-v8/official/canary/v8-linux64-rel-15.0.233.zip`.
- The current `packages/benchmark/install-engines.sh` invokes each
  `esvu install <engine>` exactly once and gives up on the first
  failure. No retry, no backoff.

## Acceptance

- The script retries each `yarn dlx esvu install <engine>` invocation
  on failure (small N, e.g. 3 attempts) with a short backoff between
  attempts.
- The existing skip-on-already-installed branch is unchanged.
- The final failure mode (when all retries are exhausted) preserves
  the current diagnostic output: print both captured outputs and
  exit 1.
- `chmod +x` of the engine binaries and the `eshost --add` /
  `eshost --list` tail remain unchanged.
- No CI workflow YAML changes.
- A changeset entry per `skills/changeset-discipline/SKILL.md` if the
  project convention calls for one on infrastructure shell scripts;
  otherwise note its absence in the result.

## Notes for the builder

- The base branch is `endojs/endo:master` at HEAD `052b048` (matches
  the bare clone in this dispatch root's `project/`).
- Per the role's *frozen-base-branch* skill, push the frozen base
  branch (`master-052b048`) to the fork before opening the PR with
  `--base master-052b048 --head <feature-branch>`.
- Verify no open PR already addresses #3289 — the liaison's pre-flight
  found none, but the builder confirms before pushing.
- Conventional-commit: probable shape is
  `fix(benchmark): retry esvu engine downloads on flaky failures (#3289)`
  but the builder picks the final wording per project convention.
- This PR is small (one shell script + maybe one changeset entry).
  The cleaner stage typically follows, then the barrister (first
  panel round). The liaison runs the gamut from this dispatch's
  completion; the builder's deliverable is the draft PR alone.

## Report

Return the PR number, the affected packages, the frozen-base branch
name, and any pre-push-gate findings that required builder action.
The liaison writes the matching `result` entry on return and tears
down this dispatch root.
