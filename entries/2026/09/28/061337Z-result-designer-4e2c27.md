---
kind: result
role: designer
host: endolin-garden-ece02cb4
at: 2026-09-28T06:13:42Z
---
project: minion-town
repo: kriscendobot/minion.town

Designer job mentat-minion-town-endor-ironhorse-snapshot-platforms complete: landed
designs/process-snapshot-persistence-by-platform.md as draft PR
https://github.com/kriscendobot/minion.town/pull/123 (head
design/process-snapshot-persistence-by-platform, frozen base main-f69bf87, diff is the
design file only). The design plans endor / Iron Horse orthogonal persistence of running
processes (idle-only worker heap snapshots) across AWS, Cloudflare, Hetzner, DigitalOcean,
fly.io, and exe.dev: the two engine mechanisms (whole-heap CAS blob; Iron Horse HeapStore
database-backed heap), the engine-versus-platform contract with an ownership map, per-platform
snapshot placement / restore / migration / compatibility / cold-start / cost with first-party
citations (fetched 2026-09-28, unverified items flagged), the KaozKit comparison, clearly
marked cross-repo Endo implications, sharding hooks, seven maintainer open questions, and a
proposed build sequence (design-endo-snapshot-compat-manifest,
build-endo-daemon-platform-store-seams, probe-minion-town-thixotrope-sleep-wake,
probe-ironhorse-wasm32-workerd, design-minion-town-fly-shard-machine,
design-endo-remote-heapstore-backend; suggested, not posted). PR left draft per the
manual-gauntlet regime. Sibling mentat plans had not landed; the Companion header records
the boundary.

Self-improvement: nothing this time.
