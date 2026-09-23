---
source: designs/ocapn-network-transport-separation.md
source_repo: endojs/endo-but-for-bots
source_branch: llm
source_commit: 0ee0cbb3c7639985c971c30c2fb6f32e1944d55b
source_date: 2026-02-28
source_authors: [Kris Kowal]
ingested: 2026-05-14
ingested_by: scholar
section_count: 4
status: current
notes: Substantial refactor design. Status: In Progress. The conceptual shift "locator → network → transport → physical connection" reorganizes OCapN's identity story. Cross-cuts heavily with library's existing OCapN material: ocapn--draft-specifications-locators (the locator + transport field today), ocapn--draft-specifications-captp (op:start-session handshake), ocapn--implementation-guide--stage-0-foundation (the current handshake + crossed-hellos flow), endo--pkg-ocapn-readme (the realization), endo--pkg-ocapn-noise-readme (the noise netlayer that drives this refactor).
---

> Abstract: Design for separating OCapN's "network" and "transport" concepts. Today the `OcapnLocation.transport` field conflates protocol family with physical carrier; the design renames it to `network` and introduces a new `OcapnNetwork` interface whose `connect(location)` returns a **session** (authenticated, encrypted, CapTP-ready) rather than a raw connection. Networks own the full lifecycle from transport selection through session establishment, including their own handshake (today's `op:start-session` becomes the tcp-for-test network's handshake, not a core mandate). Four sections: problem statement, new conceptual model + OcapnNetwork interface, refactoring steps with affected-files table, and compatibility + upgrade implications (breaking API change to `@endo/ocapn` v0.2.2; Syrup wire format changes; coordinate with OCapN spec group).

## Sections

| Section | Topics | Status |
|---------|--------|--------|
| [problem-statement](../sections/endo-but-for-bots--llm-designs-ntsep--problem-statement.md) | ocapn, captp | current |
| [design-conceptual-model](../sections/endo-but-for-bots--llm-designs-ntsep--design-conceptual-model.md) | ocapn, captp, capability-security | current |
| [refactoring-steps](../sections/endo-but-for-bots--llm-designs-ntsep--refactoring-steps.md) | ocapn, captp | current |
| [compatibility-and-upgrade](../sections/endo-but-for-bots--llm-designs-ntsep--compatibility-and-upgrade.md) | ocapn, repository-governance | current |

## Cross-references

- The current `op:start-session` handshake under refactor: `ocapn--draft-specifications-captp--*` (spec), `ocapn--implementation-guide--stage-0-foundation` (impl walk-through).
- The `OcapnLocation` `transport` field today: `ocapn--draft-specifications-locators--*`.
- Endo's current netlayer realization: `endo--pkg-ocapn-readme--*`.
- The noise-network driver: `endo--pkg-ocapn-noise-readme--*`.

## Source

[designs/ocapn-network-transport-separation.md](https://github.com/endojs/endo-but-for-bots/blob/0ee0cbb3c7639985c971c30c2fb6f32e1944d55b/designs/ocapn-network-transport-separation.md) at commit `0ee0cbb3` on branch `llm`.
