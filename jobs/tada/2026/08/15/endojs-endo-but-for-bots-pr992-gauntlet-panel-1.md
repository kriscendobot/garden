The panel verdict is posted. This is a design-only PR (garden library), no code changes to commit. Job done — one panel round, disposition must-fix, verdict posted.

## Completion report

**Job:** Gauntlet PANEL round 1 for endojs/endo-but-for-bots PR #992 (`design(http): HTTP client/controller as a metered pass-style adapter pipeline`).

**What I did:**
- Resolved the PR head as a **fork** branch (`kriscendobot:design-http-adapter-pipeline`) and checked it out via `ensure-project-worktree.sh` from the fork owner (the base-repo fetch failed, as expected for a fork PR — the recent `fix(gauntlet): check out fork PR heads from their owner` covers this; my job spec predated it).
- Determined the correct diff base: GitHub reports the PR as a single commit (`43ff29d78`) touching `designs/README.md`, `designs/cli-http-client.md`, `designs/http-adapter-pipeline.md`. Local `upstream/llm` was stale, so I used `HEAD~1`, which reproduces exactly that 3-file diff.
- Ran the panel in single-round mode: `GARDEN_PANEL_SINGLE_ROUND=1 panel.sh <wt> 992 HEAD~1`. It sensed a **design** panel, fanned 7 seats (critic, skeptic, decomplector, ergonomist, copyeditor, pedant, novice), aggregated, and decided **must-fix** (rc=0; all 7 seats returned request-changes).
- Posted the aggregate to PR #992. `--request-changes` is disallowed on one's own PR, so I posted it as a **comment review** (`state=COMMENTED`, kriscendobot, 2026-08-15T06:53:19Z) with an explicit `must-fix` marker at the top so the fix stage can read the findings.

**Key findings (for the fix stage):** a load-bearing contradiction between the canonical stage-order table (breaker outermost) and the prose claim that the breaker observes every retry attempt (structurally impossible under the compose-at-construction far-ref model); 429 counted as breaker/retry evidence while the design excludes 4xx for guest-fairness; `RequestContext` described as immutable yet "set"/"incremented" in place; a single `RequestContextShape` shared across the guest-facing and internal boundaries; pervasive em-dashes and typist-hostile code points (`→ · − ≤ …`); and several heading/numbering inconsistencies.

**Changed:** no repo commits — design-only PR; the only output is the posted panel review.

**Follow-ups:** none from this stage; the gauntlet advances to fix round 1 off the stage-result marker below.

<!-- gauntlet-stage-result: panel=must-fix -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr992-gauntlet-panel-1.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 40 tokens (1069802 cached reads)
- Output: 7852 tokens
- Cost: $1.260813
- Wall-clock: 353s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
