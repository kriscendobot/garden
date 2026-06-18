---
created: 2026-05-20
updated: 2026-06-04
author: gardener
---

# Skill: pre-push-gates

The deterministic gate the [builder](../../roles/builder/AGENT.md) and [fixer](../../roles/fixer/AGENT.md) run before every push to a PR branch. The gate runs auto-fixers (Prettier, eslint `--fix`), re-stages their effects silently, runs a small set of garden-specific deterministic probes, and runs the non-auto-fixable check (`yarn typecheck`). Auto-fixable findings produce no separate commit and no surface noise; the fix lands in whatever commit the builder or fixer was about to push. Non-auto-fixable findings exit non-zero with a one-line per-finding summary the calling role addresses before retrying.

The skill exists because PR #75 surfaced eight recurring maintainer complaints, four of which were deterministic (Prettier drift, ASCII banners in markdown, pull-request citations in package code, file-naming stutter); each had a standing rule already documented elsewhere in the garden. The pre-push gate is the structural fix: by the time a fixer push reaches the panel, the deterministic class of complaint cannot survive.

## When to use

- **Builder**: before opening the initial draft PR. Run the gate; address any non-auto-fixable findings; then push. The builder's first push is the maintainer's first impression of the diff; the gate cleans it.
- **Fixer**: before every follow-up push. Same procedure. Auto-fixes silently re-stage into whatever commit the fixer was assembling.
- **Cleaner / weaver**: not directly. Both touch the diff (cleaner adds tests; weaver rebases); each can invoke the gate if its operating norms direct it to, but the gate's primary call sites are builder and fixer.

The gate is **not** an orchestrator concern. The liaison, steward, and judge do not run it; their work is at the journal and review surfaces, not the project working tree.

## Inputs

`pre-push-gates.sh [--no-auto-fix] [--probes-only] [--summary] [<project-root>]`

