All landed and verified on the `origin/journal2` tip. Inbox is empty.

---

## Completion report

**Job:** `scholar-clear-ocap-kernel-library-backfill-notes` — clear the two carried ocap-kernel library backfill notes. Read-only library scholarship; no fork, no PR. All edits landed via `land-journal-edit.sh` against the live `origin/journal2` tip (never a live worktree).

**Item 1 — KernelQueue.ts three leaf sections backfilled onto topic pages.** The three `KernelQueue.ts` leaf sections were indexed on the `[[ocap-kernel]]` concept page but carried zero Section rows on their topic pages. Backfilled each leaf onto the topic page(s) named in its *own* frontmatter `topics:` (per-section, not a blanket three-topic spray):
- `library/topics/persistence.md` +2 (`--forever-run-loop-and-crank-lifecycle`, `--crank-abort-rollback-versus-commit-flush`)
- `library/topics/eventual-send.md` +1 (`--immediate-versus-buffered-enqueue-and-decider-authorized-resolution`)
- `library/topics/capability-security.md` +3 (all three)

Rows inserted with `insert-sections-table-row.sh` (matched each page's `Section | Source | One-line abstract` shape; landed grouped with the sibling ocap-kernel cluster). `library/topics/README.md` counts regenerated via `regenerate-topics-counts.sh --land`.

**Item 2 — sources/README.md danglers resolved.** Rewrote the two concept-rendered `[[wikilink]]`s that resolved to non-existent concept pages — `[[engine-implementation]]` and `[[local-model-serving]]` — into resolvable topic markdown links (`[…](../topics/….md)`). Intent-preserving (both targets are genuinely *topics*, not concepts), avoiding duplicate concept stubs.

**Verification.** `regenerate-sections-index.sh --land`: already current (leaf files pre-existed in the flat index). `library-link-check.sh --all` (via `library-link-scan.sh`, tip-synced): **OK — every must-resolve navigation/index/source-table link resolves**; both former danglers now show `ok`. `--actuate --dry-run` standing-gate: OK, nothing to post. Result entry recorded: `entries/2026/07/06/021122Z-result-gardener-c4b132.md`.

**Outcome:** Both backfill notes cleared; indexes regenerated; integrity gate passing. The carried ocap-kernel library-hygiene backlog is **fully drained**.

**Follow-up (out of scope, pre-existing):** a whole-repo `--nav --wikilinks` scan surfaces ~24 pre-existing advisory `[[wikilink]]` danglers on *other* pages — 8 concept→concept links to missing concept stubs (`endopi`, `llm-agent-frameworks`, `capdesk`, `permission-versus-authority`, `designation-and-authorization`, `confused-deputy`, a `capability-security` concept page, `journal-library-conventions`) plus a large `sources/endo-but-for-bots--llm-designs-*` family whose sibling cross-refs render as `concepts/…` but mean `../sources/…` (same defect class fixed here, at scale). Non-gating; a future librarian sweep could clear them.
