---
title: "garden/designs/driver.md — the garden's own script-orchestrated PR-creation flow design"
source-slug: garden--designs-driver-md
url: https://github.com/kriskowal/garden/blob/main/designs/driver.md
authors: [gardener, fixer, designer]
repo: kriskowal/garden
path: designs/driver.md
total-lines: 691
ingest-cycle: 281
ingest-date: 2026-06-10
lane: designs
scope: structural-pattern-observations
---

# `garden/designs/driver.md`

A 691-line **garden-internal design** for the script-orchestrated PR-creation flow. **The first design from the garden's own repository ingested.** Status: Proposed (second Proposed instance observed); Created 2026-05-29; Updated 2026-06-04; Authors: gardener + fixer + designer.

## Key moves

- **§The first design from the garden's own repository ingested** — the library now includes a design from the host meta-repository; §two-cycles-with-meta-design-ingest (265 + 281).
- **§The garden's design-doc format IS distinct from the endo-but-for-bots format** — field-names NOT bold + no `(prompted)` suffix + multi-author comma-separated.
- **§Multi-author attribution by role name** — gardener + fixer + designer as collective authors.
- **§The `## Update — YYYY-MM-DD <topic>` section at top** — named time-stamped amendment before the canonical sections.
- **§Maintainer directive cited verbatim** as named evidence of change.
- **§Three cycles with design acknowledging its own evolution within the document** (269 + 279 + 281).
- **§The claude-on-top vs claude-under-script** as named orchestration shape distinction.
- **§Three named observable costs from a single day** as empirical motivation (28-min gap PR #376 + 50-min weaver hand-off PR #357 + 5 consecutive quiet cycles).
- **§The driver IS a script, not a role** as named categorical distinction.
- **§The scripts/ top-level directory with named convention** — three named top-level directories with named audiences (scripts + roles + skills).
- **§Two named daemon shapes with distinct cardinality** — persistent driver pool (N) + one watcher per upstream feed.
- **§The driver's outer loop IS six numbered steps** with deterministic default and LLM fallback.
- **§Seven named job kinds in a generic job inbox** — pr-creation + observed-error + issue-response + build-request + design-request + retcon-rebase + ci-recovery.
- **§Lane-numbered systemd template** with `@<N>.service` syntax.
- **§Role-prefixed lanes** — extends generic lanes for non-PR roles (gardener-1 + librarian-1 + ...).
- **§The prompt-on-failure capture pattern** — `git hash-object -w --stdin` for the log; SHA passed to prompt; LLM reads on demand via `git cat-file blob`.
- **§Three cycles with content-addressed storage disciplines** (275 SHA-256 blob-storage + 276 SHA-512 source-map-cache + 281 git-object-store-for-failure-logs).
- **§Two named shapes for naming implementation blast radius** — Affected-packages-list (cycle 275) + What-changes-in-the-existing-library with New-artifacts and Modified-artifacts (cycle 281).

## Section files

- [§The garden's own script-orchestrated PR-creation flow design + claude-on-top vs claude-under-script as named orchestration shape + multi-author attribution + Update section at top](../sections/garden--designs-driver-md--the-garden's-own-script-orchestrated-PR-creation-flow-design-and-claude-on-top-vs-claude-under-script-as-named-orchestration-shape-and-multi-author-attribution-and-Update-section-at-top.md) — structural pattern observations (691-line file ingested in pattern-scope).

## Ingest scope

Cycle 281 (designs-lane after cycle 280's chat-lane zip-writer). 691-line file ingested in pattern-scope. **First-explicit-observations (twelve plus secondary)**: the-first-design-from-the-garden's-own-repository-ingested + the-garden's-design-doc-format-IS-distinct-from-the-endo-but-for-bots-design-doc-format + multi-author-attribution-by-role-name-as-named-discipline + the-`## Update — YYYY-MM-DD <topic>`-section-at-top-as-named-time-stamped-amendment + maintainer-directive-cited-verbatim-as-named-evidence-of-change + three-cycles-with-design-acknowledging-its-own-evolution-within-the-document + the-claude-on-top-vs-claude-under-script-as-named-orchestration-shape-distinction + three-named-observable-costs-from-a-single-day-as-empirical-motivation + the-driver-IS-a-script-not-a-role-as-named-categorical-distinction + the-scripts-top-level-directory-with-named-convention + two-named-daemon-shapes-with-distinct-cardinality + the-driver's-outer-loop-IS-six-numbered-steps-with-deterministic-default-and-LLM-fallback. Plus: seven-named-job-kinds + lane-numbered-systemd-template + role-prefixed-lanes + the-prompt-on-failure-capture-pattern + three-cycles-with-content-addressed-storage-disciplines + two-named-shapes-for-naming-implementation-blast-radius.
