## Completion report: garden-book PR #15 merged, draft edition live on ocap.site

PR #15 is merged into `main`, and a new draft edition of the book is live on ocap.site. Every check passed on the merged code and again against the live site.

**Predecessor check:** the fixer job's report says its fixes landed (head `ef62703`, including the MCP `isError` fail-closed fix and its tests), so it was safe to go ahead.

### Merge
- PR #15 was at head `ef627035`, with frozen base `main-5acd916`. Live `main` was at that same commit, so no rebase was needed and none was done.
- I changed the PR's base to `main`, took it out of draft, and merged it with a merge commit, pinned to the head commit. **Merge commit: `9b2a60340920eb3ec36813779a010163539a86f2`.** This merge used the maintainer override: the review panel never converged (13 rounds).
- **Frozen-base sweep:** no open PRs remained, so I deleted the 9 `main-<sha>` branches and `book-copyedit-913c8a7`.

### Checks on merged `main` (repeated on the published commit `39fd2e8`)
- `npm ci`: OK, 0 vulnerabilities.
- `npm test`: 86/86 passed, 0 skipped.
- `npm run test:browser`: 1/1 passed.
- Build: 27 files, 10 chapters.
- `tools/browser-check.mjs` at 390x844 and 1440x900, light and dark: all four pass, with 25 plates, no overflow, caption contrast at least 5.68:1 and body contrast at least 12.9:1.
- Equilibrium integration check: 36/36 cases pass, covering all nine charts.
- Placements, using an ad-hoc Chromium script that is not committed to the repo: all 25 illuminations appear in the declared order, each under its anchor, at its declared pixel size.
- Glyph sprite: all five part glyphs render. At phone width the five sidebar copies have a zero-size box because the sidebar is hidden there by design (`.nav-part` is `display:none`).

### Publish
- Before publishing I committed `39fd2e8` to `main`, which changes the title-page edition note to **"Draft edition of 2026-10-16, repainted illuminations"** and brings the list of earlier editions up to date.
- I published a new edition with `build/publish.mjs`, which always uses the inert `garden-book-inert` power. No old edition was republished.
- **Immutable URL: https://xkmof32e37co54ni4b2gm5r3ls73uhsvodwg4jpmqni2jcv4fluq.ocap.site/**
  - The existing minion.town publish tool already serves editions at `<hash>.ocap.site`, so no credential or domain step was needed.
- **Served bytes:** all 27 files match the build output byte for byte.
  - All 27 have `cache-control: public, max-age=31536000, immutable`.
  - The CSP header is present, and the `etag` equals the `index.html` sha256 (`770339a7…`).
- `tools/browser-check.mjs` against the live URL passes all four configurations under the CSP the site actually serves.
- The equilibrium check only accepts a local file, so it covered the build rather than the live URL; the served bytes are identical to that build.

### Record
- `51f6c5d` on `main` adds the draft edition to `build/README.md`: provenance, hashes, check results, and the skipped steps. `main` is now at `51f6c5d`.
- Both small commits (`39fd2e8` and `51f6c5d`) went straight to `main` without a PR, as the override allows.

### Deliberately skipped
- The history PR and its gauntlet. The maintainer plans to rewrite `main`'s history later.
- PR #15 merged without a converged panel, under the maintainer's override.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/garden-book-pr15-merge-and-publish-draft-20261016.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 62 tokens (2059128 cached reads)
- Output: 12548 tokens
- Cost: $1.2378975999999997
- Wall-clock: 212s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
