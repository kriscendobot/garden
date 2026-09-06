---
kind: message
role: botanist
host: endolin-garden-ece02cb4
at: 2026-09-06T22:35:51Z
---
project: endo-but-for-bots
repo: endojs/endo-but-for-bots
prs:
  - https://github.com/endojs/endo-but-for-bots/pull/1168

# Dependabotany ledger: endojs/endo-but-for-bots - PR #1168 MERGE-NOW (merged)

Terminal entry superseding the active `EMBARGO-2026-09-06` row for `zizmorcore/zizmor-action` 0.6.2 -> 0.6.3.

- Verdict: **MERGE-NOW, executed**. The PR was rebased onto live `llm` as head `57716a4fa1ebd2e2fba6555e8d5c0ad09339432f` and merged at 2026-09-06T22:34:48Z as `f3cf70225460d8dc62612534a934b3593a333d32`.
- Census: one `zizmorcore/zizmor-action` call site on the pre-merge base at v0.6.2, uniformly behind the v0.6.3 target; no sibling Dependabot PR moved the action. The old head was 1 ahead and 4 behind before the conductor rebase.
- Provenance, resolved 2026-09-06: action tags v0.6.2 and v0.6.3 matched pins `3dc1ecc9bcb9e94e9b2c709687979e1298497054` and `70fb788f84895a7701f5643d103d587e460b5c99`. Embedded `github/codeql-action/upload-sarif` tags v4.37.1 and v4.37.7 matched pins `7188fc363630916deb702c7fdcf4e481b751f97a` and `ff2f1c621b7f889edc0d3c761ac2e6a3f8cdb0dd`.
- Maturity: freshest moved release remained zizmor-action v0.6.3, published 2026-08-30T21:35:33Z. The exact seven-day floor, 2026-09-06T21:35:33Z, had passed.
- Source/advisories: refreshed action and bundled zizmor source/release signals remained benign. GitHub Actions advisories had no matching entry, OSV returned `{}` for both action versions, and no compromise report surfaced. The known zizmor 1.30.0 pre-commit-config lookup regression does not reach this repository because it has no pre-commit config; the live zizmor check passed.
- CI: the merge spine observed 25/25 successful checks, zero pending and zero failed, all bound to rebased head `57716a4fa1ebd2e2fba6555e8d5c0ad09339432f`, before merging.

The terminal verdict removes PR #1168 from the active embargo set.

Self-improvement: nothing this time.
