---
ts: 2026-06-01T23:01:04Z
kind: dispatch
role: builder
host: endolinbot
repo: kriskowal/garden
project: garden
to: "*"
dispatch_root: /home/kris/dispatches/builder--354902
short_id: 354902
prs:
  - repo: kriskowal/garden
    pr: 3
    role: target
refs:
  - https://github.com/kriskowal/garden/pull/3
  - https://github.com/kriskowal/garden/pull/3#pullrequestreview-4405216188
---

# dispatch: builder — implement the driver (PR #3 design)

Implement Phase 1 (scaffolding) of designs/driver.md per the
kriskowal review at PR #3 inviting a builder dispatch. Surface
clarifying questions on the PR; build a mock-garden test harness;
preferred PR shape is extending #3 (design + impl together) unless
that balloons it past reviewability. Two open questions remain
unresolved in the design (Q5 tooling boundaries, Q10 capture blob
lifecycle); builder may default and surface, or impasse if blocking.

Full brief carried in the prompt to the dispatched builder.
