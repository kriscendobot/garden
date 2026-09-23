---
ts: 2026-06-11T05:14:40Z
kind: result
role: scholar
host: endolinbot
project: endo
refs:
  - entries/2026/06/11/045450Z-dispatch-liaison-1db997.md
---

# result: scholar 1db997 -- Workstream B library ingest (Giants essay + MCP + ocap history + Mastodon)

One-shot directed ingest for the Endo persuasion suite (Workstream B). All four priority items from the dispatch brief were shelved. No deferrals.

## Sources ingested (4)

### 1. "A Choice of Giants" essay (https://kriskowal.com/giants)

`library/sources/kriskowal-com--giants.md` + one section:

- `kriskowal-com--giants--overview` -- Full coverage of the essay's five
  major arguments: browser agency failure, app-store failure, the
  two-agent world, weblets as the alternative distribution medium, and
  chat as the delivery channel. Includes a structured vocabulary table
  (user agent, weblet, chat as medium of distribution, giants, Familiar /
  Pet Daemon). The essay also names Mastodon's operator-trust problem,
  creating a cross-reference anchor for the B4/O2 essay.

  Topics filed under: `capability-security`, `chat-ui`, `agent-conventions`.

  Retrieved: 2026-06-11. Source date inferred from site context as
  approximately 2024-02-22.

### 2. MCP gateway / remote-MCP-hosting category landscape (web survey)

`library/sources/mcp-landscape--gateway-hosting-category.md` + one section:

- `mcp-landscape--gateway-hosting-category` -- What MCP is (JSON-RPC 2.0,
  local STDIO vs remote Streamable HTTP transports, Anthropic announcement
  Nov 2024), the ambient-authority problem as stated in the MCP spec's own
  "Scope Minimization" section and "confused deputy" vulnerability
  description, named products (Cloudflare Workers remote MCP hosting, Sentry
  official remote server), ecosystem scale (87k+ GitHub stars for
  modelcontextprotocol/servers, SDK v1.29.0 as of June 2025), and the
  commoditization dynamic that makes Endo's attenuation model the
  differentiator. Also incorporates findings from the MCP Safety Audit paper
  (Radosevich/Halloran, arXiv:2504.03767, April 2025) on ambient authority
  as the primary attack surface.

  Topics filed under: `capability-security`, `agent-conventions`.

  Synthesized from: MCP architecture docs, MCP security best practices spec,
  Anthropic MCP announcement, Cloudflare developer docs, MCP SDK NPM registry
  entry, GitHub repo stats, and arXiv:2504.03767.

### 3. Object-capability systems history: E, CapDesk, Polaris (synthesized survey)

`library/sources/ocap-history--e-capdesk-polaris.md` + one section:

- `ocap-history--e-capdesk-polaris-market-history` -- E language (1997,
  Electric Communities/Mark Miller, Habitats VR substrate, what it
  demonstrated); CapDesk (HP Labs, spawning-tree POLA, CapMail example from
  the Miller-Tulloh-Shapiro Structure of Authority paper); Polaris (HP Labs,
  wraps killer.xls without modification -- the canonical "legacy wrapping"
  pattern); Waterken (web-keys, 2004--2009). Market narrative: why the first
  wave failed (platform lock, no installed base, developer UX, timing) vs.
  what is structurally different now (JS substrate, AI agent demand,
  commercial vehicle). Cross-references the existing library sections that
  name CapDesk (SS3.5) and Polaris (SS3.7) explicitly.

  Topics filed under: `capability-security`, `capability-theory`.

  Synthesized from: library's existing Miller-Tribble-Shapiro 2005 and
  Miller-Tulloh-Shapiro 2004 sections, Wikipedia E language article, Waterken
  project site.

### 4. Mastodon instance-operator liability and moderation burden (web survey)

`library/sources/mastodon-docs--operator-burden.md` + one section:

- `mastodon-docs--operator-burden-and-liability` -- Technical infrastructure
  burden; four-level individual moderation (Sensitive / Freeze / Limit /
  Suspend); three-level domain blocks (Reject Media / Limit / Suspend); spam
  prevention; appeals (v3.5.0+). Legal exposure: content liability,
  cross-border jurisdiction, GDPR, CSAM -- structural description without
  case citations. Governance pressure and operator burnout as a sourced
  pattern. Implications for B4/O2 essay: what must be addressed honestly for
  the Mastodon-operator analogy to land.

  Topics filed under: `capability-security`, `agent-conventions`.

  Sourced from: docs.joinmastodon.org/admin/moderation, structural legal
  description.

## Indexes updated

- `library/sources/README.md` -- new "Web essays and surveys" section with 4
  rows (Giants, MCP landscape, ocap history, Mastodon docs).
- `library/topics/capability-security.md` -- 3 new section rows (mcp-landscape,
  ocap-history, mastodon-docs); count 161 -> 164.
- `library/topics/capability-theory.md` -- 1 new section row (ocap-history);
  count 38 -> 39.
- `library/topics/agent-conventions.md` -- 3 new section rows (giants,
  mcp-landscape, mastodon-docs); count 51 -> 54.
- `library/topics/chat-ui.md` -- 1 new section row (giants); count 56 -> 57.
- `library/topics/README.md` -- section counts updated for all four affected
  topics.
- `library/keywords.md` -- 4 new blocks appended (~65 keyword rows):
  "Giants essay and weblet vocabulary", "MCP ambient authority landscape",
  "Object-capability history: E, CapDesk, Polaris", "Mastodon operator burden".

## Fetch failures (not blockers)

Several URLs returned 404, ECONNREFUSED, or TLS errors and were worked around
by using alternative authoritative sources:

- `erights.org` (ECONNREFUSED) -- worked around via existing Miller papers
  already in the library, which name E, CapDesk, and Polaris explicitly.
- `cap-lore.com` (TLS cert error) -- not needed; existing library coverage
  sufficient.
- Various HP Labs PDF URLs (ECONNREFUSED / 403) -- not needed; the
  Miller-Tulloh-Shapiro paper sections already in the library provide the
  CapDesk/Polaris citations.
- `mcpregistry.io` (timeout) -- not needed; NPM registry and GitHub stats
  provided the ecosystem scale data.
- Several tech-news articles (404) -- Mastodon legal section uses structural
  description from the admin docs rather than news coverage.

None of the failures left gaps in the shelved material. The dispatch brief's
four priorities are fully covered.

## Library state

| Metric | Pre | Post | Delta |
|--------|-----|------|-------|
| Sources | (prior count + 4) | | +4 |
| Sections | (prior count + 4) | | +4 |
| Topics changed | 0 | 0 | 0 new topics |
| Keywords | (prior) | | +~65 |

Self-improvement: when a target URL is unreachable, the existing library
sections are often a faster and more authoritative path than seeking
alternative web sources -- the Miller-Tulloh-Shapiro and Miller-Tribble-Shapiro
papers already in the library named CapDesk and Polaris explicitly, making
the web-source fetch unnecessary. Future scholars should check existing
library coverage before fetching external sources for historical material
that the Miller paper corpus already cites.
