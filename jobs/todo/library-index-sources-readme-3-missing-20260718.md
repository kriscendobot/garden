Library index gap — library/sources/README.md is missing 3 source pages.

Task: add inventory rows to library/sources/README.md (journal2) for three
source files that EXIST under library/sources/ but are not listed in the
README's category tables. This is an authorized library-content edit; land it
with `scripts/jobs/land-journal-edit.sh library/sources/README.md` — do NOT
hand-git / rebase the live journal/ worktree (2026-06-27 scholar incident).

Missing sources (verified absent from sources/README.md 2026-07-18):
- node--doc-api-packages            repo-doc: nodejs/node doc/api/packages.md (commit cc37ad59, 2026-06-23)
- npm--configuring-npm-package-json repo-doc: npm/cli docs/lib/content/configuring-npm/package-json.md (commit ce7681fe, 2026-06-18)
- papers--moreira-muir-volatility-managed-portfolios-2017  paper: Moreira & Muir, "Volatility-Managed Portfolios", Journal of Finance 72(4):1611-1644, 2017

For each: read the source page's frontmatter + abstract, then add one row to
the appropriate existing category table (the two repo-doc pages group with
their repo-doc peers; the paper groups under the papers/external section),
matching the existing row shape (Source link | Repo/Provenance | Date/commit |
Authors | Sections | Status). Create a category table only if none fits.

NOTE: erights-org--elang-intro is CORRECTLY absent (status: superseded, whose
live successor erights--elang-intro IS listed) — do not add it.

Acceptance: each of the 3 slugs resolves in sources/README.md; the library
link-check passes.