- `<project-root>`: defaults to the current working directory (the calling role's `project/` worktree).
- `--no-auto-fix`: skip the auto-fix stages and only run the probes + typecheck. Used by readers who want to know the current diff's gate state without mutating the tree.
- `--probes-only`: run only the garden-specific probes; skip Prettier, eslint, and typecheck. Used when the calling role has its own format / lint pipeline.
- `--summary`: print one summary line per stage instead of the full output. Default is fail-loud (full output on failure, silent on pass).

## State

- The script is stateless. Each invocation reads the working tree, mutates it (auto-fixes), and exits.
- Re-running is idempotent: a clean tree passes immediately; a dirty tree fixes what it can and reports what it can't.
- The script does **not** commit. Re-staging via `git add` is the gate's only git mutation; the calling role's existing commit machinery picks up the changes.

## Procedure

Each stage's exit code is captured; the script exits with the highest non-zero code at the end. Auto-fixable stages do not contribute to the exit code unless their fixer itself fails.

### 1. Auto-fix stage: `yarn format`

```sh
cd "$PROJECT_ROOT"
if jq -e '.scripts.format' package.json >/dev/null 2>&1; then
  yarn format
  git add -A   # re-stage whatever yarn format changed
fi
```

A project without a `format` script in its `package.json` skips this stage. The garden's primary repos (`endojs/endo-but-for-bots`, `endojs/endo`, `Agoric/agoric-sdk`) all carry the script.

### 2. Auto-fix stage: `yarn lint --fix`

```sh
if jq -e '.scripts.lint' package.json >/dev/null 2>&1; then
  yarn lint --fix 2>/dev/null || yarn lint --fix
  git add -A
fi
```

Some projects' `lint` script doesn't accept `--fix`; the fallback path swallows the error and re-runs without auto-fix. The garden-specific probes (stage 3) catch the rest.

### 3. Garden-specific deterministic probes

The probes live in `skills/pre-push-gates/probes/<rule>.sh`, one script per rule. Each script reads the staged diff (or the diff against `origin/<base>`), prints `pass` or `fail: <reason>` to stdout, and exits 0 or 1 accordingly. The driver script invokes every probe and aggregates.

Probes shipped with the garden today:

| Probe                         | What it checks                                                                                                    | Provenance                              |
| ----------------------------- | ----------------------------------------------------------------------------------------------------------------- | --------------------------------------- |
| `no-ascii-banners`            | No box-drawing chars (U+2500–U+257F) or `+--+` / `|...|` boxes in changed `.md` or `.js` files.                   | PR #238 inline `r3237804603`; PR #75 `r3267751127`. Mermaid-over-ASCII rule on `roles/jurors/pedant/AGENT.md`. |
| `no-pull-citations`           | No `pull/<n>` URLs or `#<n>` references in changed paths under `packages/**/*.{js,md}`.                            | PR #75 `r3267735686`.                   |
| `no-inline-import-jsdoc`      | No `/** @type {import('...').X} */` inline form in changed `.js` / `.ts` files. Require `@import` instead.         | PR #75 `r3223741240`; per-repo CLAUDE.md "we prefer `@import` jsdoc". |
| `test-package-no-main`        | A package under `packages/*-test/` or whose only files are under `test/` has no `main`, `module`, or `exports` in its `package.json`. | PR #75 `r3223667088`.                   |
| `security-md-hash-uniform`    | Every `packages/*/SECURITY.md` has the same SHA-256 hash.                                                          | PR #75 `r3223750050` ("dispatch a builder to create a CI rule"). |
| `filename-no-stutter`         | No file at `packages/<P>/.../<P>-foo.<ext>` (filename basename does not start with or contain `_<P>_`).            | PR #75 `r3223811705`.                   |
| `sentence-per-line-md`        | Markdown files in changed paths use sentence-per-line shape (no multi-sentence physical lines outside of code blocks). | PR #75 `r3270500584` + CONTRIBUTING.md style guide. |
| `no-non-ascii-in-source`      | No non-ASCII characters in newly-added lines of `packages/<pkg>/src/` and `packages/<pkg>/lib/` `.js` / `.ts` / `.mjs` / `.cjs` files. Test paths and fixtures excluded by path. Per-file opt-out via a `/* ascii-exempt */` marker on a line within the first 5. | PR #417 inline `r3353301111` (kriskowal 2026-06-04: "Avoid non-ASCII. This is in the guide. Dispatch a gardener to revise the driver to have deterministic automation to keep source generally in the ASCII range."). |

Each probe is small (typically 5 to 30 lines of shell or awk). A new probe is one new script in `probes/`; the driver picks it up by glob.

A probe's first finding is enough to fail it; the driver runs every probe so the final report enumerates all findings rather than just the first.

### 4. Non-auto-fixable stage: `yarn typecheck`

```sh
if jq -e '.scripts.typecheck' package.json >/dev/null 2>&1; then
  yarn typecheck
fi
```

A typecheck failure is the gate's terminal failure. The calling role addresses the underlying type error and re-runs.

### 5. Summary

```
yarn format     pass (auto-fixed 3 files; re-staged)
yarn lint --fix pass (no changes)
probes:
  no-ascii-banners       pass
  no-pull-citations      pass
  no-inline-import-jsdoc pass
  test-package-no-main   pass
  security-md-hash-uniform pass
  filename-no-stutter    fail: packages/chacha12/test/chacha12-fill-bytes.bench.js stutters chacha12
  sentence-per-line-md   pass
yarn typecheck  pass

result: 1 finding (filename-no-stutter); address and re-run.
```

The exit code is the worst per-stage exit (0 if all probes passed, 1 if any failed, 2 if typecheck failed, etc.).

## Output

- Exit 0: gate passed (possibly after auto-fixes); the calling role proceeds to push.
- Exit non-zero: at least one non-auto-fixable finding; the calling role addresses it before pushing.

The exit code is the gate's sole machine-readable signal. The summary (printed to stdout) is for the calling role's context.

## Composition with other skills

- **`skills/yarn-lock-separate-commit/SKILL.md`**: the yarn-lock-as-its-own-commit rule still applies on top of the gate. The gate does not stage `yarn.lock` changes from its own auto-fixes; if Prettier or eslint touched `yarn.lock` (rare), the calling role splits the commit per the lockfile-separation skill.
- **`skills/pre-pr-checklist/SKILL.md`**: the pre-PR checklist is the broader human-facing review-yourself list; this gate is the deterministic subset of it. The checklist's items that are not in the gate (e.g., "PR body uses behavior-over-diff prose") remain the calling role's responsibility.
- **`skills/em-dash-style/SKILL.md`**: not currently gated (em-dash discipline applies to journal entries and garden documents, not to all code). A future probe `no-em-dashes-in-prose` would cover prose under `docs/` and README files; for now the rule stays in role files.

## Adding a probe

A new probe is one shell script under `probes/`:

1. Name the file by the rule (`no-em-dashes.sh`, `single-changeset-per-pr.sh`).
2. The script reads the staged diff via `git diff --staged --name-only` (or `git diff origin/<base>...HEAD --name-only` when the diff isn't yet staged).
3. The script prints `pass` or `fail: <one-line reason per finding>` and exits 0 or 1.
4. Add a row to this skill's *Garden-specific deterministic probes* table with the rule, what it checks, and the provenance.

The driver does not need to know about the new probe; it walks `probes/*.sh` at runtime.

## Pitfalls

- **A probe that's too aggressive blocks the builder on legitimate diffs.** Each probe should fail on a clear and narrow signal. Probes that need judgment go to the panel as a juror seat (e.g., `pruner` for README padding), not to the gate. The line: deterministic-yes-or-no is gate-eligible; anything that requires reading the change's intent is juror-eligible.
- **Auto-fix loops that don't converge.** A `yarn format` that fights with `yarn lint --fix` would loop forever. The gate runs each stage once. If a project's tools genuinely disagree, that's a project bug to surface, not a gate bug to retry.
- **Per-project specialization** belongs in the project's own scripts (the `yarn lint` and `yarn typecheck` scripts the gate invokes), not in the gate driver. The gate is the contract; the project's scripts implement.

## Notes from the field

(Append; terse and dated.)

- _2026-05-20_: initial bootstrap. The seven probes ship with the skill; provenance traces to PR #75 (six items) and PR #238 (the mermaid rule). The next several PRs through the gamut will exercise the gate; expect new probes to land for patterns the maintainer surfaces that the seven do not catch.

- _2026-06-04_: added `no-non-ascii-in-source` probe per the maintainer's inline review on `endojs/endo-but-for-bots#417` (comment `r3353301111`): *"Avoid non-ASCII. This is in the guide. Dispatch a gardener to revise the driver to have deterministic automation to keep source generally in the ASCII range."* The fixer that addressed the four `§` (U+00A7) instances in `packages/ses/src/permits.js` forwarded the gardener-level ask via `journal/entries/2026/06/04/044044Z-message-fixer-bb2325.md`. The probe is the deterministic gate: future builder, fixer, and weaver pushes that introduce a non-ASCII character in `packages/<pkg>/src/` or `lib/` source fail at the gate. The per-file `/* ascii-exempt */` marker opts out a file that legitimately carries non-ASCII (rare under src/lib; the path glob already excludes the typical UTF-8-round-trip test paths).

- _2026-06-18_: panel observation on `endojs/endo-but-for-bots#468` (justice round 2): an `// eslint-disable-next-line guard-for-in` comment preceded a `for...of` loop, where `guard-for-in` does not apply. An eslint-disable comment that names a rule that never fires on the annotated line is a no-op but actively misleads future maintainers (and silently fails to suppress the real rule). Builders and fixers writing a disable comment verify the rule name against the actual ESLint output before committing; reviewers (typist seat is the natural finder, since type annotations and eslint-disable are both meta-comments on the line below) flag mismatches. No deterministic probe landed because the check requires running ESLint with each disabled rule individually, which is heavy; the discipline is the gate. Precipitating message: `journal/entries/2026/06/18/090921Z-message-justice-4e49e6.md`.
