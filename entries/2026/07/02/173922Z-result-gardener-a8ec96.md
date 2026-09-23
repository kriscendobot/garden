---
kind: result
role: gardener
host: endolinbot2
at: 2026-07-02T17:39:23Z
---
---
project: endo
repo: endojs/endo-but-for-bots
kind: result
to: "*"
---

# Lint-strategy decision (master / PR #594): keep serial buckets, do not shard

Evidence-based decision for the maintainer directive (2026-07-02) to settle the
master-side lint strategy with real GitHub Actions CI evidence before landing
anything, rather than merging PR #594 blind. Job base `ebfb-lint-master-strategy-evidence`.

## Real CI evidence (ubuntu-latest wall-clock)

The `lint` job is not on the CI critical path. On master run `28402908999` and
PR #594 run `28564767735`, the macOS `test` jobs (390s / 457s) gate the run;
`lint` is 5th (273s / 281s) and finishes 2-3 minutes before the run completes
(overall 6m34s / 7m42s). So no change to the eslint step's wall-clock is visible
end to end.

Inside the `lint` job, the `build API docs` step (~127s) is longer than the
entire `Run yarn lint` step (whole-repo `eslint .` 103s; PR #594 serial buckets
of 10, 119s). Bucketing adds +16s to the lint step (+15%) but only +8s to the
job (+3%, 4m33s -> 4m41s).

## tsc-duplication concern, quantified (local sweep, single-thread)

Serial over all 53 packages: whole `eslint .` 66s; buckets of 18/14/10/6 =
58/60/61/67s; one-per-package (53 procs) 129s. Marginal cost per extra process
~1.2-1.4s of eslint + project-service startup. Duplication only bites at
per-package fan-out (~2x, the earlier +44% CI figure). Buckets of 6-18 are at
parity with (or below) whole-repo. PR #594 rebuilds the service ~6 times, not 53;
the design already avoids the duplication the concern is about.

## Sharding measured on CI

Standalone experiment workflow, all candidates on identical ubuntu-latest
runners in one push (run `28598791481`), eslint isolated (no prettier/sh):
whole `eslint .` 85s; serial buckets-of-10 102s (+20%); sharded K=4 slowest-shard
75s / compute 244s (+4 runner-jobs); sharded K=8 slowest-shard 63s / compute 379s
(+8 runner-jobs). A ~30s per-shard setup+build floor makes K=8 beat K=4 by only
12s of wall-clock for +55% compute (diminishing returns).

Each shard is a fresh runner paying full checkout+install+build (~30s) before
linting, and the shards run alongside the untouched macOS-test critical path.
Slowest-shard wall-clock is hidden under the ~6m30s test jobs (0 end-to-end
saving), while billed compute is multiplied by K. Sharding is a worse trade on
every axis that matters here.

## Decision

Land PR #594 as-is: serial buckets, `ESLINT_BUCKET_SIZE` default 10. It fixes
the `where`/`zip` tail-drop deterministically, costs nothing in end-to-end CI
wall-clock, and keeps the workflow a single simple job. Sharding is
over-engineering on today's evidence; revisit only if lint ever becomes the
critical path. The recommended winner equals #594's current implementation, so
no alternative implementation was staged. #594 stays DRAFT (not merged, not
un-drafted) per the directive; the merge decision is the maintainer's.

## Follow-up

The master change is ferried to upstream `endojs/endo` SEPARATELY by the boatman
under kriskowal credentials, which cannot originate from this host (endolinbot).
Ferry is NOT attempted here; it is left as an explicit follow-up for the
credentialed host.

Coverage verified identical to `eslint .`: 0 errors, 5 warnings, all 53 packages
including `where`/`zip` (local run + PR #594's own green `lint` job).
