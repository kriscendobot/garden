---
kind: result
role: scholar
host: endolinbot
at: 2026-06-27T10:46:38Z
---
# Result: scholar — ingest MetaMask/ocap-kernel docs/usage.md (seventh ocap-kernel ingest)

Job `scholar-ingest-ocap-kernel-usage`. Ingested `MetaMask/ocap-kernel` `docs/usage.md`
(691 lines, file-commit `175b7c0`, 2026-04-23, authors Dimitris Marlagkoutsos / Erik Marks)
as library source `metamask-ocap-kernel--docs-usage-md`. The operational companion to the
sixth ingest (`docs/kernel-guide.md`); curated for the setup / bundling / CLI / testing
surface the kernel guide omits, cross-linked rather than duplicated for everything
model-level.

## Sections written (9 + parent index + source)

- overview, setting-up-the-kernel, vat-bundles, cluster-configuration, kernel-api,
  endo-integration, development-tools, end-to-end-testing, implementation-example.
- `kind: index` parent `sections/metamask-ocap-kernel--docs-usage-md.md`.
- source index `sources/metamask-ocap-kernel--docs-usage-md.md`.

Each section carries an honest external-lineage flag (MetaMask's kernel, distinct from @endo:
shared substrate `@endo/eventual-send` + `@endo/exo` + injected platform/store seam;
divergences in the four-scope name-space, first-class `kernel.revoke(kref)`, name-registered
kernel services, `Far()` forbidden, SQLite `kv` store vs the formula graph).

## No-duplication discipline

- Kernel/vat **model** (vat code, kernel services, subclusters, endowments, exos, baggage,
  revocation) cross-linked to [kernel-guide](../library/sources/metamask-ocap-kernel--docs-kernel-guide-md.md), not re-ingested.
- BIP39 **identity** detail cross-linked to the existing
  [identity-backup-recovery](../library/sources/metamask-ocap-kernel--docs-identity-backup-recovery-md.md) source.
- The guide's "Common Use Cases" recipe recaps and the standalone "Identity Backup and
  Recovery" pointer folded into the overview and kernel-api sections rather than given their
  own pages.

## Indexes updated

- `concepts/ocap-kernel.md` (+5 rows), `keywords.md` (usage cluster), `sources/README.md`
  (+1 row), `sections/README.md` (+1 block), and 8 topic pages: getting-started, daemon,
  bundles, capability-security, eventual-send, exo, tooling, testing.

## Integrity gate (step 8)

`library-link-check.sh --source-slug metamask-ocap-kernel--docs-usage-md` — **OK against the
committed origin/journal2 tip** (every section-table target, sections/README index row, and
the kind:index parent's child list resolves to a committed file). The 25 dangling links the
broader `--nav --wikilinks` scan reports are all pre-existing in unrelated sources (endoclaw /
endopi designs), none in the usage cluster.

## Landing discipline

All 23 touched files landed through `scripts/jobs/land-journal-edit.sh` (the sanctioned
producer-clone path), authored and validated in an isolated scratch worktree off
origin/journal2, rebased onto the live tip before landing. No hand-git against the live
`/home/kris/journal` worktree.

## Remainder

`docs/usage.md` is fully ingested. The remaining ocap-kernel work (per-package READMEs +
kernel-internals code-comment fragments) is already tracked by the existing deferred plan
`jobs/plan/scholar-ingest-ocap-kernel-packages.md`; no new follow-on posted (would duplicate).

Self-improvement: nothing this time.
