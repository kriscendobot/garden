---
title: Introduction
source: docs/message-passing.md
source_repo: endojs/endo
source_commit: 14a0b631832ff516b4cafa3946a4a3c0ccbcf052
source_date: 2026-01-04
source_authors: [Kris Kowal]
ingested: 2026-05-14
ingested_by: scholar
topics: [eventual-send, marshal, capability-security]
status: current
---

> Abstract: Framing for the message-passing model in Endo: how capability-bearing objects exchange messages across realm, vat, and machine boundaries. The Introduction section sets the stage with what makes message-passing different from synchronous calls, why it matters for distributed and confined systems, and what tools (pass-style, patterns, eventual-send) the rest of the guide will assemble.

---
title: message-passing
group: Documents
category: Guides
---

# Message Passing

## Introduction

Building distributed object-capability systems requires solving a fundamental
challenge: how do objects in different isolated compartments or machines
communicate safely and asynchronously?
The Endo stack provides a layered solution through four interconnected
packages:

- **@endo/pass-style** - Defines what data can cross boundaries
- **@endo/patterns** - Describes and validates expected data shapes
- **@endo/exo** - Creates defensive objects that validate inputs
- **@endo/eventual-send** - Enables asynchronous message passing

Together, these packages implement safe message passing: the ability to send
messages to objects that will receive and process them, with strong safety
guarantees at every step.

This guide presents a natural progression: from data (what can be passed?)
through validation (is it well-formed?) to objects (how do we receive safely?)
and finally communication (how do we pass messages?).
Each concept builds on the previous one, culminating in a complete example
showing all four packages working together.

### Prerequisites

This guide assumes familiarity with:
- [Hardened JavaScript](./guide.md) and the `lockdown()` function
- Object capabilities and the principle of least authority
- Promises and asynchronous JavaScript


Source: [docs/message-passing.md](https://github.com/endojs/endo/blob/14a0b631832ff516b4cafa3946a4a3c0ccbcf052/docs/message-passing.md) at commit `14a0b631`.
