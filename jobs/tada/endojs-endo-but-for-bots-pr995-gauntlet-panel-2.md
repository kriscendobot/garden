The round 2 panel verdict is posted as a COMMENTED review. The panel stage is complete — one round run, disposition posted, no fixing or un-drafting. This is a garden-development worktree with no commits owed (all work was posting to the project PR).

---

**Completion report**

Ran gauntlet stage PANEL round 2 for endojs/endo-but-for-bots PR #995 (`design(endo-claude): confined claude -p inference for one guest facet`).

**What I did:**
- Resolved the PR head (endojs/endo-but-for-bots @ `design/endo-claude`, base `llm`) and created an isolated project worktree.
- Ran `panel.sh` in `GARDEN_PANEL_SINGLE_ROUND=1` mode against the worktree at head `8ae8b364a8`. The code panel (28 seats) fanned, aggregated, and returned disposition **must-fix**.
- Synthesized the 112 KB, 28-seat aggregate (which exceeds GitHub's review-body limit) into an ~11 KB panel verdict matching round 1's shape: roster (22 request-changes, 3 comment-only, 3 approve), 8 convergent must-fixes, recurring should-fixes, and doc-hygiene items.
- Posted it as a review on PR #995. `--request-changes` was rejected (own-PR by the bot identity, same as round 1), so posted as a **COMMENT** review — the panel-verdict shape the next-stage heuristic recognizes for a must-fix on an own PR.

**Convergent must-fixes surfaced:** argv injection via variadic flags / bare-positional prompt; unvalidated allow-list tool names; open-ellipsis deny set over a version-pinned surface; `--bare` misattribution (vs `--safe-mode`); `ClaudeCredentials` reuse falsified by the live caplet guard; stdio shim leaking the unattenuated daemon socket; unspecified path/mode/lifetime of generated credential files; hardcoded `/run/endo-daemon/endo.sock` vs `whereEndoSock`.

**Follow-ups:** The next gauntlet stage (fix-loop) owns remediation — do not fix here. Seats repeatedly flagged that the worktree's local `llm` ref was ~575 commits stale (a 3,483-file phantom diff); the panel harness should reset the base ref to its remote-tracking tip before fanning seats.

No garden-repo changes; nothing to commit or push.

<!-- gauntlet-stage-result: panel=must-fix -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr995-gauntlet-panel-2.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 32 tokens (988396 cached reads)
- Output: 12006 tokens
- Cost: $1.5181460000000002
- Wall-clock: 735s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
