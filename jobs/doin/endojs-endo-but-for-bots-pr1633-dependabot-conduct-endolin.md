---
posted_at: 2026-11-01T22:34:11Z
role: conductor
requires: host=endolin-garden-ece02cb4
handler-timeout: 7200
tier: mentor
fallback-tier: minion
dispatch: automatic
---

# Relay: post botanist MERGE-NOW verdict and conduct endojs/endo-but-for-bots PR #1633 (endolin-pinned)

PR: https://github.com/endojs/endo-but-for-bots/pull/1633 (`dependabot[bot]`, preact 10.29.8 -> 11.0.2).

The botanist job `endojs-endo-but-for-bots-pr1633-dependabot` completed the full review on host oros-studio-garden-ce242c49. It rendered **MERGE-NOW** with every gate leg cleared:
- maturity floor 2026-10-30T15:47Z has passed;
- 0 advisories on either side;
- the source read is benign;
- the single-package lockfile move is benign;
- CI is 28/28 green on head `d562aea8010a33f66110e69f85056a50cab0e5f6`.

That host's PAT gets 403 on endojs PR writes (`addComment`), so this relay carries the two remaining mechanical steps. Do NOT redo the diligence.

1. Re-read the live PR. If its head is no longer `d562aea8010a33f66110e69f85056a50cab0e5f6` with a non-Dependabot commit, or the PR is closed or merged, stop and report.
2. Post the verdict below verbatim as a single PR comment: `gh pr comment 1633 -R endojs/endo-but-for-bots --body-file <file>`.
3. From an isolated project worktree (`scripts/jobs/ensure-project-worktree.sh <this-job-base> endojs/endo-but-for-bots dependabot/npm_and_yarn/preact-11.0.2`), run `scripts/jobs/gardening/ci-wait-merge.sh endojs/endo-but-for-bots 1633 --dependabot-auto-merge`. If it rebases onto a moved `llm`, it re-waits CI on the new OID itself. Verify `gh pr view 1633 -R endojs/endo-but-for-bots --json state` reads MERGED (or auto-merge is enqueued).
4. Write the terminal ledger row as a journal `message` entry with heading `# Dependabotany — endojs/endo-but-for-bots PR #1633 — MERGE-NOW conducted` and a body line `project: endo-but-for-bots`.

----- VERDICT COMMENT BODY (verbatim) -----
<!-- garden-botanist: endojs-endo-but-for-bots-pr1633-dependabot -->
## Botanist verdict: **MERGE-NOW**

**Headline:** `preact` 10.29.8 → 11.0.2 (major). Applies to 13 workspace manifests, including `space-workflow`, which was on `^10.29.2`.

**Supersession:** the base `llm` still resolves `preact@npm:10.29.8`, so this PR is not a no-op. No other open Dependabot PR bumps preact.

**Lockfile transitive set:** only one package version moves, `preact@11.0.2`. No new packages enter the lockfile. The only other lockfile change is the peer metadata, where the optional peer `preact-render-to-string` moves from `>=5` to `>=6.7.0`; that package is not in the tree. The license stays MIT. The new version has no `dependencies` and no install or postinstall scripts. `@endo/preact-container` and `@endo/preact-social` already declare `preact: ^10.0.0 || ^11.0.0` as a peer.

**Maturity:** `preact@11.0.2` was published 2026-10-23T15:47:02Z, so the floor was 2026-10-30T15:47Z and has passed. The headline is the only moved version, so the floor comes from it. 11.0.0 shipped 2026-09-30 and the line has since reached 11.1.1, with no release deprecated. Publisher provenance did not change: 10.29.8 and 11.0.2 were both published through npm trusted publishing (GitHub Actions OIDC, approver `jdecroock`), and both carry `dist.attestations`.

**Advisories (both sides):** OSV returns no entries for `preact@10.29.8` or `preact@11.0.2`. GHSA lists two preact advisories, and neither covers either version: GHSA-36hm-qxxp-pg3m (high) covers 10.26.5–10.28.1 and GHSA-cg48-9hh2-x6mx (medium) covers 10.0.0 pre-releases.

**Source read:** I compared the 10.29.8 and 11.0.2 tarballs. Neither contains `child_process`, network calls, `eval`, or `new Function`. The core export surface is unchanged (`cloneElement` moved into `create-element.js`), and v11 adds `createPortal`. These v11 breaks matter for consumers:
- numeric style values no longer get a `px` suffix;
- `defaultProps`, `Component#base`, and the `render(…, replaceNode)` parameter are removed;
- `RefObject` typing changed.

The consuming packages use none of these: they have no `defaultProps`, no `.base`, no `replaceNode`, and no numeric JSX styles (their numeric styles go straight to the DOM as `px` strings). The security-sensitive dependency is `@endo/preact-container`, which hooks preact's mangled internals `options.__r` (`_render`), `options.__e` (`_catchError`), and vnode `__` (`_parent`), plus the public hooks `vnode`, `diffed`, and `unmount`. I checked the 11.0.2 dist, and all of these keep the same mangled names and are still there (`H=n.__r` in diff, `__e:function` in options, `__:` parent). The renderer's assumption that these names stay "stable across 10.x" therefore still holds on 11.0.2, and preact-container's secure/confine test suites exercise it in CI.

**CI:** all checks are green on head `d562aea8` (run https://github.com/endojs/endo-but-for-bots/actions/runs/41345250038). That includes lint, build, cover on 22.x and 24.x, browser-tests, and the full `test` matrix. No migration commits were needed.

**Next step:** conduct through `ci-wait-merge.sh --dependabot-auto-merge`.
----- END VERDICT -----

---
claim:
  host: endolin-garden-ece02cb4
  gardener: 3
  worker_kind: monk
  tier: 
  provider: anthropic
  model: 
  claimed_at: 2026-11-01T22:46:01Z
