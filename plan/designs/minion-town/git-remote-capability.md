---
slug: git-remote-capability
repository: minion-town
status: Complete
size: M
milestone: M3
roadmap_relevance: 100
depends_on: [daemon-git-remotes, daemon-git-next-steps, endor-git-bindings]
pr: minion-town#41
created: 2026-08-11
updated: 2026-09-03
source: carved into the endo M3 roadmap by groom-carve-mcp-bridge-milestone (2026-09-03)
---

# git-remote-capability — the capability-addressed git remote (client-side bridge, M3 top priority)

One of the **two client-side-bridge capabilities** carved to the head of the
endo M3 milestone on 2026-09-03. It is the "get an artifact in" half of the
bottleneck class *get code/state across the MCP-daemon boundary without an
external LLM hand-marshaling bytes*: Minion Town HTTP acts as a **git remote per
guest**, capability-URL addressed, authorizing read/write into a CAS partition —
so `git push` becomes the way to get an artifact into an Endo directory, with no
MCP-tool-call byte marshaling.

- **Design:** `designs/git-remote-capability.md` on `kriscendobot/minion.town`
  (PR minion-town#41, merged 2026-08-18; spec only, no live change).
  Maintainer-mandated (@kriskowal, 2026-08-11). Its § 12 named the endo-side
  follow-on implementation as "named but not actioned."
- **Endo-side follow-on (in M3):** the git trio [[daemon-git-capability]],
  [[daemon-git-remotes]], [[daemon-git-next-steps]], plus the
  [[daemon-agent-tools]] `makeGitRemoteTool` push tier (#705).
- **Rust smart-HTTP backing:** [[endor-git-bindings]] (home M11; revised
  2026-08-14 after this Minion Town Git-remote review — the shared
  `rust/endor-git` contract backs Minion Town's smart-HTTP adapter).
- **Read-side companion it reframes:** git-content-substrate (minion.town #39).
- **Endo ledger PR:** endojs/endo-but-for-bots#1127 (the groom carving this into M3).

This record is the cross-repository companion in the endo milestone ledger; the
design itself lives and is complete in `kriscendobot/minion.town`.
