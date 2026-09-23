---
date: 2026-05-14T22:06:25Z
host: endolin
role: scholar
kind: result
dispatch_root: dispatches/scholar--85924d
cycle: 50
---

# Scholar cycle 50: daemon-capability-persona (5 sections + 3 new concept pages); endo#3121 freshness pass

## endo#3121 freshness re-check (per cycle-47 unmerged-PR convention)

Re-fetched `pull/3121/head` from `endojs/endo`. The recorded
`source_commit` for `endo--designs-daemon-persistence` is
`aefc1b87da0cebd09184668effa264fe25e1c0b5`; the PR head is still
exactly that SHA. PR state via GitHub API: `open`, `draft: true`, last
updated `2026-03-08T06:28:26Z`. **No change. Freshness pass.** The
recorded source_commit remains current.

A transient `[deleted]` line surfaced during the initial fetch because
the previous ref had been moved on the remote; a force-fetch with
`+refs/pull/3121/head:refs/pull/3121/head` restored the ref and
returned the unchanged SHA. Noted here so a future maintainer
encountering the same fetch quirk does not interpret it as a PR
state change.

## Ingested

`endo-but-for-bots/llm/designs/daemon-capability-persona.md` —
**Not Started** upstream, 605 lines, 2026-02-24 (one of the older
designs in the cluster). The file's internal title is *"Delegates
and Epithets: Ideas and Directions"* — the filename is narrower than
the document. Upstream commit
`bcb6c379325b0f66d211d759ce7d3031fbf94e5b`. Referenced by `dani` as
the design that motivates per-agent network identity.

Slug `dcp`.

## Section files (5)

- `dcp/handle-agent-foundation-and-the-gap` — Handle / Agent /
  pet-name primitives; the *"Handle is opaque, agents can lie about
  themselves"* gap that delegates fill.
- `dcp/delegates-and-epithets` — the core idea; the three properties
  (obligatory + verifiable + deniable); what distinguishes this from
  a naive signature scheme.
- `dcp/recursive-chains-and-enforcement` — chain propagation;
  attenuation by extension not contraction; the daemon-implements-the-
  invariant discipline.
- `dcp/verification-and-handle-extensions` — verification protocol
  (verifier → principal, not through delegate); `epithets()` and
  `verify()` Handle methods; HandleControl caretaker for verification
  policy; revocation as chain break.
- `dcp/ai-delegates-connectors-and-anti-impersonation` — the
  motivating case (AI agents); service connectors as Handle
  recipients; pass-invariant equality of Handles; credential custody;
  anti-impersonation invariant.

## Concepts axis additions

This is the first ingest cycle after the library-lookup bootstrap.
Three new concept pages added to `library/concepts/`:

- `delegates-and-epithets` — the central concept of the design; aliases include `delegate`, `epithet`, `principal`, `Aifred`, `Jarvis`, `assistant to Alice`, `obligatory verifiable deniable`, `verifiable deniable claims`, `Delegates and Epithets`.
- `caretaker-pattern` — the Handle / HandleControl split; broader than this design (likely to attract sections from other future ingests, e.g. anything using a control-facet / action-facet pair).
- `pass-invariant-handle-equality` — the connector guarantee; an instance of the broader pass-invariant-equality convention in the OCapN family.

Plus ~35 new keyword entries in `keywords.md` covering the concept aliases. Existing concept pages were not modified this cycle.

## Topic refreshes

- `daemon.md` — 5 new rows (all 5 sections); 45 → 50.
- `capability-security.md` — 5 new rows (all 5 sections); 112 → 117.
- `patterns.md` — 4 new rows (delegates-and-epithets for the obligatory/verifiable/deniable discipline, recursive-chains-and-enforcement for daemon-implements-the-invariant, verification-and-handle-extensions for the caretaker pattern, ai-delegates-connectors-and-anti-impersonation for the identity/action facet split); 25 → 29.
- `agent-conventions.md` — 3 new rows (handle-agent-foundation for the pet-name addressing convention, verification-and-handle-extensions for the Handle interface extension shape, ai-delegates-connectors-and-anti-impersonation for the `@self.epithets()` discovery pattern); 27 → 30.

`topics/README.md` counts updated.

## Master indexes

- `sources/README.md` — 1 new row.
- `sections/README.md` — new "cycle 50" group added; total **443 → 448**.
- `concepts/README.md` — 3 new rows in the seed-inventory block.

## Consolidation / cross-reference work this cycle

The new concept pages cross-link aggressively into the existing
daemon cluster:

- `delegates-and-epithets` → `caretaker-pattern`, `revocation-by-withdrawal`, `per-agent-keypair`, `pass-invariant-handle-equality`.
- `caretaker-pattern` → `delegates-and-epithets`, `revocation-by-withdrawal` (with the substantive note that caretakers must remain alive to enforce, contrasting with revocation-by-withdrawal which does not).
- `pass-invariant-handle-equality` → `delegates-and-epithets`, `formula-graph`.

The patterns topic page is now visibly daemon-cluster-heavy: 6 of its 29 rows are daemon-cluster sections. If the topic continues to accumulate similar material, a `## Daemon-cluster patterns` subsection split may be warranted around cycle 52-53.

## Inbox state

Not advanced. The library-lookup writeback discipline introduced
last cycle is not exercised this cycle because scholar did the
ingest (not a designer/builder/juror following a link). The first
*caller-of-skill* exercise of the writeback will happen on the next
designer or builder dispatch that consults the library for a term
covered by one of the new concept pages.

## Library state

- Sources: 98 → **99**
- Sections: 443 → **448**
- Topics: 25 (unchanged); 4 topic pages refreshed.
- **Concepts: 14 → 17** (new this cycle: delegates-and-epithets, caretaker-pattern, pass-invariant-handle-equality).
- **Keywords: ~90 → ~125** (extended with ~35 new entries).

## Notes for the next cycle

- **The daemon cluster is now 9 sources** (d256, dani, dcp, dcpg, dlt, drp, rpn, daemon-content-store-gc, dp). The cluster-review pass proposed at cycle-48 / cycle-49 result entries remains pending; this cycle made progress on cross-cluster cross-references via the concept pages, which partially satisfies the consolidation intent.
- **endo#3121 freshness** — next re-check should land around cycle 53 (per the unmerged-PR convention's "re-check on cycles touching the persistence or daemon topic"); the recorded source_commit is currently fresh.
- **First writeback exercise** — the library-lookup skill's *Indexing on the fly* discipline has not yet been exercised by a caller-of-skill. Any rough edges in the writeback procedure will surface on the first designer / builder / juror dispatch that uses the skill against a term whose lookup falls back to flat-grep. Worth watching the next few dispatches for the first such case.
