---
ts: 2026-05-14T09:50:46Z
kind: result
role: scholar
project: garden-library
---

# Thirtieth scholar cycle — first consolidation pass + 6 fresh priming messages

First cycle to act on the maintainer's 2026-05-14 discretion mandate (per `entries/2026/05/14/053037Z-message-liaison-7c4e02.md`). Inbox was empty of pending ingest tasks (all 55 cycles-1–29 priming messages have landed sections in the library), so this cycle pivoted entirely to consolidation and survey.

## Cycle work

### Cluster B consolidation (pre-authorized in cycle 15)

The four per-verb API reference sections — derived from short H2s in `docs/reference.md` and consolidated in the guide-shape `docs/guide.md` `api-overview` section — get the canonical/superseded treatment:

| Superseded | Canonical | Notes |
|------------|-----------|-------|
| `endo--docs-reference--lockdown-api` | `endo--docs-guide--api-overview` | `status` flipped to `superseded`; `superseded_by`/`superseded_on`/`superseded_reason` added |
| `endo--docs-reference--repair-intrinsics-api` | `endo--docs-guide--api-overview` | same |
| `endo--docs-reference--harden-intrinsics-api` | `endo--docs-guide--api-overview` | same |
| `endo--docs-reference--lockdown-and-harden` | `endo--docs-guide--api-overview` | same |

The canonical's `notes:` field rewritten to declare its consolidating role and forward-point at the superseded slugs (for readers who arrive at the canonical and need the legacy file).

The `topics/hardened-javascript.md` page restructured: the four rows moved out of the primary *Sections* table and into a new *Superseded sections* subsection at page-end. The canonical's row updated to call out its "**Canonical**" status with the consolidated verb list.

Per the maintainer's append-only constraint, the four section files remain on disk; only their frontmatter `status:` and the topic-page placement changed.

### One cross-reference added (Cluster review bullet 1)

`endo--pkg-pass-style-readme--far` and `endo--pkg-exo-readme--makeexo-single-instance` now cross-reference each other via `notes:` fields, characterizing them as alternative remotable-construction paths (minimal vs heavier-weight with patterns guards). A reader arriving at either via the topic pages or grep can now navigate to the alternative.

### Conventions update

`library/conventions.md` extended with two new top-level sections:

- **Sectioning shapes by source type** — codifies cycle 29's aggressive consolidation pattern for alphabetical/non-thematic reference documents (1–3 sections preserving H2 anchors inline) as a recognized exception to the H2-per-section default.
- **Consolidation as a cycle output** — codifies the canonical/superseded procedure used in this cycle, including the topic-page restructuring and the topic-section-count invariant. Names soft-flagging as the default and hard-supersession as the exception (when the overlap is at the same shape and the canonical strictly dominates).

These are now reference-able from future cycles so the procedure does not need to be re-derived.

### Survey: 6 priming messages queued for next cycle

All from worktree bare clones the garden already maintains:

| source_repo | source_path | Rationale |
|-------------|-------------|-----------|
| agoric/agoric-sdk | AGENTS.md | Agent-facing operating notes (analog of `endo--agents.md`). |
| agoric/agoric-sdk | CONTRIBUTING.md | Repository-governance, likely soft-flag overlap with `endo--contributing`. |
| agoric/agoric-sdk | SECURITY.md | Security-disclosure, likely overlap with `endo--docs-security`. |
| agoric/agoric-sdk | README.md | Top-level frame for the agoric-sdk corpus. |
| agoric/agoric-sdk | packages/README.md | Per-package navigation aid. |
| kriscendobot/ocapn | implementation-guide/Implementation Guide.md | Substantial additional OCapN-family spec material; will cross-cut the existing 6 spec source files. |

All queued as `to: scholar` `library_action: ingest-source` messages with `source_repo` and `source_path` fields the scholar's inbox-drain procedure understands.

## Library state

No section count change (consolidation flipped statuses but added no new sections; 282 sections from 58 sources across 3 repos).

- 4 sections now `status: superseded` (all 4 cluster-B per-verb references)
- 1 section now flagged as "**Canonical**" on its topic page (`api-overview`)
- 2 sections now carry cross-reference `notes:` (far ↔ makeExo)

## Inbox state

6 fresh tasks queued. Active mode (600–1200s wakeup) for next cycle.

## Self-improvement

Two things observed:

1. The supersede procedure is mechanical once the canonical is named: section-file frontmatter edits + topic-page restructuring + canonical's `notes:` update + conventions section. No structural decisions needed beyond cluster identification. Codifying the procedure in `library/conventions.md` should make future cycles cheaper.

2. The remaining clusters from the review can land in similar small batches:
   - Cluster A (lockdown options) — three sections at three abstraction levels (canonical detail / reference summary / guide shape); needs decision on whether to drop the reference summary or keep all three. Maintainer discretion now grants the scholar this call.
   - Cluster C (HardenedJS removes/adds) — guide points at reference per the cluster-15 recommendation; verb the cross-references and update topic placement.
   - Remaining cross-reference bullets 2–4 from the cluster review (marshal/eventual-send, message-passing/digital-purse-example, eventual-send/exo).
   - Topic-page abstract staleness sweep.

Routing one of these per cycle alongside priming ingest cycles is the steady cadence going forward.
