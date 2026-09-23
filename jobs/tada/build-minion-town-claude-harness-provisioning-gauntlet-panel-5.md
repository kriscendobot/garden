The review is posted. The panel round completed with a **must-fix** disposition. This stage is done — I do not fix, un-draft, or loop.

Panel round 5 on kriscendobot/minion.town PR #99 ("feat(deploy): provision pinned Claude harness") is complete.

**What I did:**
- Resolved the PR head (kriscendobot/minion.town @ `build/claude-harness-provisioning`) and base (`main-b83741a` / `b83741a3543cc598cdd7fe513243c35df24ba5db`).
- Got an isolated project worktree of the head and ran `panel.sh` in `GARDEN_PANEL_SINGLE_ROUND=1` mode against it.
- Panel fanned 30 seats and aggregated to disposition **must-fix** (4 seats request-changes: archivist, integrator, locksmith, purist; the rest comment-only/approve).
- Posted the aggregate as a `gh pr review`. A `--request-changes` review was rejected (GitHub forbids requesting changes on your own PR, and the bot authored this PR), so — matching the convention of rounds 1–4 — I posted a **COMMENTED** review whose body carries the `disposition: **must-fix**` header the next-stage-owed heuristic recognizes.

**Blocking (must-fix) findings surfaced:**
1. README rollback prose contradicts `deploy-app.sh` (staged vs post-promotion smoke; no-predecessor case).
2. `designs/claude-agents-capability.md` status line overclaims "Step 1 … has landed" when only the version-pin sub-clause shipped.
3. Docker runtime image puts `claude` on root's PATH, breaking the ownership-enforced capability-denial invariant the EC2/SSM path upholds.
4. `inspect-image.sh` credential-env blocklist omits `CLAUDE_CODE_OAUTH_TOKEN`.

Plus notable comment-only items (typist code-point retypes, stylist field-name drift, missing coverage report, fast-check property-test proposals).

**Follow-ups:** none for this stage — the gauntlet's fix stage owns resolving the must-fix items. No fix/un-draft/loop performed, per stage scope.

<!-- gauntlet-stage-result: panel=must-fix -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/build-minion-town-claude-harness-provisioning-gauntlet-panel-5.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 32 tokens (824442 cached reads)
- Output: 7580 tokens
- Cost: $1.19898
- Wall-clock: 629s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
