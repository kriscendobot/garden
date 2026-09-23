---
ts: 2026-05-22T04:39:50Z
kind: result
role: liaison
project: garden
to: "*"
subject_matter:
  - panel-composition
  - juror-dispatch
  - diff-signal-hints
  - meta-evolution-research
refs:
  - entries/2026/05/20/010623Z-result-liaison-51dbd2.md
---

# Investigation: diff-signal hints for jury paneling

The maintainer's framing on 2026-05-22: *"It might be useful for the Judge to have a script that greps diffs and echoes jury paneling hints. Certain keywords may reliably suggest that a particular kind of reviewer should be dispatched. It might have false positives but still enable us to efficiently use a much broader panel."*

This entry is the requested report. It catalogs the diff signals per juror seat, names which signals are reliable enough to drive dispatch decisions, sketches the script's shape, and recommends a four-bucket panel-composition policy that the judges (`solicitor` / `barrister` / `justice`) can consult before fanning out.

## Why this is a good lever

The code panel is 26 seats and growing. The expansion since 2026-05-20 (the six PR-#75-derived seats: `benchmarker`, `changeset-auditor`, `surfacer`, `scribe`, `pruner`, `gateway`) added seats whose lenses fire on a small fraction of PRs but produce highly-targeted findings when they do. The 2026-05-21 expansion (`corner-prober`, `fast-checker`, `releaser`) follows the same shape. If the trend continues, the panel will likely accrete more narrow seats, which raises a structural question: is dispatching every seat on every PR the right default when most narrow seats will return "no findings" on the typical diff?

The maintainer's framing answers no: a script that greps the diff for each seat's signature can recommend which seats are likely relevant. False positives (dispatching a seat whose lens does not actually apply) are cheap — the juror returns a clean block. False negatives (skipping a seat whose lens does apply) are the failure mode the script must minimize. The leverage move: a low-bar threshold (any positive signal triggers the seat) plus an "always-on core" set that fires regardless of signals, with the long tail of narrow seats opting in.

## Bucketed catalog

Across the 33 jury seats (26 code panel + 7 design panel), every seat fits into one of four buckets by the shape of its trigger:

### Bucket A: Always-on core (code panel)

Seats whose lens applies on virtually every code PR. Fire regardless of signals.

| Seat | Why always-on |
|---|---|
| `assessor` | Correctness logic; fires on any non-trivial control-flow change. |
| `typist` | TS/JSDoc annotations; fires on any change in a typed codebase. |
| `stylist` | Naming; fires on any identifier-touching diff. |
| `packager` | Commit shape, diff hygiene, changeset bundling; fires on every PR. |
| `archivist` | Docs and comment-prose accuracy; fires when source moves regardless of doc churn. |
| `prover` | Regression evidence; fires whenever tests are touched or absent. |
| `saboteur` | Adversarial inputs; broad enough that almost every public-surface change warrants it. |
| `integrator` | Integration coherence: merge-commit readability, rename completeness, convention probe; fires on every PR. |

Eight seats. The minimum panel for a non-trivial source PR.

### Bucket B: Path-triggered (sharp diff signals)

Seats whose trigger is a path or path-pattern in the diff. Sharp on/off signal; low false-positive rate.

| Seat | Path trigger |
|---|---|
| `curator` | `**/package.json` exports/main/types field; `**/index.*`; `**/*.d.ts` |
| `surfacer` | Any change touching ≥2 of `{package.json exports, index.*, .d.ts, README.md}` within one package |
| `migrator` | `**/package.json` dependencies; `.changeset/*.md`; multi-package diff |
| `changeset-auditor` | Any `.changeset/*.md` (excluding `README.md` and `config.json`) |
| `releaser` | Any diff (the seat asks whether a changeset *should* exist; also `.changeset/*.md` when one does) |
| `benchmarker` | `**/BENCH.md`, `**/*.bench.{js,ts}`, `**/benchmark/**` |
| `gateway` | `tsconfig*.json`, `.eslintrc*`, root `package.json`, `.github/workflows/*.yml`, `.prettierrc*`, `.editorconfig`, `.gitattributes` |
| `pruner` | Any `*.md` added or substantially edited (`+` line count > ~30) |
| `fast-checker` | Test files + `fast-check` already present in devDeps, OR test files for codec/numeric/algebraic surfaces |

Nine seats. Sharp triggers; the script's primary fan-out lever.

### Bucket C: Content-triggered (regex against added lines)

Seats whose trigger is a content regex against `git diff -U0`. Moderate false-positive rate; depends on the codebase's idiom.

| Seat | Content regex (added lines only) |
|---|---|
| `warden` | `\bharden\(`, `globalThis`, `__proto__`, `Object\.prototype`, `from\s+['"]ses['"]`, `from\s+['"]@endo/(init\|lockdown\|exo\|pass-style)['"]` |
| `locksmith` | `attenuate`, `endowments?`, `Far\(`, `passStyleOf`, `\bE\(`, `\bExo\b`, `makeCapTP` |
| `breaker` | `M\.interface\(`, `makeExo\b`, `@returns?` with strong-claim language, `^## Invariants` in design docs |
| `purist` | Endo intrinsic-shaping packages plus `defineProperty.*enumerable`, `Object\.freeze`, type+value name collisions |
| `spec-keeper` | `Reflect\.(apply\|construct\|ownKeys)`, `\.call\(\|\.apply\(`, polyfill/shim filenames, `tc39\.es`, `Symbol\.(iterator\|asyncIterator)` |
| `wire-watcher` | `\bsha(256\|512)\b`, `digest`, `hash`, `JSON\.parse`, vref/kref identifiers `v\d+-\|o[+-]\d+`, `\bretireImports?` |
| `engine-realist` | `\bWeakMap\b`, `\bWeakRef\b`, `FinalizationRegistry`, `\bcrank\b`, `\b(durable\|virtual\|ephemeral)\b`, `vatstore`, `Float16Array` |
| `corner-prober` | `MAX_SAFE_INTEGER`, `\bNaN\b`, `\bInfinity\b`, `BigInt\(`, `Date`, `surrogate\|NFC\|NFD`, `WeakMap`, `setTimeout`, `Math\.(floor\|ceil\|round)` |

Eight seats. Triggers in `git diff origin/<base>...HEAD -U0 | grep -E '^\+'`. Each regex set takes ~5-10 patterns; false positives are common but cheap.

### Bucket D: Cross-reference-triggered (needs more than diff)

Seats whose primary signal lives outside the diff: PR comments, prior journal entries, the upstream PR's history. The script's diff-only scan cannot reliably trigger these.

| Seat | Signal source |
|---|---|
| `scribe` | PR comment history — maintainer asks to "note this in standing orders" |
| `benchmarker` (partial) | PR body / threads — optimization claims via `benchmark\|perf\|faster\|optimi[sz]e` |
| `releaser` (partial) | Diff judgment — is the change user-facing? |

These three seats can either: (a) always fire (cheap; low marginal cost; their reports degrade to "no findings" when the signal is absent); (b) fire on a coarser proxy like "PR has > 5 review comments" for scribe or "PR body length > 1KB" for benchmarker. I recommend (a) for `scribe` and `releaser` (always fire) and keep `benchmarker` in bucket B (path-triggered) — the BENCH.md path signal is sufficient even if it misses thread-only optimization claims.

### Bucket E: Design panel routing

The design panel is wholesale: when `git diff --name-only origin/<base>...HEAD` returns only paths under `<project>/designs/`, all 7 design seats fire (`critic`, `skeptic`, `decomplector`, `ergonomist`, `copyeditor`, `pedant`, `novice`). The `solicitor` is the judge; the script's job here is only the panel-kind discrimination (code vs design), which is already in the `solicitor`-vs-`barrister`/`justice` selection logic.

Two design seats (`pedant`, `copyeditor`) additionally fire on code PRs that include substantial markdown changes — the same trigger as `pruner` in bucket B. This is the only cross-panel composition the script needs to recognize.

## Script shape

A new skill `skills/panel-hints/` carrying:

```
skills/panel-hints/SKILL.md
skills/panel-hints/panel-hints.sh
```

The script reads two inputs: a project worktree and a base branch (default `master` or the project's roadmap branch). It emits a recommended panel to stdout in the shape:

```
Panel-kind: code-panel
Always-on core (8): assessor, typist, stylist, packager, archivist, prover, saboteur, integrator
Path-triggered (5): changeset-auditor, gateway, curator, surfacer, pruner
  changeset-auditor   .changeset/dropping-node-20.md
  gateway             .github/workflows/ci.yml, tsconfig.eslint-base.json
  curator             packages/foo/package.json (exports field)
  surfacer            packages/foo/{package.json, index.js, README.md}
  pruner              packages/foo/README.md (+47 lines)
Content-triggered (3): warden, corner-prober, spec-keeper
  warden              harden\( in packages/foo/src/bar.js:42
  corner-prober       MAX_SAFE_INTEGER in packages/foo/src/int.js:18, NaN in test/int.test.js:91
  spec-keeper         Reflect.apply in packages/foo/src/util.js:104
Always-fire (3): scribe, releaser, fast-checker
Suppressed (10): migrator, locksmith, breaker, purist, wire-watcher, engine-realist, benchmarker, ...

Total recommended: 19 seats (out of 26).
```

The shape:
- **Always-on core**: 8 seats, always listed.
- **Path-triggered**: 0-9 seats, listed with the triggering paths so the judge can verify.
- **Content-triggered**: 0-8 seats, listed with one example file:line hit so the judge can verify.
- **Always-fire**: 3 seats whose lens applies broadly without a sharp diff signal.
- **Suppressed**: 0-7 seats the script believes do not apply; named explicitly so the judge can override.

The judge dispatches the recommended set by default. The judge may add any suppressed seat if maintainer context warrants it (e.g., a known sensitive package).

Implementation effort: ~250 lines of bash + awk + grep. The 8 content-regex patterns from bucket C are the largest section. The path patterns from bucket B are one-liners each. The script's structure mirrors `skills/pre-push-gates/pre-push-gates.sh` (per-probe scripts under `skills/panel-hints/probes/` would be a natural shape, one probe per signal-triggered seat).

## False-positive vs false-negative tradeoff

The catalog flags each seat with a per-bucket risk profile:

- **Always-on core (A)**: false-positive risk near zero (the lenses always apply); the cost is the dispatch overhead.
- **Path-triggered (B)**: false-positive risk **low**, false-negative risk **low** — sharp signals.
- **Content-triggered (C)**: false-positive risk **medium** (a regex match in a comment vs in load-bearing code), false-negative risk **medium** (a capability grant without keyword, an invariant claim in prose). The script flags content-triggered seats with **one example file:line hit** so the judge can do a quick visual check and override the trigger if the hit was spurious.
- **Cross-reference (D)**: false-positive risk **medium** if we tried to use diff-only proxies, so we always-fire these three seats instead.
- **Design (E)**: false-positive risk **zero** when the path filter is strict (every changed path under `<project>/designs/`).

**Bias toward false positives, against false negatives.** The script's defaults: any positive signal triggers the seat. Suppressing a seat requires *all* signals to be absent. The judge can override either direction.

## Integration with the judges

The script lives in `skills/panel-hints/` and is consulted by the three judges (`solicitor`, `barrister`, `justice`) at top-of-dispatch:

1. Judge prepares its dispatch as today.
2. Before fanning out the panel, judge runs `bash skills/panel-hints/panel-hints.sh --base <base>` against the PR worktree.
3. The script's stdout is parsed for the recommended set.
4. Judge dispatches the recommended set concurrently per `skills/panel-review/SKILL.md` § Concurrent dispatch.
5. Judge's `result` entry records the recommended set, the suppressed set, and any judge-side overrides for audit.

Wiring: each judge role file gains one bullet in *Operating norms* naming the consultation step. The shared `skills/panel-review/SKILL.md` § Concurrent dispatch gains a note that the dispatched seat list may be a script-recommended subset rather than the full panel.

The `solicitor` (design panel) does not benefit from the script — the design panel is small and wholesale-triggered. The script's value is on the code panel (26 seats → ~12-19 on a typical diff).

## Cost-benefit estimate

Typical code PR (single-package, ~50-line diff, one test file added):
- Today: 26 dispatches × ~3-8K tokens each = 78K-208K tokens of fan-out per round.
- With hints: ~12-15 dispatches = 36-120K tokens. **~40-60% reduction.**

Atypical PR (multi-package, root config touched, README change, exports rewrite):
- Today: 26 dispatches.
- With hints: ~20-23 dispatches. **~15-20% reduction.**

Design-only PR:
- Today: 7 dispatches.
- With hints: 7 dispatches. **No change** (the design panel is already small).

The script's wall-clock cost: ~50ms per probe × 20 probes = ~1 second per panel round. Negligible against the 2-3 minute panel-dispatch wall-clock.

The leverage compounds with panel growth: each new narrow seat added in 2026-05-20 / 2026-05-21 / future expansions costs almost nothing on PRs where its signal does not fire, instead of always-firing-and-returning-no-findings.

## Recommended next step

One gardener engagement to:

1. Author `skills/panel-hints/SKILL.md` with the canonical bucket table above.
2. Author `skills/panel-hints/panel-hints.sh` with the per-probe scripts in `skills/panel-hints/probes/`.
3. Update each of the three judge role files (`solicitor`, `barrister`, `justice`) to consult the script at top-of-dispatch.
4. Update `skills/panel-review/SKILL.md` § Concurrent dispatch to name the script-recommended-subset pattern.
5. Smoke-test on PR #75's diff (which exercised many lenses) and on the next garden-authored draft PR.

Estimated scope: one gardener dispatch, ~250 lines of bash + ~30 lines of role-file deltas. The empirical-source for each per-probe regex is already in the catalog above; no further investigation needed.

## Decisions to confirm

Before encoding, the maintainer should confirm:

- **Always-on core set**: is the bucket A list above (assessor, typist, stylist, packager, archivist, prover, saboteur, integrator) the right floor? Alternatives: add `corner-prober` to core (boundary-case enumeration applies to most logic changes); add `breaker` (invariant attacks); remove `saboteur` from core (it's broad but expensive in tokens).
- **Always-fire set**: scribe + releaser + fast-checker fire regardless of signals. Is this the right default? Each can move to bucket B (path-triggered) with a coarser proxy if always-fire feels wasteful.
- **Suppressed seats and override discipline**: should the judge be free to override suppressions on a per-PR basis (default), or should overrides require a maintainer directive in the dispatch brief (stricter)?

The catalog above is enough to start; the policy questions are the maintainer's to decide.

## Self-improvement

The diff-signal-hints script is a near-perfect example of the panel-composition-as-policy pattern the garden has been accreting through the May-2026 panel expansion. Each new seat the gardener carves has a tight enough lens that its signature is reliably detectable from the diff alone. Encoding that detection in a script lets the panel keep growing without proportionally growing the per-PR fan-out cost; the seat-count and the per-PR-dispatch-count become decoupled.

The structural lesson: **panel expansion is sustainable only when seat lenses are narrow enough to be signal-detectable.** Future seat proposals should be evaluated against this criterion. A seat whose lens is so broad that no diff signal reliably opts it in (or out) is a fundamentally different shape than the narrow seats added since 2026-05-15 — it would need to live in bucket A (always-on) rather than buckets B or C. The carving discipline should resist always-on additions unless the lens is genuinely universal.

Self-improvement: this report itself follows the cite-or-propose discipline at the meta level. Each seat's signal set cites empirical patterns from its role file; the always-on core proposes (rather than mechanically derives) the right floor based on lens-breadth judgment. The maintainer's decisions above will close the open proposals.
