# signed-updates

Cryptographically signed software update channels for always-online appliance-like nodes. Covers The Update Framework (TUF): its four-role hierarchy (Root/Targets/Snapshot/Timestamp), online vs. offline key discipline (Timestamp key is online for automated re-signing; Snapshot/Root keys are offline to limit compromise blast radius), threshold signatures, and the threat model defended (rollback attacks, freeze attacks, mix-and-match attacks, arbitrary-software injection). For the Endo gateway's upgrade-channel design gap, TUF is the canonical reference for how a vendor delivers signed updates to deployed nodes in a way that is secure even if individual infrastructure components are compromised.

## Sections

| Section | One-line summary |
|---|---|
| [The Update Framework (TUF): overview](../sections/web--tuf-signed-update-framework--overview.md) | TUF role hierarchy, online/offline key distinction, rollback-attack defense, threat model, and always-online node deployment pattern. |
| [Repository-move continuity gap](../sections/literate-ai--docs-decisions-0049-repository-succession--repository-move-continuity-gap.md) | repository-governance, signed-updates | A sanitized move from an internal predecessor to a public successor leaves projects, installed self-updaters, contributor remotes, and historical tags pointing at different repository identities. |
| [Declared repository succession](../sections/literate-ai--docs-decisions-0049-repository-succession--declared-repository-succession.md) | repository-governance, signed-updates, software-supply-chain | One exact predecessor-to-successor declaration permits update continuity without rewriting recorded provenance; an attempted private bridge release failed, so 1.0.x prefix installs require one manual reinstall. |
| [Consequences](../sections/literate-ai--docs-decisions-0049-repository-succession--consequences.md) | repository-governance, signed-updates | Successor-built CLIs can update predecessor-initialized projects and future self-updates target the successor, while each additional move still requires explicit review. |

## See also

- cloud-marketplace — a marketplace listing for an always-online node implies an upgrade channel, making this topic a dependency of the Phase 11 packaging gap.
- tls-provisioning — TLS and signed updates share the key-management and ceremony concerns of first-boot trust establishment.
- node-packaging — upgrade-channel design is a named gap in the Endo strategy brief alongside OS packaging.
