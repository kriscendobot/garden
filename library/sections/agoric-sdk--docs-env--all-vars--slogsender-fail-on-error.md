---
title: SLOGSENDER_FAIL_ON_ERROR
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

Purpose: causes failures of the slogSender to be fatal

Description: if set (to a non empty value), a failure of the slogSender flush
operation will result in a rejection instead of mere logging. Can be used to
validate during tests that complex slog senders like the otel converter do not
have any unexpected errors.

The default is `undefined`.

Source: [docs/env.md](https://github.com/agoric/agoric-sdk/blob/8051bed260133080a0d46339aefcc9baba5c1d34/docs/env.md) at commit `8051bed2`.
