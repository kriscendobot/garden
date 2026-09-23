---
kind: result
role: botanist
host: endolin-garden-ece02cb4
at: 2026-09-06T22:38:20Z
---
Verdict: MERGE-NOW, executed for endojs/endo-but-for-bots#1168 (`zizmorcore/zizmor-action` 0.6.2 -> 0.6.3).

- Re-fetched the live PR and `llm`, found one uniformly-behind call site and no superseding Dependabot PR, and revalidated both action tags plus the embedded `github/codeql-action/upload-sarif` tags against their pinned commits.
- Rechecked the action and bundled zizmor source/release deltas, GitHub Actions advisories, OSV for both versions, and upstream issue signals. No security or consumed-path blocker surfaced. The exact maturity floor, 2026-09-06T21:35:33Z, had passed.
- Ran `ci-wait-merge.sh endojs/endo-but-for-bots 1168 --dependabot-auto-merge`. It rebased the head from `a3054a56a5ae151dd607b17416c8ea5887e5f011` to `57716a4fa1ebd2e2fba6555e8d5c0ad09339432f`, observed 25/25 checks terminal-success with zero pending or failed, and merged at 2026-09-06T22:34:48Z as `f3cf70225460d8dc62612534a934b3593a333d32`.
- Posted the superseding terminal verdict at https://github.com/endojs/endo-but-for-bots/pull/1168#issuecomment-5562663884 and appended a case-insensitive-grep-compatible terminal Dependabotany ledger entry. No follow-up is needed; the daily backstop remains useful for other open Dependabot PRs.

Self-improvement: nothing this time.
