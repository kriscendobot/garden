The panel round completed. Verdict posted; stage result is must-fix.

## Completion report

**Job:** Gauntlet PANEL stage, round 1 — endojs/endo-but-for-bots PR #1015 (`feat(claude): add @endo/claude confinement core`).

**What I did:**
1. Resolved the PR head (`endojs:endo-claude-package`, base `llm`) and created an isolated project worktree at head `971fe22c3`; merge-base against `origin/llm` is `71e9fcf7d0`.
2. Ran the code panel in single-round mode (`GARDEN_PANEL_SINGLE_ROUND=1`) against that worktree with base `71e9fcf7d0`. All 30-odd seats fanned, aggregated, decided. Terminal line: `panel #1015: code-panel single-round — must-fix`. The run was recorded to the journal (`panel-runs/endojs-endo-but-for-bots-1015/16cf8d5f68e2.md`).
3. Built a review body leading with the **must-fix** disposition + a blocking-findings summary, followed by the full per-seat aggregate (truncated to 65000 chars to fit GitHub's review-body limit; the raw 86 KB aggregate exceeds it).
4. Posted it to PR #1015. A `--request-changes` review is rejected by GitHub ("Can not request changes on your own pull request" — the PR is bot-authored), so I posted it as a **comment review** whose body leads with `disposition: **must-fix**`. The authoritative stage result travels via the report marker below, which the gauntlet driver reads.

**Blocking (must-fix) findings surfaced:**
- **typist** — `@endo/claude` inlines exported `@typedef`s in `src/**/*.js` and re-exports via `claude.types.d.ts`, inverting the typedef-placement convention.
- **breaker** — cancellation race in `harness.js:241-294`: abort flag checked once, then five `await`s (incl. credential-file write + `launch`) run un-rechecked, so a late cancel still writes files and spends a pooled turn.
- **fast-checker** — `results.js facetThrew` "always-passable" `forall` is only two-example spot-checked, not property-verified.
- Plus several should-fix/summary-fix items (stylist `rid`→`requestId`; corner-prober boundary gaps; locksmith `id: null` vs absent-id discriminator; packager unsquashed `fixup!`; assessor dead `opts.failed`).

**Scope:** exactly one panel round; no fix, no un-draft, no loop, as required.

**Follow-ups:** none from me — the gauntlet driver will schedule a fix stage on this must-fix result.

<!-- gauntlet-stage-result: panel=must-fix -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1015-gauntlet-panel-1.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 37 tokens (1044804 cached reads)
- Output: 8178 tokens
- Cost: $1.2718
- Wall-clock: 715s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
