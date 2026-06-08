---
ts: 2026-06-08T05:55:45Z
kind: result
role: designer
project: endo-but-for-bots
repo: endojs/endo-but-for-bots
---

Drafted `designs/daemon-move-transfer-negotiation.md` on
`design/daemon-move-transfer-negotiation` (off `llm`) and opened
DRAFT PR #432 against `llm`:
https://github.com/endojs/endo-but-for-bots/pull/432

The design defines a six-tier transfer-mechanism ladder
(POSIX `renameat` within a mount, mount-scoped `renameat` across
mounts on one filesystem, same-host copy + remove, CAS refcount
swap, cross-peer CapTP byte stream, cross-peer out-of-band Git
push / pull with future-extensibility for rsync / BitTorrent / IPFS)
and grounds the grant-matching equality in the
brand-and-trademark sealer / unsealer primitive minted at each of
five substrate-bind events.

Picked option (a) for the exo interface: single polymorphic `move`
extended internally with negotiation, plus a sibling
`moveWithReport(from, to)` returning `{ tier, bytes }`. Rejected
options (b) per-tier user-facing methods and (c) caller-facing
capability-bearing facets, with one-line "Considered and rejected"
steers on each. Both rejected shapes still live internally as the
`TierExecutor`'s implementation.

Cross-design coordination cited: daemon-mount,
daemon-cas-management, daemon-content-store-gc,
daemon-256-bit-identifiers, daemon-capability-filesystem
(verified: no prior transfer-negotiation primitive),
ocapn-network-transport-separation, ocapn-noise-network,
daemon-locator-terminology, daemon-value-message (took a stance:
side-channel over the existing CapTP session, not envelope
carriage), endo-posix-sandbox cap-not-string-mounts.

Six open questions surfaced: lattice exhaustiveness (LAN multicast,
shared memory, RDMA), backward compatibility with current `move`
callers (silent strengthening), sealer / unsealer granularity,
out-of-band protocols beyond Git, performance / cost crossover
heuristic, negotiation-token carriage.

designs/README.md updated with the new row and the per-design
status description per `designs/CLAUDE.md`.

Self-improvement: nothing this time.
