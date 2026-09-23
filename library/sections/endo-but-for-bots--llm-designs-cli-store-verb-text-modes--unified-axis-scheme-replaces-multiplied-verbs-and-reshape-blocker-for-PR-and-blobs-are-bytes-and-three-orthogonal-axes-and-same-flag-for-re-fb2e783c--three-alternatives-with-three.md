---
title: §Three-alternatives-with-three-fates (all rejected)
source-slug: endo-but-for-bots--llm-designs-cli-store-verb-text-modes
source-url: https://github.com/endojs/endo-but-for-bots/blob/master/designs/cli-store-verb-text-modes.md
authors: [Kris Kowal (prompted)]
repo: endojs/endo-but-for-bots
path: designs/cli-store-verb-text-modes.md
total-lines: 446
ingest-cycle: 240
ingest-date: 2026-06-08
lane: designs
parent: endo-but-for-bots--llm-designs-cli-store-verb-text-modes--unified-axis-scheme-replaces-multiplied-verbs-and-reshape-blocker-for-PR-and-blobs-are-bytes-and-three-orthogonal-axes-and-same-flag-for-read-and-write
---

§Alternatives-considered enumerates three alternatives:

- **Alt 1: keep `write-text` / `read-text` as-is** — §rejected (inflates verb count and entrenches the conflation).
- **Alt 2: only add `--text` to `endo store`; defer mount-path writes** — §rejected as partial-fix (PR #128 needs an answer; deferring leaves the new top-level verbs in place).
- **Alt 3: single `endo write` verb subsumes both formula and mount cases** — §rejected because §the-operation's-effect-depends-on-the-state-of-the-daemon-rather-than-on-the-verb-the-user-typed + §surprising-and-hard-to-script-defensively.

§Alt-3-as-state-dependent-dispatch-anti-pattern: §when-a-verb's-effect-depends-on-implicit-state, §the-script-cannot-defend-against-the-state-changing + §the-verb-becomes-context-dependent. §This-IS-the-shape-of-state-dependent-dispatch-rejected-as-CLI-design-anti-pattern. §Sibling-to-cycle-238's §Alt-A-rejected (mutate-by-recreate would invalidate guest references): both rejections name §the-operation's-effect-depends-on-implicit-state-IS-the-failure-mode.

§Two-cycles-with-Alternatives-Considered-section-with-named-fates (cycles 238 + 240). §Cycle-238 had (rejected + rejected + deferred); §cycle-240 has (rejected + rejected + rejected). §Three-fates-discipline now varies: §two-different-fate-distributions in the same family.
