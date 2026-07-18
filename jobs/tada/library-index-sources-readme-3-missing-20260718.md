Done. Inbox empty, work landed and verified.

## Completion report

**Task:** Add inventory rows to `library/sources/README.md` (journal2) for three source files that existed under `library/sources/` but were unlisted in the README's category tables.

**What I did:**
- Read each source file's frontmatter + abstract to derive accurate, style-matched rows.
- Added the two repo-doc `package.json` reference pages to the existing **Package-manifest runtime sources** table (columns: Source | Repo | Path | Commit | Sections | Status), where they group with their peers (Deno/Bun/pnpm/Yarn/Corepack):
  - `node--doc-api-packages` → nodejs/node · `doc/api/packages.md` · `cc37ad5` · 8 sections
  - `npm--configuring-npm-package-json` → npm/cli · `docs/lib/content/configuring-npm/package-json.md` · `ce7681f` · 5 sections
- Added the paper to the existing **External papers** table (columns: Source | Authors | Year | Venue | Sections | Status), grouped with the financial-forecasting-corpus peers:
  - `papers--moreira-muir-volatility-managed-portfolios-2017` → Moreira & Muir · 2017 · Journal of Finance 72(4):1611-1644 · 5 sections · SHA-256 `679361ac28d0`, ingest tag `scholar-ingest-financial-forecasting-corpus-6` (verified against `concepts/README.md`).
- Did **not** add `erights-org--elang-intro` (correctly absent — superseded).
- Landed via `scripts/jobs/land-journal-edit.sh library/sources/README.md` (no hand-git on the live worktree). Exit 0, verified on `origin/journal2`.

**Verification:**
- All three slugs resolve in `sources/README.md` (1 match each).
- `library-link-check.sh --files sources/README.md` against the landed producer clone: **OK — every checked link resolves to a committed file** (exit 0).

**Follow-ups:** None. The live garden-root `journal/` worktree remains behind the landed tip (github fetch/push over ssh was timing out during the run, though the sanctioned land itself succeeded); it will catch up on its next sync — no action needed.
