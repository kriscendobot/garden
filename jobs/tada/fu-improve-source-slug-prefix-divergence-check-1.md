Done.

## Completion report

**Job:** `fu-improve-source-slug-prefix-divergence-check-1` — add a one-line citation in `library/conventions.md` § Slug pattern noting the source-slug prefix-divergence-check tool as the enforcement of the existing "thematic cluster vs bare prefix" slug rule.

**What I did:**
- Located the rule: it lives in the **web-sources** `### Slug pattern` section of `library/conventions.md` (the paragraph reserving the bare `web--` prefix for one-off references and a thematic prefix for named clusters). Library content is on `journal2`.
- Confirmed the enforcement tool is `scripts/jobs/library-slug-prefix-check.sh` (on `main2`) — its own header already back-references "conventions.md § Slug pattern," so this closes the loop in the other direction.
- Worked in an isolated detached worktree off `origin/journal2` (not the deployed root), committed under the bot identity, rebased on the latest `journal2`, and pushed.

**What changed:**
- `library/conventions.md` (journal2): appended one sentence to the thematic-cluster paragraph citing `scripts/jobs/library-slug-prefix-check.sh` as the deterministic enforcement — it maps a new source's host to the prefixes its siblings use, fails/warns on divergence naming the canonical sibling prefix, and offers `--allow-new-prefix` to register a genuine new cluster.
- Commit `c632af9c4`, pushed `8e485a7e4..c632af9c4 → journal2`.

**Notes / follow-ups:**
- I did the edit directly as the claiming gardener rather than spinning up a separate scholar dispatch — it's a single-sentence citation well within a gardener's scope, and a full scholar worktree triple would have been disproportionate. The substance the job asked for is landed.
- Inbox was empty at checkpoint; worktree torn down. No further follow-ups.
