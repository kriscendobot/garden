---
created: 2026-05-22
updated: 2026-05-22
author: gardener
---

# Skill: panel-hints

A diff-signal recommender the three judges ([solicitor](../../roles/solicitor/AGENT.md), [barrister](../../roles/barrister/AGENT.md), [justice](../../roles/justice/AGENT.md)) consult at top-of-dispatch to decide which jury seats to fan out to on a given PR. The skill exists so the panel can keep growing into narrower and more specialized seats without proportionally growing the per-PR dispatch fan-out: as new seats accrete, only the subset whose lens has a signal in the diff fires on any given PR.

The maintainer's framing on 2026-05-22: *"err on the side of too many reviewers. The idea is not to reduce the amount of reviews we are currently doing, but to enable us to vastly expand the juror profiles and make juror profiles narrower."* The skill encodes that bias: any positive signal triggers the seat; suppression requires *all* signals to be absent.

The investigation that produced this skill's per-seat catalog and the five-bucket policy is in [`journal/entries/2026/05/22/043950Z-result-liaison-6c970b.md`](../../journal/entries/2026/05/22/043950Z-result-liaison-6c970b.md).

## When to use

- **Judge top-of-dispatch.** Each of the three judges consults the script before fanning out the panel. The judge dispatches the recommended set concurrently per `skills/panel-review/SKILL.md` § Concurrent dispatch.
- **Maintainer ad-hoc.** When the maintainer wants to know which seats *would* fire on a given diff before authorizing a dispatch (e.g., assessing whether a sensitive package warrants a custom seat list).
- **Smoke-test after a new seat lands.** When the gardener adds a new juror, the seat's probe is added to `probes/` and the script verifies the seat fires on a known-relevant historical PR's diff.

The script is **not** a hard gate. The judge may add any suppressed seat if maintainer context warrants it; the judge may drop any recommended seat if it knows the lens does not apply on this PR. The script's output is a strong default, not a constraint.

## Inputs

`panel-hints.sh [--base <ref>] [--design-paths <glob>] [<project-root>]`

- `<project-root>`: defaults to the current working directory. The script reads the diff between `<base>` and `HEAD` against this tree.
- `--base <ref>`: the diff's base, defaulting to `origin/master` or the upstream the current branch tracks. Common values: `origin/master`, `origin/llm` (for roadmap branches on `endojs/endo-but-for-bots`).
- `--design-paths <glob>`: the project's design directory pattern, defaulting to `designs/`. Used to detect design-only PRs that should route to the design panel.

## State

The skill is stateless. Each invocation reads the diff fresh.

## Procedure

### 1. Determine panel kind

```sh
files=$(git diff --name-only "$BASE...HEAD")
all_design=true
has_any=false
for f in $files; do
  has_any=true
  case "$f" in
    designs/*.md|*/designs/*.md) ;;
    DESIGN*.md|*/DESIGN*.md) ;;
    *) all_design=false; break;;
  esac
done
```

If every changed file is under a design directory or matches the `DESIGN*.md` naming convention (used in `endojs/endo` for per-package design documents at `packages/<name>/DESIGN*.md`) and there is at least one changed file, the panel is `design-panel` (route to `solicitor`). Otherwise it is `code-panel` (route to `barrister` for the first round; `justice` for re-runs). The choice is the orchestrator's, not this script's; this script only emits the panel-kind so the orchestrator's heuristic can verify.

### 2. Run the seat probes (code-panel case)

For each seat-probe script under `probes/`, run it against the diff:

```sh
for probe in skills/panel-hints/probes/*.sh; do
  bash "$probe" "$BASE"
done
```

Each probe emits one of:

- `fire <seat>  <one-line reason>` — the signal fired; recommend the seat.
- `skip <seat>` — no signal; the seat is suppressed by default.

The driver collects every `fire` line into the recommended set.

### 3. Always-fire and always-on seats

Two classes of seats fire regardless of probe state:

**Always-on core (9 seats).** Lenses apply to almost every code PR; fire unconditionally on code-panel PRs:

| Seat | Why always-on |
|---|---|
| `assessor` | Correctness logic |
| `typist` | Types and annotations |
| `stylist` | Naming |
| `packager` | Diff hygiene + commit shape |
| `archivist` | Docs + JSDoc-prose accuracy |
| `prover` | Regression evidence |
| `saboteur` | Adversarial inputs |
| `integrator` | Integration coherence |
| `corner-prober` | Edge and corner case enumeration |

