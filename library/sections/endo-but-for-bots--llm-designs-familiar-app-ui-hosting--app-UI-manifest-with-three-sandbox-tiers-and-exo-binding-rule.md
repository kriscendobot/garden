---
section: app-UI-manifest-with-three-sandbox-tiers-and-exo-binding-rule
source: endo-but-for-bots--llm-designs-familiar-app-ui-hosting
topics: [agent-conventions, capability-security]
status: current
---

# App UI manifest with three sandbox tiers and exo-binding rule

> *Reuse the weblet substrate; add only an app-facing manifest.
> This design deliberately owns no HTTP server or iframe
> mechanics — only the `{ entry, assets, sandbox, bridge }`
> shape and the exo-binding rule.*
>
> — `designs/familiar-app-ui-hosting.md` §Design Decisions

`familiar-app-ui-hosting.md` (146 lines, *Proposed* status,
created 2026-06-01) is authored by Aaron (with *(prompted)*
attribution — a third distinct attribution shape after Kris
Kowal's and Joshua T Corbin's). The design adds a **thin
app-UI layer** on top of three existing weblet-substrate
designs (cycle 114's `familiar-unified-weblet-server`, the
unindexed `familiar-chat-weblet-hosting`, and `daemon-weblet-
application`).

## The §reuse-the-weblet-substrate discipline

The §Design Decision 1 is the design's *minimalist promise*:

> *This design deliberately owns no HTTP server or iframe
> mechanics — only the `{ entry, assets, sandbox, bridge }`
> shape and the exo-binding rule.*

The §thin-app-UI-layer-over-existing-weblet-substrate
discipline. Three existing designs provide the substrate:

- **`familiar-unified-weblet-server`** (cycle 114) — one HTTP
  server that routes by virtual host to weblet handlers
- **`familiar-chat-weblet-hosting`** (unindexed) — embedding
  a weblet as an iframe pane inside Chat with a chrome/guest
  barrier
- **`daemon-weblet-application`** (unindexed) — serving a
  `readable-tree` of static files plus a powers reference
  over CapTP

This design adds *only*:

1. A **UI manifest** on the app handle (entry HTML + assets
   tree + sandbox tier + bridge transport)
2. A small **sandbox-level policy** (the three tiers)
3. The **CapTP wiring** binding the UI back to *that app's*
   exo (not ambient daemon authority)

The §minimalist-design discipline: *defers all core hosting
mechanics to the three documents above*.

## The §UI manifest shape

The `ui` field on an app handle:

```
ui: {
  entry:   'index.html',                 // path within the assets tree
  assets:  <readable-tree>,              // static files to serve
  sandbox: 'isolated' | 'connected' | 'trusted',
  bridge:  'message-port' | 'web-socket',// CapTP transport to the app exo
}
```

Four fields: *what HTML to serve as the entry point* + *which
files to make available* + *which sandbox tier to use* +
*which transport to use for the back-channel*.

## The §three sandbox tiers

The §Sandbox tiers table is the design's *load-bearing
mechanism*:

| Tier | Origin | CSP `connect-src` | CapTP to app exo | Use |
|------|--------|--------------------|--------------------|-----|
| `isolated` | unique `localhttp://<id>` | `'none'` | no | Pure presentational UI; no back-channel |
| `connected` (default) | unique `localhttp://<id>` | `'self'` | yes, **only** to its own exo | The normal case |
| `trusted` | unique `localhttp://<id>` | `'self'` + author-declared origins | yes | Author opts into extra reach |

The §tiers-widen-reach-never-relax-origin-isolation invariant
(Design Decision 2):

> *Every tier keeps the per-app unique origin and the
> `object-src 'none'` / `form-action 'self'` baseline from the
> existing protocol handler. Tiers only widen `connect-src` and
> whether a CapTP bootstrap is granted — they never relax origin
> isolation.*

The §two-axes-the-tiers-vary-along discipline: tiers differ in
*connect-src* (network reach) and *CapTP bootstrap* (back-
channel to exo); they don't differ in *origin isolation*
(unique localhttp per app), *plugin lockdown* (no plugins),
or *form posting* (only to self).

## The single most structurally interesting move — §the UI is
bound to a specific app exo

§Design Decision 3:

> *The UI is bound to a specific app exo, not ambient authority.
> Whether referenced or cloned, the UI can only reach the
> instance and powers the app was run with.*

The §exo-binding-rule:

> *The CapTP bootstrap handed to a `connected`/`trusted` UI
> resolves to **that app instance's exo**, carrying only the
> powers the app was run with (`run.powers` from the app
> handle).*

The §two share-modes:

- **Referenced**: a referenced app's UI bridges back to *the
  author's running exo*.
- **Cloned**: a cloned app's UI bridges to *the recipient's
  local exo*, under the *recipient's powers*.

The §reference-vs-clone-determines-which-exo discipline. The
*same UI code* can be hosted under different share-modes; the
exo binding determines what it can do. The
§capabilities-not-configurations discipline (cycle 105's
canonical principle) applied at the UI layer.

This is the §ambient-authority-prevention move: the UI gets a
*specific* exo's powers, never *all daemon authority*. Even a
malicious UI is bounded to the powers the app was provisioned
with.

## The §transport-choice — MessagePort preferred, WebSocket
fallback

The §Transport paragraph:

