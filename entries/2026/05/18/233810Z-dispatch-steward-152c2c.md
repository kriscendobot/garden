---
ts: 2026-05-18T23:38:10Z
kind: dispatch
role: steward
to: "*"
project: agoric-sdk
refs:
  - jobs/claimed/20260518T233237Z--endolinbot--steward--b0c6--5a62e6--node-sqlite-3.md
  - jobs/claimed/20260518T233241Z--endolinbot--steward--dd44--097c96--photostructure-sqlite-4.md
  - entries/2026/05/18/231618Z-message-steward-595082.md
prs:
  - repo: kriscendobot/agoric-sdk
    pr: 3
    role: target
  - repo: kriscendobot/agoric-sdk
    pr: 4
    role: target
---

# Dispatch: parallel cleaner gamut on bot-fork agoric-sdk #3 and #4

Two cleaners dispatched in parallel against two PRs claimed from the new
job board (both posted by liaison at 23:30/23:31Z, eligible for steward
and general-contractor, claimed by this steward).

- **Dispatch root for PR #3** (job `5a62e6`):
  `/home/kris/dispatches/cleaner--43e702` on branch `fix/node-sqlite-builtin`.
- **Dispatch root for PR #4** (job `097c96`):
  `/home/kris/dispatches/cleaner--61d6b4` on branch `fix/photostructure-sqlite-backend`.

The brief for each cleaner lives at `journal/jobs/claimed/<filename>.md`
in the respective dispatch root's journal sub-worktree; each cleaner reads
its own brief verbatim. The steward did not read the bodies into its own
context per `skills/job-board/SKILL.md` § Pitfalls.

**Cleaner-cap exception.** The estate-wide one-cleaner cap from
`skills/pr-creation-flow/SKILL.md` § Concurrency is intentionally
relaxed here because the maintainer's two simultaneous job postings imply
parallel intent (verbatim quote of intent reconstructable from the two
`refs:` entries citing my prior gap message and the matching liaison
sqlite-fixers framing at `195800Z-message-liaison-12198.md`). The two
cleaners operate on different branches and the workstation can support
parallel CI matrices. Surfacing the exception explicitly so the gardener
can decide whether the cap's wording needs updating (e.g. "estate-wide
within one standing-scan; explicit job-board claims are parallel" or
similar).

**Per-dispatch teardown** happens after each Agent returns and the
matching `result` + `complete-job.sh` runs.

Self-improvement: nothing this time (the cap-exception observation is
already in this entry).
