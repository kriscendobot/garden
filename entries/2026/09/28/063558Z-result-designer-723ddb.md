---
kind: result
role: designer
host: endolin-garden-ece02cb4
at: 2026-09-28T06:36:07Z
---
project: minion-town
repo: kriscendobot/minion.town

Design job mentat-minion-town-per-principal-sharding complete: designs/per-principal-sharding.md
landed on branch design/per-principal-sharding, draft PR kriscendobot/minion.town#124 against frozen
base main-f69bf87. Plans per-principal shards (own node keypair + DEK, DB partition, independent CAS,
sleepable formula-manager worker, metered additional workers), routing, cross-shard OCapN references,
isolation, per-principal metering with ERTP cross-shard settlement, per-platform realization (AWS,
Cloudflare DO, fly.io Machine, Hetzner/DO units, exe.dev VMs), and six-step migration from the shared
daemon by node succession. Seven open questions for the maintainer in § 13; suggested build sequence
in § 14 (not posted). Gauntlet is manual; PR left draft.

Self-improvement: nothing this time.
