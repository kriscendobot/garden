---
title: "kriskowal/garden/scripts/watcher/endo-but-for-bots/watcher.sh — the per-feed watcher daemon for endojs/endo-but-for-bots (Phase 1 stub)"
source-slug: garden--scripts-watcher-endo-but-for-bots-watcher-sh
url: https://github.com/kriskowal/garden/blob/main/scripts/watcher/endo-but-for-bots/watcher.sh
authors: [Endo project (collective; role-as-author convention)]
repo: kriskowal/garden
path: scripts/watcher/endo-but-for-bots/watcher.sh
total-lines: 60
ingest-cycle: 304
ingest-date: 2026-06-11
lane: chat
---

# `kriskowal/garden/scripts/watcher/endo-but-for-bots/watcher.sh`

A 60-line bash script — the per-feed watcher daemon for endojs/endo-but-for-bots, in Phase 1 stub form. **The ninth garden source ingested**. §nine-cycles-with-garden-repo-source-ingest (281 + 297 + 298 + 299 + 300 + 301 + 302 + 303 + 304). §nine-named-shapes-of-garden-self-documentation (proposed-design + standing-reference + implementation-source + project-instructions + operational-daemon-control + standing-subagent-instructions + skill-procedural-playbook + role-specific-orchestrator-instructions + per-feed-watcher-stub).

**§the-named-quadruple-claim-and-single-realization**: four prior cycles named the watcher concept (297 WORKTREES.md standing-monitor + 299 CLAUDE.md monitoring safety constraint + 300 daemons config `GARDEN_WATCHER_FEEDS=(endo-but-for-bots)` + 301 COMMON.md standing-monitor restated); cycle 304 IS the actual implementation stub realizing those claims.

## Key moves

- **§the-named-per-feed-watcher-stub-shape** — the ninth named shape; §the-named-stub-IS-named-deliberate-not-incomplete; §the-named-numbered-phase-discipline (Phase 1 + Phase 2-5).
- **§five-named-contract-steps** (poll + classify + route + reactji + self-heal) — §the-named-contract-IS-named-IN-the-stub; §the-named-stub-IS-named-contract-bearer; §the-named-deferred-contract-marker.
- **§six-named-event-types** (push + review submission + comment + label + assigned-issue + CI status).
- **§the-named-eyes-reactji-discipline** — deterministic + acknowledgment-before-routing; §the-named-typographic-emphasis-on-temporal-ordering ("*before*" italicized).
- **§the-named-per-host-per-lane-subscription-file** — `journal/drivers/<host>/<lane>.subscriptions`; §two-axis-subscription-file-name; §the-named-non-markdown-extension-discipline.
- **§the-named-event-log-path-shape** — `journal/events/<repo>--<pr>.log`; §two-cycles-with-named-double-dash-separator-discipline (297 + 304); §the-named-`--`-IS-the-named-garden-wide-pair-separator; §the-named-`.log`-extension-IS-named-append-only-log.
- **§the-named-fallback-to-job-board-when-no-subscriber** — §two-named-routing-targets (per-PR event log + open job board); §the-named-broadcast-via-job-board-fallback.
- **§the-named-self-heal-via-systemd-Restart-on-failure** — §the-named-systemd-policy-as-named-resilience-mechanism; §the-named-rely-on-the-runtime-for-recovery; §two-named-failure-classes (transient + persistent) with named-distinct-handling.
- **§the-named-escalation-to-gardener-inbox** — `journal/inboxes/<host>/gardener.md` per `skills/gardener-inbox-error-reporting/SKILL.md`; §the-named-escalation-via-named-skill; §the-named-implementation-points-at-named-skill.
- **§four-named-environment-overrides** (GARDEN_ROOT + GARDEN_JOURNAL + GARDEN_HOST + FEED_POLL_SECONDS=30) — §the-named-defaults-are-named-pedagogical; §the-named-honest-stub-discipline (stub honors only GARDEN_ROOT).
- **§three-cycles-with-named-script-location-discovery-shapes** — cycle 298 single-level + cycle 300 decomposed + cycle 304 three-deep (`../../..`); §the-named-depth-encodes-nesting; §two-named-script-location-variable-names (SCRIPT_DIR + SCRIPT_PATH).
- **§the-named-`${VAR:-default}`-bash-default-substitution** — §three-cycles-with-named-bash-parameter-expansion-discipline (298 suffix/prefix strip + 300 default-empty + 304 default substitution).
- **§two-cycles-with-`set -uo pipefail`-WITHOUT-`-e`** (300 + 304) — §the-named-bash-strictness-discipline-IS-context-determined-not-universal (now 2-cycle pattern); §the-named-two-named-strictness-tiers-by-script-cluster.
- **§the-named-parameterized-prefix-shape** — `watcher[$FEED_SLUG]:`; §three-named-prefix-shapes (298 no-prefix + 300 simple-prefix + 304 parameterized-prefix); §the-named-prefix-encodes-the-instance; §the-named-three-fold-instance-encoding (systemd template + bash constant + log prefix).
- **§three-named-pointer-references-in-the-docstring** — feed-inventory + feed-specifics + design-rationale; §two-cycles-with-named-design-and-implementation-cross-reference-pair (281 designs/driver.md + 304 implementation pointing back).
- **§the-named-FEED_SLUG-named-as-constant-not-derived** — §the-named-explicit-feed-identity; §the-named-feed-identity-IS-in-the-source-not-the-path; §the-named-name-appears-in-two-places-as-named-redundancy.
- **§the-named-Phase-1-stub-IS-named-end-to-end-exercise-before-implementation** — §the-named-end-to-end-exercise-before-implementation-discipline; §the-named-plumbing-first-substance-later; §the-named-vertical-slice-IS-named-validatable-before-horizontal-completion.
- **§the-named-exit-0-clean-exit** — §the-named-stub-exits-cleanly-not-with-error; §the-named-deliberate-no-op-IS-named-exit-zero; §the-named-stderr-output-and-exit-zero-pair.
- **§the-named-cycle-304-IS-the-named-ninth-garden-source-and-the-named-stub-implementation-realizing-the-named-quadruple-claim** — §the-named-multi-cycle-claim-converges-to-single-realization-cycle; §the-named-stub-IS-named-vertical-slice-realization.

