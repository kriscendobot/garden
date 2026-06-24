---
ts: 2026-05-22T20:31:43Z
kind: dispatch
role: liaison
project: endo-but-for-bots
to: designer
---

# Dispatch: designer proposes a Daemon/Familiar plugin for pinchtab.com; compare/contrast with `endoclaw-browser` Playwright plugin; design coherent Exo interfaces

Dispatch root: `dispatches/designer--8e9c43/`. Project worktree on `endojs/endo-but-for-bots@llm` (head `68246ad92`).

## Maintainer directive (verbatim)

> Please dispatch a designer to propose a Daemon/Familiar plugin for https://pinchtab.com/ and compare and contrast with the existing proposal for a Playwright based remote browser control. We should pursue both and also ensure that they are coherent Exo interfaces to the extent that is possible.

## Existing Playwright-based design

`designs/endoclaw-browser.md` (Status `Not Started`, Parent `endoclaw.md`) carries the existing Playwright remote-browser-control proposal. It defines a `Browser` capability with `goto(url) → Page`, and a `Page` capability with `url`, `title`, `textContent`, `querySelector(All)`, `fill`, `click`, `submit`, `snapshot`, `waitForSelector`, `help`. The host controls allowed domains; the agent navigates, extracts, fills forms, takes snapshots within scope. It is part of the **endoclaw** family of agent-facing capabilities (see `designs/endoclaw.md` for the parent narrative).

## pinchtab.com

The designer should **WebFetch `https://pinchtab.com/`** to read pinchtab's positioning, integration shape (API? extension? hosted browser?), capability surface, and pricing/auth model. The maintainer's framing ("a Daemon/Familiar plugin for pinchtab.com") suggests a hosted-third-party browser-control service the Familiar (or daemon) integrates with via API — pinchtab gives an agent a controlled browsing context the way Playwright gives the agent a Chromium-controlled context.

The designer should also WebFetch any pinchtab API documentation, pricing, and quickstart pages reachable from the landing page. **Do not speculate** about pinchtab's surface — read what the site says and design from there. If pinchtab's site does not publish an API, surface that as the load-bearing open question and design the *shape* of the plugin assuming a typical hosted-browser-control API (CDP-over-WebSocket, REST + tokens, etc.) with the actual integration deferred until pinchtab's API is documented.

## Task

Produce **one design document** at `designs/<slug>.md` covering both the pinchtab plugin proposal and the coherent-Exo-interfaces analysis with `endoclaw-browser`. Suggested slug: **`endoclaw-pinchtab.md`** (sibling of `endoclaw-browser.md` under the endoclaw family) — designer picks the final name. If the coherent-interface analysis grows beyond a few paragraphs and becomes its own structural argument, split into two siblings: `endoclaw-pinchtab.md` (the plugin proposal) + `endoclaw-browser-pinchtab-coherence.md` (the interface-unification analysis); designer's call.

### Sections, in `project/designs/CLAUDE.md` order

