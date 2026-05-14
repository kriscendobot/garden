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
| [docs/reference.md](endo--docs-reference.md) | endojs/endo | 2026-04-26 | Kris Kowal | 9 | current (overlaps docs/lockdown.md) |
| [packages/daemon/README.md](endo--pkg-daemon-readme.md) | endojs/endo | 2022-12-08 | Kris Kowal | 1 | current |
| [packages/marshal/README.md](endo--pkg-marshal-readme.md) | endojs/endo | 2024-02-05 | Richard Gibson + Kris Kowal | 7 | current |
| [packages/pass-style/README.md](endo--pkg-pass-style-readme.md) | endojs/endo | 2026-01-04 | Kris Kowal | 11 | current |
| [packages/exo/README.md](endo--pkg-exo-readme.md) | endojs/endo | 2026-01-04 | Kris Kowal | 11 | current |
| [packages/patterns/README.md](endo--pkg-patterns-readme.md) | endojs/endo | 2026-01-04 | Kris Kowal | 10 | current |
| [packages/eventual-send/README.md](endo--pkg-eventual-send-readme.md) | endojs/endo | 2026-01-04 | Kris Kowal | 14 | current |
| [packages/ses/README.md](endo--pkg-ses-readme.md) | endojs/endo | 2025-09-25 | Kris Kowal | 9 | current |
| [docs/message-passing.md](endo--docs-message-passing.md) | endojs/endo | 2026-01-04 | Kris Kowal | 9 | current |
| [docs/guide.md](endo--docs-guide.md) | endojs/endo | 2025-09-25 | Kris Kowal | 10 | current (multi-source overlaps) |
| [packages/captp/README.md](endo--pkg-captp-readme.md) | endojs/endo | 2022-01-13 | Kris Kowal | 4 | current |
| [packages/marshal/docs/smallcaps-cheatsheet.md](endo--pkg-marshal-docs-smallcaps-cheatsheet.md) | endojs/endo | 2026-02-02 | Mark S. Miller | 1 | current |
| [packages/pass-style/doc/copyArray-guarantees.md](endo--pkg-pass-style-doc-copyarray-guarantees.md) | endojs/endo | 2023-11-30 | Kris Kowal | 1 | current |
| [packages/pass-style/doc/copyRecord-guarantees.md](endo--pkg-pass-style-doc-copyrecord-guarantees.md) | endojs/endo | 2023-11-30 | Kris Kowal | 1 | current |
| [packages/pass-style/doc/enumerating-properties.md](endo--pkg-pass-style-doc-enumerating-properties.md) | endojs/endo | 2023-11-30 | Kris Kowal | 1 | current |
| [packages/patterns/docs/marshal-vs-patterns-level.md](endo--pkg-patterns-docs-marshal-vs-patterns-level.md) | endojs/endo | 2025-05-02 | Mark S. Miller | 3 | current |
| [packages/exo/docs/exo-taxonomy.md](endo--pkg-exo-docs-exo-taxonomy.md) | endojs/endo | 2023-01-27 | Mark S. Miller | 5 | current |
| [CONTRIBUTING.md](endo--contributing.md) | endojs/endo | 2026-01-08 | Kris Kowal | 6 | current |
| [draft-specifications/Model.md](ocapn--draft-specifications-model.md) | kriscendobot/ocapn | 2025-06-23 | Mark S. Miller | 11 | current (data-model overlap with pass-style/marshal flagged in per-section notes) |
| [draft-specifications/Notation.md](ocapn--draft-specifications-notation.md) | kriscendobot/ocapn | 2025-06-19 | Mark S. Miller | 4 | current (Record/Tagged terminology mismatch flagged) |
| [README.md](endo--readme.md) | endojs/endo | 2025-12-19 | Kris Kowal | 3 | current |
| [packages/lockdown/README.md](endo--pkg-lockdown-readme.md) | endojs/endo | 2022-12-08 | Kris Kowal | 1 | current |
| [packages/exo/docs/types.md](endo--pkg-exo-docs-types.md) | endojs/endo | 2024-11-04 | Kris Kowal | 1 | current |
| [draft-specifications/Locators.md](ocapn--draft-specifications-locators.md) | kriscendobot/ocapn | 2025-12-03 | Jessica Tallon | 5 | current (draft; sturdyref overlaps durable-Exo) |
| [draft-specifications/Netlayers.md](ocapn--draft-specifications-netlayers.md) | kriscendobot/ocapn | 2024-10-01 | Jessica Tallon | 4 | current (draft; overlaps endo netstring/noise/stream) |
| [packages/ses/docs/preparing-for-stabilize.md](endo--pkg-ses-docs-preparing-for-stabilize.md) | endojs/endo | 2025-01-18 | Mark S. Miller | 3 | current |
| [packages/ses-ava/README.md](endo--pkg-ses-ava-readme.md) | endojs/endo | 2025-10-29 | Richard Gibson | 3 | current |
| [packages/memoize/docs/memoize.md](endo--pkg-memoize-docs-memoize.md) | endojs/endo | 2026-01-27 | Mark S. Miller | 7 | current |
| [README.md](ocapn--readme.md) | kriscendobot/ocapn | 2025-07-10 | Jessica Tallon | 5 | current |
| [draft-specifications/CapTP Specification.md](ocapn--draft-specifications-captp.md) | kriscendobot/ocapn | 2026-03-12 | Jessica Tallon | 10 | current (largest source; ops and descs consolidated) |
| [packages/compartment-mapper/README.md](endo--pkg-compartment-mapper-readme.md) | endojs/endo | 2024-12-15 | Kris Kowal | 5 | current |
| [packages/bundle-source/README.md](endo--pkg-bundle-source-readme.md) | endojs/endo | 2025-08-02 | Richard Gibson | 7 | current |
| [packages/ses/docs/secure-coding-guide.md](endo--pkg-ses-docs-secure-coding-guide.md) | endojs/endo | 2023-08-26 | Mark S. Miller | 4 | current |

## Backlog (not yet ingested)

Roughly grouped by priority. The full file inventory was captured during the pilot survey; the lists below are summaries, not authoritative manifests.

**Top-level (0 remaining):** all 4 top-level documents ingested (AGENTS.md, CONTRIBUTING.md, README.md, SECURITY.md). SECURITY.md content overlaps `docs/security.md` and may need a contradiction check.

**`docs/` (0 remaining):** all 8 `docs/*.md` files ingested. `bugs.md`, `get-started.md`, `reference.md`, `message-passing.md`, and `guide.md` ingested on the /loop ticks of 2026-05-14; `lockdown.md` was ingested 2026-05-13 as the first scholar-cycle library task; `security.md` and `errors.md` from the original pilot.

**Package READMEs (39 remaining):** of the 47 packages under `packages/`, 8 are now ingested (`daemon`, `marshal`, `pass-style`, `exo`, `patterns`, `eventual-send`, `ses`, `captp`). 39 small-utility packages remain in the backlog.

**Package `docs/` and `doc/` (8 remaining):** ingested so far: `marshal/docs/smallcaps-cheatsheet.md`, `pass-style/doc/{copyArray,copyRecord,enumerating-properties}-guarantees.md`, `patterns/docs/marshal-vs-patterns-level.md`, `exo/docs/exo-taxonomy.md`. Remaining: `exo/docs/types.md`, `memoize/docs/memoize.md`, `ses/docs/{draft-standalone-spec,guide,preparing-for-stabilize,secure-coding-guide,ses-0.7}.md`.

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
