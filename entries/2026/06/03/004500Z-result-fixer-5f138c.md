---
ts: 2026-06-03T00:45:00Z
kind: result
role: fixer
host: endolinbot
repo: endojs/endo-but-for-bots
project: endo-but-for-bots
to: "*"
short_id: 5f138c
prs:
  - { repo: endojs/endo-but-for-bots, pr: 388, role: target }
  - { repo: endojs/endo-but-for-bots, pr: 389, role: rebased }
  - { repo: endojs/endo-but-for-bots, pr: 392, role: rebased }
  - { repo: endojs/endo-but-for-bots, pr: 393, role: rebased }
  - { repo: endojs/endo-but-for-bots, pr: 394, role: rebased }
  - { repo: endojs/endo-but-for-bots, pr: 395, role: rebased }
  - { repo: endojs/endo-but-for-bots, pr: 396, role: rebased }
  - { repo: endojs/endo-but-for-bots, pr: 397, role: rebased }
refs:
  - entries/2026/06/03/000200Z-dispatch-fixer-5f138c.md
---

# result: fixer — #388 UDS→sock rename + restack #389-#397 (8 PRs cascaded)

Layer #388 settled on kriskowal's UDS-initialism feedback.

Rename SHA on #388: `741890f1d`. Linux/Mac-only scope; 2
Windows-only tests removed; 125/125 pass after rename.

Restacked 7 PRs above #388 (force-with-lease):
- #389 phase-3 head `cdaf627568` (151 tests)
- #392 phase-4 head `d2a276a464` (169 tests)
- #393 phase-5 head `b988a2650e` (235 tests)
- #394 phase-6 head `72d425f710` (273 tests)
- #395 phase-7 head `96708da1ba` (315 tests)
- #396 phase-8 head `ac68f08116` (357 tests)
- #397 phase-9 head `3cc7e50511` (391 tests)

All rebases clean. Top-level summary on #388 at
issue-comment 4608052027.

Pre-existing CI failures unrelated to rename: netlayer-tcp-syrup
test exits 1 on every Node job; `makeClient not found` lint
error in a different package. None new.

Self-improvement: stack-wide rebases would benefit from
`git config rerere.enabled true` at start; the rename's
wording wins repeatedly. One-line config, no skill needed.

## Liaison disposition

Dispatch root torn down. Next layer: **#389 separate admin
socket + Linux/Mac scope confirmation** (the cascade from #388
is already settled; #389's substantive change is the
separate-admin-socket design).
