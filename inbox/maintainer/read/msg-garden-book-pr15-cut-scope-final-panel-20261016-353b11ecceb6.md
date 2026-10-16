from_host: oros-studio-garden-ce242c49
from: gardener:garden-book-pr15-cut-scope-final-panel-20261016
reply_to: garden-book-pr15-cut-scope-final-panel-20261016
msg_key: msg-garden-book-pr15-cut-scope-final-panel-20261016-353b11ecceb6
notice_count: 1
first_seen: 2026-10-16T15:26:50Z
last_seen: 2026-10-16T15:27:07Z
sent_at: 2026-10-16T15:27:07Z
---
kriscendobot/garden-book#15 (https://github.com/kriscendobot/garden-book/pull/15): I cut the scope and the one extra panel round ran. It came back must-fix again, with real defects, so I stopped as you asked. I did not fix anything after the panel, I did not grant more rounds, and the PR is still a draft. The gauntlet ends at review-budget-reached (iteration 13/13).

What I pushed (head c24d8c9):
- 5bccb75 refactor(browser-check): only the Linux Playwright cache is searched now. I removed the macOS/Windows branches and the platform parameter. Linux ARM64 is still searched, because this validation host (oros) only has chrome-headless-shell-linux-arm64.
- c24d8c9 test: dropped fast-check and its lockfile entries, and replaced the property tests with fixed examples.
- The earlier fix round 12 (commit 36c7c8a) had already removed the partial WebP parser and the caller-controlled `garden-book-` prefix. The powers name is now fixed as POWERS_NAME="garden-book-inert".
- Local checks: npm ci passed; npm test 80/80; npm run test:browser passed with real Chromium; the build wrote 27 files; tools/browser-check.mjs passed in all 4 configs.

Panel round 13 (review on kriscendobot/garden-book#15, 2026-10-16T15:24Z; run 767add412a1b). Real defects I checked myself:
1. SECURITY (breaker): publishBook doesn't check MCP `result.isError`. build/node-json-rpc.mjs rejects only on a JSON-RPC `error`, and nothing in build/, tools/ or test/ checks isError. So if the `writeText` that blanks "garden-book-inert" fails, the publish still goes ahead with `powers` bound to whatever that name already held, and that value becomes every visitor's bootstrap. A failed `publish` also exits 0. Fix: throw when result.isError on both calls.
2. art/MANIFEST.md:49-50: the E1-E9 chart table has a 5-column header but a 4-column separator, so it renders as raw pipes. Fix: add one `--- |`.
3. art/chapter-illustrations-brief.md:145 still says the ch3 opener is "portrait-leaning 4:3". It is now 3:4, which is the layout change the PR body asks reviewers to look at.
Nits / not defects: decomplector says to replace the pythonJson size mirror with JSON.stringify plus a margin (simplification). coverage-auditor wants tests for the screenshot branch and for "image did not load". saboteur says a zero-figure edition passes the CLI check (the Chromium test does pin 25 figures). The rest is pruner prose cuts and integrator commit grouping.

Suggested next step: one small fixer job for items 1-3 only, then either a merge decision without another panel or a last panel round. Your call.
