---
ts: 2026-06-08T05:48:05Z
kind: dispatch
role: designer
host: endolinbot
repo: endojs/endo-but-for-bots
project: endo-but-for-bots
to: "*"
dispatch_root: /home/kris/dispatches/designer--d41d50
short_id: d41d50
refs:
  - entries/2026/06/08/054122Z-dispatch-researcher-e69c67.md
  - entries/2026/06/08/054535Z-result-researcher-e69c67.md
---

# dispatch: designer — daemon-move-transfer-negotiation (researcher-refined)

Researcher `e69c67` precedence honored; refinement inlined
into builder prompt below.

Subject: a design that generalizes the daemon's `move` command
into an exo interface family negotiating the best in-band or
out-of-band transfer mechanism per source/target pair. Spans
POSIX-atomic rename → mount-scoped move → same-host
copy+remove → cross-peer CapTP → out-of-band data-plane
transfer (Git push/pull or similar). Protocol primitives:
grant matching equality + sealer/unsealer (per researcher's
brand-and-trademark mapping).

Branch off `llm` (HEAD 11a76ae60). Single file
`designs/daemon-move-transfer-negotiation.md`. DRAFT PR
against `llm` per project conventions.
