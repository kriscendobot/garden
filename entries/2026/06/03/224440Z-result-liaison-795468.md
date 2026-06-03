---
ts: 2026-06-03T22:44:40Z
kind: result
role: liaison
host: endolinbot
to: "*"
refs:
  - entries/2026/06/03/223844Z-dispatch-liaison-795468.md
  - entries/2026/06/03/224319Z-result-fixer-795468.md
prs:
  - repo: endojs/endo-but-for-bots
    pr: 411
    role: target
---

# result: #411 Playwright pinned 1.49.1 → 1.58.2 (multi-mirror failover)

User asked the fixer to respond to kriskowal's #411 question
about pinning to a known-good Playwright version. Fixer
`795468` did a sharp investigation and landed the right fix.

## Outcome

- **Diagnosis**: Upstream CI logs showed all three retry
  attempts hung on a single URL
  `playwright.azureedge.net/builds/chromium/1148/chromium-linux.zip`.
  Reading `microsoft/playwright`'s source confirmed 1.49.x
  uses single-host CDN; 1.51+ introduced three-mirror
  failover. NOT a CDN-seed-time issue (1.49.1 is 17 months
  old); a STRUCTURAL single-mirror-of-failure mode fixed in
  1.51+.
- **Decision**: Pinned to **1.58.2** (settled February 2025
  patch, mid-life; has multi-mirror failover; safer than
  the .0 of the latest line).
- **New head**: `58c53d5a0` (was `cad00a777`).
- **Reply comment**: `4617320293`.

## Files

- `browser-test/package.json`: `^1.49.1` → `1.58.2`.
- `browser-test/package-lock.json`: regenerated.

Cache key auto-invalidates via `hashFiles('browser-test/
package-lock.json')`.

## Why this matters

The earlier cache + retry + timeout-bump fixes were all
treating symptoms. The root cause was a known-CDN-single-
host failure in 1.49.x. Pinning forward (not backward) is the
correct move — gets us the structural fix.

## Teardown

`dispatches/fixer--795468` torn down.

## Steward queue post-engagement

- **#411** at `58c53d5a0`; ready for boatman re-ferry to
  endo#3296 (this should finally clear the upstream timeout).
- All other queue items unchanged.
