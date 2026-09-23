The panel verdict is posted (12,978-char COMMENTED review with the `## Panel verdict: request-changes (must-fix)` header the next-stage heuristic recognizes). Panel round 4 is complete: disposition **must-fix**. Per this stage's contract I stop here — no fix, no un-draft.

---

**Completion report**

- **Stage:** Gauntlet PANEL round 4 for endojs/endo-but-for-bots PR #995 (`design(endo-claude)`), single-round mode. One round, verdict posted, stopped.
- **Setup:** Resolved PR head (endojs fork, branch `design/endo-claude`, base `llm`, head `f83464a877`), took an isolated project worktree via `ensure-project-worktree.sh`.
- **Ran:** `GARDEN_PANEL_SINGLE_ROUND=1 scripts/jobs/gardening/panel.sh <wt> 995 llm` → exit 0, terminal disposition `must-fix`. 28 design-panel seats: **22 request-changes, 5 comment-only, 1 approve.**
- **Posted:** Curated aggregate as a `gh pr review` on PR #995. `--request-changes` was rejected by GitHub (kriscendobot is the PR author — cannot request changes on its own PR), so it fell back to `--comment`, matching prior rounds. Landed at `2026-08-16T08:48:36Z`, header `## Panel verdict: request-changes (must-fix)`.
- **Convergent must-fixes** (drivers for the next fix-loop): (1) the `ENDO_SOCK` scrub is not a confinement boundary — `whereEndoSock` derives the socket path with an empty env (10 seats, most convergent); (2) the fail-closed argv invariant is unsatisfiable as written; (3) the negative-confinement test passes vacuously — no positive-reachability assertion; (4) DD8's return taxonomy is both settled and open, no discriminant; (5) package shape yields 4 accidental public entry points, unnamed export/`exports` map; plus enforcement-on-wrong-side-of-boundary, dunder/prototype-pollution in the name validator, `revoke` no-op on the happy path, tool-results as a second attack input + cancellation not killing the child, env denylist-of-one, slice/loopback mutual exclusivity, ambient-authority `infer` signature, README/roadmap/PR-description sync, and a missing cross-round summary comment.
- **Follow-ups:** None owned by this stage. The gauntlet's next stage (fix-loop) owns the must-fix items. No garden-repo changes were made; no commit/push to main2 was needed.

<!-- gauntlet-stage-result: panel=must-fix -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr995-gauntlet-panel-4.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 34 tokens (1085191 cached reads)
- Output: 15147 tokens
- Cost: $1.9310685
- Wall-clock: 795s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
