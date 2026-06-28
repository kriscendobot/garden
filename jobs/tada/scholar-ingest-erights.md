---
ts: 2026-06-28T15:58:00Z
kind: result
role: scholar
project: endo
---

# scholar-ingest-erights — result

Ingested the foundational erights.org HTML pages reachable via the GitHub Pages
mirror (`source_fetched_via=mirror` for every fetch, content-SHA-256 anchors).

## Sources ingested (3 net-new; all via mirror)

- **`erights--elang-index`** (1 section) — the E Language index/landing hub
  (`elang/index.html`, SHA `77f5814bce5d`). Section `overview`: the E doc-tree
  map + E-self-description + E-to-Endo translation. Topics: `e-language`,
  `capability-security`.
- **`erights--elang-same-ref`** (2 sections) — *Semantics of "Same"*
  (`elang/same-ref.html`, SHA `95878351747c`). Sections:
  `synchronous-sameness-and-reflexivity` (the `==` operator, substitutability,
  reflexivity incl. NaN, `<=>`, scalar sameness) and
  `selfish-and-selfless-objects` (identity vs transparency, the three conditions,
  pass-by-copy between vats, collections). The direct ancestor of Endo
  pass-style. Topics: `e-language`, `pass-style`.
- **`erights--elib-capability-ode-index`** (0 sections; HTML-form POINTER) —
  *An Ode to the Granovetter Diagram* index (`elib/capability/ode/index.html`,
  SHA `9763047ff7eb`). Recorded as a pointer, **not** a re-ingest: the ode is the
  same document already in the library as the paper
  `papers--miller-morningstar-frantz-capability-based-financial-instruments-2000`.
  The page maps the HTML chapters to the existing paper sections so a reader who
  lands on an erights ode URL navigates to the canonical material, with no
  content duplication.

## New index pages

- Topic **`e-language`** (new): collects the language-level E sources, distinct
  from the capability-*theory* papers.
- Concept **`selfless-and-selfish-objects`** (new, `status: draft`): E's
  identity-vs-transparency split, cross-linked to `pass-invariant-handle-equality`,
  `object-capability`, `granovetter-operator`.

## Indexes updated

`topics/README.md` (e-language row), `concepts/README.md` (selfless row),
`keywords.md` (19 keyword lines: selfless/selfish/sameness aliases + E-language
and ode pointers), `topics/pass-style.md` (2 sameness section rows),
`sources/README.md` (3 web-source rows under External web sources).
`sections/README.md` (the 5561-entry auto-generated index) was **not** edited —
hand-editing a 40 KB+ auto-generated file via whole-file-replace is impractical
and risky, and the integrity gate does not require it; a regeneration pass will
pick up the new sections.

## Overlap discovered (and handled)

My initial survey read the **stale live `journal/` worktree** and missed that a
2026-06-27 cycle had already ingested the E tutorial intro
(`erights--elang-intro` + chapters, canonical; the divergent `erights-org--`
slug already superseded) and **two ode chapters** (`ode-protocol`, `ode-pki`,
which themselves overlap the FC2000 paper). My three sources are all genuinely
net-new (no file collision). After discovering this against the true tip, I
corrected two of my landed files: the elang-index overview now marks the
tutorial/concurrency pages as ingested (not "queued"), and the ode-index pointer
now cross-references the two already-ingested ode chapter sections and notes the
overlap.

## Integrity gate

`library-link-check.sh --source-slug` on all three new clusters: **PASS** (every
section-table / README row resolves to a committed file). A `--nav` sweep
surfaced ~20 pre-existing dangling links, **none** in any file this cycle
touched (they live in the `endo-but-for-bots--llm-designs-*` cluster +
`concepts/polaris.md` / `powerbox.md` + `endo--designs-daemon-persistence.md`);
flagged for a separate cleanup job in the follow-on.

## Follow-on posted

`scholar-ingest-erights-2`: the remaining queued E-language spec/data-type pages
(quick-ref, grammar, blocks, kernel-E, scalars, collections, io, concurrency
index, guarding), the un-ingested ode chapters (with a caution that they
duplicate the paper), and the pre-existing dangling-link cleanup flag.

Self-improvement: nothing this time. (The stale-live-worktree survey gap is
already covered by the standing memory "inspect journal2 read-only via
`git show origin/journal2:<path>`"; I recovered by surveying against a
tip-synced clone. The lander/gate model worked as documented.)
