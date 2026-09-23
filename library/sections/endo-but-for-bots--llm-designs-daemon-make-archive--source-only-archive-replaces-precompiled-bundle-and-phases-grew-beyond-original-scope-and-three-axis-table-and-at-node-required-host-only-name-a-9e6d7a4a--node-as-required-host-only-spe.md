---
title: §`@node` as §required-host-only-special-name
source-slug: endo-but-for-bots--llm-designs-daemon-make-archive
section-id: source-only-archive-replaces-precompiled-bundle-and-phases-grew-beyond-original-scope-and-three-axis-table-and-at-node-required-host-only-name-and-composable-stageTree-plus-convenience-wrapper
url: https://github.com/endojs/endo-but-for-bots/blob/master/designs/daemon-make-archive.md
authors: [Kris Kowal (prompted)]
repo: endojs/endo-but-for-bots
path: designs/daemon-make-archive.md
total-lines: 813
status: In Progress (2026-04-23 → 2026-04-24; Phases 1-5 complete; Phases 6-7-8 added)
ingest-cycle: 236
ingest-date: 2026-06-08
lane: designs
parent: endo-but-for-bots--llm-designs-daemon-make-archive--source-only-archive-replaces-precompiled-bundle-and-phases-grew-beyond-original-scope-and-three-axis-table-and-at-node-required-host-only-name-and-composable-stageTree-plus-convenience-wrapper
---

§The-Phase-6-architectural-move:

> Guests do **not** see `@node`; it is a host-only capability.

§Three-properties of `@node`:
1. §Required-not-optional — every `HostFormula` carries a mandatory `nodeWorker` field.
2. §Host-only-not-guest-visible — guests inherit a filtered view that omits `@node`.
3. §XS-workers-explicitly-reject-makeUnconfined — directing callers to `@node`.

§Borrowable-pattern: §when-a-capability-is-only-meaningful-on-one-substrate, §expose-it-as-a-required-special-name-on-the-host + §filter-it-out-of-guest-views + §make-the-rejecting-substrate-name-the-redirect-target-in-its-error-message. §Three-layer-discipline:
- §Architecture: required-on-host.
- §Visibility: hidden-from-guests.
- §Error-message: names-the-redirect-target.

§The-redirect-is-always-available — §it-is-not-a-best-effort-lookup. §Borrowable-pattern: §when-an-error-points-at-an-alternative, §the-alternative-must-be-guaranteed-to-exist.

§Sibling to cycle 234 endoclaw-oauth's §the-agent-never-sees-the-token — both designs §filter-the-capability-out-of-the-guest's-view. §Cycle-234-hides-the-credential-from-the-agent-using-the-capability; §cycle-236-hides-the-capability-from-the-guest-not-allowed-to-use-it.

§All-users-purge-state-for-this-change + §no-migration-path. §Borrowable-pattern: §when-the-cleaner-design-requires-state-purge, §accept-the-one-time-cost + §don't-build-an-optional-field-crutch. §Sibling to cycle 234's §when-removing-legacy-is-cleaner-than-maintaining-shim. §The-pattern: §state-purge-as-acceptable-design-cost.
