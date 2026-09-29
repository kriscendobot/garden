Findings delivered to the maintainer. This was investigate-only — nothing committed, no PR, no merge.

## Completion report

**Job:** Dependabot investigate-only pass on `kriscendobot/oros-ckm-data-readiness` (public, Apache-2.0), default branch `ckm-poc-build`.

**What I did**
- Confirmed **Dependabot alerts are genuinely disabled** for the repo (the `gh api .../dependabot/alerts` 403 message is "alerts are disabled"; the bot token additionally lacks `admin:repo_hook`, but disabled is the real state). Getting GitHub's own "2 high" count would require enabling Dependabot in repo Settings.
- Fell through to `npm audit` against an **isolated** project worktree of the default-branch `package-lock.json` (npm-based; prod deps: d3, dotenv, papaparse, pg, react, react-dom).
- Traced every high-severity finding to its dependency parent and tested both non-breaking (`npm audit fix --package-lock-only`) and breaking fix paths.

**Findings (delivered to maintainer via message bus)**
- Current audit: **10 high + 4 moderate + 2 low**. All 10 highs are in **dev/build tooling** (devDependencies and their transitives); **none reach the shipped production runtime** — real-world exposure of the deployed app is effectively nil.
- The npm count (10) exceeds Dependabot's snapshot ("2 high") because npm's advisory DB is broader and several advisories are recent.
- **9 of 10 highs close with a non-breaking `npm audit fix`** (lockfile-only bumps inside existing `^` ranges): brace-expansion, browserslist, glob, minimatch, nanoid, picomatch, postcss, rollup, undici.
- **1 high remains** after the safe fix — esbuild ≤0.24.2 (GHSA-67mh-4wv8-2f99, dev-server) under vite@5 — closing only via vite 5→8 (breaking major); the 3 leftover moderates are the same vite/vitest chain (vite 5→8 + vitest 3→5, breaking).

**What changed:** Nothing persistent. No commits, no PR, no merge (honoring the repo's milestone-merge-only + investigate-only convention). All analysis was in a disposable worktree.

**Follow-ups suggested to maintainer:** (1) run `npm audit fix` at next milestone merge — clears 9/10 highs, no behavior change; (2) schedule vite/vitest major upgrade as deliberate toolchain work for the last dev-only high + 3 moderates (not urgent); (3) optionally enable Dependabot alerts for authoritative counts on this public repo.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/oros-ckm-dependabot-audit-0013418.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 5 on 2 host(s) (2 unmetered)
- Input: 30 tokens (823241 cached reads)
- Output: 9208 tokens
- Cost: $1.1972904999999998 (2 engagement(s) unpriced)
- Wall-clock: 185s
- Model(s): claude-opus-4-8 ×3

<!-- garden-usage-end -->
