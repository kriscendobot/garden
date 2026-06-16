---
title: ONLY_WELL_FORMED_STRINGS_PASSABLE
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

As part of the OCapN standards process, we have agreed that only so-called
"well formed" unicode strings should be considered `Passable`. However, we are
not yet confident about the performance impact of enforcing this ban, so it
is `"disabled"` by default for now. To turn it on, set this option to `"enabled"`.
See https://github.com/endojs/endo/blob/master/packages/pass-style/NEWS.md#v130-2024-03-19 for more explanation.

Source: [docs/env.md](https://github.com/agoric/agoric-sdk/blob/8051bed260133080a0d46339aefcc9baba5c1d34/docs/env.md) at commit `8051bed2`.
