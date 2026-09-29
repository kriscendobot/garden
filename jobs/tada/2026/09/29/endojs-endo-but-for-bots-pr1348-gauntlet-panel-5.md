Panel round 5 on endojs/endo-but-for-bots#1348 came back **must-fix**, for the same reason as rounds 3 and 4. A fixer can't clear it: it needs a maintainer decision.

**What I ran**
- Checked out the PR head in an isolated worktree. The head is `c193f194` on `endojs:build/daemon-agent-tools-explicit-harness`, which is on the base repo, not a fork.
- Ran `GARDEN_PANEL_SINGLE_ROUND=1 panel.sh` against the PR's actual base commit `54d65400` (`llm-54d6540`), not a possibly stale `origin/llm-54d6540`.
- `panel.sh` exited 0 with disposition `must-fix`. All 33 seats ran ok: 27 approved, 5 were comment-only, and 1 (integrator) requested changes. The phase/evidence pre-pass flagged the ledger for comparison against the design.
- Posted the verdict as review 5347587371: https://github.com/endojs/endo-but-for-bots/pull/1348#pullrequestreview-5347587371. GitHub refused request-changes because the bot owns the PR, so it went up as COMMENTED, the same as rounds 3 and 4.

**Findings**
- **Must-fix (integrator):**
  1. The new `@endo/agentry/workspace-agent` harness is new JSON-tool work, which the #731 parking forbids.
  2. The ledger says `deliverable` while its own Draft-hold is still open and Phase 4 is deferred.
  3. The design's "Remaining" text and its parking section give contradictory directions.
- **Should-fix:**
  - The collision guard's failing path has no test (breaker, wire-watcher).
  - The rename table is keyed by group-name strings (purist).
  - `readOnly` is a runtime flag rather than a real restriction (locksmith).
  - `workspaceGrants` overlaps with the grants from #965.
  - The commits need regrouping.
- **Fixed since round 4:** scribe's missing-summary must-fix is resolved, and the earlier `harden`, README and `@endo/errors` findings no longer come up.

**Follow-up:** I messaged the maintainer inbox that the decision is theirs. Either lift the #731 parking for this slice and record that in `designs/daemon-agent-tools.md`, or keep #1348 as a held draft. More fix rounds won't clear this blocker, so the gauntlet will likely hit its review budget unless that decision comes first.

<!-- gauntlet-stage-result: panel=must-fix -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1348-gauntlet-panel-5.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 38 tokens (1040071 cached reads)
- Output: 7200 tokens
- Cost: $0.8323822
- Wall-clock: 477s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