> *Transport is `MessagePort` for the in-Chat iframe (preferred,
> no network surface) with a `web-socket` fallback for an
> external browser.*

The §MessagePort-over-WebSocket-when-possible discipline:

- **MessagePort** — no network surface at all; bytes never
  leave the user's process. Used when the UI is hosted inside
  Chat's Electron renderer (cycle 109's familiar-electron-shell
  provides the substrate).
- **WebSocket** — fallback for *external browser* (when the
  user opens the app's URL in a separate browser window).
  Bytes cross localhost; the WebSocket terminates at the
  daemon's gateway (cycle 111's familiar-gateway-migration).

The §preferred-over-fallback shape lets the design *use the
cheapest secure transport* when available without preventing
external-browser use.

## The §chrome/guest barrier — *hard requirement for app UIs*

The §chrome/guest barrier paragraph:

> *The host chrome (pane frame, close button, app title) lives
> outside the iframe; the app's UI lives inside it. Controls
> that act on the app's lifecycle are never rendered by the
> guest. This is the same barrier described in
> [familiar-chat-weblet-hosting](familiar-chat-weblet-hosting.md),
> restated here as a hard requirement for app UIs because app
> authors are potentially untrusted third parties.*

The §host-chrome-not-guest-chrome discipline: *close button*,
*pane title*, *app-lifecycle controls* — all rendered by Chat's
chrome, *outside* the iframe. The guest cannot draw a fake
close button or hide the real one.

The §restated-here-as-hard-requirement clause: the same
discipline already in `familiar-chat-weblet-hosting`; this
design *re-emphasizes* it for the app-UI case because *app
authors are potentially untrusted third parties* (vs Chat's
plugins which might be considered first-party).

## The §three-phase implementation plan

The §Phased Implementation section breaks the work into three
phases:

1. **Manifest + `connected` tier** — serve `assets` at unique
   origin; bootstrap CapTP to app's exo over MessagePort
   inside Chat iframe pane. *Depends on unified-server and
   chat-weblet-hosting integration points landing.*
2. **Tiers `isolated` and `trusted`** — add no-bridge and
   author-allowlisted-origin tiers; *surface trusted origins to
   the user at install/open time*.
3. **External-browser path** — WebSocket fallback for opening
   an app UI outside Familiar.

The §user-surface-trusted-origins discipline (Phase 2): when
an app declares `trusted` tier with extra origins, the user
sees those origins *at install time*. The §inform-the-user-of-
extra-reach pattern.

## The §existing-vs-gap inventory

The §Background table catalogs what already exists vs what's
missing:

**Complete:**
- `localhttp://<weblet-id>/` privileged scheme with per-app
  origin isolation (cycle 109's `familiar-electron-shell`)
- CSP injection per response (`connect-src 'self'`, `object-src
  'none'`, `frame-src 'self'`, ...)
- Navigation guards / exfiltration defenses

**In Progress / Not Started:**
- Unified weblet server routing (cycle 114)
- Chat iframe weblet pane (unindexed)
- Serve `readable-tree` files + powers over CapTP (unindexed)

The §strong-parts-already-ship discipline: per-app origin
isolation and CSP are *already in production* (cycle 109's
electron-shell shipped them). The *gap* is the app-facing
manifest + sandbox tiers + exo-binding.

## §Four design decisions codify the choices

The §Design Decisions section names four:

1. **Reuse the weblet substrate; add only an app-facing
   manifest** — the minimalist discipline.
2. **Tiers widen reach, never relax origin isolation** — the
   §invariant-across-tiers discipline.
3. **The UI is bound to a specific app exo, not ambient
   authority** — the §capability-not-configuration discipline
   (cycle 105's principle).
4. **`connected` is the sensible default** — *most app UIs need
   exactly one thing: a confined back-channel to their own
   capability*.

## Related sections

- cycle 109
  [[endo-but-for-bots--llm-designs-familiar-electron-shell--electron-shell-with-daemon-outlives-app-and-localhttp-protocol]]
  — provides the `localhttp://` protocol + per-app origin
  isolation + CSP injection this design's tiers build on.
- cycle 114
  [[endo-but-for-bots--llm-designs-familiar-unified-weblet-server--unified-weblet-server-with-host-header-routing-and-two-mode-split-for-Familiar-vs-Chat]]
  — provides the virtual-host HTTP routing this design's UI
  hosting serves over.
- cycle 105
  [[endo-but-for-bots--llm-designs-daemon-capability-bank--shared-capabilities-as-a-meta-design-with-six-design-principles]]
  — the *Capabilities are objects, not configurations*
  Design Principle 1 this design's §exo-binding-rule
  embodies for app UIs.
- cycle 107
  [[endo-but-for-bots--llm-designs-daemon-agent-tools--dir-shell-and-git-as-claw-like-agent-capabilities]]
  — the *capability-driven dynamic tool registration*
  discipline that pairs with this design's
  *connected*-tier-bridges-to-specific-exo discipline.
- cycle 137
  [[endo-but-for-bots--llm-designs-daemon-message-streaming--streamReply-and-streamSend-with-stream-formula-and-CapTP-rides-method-calls]]
  — sibling *non-Kris-Kowal author* design (Joshua T Corbin's
  *(evoked)* vs this design's Aaron's *(prompted)*; the bot-
  identity broadens beyond a single contributor).
