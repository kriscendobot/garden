The review posted successfully as a COMMENTED review carrying the must-fix disposition. This is a garden PROJECT-repo review job — no garden `main2` code changed, so nothing to commit or push in my worktree.

## Completion report

**Job:** Gauntlet PANEL round 5 for endojs/endo-but-for-bots PR #989 (`design(worker): embargo outbound until a worker quiesces after delivery`).

**What I did:**
1. Ran the container guard (clean, inside container) and resolved the PR head: `endojs:design/worker-quiescence-embargo`, base `llm`, HEAD `6a6c4d50c`.
2. Set up an isolated project worktree keyed to this job's base.
3. Ran the panel in single-round mode (`GARDEN_PANEL_SINGLE_ROUND=1`) against the worktree, base ref `origin/llm`. Seven seats ran (critic, skeptic, decomplector, ergonomist, copyeditor, pedant, novice), all exited `ok`. Panel disposition: **must-fix**.
4. Posted the aggregated seat verdicts as a `gh pr review` on PR #989. A `--request-changes` review was rejected (GitHub forbids requesting changes on one's own PR — the PR is bot-authored), so I posted it as a `--comment` review with the **must-fix** disposition stated explicitly in the header and summary. Confirmed submitted at 2026-08-18T04:44:47Z.

**Outstanding must-fix items surfaced (for the next fix stage):**
- **skeptic [must-fix]:** The OCapN-coverage premise is false — `@endo/ocapn` is not layered over `@endo/captp`; the design's `pumpOptions`/`makeMessageCapTP` mechanism never reaches OCapN's real dispatch path, and the Affected Components table lists no `packages/ocapn*` rows. Either scope OCapN out or add the missing rows/mechanism.
- **pedant [must-fix]:** 38 em-dashes remain in prose despite panel-1 and panel-2 commit messages claiming a sweep; needs a real grep-driven sweep per `skills/em-dash-style/SKILL.md`.
- Several should-fix items (cross-language config-key binding, stuck-crank warning shape/assertion, forward-referenced Decision citations, paragraph splits, copyedit fixes) are in the posted aggregate.

**Follow-ups:** none from me — this is one stage; I did not fix, un-draft, or loop. The gauntlet's next fix stage owns the must-fix items.

<!-- gauntlet-stage-result: panel=must-fix -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr989-gauntlet-panel-5.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 25 tokens (614440 cached reads)
- Output: 4255 tokens
- Cost: $0.848448
- Wall-clock: 382s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
