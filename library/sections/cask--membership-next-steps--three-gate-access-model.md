---
title: The Three-Gate Access Model
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

> Abstract: CASK is not an open service. Nobody should be able to read or write without being an **invited guest** holding a capability to read or write starting at some particular cell; even establishing a session is an imposition permitted only for a **known friend** (a peer in membership). Access is therefore layered into three ordered gates: **membership** (can this peer connect at all, i.e. is it allowed to send `ini6` and establish a session?), **session** (an authenticated, encrypted channel, opened only if the peer is in membership), and **capability** (what this session may do: read/write scoped to cells for which the peer holds a capability). As of this design, gates 1 and 2 are on the cusp of enforcement; gate 3 is the longer-term capability model from CELLS.md. The membership gate is the prerequisite that ensures only invited guests ever reach the point of presenting capabilities at all.

## Principle

CASK is not an open service. Nobody should be able to read or write without being an **invited guest** — holding a capability to read or write starting at some particular cell. Even establishing a session is an imposition we only permit if the peer is a **known friend** (in membership).

**Order of gates:**

1. **Membership** – Can this peer connect at all? (Allowed to send `ini6` and establish a session?)
2. **Session** – Authenticated, encrypted channel (only if in membership).
3. **Capability** – What may this session do? (Read/write scoped to cells for which the peer holds a capability.)

We are on the cusp of enforcing (1) and (2); (3) is the longer-term model from CELLS.md.

Source: [doc/design/membership-next-steps.md](https://github.com/kriskowal/cask/blob/cdb975d875b876c8fb7b4fb9e97f6567b52a7aa4/doc/design/membership-next-steps.md) at commit `cdb975d8`.
