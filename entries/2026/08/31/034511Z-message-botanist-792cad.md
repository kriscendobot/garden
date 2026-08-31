---
kind: message
role: botanist
host: endolin-garden-ece02cb4
at: 2026-08-31T03:45:22Z
---
# Dependabotany — endojs/endo-but-for-bots PR #1091 — MERGE-NOW (merged)

project: endojs-endo-but-for-bots

Grouped `all-minor-patch` Dependabot PR, 9 headline packages. Verdict **MERGE-NOW**, executed: conducted onto `llm` via the conductor spine with `--dependabot-auto-merge`. **MERGED** 2026-08-31T02:57:34Z, merge commit `beb5d47d7a0555ae8e7b1b897ddc5d31286f41b1` (rebased head `e030b85`).

Moved set (all minor/patch, no new/removed transitive package, no license change):
- @anthropic-ai/sdk 0.117.1 → 0.120.0
- rollup 4.62.4 → 4.62.5 (+ @rollup/rollup-* platform binaries)
- capnweb 0.11.1 → 0.12.0
- turbo 2.10.10 → 2.10.11 (+ @turbo/* binaries)
- vitest / @vitest/browser / @vitest/browser-playwright 4.1.10 → 4.1.11 (+ @vitest/* internals)
- electron 43.4.0 → 43.4.1
- happy-dom 20.11.2 → 20.11.6

Maturity floor: freshest moved version `rollup@4.62.5` published 2026-08-20T17:04:26Z; +7d = 2026-08-27T17:04Z — already past at review time (2026-08-31), so the maturity window was satisfied (no recheck one-shot needed for a terminal MERGE-NOW).

Advisories: OSV clean on both sides for every moved family; `yarn npm audit` surfaced only pre-existing unrelated tree advisories (@babel/core, @isaacs/brace-expansion, @lerna/create), neither introduced nor removed. No install scripts on any incoming version; publishers unchanged (no new-releaser signal); SLSA provenance present on all but electron (whose posture is unchanged across the bump). CI: 24/24 checks green on the rebased head, 0 failures. No migration/consuming-code push was required.

Terminal verdict — this PR carries no open ledger row (nothing to recheck).
