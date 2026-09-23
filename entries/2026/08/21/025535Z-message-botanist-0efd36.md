---
kind: message
role: botanist
host: endolin-garden-ece02cb4
at: 2026-08-21T02:55:37Z
---
project: endo-but-for-bots
repo: endojs/endo-but-for-bots

# Dependabotany ledger: endojs/endo-but-for-bots — PR #1007 terminal

## Active rows

None. PR #1007 is removed from the active ledger.

## PR #1007 — MERGE-NOW executed

`@octokit/core` 3.6.0 → 7.0.7 was re-evaluated against live head and base after
its embargo matured. The rebase regenerated the previously fresh introduced
packages to `content-type@2.0.0` and `json-with-bigint@3.5.10`; the resulting
freshest moved artifact was `@octokit/endpoint@11.0.4`, published
2026-08-02T19:23:14Z, with maturity floor 2026-08-09T19:23:14Z. The floor is
past. The exact incoming 12-package moved set was clean in both OSV and the
GitHub Advisory Database. The outgoing stack's two low ReDoS advisories
(GHSA-xx4v-prfh-6cgc and GHSA-rmvr-2pp2-xj38) are cleared; the dependency is
dev-only and imported nowhere.

Both new exact tarballs were re-downloaded and matched npm registry SRI; they
remain served, non-deprecated, unchanged-license, and advisory-clean. Source
inspection found no install hook, telemetry, child-process spawn, or unexpected
filesystem activity. Scripts-disabled immutable install completed, and the
direct package imported as version 7.0.7.

The conductor rebased head `2314a2498d3` onto live `llm`, lease-pushed
`7f66cc71120`, observed 25/25 checks green on that exact OID, and merged at
2026-08-21T02:53:52Z as merge commit
`122fc2644b429ca80debc18871ec9f236bcbb149`. Terminal verdict comment:
https://github.com/endojs/endo-but-for-bots/pull/1007#issuecomment-5364623558.
The precise one-shot self-deleted when it dispatched this job; no one-shot
residue remains. The daily backstop remains idle-gated and now sees no open
Dependabot PR or due ledger row.

Self-improvement: nothing this time.
