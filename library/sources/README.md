# Sources

Per-source-document inventory. Each row points to a `<source-slug>.md` file that lists the section files derived from that source, with provenance metadata (commit, date, authors, ingestion date).

The pilot batch (2026-05-13) covers three endo top-level / docs-level files. The rest of the endo corpus (~70 substantive markdown files: top-level, `docs/`, per-package READMEs, per-package `docs/` and `doc/` directories) is queued for future ingestion batches; the index will grow as those are filed.

## Ingested

| Source | Repo | Last-modified | Primary author | Sections | Status |
|--------|------|---------------|----------------|----------|--------|
| [AGENTS.md](endo--agents.md) | endojs/endo | 2026-03-21 | Turadg Aleahmad | 6 | current |
| [docs/security.md](endo--docs-security.md) | endojs/endo | 2025-09-25 | Kris Kowal | 3 | current |
| [docs/errors.md](endo--docs-errors.md) | endojs/endo | 2025-09-25 | Kris Kowal | 7 | current |
| [docs/lockdown.md](endo--docs-lockdown.md) | endojs/endo | 2025-09-25 | Kris Kowal | 15 | current |
| [docs/bugs.md](endo--docs-bugs.md) | endojs/endo | 2025-09-25 | Kris Kowal | 1 | current |
| [docs/get-started.md](endo--docs-get-started.md) | endojs/endo | 2025-12-04 | Kris Kowal | 6 | current |
| [packages/daemon/README.md](endo--pkg-daemon-readme.md) | endojs/endo | 2022-12-08 | Kris Kowal | 1 | current |
| [packages/marshal/README.md](endo--pkg-marshal-readme.md) | endojs/endo | 2024-02-05 | Richard Gibson + Kris Kowal | 7 | current |
| [packages/pass-style/README.md](endo--pkg-pass-style-readme.md) | endojs/endo | 2026-01-04 | Kris Kowal | 11 | current |
| [packages/exo/README.md](endo--pkg-exo-readme.md) | endojs/endo | 2026-01-04 | Kris Kowal | 11 | current |

## Backlog (not yet ingested)

Roughly grouped by priority. The full file inventory was captured during the pilot survey; the lists below are summaries, not authoritative manifests.

**Top-level (1 remaining):** `README.md`, `CONTRIBUTING.md`. (`AGENTS.md` and `SECURITY.md` are done; `SECURITY.md` content overlaps `docs/security.md` and may need a contradiction check.)

**`docs/` (3 remaining):** `guide.md`, `message-passing.md`, `reference.md`. (`bugs.md` and `get-started.md` ingested on the /loop ticks of 2026-05-14; `lockdown.md` was ingested 2026-05-13 as the first scholar-cycle library task.)

**Package READMEs (43 remaining):** of the 47 packages under `packages/`, 4 are now ingested (`daemon`, `marshal`, `pass-style`, `exo`). Flagship READMEs queued in the inbox for subsequent cycles: `ses`, `eventual-send`, `patterns`. Other packages remain in the unprimed backlog.

**Package `docs/` and `doc/` (13):**
- `packages/exo/docs/`: `exo-taxonomy.md`, `types.md`.
- `packages/marshal/docs/smallcaps-cheatsheet.md`.
- `packages/memoize/docs/memoize.md`.
- `packages/pass-style/doc/`: `copyArray-guarantees.md`, `copyRecord-guarantees.md`, `enumerating-properties.md`.
- `packages/patterns/docs/marshal-vs-patterns-level.md`.
- `packages/ses/docs/`: `draft-standalone-spec.md`, `guide.md`, `preparing-for-stabilize.md`, `secure-coding-guide.md`, `ses-0.7.md`.

**Other:**
- `.changeset/*.md` (13 files): recent change descriptions; useful for "what landed when."
- `packages/ses/error-codes/*.md` (13 files): SES error-code reference; mechanical but useful.
- `rust/ocapn_noise/README.md`: small.
- `scripts/setup-agoric-bot.md`: small.

Auto-generated content not for ingestion:
- `CHANGELOG.md` files (47): one per package; per-package change history. Out-of-scope for the library; the upstream files remain the source of truth.

## Notes

- Some files have only one commit in `git log` (probably post-rename); their content date may predate the commit date. The pilot ingestion flagged these in per-source `notes:` fields. A future contradiction-check pass should compare pre- and post- rename content if the upstream history is recovered.
