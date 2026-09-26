Deployed root is clean; the fix lives only in the committed main2 change. All work complete.

## Completion report

**Stage: PANEL round 3 — endojs/endo-but-for-bots PR #995** (`design(endo-claude)`, design-doc-only PR: `designs/endo-claude.md` + `designs/README.md`).

**What I did**
1. Resolved the PR head (`endojs/endo-but-for-bots` @ `design/endo-claude`) and got an isolated project worktree at PR head `5775f93dc`.
2. Ran the panel in single-round mode. The first run used the dispatched base `llm`, which produced a **polluted 17-file/2128-line code panel** — the worktree's local `llm` (2026-08-14) was a day stale against `origin/llm` (2026-08-15), so `git diff llm...HEAD` folded in unrelated commits. I detected this from the aggregate (seats reviewing `packages/where`, `familiar`, other designs not in the PR; the scribe seat flagged the recurrence explicitly) and re-ran the single round against `origin/llm`, which correctly sensed a **design-panel** over the true 2-file diff.
3. The corrected design panel returned **must-fix** (base `origin/llm`, 7 design seats). Legitimate in-diff must-fix findings: the `infer` export shape stated three incompatible ways (DD8 "settled exo" vs Open Questions "undecided" vs Package-shape "plain function"); an "optional" vs "required" self-contradiction at :130-133; 51 em-dashes violating the no-em-dash rule. Plus should-fix: `--tools ""` does not close the `/skill` surface (`--disable-slash-commands` is a separate flag — a real confinement gap), the "same bearer" build-sequencing claim contradicting the routing model, formula-id identity/credential complecting, and pool `acquire` braiding policy with mechanism.
4. Posted the aggregate verdict to PR #995. `gh pr review --request-changes` is refused on the bot's own PR, so I posted it as a PR comment carrying the **must-fix** verdict: https://github.com/endojs/endo-but-for-bots/pull/995#issuecomment-5306341883

**What changed (garden main2)**
- `fix(panel): normalize a bare local base branch to its remote-tracking tip` (`3e7ffb1e13`, pushed to `main2`). `panel.sh` now rewrites a bare base branch (e.g. `llm`) to `origin/<base>` before any diff, so a stale local branch can no longer misclassify a design PR as a code panel or decide a disposition over files not in the PR. This closes the recurring base-ref defect the scribe seat cited across #970 and #995. Explicit `origin/...`, sha, and `HEAD~N` bases are left untouched.

**Note / follow-up**
- I initially edited `panel.sh` in the deployed garden root by mistake; I reverted that stray working-tree edit (no git run in the root) and re-applied + committed the change in my per-job worktree. Deployed root confirmed clean.
- The fix is committed but only takes effect on the next garden deploy; existing in-flight panels still receive whatever base their dispatch passed.

<!-- gauntlet-stage-result: panel=must-fix -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr995-gauntlet-panel-3.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 65 tokens (2476316 cached reads)
- Output: 22293 tokens
- Cost: $2.6154010000000008
- Wall-clock: 1141s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
