---
title: Milestones M0–M6 (goals + exit criteria + per-milestone status)
source: designs/README.md
source_repo: endojs/endo-but-for-bots
source_branch: llm
source_commit: 510630411ebc26a6d9327928b4d71e5155802ea4
source_date: 2026-05-09
source_authors: [Kris Kowal]
ingested: 2026-05-14
ingested_by: scholar
topics: [repository-governance]
status: current
notes: The 7-milestone structure is the canonical roadmap. M0 is Complete; M1 is in progress (12 remaining of ~15 originally); M2 (networking) is the next critical-path milestone after M1. The "strategic early items" within M1 (endoclaw-timer + endoclaw-network-fetch) are pulled forward because they're foundational capabilities, not features.
---

> Abstract: Seven milestones tracking the corpus toward the long-term plan. **M0: Downloadable AI Agent Experience** — Complete (Feb 15 – Mar 5, 18 active work days, 7 designs). Goal: a Familiar application downloadable on at least one platform. **M1: Remote Access and Coding Capabilities** — In progress; 12 designs remaining. Goal: self-host with Docker, remote control via local Familiar or hosted Chat with bearer token, claw-like coding capabilities. **M2: Networking** — Not started; 7 designs (ocapn-network-transport-separation, ocapn-tcp-for-test-extraction, ocapn-tcp-syrups-framing, syrups [Deprecated], cbors, ocapn-noise-cryptographic-review, daemon-agent-network-identity, ocapn-noise-network). Goal: secure peer connections over OCapN-Noise; locator format finalized. **M3: Weblets and Integrations** — 9 designs. Goal: weblet hosting in Familiar + Daemon; OAuth-based external service integrations; proactive agent behavior; webhooks. **M4: UX Polish and Agent Tooling** — 12 designs. **M5: Capability Confinement and Ecosystem** — 6 active (1 superseded). **M6: Rust Daemon (`endor`)** — 2 designs; research-heavy. Strategic Early Items pull `endoclaw-timer` and `endoclaw-network-fetch` from later milestones into M1 because they're foundational capabilities (SES removes setTimeout; agents need scheduled execution + outbound HTTP).

### Milestones

The README defines seven milestones (M0 through M6). Each has a goal, a per-milestone table of designs (with current status and notes), and an exit criterion. Library does not mirror the full per-milestone design tables (they evolve faster than the library cycles). Summary:

| # | Milestone | Goal | Status |
|---|-----------|------|--------|
| M0 | Downloadable AI Agent Experience | A Familiar application suitable for use on at least one platform that folks can download and interact with an agent using their own API key and local capabilities. | **Complete** (Feb 15 – Mar 5; 18 active work days; 7 designs) |
| M1 | Remote Access and Coding Capabilities | Self-host with Docker; remote control via local Familiar or hosted Chat with bearer token; claw-like coding capabilities for agents. | In Progress (12 remaining) |
| M2 | Networking | Secure peer connections via OCapN-Noise; locator format finalized. | Not Started (7 designs) |
| M3 | Weblets and Integrations | Weblet hosting in Familiar/daemon; OAuth integrations; proactive behavior; webhooks. | Not Started (9 designs) |
| M4 | UX Polish and Agent Tooling | (UX completeness) | Not Started (12 designs) |
| M5 | Capability Confinement and Ecosystem | (cap-discipline + ecosystem) | Not Started (6 active, 1 superseded) |
| M6 | Rust Daemon (`endor`) | (research-heavy Rust daemon) | Not Started (2 designs) |

**Strategic Early Items**: `endoclaw-timer` and `endoclaw-network-fetch` are surfaced in M1 (rather than later) because they are foundational rather than features: SES lockdown removes `setTimeout`/`setInterval` so Timer is the *only* mechanism for scheduled agent execution; HttpClient with origin allowlist is the minimal network capability that OAuth + channel bridges + all integrations depend on.

For the full per-milestone design tables (with current status per design), consult the upstream README.

Source: [designs/README.md](https://github.com/endojs/endo-but-for-bots/blob/510630411ebc26a6d9327928b4d71e5155802ea4/designs/README.md) at commit `51063041` on branch `llm`.
