---
section: three-configurations-of-eval-authority-with-ocap-as-safety-boundary-not-message-approval
source: endo-but-for-bots--llm-designs-daemon-guest-eval-simplification
topics: [agent-conventions, capability-security]
status: current
title: The §three-dependencies — design-link cluster
parent: endo-but-for-bots--llm-designs-daemon-guest-eval-simplification--three-configurations-of-eval-authority-with-ocap-as-safety-boundary-not-message-approval
---

The §Dependencies table names three sibling designs:

| Design | Relationship |
|--------|-------------|
| `daemon-agent-tools` (cycle 107) | *Simplifies the tool surface — eval covers many tool patterns* |
| `daemon-capability-bank` (cycle 105) | *Capability composition model that makes direct eval safe* |
| `lal-fae-form-provisioning` | *Agents already use direct eval via this design* |

The §design-link-cluster: cycle 105's `daemon-capability-bank`
provides the *ocap discipline that makes direct eval safe*; cycle
107's `daemon-agent-tools` is the *concrete-tool surface that eval
subsumes*; `lal-fae-form-provisioning` is the *already-uses-direct-
eval* prior art that proves the model works.