The 9th seat (`corner-prober`) joined the always-on core 2026-05-22 per the maintainer's err-on-too-many guidance; its boundary-set enumeration applies broadly enough that signal-triggering it would risk missing edge cases on PRs whose primary diff doesn't trip the content regex.

**Always-fire (2 seats).** Their signal lives outside the diff (in PR comment history or in judgment-based reading of the diff); always fire on code-panel PRs:

| Seat | Why always-fire |
|---|---|
| `scribe` | Knowledge-capture closure — needs PR-comment history |
| `releaser` | Reads the diff for user-facing-ness; needs judgment, not regex |

### 4. Path-triggered seats (9)

| Seat | Trigger |
|---|---|
| `curator` | `**/package.json` exports/main/types field modified; `**/index.{js,ts,mjs}` modified; `**/*.d.ts` modified |
| `surfacer` | ≥2 of `{package.json, index.*, .d.ts, README.md}` modified within one package, OR new package added |
| `migrator` | `**/package.json` `dependencies`/`peerDependencies` modified; multi-package diff (>1 package touched); changeset present |
| `changeset-auditor` | Any `.changeset/*.md` (excluding `README.md` and `config.json`) |
| `benchmarker` | `**/BENCH.md` modified; `**/*.bench.{js,ts}` modified; `**/benchmark/**` modified |
| `gateway` | `tsconfig*.json`, `.eslintrc*`, root `package.json`, `.github/workflows/*.yml`, `.prettierrc*`, `.editorconfig`, `.gitattributes` modified |
| `pruner` | Any `*.md` added or substantially edited (`+` line count > 30) |
| `fast-checker` | `**/test/**` or `**/*.test.{js,ts}` modified; OR `fast-check` already in any `package.json` `devDependencies` |
| `breaker` | Touch to a file containing `M.interface(`, `makeExo`, or `^## Invariants` heading |

### 5. Content-regex-triggered seats (7)

For each, the probe runs `git diff "$BASE...HEAD" -U0 | grep -E '^\+'` and tests for at least one match against the regex set:

| Seat | Regex set |
|---|---|
| `warden` | `\bharden\(`, `globalThis`, `__proto__`, `Object\.prototype`, `from\s+['"]ses['"]`, `from\s+['"]@endo/(init\|lockdown\|exo\|pass-style)`, `\bProxy\b` |
| `locksmith` | `attenuate`, `endowments?`, `Far\(`, `passStyleOf`, `\bE\(`, `\bExo\b`, `makeCapTP`, `\bgrant\w*\b` |
| `purist` | `defineProperty.*enumerable`, `Object\.freeze\(`, `\bharden\b`, `passStyleOf`, `Remotable\w*`, `\bM\.|matches\b` (when paired with `@endo/patterns`) |
| `spec-keeper` | `Reflect\.(apply\|construct\|ownKeys\|deleteProperty)`, `\.call\(\|\.apply\(`, `Number\.MAX_SAFE_INTEGER\|EPSILON`, `Symbol\.(iterator\|asyncIterator)`, `tc39\.es\|webidl\.spec`, polyfill filename pattern |
| `wire-watcher` | `\bsha(256\|512)?\b`, `\bdigest\b`, `\bhash\b`, `JSON\.parse\(`, vref/kref `v\d+-\|o[+-]\d+`, `\bretire(Imports\|Exports)?\b`, `\bsyscall\.` |
| `engine-realist` | `\bWeakMap\b`, `\bWeakRef\b`, `FinalizationRegistry`, `\bcrank\b`, `\b(durable\|virtual\|ephemeral)\b`, `vatstore`, `Float16Array`, `\bharden\b` (when combined with vat-package touch) |

A single regex hit anywhere in the added lines fires the seat. False positives are accepted; false negatives are minimized. The script reports the first hit's `file:line` so the judge can verify.

### 6. Design-panel routing

When step 1 determines the panel kind is `design-panel`, the recommended set is the wholesale seven-seat design panel: `critic`, `skeptic`, `decomplector`, `ergonomist`, `copyeditor`, `pedant`, `novice`. The script does not consult code-panel probes on design-only PRs.

**Cross-panel** seats: on code-panel PRs that include substantial markdown changes (`*.md` with `+` line count > 30 anywhere outside `designs/`), additionally fire `pedant` and `copyeditor` from the design panel. The script lists them under a separate "Cross-panel" section in its output so the judge can verify the cross-fire is wanted.

## Output

A structured stdout report:

