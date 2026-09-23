---
ts: 2026-06-22T11:54:17Z
kind: result
role: librarian
project: endo
---

Cycle 439 designs-lane complete. Ingested packages/lal/primer/howto-inventory.md (133 lines) from endojs/endo-but-for-bots llm branch.

**Source page**: `library/sources/endo-but-for-bots--packages-lal-primer-howto-inventory-md.md`
**Section file**: `library/sections/endo-but-for-bots--packages-lal-primer-howto-inventory-md--pet-names-as-gc-roots.md`
**README updated**: total advances to 951 sections / 477 sources / 87 conformant cycles.

**Single most structurally interesting move**: §the-named-pet-names-as-gc-roots. Lines 118-121 warn: "if the garbage collector is enabled and you remove all names for a capability you've shared, the other party loses access." Pet names are GC roots. The inventory naming layer is not just a human-readable alias system but the LIVENESS LAYER for remote capability access: the naming structure determines which capabilities remain reachable for remote parties. §the-named-naming-layer-as-liveness-layer as tier-3 meta-pattern.

**New vocabulary / state delta**:
- §the-named-liveness-revocation-as-fourth-security-dimension: the cluster's security vocabulary now spans FOUR named dimensions — COTENANT (cycle 433) + EXFILTRATION (cycle 436) + EXECUTION-CONTEXT-LEAK (cycle 438) + LIVENESS-REVOCATION (cycle 439). Each requires distinct handling; the Endo architecture addresses each with dedicated machinery.
- §the-named-user-facing-namespace-simpler-than-implementation-namespace: cycle 394's three-namespace implementation (lowercase pet names, UPPERCASE special names, @-prefixed special names) collapses to two in user-facing vocabulary. The howto calls @-prefixed names "special names" and treats UPPERCASE as code-internal.
- §the-named-chat-and-cli-as-non-overlapping-operation-sets: the Chat/CLI surface asymmetry is now named bidirectionally. CLI has UNCONFINED (cycle 409); Chat has /view and /edit (cycle 439). Both directions are explicit.
- §the-named-inventory-as-full-crud-namespace: the primer's howto-* trio is now complete. howto-code (cycle 409) covers code evaluation; howto-capabilities (cycle 437) covers capability management; howto-inventory (cycle 439) covers inventory management. Together they span the full user-facing surface of @endo/lal.

**Citation arc delta**: 10 arcs closed (cycles 438, 437, 409, 394, 429, 433, 416, 326, 322, 435). Citation-arc-closures-in-pivot advances from 842 to **852**.

Self-improvement: nothing this time. The designs-lane howto-inventory.md ingestion followed the established pattern cleanly; no structural gaps in the procedure surfaced.
