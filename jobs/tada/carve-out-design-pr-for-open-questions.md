Pushed to `main2`. The job is complete.

## Completion report

**Job:** `carve-out-design-pr-for-open-questions` — establish that a garden-own-repo design carrying unresolved, maintainer-facing open questions gets a review PR instead of a blind bare land.

Re-derived state first: no prior attempt landed anything (HEAD was the shell-injection doc commit; journal showed only claim/requeue records). Clean start.

**Committed & pushed to `main2`** (`2e37272c33`):

- **`roles/designer/AGENT.md` § Operating norms** — new carve-out norm placed right after the "bare file only" line the spec named. States: a garden design with a non-empty `## Open questions` section lands as a PR (base = snapshot of the commit immediately before the design lands, head carries the design commit(s), reusing [`frozen-base-branch`](skills/frozen-base-branch/SKILL.md) — the same shape as the agoric-sdk no-roadmap-branch case, not a new mechanism); the decision is made at design-completion time, not retroactively; an empty/absent section still lands bare.
- **`CLAUDE.md` § Conventions** — carve-out note added directly beside the "we do not generally open pull requests against ourselves" statement, cross-linking to the designer role for the full mechanics. One canonical statement, no conflicting duplication.
- **The class marker** — the designer stamps `<!-- garden-design-open-questions -->` into the PR body. New `is_open_questions_design_pr` predicate in `scripts/jobs/common.sh` is the single definition of the marker; both the gauntlet **stager** (`auto-gauntlet-handoff.sh` DESIGN-PR path) and the completion **sensor** (`assert-design-pr-gauntlet.sh`) call it and skip staging/gating a design panel for a marked PR. Marker is designer-applied only for the garden's own repo, so fork-repo design PRs (no marker) still panel normally — matching the existing probe-exemption trust model.
- **Test fixture** — `scripts/jobs/test/design-pr-gauntlet-bypass-test.sh` gains a carve-out block: a marked garden open-questions PR (`kriscendobot/garden#74`) stages no gauntlet and is never sensed as a miss; a guard proves the marker is load-bearing (the same PR *without* the marker still panels). Full suite passes; `bash -n` clean on all three scripts.

**Acceptance met:** both docs state the carve-out consistently (one canonical statement, cross-linked); worked example is the muse fixture (marked → PR-with-no-panel, unmarked → panels); the report cites `design-muse-worker-kind` / PR #74 as grounding, as does every artifact.

No follow-ups required.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/carve-out-design-pr-for-open-questions.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 3 on 1 host(s) (2 unmetered)
- Input: 37 tokens (1372650 cached reads)
- Output: 13870 tokens
- Cost: $1.7286159999999997 (2 engagement(s) unpriced)
- Wall-clock: 211s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
