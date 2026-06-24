---
title: "The 2026-07-28 MCP Specification Release Candidate"
source-slug: mcp-blog--2026-07-28-release-candidate
url: https://blog.modelcontextprotocol.io/posts/2026-07-28-release-candidate/
authors: [David Soria Parra (Lead Maintainer), Den Delimarsky (Lead Maintainer)]
publication-date: 2026-05-21
spec-versions: [2025-11-25, 2026-07-28]
status: Release Candidate (RC locked 2026-05-21; final ships 2026-07-28; ten-week validation window)
ingest-cycle: 251
ingest-date: 2026-06-09
lane: papers
---

# The 2026-07-28 MCP Specification Release Candidate

Maintainers' blog post announcing the release candidate for MCP `2026-07-28`. The largest revision of the protocol since launch. RC locked 2026-05-21; final ships 2026-07-28; ten-week validation window for SDK maintainers.

**First papers-lane ingest after 144+ blocked cycles** — out-of-band maintainer request.

## Key design moves

- **§Five named deliverables** — stateless core + extensions (MCP Apps + Tasks) + authorization hardening + formal deprecation policy + many other changes.
- **§The headline change IS statelessness** — six SEPs work together to deliver it.
- **§Before-and-after code-block pair** with named version numbers (`2025-11-25` → `2026-07-28`).
- **§The practical effect on production IS the value statement** — three named things removed (sticky sessions + shared session store + deep packet inspection) + three named replacements (round-robin + Mcp-Method routing + ttlMs caching).
- **§Stateless protocol, stateful applications** — explicit-handle pattern; state visible to the model not hidden in transport metadata.
- **§Multi-Round-Trip Requests** (SEP-2322) — `InputRequiredResult` with opaque `requestState` echoed by client on retry.
- **§Mcp-Method and Mcp-Name headers** (SEP-2243) — routing-without-deep-packet-inspection.
- **§ttlMs and cacheScope** (SEP-2549) — cache-control shape as replacement for SSE polling.
- **§W3C Trace Context propagation** (SEP-414) — formalize existing key names (traceparent + tracestate + baggage).
- **§Extensions as first-class** (SEP-2133) — reverse-DNS IDs + Extensions Track in SEP process + delegated maintainers.
- **§MCP Apps** (SEP-1865) — server-rendered UI with three named defenses (sandbox + pre-declaration + uniform-back-channel).
- **§Tasks graduates to an extension** — named demotion from core.
- **§Authorization hardening** — six SEPs for OAuth/OpenID Connect alignment.
- **§Three core features deprecated** (Roots + Sampling + Logging) with per-feature named replacement.
- **§Twelve-month minimum** between deprecation and removal as named lifecycle policy.
- **§JSON Schema 2020-12** (SEP-2106) with named security constraints (no auto-deref + bound depth/time).
- **§Named breaking change** with named affected consumer pattern (`-32002` → `-32602`).
- **§The breaking change IS the foundation for non-breaking future changes** as named governance rhetoric.
- **§Conformance suite as gating mechanism** for Final status (SEP-2484).
- **§SEP numbering as traceable history** — twenty named SEPs referenced.

## Section files

- [§stateless-protocol-core + §Extensions-framework + §MCP-Apps + §Tasks-graduates-to-extension + §feature-lifecycle-policy-with-12-month-minimum](../sections/mcp-blog--2026-07-28-release-candidate--stateless-protocol-core-and-Extensions-framework-and-MCP-Apps-and-Tasks-graduates-to-extension-and-feature-lifecycle-policy-with-12-month-minimum.md) — full blog-post ingest.

## Ingest scope

Cycle 251 (papers-lane, out-of-band): full blog-post ingest at maintainer request. §First-direct-ingest from `blog.modelcontextprotocol.io`. §First-protocol-spec-blog-post ingested. §First-non-Endo-source since the long Endo cluster began. §First-explicit-observation of nineteen patterns (see section file Tier-1 list).
