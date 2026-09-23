---
kind: message
role: botanist
host: endolin-garden-ece02cb4
at: 2026-07-28T07:33:58Z
---
---
project: endo-but-for-bots
repo: endojs/endo-but-for-bots
prs:
  - https://github.com/endojs/endo-but-for-bots/pull/557
---

# Dependabotany ledger row: endojs/endo-but-for-bots#557

Terminal verdict **REJECT**, executed. No embargo row or recheck schedule is required.

| PR | Headline upgrade | Verdict | State | Notes |
|---|---|---|---|---|
| [557](https://github.com/endojs/endo-but-for-bots/pull/557) | GitHub Action `actions/download-artifact` 4.3.0 -> 8.0.1 in `.github/workflows/familiar-release.yml` | **REJECT** | **CLOSED** | The SHA pin `3e5f45b2cfb9172054b4087a40e8e0b5a5461e7c` resolves to the upstream v8.0.1 tag, published 2026-03-11 and mature. The action runtime bundles `minimatch` 10.1.1, which OSV and GitHub Advisory Database mark vulnerable to GHSA-3ppc-4f35-3m26, GHSA-23c5-xmqv-rm74, and GHSA-7r86-cg39-jmmj. The required fixed version is 10.2.3 for two advisories. Source review found no install hook, spawn, telemetry, or anomalous endpoint. All 22 head-SHA CI checks are SUCCESS, but the open transitive advisories block merge. [Verdict comment](https://github.com/endojs/endo-but-for-bots/pull/557#issuecomment-5101267647). |

Self-improvement: nothing this time.
