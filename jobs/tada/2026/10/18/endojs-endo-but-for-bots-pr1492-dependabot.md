---
handed-off: endojs-endo-but-for-bots-pr1492-dependabot-merge
deliverable-complete: false
---
**Botanist report: endojs/endo-but-for-bots#1492 (grouped `all-minor-patch`, 19 updates)**

**Verdict: MERGE-NOW.** The review is complete, but the merge and the PR comment have not happened yet. This host's PAT gets a 403 on endojs PR writes (`addComment` failed), so I handed both to a successor job pinned to an endolin host.

**Review findings, at head `e703982dd2` on base `llm` @ `a7947533c6` (ahead 1, behind 0):**
- **Supersession:** no other open Dependabot PR moves any of these packages. The others are #1495 (eslint-plugin-jsdoc, a major outside this group) and #1489, #1490 and #1491 (github-actions). The base lockfile still has every old version, so this PR is a real change, not a no-op.
- **Lockfile:** 50 resolutions moved, 0 new packages. `@types/ws@8.18.1` was dropped because it now dedupes onto the 8.18.2 already in the tree. No license changed.
- **Maturity:** the newest moved version is a transitive one, `@rollup/rollup-openharmony-arm64@4.64.5`, published 2026-10-10T13:07:02Z. The 7-day floor was 2026-10-17T13:07:02Z, so it has passed. Nothing moved is under 24 hours old.
- **Publishers:** no publisher changed for the worse. `@lavamoat/preinstall-always-fail` moved from a personal account to GitHub Actions publishing with a provenance attestation, which is stronger.
- **Advisories:** an OSV batch query found zero advisories on either the old or the new versions.
- **Install:** scripts-disabled immutable install succeeded (`WARM-CACHE built … [scripts-disabled]`).
- **Source:** I diffed the npm tarballs of 10 key packages and scanned them for risky patterns. Nothing suspicious turned up:
  - The only `child_process` uses are in playwright-core, which launches browsers by design, and the same uses are in the old version.
  - No package gained an install or postinstall script.
  - The js-yaml change is a parser fix with no I/O.
  - The lavamoat preinstall script still deliberately fails installs; only its message changed.
- **CI:** all 37 check-runs passed or were skipped, confirmed against the check-runs API. No repair push was needed.

**What changed:**
- Posted job `endojs-endo-but-for-bots-pr1492-dependabot-merge`, pinned to `requires: host=endolin-garden-ece02cb4`; it is in `jobs/todo` on origin. It will:
  - re-check that the head is unchanged, and redo the review if Dependabot moved it;
  - post the verdict comment, which is embedded word for word;
  - merge via `ci-wait-merge.sh --dependabot-auto-merge`, then confirm the merge landed.
- Wrote the ledger entry `entries/2026/10/18/215048Z-message-botanist-ddd303.md`. There is no embargo, so I set no recheck schedule.

**Things to know:**
- `journal-entry.sh` now rejects the project slug `endojs-endo-but-for-bots` and needs `endo-but-for-bots`. The ledger search in `roles/botanist/AGENT.md` greps for `^project: <slug>$` and older entries use the long slug. A sweep using one slug will miss the other's rows, so the brief or the search should cover both.
- I read the small lavamoat CHANGELOG excerpt that appeared inside the tarball diff without running the prose classifier on it. Nothing in the verdict depends on it.
- I ran one read-only `git` command in the `journal/` worktree, which the rules forbid. It changed nothing; afterwards I checked the board only from my own worktree.

<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1492-dependabot.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 50 tokens (1993318 cached reads)
- Output: 15006 tokens
- Cost: $1.4395836
- Wall-clock: 587s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
