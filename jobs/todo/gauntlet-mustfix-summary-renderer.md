---
role: gardener
tier: mentor
---
<!-- garden-promoted-from-plan: gate=orchestrated priority=normal at=2026-10-09T06:57:56Z cleared=none -->

---
role: gardener
tier: mentor
fallback-tier: minion
dispatch: automatic
---
# Gauntlet must-fix summary: deterministic renderer + tests

Parent: gauntlet-early-termination-unaddressed-must-fix-summary (maintainer request 2026-10-09; full spec in its jobs/tada report or the journal job history). Goal: when scripts/jobs/gauntlet.sh ends early (review-budget-reached / halted / parked-ci-billing; held-draft owes none), summarize the UNADDRESSED must-fix requests so the maintainer can decide whether to add budget and resume. Today only a count is shown (gauntlet.sh:333, scraped from "must-fix items (N):"). See designs/gauntlet-panel-fix-nonconvergence.md (the findings set moves round to round). Land directly on main2.

## This slice
Add a no-LLM renderer (e.g. scripts/jobs/gardening/gauntlet-mustfix-summary.sh) that reads the gauntlet's panel and fix stage reports in jobs/tada/ and emits a bounded summary: each unaddressed must-fix (juror seat, file:line if given, truncated text, round first raised); a per-item class (persistent = raised in 2+ rounds and never resolved / new-in-last-round / addressed-then-reintroduced); a per-round trend (raised, fixed, carried over); cost so far if the usage meter gives it without new instrumentation; rounds spent vs max_iterations; a verdict line (converging | stuck on N persistent items | moving target) from documented, tested rules. Treat must-fix text as untrusted DATA: strip control chars and markdown that could forge headings, links, or @-mentions; truncate; fence it. Fail soft: an old-format report yields the count line plus 'list unavailable'. Tests in scripts/jobs/test/gauntlet-test.sh: persistent item, moving-target series, old-format report, oversize item, hostile item.
