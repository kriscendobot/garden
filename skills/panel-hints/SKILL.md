---
created: 2026-05-22
updated: 2026-08-05
author: gardener
---

# Skill: panel-hints

A deterministic diff-signal recommender that suggests which jury seats to fan out to on a given PR. The scripted panel run a gardener supervises ([panel](../panel/SKILL.md), `scripts/jobs/gardening/panel.sh`) consults it at its seat-selection step: it senses the panel kind from the diff's path set, then emits the subset of seats whose lens has a signal in the diff. The skill exists so the panel can keep growing into narrower and more specialized seats without proportionally growing the per-PR seat fan-out: as new seats accrete, only the subset whose lens has a signal fires on any given PR.

The bias is toward firing. Maintainer framing 2026-05-22: *"err on the side of too many reviewers. The idea is not to reduce the amount of reviews we are currently doing, but to enable us to vastly expand the juror profiles and make juror profiles narrower."* Any positive signal triggers the seat; suppression requires *all* signals to be absent.

## When to use

- **Panel-run seat selection.** The supervised panel run (`panel.sh`) consults `panel-hints.sh` to compute the seat list before fanning one `claude -p` per seat. The recommended set is a strong default the supervisor may widen or trim; it is **not** a hard gate.
- **Maintainer ad-hoc.** When the maintainer wants to know which seats *would* fire on a given diff before authorizing a run.
- **Smoke-test after a new seat lands.** When the gardener adds a seat, its probe is added under `probes/` and verified to fire on a known-relevant historical diff.

## Relationship to the panel script's sense step

`panel.sh` already senses panel kind (code vs design) via the gardening `sense.sh` family and its own exact-match path test. `panel-hints.sh` re-derives the panel kind (the two use the same exact-match rule, so they agree) and additionally returns the recommended *seat subset* for the code panel. The seat-subset logic is the part `sense.sh` does not cover; `panel-hints.sh` is the right home for it because the per-seat probes are a growing catalog that wants to live next to this skill rather than inside the gardening state machine. If a future refactor wants the seat-subset logic in the state machine, fold the probe loop into `scripts/jobs/gardening/sense.sh` and have `panel.sh` call it directly; until then the sibling `panel-hints.sh` is the source of truth and `panel.sh` shells it.

## Inputs

`panel-hints.sh [--base <ref>] [--design-paths <glob>] [<project-root>]`

- `<project-root>`: defaults to the current working directory. The script reads the diff between `<base>` and `HEAD` against this tree.
- `--base <ref>`: the diff's base, defaulting to the upstream the current branch tracks, else `origin/master`. Common values: `origin/master`, `origin/llm`.
- `--design-paths <glob>`: the project's design directory pattern, defaulting to `designs/`. Used to detect design-only PRs that route to the design panel.

## State

Stateless. Each invocation reads the diff fresh.

## Procedure

### 1. Determine panel kind

```sh
files=$(git diff --name-only "$BASE...HEAD")
all_design=true
for f in $files; do
  case "$f" in
    designs/*.md|*/designs/*.md) ;;
    DESIGN*.md|*/DESIGN*.md) ;;
    *) all_design=false; break;;
  esac
done
```

If every changed file is under a design directory or matches `DESIGN*.md` (used in `endojs/endo` for per-package design docs at `packages/<name>/DESIGN*.md`) and there is at least one changed file, the panel is `design-panel`; otherwise `code-panel`. The script emits the panel kind; the panel run's own sense step agrees by the same exact-match rule.

### 2. Run the seat probes (code-panel case)

For each seat-probe under `probes/`, run it against the diff:

```sh
for probe in skills/panel-hints/probes/*.sh; do
  BASE="$BASE" bash "$probe"
done
```

Each probe emits one of:

- `fire <seat>  <one-line reason>` — the signal fired; recommend the seat.
- `skip <seat>` — no signal; suppressed by default.

Every `fire` line collects into the recommended set.

### 3. Always-fire and always-on seats

**Always-on core (9 seats).** Lenses apply to almost every code PR; fire unconditionally on code-panel PRs: `assessor`, `typist`, `stylist`, `packager`, `archivist`, `prover`, `saboteur`, `integrator`, `corner-prober`. (`corner-prober` joined the always-on core 2026-05-22 per the err-on-too-many guidance; its boundary-set enumeration applies broadly enough that signal-triggering it would risk missing edge cases.)

**Always-fire (3 seats).** Their signal lives outside the diff (in PR-comment history, in judgment-based reading, or in a coverage report): `scribe` (knowledge-capture closure; needs PR-comment history), `releaser` (reads the diff for user-facing-ness; needs judgment, not regex), and `coverage-auditor` (test coverage of new lines; its signal is the c8 report, not the diff shape). The `coverage-auditor` is *always-fire* yet **cost-gated at dispatch**: `scripts/jobs/gardening/seat-gate-coverage-auditor.sh` runs a deterministic c8 coverage pre-pass first and spends its `claude -p` only when the change has uncovered new lines, so recommending it every code round costs nothing on a well-covered change.

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

