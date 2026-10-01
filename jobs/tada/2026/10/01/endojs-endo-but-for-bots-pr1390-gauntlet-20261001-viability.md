Viability verdict: **proceed**. PR #1390 is still open and needed, and nothing newer has replaced it.

**Deciding question:** Does the live `llm` branch still accept a bare-string pet name (quietly turning `"name"` into `["name"]`), so that the change kriskowal asked for in the #1343 review (accept pet-name paths only, as arrays) has not landed some other way?
Answer: yes, it still accepts bare strings. So the PR has not been superseded, and the reason for it still holds.

**Evidence:**
- **PR state:** #1390, "feat(daemon)!: accept only pet-name paths, reject bare pet-name strings", is OPEN, a draft, and not merged. Its head is `build/pet-name-path-only` @ `784decdc7a` and its base is the frozen `llm-8e53cc0` (`8e53cc0f89`). CI is green at that head.
- **Live `llm` (`80054c3453`, fetched just now) still accepts bare strings:**
  - `packages/daemon/src/pet-name.js:148-152`: `namePathFrom` still does `typeof nameOrPath === 'string' ? [nameOrPath] : nameOrPath`, so a bare string is still converted rather than refused.
  - `packages/daemon/src/type-guards.js:29-33` still defines `NameOrPathShape` and `NamesOrPathsShape`, which this PR removes.
- **Nothing on `llm` competes with it:** 28 commits have landed since the frozen base, and none of them touch pet-name paths or bare-string handling. Searching PR titles finds only #1144, an earlier and narrower send-path fix that this PR builds on.
- **The motivation is still current:** the change comes straight from kriskowal's review on #1343 (pullrequestreview-5360774903). #1343 is still an open draft. It reshapes endowment values, which is a separate change, so the two PRs combine rather than one replacing the other.
- **The remaining review problems are follow-up work, not a sign it's outdated:**
  - The previous gauntlet stopped at its review budget (`review-budget-reached`, 6 rounds, CI green).
  - The latest panel, round 4 on head `784decdc7a`, still came back must-fix: 6 request-changes and 19 items.
  - Those items are leftover string-to-path call sites, such as `floot/src/container-mounts.js:305` and the `journalName` → `storeValue` path, plus a design phase-ledger mismatch.
  - That is unfinished migration work for the fix loop to handle.

GitHub's REST API rate limit ran out partway through these checks, so I checked live `llm` with a git fetch into an isolated project worktree instead. No clean, panel, fix, CI-wait or un-draft budget was spent.

<!-- gauntlet-stage-result: viability=proceed -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1390-gauntlet-20261001-viability.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 12 tokens (303357 cached reads)
- Output: 2688 tokens
- Cost: $0.5522554
- Wall-clock: 45s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
