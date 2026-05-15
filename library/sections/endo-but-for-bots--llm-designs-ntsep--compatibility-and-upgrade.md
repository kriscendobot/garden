---
title: Security / Scaling / Test plan / Compatibility / Upgrade
source: designs/ocapn-network-transport-separation.md
source_repo: endojs/endo-but-for-bots
source_branch: llm
source_commit: 0ee0cbb3c7639985c971c30c2fb6f32e1944d55b
source_date: 2026-02-28
source_authors: [Kris Kowal]
ingested: 2026-05-14
ingested_by: scholar
topics: [ocapn, repository-governance]
status: current
notes: The "structural refactoring, no security properties change" claim is the load-bearing safety story. Pre-1.0 status (`@endo/ocapn` v0.2.2) authorizes the breaking change without semver ceremony. The Syrup wire-format change in OcapnLocation field name is the only inter-implementation coordination cost — must talk to the OCapN spec group.
---

> Abstract: Four consideration sections. **Security**: structural refactoring; no security properties change. The refactor makes the boundary clearer (network = trust boundary, not transport). Each network is responsible for its own auth guarantees; OCapN core should document what security properties it expects from a network. **Scaling**: no impact; the registered-network count is small (1-2 typically); session routing overhead is negligible. **Test plan**: all existing tests must pass with updated registration; new unit test for multi-network routing; integration test for tcp-for-test end-to-end on the new interface. **Compatibility**: breaking change to `@endo/ocapn` API (registerNetlayer → registerNetwork; OcapnLocation.transport → .network; NetLayer → OcapnNetwork); Syrup wire-format field-name change affects inter-implementation compat — coordinate with OCapN spec group. Pre-1.0 (v0.2.2) so breaking is expected. **Upgrade**: daemon's `loopback-network` formula + peer-connection logic must adapt; external consumers update their netlayer registrations.

## Security Considerations

- This is a structural refactoring. No security properties change.
- The refactoring makes security boundaries clearer: the network is the trust boundary, not the transport.
- Each network is responsible for its own authentication guarantees. OCapN core should document what security properties it expects from a network (e.g., confidentiality, integrity, peer authentication).

## Scaling Considerations

- No scaling impact. The number of registered networks is small (typically 1-2).
- Session routing adds negligible overhead.

## Test Plan

- All existing OCapN tests must pass after refactoring (with updated registration calls).
- New unit test: register multiple networks, verify locator routing dispatches to the correct network.
- Integration test: tcp-for-test network works end-to-end through the new interface.

## Compatibility Considerations

- This is a breaking change to the `@endo/ocapn` API surface:
  - `registerNetlayer` → `registerNetwork`
  - `OcapnLocation.transport` → `OcapnLocation.network`
  - `NetLayer` type replaced by `OcapnNetwork`
- Syrup wire format for locators changes (field name). This affects interoperability with other OCapN implementations. Coordinate with the OCapN spec group.
- The `@endo/ocapn` package is pre-1.0 (v0.2.2), so breaking changes are expected.

## Upgrade Considerations

- Daemon's `loopback-network` formula and peer connection logic will need to adapt to the new registration API.
- Any external consumers of `@endo/ocapn` will need to update their netlayer registrations.

## See also

- [[syrup-record-positionality]] — important nuance on the design's "Syrup wire-format field-name change" claim. JS field names in `makeOcapnRecordCodecFromDefinition` are *positional bindings*, not on-the-wire. Renaming `transport` → `network` is therefore source-only and wire-compatible *provided* field order, value type, and consumer call sites are updated in lockstep. Cross-implementation coordination may still be warranted, but on grounds of API hygiene (matching the OCapN spec's vocabulary) rather than wire compat per se.

Source: [designs/ocapn-network-transport-separation.md](https://github.com/endojs/endo-but-for-bots/blob/0ee0cbb3c7639985c971c30c2fb6f32e1944d55b/designs/ocapn-network-transport-separation.md) at commit `0ee0cbb3` on branch `llm`.
