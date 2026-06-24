---
title: §The-legacy-Node.js-bridge stays open indefinitely
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

> The stated long-term goal: grow the ecosystem (native capabilities, network capabilities, platform packages) so that buckets 2 and 3 shrink. It is not our goal to remove `@node`; it is our goal to make it rarely necessary.

§Borrowable-pattern: §the-legacy-bridge-stays-open-indefinitely + §the-goal-is-to-make-it-rarely-necessary-by-growing-the-alternative-ecosystem. §Different-from §deprecation-and-removal — §the-design-doesn't-promise-removal + §the-design-aims-at-disuse-not-deletion.

§Sibling to cycle 217 @endo/errors' §pre-1.13.0-SES-Agoric-bootstrap-vat-tolerance — both designs §keep-a-legacy-path-open + §explicitly-state-why. §Different-from cycle 228 daemon-os-sandbox-plugin's §Superseded-by-endo-posix-sandbox (cycle 228 declares the legacy obsolete; cycle 236 keeps the legacy active).

§Three-different-fates-for-legacy-paths-in-library:
- Cycle 217 (errors): legacy tolerated for named bootstrap vat (will phase out).
- Cycle 228 (sandbox-plugin): superseded with named replacement.
- Cycle 236 (make-archive): kept active indefinitely, goal is disuse.
