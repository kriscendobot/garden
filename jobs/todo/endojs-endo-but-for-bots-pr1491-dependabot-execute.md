---
role: botanist
requires: host=endolin-garden-ece02cb4
tier: mentor
fallback-tier: minion
dispatch: automatic
---

# botanist (execute MERGE-NOW) on endojs/endo-but-for-bots PR #1491

The botanist review of https://github.com/endojs/endo-but-for-bots/pull/1491 (`actions/download-artifact` 4.3.0 → 8.0.2, author `dependabot[bot]`) is **done**: the verdict is **MERGE-NOW**, rendered by job `endojs-endo-but-for-bots-pr1491-dependabot`. That job ran on oros-studio-garden-ce242c49. Its bot PAT gets a 403 on endojs PR writes (`addComment`), so it could neither post the verdict nor conduct the merge. This job is pinned to endolin, and its only task is to **execute** that verdict. Do NOT redo the review.

Wear roles/botanist/AGENT.md § Autonomous disposition. Steps:

1. Re-fetch live PR state. If the PR is closed or merged, or its head is no longer `31f94a4ad87352580dfe857a747652ab06441f06` with only workflow-file edits by `dependabot[bot]`, run step 1 of the botanist review again (base census plus tag→commit pin check) before acting. A Dependabot rebase onto a newer base is fine as long as the diff still pins `actions/download-artifact@9000827ccba6bdab643e8b6fd33ac0654aef8333 # v8.0.2` at 4 sites.
2. Post the verdict below as ONE PR comment (`gh pr comment 1491 -R endojs/endo-but-for-bots --body-file …`), unless a comment carrying `<!-- garden-job: endojs-endo-but-for-bots-pr1491-dependabot -->` already exists.
3. From an isolated project worktree (`ensure-project-worktree.sh <this-base> endojs/endo-but-for-bots dependabot/github_actions/actions/download-artifact-8.0.2`), conduct the merge with `scripts/jobs/gardening/ci-wait-merge.sh endojs/endo-but-for-bots 1491 --dependabot-auto-merge`. Do not name a merge method. Before reporting, confirm `gh pr view 1491 --json state,autoMergeRequest` shows MERGED or auto-merge enqueued. If it stalls `needs weave` or `ci red: needs shepherd`, route accordingly.
4. Append a terminal ledger row: a journal `message` entry with heading `# Dependabotany`, a line `project: endojs-endo-but-for-bots`, and PR #1491 MERGE-NOW (floor 2026-10-14T10:09:51Z from actions/download-artifact@8.0.2, past).

----- VERDICT COMMENT (post verbatim) -----
## Botanist verdict: **MERGE-NOW**

**Headline:** `actions/download-artifact` 4.3.0 → 8.0.2 (`github-actions` ecosystem, 4 call sites: `ci.yml` ×1, `familiar-release.yml` ×3).

**Base census (`llm`):** all 4 `download-artifact` sites on the base pin `d3f86a10` (v4.3.0). The base is uniformly behind the target, so the PR is not superseded. The watcher found no sibling Dependabot PR moving this action. Head is ahead 1, behind 2.

**Pin provenance (tag → commit, resolved 2026-10-18T21:54Z):**
- `v8.0.2` → `9000827ccba6bdab643e8b6fd33ac0654aef8333` (lightweight tag) equals the incoming pin ✅
- `v4.3.0` / `v4` → `d3f86a106a0bac45b974a628896c90dbdf5c8093` equals the outgoing pin ✅
- `uses:` owner is `actions/download-artifact` on every site.

**Maturity:** v8.0.2 was published 2026-10-07T10:09:51Z, so the floor was 2026-10-14T10:09:51Z and has passed. There is no lockfile, so this one release is the whole moved set.

**Advisories (GHSA `ecosystem=actions` + OSV):** the only advisory on this action is GHSA-cxww-7g56-2vh6 (high, `>= 4.0.0, < 4.1.3`). It affects neither 4.3.0 nor 8.0.2. Both sides are clean, and the upgrade does not close a CVE.

**Source read** (`v4.3.0...v8.0.2` `src/` + `action.yml`, and the `v8.0.1...v8.0.2` bundled `dist/index.js`). No new network endpoints, child processes, eval, or telemetry. The `src/` changes add the `skip-decompress` and `digest-mismatch` inputs and move the runtime to `node24`. v8.0.2 itself bumps `@actions/artifact` 6.2.1 → 6.3.1 (`@azure/storage-blob` 12.31.0, `@octokit/request` 10.0.8, a 429 retry path, and the `json-with-bigint` JSON parser) and drops the protobuf codegen from runtime deps.

Behavior changes checked against this repo's usage:
- **A pattern that matches exactly one artifact now extracts into `path` itself, not `path/<name>`.** `compare-ironhorse-math` reads `math-vectors/math-test-ironhorse*/…`, and `math-test-ironhorse*` always matches three artifacts, so the layout is unchanged. That job ran green on this head. `familiar-release` collects `familiar-*` (3 matrix legs) and the release step globs `artifacts/**/*`, so it does not depend on layout. The two `name:` downloads are single-artifact either way.
- **`digest-mismatch` now defaults to `error`.** Every artifact is produced in the same run by `upload-artifact` v7.0.1, so digests should match. Failing on a mismatch is the safer default.
- **`node24` runtime.** All consuming jobs run on GitHub-hosted runners.

No upstream prose (changelog, release body, README, PR body) was read. Only metadata and source were used, so no foreign-content classification was needed.

**CI:** 39/39 check runs succeeded on head `31f94a4a` (cross-checked through `/commits/<sha>/check-runs`). `familiar-release.yml` runs only on release tags and is not exercised by PR CI. Its download sites use the same inputs as above.

**Next:** conducting through `ci-wait-merge.sh --dependabot-auto-merge`. This rebases onto the live base and re-waits for CI if the head is behind.

<!-- garden-job: endojs-endo-but-for-bots-pr1491-dependabot -->
----- END VERDICT -----
