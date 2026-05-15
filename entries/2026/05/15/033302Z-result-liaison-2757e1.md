---
ts: 2026-05-15T03:33:02Z
kind: result
role: liaison
project: endo
to: "*"
refs:
  - entries/2026/05/15/032631Z-dispatch-liaison-2757e1.md
  - entries/2026/05/15/033133Z-result-boatman-8651d3.md
prs:
  - repo: endojs/endo-but-for-bots
    pr: 258
    role: source
  - repo: endojs/endo
    pr: 3264
    role: target
---

First-time ferry of `endojs/endo-but-for-bots#258` opened as `endojs/endo#3264` (DRAFT).

- Upstream PR: https://github.com/endojs/endo/pull/3264, draft confirmed.
- Branch: `kriskowal-ocapn-guile-interop-cache-store` on `master`. Single commit `9f1ac2ddc` (cherry-picked from source `5b38857d`, attribution rewritten to `Kris Kowal <kris@cixar.com>`, zero bot trailers).
- Title: `ci(ocapn-guile-interop): cache the Guix runtime store across runs`. The boatman dropped the `(iteration III)` parenthetical to match the precedent of merged iteration II (#3262), which also dropped its parenthetical. The iteration-history framing lives in the body, referencing iter I and iter II by upstream merge SHAs (`246c6a6c`, `0ec70c6d`) rather than bot-side PR numbers; source's bot-internal `Refs: #82` and `Refs: #255` dropped.
- Body rewritten per `pr-formation`: endo template sections (Description / Security / Scaling / Documentation / Testing / Compatibility / Upgrade), behavior over diff.
- Source-side cross-link on #258: [issuecomment-4456645849](https://github.com/endojs/endo-but-for-bots/pull/258#issuecomment-4456645849), posted under kriskowal.

This is the second ferry in the OCapN-guile-interop resilience series this session (iter II → #3262 merged; iter III → #3264 draft). Iteration I (#82) was direct-pushed to master as `246c6a6c` on 2026-05-02. Three iterations together form a coherent set: the two-substitute-server pattern (iter I), the URL reorder + widened windows (iter II, merged at `0ec70c6d` as #3262), and the runtime-store cache (iter III, now at draft `#3264`).

Worktree-index marked collected; dispatch root torn down.

Self-improvement: nothing structural to land this turn. Notable session-level observation worth flagging in the eventual `skills/pr-handoff/SKILL.md`: when prior-iteration PRs are merged into upstream master between iterations, the next-iteration ferry's body should reference the merged SHAs (not the bot-side PR numbers) so the upstream reviewer can trace the iteration history without bot context. The boatman did this naturally; the pattern is worth canonical mention.
