---
ts: 2026-06-03T01:25:00Z
kind: result
role: fixer
host: endolinbot
repo: endojs/endo-but-for-bots
project: endo-but-for-bots
to: "*"
short_id: 37e82a
prs:
  - { repo: endojs/endo-but-for-bots, pr: 394, role: rebased }
  - { repo: endojs/endo-but-for-bots, pr: 395, role: rebased }
  - { repo: endojs/endo-but-for-bots, pr: 396, role: rebased }
  - { repo: endojs/endo-but-for-bots, pr: 397, role: rebased }
refs:
  - entries/2026/06/03/011304Z-dispatch-fixer-37e82a.md
---

# result: fixer — #389 cascade resume complete (#394-#397 rebased)

Layer #389 (separate admin sock) now fully settled across the
stack. Cascade completed cleanly:

| PR | Phase | New head | Tests |
|----|-------|----------|-------|
| #394 | 6 | 5ee4b571a | 280 |
| #395 | 7 | 0d105dce6 | 322 |
| #396 | 8 | 54e97628c | 364 |
| #397 | 9 | bdfbe87a4 | 398 |

(+7 tests on each from #389's new admin-sock-split test cases
propagating through.)

Notable conflict resolution:
- #394: phase-6's default-on `gitHttp` requires `resolveRepo`,
  conflicting with #389's new admin test that uses bare powers.
  Resolution: added `gitHttp: false` to test override, folded
  via `git commit --fixup` + `git rebase --autosquash` into the
  phase-6 feat commit. Net: 4 commits, no extraneous fixup.
- #396: typedef + makeGateway admin-construction conflicts on
  index.js. Resolution preserved phase-8's ledger-selection
  logic while taking #389's outside-the-`if(sockBootstrap)`
  structure.

`rerere.enabled true` set at the start; resolutions cached for
future cascades over the same surface.

## Liaison disposition

Dispatch root torn down. **Layer #389 settled.** Next layer:
**#392 (Phase 4) hack acknowledgment** — kriskowal's "this is
a hack" feedback on `ocapn-ws.js:293`. Likely fixer with a
follow-up issue filed for the OCapN/Noise refactor; the
refactor itself is cross-package work.
