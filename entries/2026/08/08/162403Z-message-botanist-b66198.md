---
kind: message
role: botanist
host: endolin-garden2-5bcdff64
at: 2026-08-08T16:24:04Z
---
project: endo-but-for-bots
repo: endojs/endo-but-for-bots
prs:
  - https://github.com/endojs/endo-but-for-bots/pull/923
  - https://github.com/endojs/endo-but-for-bots/pull/867
  - https://github.com/endojs/endo-but-for-bots/pull/868
  - https://github.com/endojs/endo-but-for-bots/pull/912
  - https://github.com/endojs/endo-but-for-bots/pull/913
  - https://github.com/endojs/endo-but-for-bots/pull/914
  - https://github.com/endojs/endo-but-for-bots/pull/915
  - https://github.com/endojs/endo-but-for-bots/pull/916

# Dependabotany ledger: endojs/endo-but-for-bots — 2026-08-08 daily backstop sweep

Daily backstop job `dependabotany-recheck-endo-but-for-bots-20260808-162001`.
Recovered the cumulative ledger with the case-insensitive heading match and
reconciled every open row against live GitHub state at 2026-08-08T16:23Z.
The open Dependabot set remains exactly the eight ledgered rows below. No row
is due for a new terminal verdict today, so no PR was merged, closed, rebased,
or re-commented.

## Open embargo row: PR #923 holds

- Verdict remains **EMBARGO-2026-08-10**. The head is unchanged at
  `d2635dcead1f15a4e3909a0559c0b01f9bc04b76`, so the reviewed 36-update moved
  set and its source/advisory assessment remain the applicable evidence; no
  regenerated lockfile reset the floor.
- Maturity floor remains **2026-08-10T20:37:45.880Z**, derived from the freshest
  moved version, `ws@8.21.2` published 2026-08-03T20:37:45.880Z, plus seven
  days. At this sweep the floor is about 52 hours away; the terminal recheck is
  not yet due.
- PR remains OPEN on `llm`, with no sibling Dependabot PR superseding the npm
  group. It remains `mergeable=false` / `mergeable_state=dirty`; Dependabot has
  not rebased the conflicting head. The due recheck must re-fetch and
  re-enumerate after any future rebase rather than reuse this floor blindly.
- Existing CI on this unchanged head remains 24/24 completed successfully.
- Recheck wiring is present and active: the precise one-shot fires
  **2026-08-10T21:15:00Z**, and the daily backstop remains scheduled.

## Seven terminal MERGE-NOW rows remain approval-held

Re-ran `scripts/jobs/handlers/pr-maintainer-approval-gh.sh` for PRs #867, #868,
#912, #913, #914, #915, and #916. Every invocation failed closed with `no
current APPROVED review on head`; consequently the conductor spine had no
authorized merge to execute. All seven heads are unchanged from the 2026-08-07
sweep. Live merge posture is also unchanged: #868 remains conflicting/dirty;
#867 is clean; #912–#915 are mergeable/blocked; #916 is clean. They remain open
pending a current maintainer approval (and #868 additionally needs a weave once
approved).

## Terminal closed rows

Previously rejected PRs #918 and #919 remain closed and require no action.

Self-improvement: nothing this time.
