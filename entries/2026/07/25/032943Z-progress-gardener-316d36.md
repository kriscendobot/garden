---
kind: progress
role: gardener
host: endolin-garden2-5bcdff64
at: 2026-07-25T03:29:45Z
---
# SturdyRef press — 2026-07-25 tick (job endo-sturdyref-press-20260724-105003): stack coherent but CI-red; CI-green cascade posted

**Peer state:** the two newer press ticks (…-165003, …-225004) both FAILED at the
handler (rc=1 within ~40s of claim; error entries 01:23Z/02:53Z) and sit in doin/
awaiting the reaper — no live sturdyref worker, so this driver took the wheel.
Press ticks have produced no progress entry since 2026-07-22 16:10Z.

**Verified live this tick** (`gh pr view/list`, `gh api compare`, `gh run view`):
- The 07-22 restack cascade `endo-sturdyref-restack-701-704-pr737-line` COMPLETED
  (orch tada: all 4 children succeeded; #704 → `b212146b`). Every adjacency link
  in llm ← #774 ← #737 ← #541 ← #698 ← #700 ← #701 ← #702 ← #703 ← #704 compares
  `identical` — the stack is fully coherent.
- **But CI is RED across the stack** while unrelated llm PRs (#853/#854) are
  green: #774 SUCCESS:24; #737 3 failures; #541/#698 2 each; #700–#704 8 each.
  Diagnosed from logs: (a) lint — `Drift detected:
  packages/ocapn/tsconfig.composite.json`, needs `yarn build:types:gen`;
  (b) zizmor exit 13 — stale action hash-pin version comments (ci-docs.yml:42/71,
  ci.yml:123, hash 11d5960a3267), already fixed on llm; (c) REAL test/cover
  failures from #700 up (22.x/24.x, ubuntu+macos) needing per-PR diagnosis.
- No maintainer movement since 07-22: #695/#697/#737/#539 still show stale
  CHANGES_REQUESTED (fixes pushed; awaiting maintainer re-review; 07-21 omnibus
  already asked — do not re-nudge).

**Action this tick:** posted orchestration
`endo-sturdyref-ci-green-737-704-20260725` (serial, halt-on-failure) over eight
parked children — `endojs-endo-but-for-bots-pr737-ci-green-20260725` (fix the
stack-wide lint drift + zizmor pin comments + one macos test at the bottom), then
`…-pr{541,698,700,701,702,703,704}-ci-green-cascade-20260725` (rebase onto moved
predecessor, drive residuals green). Each child body makes the confinement suites
load-bearing with command+output evidence required. No pushes to project branches
by this tick itself.

**Confinement:** no sturdyref behavior changed this tick (board/orchestration
work only). Invariants continue to ride #774's confinement tests, #737's opacity
coverage, and the restacked #698/#700 suites (no-location: locator only via the
closely-held mapping; no toString URI leak; token unlinkability; opaque surface);
every cascade child is instructed to keep them green with evidence.

**Next driver:** watch `jobs/orch/endo-sturdyref-ci-green-737-704-20260725`; on a
halt, surface the failing child. After the stack is green, the next unblocked
artifact remains the agent provide/accept surface (finish-line bar 2), gated on
maintainer re-review of design #695 (and #697/#539/#737) — maintainer-side, do
not re-nudge. Also note the repeated press-handler rc=1 failures (three ticks in
a row died at the spine, not the work) — if the pattern persists, that is a fleet
issue worth surfacing separately.
