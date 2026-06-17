---
ts: 2026-06-17T22:14:00Z
kind: message
role: liaison
host: endolinbot
repo: endojs/endo-but-for-bots
project: endo-but-for-bots
prs:
  - repo: endojs/endo-but-for-bots
    pr: 452
    role: subject
refs:
  - https://github.com/endojs/endo-but-for-bots/pull/452#issuecomment-4735987527
---

# queued: investigator dispatch for kumavis reconnection-semantics ask on #452

Kumavis at 22:11:25Z asks (in reply to the earlier kriscendobot
teardown-semantics response at #issuecomment-4735846280):

> we want to make sure that if the connection goes down and a then a
> remote object is attempted to be used again, it will retrigger a
> connection attempt. if im not mistaken, the correct way to do that
> is to trigger the teardown of all remote formulas and those that
> depend on them by destroying the peer formula. investigate and
> report here

Added 👀 reactji on the comment (reaction id 371463662).

## Why queued, not folded into fixer da9e7d

Fixer `da9e7d` is already in flight on the three earlier kumavis
directives (copilot feedback + teardown response + lint fix incl.
shellcheck). It pushed 73c22d89c at 22:11Z and posted the lint
follow-up at 22:12:48Z. Folding a new investigation in mid-task
muddles the deliverable and the fixer is shaped for code changes,
not for an "investigate and report" ask.

This is an **investigator** dispatch shape (per
`roles/investigator/AGENT.md`): read the relevant peer/host
formula code paths, characterize current connection-loss behavior,
verify or refute kumavis's hypothesis (destroying the peer formula
is the correct trigger for retriggering connection on next use),
and post a top-level findings comment that either confirms the
proposed mechanism or proposes an alternative grounded in the code.

If the investigation confirms the mechanism, a follow-up
fixer/builder dispatch lands the code change; if it refutes or
refines, the dispatch ends at the report.

## Next-tick action

After fixer `da9e7d` returns (notification expected shortly given
its 22:12:48Z post), dispatch investigator with:

- Target: PR #452 / branch `kriskowal-iroh-heartbeat`
- Question: when an iroh connection drops, what does the daemon
  currently do with the peer's remote formulas? Does attempting to
  use a remote object after disconnect retrigger a connection? If
  not, is destroying the peer formula the correct trigger as
  kumavis proposes?
- Refs: kumavis comment 4735987527, prior bot teardown response
  4735846280, the heartbeat PR itself, and `packages/daemon/src/`
  formula-management code.
- Deliverable: top-level findings comment on #452
  at-mentioning @kumavis.
