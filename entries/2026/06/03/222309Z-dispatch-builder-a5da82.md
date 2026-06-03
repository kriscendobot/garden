---
ts: 2026-06-03T22:23:09Z
kind: dispatch
role: builder
host: endolinbot
repo: endojs/endo-but-for-bots
project: endo-but-for-bots
to: "*"
dispatch_root: /home/kris/dispatches/builder--a5da82
short_id: a5da82
prs:
  - { repo: endojs/endo-but-for-bots, pr: 413, role: stack-base }
refs:
  - entries/2026/06/03/221546Z-dispatch-researcher-895d06.md
  - entries/2026/06/03/222030Z-result-researcher-895d06.md
  - https://github.com/endojs/endo-but-for-bots/pull/413
---

# dispatch: builder — gateway phase 11b CAS-fetch for Host-header weblets (researcher-refined)

Preceded by researcher dispatch `895d06` per liaison role's
researcher-precedence norm. The researcher's
`## Library and project references` section is inlined into the
builder prompt below.

Phase 11b: replace PR #413's 501 placeholder with the real CAS-
fetch path for Host-header weblets. Gateway-side `serveWeblet`
shape only; daemon-side `UserDaemon.fetchContentTree` exo
assumed to exist or stubbed (one of the researcher's open
questions; resolution left to the dispatched builder).

Base `design/gateway-package-phase-11` (PR #413 head 88a627ad9).
Head `design/gateway-package-phase-12`. DRAFT.
