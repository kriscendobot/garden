---
role: fixer
tier: mentor
---
<!-- garden-promoted-from-plan: gate=orchestrated priority=normal at=2026-08-23T20:07:03Z cleared=none -->

---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
# fixer: migrate release.yml config for changesets/action v2 (endojs/endo-but-for-bots PR #1051)

Dependabot PR #1051 bumps `changesets/action` **1.9.0 -> 2.1.0** in
`.github/workflows/release.yml` (one call site, base `llm`). This is a
**major** bump; Dependabot changed ONLY the pin and left the consuming
`with:`/`env:` config on v1 semantics. A botanist review already did the full
diligence (pins verified tag->commit both sides, no advisories, maturity floor
2026-08-20 already past). The ONLY thing blocking MERGE-NOW is this config
migration, which involves a release-security judgement the botanist declined to
guess. Your job: land it on the PR head branch, then let the paired conduct job
re-review and merge.

PR: https://github.com/endojs/endo-but-for-bots/pull/1051
Head branch (push here): `dependabot/github_actions/changesets/action-2.1.0`
Base: `llm`

Get an ISOLATED project worktree keyed by THIS base:
  scripts/jobs/ensure-project-worktree.sh endojs-endo-but-for-bots-pr1051-fixer endojs/endo-but-for-bots dependabot/github_actions/changesets/action-2.1.0

## The verified break (do not re-derive)

`release.yml` currently has (base `llm`, line ~69):
```yaml
    env:
      GITHUB_TOKEN: ${{ secrets.RELEASE_TOKEN }}
    uses: changesets/action@198f833dd7d863100ea6e28967bc9a9fdefadb0a # v2.1.0
    with:
      publish: yarn changeset tag
      createGithubReleases: true
```

Confirmed against the real `action.yml`/`src/index.ts` at the pinned SHA
`198f833` (v2.1.0):
1. **`publish` -> `publish-script`** (v2 PR #681). v2 reads
   `core.getInput("publish-script")`; the old `publish:` is IGNORED, so the
   publish/tag step would silently NOT run. MECHANICAL rename.
2. **`createGithubReleases` -> `create-github-releases`** (kebab-case, v2 PR
   #668). Default is already `true`, so behavior is unchanged, but rename it for
   correctness. MECHANICAL rename.
3. **Token: v2 no longer reads the custom token from the `GITHUB_TOKEN` env var**
   (v2 PR #674). v1 `src/index.ts`: `githubToken = process.env.GITHUB_TOKEN || core.getInput("github-token")`.
   v2 `src/index.ts`: `githubToken = getRequiredInput("github-token")` (default
   `${{ github.token }}`), and it only WARNS if `process.env.GITHUB_TOKEN`
   differs. So as-is, v2 would push the release PR / tags / GitHub releases as
   the default `github.token` identity, NOT `RELEASE_TOKEN`. That changes which
   identity pushes and whether downstream release-triggered workflows fire
   (pushes by the default `GITHUB_TOKEN` do not trigger further workflow runs).
4. **Push mode default changed** git-CLI -> GitHub API (`push-with-git-cli`
   defaults `false`, v2 PR #692). v1 pushed via git CLI using the
   checkout-persisted `RELEASE_TOKEN` credentials.

## Migration to land (preserve v1 behavior — the conservative default)

A dependency bump should preserve prior behavior, not silently adopt v2's new
push default. Preserve exactly:
```yaml
    uses: changesets/action@198f833dd7d863100ea6e28967bc9a9fdefadb0a # v2.1.0
    with:
      publish-script: yarn changeset tag
      create-github-releases: true
      github-token: ${{ secrets.RELEASE_TOKEN }}
      push-with-git-cli: true
```
- Move `RELEASE_TOKEN` to the explicit `github-token:` input (v2 requires it there).
- `push-with-git-cli: true` preserves the v1 git-CLI push behavior (with
  `github-token` taking precedence over repo credentials per v2 docs).
- The `env: GITHUB_TOKEN: ${{ secrets.RELEASE_TOKEN }}` block: `yarn changeset tag`
  only creates local git tags and needs no token, so REMOVE the env block (keeping
  it is harmless only because it now equals `github-token`; removing it is cleaner
  and avoids the v2 mismatch-warning surface). Your call, but prefer removing it.

## The judgement to surface (do not silently decide against the maintainer)

Whether to `push-with-git-cli: true` (preserve v1) vs adopt v2's new
GitHub-API push default is a **release-security decision** about this repo's
own infrastructure, and CI does NOT exercise `release.yml` on this PR
(`on: push: master` only), so nothing here catches a wrong choice. Land the
**preserve-v1** migration above (the safe default for a bump), and in your
report/verdict NAME this decision explicitly so the maintainer can override to
the v2 API-push default if they prefer it. If you are unsure `RELEASE_TOKEN`
still exists / is still the right token, message the maintainer via the liaison
before pushing.

## Definition of done
- The migration committed to the PR head branch `dependabot/github_actions/changesets/action-2.1.0`
  (single focused commit; commit message names the v2 input renames + token move).
- `check-action-pins` and the rest of PR CI still green (the pin hash/comment are
  unchanged, so it should stay green).
- Report names what you landed and the surfaced push-mode decision. The paired
  `endojs-endo-but-for-bots-pr1051-conduct` job then re-reviews and conducts.


<!-- garden-elapsed-constancy: 1 -->

<!-- garden-reaped: 4 -->
