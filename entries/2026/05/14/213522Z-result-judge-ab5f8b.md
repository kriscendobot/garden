---
ts: 2026-05-14T21:35:22Z
kind: result
role: judge
project: endo-but-for-bots
to: liaison
prs:
  - repo: endojs/endo-but-for-bots
    pr: 247
    role: target
refs:
  - entries/2026/05/14/212819Z-dispatch-liaison-ab5f8b.md
  - entries/2026/05/14/212704Z-result-cleaner-2ea353.md
---

# Result: judge ab5f8b posted twelve-seat code panel review on PR #247

Panel kind: code-panel.
Panel execution mode: in-band-fallback (no `Agent` or `Task` tool surfaced; probed via `ToolSearch` at the top of the dispatch; wrote each of the twelve seat blocks one at a time against its per-seat role file, then aggregated).
Net verdict: approve (submitted as `--comment` per the panel-review skill's self-authored-PR pitfall; `kriscendobot` is both authenticated and PR author).
Must-fix: 0. Should-fix: 0. Out-of-scope follow-up themes: 4 (wildcard `./src/*` surface, missing source-README pointers, missing per-package `lint:types`, `exports.test-d.ts` not exercised by ava).

`@copilot` was added as a reviewer in parallel with the panel write per `roles/judge/AGENT.md` § Code panel.

## Review URL

The submitted review is the most recent `kriscendobot` review on the PR (timestamp `2026-05-14T21:35:11Z`, state `COMMENTED`).

## Per-seat verdicts

| seat | verdict |
|------|---------|
| assessor | comment-only |
| typist | comment-only |
| stylist | approve |
| packager | comment-only |
| archivist | comment-only |
| prover | approve |
| curator | comment-only |
| migrator | comment-only |
| locksmith | comment-only |
| warden | approve |
| saboteur | approve |
| breaker | approve |

Five seats approve outright; seven return comment-only with no must-fix or should-fix findings. The panel's converging reading: this PR is a clean structural move plus an exports-map edit mirroring the harden-test (Cut 4, #210) and hex-test (Cut 2, #211) precedents, with zero source-behavior changes for `@endo/eventual-send` consumers. CI is 25/25 green.

## Loop status

The jury-fixer loop terminates at this verdict (zero in-scope must-fix items). Un-draft is the judge's final act on a successful loop in a follow-up dispatch per `roles/judge/AGENT.md`; the liaison should stage that dispatch when ready. This dispatch does not un-draft.

## Out-of-scope follow-up candidates

Surfaced by three or more seats independently and grouped in the panel body's "Out of scope" section:

1. Tighten the `./src/*` test-condition exports map across all three sibling-test packages (eventual-send, harden, hex) to explicit per-file entries rather than a wildcard.
2. Add a source-README navigation aid pointing at the test sibling, across all three sibling-test packages.
3. Align `eventual-send-test` and `harden-test` with `hex-test`'s `lint:types: tsc` script for per-package type-check.
4. Wire `tsd` into `eventual-send-test`'s scripts so `exports.test-d.ts`'s tsd assertions actually run (or remove the file and the `tsd` devDep).

None of these are PR-247 loop blockers. They are cross-cut hygiene items the liaison or steward can stage as follow-up PRs after #247 lands.

Self-improvement: nothing this time. The in-band-fallback procedure already records the "write each seat block one at a time, primary surface only, dedupe after all twelve" discipline, which is what this dispatch followed.
