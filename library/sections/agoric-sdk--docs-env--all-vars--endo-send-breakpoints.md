---
title: ENDO_SEND_BREAKPOINTS
source: docs/env.md
source_repo: agoric/agoric-sdk
source_commit: 8051bed260133080a0d46339aefcc9baba5c1d34
source_date: 2026-03-31
source_authors: [Mark S. Miller]
ingested: 2026-05-14
ingested_by: scholar
project: agoric-sdk
topics: [tooling, repository-governance, errors]
status: current
parent: agoric-sdk--docs-env--all-vars
---

The value of this option is a JSON string identifying for which eventual sends
should a JS `debugger;` statement be executed. The format is the same as
shown for `ENDO_DELIVERY_BREAKPOINTS` above, but the breakpoint happens
when and where the message is sent, rather than when and where it is delivered.

Source: [docs/env.md](https://github.com/agoric/agoric-sdk/blob/8051bed260133080a0d46339aefcc9baba5c1d34/docs/env.md) at commit `8051bed2`.
