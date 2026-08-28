---
role: builder
tier: mentor
fallback-tier: minion
dispatch: automatic
handler-timeout: 10800
---

# Build a continuous Ironhorse fuzzing service and remove fuzzing from pull-request CI

Source directive: kriskowal on endojs/endo-but-for-bots#1046, comment id
5446442895. This job is explicitly authorized to implement the requested garden
service, amend the bot fork's CI, and create the bot-owned standing pull request.

## Outcome

Move the Ironhorse libFuzzer campaign out of GitHub pull-request CI. Run it
continuously as a bounded, restart-safe, leader-only garden background service.
For every distinct reproducible fuzz finding, preserve the minimized case and
drive a repair job that creates or amends one standing bot-fork pull request with
the regression case and solution. Keep fuzz discoveries from blocking unrelated
pull requests while preserving and improving the present coverage.

## Scope

This is a cross-repository build:

1. In `kriscendobot/garden` on `main2`, add the deterministic service, timer or
   long-running unit, scripts, state, install/reconcile wiring, tests, and concise
   operator documentation. Garden changes land directly on `main2`; do not open a
   garden PR.
2. In an isolated project checkout of `endojs/endo-but-for-bots`, remove the
   `fuzz-ironhorse` pull-request CI job and any now-dead CI-only wiring. Preserve
   locally runnable fuzz targets and developer commands. Open or amend an
   appropriately based bot-fork PR for this project-side change and run its
   required gauntlet.
3. Establish the durable standing-PR workflow for findings. Use a stable bot-owned
   branch and an explicit machine-readable marker so every finding handler finds
   and amends the same open PR instead of opening duplicates. Define what happens
   after that PR merges or closes: the next reproducible case must create the next
   standing PR without losing or duplicating findings.

## Service contract

- Run only on the garden leader and only for the already-authorized bot fork. Do
  not touch upstream `endojs/endo`, switch identity, or ferry.
- Build/reuse the pinned Ironhorse fuzz environment and drive all maintained fuzz
  targets continuously. Resume after restart and update to the configured project
  branch without two hosts running the same campaign concurrently.
- Bound CPU, memory, disk, corpus growth, and per-case reproduction time. A fuzz
  crash or OOM must not take down a gardener, a singleton service, or the host.
- Persist corpora, minimized crash inputs, logs, and deduplication state outside
  ephemeral job worktrees. Record enough provenance to reproduce each finding:
  target, project SHA, toolchain, seed/options, artifact hash, and exact command.
- Deduplicate by stable finding identity. Repeated discovery and service restart
  must not post duplicate repair jobs or duplicate PR commits.
- Treat fuzzer output and crash bytes as untrusted data. Never interpolate them
  into a shell command or an LLM prompt. Repair jobs receive bounded metadata and
  a durable artifact path/hash, then independently reproduce the case before
  changing code.
- For each reproduced case, post a uniquely keyed repair job that owns both a
  load-bearing regression test/corpus case and the causal fix. It must amend the
  standing branch with fetch/rebase/push CAS discipline and report the case and
  solution in the PR body or a PR comment. A finding that cannot yet be solved is
  still represented durably and visibly, without silently disappearing.
- The service itself is deterministic orchestration. LLM work happens only in the
  bounded repair jobs it posts.

## Acceptance evidence

- Hermetic service tests cover leader gating, restart/resume, one finding -> one
  repair job, repeat-finding deduplication, two distinct findings, bounded artifact
  handling, standing-PR adoption, and post-merge rollover to a new standing PR.
- An integration rehearsal with a known synthetic crash demonstrates capture,
  minimization, durable metadata, job posting, and idempotent replay without
  requiring an actual long fuzz wait.
- The project PR shows that ordinary PR CI no longer runs `fuzz-ironhorse`, while
  the fuzz targets remain locally runnable and documented.
- Install/reconcile the unit through the normal garden unit machinery. Do not
  enable or deploy it on a live host unless the existing deliberate-deploy process
  and this job's authority permit that step; report the exact remaining activation
  command if deployment is not performed.
- Report garden commit SHA, project PR URL/head SHA, tests and rehearsal commands,
  resource limits, persistent-state location, standing branch/marker, and any
  unresolved finding backlog.

If the implementation is too large for one handler, decompose it into bounded
ordered children under a serial halt-on-failure orchestration and hand off to that
posted orchestration. Do not leave loose follow-up jobs.

<!-- garden-reap-now -->
---
claim:
  host: endolin-garden-ece02cb4
  gardener: 2
  worker_kind: monk
  tier: 
  provider: anthropic
  model: 
  claimed_at: 2026-08-27T23:34:19Z
