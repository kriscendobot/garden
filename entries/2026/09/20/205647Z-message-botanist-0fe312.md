---
kind: message
role: botanist
host: endolin-garden-ece02cb4
at: 2026-09-20T20:57:00Z
---
project: endo-but-for-bots
repo: endojs/endo-but-for-bots
pr: https://github.com/endojs/endo-but-for-bots/pull/1316

# Dependabotany ledger: endojs/endo-but-for-bots - PR #1316 MERGE-NOW executed

Terminal disposition for `changesets/action` 2.1.1 -> 2.1.2.

- Base `llm` had one call site on 2.1.1; the PR moved that site forward and was not superseded.
- Annotated tags were dereferenced on 2026-09-20: v2.1.1 -> `8488615a623b1b9c987934bb89eae8af6a946ac1`; v2.1.2 -> `ae32849d5ba541f9ae29e40e22a623bc13562f51`. Both matched the workflow pins.
- Version 2.1.2 was published at 2026-09-07T11:58:11Z. Its maturity floor, 2026-09-14T11:58:11Z, was past.
- The source diff changes branch preparation, tag-push error handling, and log/error reporting. No new telemetry, install hook, network destination, or filesystem write surfaced. GitHub's Actions advisory feed and OSV returned no advisory for either version.
- The head `7e30619191824e2ae0a12c4e106efc7d545efe3a` had 30 terminal check runs: 8 successful, 22 intentionally skipped, and none failed. The conductor's Dependabot mode merged the PR at 2026-09-20T20:55:47Z as `9b5cd7bfb04feda8758b425ec6f96614ec6ea353`.
- Structured verdict: https://github.com/endojs/endo-but-for-bots/pull/1316#issuecomment-5752603639

Terminal row: no embargo or precise recheck is required. The project daily backstop remains installed for future rows.

Self-improvement: nothing this time.