## Section files

- [§nine-cycles-with-garden-repo-source-ingest + §the-named-per-feed-watcher-stub-shape + §five-named-contract-steps + §six-named-event-types + §the-named-eyes-reactji-discipline + §three-cycles-with-named-script-location-discovery-shapes + §two-cycles-with-`set -uo pipefail`-WITHOUT-`-e` + 20+ more first-explicit-observations](../sections/garden--scripts-watcher-endo-but-for-bots-watcher-sh--ninth-garden-source-and-named-phase-1-stub-shape.md) — full 60-line stub in scope.

## Ingest scope

Cycle 304 (chat-lane after cycle 303's designs-lane roles/liaison/AGENT.md). Full 60-line stub in scope. **First-explicit-observations (twenty-plus)** at full scope: §the-named-per-feed-watcher-stub-shape (the ninth named shape), §the-named-quadruple-claim-and-single-realization (four prior cycles named the watcher; cycle 304 IS the implementation stub), §five-named-contract-steps documented in the stub's docstring, §six-named-event-types, §the-named-eyes-reactji-discipline with §the-named-acknowledgment-before-routing, §the-named-fallback-to-job-board-when-no-subscriber, §the-named-self-heal-via-systemd-Restart-on-failure with §two-named-failure-classes, §the-named-escalation-to-gardener-inbox via named skill, §four-named-environment-overrides with §the-named-honest-stub-discipline, §three-cycles-with-named-script-location-discovery-shapes (298 + 300 + 304), §two-cycles-with-`set -uo pipefail`-WITHOUT-`-e` (300 + 304), §the-named-parameterized-prefix-shape (`watcher[<slug>]:`) with §three-named-prefix-shapes across the garden's bash scripts, §three-named-pointer-references-in-the-docstring closing a loop with cycle 281, and §the-named-Phase-1-stub-IS-named-end-to-end-exercise-before-implementation.
