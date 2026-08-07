---
child-pr910-mustfix-round2-06-repanel-host: endolin-garden2-5bcdff64
child-pr910-mustfix-round2-06-repanel-reap-count: 0
child-pr910-mustfix-round2-05-hygiene-host: endolin-garden2-5bcdff64
child-pr910-mustfix-round2-05-hygiene-reap-count: 0
child-pr910-mustfix-round2-04-types-help-host: endolin-garden2-5bcdff64
child-pr910-mustfix-round2-04-types-help-reap-count: 0
child-pr910-mustfix-round2-03-producer-copy-host: endolin-garden-ece02cb4
child-pr910-mustfix-round2-03-producer-copy-reap-count: 0
child-pr910-mustfix-round2-02-daemon-cas-host: endolin-garden2-5bcdff64
child-pr910-mustfix-round2-02-daemon-cas-reap-count: 0
child-pr910-mustfix-round2-01-platform-range-host: endolin-garden-ece02cb4
child-pr910-mustfix-round2-01-platform-range-reap-count: 0
order: serial
children: pr910-mustfix-round2-01-platform-range pr910-mustfix-round2-02-daemon-cas pr910-mustfix-round2-03-producer-copy pr910-mustfix-round2-04-types-help pr910-mustfix-round2-05-hygiene pr910-mustfix-round2-06-repanel
on-child-failure: halt
state: running
created_by: planner
created_at: 2026-08-07T03:10:58Z
---

# Orchestration: PR #910 fix round 2 (fresh-panel must-fix blockers)

Drives the fix loop for the FRESH 28-seat panel's must-fix verdict on
https://github.com/endojs/endo-but-for-bots/pull/910 (head `955f53be`, base frozen
`llm-a3064e1`, durable panel record `14604383ce1d`, deduplicated blocker list in
completion-summary comment 5210132433). Planned per kriskowal review 4879564977
by job `endojs-endo-but-for-bots-pr910-fixer-orchestration-plan`.

Serial, halt on child failure, six children in dependency order:

1. `pr910-mustfix-round2-01-platform-range` — platform blob-range invariants: interval-composition `newLo` overflow clamp (blocker 7), BOM/U+FEFF reconciliation incl. interior-BOM selection start (blocker 2), multi-chunk LocalBlob regression test (test half of blocker 10).
2. `pr910-mustfix-round2-02-daemon-cas` — daemon mount/CAS hardening: EOF-loop window reads (blocker 1), fixed frame bound + size/digest-verified CAS insert (blocker 3), parent-SHA exo-tag leak (tag half of blocker 8).
3. `pr910-mustfix-round2-03-producer-copy` — Git/XS producers: whole-object read amplification (blocker 6), copied window bytes vs retained `subarray` backing buffer (copy half of blocker 8).
4. `pr910-mustfix-round2-04-types-help` — optional-`end` contract / `RichReadableBlob` daemon range typing (blocker 4), workspace-generated `BlobRef.range`/`textRange` `Promise<unknown>` (blocker 5), glob/grep/glorp help + stale prose restoration (blocker 9).
5. `pr910-mustfix-round2-05-hygiene` — changeset bump levels, unsquashed `fixup!` commits, empty CI-trigger commits (hygiene half of blocker 10), respecting the no-force-push constraint (GD-07).
6. `pr910-mustfix-round2-06-repanel` — CI green, full 28-seat panel re-run; clean verdict → un-draft; must-fix → report `orchestration-failed: true` and stop (no auto loop).

Reasoned declines PLAT-05/25/19/33, GD-07/08/11 stand; children must not silently reopen them.
