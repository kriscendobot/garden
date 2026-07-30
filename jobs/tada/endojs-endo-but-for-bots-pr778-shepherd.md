• CI is green except `zizmor`. Let me get the failing job log and the PR's head state.

• The PR's two commits touch no workflows — this is the zizmor time-bomb, an in-scope shepherd fix per the field note. Let me check the precedent commit's message style, then fix the three pins.

• Pushed `17a0ee112` to the PR branch. Draining inbox, then watching CI on the new head.

• While CI runs, checking the parity question — does `local-verify` cover zizmor?

• No zizmor coverage in `local-verify` — that's the parity gap to note in the report.

• CI fully green on the new head — all 23 checks pass, including `zizmor` and `check-action-pins`. Verifying head SHA, draining inbox, and checking the parity follow-up tooling.

• `$TMPDIR` was empty — retrying with `/tmp`.

• # shepherd report: endojs/endo-but-for-bots PR #778 — CI driven to green

  ## Result

  CI is green on head `17a0ee112db54991d5b79d1390f80e34db95ca58`. Termination condition: **green**. `next: none` — no further stage needed. PR `mergeable_state: clean`.

  ## Diagnosis

  Live rollup at job start: only `zizmor` failing (build/lint/test already passing). The failing job log (run 30503386441) showed zizmor v1.24.1 exiting 13 on three warnings:

  ```
  ci-docs.yml:42 / ci-docs.yml:71 / ci.yml:123: action's hash pin has mismatched or missing version comment: points to commit 11d5960a3267
  ```

  This is the known zizmor `stale-action-refs` **time-bomb** (shepherd field note 2026-07-20): three `actions/checkout@34e114876b0b… # v4` pins whose version comment no longer matches the commit the moved `v4` tag resolves to. Confirmed not caused by the PR's own diff: `git diff origin/llm-d396059...HEAD -- .github/workflows/` is empty (the PR's two commits are design-only), and base `llm-d396059` carries the same three stragglers. Every other workflow in the tree already uses `actions/checkout@de0fac2e4500dabe0009e67214ff5f5447ce83dd # v6.0.2`.

  ## What changed

  One commit pushed to the PR branch `design/endo-ertp-migration` (push via isolated per-job project worktree, `ensure-project-worktree.sh`):

  - `17a0ee112` `fix(ci): repin stale actions/checkout hashes flagged by zizmor` — repinned the three stragglers (`.github/workflows/ci.yml:123`, `.github/workflows/ci-docs.yml:42`, `.github/workflows/ci-docs.yml:71`) to `de0fac2e… # v6.0.2`, matching all 28 sibling usages and mirroring precedent `1ff3e0d3d` on `llm`. Plain commit, not `--fixup`: no commit in this PR introduced the violation (it's an upstream tag-move time-bomb on the base).

  ## Verification (real-execution evidence)

  - Local: `zizmor --persona pedantic --min-severity low .` (v1.25.2, same gate inputs as `.github/workflows/zizmor.yml`) on the fixed tree → `No findings to report`, exit 0.
  - CI: full 23-check matrix on head `17a0ee112` all `pass`, zero pending/fail — including `zizmor` (14s, run 30503917612), `check-action-pins` (1m59s), lint, and the full test matrix. Green run: https://github.com/endojs/endo-but-for-bots/actions/runs/30503917602

  No PR comment posted: the job body carries no external-repo comment authorization (auto-dispatched shepherd), so the green-run URL is reported here only.

  ## Follow-ups

  - **Parity gap (parked):** the failure was locally anticipable — the pins were already stale when head `aac89e41e` was pushed at 00:40Z (llm fixed them 9 days prior), but `local-verify` has no zizmor coverage. Posted deferred/low plan job `local-verify-zizmor-parity` (role: builder) to add a zizmor audit step mirroring the repo's gate inputs.
  - Base branch `llm-d396059` still carries the three stale pins; it will go red on its next zizmor run unless it absorbs `1ff3e0d3d` from `llm`. Left alone as out of this PR's scope.
  - Project worktree left in place for GC per the per-job checkout design; inbox drained (empty).
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr778-shepherd.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 44298 tokens (1333760 cached reads)
- Output: 12489 tokens
- Cost: $0 (1 engagement(s) unpriced)
- Wall-clock: 1980s
- Model(s): kimi-k3 ×1

<!-- garden-usage-end -->