For each, the probe runs `git diff "$BASE...HEAD" -U0 | grep -E '^\+'` and tests for at least one match against the regex set: `warden`, `locksmith`, `purist`, `spec-keeper`, `wire-watcher`, `engine-realist`, `typist`. A single regex hit anywhere in the added lines fires the seat; false positives are accepted, false negatives minimized. The probe reports the first hit so the seat list can be verified. The full regex sets live in the per-seat `probes/C-<seat>.sh` files. The `purist` probe includes recognizable reimplementations of Endo primitives (SHA-256, byte/text codecs, base64, hex, ASCII, `insist`, and Rust base64), routing ambiguous cases to judgment while the narrower pre-push probe blocks unambiguous JavaScript/TypeScript shapes. The `spec-keeper` probe additionally fires on an added `M.any()` or broad `M.record()` in a changed `.ts`/`.js` exo or `M.interface(...)` guard, so the seat can decide whether a documented compatibility exception justifies it. The typist probe fires on an inline `import()` type reference in a JSDoc tag, because the always-on seat is still the backstop when a gauntlet skips the gate.

### 6. Design-panel routing

When step 1 determines `design-panel`, the recommended set is the wholesale seven-seat design panel: `critic`, `skeptic`, `decomplector`, `ergonomist`, `copyeditor`, `pedant`, `novice`. The script does not consult code-panel probes on design-only PRs.

**Cross-panel** seats: on code-panel PRs with substantial markdown changes (`*.md` with `+` line count > 30 anywhere outside `designs/`), additionally fire `pedant` and `copyeditor` from the design panel. The script lists them under a separate "Cross-panel" section so the cross-fire can be verified.

## Output

A structured, human-readable AND grep-able stdout report:

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

The panel run greps `^fire ` against the per-probe output to assemble the seat list; the human-readable report is for the run's audit trail. The recommended set is typically 12-22 seats on a code-panel first round, 10-18 on a re-run, and 7 on a design-only PR.

## Composition with other skills

- **With [panel](../panel/SKILL.md):** the script-recommended set is the input to the panel run's seat fan-out; the run records the script's output in its run dir alongside the per-seat blocks.
- **With [panel-review](../panel-review/SKILL.md):** orthogonal. panel-hints picks *which* seats run; panel-review is *what each seat does* and how the aggregate decides.
- **With [pre-push-gates]:** orthogonal. Gates fire on the fixer's push; panel-hints fires at panel-run seat selection. They never interact.

## Adding a probe (when a new seat lands)

When the gardener adds a seat, the corresponding probe is added in the same commit:

1. Name by category prefix + seat slug: `probes/B-<seat>.sh` (path-triggered), `probes/C-<seat>.sh` (content-triggered), `probes/X-<seat>.sh` (cross-panel). **Exception — always-fire seats** whose signal is not a diff path/content shape (e.g. `scribe`, `releaser`, `coverage-auditor`) have no probe; they are listed in the `ALWAYS_FIRE` string instead. `coverage-auditor` in particular is gated downstream at *dispatch* by its deterministic c8 pre-pass (`seat-gate-coverage-auditor.sh`), not by a diff probe.
2. The probe reads the diff via `git diff "$BASE...HEAD" --name-only` (path patterns) or `git diff "$BASE...HEAD" -U0 | grep -E '^\+'` (content regexes) and emits one of `fire <seat>  <reason>` or `skip <seat>`.
3. Add a row to *Path-triggered seats* or *Content-regex-triggered seats* with the trigger and empirical source. When extending an existing seat's probe, update its documented trigger in the same commit as the seat amendment.

`panel-hints.sh` picks up the new probe automatically (it globs `probes/*.sh`).

## Pitfalls

- **A regex that's too aggressive fires the seat on every PR.** The seat returns "no findings" cleanly, so the cost is one extra `claude -p` per PR rather than a wrong action. Still: tune the regex specific enough that the seat *would* find something if it ran.
- **A path pattern that's too narrow misses legitimate triggers.** The bias is the other way: too narrow is worse than too broad. When in doubt, broaden.
- **PR-comment history is not in the diff.** Two seats (scribe, releaser partially) need PR-comment context; they are in always-fire for that reason. Do not surface PR-comment signals through the probe layer.
- **Design-only detection is exact-match.** A PR with one source change and several design-doc changes is a code-panel PR (the source change keys the routing); pedant and copyeditor still fire as cross-panel. No design-only-with-typo escape.
- **Probe output must match the parse contract.** The driver greps `^fire ` and `^skip ` exactly; a probe that emits formatting noise pollutes the recommended set.

## Notes from the field

- _2026-06-24_: migrated to v2. The helper `panel-hints.sh` and the `probes/` directory are pure diff-scanners with no v1 coordination dependency, so both are reproduced verbatim alongside this skill. The only wording change is the consumer: v1's three judges consulted the script at top-of-dispatch; v2's supervised panel run (`scripts/jobs/gardening/panel.sh`) consults it at its seat-selection step. The seat-subset logic could alternatively be folded into the gardening `sense.sh`; until then the sibling helper is the source of truth.
- _2026-08-05_: widened `C-purist.sh` with the deterministic signature catalog from the consolidated `prefer-endo-primitives` review-miss cluster. It now fires the purist on added hand-rolled SHA-256, byte/text encoding, base64, hex, ASCII, `insist`, and Rust base64 shapes; `scripts/jobs/test/review-convention-probes-test.sh` relitigates the signatures and verifies the Rust review-only route.
- _2026-05-22_: initial bootstrap. Always-on core expanded from 8 to 9 with `corner-prober`. `breaker` moved from always-on candidate to path-triggered (its lens needs `M.interface(` / `makeExo` / `^## Invariants` present). `fast-checker` moved from always-fire to path-triggered (the test-file path trigger is sharp enough).
