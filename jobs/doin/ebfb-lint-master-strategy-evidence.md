# scout/investigator: evidence-based decision on the master-side lint strategy

**Repo:** `endojs/endo-but-for-bots` (bot-pushable; bot-repo work only, **no upstream `endojs/endo` touch**). Commenting is standing-authorized for this repo.

**Base branch under decision:** `master` (kept in sync with upstream `endojs/endo`; any change here is ferried upstream — see Constraints).

## The maintainer directive (2026-07-02, via the liaison)

Do **not** just merge PR #594. Before landing anything on `master`, produce an **evidence-based decision** on the lint strategy. The concern: `tsc` duplicates a lot of work when the eslint project service is rebuilt once per package, so a serial per-package (or per-bucket) run may **regress the CI `lint` wall-clock**. The maintainer explicitly wants sharding considered: **split the lint workflow into concurrent CI jobs** so buckets of workspaces lint in parallel, instead of one serial job. Either way we need real evidence, and the resulting master change will be ferried upstream regardless.

## Context (what already exists)

- **Root cause:** a typescript-eslint **project-service scaling ceiling**. A single whole-repo `eslint .` must hold every package's TS program; past ~53 packages it tail-drops its alphabetically-last packages (`packages/zip/**`, `packages/where/**`) and emits phantom "none of those TSConfigs include this file" parsing errors, reddening CI `lint` on every large PR.
- **`llm` side — already fixed and merged:** PR #596 (`scripts/eslint-repo.sh`, bucketed per-package, bucket size 10) merged to `llm` 2026-07-02.
- **`master` side — PR #594, OPEN + DRAFT, green CI, MERGEABLE/CLEAN.** Head `3473f5df2`. It implements the **serial bucketed** approach (`scripts/eslint-repo.sh`, `ESLINT_BUCKET_SIZE` default 10). Prior measurements are conflicting and must be settled with fresh, real CI evidence:
  - A local (non-CI) measurement: whole-tree `eslint .` 65.4s; per-package (53 procs) 125.6s (~1.9x); bucket 6/10/14/18 → 66/66/62/60s (≈parity from bucket 6 up).
  - A real-CI measurement on one thread: base `master` `eslint .` **4m33s** vs one-process-per-package **6m32s (+44%)**; bucket 10 lint on #594's head measured **4m41s** (≈parity with the 4m33s baseline).
  - The two disagree on how much bucketing costs; the sharding option was never measured at all.

## Your task

Benchmark the candidate strategies with **real GitHub Actions CI wall-clock** (label any local-only number as local, per the evidence rule in `garden/roles/COMMON.md` § Reporting — never write "verified" without a cited real run). Use `garden/skills/ci-runtime-comparison/SKILL.md` and `garden/skills/benchmark-comparative-report/SKILL.md`.

Candidates:
1. **Baseline** whole-repo `eslint .` (the fast-but-broken reference; time it on a run that completes, note it drops the tail — this is the number to beat).
2. **Serial per-package** (1 process per package).
3. **Serial bucketed** at sizes ~6 / 10 / 14 / 18 (the #594 family).
4. **Sharded / concurrent CI** — a matrix of K parallel lint jobs, each linting a bucket of workspaces concurrently. Report **both** total wall-clock (the slowest shard = what the maintainer waits for) **and** total compute (sum across shards = billed minutes), and pick a K that gives good wall-clock without excessive runner fan-out.

Quantify the `tsc` project-service rebuild cost per process so the "duplicated effort" concern is answered with data, not assertion.

## Deliverables

1. **A decision comment on PR #594** (standing-authorized) with a comparison table of the candidates (real CI timings), the answer to the tsc-duplication concern, and a clear **recommendation** with its rationale.
2. **A journal `result` entry** capturing the evidence and the decision (so it survives independent of the PR thread).
3. **If the recommended winner differs from #594's current serial-bucket implementation** (most likely: sharding), stage that implementation on a **`master`-base** branch — either update #594 or open a fresh `master`-base draft PR — and leave it **DRAFT / for-review**.

## Constraints

- **Do NOT un-draft or merge #594** (or any master PR). The merge decision is the maintainer's; your job ends at the evidence-backed recommendation plus a staged (draft) implementation.
- **Bot-repo work only. No upstream `endojs/endo` interaction** (no comments, PRs, issue/PR links, merges). The `master` change is ferried to `endojs/endo` **separately**, via the boatman under kriskowal credentials, which **cannot originate from this host (endolinbot)**. Record that ferry as an explicit **follow-up** in your report; do not attempt it.
- Keep the coverage byte-identical to `eslint .` (0 errors, warnings only, including `where`/`zip`); a strategy that lints fewer files is disqualified.

## Definition of done

A decision comment is posted on #594 with a real-CI evidence table and a recommendation; a journal `result` entry records the evidence and decision; if warranted, a draft `master`-base implementation of the recommended strategy is staged; and the upstream ferry is listed as a follow-up for the credentialed host. #594 is left in its current draft state (not merged, not un-drafted).

<!-- garden-reaped: 1 -->

<!-- garden-reap-now -->
---
claim:
  host: endolinbot
  gardener: 99
  claimed_at: 2026-07-02T14:33:08Z
