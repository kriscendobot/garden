---
source: packages/eventual-send/README.md
source_repo: endojs/endo
source_commit: 14a0b631832ff516b4cafa3946a4a3c0ccbcf052
source_date: 2026-01-04
source_authors: [Kris Kowal]
ingested: 2026-05-14
ingested_by: scholar
section_count: 14
status: current
notes: "Core API" H2 split at H3 (5 functions, each substantively distinct); E.get + E.sendOnly consolidated as one section since they are both lesser-used variants of the basic call form. "Why Eventual Send?" H2 kept consolidated (4 H3s flow as one argument). Background + See Also (both short H2 footers) consolidated into one section.
---

> Abstract: The @endo/eventual-send package README. Covers the shim that installs eventual-send onto promises, the import path, the 5-method Core API (E(target).method, E.get, E.sendOnly, E.when, E.resolve), promise pipelining for cross-boundary calls, the four motivating reasons for E() over .then, Exo integration, the underlying HandledPromise primitive, testing patterns, and Endo-package integration. The application-facing surface for capability-bearing distributed messaging in Endo.

## Sections

| Section | Topics | Status |
|---------|--------|--------|
| [overview](../sections/endo--pkg-eventual-send-readme--overview.md) | eventual-send | current |
| [shim](../sections/endo--pkg-eventual-send-readme--shim.md) | eventual-send | current |
| [importing](../sections/endo--pkg-eventual-send-readme--importing.md) | eventual-send | current |
| [e-method-call](../sections/endo--pkg-eventual-send-readme--e-method-call.md) | eventual-send, captp | current |
| [e-get-and-sendonly](../sections/endo--pkg-eventual-send-readme--e-get-and-sendonly.md) | eventual-send, captp | current |
| [e-when](../sections/endo--pkg-eventual-send-readme--e-when.md) | eventual-send, errors | current |
| [e-resolve](../sections/endo--pkg-eventual-send-readme--e-resolve.md) | eventual-send | current |
| [promise-pipelining](../sections/endo--pkg-eventual-send-readme--promise-pipelining.md) | eventual-send, captp | current |
| [why-eventual-send](../sections/endo--pkg-eventual-send-readme--why-eventual-send.md) | eventual-send, capability-security | current |
| [integration-with-exo](../sections/endo--pkg-eventual-send-readme--integration-with-exo.md) | eventual-send, exo | current |
| [handled-promise](../sections/endo--pkg-eventual-send-readme--handled-promise.md) | eventual-send | current |
| [use-in-tests](../sections/endo--pkg-eventual-send-readme--use-in-tests.md) | eventual-send, testing | current |
| [integration-with-endo](../sections/endo--pkg-eventual-send-readme--integration-with-endo.md) | eventual-send | current |
| [background-and-see-also](../sections/endo--pkg-eventual-send-readme--background-and-see-also.md) | eventual-send | current |

## Provenance

- File last modified 2026-01-04 by Kris Kowal.
- Captured at endo file-specific commit `14a0b631`.

Source: [packages/eventual-send/README.md](https://github.com/endojs/endo/blob/14a0b631832ff516b4cafa3946a4a3c0ccbcf052/packages/eventual-send/README.md).
