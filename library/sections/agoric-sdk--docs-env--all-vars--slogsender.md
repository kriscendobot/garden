---
title: SLOGSENDER
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

Affects: cosmic-swingset

Purpose: intercept the SwingSet LOG file in realtime

Description: when nonempty, use the value as a list of module specifiers
separated by commas `,`.  `@agoric/telemetry/src/make-slog-sender.js` export
`makeSlogSender` loads each module via dynamic `import` and calls its exported
`makeSlogSender` function to construct a slogSender that will be called with
each new slog entry (fanning such objects out to each module). Prefixing a
module specifier with `-` causes it to be excluded, and can be used to suppress
otherwise automatic use of modules for e.g. writing slogfiles and exporting
Prometheus metrics.

The default is `'@agoric/telemetry/src/flight-recorder.js'`, which writes to an
mmap'ed circular buffer.

Source: [docs/env.md](https://github.com/agoric/agoric-sdk/blob/8051bed260133080a0d46339aefcc9baba5c1d34/docs/env.md) at commit `8051bed2`.
