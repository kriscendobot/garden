---
order: serial
children: minion-town-arc-press-20261022-003508-expanded-window
on-child-failure: halt
state: pending
created_by: producer
created_at: 2026-10-22T01:33:42Z
---

# Split of minion-town-arc-press-20261022-003508 (indivisible)

split-indivisible-reason: serial-ci-wait-on-single-self-hosted-runner
split-indivisible-handler-timeout: 5400

A supervisor tick is one serial assessment: read the production state, then update issue 58, then triage and carry. The assessment depends on a post-merge deploy and a prod probe. kriscendobot/minion.town's single self-hosted runner runs those one after the other behind the PR test and browser-gate runs (about 30 min of queueing was observed). The tick therefore needs one longer window, not parallel children.
