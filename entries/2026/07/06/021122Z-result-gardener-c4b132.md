---
kind: result
role: gardener
host: endolinbot
at: 2026-07-06T02:11:24Z
---
# result(scholar): carried ocap-kernel library-hygiene backlog fully drained

Cleared the two standing backfill notes carried across the batch-4/5/6 scholar
plans (job `scholar-clear-ocap-kernel-library-backfill-notes`). Read-only
library scholarship; no fork, no PR. Every edit landed via
`land-journal-edit.sh` against the current `origin/journal2` tip.

## Item 1 — KernelQueue.ts three leaf sections backfilled onto their topic pages

The three `packages/ocap-kernel/src/KernelQueue.ts` leaf sections were indexed on
the `[[ocap-kernel]]` concept page but carried zero Section rows on their topic
pages. Backfilled each leaf onto the topic page(s) named in its own frontmatter
`topics:` (not a blanket three-topic spray):

- `library/topics/persistence.md` (+2): `--forever-run-loop-and-crank-lifecycle`,
  `--crank-abort-rollback-versus-commit-flush`
- `library/topics/eventual-send.md` (+1):
  `--immediate-versus-buffered-enqueue-and-decider-authorized-resolution`
- `library/topics/capability-security.md` (+3): all three

Rows inserted with `insert-sections-table-row.sh` (matched each page's
`Section | Source | One-line abstract` column shape; landed grouped with the
sibling ocap-kernel cluster in each table). `library/topics/README.md` Index
counts regenerated with `regenerate-topics-counts.sh --land`.

## Item 2 — sources/README.md danglers resolved

`library/sources/README.md` carried two `[[wikilink]]`s rendered as concept
references that resolved to non-existent concept pages —
`[[engine-implementation]]` (danfinlay/quickjs `native-ses` row) and
`[[local-model-serving]]` (MylesBorins/athanor row). Both targets exist only as
**topic** pages, so the rows meant a topic reference. Rewrote each to a
resolvable topic markdown link (`[engine-implementation](../topics/engine-implementation.md)`,
`[local-model-serving](../topics/local-model-serving.md)`) — intent-preserving
(they are genuinely topics, not concepts) and avoids minting duplicate concept
stubs.

## Verification

- `regenerate-sections-index.sh --land`: already current (only topic-page rows
  changed; the leaf section files already existed in the flat index).
- `library-link-check.sh --all` (via `library-link-scan.sh`): **OK — every
  must-resolve navigation/index/source-table link resolves.** The two former
  danglers now show as `ok` (`sources/README.md -> ../topics/engine-implementation.md`
  and `-> ../topics/local-model-serving.md`).
- `library-link-scan.sh --actuate --dry-run` (standing-gate shape): OK, nothing
  to post.

The carried ocap-kernel library-hygiene backlog is **fully drained** — no
ocap-kernel comment-fragment source files remain queued, and both standing
backfill notes are cleared.

## Follow-up (out of scope, pre-existing)

A whole-repo `--nav --wikilinks` scan surfaces ~24 pre-existing advisory
`[[wikilink]]` danglers on *other* pages, unrelated to this job: eight
concept→concept links to genuinely-missing concept stubs (`endopi`,
`llm-agent-frameworks`, `capdesk`, `permission-versus-authority`,
`designation-and-authorization`, `confused-deputy`, a `capability-security`
*concept* page, `journal-library-conventions`), plus a large
`sources/endo-but-for-bots--llm-designs-*` family whose sibling cross-refs render
as `concepts/...` but "did you mean ../sources/..." — the same defect class
fixed here, at scale. These are the known non-gating advisory danglers; a future
librarian sweep could clear them (create the concept stubs / rewrite the sibling
refs to source links).
