---
title: "OCapN spec compatibility: three options for the comma deviation"
source: designs/ocapn-tcp-syrups-framing.md
source_repo: endojs/endo-but-for-bots
source_branch: llm
source_commit: a4978698b19bbea5fcb8049e5cb7944ac8f2485a
source_date: 2026-05-06
source_authors: [Kris Kowal]
ingested: 2026-06-22
ingested_by: librarian
topics: [ocapn]
status: current
---

> Abstract: The OCapN draft spec describes a netlayer for "TCP with netstring framing" including the trailing comma. The comma-less `@endo/syrups` variant is therefore not on-the-wire compatible with other OCapN implementations. Three options: (1) propose the change upstream (argue to the OCapN community that Syrup-carrying transports should adopt the comma-less variant); (2) Endo-internal variant on a distinct transport identifier (`tcp-syrups` alongside `tcp-testing-only`); (3) make it the default for test-only traffic and upstream later. Recommended: Option 2 in the short term (a new transport identifier is cheap, preserves Python-test-suite interop for existing `tcp-testing-only` transport which gets a correctness fix with real `@endo/netstring` framing), argue for Option 1 in parallel (draft a spec change proposal to the OCapN community). The existing `tcp-testing-only` netlayer gets a bug fix (adopt `@endo/netstring` so chunk-boundaries are handled) and a new sibling `tcp-syrups` gets the comma-less framing. Dependencies: `ocapn-network-transport-separation.md` (prerequisite; establishes `OcapnNetwork` interface), `ocapn-tcp-for-test-extraction.md` (sibling; the `op:start-session` handshake moving into the TCP network flows through the syrups framer).

**Three compatibility options (lines 403-451):**

Option 1: Propose upstream to the OCapN community that Syrup-carrying transports should use comma-less grammar. Payoff: 1 byte per message saved, cleaner conceptual model. Cost: coordination with Spritely and other OCapN participants, compatibility break for existing implementations. Not trivial.

Option 2 (recommended): Register a new transport name (`tcp-syrups`) alongside `tcp-testing-only`. Keep `tcp-testing-only` netstring-compliant (actually adopt `@endo/netstring` for the bug fix) and use `tcp-syrups` for Endo-to-Endo traffic. Locators advertise which variant they speak.

Option 3: Change `tcp-testing-only` framing unilaterally (since it is explicitly test-only), document the deviation, propose upstream rationalization when OCapN spec moves toward 1.0. Interop with Python test suite breaks until upgraded.

**Relationship to sibling designs (lines 462-470):**
From `ocapn-network-transport-separation.md`: a `tcp-syrups` network registers under a distinct network identifier and carries its own framing choice. The `OcapnNetwork.connect` contract ("return a session ready for CapTP") is unchanged. From `ocapn-tcp-for-test-extraction.md`: the `op:start-session` handshake moving into the TCP network is itself a Syrup record; it flows through the same framing. With `@endo/syrups`, `handleHandshakeMessageData` reads exactly one frame, decodes one Syrup record, and hands off — the `while` loop disappears.

**Named structural fact: §the-named-two-transport-identifiers-as-spec-divergence-management** — maintaining two registered transport names (`tcp-testing-only` for spec-compliant netstring, `tcp-syrups` for comma-less syrups) lets Endo innovate on the wire format without breaking existing interop, while the locator disambiguates which variant each peer speaks.
