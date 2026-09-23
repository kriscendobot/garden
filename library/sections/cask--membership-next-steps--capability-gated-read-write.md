---
title: Later — Capability-Gated Read/Write
source: doc/design/membership-next-steps.md
source_repo: kriskowal/cask
source_commit: cdb975d875b876c8fb7b4fb9e97f6567b52a7aa4
source_date: 2026-02-14
source_authors: [Kris Kowal]
ingested: 2026-06-25
ingested_by: scholar
topics: [capability-security, networking]
status: current
---

> Abstract: The third gate, deferred behind membership and session. Once membership and session are in place, a **session** means "this peer is a known friend and we have an encrypted channel," while a **capability** means "this peer is allowed to read/write this cell (or subtree)." The next layer is that even with a valid session the server only allows LOAD/STOR (or lode/stoe) when the request is authorized by a capability: the request carries or implies a `cap_token` that maps to a `cell_addr`, and the operation must be within the scope of that cell. The design lives in CELLS.md and the future RPC/cell layer; membership is the prerequisite so only invited guests can get to the point of presenting capabilities at all.

## Later: Capability-Gated Read/Write

Once membership and session are in place:

- **Session** = "this peer is a known friend and we have an encrypted channel."
- **Capability** = "this peer is allowed to read/write this cell (or subtree)."

So the next layer is: even with a valid session, the server only allows LOAD/STOR (or lode/stoe) when the request is authorized by a capability — e.g. the request carries or implies a `cap_token` that maps to a `cell_addr`, and the operation is within the scope of that cell. Design for that lives in CELLS.md and the future RPC/cell layer; membership is the prerequisite so that only invited guests can get to the point of presenting capabilities at all.

## Doc References

- **ROOT_DESIGN.md** – Membership as Rabin-chunked sorted array (`peers_index`, `peer_info`, `trusted`).
- **SORTED_ARRAY_DESIGN.md** – Implementation plan for sorted array (not yet built).
- **CELLS.md** – Capability map, cell map, capability-gated access.
- **SESSION_INIT_DESIGN.md** – `ini6`/`in6r`, encrypted commands (lode/stoe/acke).

Source: [doc/design/membership-next-steps.md](https://github.com/kriskowal/cask/blob/cdb975d875b876c8fb7b4fb9e97f6567b52a7aa4/doc/design/membership-next-steps.md) at commit `cdb975d8`.
