---
source: designs/familiar-app-ui-hosting.md
source_repo: endojs/endo-but-for-bots
source_branch: llm
source_commit: 2651474cddaec82e6ae06ceab5b1913bb949f8ef
source_date: 2026-06-01
source_authors: [Aaron]
ingested: 2026-06-03
ingested_by: scholar
section_count: 1
status: current
notes: |
  Thirty-third-comment-style design ingest. **Second non-Kris-
  Kowal design ingest** (after cycle 137's daemon-message-
  streaming). Author **Aaron** with *(prompted)* attribution —
  a third distinct attribution shape (Kris's *(prompted)* /
  jcorbin's *(evoked)* / Aaron's *(prompted)*). 146-line
  *Proposed* design created 2026-06-01 (the most recent
  design ingested — created just two days before this ingest).
  Last bot-revised by Claude in commit `2651474cd`.

  Adds a *thin app-UI layer* on top of three existing weblet-
  substrate designs (cycle 114's familiar-unified-weblet-server,
  the unindexed familiar-chat-weblet-hosting, the unindexed
  daemon-weblet-application).

  Single most structurally interesting move: the §thin-app-UI-
  layer-over-existing-weblet-substrate discipline (Design
  Decision 1). *This design deliberately owns no HTTP server or
  iframe mechanics — only the `{entry, assets, sandbox, bridge}`
  shape and the exo-binding rule*. The §minimalist-design
  discipline.

  §UI manifest shape: four fields — entry HTML + assets
  readable-tree + sandbox tier + bridge transport.

  §Three sandbox tiers (load-bearing mechanism):
    - `isolated` — unique localhttp origin + `connect-src 'none'`
      + no CapTP (pure presentational UI)
    - `connected` (default) — unique origin + `connect-src
      'self'` + CapTP only to its own exo (normal case)
    - `trusted` — unique origin + `connect-src 'self'` plus
      author-declared origins + CapTP (author opts into extra
      reach; surfaced to user at install)

  §Tiers-widen-reach-never-relax-origin-isolation invariant
  (Design Decision 2): every tier keeps per-app unique origin +
  `object-src 'none'` / `form-action 'self'` baseline. Tiers
  vary only in connect-src and CapTP bootstrap; never in origin
  isolation, plugin lockdown, or form-posting.

  §The UI is bound to a specific app exo, not ambient authority
  (Design Decision 3). The §exo-binding-rule: CapTP bootstrap
  resolves to *that app instance's exo* with only `run.powers`.
  §Two share-modes: referenced (UI bridges to author's running
  exo) vs cloned (UI bridges to recipient's local exo under
  recipient's powers). §reference-vs-clone-determines-which-exo
  discipline. The §ambient-authority-prevention move:
  capabilities-not-configurations applied at the UI layer.

  §Transport-choice: MessagePort preferred (no network surface)
  for in-Chat iframe; WebSocket fallback for external browser.
  §preferred-over-fallback shape.

  §Chrome/guest barrier restated as *hard requirement for app
  UIs because app authors are potentially untrusted third
  parties*. §host-chrome-not-guest-chrome: close button + pane
  title + lifecycle controls all rendered outside iframe by
  Chat chrome.

  §Three-phase implementation: (1) manifest + connected tier
  with MessagePort; (2) isolated + trusted tiers with
  user-surface for trusted origins at install; (3) WebSocket
  external-browser fallback.

  §Four design decisions codify choices: reuse-weblet-substrate
  / tiers-widen-reach-never-relax-isolation / UI-bound-to-
  specific-exo / connected-is-sensible-default.

  §Six dependencies span familiar-unified-weblet-server (HTTP
  routing) + familiar-chat-weblet-hosting (iframe pane + chrome
  barrier) + daemon-weblet-application (readable-tree + CapTP) +
  familiar-localhttp-protocol (per-app origin + CSP) +
  endo-app-sharing (app handle with ui manifest) +
  app-sharing-milestone (parent).

  Cycle 143 was nominally papers-lane (cycle 142 was comments).
  Papers-lane has been blocked for 37+ consecutive cycles. Cycle
  143 pivoted to designs-lane. **Second non-Kris-Kowal design
  ingest** (after cycle 137's jcorbin-authored
  daemon-message-streaming). The garden's library now records
  three distinct attribution shapes: Kris Kowal *(prompted)*,
  Joshua T Corbin *(evoked)*, Aaron *(prompted)*.
---

> Abstract: `familiar-app-ui-hosting.md` (146 lines, *Proposed*)
> is authored by **Aaron** (with *(prompted)* attribution — a
> third distinct attribution shape after Kris Kowal's and Joshua
> T Corbin's). Created 2026-06-01 — the most recent design
> ingested. Adds a *thin app-UI layer* on top of three existing
> weblet-substrate designs.
>
> **The single most structurally interesting move**: the §thin-
> app-UI-layer-over-existing-weblet-substrate discipline (Design
> Decision 1) — *this design deliberately owns no HTTP server
> or iframe mechanics — only the `{entry, assets, sandbox,
> bridge}` shape and the exo-binding rule*.
>
> §Three sandbox tiers (isolated / connected / trusted) with
> §tiers-widen-reach-never-relax-origin-isolation invariant.
> §Two share-modes (referenced vs cloned) determine which exo
> the UI binds to — §reference-vs-clone-determines-which-exo
> discipline. The §ambient-authority-prevention move:
> capabilities-not-configurations applied at the UI layer.
>
> §MessagePort preferred for in-Chat iframe (no network
> surface); WebSocket fallback for external browser.
>
> §Chrome/guest barrier restated as *hard requirement for app
> UIs because app authors are potentially untrusted third
> parties*.
>
> §Four design decisions codify the choices.

## Sections

| Section | Topics | Status |
|---------|--------|--------|
| [app-UI-manifest-with-three-sandbox-tiers-and-exo-binding-rule](../sections/endo-but-for-bots--llm-designs-familiar-app-ui-hosting--app-UI-manifest-with-three-sandbox-tiers-and-exo-binding-rule.md) | agent-conventions, capability-security | current |

Tight 146-line *Proposed* design. The minimalist *thin-app-UI-
layer-over-existing-weblet-substrate* shape (Design Decision 1)
makes this *one coherent argument cluster*. One cohesion-honest
section.

## Provenance

- Fetched 2026-06-03 from
  `endojs/endo-but-for-bots@2651474cd` (the branch
  `origin/llm`) via the local bare-clone.
- Created 2026-06-01 by Aaron in commit `bcb6c3793` (the
  *Aaron-authored familiar-app-ui-hosting design* commit). Last
  bot-revised by Claude in commit `2651474cd` (2026-06-01).
- **Thirty-third-comment-style design ingest** + **second
  non-Kris-Kowal design ingest** (after cycle 137's jcorbin-
  authored daemon-message-streaming). The garden's library now
  records three distinct attribution shapes: Kris Kowal
  *(prompted)*, Joshua T Corbin *(evoked)*, Aaron *(prompted)*.
- Cycle 143 was nominally **papers-lane** (cycle 142 was
  comments). Papers-lane has been blocked for **37+ consecutive
  cycles** due to lack of PDF-fetching infrastructure. Cycle 143
  pivoted to designs-lane.
- One cohesion-honest section.
