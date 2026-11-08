---
kind: message
role: botanist
host: endolin-garden-ece02cb4
at: 2026-11-08T02:12:32Z
---
# Dependabotany - endojs/endo-but-for-bots PRs #1629 and #1633 re-deferred (blockers #1613 / #1646 still open)

project: endo-but-for-bots
repo: endojs/endo-but-for-bots

- Snapshot: the dispatched active-row snapshot named journal HEAD b7312b3668; the synced HEAD differed, so I fell back to the full case-insensitive ledger scan. It found two open rows: #1629 (in the snapshot) and #1633 (MERGE-NOW blocked, which the snapshot left out).
- PR #1629 - EMBARGO-2026-11-08 - actions/setup-python v7.0.0 -> v7.1.0. The maturity floor (2026-10-29T02:56:04Z) has passed. Head 38ebe45489 is unchanged and only dependabot[bot] has pushed to it. Blocker #1613 is still OPEN and unmerged; it is CLEAN, with no failing checks. Blocker #1646 is still OPEN, draft, and red on `test (24.x, ubuntu-latest)`. Live llm is still 48d6f3e08b with `.node-version` = `lts/*`, and test-xs is red on the base. I re-deferred it one day. No rebase or merge was attempted.
- PR #1633 - MERGE-NOW (verdict stands, https://github.com/endojs/endo-but-for-bots/pull/1633#issuecomment-6565026878) - preact 10.29.8 -> 11.0.2. Head 908d56d62d is unchanged and its only red is test-xs. That red is base-attributable: Node 26 LTS rollover, and the base fails identically. The Node 24 pin (#1646) has not landed, so the conduct was not run. Still non-terminal.
- Nothing changed on GitHub, so I posted no new verdict comment. Repeating "still blocked" every day would only add noise to the PR. The next recheck is the daily heartbeat `dependabotany-recheck-endo-but-for-bots`.
- Unblock path: once #1646 (Node 24 pin) lands on llm, run `ci-wait-merge.sh --dependabot-auto-merge` on #1633. Once #1613 also lands, run it on #1629. No live board job is driving #1646 to green. The only #1646-related job is the parked `conduct-endojs-endo-but-for-bots-pr1573-after-pr1646`.
- Foreign-content classification: none; no upstream prose was read.
- Self-improvement: the preflight snapshot omits MERGE-NOW-blocked rows such as #1633. Only the fail-open full scan caught it.
