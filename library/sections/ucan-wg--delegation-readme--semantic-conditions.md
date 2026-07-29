---
title: Semantic conditions at invocation execution
source: README.md
source_repo: ucan-wg/delegation
source_commit: 1cb32dbc9d4d15a23bf9844a02515d760b81e816
source_date: 2026-07-08
source_authors: [Brooklyn Zelenka, Irakli Gozalishvili, Philipp Kruger]
ingested: 2026-07-29
ingested_by: scholar
topics: [ucan-authorization, capability-security]
status: current
---

> Abstract: A UCAN policy cannot express semantic conditions that need facts or side effects outside its argument syntax, such as the current day of week. Those conditions MUST be handled during Invocation execution; the recommended representation is to make the relevant asserted fact part of the command's argument shape, such as `day_of_week: "friday"`, rather than extending policy evaluation into ambient authority.

This is the explicit boundary between offline, deterministic attenuation and the executor's resource-specific semantics. It also explains the token-validation rule that an executor must not reject every capability merely because an irrelevant capability or condition is not understood: interpretation remains capability-specific.

Source: [`README.md`](https://github.com/ucan-wg/delegation/blob/1cb32dbc9d4d15a23bf9844a02515d760b81e816/README.md) at commit `1cb32dbc`.
