The panel round-2 review is posted. The stage is complete.

## Completion report

**Job:** Gauntlet PANEL round 2 for endojs/endo-but-for-bots PR #322 (`feat/familiar-flatpak-pipeline`, a design PR for the Familiar Flatpak packaging pipeline).

**What I did:**
- Resumed after multiple reaper requeues (reap #4). The host was heavily loaded with concurrent panels, which repeatedly killed the panel mid-run. I relaunched `panel.sh` fully **detached** (`setsid nohup`) so it would survive session teardown.
- Ran the panel in single-round mode against the isolated PR-head worktree (`project-wt-endojs--807555c77a25-1b9884da`, head `240b906e98`, base `origin/llm`). All 7 design seats (critic, skeptic, decomplector, ergonomist, pedant, novice, copyeditor) completed `ok`; aggregate = 37 KB.
- Disposition: **must-fix** (terminal line: `panel #322: design-panel single-round — must-fix`).
- Posted the aggregate as a `gh pr review` on PR #322. Because the PR is authored by the bot itself (`kriscendobot`), GitHub disallows a request-changes review on one's own PR, so it was posted as a **comment review** with the must-fix disposition explicit in the header (the shape the next-stage heuristic recognizes for a must-fix verdict).

**Key must-fix findings (for the fixer stage):**
- The `finish-args` filesystem grants are wrong: Flatpak has no `xdg-state` token and doesn't relocate `XDG_STATE_HOME`, so state writes land on an unmounted host path while `xdg-cache/endo` is a dead grant — and the design self-contradicts about where state lands.
- The sandbox-engagement gate (`pgrep -af 'zypak-helper|bwrap'`) is a tautology that passes even under `--no-sandbox`, defeating the design's raison d'être.
- The CI graft assumes a `step:package` that `familiar-release.yml` never runs, so `build-flatpak.mjs` hard-exits and, under the no-`continue-on-error` policy, blocks releases for every platform.
- Several cited facts (chrome-sandbox chmod instruction, `productName`, base-app Electron tracking) don't hold in-tree.

**Changed:** No garden files. One comment review added to PR #322 (2026-09-04T05:39Z).

**Follow-ups:** None from this stage — I stop here per the single-round contract (no fix, no un-draft, no loop). The gauntlet's fix-loop stage owns the must-fix items.

<!-- gauntlet-stage-result: panel=must-fix -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr322-gauntlet-panel-2.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 5 on 1 host(s)
- Input: 64 tokens (1805907 cached reads)
- Output: 11304 tokens
- Cost: $2.3543485
- Wall-clock: 228s
- Model(s): claude-opus-4-8 ×5

<!-- garden-usage-end -->
