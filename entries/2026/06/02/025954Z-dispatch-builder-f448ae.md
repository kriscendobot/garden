---
ts: 2026-06-02T02:59:54Z
kind: dispatch
role: builder
host: endolinbot
repo: endojs/endo-but-for-bots
project: endo-but-for-bots
to: "*"
dispatch_root: /home/kris/dispatches/builder--f448ae
short_id: f448ae
prs:
  - repo: endojs/endo-but-for-bots
    pr: 343
    role: stack-base
refs:
  - https://github.com/endojs/endo-but-for-bots/pull/343
  - designs/gateway-package.md
---

# dispatch: builder — endo gateway phase 2 (stacked PR on #343)

Stacked-PR shape (per maintainer direction): each phase PR's
**base is the previous PR's head branch**, not `master`. Phase 1
landed on PR #343 (head `design/gateway-package`); Phase 2's
PR base is `design/gateway-package`.

Builder picks the next coherent feature from the design's
remaining nine. Default ordering (foundational first):

  Phase 2: Feature 4 (UDS bootstrap for CapTP relay
           registration + proof-of-possession).
  Phase 3: Feature 7 (admin daemon — extends UDS bootstrap).
  Phase 4: Feature 8 (`/ocapn-cbor-np` WebSocket; gated on
           `@endo/ocapn-noise` pin).
  Phase 5: Feature 6 (public CapTP relay).
  Phase 6: Feature 3 (Git over HTTP).
  Phase 7: Feature 2 (formula-backed AppsNameHub promotion).
  Phase 8: Feature 1 (chat hosting + payment tokens).
  Phase 9: Feature 5 (Familiar-bundled fallback config).
  Phase 10: Feature 9 (HTTPS proxy compat).
  Phase 11: Feature 10 (OS packaging).

Builder may reorder within reasonable dependency constraints;
record the ordering choice in the PR body for the liaison's
chain visibility.

Restacking discipline (recorded here for the whole stack):
when a lower PR (closer to master) changes, every PR above it
in the stack rebases onto the new base. The liaison or a
weaver dispatches the rebase chain.

Full brief in the prompt.
