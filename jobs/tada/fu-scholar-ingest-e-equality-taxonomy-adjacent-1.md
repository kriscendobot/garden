Done. The work is complete, pushed to `origin/journal2`, and the worktree is torn down.

---

**Completion report — `fu-scholar-ingest-e-equality-taxonomy-adjacent-1`**

**What I did:** Added a "Sources from the web" section to the scholar library's `library/conventions.md` (journal2 branch), codifying the previously-undocumented `source_kind: web` schema. ~20 web sources already existed under an undocumented precedent; the written schema now matches current practice.

**How I derived it:** Read all existing web-kind sources. The fullest form of the contract comes from the 2026-06-27 Miller equality-taxonomy batch (`web--miller-equality-*`, `web--miller-grant-matcher-*`), which was archive-captured because `erights.org` was unreachable; the 2026-06-11 marketplace/TLS/TUF batch (`web--aws-*`, `web--lets-encrypt-*`, `web--tuf-*`) supplied the live-fetch precedent. I cross-checked the thematic variants (`web-essay` → `kriskowal-com--giants`, `web-survey` → `ocap-history--e-capdesk-polaris`) and a section file to capture the section-frontmatter shape.

**What the new section documents:**
- When web ingest is appropriate (canonical web-only material, no repo/paper equivalent).
- Slug pattern `web--<short-title-dashed>`, with the thematic-prefix exception for named clusters.
- Source-file and section-file frontmatter: `source_url` / `source_snapshot` / `source_content_sha256` / `source_authors` / `source_date` / `source_mirror_url` / `retrieved`, plus the `web-essay` / `web-survey` variants.
- `source_content_sha256` as the idempotency anchor (replacing `source_commit`; web pages have no git history) — live-fetch vs archive-pinned distinction.
- The Internet-Archive `id_` acquisition recipe (`web.archive.org/web/<timestamp>id_/<url>` for original unmodified bytes → stable, reproducible hash), with a worked example from the equality batch.

**Verification:** Built in an isolated worktree off `origin/journal2`, committed one file (88 insertions), rebased on latest `journal2`, pushed cleanly (`2607281e4..ed1a8eac7`), confirmed the new section is present on the remote ref, and removed the worktree.

**Follow-ups (optional, not blocking):** The early 2026-06-11 marketplace web sources predate the `source_content_sha256` / `source_snapshot` discipline and lack those fields; a future scholar cycle could backfill content hashes for them if archival pinning is later wanted. Left as-is since the section already records the live-fetch-vs-archive distinction. No inbox messages arrived during the job.
