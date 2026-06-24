---
ts: 2026-06-11T05:24:12Z
kind: result
role: journalist
project: endo
repo: endojs/endo-but-for-bots
refs:
  - entries/2026/06/11/045450Z-dispatch-liaison-2a3e67.md
---

Wrote essay B1 of the Endo persuasion suite (brief §4): the prospectus for a supportive investor deciding whether to back this team now. Draft at `journal/projects/endo/drafts/prospectus-2026-06.md` (frontmatter `status: draft-for-maintainer-triage`).

**Abstract.** The essay argues that agent sprawl has turned ambient authority into an acute, named enterprise anxiety documented in MCP's own security specification, that capability attenuation is the remedy with thirty years of technical proof (E, CapDesk, Polaris) and a working implementation, and that the two-stage plan (O1 turn-key self-custodial node to O2 community hub to ecosystem) converts a commons vision into independently shippable products whose commercial channel doubles as the federation bootstrap. It leads with the attenuation discipline and the Endo lineage as the moat, explicitly *not* MCP termination (which the essay concedes is commoditizing, per brief §2 Positioning), and grounds every status claim in the ledger: 39 of 135 designs Complete/Implemented, Milestones 1 and 2 closed, OCapN-Noise and bearer-token auth merged, the gateway stack In Progress (9 of 11 phases open as PRs, phases 10/11 pending), MCP termination design-written-but-Not-Started, and the four commercial-layer pieces named as design gaps. It closes on the funding-the-commons model stated honestly in both directions and notes plainly that computrons/cogitrons are metering units, not crypto assets (brief §2 Pricing legibility).

**Library sources cited:** `journal/library/sections/kriskowal-com--giants--overview.md` (the giants thesis, weblet/Familiar/user-agent vocabulary); `journal/library/sections/mcp-landscape--gateway-hosting-category.md` (MCP ambient-authority problem from the security spec, the 87k-star ecosystem scale, the Radosevich/Halloran arXiv:2504.03767 safety audit, the commoditization dynamic, named hosts Cloudflare/Sentry); `journal/library/sections/ocap-history--e-capdesk-polaris-market-history.md` (the thirty-year technical-success/market-failure pattern, the Polaris attenuation demonstration, and the three structural differences in the current moment). Project ledger `designs/README.md` @ `llm` tip 72d1c764c for every status claim.

**Canon discrepancies:** None that block the essay. One internal-consistency note: the ledger lists `endo-gateway-mcp` Status as **Not Started** in the Summary table while the M3 and M6-P1 prose say its design "merged today (PR #376)." These are consistent under the project's own status vocabulary (`designs/CLAUDE.md`: "Not Started" = design written, no implementation begun), so the essay reports the MCP termination layer as design-written-and-merged but implementation Not Started, which both readings support. No silent resolution was needed.

Self-improvement: filing a one-line lesson to liaison (below) about the em-dash byte-grep gotcha that nearly let four em-dashes through the style gate.
