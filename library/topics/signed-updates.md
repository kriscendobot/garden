# signed-updates

Cryptographically signed software update channels for always-online appliance-like nodes. Covers The Update Framework (TUF): its four-role hierarchy (Root/Targets/Snapshot/Timestamp), online vs. offline key discipline (Timestamp key is online for automated re-signing; Snapshot/Root keys are offline to limit compromise blast radius), threshold signatures, and the threat model defended (rollback attacks, freeze attacks, mix-and-match attacks, arbitrary-software injection). For the Endo gateway's upgrade-channel design gap, TUF is the canonical reference for how a vendor delivers signed updates to deployed nodes in a way that is secure even if individual infrastructure components are compromised.

## Sections

| Section | One-line summary |
|---|---|
| [The Update Framework (TUF): overview](../sections/web--tuf-signed-update-framework--overview.md) | TUF role hierarchy, online/offline key distinction, rollback-attack defense, threat model, and always-online node deployment pattern. |

## See also

- cloud-marketplace — a marketplace listing for an always-online node implies an upgrade channel, making this topic a dependency of the Phase 11 packaging gap.
- tls-provisioning — TLS and signed updates share the key-management and ceremony concerns of first-boot trust establishment.
- node-packaging — upgrade-channel design is a named gap in the Endo strategy brief alongside OS packaging.