```
Panel-kind: code-panel
Always-on core (9): assessor, typist, stylist, packager, archivist, prover, saboteur, integrator, corner-prober
Always-fire (2): scribe, releaser
Path-triggered (5): curator, surfacer, changeset-auditor, gateway, pruner
  curator             packages/foo/package.json (exports field)
  surfacer            packages/foo/{package.json, index.js, README.md}
  changeset-auditor   .changeset/foo-feature.md
  gateway             tsconfig.base.json
  pruner              packages/foo/README.md (+47 lines)
Content-triggered (3): warden, spec-keeper, engine-realist
  warden              packages/foo/src/bar.js:42 (harden\()
  spec-keeper         packages/foo/src/util.js:104 (Reflect.apply)
  engine-realist      packages/foo/src/cache.js:18 (WeakMap)
Cross-panel (0): -
Suppressed (8): migrator, locksmith, breaker, purist, wire-watcher, benchmarker, fast-checker
Recommended total: 19 of 26 code-panel seats.
```

Format:

- **Panel-kind**: `code-panel` or `design-panel`.
- **Always-on core**: comma-separated seat list. No further detail.
- **Always-fire**: same.
- **Path-triggered**: each seat on its own line with one example matching path.
- **Content-triggered**: each seat on its own line with one example `file:line` hit and the matching regex.
- **Cross-panel**: design-panel seats firing on a code-panel round.
- **Suppressed**: seats whose probes all returned `skip`. Listed explicitly so the judge can see what was deliberately omitted.
- **Recommended total**: count vs the total seat count for the panel kind.

The output is meant to be human-readable AND grep-able. The judge greps `^fire` against the per-probe output to assemble the dispatch list; the human-readable report is for the journal audit trail.

## Composition

- **With `skills/panel-review/SKILL.md` § Concurrent dispatch**: the script-recommended set is the input to the judge's concurrent-dispatch fan-out. The judge cites the script's output in its `result` entry alongside the per-juror block summaries.
- **With each judge's role file** (`solicitor`, `barrister`, `justice`): the operating norms name the consultation step at top-of-dispatch.
- **With `skills/pre-push-gates/SKILL.md`**: orthogonal. Gates fire on the fixer's push; panel-hints fires on the judge's dispatch. The two never interact.

## Adding a probe (when a new seat lands)

When the gardener adds a new juror seat, the corresponding probe is added in the same commit:

1. Name the probe by category prefix + seat slug: `probes/B-<seat>.sh` for path-triggered, `probes/C-<seat>.sh` for content-triggered.
2. The script reads the diff via `git diff "$BASE...HEAD" --name-only` (for path patterns) or `git diff "$BASE...HEAD" -U0 | grep -E '^\+'` (for content regexes). It emits one of `fire <seat>  <reason>` or `skip <seat>`.
3. Add a row to *Path-triggered seats* or *Content-regex-triggered seats* in this skill with the seat's trigger pattern and the empirical source.

The driver picks up the new probe automatically (it globs `probes/*.sh`).

## Pitfalls

- **A regex that's too aggressive fires the seat on every PR.** The seat returns "no findings" cleanly, so the cost is one extra dispatch per PR rather than a wrong-action. Still: tune the regex to be specific enough that the seat *would* find something if dispatched. A regex hitting every JS file fails this test.
- **A path pattern that's too narrow misses legitimate triggers.** The bias is the other way: too narrow is worse than too broad. When in doubt, broaden.
- **PR-comment history is not in the diff.** Two seats (scribe, releaser partially) need PR-comment context. They are in always-fire for that reason; do not try to surface PR-comment signals via the probe layer.
- **Design-only detection is exact-match.** A PR with one source change and several design-doc changes is a code-panel PR (the source change keys the routing); pedant and copyeditor still fire as cross-panel. Do not allow a design-only-with-typo escape.
- **Probe output must match the parse contract.** The driver greps `^fire ` and `^skip ` exactly; a probe that emits formatting noise pollutes the recommended set.

## Notes from the field

(Append; terse and dated.)

- _2026-05-22_: initial bootstrap. Always-on core expanded from the proposed 8 to 9 with `corner-prober` per the maintainer's err-on-too-many guidance ("The idea is not to reduce the amount of reviews we are currently doing, but to enable us to vastly expand the juror profiles"). `breaker` moved from always-on candidate to path-triggered: the seat's lens needs `M.interface(` / `makeExo` / `^## Invariants` to be present in the codebase; firing it on every code PR would be over-broad. `fast-checker` moved from always-fire to path-triggered: the test-file path trigger is sharp enough that always-fire would be wasteful, and the seat still picks up codec/numeric/algebraic tests via the path pattern.
