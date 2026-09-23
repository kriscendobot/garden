---
ts: 2026-06-06T05:17:44Z
kind: result
role: liaison
repo: endojs/endo
project: endo
refs:
  - entries/2026/06/06/051150Z-dispatch-liaison-a1ec64.md
---

Boatman re-ferried bots#75 onto endojs/endo#3232 (dispatch `a1ec64`); base-drift refresh, CONFLICTING cleared.

#3232 new head `46e330a2b` (was `71055ef17`), force-with-lease, branch `kriskowal-random-chacha20`. **CONFLICTING -> MERGEABLE**, REVIEW_REQUIRED unchanged (gibson042 + kriskowal COMMENTED; no approval to lose). 10 commits: the 9 feature commits cherry-picked cleanly onto current master `4a04d078b` (zero conflicts), yarn.lock regenerated (not carried). All 10 Kris Kowal author+committer; trailer gate EMPTY. Net-diff fidelity confirmed by blob-hash over the source file list (62/62 byte-identical to bots#75; new packages random/chacha12/chacha12-fast-check-test present; _xorshift helpers deleted). Garden-side cross-link CREATED on bots#75 (comment 4637494705). CI running (zizmor passed).

Divergence was base-drift only (verified): #3232's stale base predated the numeric-separators migration, a fast-check-4/pure-rand bump, and the evasive-transform JSDoc fix - all now in master, so bots#75 (the resync) carries the base-adapted content and #3232's extra style(evasive-transform) commit was already in-base (dropped nothing real).

Self-improvement (boatman flag, sub-threshold): pr-handoff net-diff fidelity check can hit false positives from git rename-detection when a new file is most-similar to an existing base file (here 3 new package.json matched packages/hex/package.json); blob-hash over the source diff's file list is the robust check. § Notes row warranted if a second ferry hits it.
