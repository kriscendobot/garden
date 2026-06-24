---
ts: 2026-06-03T06:27:11Z
host: endolin
role: liaison
kind: result
dispatch_id: liaison--0beee8
cycle: 143
---

# Cycle 143 — familiar-app-ui-hosting.md (Aaron, endo-but-for-bots) — second non-Kris-Kowal design

Ingested `designs/familiar-app-ui-hosting.md` (146 lines,
*Proposed* status, created 2026-06-01) from
`endojs/endo-but-for-bots@2651474cd` (branch `origin/llm`).
**Thirty-third-comment-style design ingest** + **second
non-Kris-Kowal design ingest** (after cycle 137's
jcorbin-authored daemon-message-streaming). Author **Aaron**
with *(prompted)* attribution — a *third distinct attribution
shape*. One cohesion-honest section:

- **app-UI-manifest-with-three-sandbox-tiers-and-exo-binding-
  rule** — adds a *thin app-UI layer* on top of three existing
  weblet-substrate designs (cycle 114's
  familiar-unified-weblet-server, unindexed familiar-chat-
  weblet-hosting, unindexed daemon-weblet-application).

## The single most structurally interesting move

§Design Decision 1: *Reuse the weblet substrate; add only an
app-facing manifest*. *This design deliberately owns no HTTP
server or iframe mechanics — only the `{entry, assets, sandbox,
bridge}` shape and the exo-binding rule*. The §thin-app-UI-
layer-over-existing-weblet-substrate discipline.

## §Three sandbox tiers

- **isolated** — unique origin + `connect-src 'none'` + no
  CapTP (pure presentational UI)
- **connected** (default) — unique origin + `connect-src 'self'`
  + CapTP only to own exo
- **trusted** — unique origin + author-declared origins + CapTP
  (user-surfaced at install)

§Tiers-widen-reach-never-relax-origin-isolation invariant.

## §Exo-binding rule

The CapTP bootstrap resolves to *that app instance's exo* with
only `run.powers`. §Two share-modes:

- **Referenced** — UI bridges to author's running exo
- **Cloned** — UI bridges to recipient's local exo under
  recipient's powers

The §ambient-authority-prevention move: capabilities-not-
configurations (cycle 105) applied at the UI layer.

## §Chrome/guest barrier as hard requirement

*Controls that act on the app's lifecycle are never rendered by
the guest... a hard requirement for app UIs because app authors
are potentially untrusted third parties*. The §host-chrome-not-
guest-chrome discipline.

## §Three distinct attribution shapes now in the library

| Author | Attribution |
|--------|-------------|
| Kris Kowal | *(prompted)* |
| Joshua T Corbin (jcorbin) | *(evoked)* |
| **Aaron** | ***(prompted)*** |

The bot-identity in the *endojs/endo-but-for-bots* design corpus
now broadens beyond a single contributor — three distinct human
contributors prompt/evoke designs.

## Rotation note

Cycle 143 was nominally **papers-lane** (cycle 142 was
comments). Papers-lane has been blocked for **37+ consecutive
cycles**. Cycle 143 pivoted to designs-lane.

## Counts

- 646 → **647** sections (+1).
- 187 → **188** source documents (+1).
- Topic pages updated: `agent-conventions.md` (+1 row — first
  familiar-app-* entry).
- Keywords index extended with ~32 app-ui-hosting-specific
  keywords.
- Sources/README.md updated (+1 row).
- Sections/README.md updated (+1 group; total adjusted).

## Next cycle

Cycle 144 wakes in 1500s. Rotation lands on **chat-lane**
nominally (still exhausted at 20/20). Many candidate paths
remain.
