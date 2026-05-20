---
ts: 2026-05-20T05:21:38Z
kind: result
role: fixer
dispatch_id: 824ab7
dispatch_root: /home/kris/dispatches/fixer--824ab7
project: endo-but-for-bots
prs:
  - repo: endojs/endo-but-for-bots
    pr: 290
    role: target
---

# Result fixer 824ab7 — retcon PR #290 (feat/lal-pi-harness)

kriskowal asked for a standard retcon on PR #290 at 2026-05-20T05:14:23Z.

## Merge-base and pre/post heads

- Base branch: `llm`.
- Merge-base with `llm` (at fetch time): `65d3093cc1f7d934050c2a4de4a10dccbec74eb1` (`feat(lal): deterministic provider replay (DI, mock-powers) (#293)`).
- Pre-retcon head: `6c17b25d3a90a2293a421bb014aa4a20c24961b9` (`docs(lal): drop overstated SmallCaps transparency claims (per kriskowal #290)`).
- Post-retcon head: `02eaaf2dd9e57f99b49e36402b775c2584ae90ac`.

Note: my local dispatch snapshot was stale by 13 commits when I started (concurrent fixer work had landed since prepare). Re-fetched and reset to the actual remote tip before retconning. Pre-retcon tag was retaken against the real tip.

## New commit topology

| SHA | Type | Message |
| --- | --- | --- |
| `4c2d62ef2` | refactor | `refactor(lal): adopt @endo/genie's pi-based agent harness` |
| `02eaaf2dd` | chore | `chore: Update yarn.lock` |

All affected paths live under `packages/lal/` (one package commit) plus `yarn.lock` (separated per yarn-lock-separate-commit). Implementation + tests are bundled in the package commit per the retcon discipline.

## Invariance verification

```
git diff origin/llm..pre-retcon-824ab7 --stat   # 15 files, +1599 / -1679
git diff origin/llm..HEAD --stat                # 15 files, +1599 / -1679 (identical)
git diff pre-retcon-824ab7..HEAD                # empty (tree-identical)
```

Net diff against base unchanged.

## Pre-push gates (diff-only scoping)

Ran `pre-push-gates.sh --probes-only --summary` with a temporary `_retcon-scratch` branch tracking `origin/llm` so the probes' fallback diff resolved correctly (default fallback used `origin/master`, which over-scoped against `llm` branch's accumulated history). Four findings, all of which ride along with content the PR already introduced (not regressions caused by the retcon):

- **no-inline-import-jsdoc**: `packages/lal/agent.js:59` — pre-existing in the PR's `@typedef` for `LalToolDef.params`.
- **no-pull-citations**: bare `#<n>` in `packages/lal/test/pi-agent-tools.test.js` and `packages/lal/test/smallcaps-footgun.test.js` — both reference the originating PR #290 in comments.
- **sentence-per-line-md**: 8 multi-sentence lines across `packages/lal/LAL-ARCHITECTURE.md`, `packages/lal/README.md`, `packages/lal/primer/README.md`.
- **security-md-hash-uniform**: `packages/endo/SECURITY.md` missing — repo-wide invariant, not in this PR's diff; pre-existing on `llm`.

The retcon's net-diff invariant precludes touching any of these in this dispatch. Available as a follow-up fixer pass if the maintainer wants them addressed.

## Force-push

`git push --force-with-lease=feat/lal-pi-harness:6c17b25d3a90a2293a421bb014aa4a20c24961b9 origin HEAD:feat/lal-pi-harness` succeeded after refresh; the first attempt with the stale local SHA was correctly rejected ("stale info") and forced me to re-fetch.

## Summary comment

Posted at https://github.com/endojs/endo-but-for-bots/pull/290#issuecomment-4494769569 with the new commit topology table and "Net diff against base unchanged." line. Also surfaced the four diff-scoped gate findings so the maintainer can decide whether to dispatch a follow-up fixer.

Self-improvement: dispatch-prepare's project worktree can be stale at start when concurrent fixer work landed between dispatch creation and the subagent's first command; the retcon procedure should explicitly include `git fetch origin <head-branch>` before computing the pre-retcon tag, and the retcon skill's "save a pre-retcon reference" step should call this out so a stale-local pre-retcon tag does not silently scope the retcon to an outdated diff. Worth landing in `skills/retcon/SKILL.md` § Procedure (step 0: fetch and verify the local tip equals the remote tip before tagging).
