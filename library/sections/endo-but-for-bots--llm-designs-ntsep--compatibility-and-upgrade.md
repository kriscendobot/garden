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
kind: index
section_count: 6
---

> Abstract: Four consideration sections. **Security**: structural refactoring; no security properties change. The refactor makes the boundary clearer (network = trust boundary, not transport). Each network is responsible for its own auth guarantees; OCapN core should document what security properties it expects from a network. **Scaling**: no impact; the registered-network count is small (1-2 typically); session routing overhead is negligible. **Test plan**: all existing tests must pass with updated registration; new unit test for multi-network routing; integration test for tcp-for-test end-to-end on the new interface. **Compatibility**: breaking change to `@endo/ocapn` API (registerNetlayer → registerNetwork; OcapnLocation.transport → .network; NetLayer → OcapnNetwork); Syrup wire-format field-name change affects inter-implementation compat — coordinate with OCapN spec group. Pre-1.0 (v0.2.2) so breaking is expected. **Upgrade**: daemon's `loopback-network` formula + peer-connection logic must adapt; external consumers update their netlayer registrations.

Sections:

- [Security Considerations](endo-but-for-bots--llm-designs-ntsep--compatibility-and-upgrade--security-considerations.md)
- [Scaling Considerations](endo-but-for-bots--llm-designs-ntsep--compatibility-and-upgrade--scaling-considerations.md)
- [Test Plan](endo-but-for-bots--llm-designs-ntsep--compatibility-and-upgrade--test-plan.md)
- [Compatibility Considerations](endo-but-for-bots--llm-designs-ntsep--compatibility-and-upgrade--compatibility-considerations.md)
- [Upgrade Considerations](endo-but-for-bots--llm-designs-ntsep--compatibility-and-upgrade--upgrade-considerations.md)
- [See also](endo-but-for-bots--llm-designs-ntsep--compatibility-and-upgrade--see-also.md)

Source: [designs/ocapn-network-transport-separation.md](https://github.com/endojs/endo-but-for-bots/blob/0ee0cbb3c7639985c971c30c2fb6f32e1944d55b/designs/ocapn-network-transport-separation.md) at commit `0ee0cbb3` on branch `llm`.
