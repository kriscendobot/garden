---
ts: 2026-06-02T04:36:22Z
kind: dispatch
role: builder
host: endolinbot
repo: endojs/endo-but-for-bots
project: endo-but-for-bots
to: "*"
dispatch_root: /home/kris/dispatches/builder--6e6e84
short_id: 6e6e84
prs:
  - repo: endojs/endo-but-for-bots
    pr: 393
    role: stack-base
refs:
  - https://github.com/endojs/endo-but-for-bots/pull/393
  - designs/gateway-package.md
---

# dispatch: builder — endo gateway phase 6 (Feature 3 Git over HTTP, stacked on #393)

Base design/gateway-package-phase-5 (PR #393 head). Head
design/gateway-package-phase-6. Implements Feature 3: Smart-HTTP
git under `/git/<repo-id>/...` with HTTP Basic (empty user + token)
or HTTP Bearer auth; reuses `gateway-bearer-token-auth` (token =
formula identifier).

Composes with the @endo/git rename (PR #390) — if that has
merged, use `@endo/git`; otherwise note the carry-forward.
