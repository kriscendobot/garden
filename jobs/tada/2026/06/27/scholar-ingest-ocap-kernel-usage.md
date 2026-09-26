Job complete. Report follows.

---

# Completion report: `scholar-ingest-ocap-kernel-usage`

**Done.** Ingested `MetaMask/ocap-kernel` `docs/usage.md` (691 lines, file-commit `175b7c0`, 2026-04-23, authors Dimitris Marlagkoutsos / Erik Marks) into the library as source `metamask-ocap-kernel--docs-usage-md` — the operational companion to the sixth ingest (`docs/kernel-guide.md`).

**What I wrote (11 new files):** 9 section files (overview, setting-up-the-kernel, vat-bundles, cluster-configuration, kernel-api, endo-integration, development-tools, end-to-end-testing, implementation-example), the `kind: index` parent section, and the source-index file. Each section carries an honest external-lineage flag (MetaMask's kernel, distinct from @endo: shared substrate `@endo/eventual-send` + `@endo/exo` + the injected platform/store seam; divergences in the four-scope name-space, first-class `kernel.revoke(kref)`, name-registered kernel services, `Far()` forbidden, SQLite `kv` store vs the formula graph).

**No-duplication discipline:** the kernel/vat *model* is cross-linked to kernel-guide and the BIP39 *identity* detail to the existing identity-backup-recovery source rather than re-ingested; the guide's "Common Use Cases" recaps and standalone identity pointer were folded into the overview/kernel-api sections.

**Indexes updated (12 shared files):** `concepts/ocap-kernel.md` (+5 rows), `keywords.md` (usage cluster), `sources/README.md` (+1 row), `sections/README.md` (+1 block), and 8 topic pages (getting-started, daemon, bundles, capability-security, eventual-send, exo, tooling, testing).

**Integrity gate:** `library-link-check.sh --source-slug metamask-ocap-kernel--docs-usage-md` passes against the committed origin/journal2 tip. The 25 dangling links the broader `--nav --wikilinks` scan reports are all pre-existing in unrelated sources (endoclaw / endopi designs), none in my cluster.

**Landing:** all 23 touched files landed via `land-journal-edit.sh` (the sanctioned producer-clone path), authored and validated in an isolated scratch worktree off origin/journal2, rebased onto the live tip before landing — no hand-git against the live `/home/kris/journal` worktree. Result entry posted (`entries/2026/06/27/104637Z-result-scholar-6b05ea.md`); job moved doin → tada; scratch worktree torn down.

**Remainder:** `docs/usage.md` is fully ingested. The remaining ocap-kernel work (per-package READMEs + kernel-internals code-comment fragments) is already tracked by `jobs/plan/scholar-ingest-ocap-kernel-packages.md`, so I posted no duplicate follow-on.

**Follow-up note:** I accidentally created one junk journal entry (`104604Z---help-gardener-f5074e.md`) probing `journal-entry.sh --help`, which has no help flag and treats the first arg as the entry kind. Harmless in the append-only journal; flagging it for awareness.

Self-improvement: nothing this time.
