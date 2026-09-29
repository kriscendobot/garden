**Viability report: kriscendobot/minion.town PR #68, gauntlet `kriscendobot-minion-town-pr68-gauntlet-20260929`**

**Result: proceed.** PR #68 is still needed and nothing newer has replaced it. The gauntlet can begin.

PR facts: it is OPEN, unmerged and not a draft. Head is `feat/weblet-publish-dir` at `b00cb22`. Base is the frozen `main-b32291d`.

Deciding question: Does current `main` already have a way to publish a clip from content stored in the guest, or has another PR taken over that work, so that callers no longer have to paste large files inline as base64 over MCP?

Answer: no.

Evidence:
- **`main` has no equivalent.** Current `main` contains no `publishNamedContent`, `resolveNamedContent`, or any similar tool under `src/`. The only way to publish is still the inline `publish` tool, which takes each file's bytes as base64 (`src/endo/guest-tools.ts:544`). That inline path is the problem this PR exists to fix.
- **New `main` commits since `b32291d` are unrelated.** They cover the git-remote (#86, #136), SIWE design (#80), the Endo pin bump (#138) and Claude delegation (#120). None touch clip publishing by named content.
- **No other PR does this.** A search of all PRs found no competing or replacing one. The nearby open clip PRs are about something else: content-store GC (#83, #93), publish hardening (#100) and upgrade semantics (#88).
- **The maintainer still wants it.** kriskowal approved the PR on 2026-09-02 and again on 2026-09-05, and asked us to "conduct, deploy, and validate in production". Since then the PR was rebased onto `main-b32291d` with green CI (2026-09-28), and round-6 panel fixes were pushed at `b00cb22` today (2026-09-29T19:28Z).

The GitHub REST quota ran out partway through, so I checked `main` with a git fetch instead of the API. I could not tell whether #65, which the PR body links, is an issue, because the pull-request lookup found no PR with that number. That does not change the result.

Changes: none. This stage only reads; I made no commits, pushes or PR edits.

<!-- gauntlet-stage-result: viability=proceed -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion-town-pr68-gauntlet-20260929-viability.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 12 tokens (283697 cached reads)
- Output: 2150 tokens
- Cost: $0.48725939999999995
- Wall-clock: 135s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
