Both suites pass on the rebased tree (ci-watcher gained 4 assertions from a peer's commit); inbox is empty.

## Report

**Landed:** `f17f93e8e2` on `main2` — *feat(dependabot-watcher): reconcile superseded PRs before buying a review*.

### What changed

**`scripts/jobs/handlers/ci-pr-source-gh.sh`** — emits `title` as a trailing fifth TSV column (the dependency identity the grouping needs). Last on the line on purpose, and jq's `@tsv` escapes embedded tabs/newlines so a title can never split a field or forge a record.

**`scripts/jobs/ci-watcher.sh`** — reads the new column into a throwaway so it can't be appended onto `updated_at` and corrupt the activity-window comparison.

**`scripts/jobs/dependabot-watcher.sh`** — a supersession preflight now runs over the enumerated dependabot PRs before the posting loop. It groups them by the package their title says they move; a group of one is untouched. In a group of several the dominating member is the greatest target version (`sort -V`, ties to the higher PR number) and gets the full review. Every other member is either:

- an **identical target** → literal duplicate, dominated with no API call at all (the #561/#560 shape);
- a **different target** → the containment oracle decides, `behind_by == 0` being the proof (#562/#869);
- **anything else** — non-zero `behind_by` (divergent release line), unresolvable upstream/tag, API failure, unparseable title → **falls open** to the full review.

Dominated PRs get a cheap close-as-superseded body carrying the peer PR URL and the exact compare result, instead of commissioning a review whose only output would be "REJECT, superseded". The preflight only ever removes work it has *proven* redundant.

**`scripts/jobs/handlers/dep-compare-gh.sh`** (new) — the containment oracle. Resolves the package's own upstream (a github-actions name *is* the repo slug; an npm name resolves through the registry's `repository.url`), resolves each version to a real tag by probing a fixed convention set through `git/matching-refs` (a miss costs no 404 and no retry noise; the package-qualified convention leads for npm so a monorepo's bare `v1.2.3` can't compare the wrong history), then compares. Every failure exits non-zero with empty stdout — prove it or fall open.

**The #268 leg** (base already pinning newer than the PR proposes) is repo-shaped and not readable from PR metadata, so it stays as a named **first step** in the full review body, telling the botanist to stop there if the base is already at or past target.

### Injection safety

Adding `title` brings author-controlled text into a watcher that was injection-safe by construction, so it is fenced by one rule: a title may only be *matched* against the fixed `bump <pkg> from <a> to <b>` form, and only the captured package/version fields — re-validated against `[A-Za-z0-9._@/-]` and `[A-Za-z0-9.+_-]`, charsets admitting no whitespace or punctuation an instruction could be written in — reach a job body. The title is never echoed and never reaches `claude -p`.

### Verification

- `dependabot-watcher-test.sh`: **42 pass**, up from 20 — new cases G–M cover literal duplicate (asserting the oracle is *not* consulted), proved containment with evidence in the body, divergent line falls open, unprovable falls open, ungrouped titles, different packages, and an injection case asserting no fragment of three hostile titles reaches any job body.
- `ci-watcher-test.sh`: **49 pass**, no regression from the new column.
- Oracle verified **live**: `actions/setup-node` 4→5, `ses` 1.13.0→1.14.0 and `@endo/marshal` 1.6.1→1.6.2 (both `endojs/endo`, package-qualified tags), the reversed/divergent direction (`behind_by=7`), and both failure paths.
- Parser verified against the repo's **real** titles (`chore: bump X from a to b`) and against the grouped-update, multi-package and requirement forms, which are correctly left ungrouped.
- End-to-end run with the real oracle against a throwaway journal reproduced the #562/#869 case: #869 full review, #562 cheap close carrying `capricorn86/happy-dom/compare/v18.0.1...v20.11.0 → behind_by=0`.

### Follow-ups

- The **npm registry** lookup is a new outbound dependency (`curl` to `registry.npmjs.org`, bounded at 20s, seam `GARDEN_NPM_REGISTRY`). It only fires for a group with a genuine version disagreement on an npm package; a failure falls open, so an outage costs redundant reviews, never a wrong close.
- Dependabot's **grouped-update** PRs (`Bump the npm_and_yarn group with 3 updates`) are deliberately ungrouped — the title names no single package. If those become common on a watched repo, reading the moved set from the PR body or diff would extend the preflight's reach.
- Unrelated pre-existing condition, untouched: `git gc` in the shared root repo reports `unable to read 9ad05cc3563a7ba4b8f3a0b3e7941090e4d427d6` / `failed to run repack`, with a stale `gc.log` under `.git/worktrees/`. Commits, fetch, rebase and push all worked; repacking does not. Worth a sysop look since it affects the whole host, not just this worktree.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/improve-dependabot-supersession-preflight.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 3 on 1 host(s)
- Input: 90 tokens (4287218 cached reads)
- Output: 61636 tokens
- Cost: $6.094868999999999
- Wall-clock: 852s

<!-- garden-usage-end -->
