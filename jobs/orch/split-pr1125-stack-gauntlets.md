---
child-split-pr1125-1304-gauntlet-shepherd-failure-notified: true
child-split-pr1125-1304-gauntlet-shepherd-host: endolin-garden-ece02cb4
child-split-pr1125-1304-gauntlet-shepherd-reap-count: 0
order: serial
children: split-pr1125-1304-gauntlet-shepherd split-pr1125-1306-gauntlet-shepherd split-pr1125-1305-gauntlet-shepherd
on-child-failure: halt
state: running
created_by: gardener
created_at: 2026-09-17T21:55:00Z
---

# Drive the #1125-replacement stack through gauntlet + shepherd, in order

Serial orchestration of the gauntlet + shepherd loop for each PR in the three-PR
stack that replaced the retired endojs/endo-but-for-bots#1125:

1. #1304 — read-only directory attenuation (base of stack)
2. #1306 — guest provisioning (pins, networks, names) — stacked on #1304
3. #1305 — guest-owned invitation primitive — stacked on #1306

SERIAL and halt-on-failure is load-bearing: the PRs are a genuine git stack, so a
fix the gauntlet pushes to a lower slice's branch requires rebasing/repointing the
slices above it. Running one slice's gauntlet to termination before promoting the
next keeps each incremental diff honest (a parallel run would let slice 1's fix
appear to "revert" in slice 2's diff). Each child rebases onto its (by-then
settled/merged) base before initiating its own gauntlet.