1. **Metadata table** — Status `Not Started` (matching `endoclaw-browser.md`'s shape); Parent `endoclaw`.
2. **Summary** — one paragraph naming pinchtab, the plugin's purpose, and the coherence ambition with `endoclaw-browser`.
3. **What is the problem being solved?** Cite the maintainer directive. Name why both pinchtab and Playwright belong in the corpus rather than one obviating the other: pinchtab plausibly offers a *hosted* browsing context (no Chromium on the Familiar's machine; sessions persisted across Familiar restarts; possibly residential / mobile IP rotation; possibly stealth / fingerprint normalization), where the Playwright capability offers a *local* browsing context (lower latency; no third-party dependency; full Chrome capabilities; under the user's own network identity). Different cost / latency / privacy / trust profiles; agents pick per task.
4. **pinchtab capability shape** — the `Browser` and `Page` interfaces the plugin exposes, modeled after `endoclaw-browser.md`'s shapes. Differences between pinchtab and Playwright at the interface layer are minimized; differences in *underlying execution* are folded into options or configuration rather than into the surface.
5. **Coherent Exo interfaces — the unification analysis.** The load-bearing section. Compare and contrast methodically:
   - Where the surfaces align naturally (the basic browsing primitives — navigate, click, fill, extract).
   - Where they diverge (session persistence across plugin restarts? remote-only features like residential IPs? local-only features like extensions / file uploads from disk?).
   - Where the divergence can be reconciled by making the difference an *option* rather than a *type* (e.g., `Browser.openSession({ residentialIp: true })` is meaningful only for pinchtab; on the Playwright backend it is silently ignored or errors with a documented signal).
   - Where divergence cannot be reconciled — name those as separate methods on a per-backend extension interface, not on the common one.
   - The recommended split: a base `Browser` Exo interface that both `endoclaw-browser` (Playwright) and `endoclaw-pinchtab` (pinchtab) implement; per-backend extensions for the unreconcilable features.
   - State whether to revise `endoclaw-browser.md`'s capability shape to match the unified base. Recommend "yes, in a follow-up PR" if the existing shape is close enough to the unified base; recommend "no, the unified base is the new spec and `endoclaw-browser`'s shape will be deprecated" if the existing shape diverges too far. This is a design decision the designer makes with rationale.
6. **Plugin shape (Daemon-side or Familiar-side?)** — does the plugin live in the Daemon (as a CapTP-reachable Exo, like other endoclaw capabilities), or in the Familiar (as an Electron-side integration that exposes the result over CapTP back to the Daemon)? The maintainer wrote "Daemon/Familiar plugin," which is ambiguous. Inspect prior endoclaw designs to see the convention (probably Daemon-side, with the Familiar surfacing UI affordances for capability grant/revoke), and pick.
7. **Authentication and quota.** pinchtab presumably requires an API key. Where does it live (a `secrets` Exo on the host? a per-user envvar? the Familiar's gateway-bearer-token-auth shape?), who can grant it, what the rate-limit / quota story looks like, how the plugin surfaces quota exhaustion to the agent.
8. **Trust boundaries.** pinchtab is third-party. The plugin is sending the agent's URLs, headers, and possibly form data to pinchtab's servers. The design names: what the agent can leak via pinchtab (URLs, scraping content), what pinchtab can leak from the agent (browsing patterns, cookies the agent sets via pinchtab on user-recognizable accounts). Trust posture relative to Playwright (which leaks no third party).
9. **Dependencies table.** `endoclaw.md` (parent), `endoclaw-browser.md` (sibling — the coherent-interface counterpart), `lal-fae-form-provisioning.md` (for the API-key-grant UI shape), any `daemon-capability-bus.md` or `daemon-capability-bank.md` references for how the capability is registered and granted.
10. **Phased implementation.** Phase 1 — define and land the unified base `Browser` Exo interface (probably a few-hours edit to `endoclaw-browser.md` once the new design's coherence section settles it). Phase 2 — implement `endoclaw-pinchtab` against the unified base. Phase 3 — wire grant / revoke UI in the Familiar. Phase 4 — `endoclaw-browser` (Playwright) implementation against the unified base.
11. **Design decisions** with rationale — the per-backend-extension split, the daemon-vs-familiar placement, the authentication model, the unified-base-revises-endoclaw-browser question.
12. **Open questions** — most importantly, the pinchtab API surface itself (until WebFetch confirms what pinchtab exposes, the plugin's API contract is provisional). Plus: cost ceiling per agent? quota-exhaustion behavior (silent degrade vs. throw)? pinchtab's TOS regarding automated use? data-residency / privacy regime alignment with the user's jurisdiction?
13. **Prompt** — capture the maintainer's verbatim directive under `## Prompt` per `designs/CLAUDE.md`.

## Procedure

1. Read `garden/roles/COMMON.md`, then `garden/roles/designer/AGENT.md`.
2. Read `garden/skills/library-lookup/SKILL.md`. Index pinchtab as a new domain term in the library on the fly.
3. Read `garden/skills/em-dash-style/SKILL.md`, `garden/skills/relative-paths/SKILL.md`, `garden/skills/prompt-section-discovery/SKILL.md`.
4. Read `project/designs/CLAUDE.md` and `project/designs/README.md`.
5. Read **the sibling design**: `project/designs/endoclaw-browser.md`. This is the comparator.
6. Read **the parent narrative**: `project/designs/endoclaw.md`. The endoclaw family establishes the capability-shape conventions and the grant/revoke model.
7. Read **adjacent designs**: `project/designs/lal-fae-form-provisioning.md` (for the API-key-grant UI shape), `project/designs/daemon-capability-bank.md` and `project/designs/daemon-capability-bus.md` (for capability registration / grant), `project/designs/endoclaw-network-fetch.md` and `project/designs/endoclaw-oauth.md` (sibling endoclaw capabilities; the OAuth shape is especially relevant for the auth model).
8. **WebFetch `https://pinchtab.com/`** and follow links to API documentation / pricing / quickstart. Take notes on:
   - Pinchtab's positioning ("hosted browser for agents"? "scraping API"? "form-filling SaaS"?).
   - The wire protocol (REST? gRPC? CDP-over-WebSocket?).
   - The capability surface (browse, click, fill, screenshot, downloads, file uploads, session persistence, residential IPs, stealth mode).
   - Pricing model (per-session, per-page-view, per-minute, per-GB-bandwidth).
   - Auth (API key, OAuth, JWT).
   - Limits (rate, concurrency, session length).
   - Terms of service relevant to automated use.
   - **If pinchtab's site is sparse on API details**, note the gap explicitly in the design's *Open questions* section. Do not speculate beyond what the site documents.
9. Draft the design (or pair) per the section list above.
10. Sync `project/designs/README.md`: new row(s), milestone assignment (the endoclaw family probably lives in a particular milestone — match it), dependency-graph edges to `endoclaw-browser.md` + `endoclaw.md`, size estimate.
11. Open as DRAFT PR against `endojs/endo-but-for-bots@llm`. Branch: `design/endoclaw-pinchtab` (or your final slug). Title: `design(endoclaw): pinchtab plugin with coherent Exo interface alignment to endoclaw-browser`. Body cites the maintainer directive, names `endoclaw-browser.md` as the sibling, flags the WebFetch findings on pinchtab's actual API, and surfaces the unified-base-Browser-Exo proposal.

## Per-action authorization

Standing on `endojs/endo-but-for-bots`: push to your `design/<slug>` branch, open draft PR against `llm`. **WebFetch on `https://pinchtab.com/` and reachable doc subpages is authorized** as the load-bearing research step. No comment authority outside the new PR's body. READ-ONLY on `endojs/endo`.

## Out of scope

- No implementation.
- No edits to `endoclaw-browser.md` directly (the design *proposes* a revision; the actual edit is a separate follow-up PR).
- No upstream ferry.
- No un-draft.

## Report

≤ 600 words. PR URL + head SHA. Design file path(s) on llm. The pinchtab API findings from WebFetch (3-5 bullet summary: positioning, wire protocol, capability surface, auth, pricing, TOS notes). The unified-base-Browser-Exo proposal (the methods on the base + the per-backend extensions). The daemon-vs-familiar placement decision. The endoclaw-browser revision recommendation. Open questions surfaced. One-line `Self-improvement: ...`. Write the result as `journal/entries/2026/05/22/<HHMMSSZ>-result-designer-8e9c43.md` and push journal (rebase if non-fast-forward).
