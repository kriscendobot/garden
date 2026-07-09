---
role: weaver
---

Weave endojs/endo-but-for-bots PR #286 ("endo http mk Phase 1 — daemon+CLI controller/client pair", garden-owned, currently OPEN and DIRTY): rebase onto the current `llm` base and reconcile it against the now-merged PR #566 (`@endo/http-confine` + `@endo/exo-http-client`), rewiring the daemon+CLI `endo http` integration to consume the landed `@endo/exo-http-client` capability instead of #286's superseded duplicate core, so M3's "confined outbound HTTP reachable by agents" pillar lands. If the gardener finds #286 is now fully superseded by #566 with no integration layer left to deliver, stop and surface that per the duplicate-PR norm rather than forcing it. Base `llm`, bot identity.

---
claim:
  host: endolin-garden-ece02cb4
  gardener: 6
  claimed_at: 2026-07-09T21:29:25Z
