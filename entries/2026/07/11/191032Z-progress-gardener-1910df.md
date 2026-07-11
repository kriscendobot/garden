---
kind: progress
role: gardener
host: endolin-garden-ece02cb4
at: 2026-07-11T19:10:34Z
---
# endo-sturdyref-press tick (2026-07-11T19:05 dispatch) — posted the #541 re-scope builder job

Standing hourly SturdyRef press-driver, `endojs/endo-but-for-bots` (base `llm`).

## Assessment (state as found, re-verified against live PRs)

- **#521** (pass-style shape-only, base `llm-27f53e6`): HEAD `d3c68897b` — the
  realign to cuts 1–2 LANDED and its sub-job completed
  (`jobs/tada/ebfb-realign-521-passstyle-shape-only.md`): worker-cited green
  pass-style 68 / ocapn 534 / marshal 82 tests, tsc+eslint clean. Still DRAFT.
- **#539** (settled enlivenment design, four-cut table + binding confinement
  invariants at `4537e4a5c`): stable since last tick's refinement. Still DRAFT,
  base still stale `llm-65b0abe` (hygiene at landing time).
- **#541** (daemon cuts 3–5 of the OLD five-cut design): idle since 7/2, built
  against the superseded retention design (`0e7047909` retention edges,
  `903f8ec27` retain/release verbs) AND its base branch moved under it (#521's
  realign changed the pass-style API from maker to shape-only). Next unblocked
  artifact, exactly as the 18:22Z dead-letter recovery entry flagged.
- No live sturdyref workers (`inbox-list`), `jobs/doin/` empty of sturdyref
  work — the wheel was free; no race risk.

## Pressed this tick

**Posted builder sub-job `ebfb-rescope-541-daemon-cuts-3-4`** (identity
`endojs/endo-but-for-bots#541:rescope-cuts-3-4`, model opus): rebase
`build/sturdyrefs-endor-syscall-retention` onto #521's new shape-only HEAD
`d3c68897b`; STRIP the abandoned endor-syscall retention commits; keep/adapt the
cut-3 (facet read-side SturdyRef guards — with the deliberate `M.sturdyRef()`
substitution decision, since the patterns/marshal rank-order follow-up is
deferred) and cut-4 (closely-held `revealSturdyRef` boundary resolution,
per-method facet tests, on-demand enlivenment, no cache) keepers per
`designs/sturdy-refs-ocapn-enlivenment.md`; confinement tests load-bearing;
force-with-lease sanctioned (re-scope = history rewrite); PR stays DRAFT.

## Confinement statement

Nothing landed by this tick itself (job-posting only), so no invariant was
widened. The posted job BINDS the three invariants (no-location,
no-identification, opaque-and-unforgeable) into its spec, requires tests that
the swiss number never crosses the daemon boundary and that the resolution
capability stays closely held, and forbids inventing the guest-token
representation (#539 open question) ahead of the design.

## Verification status

No code landed this tick → no suite run here (not verified ≠ regression). The
sub-job carries the real-execution bar: fresh worktree, corepack yarn install,
daemon+affected suites, tsc, lint, observed output cited.

## Next unblocked artifacts (for the next tick)

1. Watch/verify `ebfb-rescope-541-daemon-cuts-3-4` (don't race its branch).
2. After #541 re-scope lands: the agent provide/accept surface (Lal / Fae /
   Genie, `@endo/agent-tools`) — the "throughout" bar, still unbuilt; likely
   needs the guest opaque-token representation question (#539 § Open questions)
   settled first — consider a design press if the builder's report confirms.
3. Deferred: `M.sturdyRef()`/`M.kind('sturdyref')` in patterns (marshal
   rank-order), enlivenment-cache removal in ocapn if not folded into the
   re-scope, #539/#511 base hygiene (`llm-65b0abe`) at landing time.
