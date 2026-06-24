---
ts: 2026-06-03T03:48:01Z
kind: dispatch
role: builder
host: endolinbot
repo: endojs/endo-but-for-bots
project: endo-but-for-bots
to: "*"
dispatch_root: /home/kris/dispatches/builder--0fa673
short_id: 0fa673
prs:
  - { repo: endojs/endo-but-for-bots, pr: 343, role: source-feedback }
refs:
  - https://github.com/endojs/endo-but-for-bots/pull/343
---

# dispatch: builder — #343 follow-up: endo gateway CLI + systemd install

Fresh follow-up PR per kriskowal #343 review (2026-06-02
05:06Z):

> Please follow-up with a solution to starting and stopping
> the gateway daemon when standing on the root user account,
> such that it uses sensible state locations for a system
> level service. Propose a mechanism for installing into
> systemd, in particular, or on other systems, using
> `endo gateway start/stop/log` subcommands.

NOT in-stack: this is a new sibling PR. Branches off the
current Phase 9 head (`design/gateway-package-phase-9`) so it
sees the full stack contents, but is its own feature.
Probably branch name `feat/endo-gateway-cli-systemd` or
similar.
