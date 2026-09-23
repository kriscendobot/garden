---
ts: 2026-06-02T23:10:47Z
host: endolin
role: liaison
kind: result
dispatch_id: liaison--76fd9c
cycle: 129
---

# Cycle 129 — endopi-extension-package-manifest.md (Kris Kowal, endo-but-for-bots) — eighth endopi-* spinout

Ingested `designs/endopi-extension-package-manifest.md` (149
lines, *Proposed* status, Parent: endopi.md) from
`endojs/endo-but-for-bots@f4a9dc6d` (branch `origin/llm`).
**Twenty-sixth-comment-style design ingest.** One cohesion-honest
section:

- **one-package-json-keyword-one-install-command-multiple-
  resource-kinds-with-per-kind-confinement** — *the endopi-*
  family unifier* — the design that consumes four prior endopi-*
  designs through its `endo` manifest key (guests / skills /
  prompts / providers). Cycle 121's family keystone §Extensibility
  architectural contrast directly named this design as the *right
  move*: *make Endo's guest model as ergonomic as Pi's plug-in
  model for the cases where the user actually wants the broad
  authority*.

## The §title encodes the four-part promise

*One `package.json` keyword, one install command, multiple
resource kinds, with per-kind confinement*. The first three are
Pi's promise (Pi's `pi` keyword + `pi install` + four resource
kinds); the fourth is Endo's addition (per-kind confinement that
Pi doesn't provide).

## The single most structurally interesting move

The §Security posture *per-kind-confinement* table:

- **Guests** under SES with only granted capabilities (*package
  authors do not get to ask for new capabilities silently*)
- **Skills** are markdown files (*their power is to instruct the
  agent, not to do anything directly*)
- **Prompts** are pure text expansion (*no capability surface at
  all*)
- **Providers** run confined with network gated by daemon's
  outbound HTTP capability

The §safer-than-today conclusion: *a package install is therefore
safer than `endo install` is today* because the new resource
kinds carry no execution authority, and the existing one (guest)
is unchanged. The *expanding-the-surface-without-expanding-the-
attack-surface* discipline.

## Endopi-* family arc progress

The endopi-* family is now at **8/9 ingested**:

- cycle 112 — `endopi-skills-markdown-format.md` (consumer for
  `skills/`)
- cycle 117 — `endopi-jsonl-transcript-format.md`
- cycle 121 — `endopi.md` (family keystone — names this design
  as the *right move*)
- cycle 122 — `endopi-edit-tool.md`
- cycle 124 — `endopi-iterative-compaction.md`
- cycle 126 — `endopi-stdio-rpc-bridge.md`
- cycle 128 — `endopi-provider-registry-and-oauth.md` (consumer
  for `providers/`)
- **cycle 129 (this cycle)** —
  `endopi-extension-package-manifest.md` (*the family unifier*)

One spinout remains: `endopi-prompt-templates`.

## Rotation note

Cycle 129 was nominally **chat-lane** (cycle 128 was designs).
Chat-lane is exhausted (20/20 upstream designs ingested).
Papers-lane has been blocked for **23+ consecutive cycles**
(97/100/102/104/106/108/110/112/113/114/116/117/118/119/120/121/
122/123/124/125/126/127/128) due to lack of PDF-fetching
infrastructure. Cycle 129 pivoted to designs-lane.

## Counts

- 632 → **633** sections (+1).
- 173 → **174** source documents (+1).
- Topic pages updated: `agent-conventions.md` (+1 row — eighth
  endopi-* row in this topic).
- Keywords index extended with ~28 package-manifest-specific
  keywords.
- Sources/README.md updated (+1 row).
- Sections/README.md updated (+1 group; total adjusted).

## Next cycle

Cycle 130 wakes in 1500s. Rotation lands on **comments-lane**
nominally. The last endopi-* spinout (`endopi-prompt-templates`,
104 lines) is also available if cycle 130 pivots to designs.
