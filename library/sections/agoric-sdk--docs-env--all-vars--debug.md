---
title: DEBUG
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

Affects: agoric (CLI), ag-chain-cosmos, ag-solo

Purpose: to change the meaning of `console.log` and other console methods

Description: uses `anylogger` to change whether the following methods are active
for a given context, in order of increasing severity:

1. `console.debug`
2. `console.log`
3. `console.info`
4. `console.warn`
5. `console.error`

If `$DEBUG` is unset or non-empty, then default (`console.log` and above) logging is enabled.  (`console.debug` logging is disabled.)

If `$DEBUG` is set to an empty string, then quiet (`console.info` and above) logging is enabled.
(`console.log` and `console.debug` logging is disabled.)

Otherwise, set to a comma-separated list of strings.

If one of those strings is
- `agoric:${level}`, then don't print `agoric-sdk` console messages below `${level}`.
- `agoric:none`, then silence all `agoric-sdk` console messages.
- `agoric` (an alias for `agoric:debug`) print all `agoric-sdk` console messages.
- `track-turns`, then log errors at the top of the event-loop that may otherwise be unreported. See also the TRACK_TURNS environment variable below.
- `label-instances`, then log exo instances with a unique label per instance. HAZARD This causes an information leak in the messages of thrown errors, which are available even to code without access to the console. Use with care.

For each of those strings beginning with a prefix recognized as indicating what
console messages to enable, pass it to `makeConsole`. For example:

- `DEBUG=SwingSet:ls` enable all console messages for liveslots, regardless of vat.
- `DEBUG=SwingSet:ls:v13` enable for liveslots in vat 13.
- `DEBUG=SwingSet:vat` enable for user code, regardless of vat.
- `DEBUG=SwingSet:vat,SwingSet:ls` enable for liveslots and user code, all vats

Source: [docs/env.md](https://github.com/agoric/agoric-sdk/blob/8051bed260133080a0d46339aefcc9baba5c1d34/docs/env.md) at commit `8051bed2`.
