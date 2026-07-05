---
created: 2026-05-20
updated: 2026-06-24
author: gardener
---

# Skill: pre-push-gates

The deterministic gate the gardening state machine runs before every push to a PR branch. The gate runs auto-fixers (Prettier, eslint `--fix`), re-stages their effects silently, runs a small set of garden-specific deterministic probes, and runs the non-auto-fixable check (`yarn typecheck`). Auto-fixable findings produce no separate commit and no surface noise; the fix lands in whatever commit was about to be pushed. Non-auto-fixable findings exit non-zero with a one-line per-finding summary the calling step addresses before retrying.

The skill exists because a PR (#75) surfaced eight recurring maintainer complaints, four of which were deterministic (Prettier drift, ASCII banners in markdown, pull-request citations in package code, file-naming stutter); each had a standing rule already documented elsewhere in the garden. The pre-push gate is the structural fix: by the time a push reaches the panel ([panel](../panel/SKILL.md)), the deterministic class of complaint cannot survive.

The executable counterpart (`pre-push-gates.sh` plus its `probes/` directory) lives under v2 `scripts/` (with the rest of the gardening automation, e.g. `scripts/jobs/gardening/`), not as a sibling of this SKILL.md. This skill is the contract the script implements.

## When to use

- **PR-open gardening step** (the gardening state machine's first push, the maintainer's first impression of the diff): run the gate; address any non-auto-fixable findings; then push.
- **Follow-up-push gardening step** (a fix-loop iteration): same procedure. Auto-fixes silently re-stage into whatever commit was being assembled.
- **Rebase / test-adding steps** touch the diff but call the gate only if their own logic directs it; the gate's primary call sites are the PR-open and follow-up-push steps.

The gate is **not** an orchestrator concern. The liaison and the panel do not run it; their work is at the journal and review surfaces, not the project working tree.

## Inputs

`pre-push-gates.sh [--no-auto-fix] [--probes-only] [--summary] [<project-root>]`

- `<project-root>`: defaults to the current working directory (the gardening worktree's `project/`).
- `--no-auto-fix`: skip the auto-fix stages and only run the probes + typecheck. Used by readers who want to know the current diff's gate state without mutating the tree.
- `--probes-only`: run only the garden-specific probes; skip Prettier, eslint, and typecheck. Used when the calling step has its own format / lint pipeline.
- `--summary`: print one summary line per stage instead of the full output. Default is fail-loud (full output on failure, silent on pass).

## State

- The script is stateless. Each invocation reads the working tree, mutates it (auto-fixes), and exits.
- Re-running is idempotent: a clean tree passes immediately; a dirty tree fixes what it can and reports what it can't.
- The script does **not** commit. Re-staging via `git add` is the gate's only git mutation; the gardening step's existing commit machinery picks up the changes.

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

The probes live in `scripts/.../pre-push-gates/probes/<rule>.sh` under v2 `scripts/`, one script per rule. Each script reads the staged diff (or the diff against `origin/<base>`), prints `pass` or `fail: <reason>` to stdout, and exits 0 or 1 accordingly. The driver script invokes every probe and aggregates.

Probes shipped with the garden today:

| Probe                         | What it checks                                                                                                    | Provenance                              |
| ----------------------------- | ----------------------------------------------------------------------------------------------------------------- | --------------------------------------- |
| `no-ascii-banners`            | No box-drawing chars (U+2500–U+257F), `+--+` / `|...|` boxes, or **banner horizontal-rule comments** (a comment line whose body is four or more repeated `-=*~_` rule characters and nothing else: `// ----`, `// ====`, ` * ----`, `/* ---- */`) in changed `.md` / `.js` / `.ts` files. Directional arrows (`// foo -> bar`), prose dashes, markdown thematic breaks, and code-block data are not banners. See [no-comment-banners](../no-comment-banners/SKILL.md). | PR #238 inline `r3237804603`; PR #75 `r3267751127` (boxes); PR #503 `4573212313` (horizontal rules). Mermaid-over-ASCII rule. |
| `no-pull-citations`           | No `pull/<n>` URLs or `#<n>` references in changed paths under `packages/**/*.{js,md}`.                            | PR #75 `r3267735686`.                   |
| `no-inline-import-jsdoc`      | No `/** @type {import('...').X} */` inline form in changed `.js` / `.ts` files. Require `@import` instead.         | PR #75 `r3223741240`; per-repo CLAUDE.md "we prefer `@import` jsdoc". |
| `test-package-no-main`        | A package under `packages/*-test/` or whose only files are under `test/` has no `main`, `module`, or `exports` in its `package.json`. | PR #75 `r3223667088`.                   |
| `security-md-hash-uniform`    | Every `packages/*/SECURITY.md` has the same SHA-256 hash.                                                          | PR #75 `r3223750050`. |
| `filename-no-stutter`         | No file at `packages/<P>/.../<P>-foo.<ext>` (filename basename does not start with or contain `_<P>_`).            | PR #75 `r3223811705`.                   |
| `sentence-per-line-md`        | Markdown files in changed paths use sentence-per-line shape (no multi-sentence physical lines outside of code blocks). | PR #75 `r3270500584` + CONTRIBUTING.md style guide. |
| `no-non-ascii-in-source`      | No non-ASCII characters in newly-added lines of `packages/<pkg>/src/` and `packages/<pkg>/lib/` `.js` / `.ts` / `.mjs` / `.cjs` files. Test paths and fixtures excluded by path. Per-file opt-out via a `/* ascii-exempt */` marker on a line within the first 5. | PR #417 inline `r3353301111` (kriskowal 2026-06-04: "Avoid non-ASCII. This is in the guide… deterministic automation to keep source generally in the ASCII range."). |
| `typedefs-belong-in-dts`      | No changed `**/src/**/*.js` file is a **types-only module** (the `types.js` masquerade): it declares one or more `@typedef` / `@callback` and, once comments and the empty `export {}` module marker are stripped, carries **no runtime code**. Such a file should be a hand-written `.d.ts` (repointed via the `types` export condition). **Non-auto-fixable** (moving to `.d.ts` + repointing the export needs judgment): fails the gate with a one-line summary. Narrow by design — an implementation file with runtime code plus a private single-use inline `@typedef` never matches, honoring the escape hatch. | `endojs/endo-but-for-bots#58` review `4612637233` (`trace-aggregator.js:41`, "Typedefs in .d.ts, please. Adjust the garden to avoid this in the future with builder directives and a reviewer.") + `#442` review `4629047816` (`packages/platform/src/fs/types.js`, the same ask on a whole typedef-only module). |

Each probe is small (typically 5 to 30 lines of shell or awk). A new probe is one new script in `probes/`; the driver picks it up by glob.

A probe's first finding is enough to fail it; the driver runs every probe so the final report enumerates all findings rather than just the first.

### 4. Non-auto-fixable stage: `yarn typecheck`

```sh
if jq -e '.scripts.typecheck' package.json >/dev/null 2>&1; then
  yarn typecheck
fi
```

A typecheck failure is the gate's terminal failure. The calling step addresses the underlying type error and re-runs.

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

- Exit 0: gate passed (possibly after auto-fixes); the calling step proceeds to push.
- Exit non-zero: at least one non-auto-fixable finding; the calling step addresses it before pushing.

The exit code is the gate's sole machine-readable signal. The summary (printed to stdout) is for the calling step's context.

## Composition with other skills

- **[yarn-lock-separate-commit]**: the yarn-lock-as-its-own-commit rule still applies on top of the gate. The gate does not stage `yarn.lock` changes from its own auto-fixes; if Prettier or eslint touched `yarn.lock` (rare), the calling step splits the commit per the lockfile-separation skill.
- **[pre-pr-checklist](../pre-pr-checklist/SKILL.md)**: the pre-PR checklist is the broader human-facing review-yourself list; this gate is the deterministic subset of it. The checklist's items that are not in the gate (e.g., "PR body uses behavior-over-diff prose") remain the calling step's responsibility.
- **[em-dash-style]**: not currently gated (em-dash discipline applies to journal entries and garden documents, not to all code). A future probe `no-em-dashes-in-prose` would cover prose under `docs/` and README files; for now the rule stays in role files.
- **[local-verify](../local-verify/SKILL.md)**: the complementary half of the push path. This gate runs the mutating style/probe checks (Prettier and eslint auto-fix, garden-specific probes, typecheck) and re-stages; `local-verify` runs the project's full verification suite (format/lint/build/test/docgen) read-only and captures any failure by git blob SHA for selective debugging-agent inspection. The push path runs the style gate, then `local-verify`, then pushes.

## Adding a probe

A new probe is one shell script under `probes/` (in v2 `scripts/`):

1. Name the file by the rule (`no-em-dashes.sh`, `single-changeset-per-pr.sh`).
2. The script reads the staged diff via `git diff --staged --name-only` (or `git diff origin/<base>...HEAD --name-only` when the diff isn't yet staged).
3. The script prints `pass` or `fail: <one-line reason per finding>` and exits 0 or 1.
4. Add a row to this skill's *Garden-specific deterministic probes* table with the rule, what it checks, and the provenance.

The driver does not need to know about the new probe; it walks `probes/*.sh` at runtime.

## Pitfalls

- **A probe that's too aggressive blocks a legitimate diff.** Each probe should fail on a clear and narrow signal. Probes that need judgment go to the panel as a juror seat (e.g., `pruner` for README padding), not to the gate. The line: deterministic-yes-or-no is gate-eligible; anything that requires reading the change's intent is juror-eligible. See [panel](../panel/SKILL.md).
- **Auto-fix loops that don't converge.** A `yarn format` that fights with `yarn lint --fix` would loop forever. The gate runs each stage once. If a project's tools genuinely disagree, that's a project bug to surface, not a gate bug to retry.
- **Per-project specialization** belongs in the project's own scripts (the `yarn lint` and `yarn typecheck` scripts the gate invokes), not in the gate driver. The gate is the contract; the project's scripts implement.

## Notes from the field

(Append; terse and dated.)

- _2026-05-20_: initial bootstrap. The seven probes ship with the skill; provenance traces to PR #75 (six items) and PR #238 (the mermaid rule).
- _2026-06-04_: added `no-non-ascii-in-source` probe per the maintainer's inline review on `endojs/endo-but-for-bots#417` (comment `r3353301111`): *"Avoid non-ASCII. This is in the guide. … deterministic automation to keep source generally in the ASCII range."* The probe is the deterministic gate: future pushes that introduce a non-ASCII character in `packages/<pkg>/src/` or `lib/` source fail at the gate. The per-file `/* ascii-exempt */` marker opts out a file that legitimately carries non-ASCII (rare under src/lib).
- _2026-06-18_: panel observation on `endojs/endo-but-for-bots#468`: an `// eslint-disable-next-line guard-for-in` comment preceded a `for...of` loop, where `guard-for-in` does not apply. An eslint-disable comment that names a rule that never fires on the annotated line is a no-op but actively misleads future maintainers (and silently fails to suppress the real rule). Pushes that write a disable comment verify the rule name against the actual ESLint output before committing; the panel's type/meta-comment seat is the natural finder. No deterministic probe landed because the check requires running ESLint with each disabled rule individually, which is heavy; the discipline is the gate.
- _2026-06-24_: migrated from v1. Rewired builder/fixer (the v1 call sites) to "the gardening state machine's PR-open and follow-up-push steps"; the executable `pre-push-gates.sh` + `probes/` now live under v2 `scripts/` rather than as a sibling of this skill. The panel cross-reference points at [panel](../panel/SKILL.md).
- _2026-07-05_: added `typedefs-belong-in-dts` probe (`scripts/jobs/gardening/pre-push-gates/probes/typedefs-belong-in-dts.sh`) — the tier-1 deterministic gate the maintainer twice asked for. It fails when a changed `**/src/**/*.js` file is a **types-only module**: a character scanner strips `//` and `/* */` (incl. JSDoc) comments while skipping string literals, and the file fires only when it declares `@typedef`/`@callback` yet has no runtime code left beyond the empty `export {}` marker. Provenance and why it exists: `endojs/endo-but-for-bots#58` review `4612637233` ("Typedefs in .d.ts, please. Adjust the garden to avoid this in the future with builder directives and a reviewer.", 2026-07-02) delivered only the two weakest tiers (a builder directive + the always-on typist seat), and the same convention was violated again two days later on `#442` (`packages/platform/src/fs/types.js`, review `4629047816`) whose gauntlet never ran — so no reviewer but the maintainer remained. The gate cannot be skipped or forgotten. It is **narrow on purpose** (§ Pitfalls): an implementation `.js` with any runtime code never matches, so a module-private single-use inline `@typedef` is left alone; the whole-file `types.js` shape is the only thing it catches. Verified fires on the `#442` pre-fix `types.js` and abstains on the `#58` `trace-aggregator.js` (an impl file whose inline typedef is the typist seat's catch, not the gate's). Cluster: `review-misses/clusters/typedef-location-dts.md`.
- _2026-06-25_: widened `no-ascii-banners` to also catch banner horizontal-rule comments (a comment line whose body is four or more repeated `-=*~_` characters, e.g. `// ---------`). Provenance: PR `endojs/endo-but-for-bots#503` review `4573212313`, where the maintainer flagged a `// ----` banner in a test comment and asked the garden to anticipate the feedback going forward. The reconstructed passable-byte-arrays PR carried roughly forty such rules across six files; the old box-only definition missed them. The rule now has a single citeable home at [no-comment-banners](../no-comment-banners/SKILL.md), which the `archivist` (code panel) and `pedant` (design panel) seats reference as the review backstop. When the executable probe is implemented, broaden its match accordingly: a comment-only line (`//`, `#`, ` * `, or `/* … */`) whose stripped body is `^[-=*~_]{4,}$`.
