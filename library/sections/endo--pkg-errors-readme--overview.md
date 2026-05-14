---
title: errors (overview)
source: packages/errors/README.md
source_repo: endojs/endo
source_commit: dd24b13d
source_date: 2025-12-04
source_authors: [Kris Kowal]
ingested: 2026-05-14
ingested_by: scholar
topics: [errors, hardened-javascript]
status: current
---

> Abstract: @endo/errors: package-level interface for the assert and error utilities described in docs/errors.md. Tiny pointer (13 lines).

# `@endo/errors`

When host and guest programs share a JavaScript context, there is some risk that
the guest will call a host function and induce it to throw an exception that
inadvertently reveals information about its internal state to the guest.
It is similarly possible that a guest would inadvertently reveal information to
a cotenant guest.

For this reason, the `@endo/errors` package provides utilities for constructing
errors with redacted messages.
In coordination with [ses](../ses/) in the host realm, the information
redacted by these utilities will be revealed to the realm's console for use
in debugging, but be invisible to code that catches them.

Source: [packages/errors/README.md](https://github.com/endojs/endo/blob/dd24b13d/packages/errors/README.md) at commit `dd24b13d`.
