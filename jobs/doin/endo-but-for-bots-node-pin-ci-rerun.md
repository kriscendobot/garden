---
tier: mentor
---
<!-- garden-promoted-from-plan: gate=blocked priority=normal at=2026-08-17T05:46:04Z cleared=none -->

---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
Repo: endojs/endo-but-for-bots

Blocked on https://github.com/endojs/endo-but-for-bots/pull/1000 (pins the four
Node 24.x matrix entries in .github/workflows/ci.yml to 24.18.0). Once that
merges to `llm`, rebase and re-run CI on the PRs the 24.x gate was blocking, and
report which actually clear.

Targets, with what is known about each:
- https://github.com/endojs/endo-but-for-bots/pull/340 (base `llm`, OPEN,
  MERGEABLE, maintainer approval already on its current head f081208e1). CI is
  its only remaining gate, so this one should go green and become mergeable.
- https://github.com/endojs/endo-but-for-bots/pull/877 (base `llm`). NOTE: its
  head moved to 43abed75a and GitHub now reports it CONFLICTING, so it needs a
  weave before a re-run is meaningful. Report the conflict rather than forcing it.
- https://github.com/endojs/endo-but-for-bots/pull/475 targets the frozen base
  `llm-a54c3ad`, NOT `llm`, so an llm-only merge does NOT reach it. Do not
  assume the pin applies. Either report that `llm-a54c3ad` needs advancing or
  that #475 needs retargeting; do not retarget it yourself, since a frozen base
  is deliberate (skills/frozen-base-branch).

IMPORTANT, do not over-attribute failures to the pin. Two DISTINCT Node 24.x
failure modes have been observed and only the first is what #1000 fixes:
1. better-sqlite3 11.10.0 AVA workers aborting in RemoveEnvironmentCleanupHook
   ("Assertion failed: (env) != nullptr") under Node 24.19.0. Upstream
   https://github.com/nodejs/node/issues/65195. This is what the pin removes.
2. The Actions runner losing its OWN bundled node
   (".../actions-runner/2.336.0/externals/node24/bin/node: No such file or
   directory", SIGINT-killing in-flight tests). Observed on
   https://github.com/endojs/endo-but-for-bots/pull/1009 and
   https://github.com/endojs/endo-but-for-bots/pull/1007. This is runner
   infrastructure, NOT the matrix version, so pinning `node-version` most likely
   does NOT fix it: `setup-node` installing 24.18.0 does not change which node
   the runner uses to execute actions themselves.

So: for each target, classify the post-pin result as cleared, still-mode-1, or
mode-2, with the log evidence. If mode 2 persists, say so plainly and report it
as a separate open problem rather than re-pinning.

<!-- garden-reaped: 1 -->

---
claim:
  host: endolin-garden2-5bcdff64
  gardener: 2
  worker_kind: gardener
  tier: 
  provider: anthropic
  model: 
  claimed_at: 2026-08-17T06:03:35Z
