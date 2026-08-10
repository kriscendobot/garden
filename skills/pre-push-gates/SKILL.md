---
created: 2026-05-20
updated: 2026-08-10
author: gardener
---

# Skill: pre-push-gates

The deterministic gate the gardening state machine runs before every push to a PR branch. The gate runs auto-fixers (Prettier, eslint `--fix`), re-stages their effects silently, runs a small set of garden-specific deterministic probes, and runs the non-auto-fixable check (`yarn typecheck`). Auto-fixable findings produce no separate commit and no surface noise; the fix lands in whatever commit was about to be pushed. Non-auto-fixable findings exit non-zero with a one-line per-finding summary the calling step addresses before retrying.

The skill began after a PR (#75) surfaced recurring maintainer complaints that could be checked mechanically. The executable gate now guarantees the format/lint/typecheck stages and the probes that actually ship in its probe directory. Other deterministic-looking conventions remain checklist or panel responsibilities until they acquire an executable probe; the inventory below is authoritative.

The executable counterpart is [`scripts/jobs/gardening/pre-push-gates.sh`](../../scripts/jobs/gardening/pre-push-gates.sh); its probes live in the adjacent `pre-push-gates/probes/` directory. The gardening state machine invokes the driver immediately before `local-verify.sh`. This skill is the contract the script implements.

## When to use

- **PR-open gardening step** (the gardening state machine's first push, the maintainer's first impression of the diff): run the gate; address any non-auto-fixable findings; then push.
- **Follow-up-push gardening step** (a fix-loop iteration): same procedure. Auto-fixes silently re-stage into whatever commit was being assembled.
- **Rebase / test-adding steps** touch the diff but call the gate only if their own logic directs it; the gate's primary call sites are the PR-open and follow-up-push steps.

The gate is **not** an orchestrator concern. The liaison and the panel do not run it; their work is at the journal and review surfaces, not the project working tree.

## Inputs

`scripts/jobs/gardening/pre-push-gates.sh [--no-auto-fix] [--probes-only] [--summary] [--base-ref <ref>] [<project-root>]`

- `<project-root>`: defaults to the current working directory (the gardening worktree's `project/`).
- `--no-auto-fix`: skip the auto-fix stages and only run the probes + typecheck. Used by readers who want to know the current diff's gate state without mutating the tree.
- `--probes-only`: run only the garden-specific probes; skip Prettier, eslint, and typecheck. Used when the calling step has its own format / lint pipeline.
- `--summary`: print one summary line per stage instead of the full output. Default is fail-loud (full output on failure, silent on pass).
- `--base-ref <ref>`: inspect committed changes in `<ref>...HEAD` instead of the staged/unstaged diff. The gardening state machine passes its base ref so a clean, already-committed PR worktree is still probed before push.

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
  yarn run format
  git add -A   # re-stage whatever yarn format changed
fi
```

A project without a `format` script in its `package.json` skips this stage. The garden's primary repos (`endojs/endo-but-for-bots`, `endojs/endo`, `Agoric/agoric-sdk`) all carry the script.

### 2. Auto-fix stage: `yarn lint --fix`

```sh
if jq -e '.scripts.lint' package.json >/dev/null 2>&1; then
  yarn run lint --fix
  git add -A
fi
```

If a project's `lint` script does not accept `--fix`, the stage fails loudly. Such a project can invoke the driver with `--probes-only` after running its own format and lint pipeline.

### 3. Garden-specific deterministic probes

The probes live in `scripts/jobs/gardening/pre-push-gates/probes/<rule>.sh`, one script per rule. Each script reads `<base>...HEAD` when the driver supplies `--base-ref`; otherwise it reads the staged diff, falling back to the unstaged working-tree diff when nothing is staged. It prints `pass` or `fail: <reason>` and exits 0 or 1. The driver discovers every executable `probes/*.sh`, so adding a probe requires no driver edit.

Probes shipped with the garden today:

| Probe                         | What it checks                                                                                                    | Provenance                              |
| ----------------------------- | ----------------------------------------------------------------------------------------------------------------- | --------------------------------------- |
| `no-inline-import-jsdoc`      | No **added** inline `import('...')` or `import("...")` type reference in a changed `.js` / `.mjs` / `.cjs` / `.jsx` / `.ts` / `.tsx` file's JSDoc. Covers every tag, including `@param`, `@returns`, `@type`, `@typedef`, `@satisfies`, and `@template`, plus a bare `{import('...')}` JSDoc type. The probe reads JSDoc blocks from the post-change file, so source strings and ordinary comments do not match. **Non-auto-fixable:** add a top-of-file `@import` tag and use a bare type reference. Per-file escape hatch: `inline-import-exempt` in the first five lines. | PR #75 `r3223741240`; repeated miss `endojs/endo-but-for-bots#721` (`packages/reminder/src/store.js`). |
| `typedefs-belong-in-dts`      | No changed `**/src/**/*.js` file is a **types-only module** (the `types.js` masquerade): it declares one or more `@typedef` / `@callback` and, once comments and the empty `export {}` module marker are stripped, carries **no runtime code**. Such a file should be a hand-written `.d.ts` (repointed via the `types` export condition). **Non-auto-fixable** (moving to `.d.ts` + repointing the export needs judgment): fails the gate with a one-line summary. Narrow by design — an implementation file with runtime code plus a private single-use inline `@typedef` never matches, honoring the escape hatch. | `endojs/endo-but-for-bots#58` review `4612637233` (`trace-aggregator.js:41`, "Typedefs in .d.ts, please. Adjust the garden to avoid this in the future with builder directives and a reviewer.") + `#442` review `4629047816` (`packages/platform/src/fs/types.js`, the same ask on a whole typedef-only module). |
| `typist-friendly-code-points` | No **added** line of a changed `.md` file carries a code point that is difficult for a typist to produce: arrows (`→` U+2192 and kin), `…`, curly quotes, `≤`/`≥`/`≠`, `×`, `−` (U+2212), no-break space, plus the judgment-only `•` and check/ballot marks. Fenced code blocks and inline spans that quote a glyph by itself are exempt; a span carrying a glyph among other text (a signature) is content. **Auto-fixable for the mechanical set**: the gate's auto-fix stage runs the probe's `--fix` mode, which rewrites the substitutable glyphs across each changed `.md` file (fix on encounter) and re-stages; the judgment-only glyphs fail the probe with a one-line suggestion. The em dash is deliberately excluded ([em-dash-style] owns it; its rewrite is judgment). Per-file opt-out via a `typist-code-points-exempt` marker in the first 5 lines. | PR #124 `r3548802060` (kriskowal 2026-07-11: "Avoid code points that are difficult for a typist to maintain. This is a standing instruction that should be in style guidance and observed by automation in the jury selection process and automatically fixed."). Rule: [typist-friendly-code-points](../typist-friendly-code-points/SKILL.md). |
| `spell-out-identifiers`       | No **added** line of a changed source file (`.js`/`.mjs`/`.cjs`/`.jsx`/`.ts`/`.tsx`) authors an identifier whose camelCase/PascalCase/snake segment is on the curated abbreviation blocklist (`dir`, `cmd`, `temp`, `tmp`, `arg`, `subdir`, `cfg`, `ctx`, `idx`, `msg`, `btn`, `impl`, `mgr`, `num`, `str`, `val`, `resp`, `req`, `addr`). Strings and comments are stripped first; matching is on **whole segments**, so `directory`/`interval`/`mkdtempSync`/`tmpdir` never match. **Non-auto-fixable** (a rename touches every call site): fails with one line per distinct (file, identifier, abbreviation). Per-file escape hatch: a `spell-out-exempt` marker in the first five lines. | `endojs/endo-but-for-bots#650` (`dir`→`directory`, `makeTempRoot`→`makeTemporaryRoot`) + `#609` review `4a711718` (`makeIntervalSchedulerCmd`→`makeIntervalScheduler`, "Avoid abbreviations… It isn't making a command") + the #684 recurrence (`Addr`→`Address`). Cluster `review-misses/clusters/avoid-name-abbreviations.md`. |
| `prefer-endo-primitives`      | No **added** JavaScript/TypeScript line introduces a recognized hand-rolled primitive when the same file does not import its audited Endo package: Node/WebCrypto SHA-256 (`@endo/sha256`), direct `TextEncoder`/`TextDecoder` construction (`@endo/bytes`), `atob`/`btoa` or Buffer base64 conversion (`@endo/base64`), a byte-to-hex `toString(16).padStart(2, ...)` loop (`@endo/hex`), `Uint8Array.from(... charCodeAt(...))` ASCII conversion (`@endo/ascii`), or an `insist*` declaration (`@endo/errors`). **Non-auto-fixable:** import and use the named package. Per-file escape hatch: `prefer-endo-primitives-exempt` in the first five lines. | Consolidated 2026-08-04 review retrospective, cluster `prefer-endo-primitives`: six misses across PRs 671, 755, 824, 836, 877, and 882. |

Rules without an executable script in that directory are checklist or panel rules, not pre-push probes. In particular, ASCII banners, package-code PR citations, test-package entry points, `SECURITY.md` uniformity, filename stutter, sentence-per-line markdown, and general source ASCII discipline are not currently enforced by this driver. Do not describe them as mechanically gated until a probe lands.

Each probe is small (typically 5 to 30 lines of shell or awk). A new probe is one new script in `probes/`; the driver picks it up by glob.

One probe doubles as an auto-fixer: `typist-friendly-code-points.sh --fix` runs with the auto-fix stages (before the probe pass), rewrites the mechanically substitutable glyphs in the changed markdown files, and re-stages what it touched, matching the format/lint stages' silent-fix contract. Its probe mode then reports only what `--fix` could not settle (the judgment-only glyphs).

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
    no-inline-import-jsdoc pass
    prefer-endo-primitives pass
    spell-out-identifiers  fail: packages/example/src/main.js adds abbreviated identifier `pendingIdx`
    typedefs-belong-in-dts pass
    typist-friendly-code-points pass
yarn typecheck  pass

result: 1 failing stage(s); address and re-run.
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

- _2026-05-20_: initial bootstrap documented seven planned probes; those early probe scripts did not survive the v2 migration.
- _2026-06-04_: documented the planned `no-non-ascii-in-source` probe per the maintainer's inline review on `endojs/endo-but-for-bots#417` (comment `r3353301111`). Its executable did not survive the v2 migration, so source ASCII remains a checklist/panel rule until a new probe lands.
- _2026-06-18_: panel observation on `endojs/endo-but-for-bots#468`: an `// eslint-disable-next-line guard-for-in` comment preceded a `for...of` loop, where `guard-for-in` does not apply. An eslint-disable comment that names a rule that never fires on the annotated line is a no-op but actively misleads future maintainers (and silently fails to suppress the real rule). Pushes that write a disable comment verify the rule name against the actual ESLint output before committing; the panel's type/meta-comment seat is the natural finder. No deterministic probe landed because the check requires running ESLint with each disabled rule individually, which is heavy; the discipline is the gate.
- _2026-06-24_: migrated the documented call sites from v1 to the gardening state machine. The driver itself was accidentally omitted from the migration and was restored on 2026-08-10.
- _2026-07-05_: added `typedefs-belong-in-dts` probe (`scripts/jobs/gardening/pre-push-gates/probes/typedefs-belong-in-dts.sh`) — the tier-1 deterministic gate the maintainer twice asked for. It fails when a changed `**/src/**/*.js` file is a **types-only module**: a character scanner strips `//` and `/* */` (incl. JSDoc) comments while skipping string literals, and the file fires only when it declares `@typedef`/`@callback` yet has no runtime code left beyond the empty `export {}` marker. Provenance and why it exists: `endojs/endo-but-for-bots#58` review `4612637233` ("Typedefs in .d.ts, please. Adjust the garden to avoid this in the future with builder directives and a reviewer.", 2026-07-02) delivered only the two weakest tiers (a builder directive + the always-on typist seat), and the same convention was violated again two days later on `#442` (`packages/platform/src/fs/types.js`, review `4629047816`) whose gauntlet never ran — so no reviewer but the maintainer remained. The gate cannot be skipped or forgotten. It is **narrow on purpose** (§ Pitfalls): an implementation `.js` with any runtime code never matches, so a module-private single-use inline `@typedef` is left alone; the whole-file `types.js` shape is the only thing it catches. Verified fires on the `#442` pre-fix `types.js` and abstains on the `#58` `trace-aggregator.js` (an impl file whose inline typedef is the typist seat's catch, not the gate's). Cluster: `review-misses/clusters/typedef-location-dts.md`.
- _2026-07-11_: added `spell-out-identifiers` probe (`scripts/jobs/gardening/pre-push-gates/probes/spell-out-identifiers.sh`) — the tier-1 deterministic gate for the `avoid-name-abbreviations` review-miss cluster (category `naming`), tripped at count=3 across two panelled PRs. It fails when an **added** line of a changed source file authors an identifier one of whose case/underscore/digit-boundary segments is on a curated abbreviation blocklist (`dir`, `cmd`, `temp`, `tmp`, `arg`, `subdir`, `cfg`, `ctx`, `idx`, `msg`, `btn`, `impl`, `mgr`, `num`, `str`, `val`, `resp`, `req`). A char scanner strips string literals and comments first (so `/tmp/x` path strings and "temp file" prose do not fire), then each identifier is split into segments and matched **whole** — `directory`, `interval`, `makeTemporaryRoot`, and the Node platform names `mkdtempSync`/`os.tmpdir()` never match because the abbreviation is not a standalone segment there. **Narrow on purpose** (§ Pitfalls) yet biased toward firing; the per-file `spell-out-exempt` marker (first five lines) is the escape hatch for a legitimate domain abbreviation. Provenance: the maintainer standing-rejects abbreviations and had to repeat the ask on `endojs/endo-but-for-bots#650` (`dir`→`directory`, `makeTempRoot`→`makeTemporaryRoot`, `packages/daemon/test/mount-revocation.test.js`) and `#609` (`makeIntervalSchedulerCmd`→`makeIntervalScheduler`, `packages/daemon/src/host.js`, "It isn't making a command"); the `stylist`/`ergonomist` seats read for crisp names but neither encoded a mechanical never-abbreviate check. Paired with a builder/fixer directive. Verified: fires on the real `#650` and `#609` historical lines and abstains on the spelled-out fixes, on platform/domain names (`mkdtempSync`, `tmpdir`, `WeakMap`, `URL`, `interval`), and on abbreviations appearing only in strings/comments. Cluster: `review-misses/clusters/avoid-name-abbreviations.md`.
- _2026-07-16_: implemented the formerly phantom `no-inline-import-jsdoc` gate as `scripts/jobs/gardening/pre-push-gates/probes/no-inline-import-jsdoc.sh`. It reads added lines in changed JavaScript and TypeScript source files against complete post-change JSDoc blocks, catches `import('...')` and `import("...")` in every JSDoc type tag or bare JSDoc type, and reports the `file:line`, tag, and specifier. It ignores source strings and ordinary comments, is non-auto-fixable because the repair changes the top-of-file `@import` block, and honors `inline-import-exempt` in the first five lines. Re-litigation: it fires on `packages/reminder/src/store.js`'s historical `@param {import('./types.js').ReminderStoreDirectory}` at `endojs/endo-but-for-bots@bee451e`, while a top-of-file `@import { ReminderStoreDirectory } from './types.js'` with bare annotations passes. The typist seat and its panel-hints probe are the review-time backstop. Cluster: `review-misses/clusters/inline-import-jsdoc.md`.
- _2026-08-10_: restored `scripts/jobs/gardening/pre-push-gates.sh`, wired it into `garden-pr.sh` before `local-verify.sh`, and reconciled the shipped-probe inventory to the five executable probes that actually exist. The seven planned v1 probes that never landed are explicitly checklist/panel rules until they acquire scripts.
- _2026-08-05_: mechanized the consolidated retrospective's two recurring findings. `prefer-endo-primitives` now fails on the narrow hand-roll signatures observed across six misses, names the corresponding `@endo/{sha256,bytes,base64,hex,ascii,errors}` package, and abstains when the file already imports that provider; the purist panel hint carries a broader matching catalog, including Rust base64, so ambiguous cross-language cases receive review instead of a hard failure. `spell-out-identifiers` now includes `addr` -> `address`, closing the PR 684 recurrence; its existing `idx` entry covers PR 806's `pendingIdx`. Regression coverage: `scripts/jobs/test/review-convention-probes-test.sh`.
- _2026-07-11_: added `typist-friendly-code-points` probe (`scripts/jobs/gardening/pre-push-gates/probes/typist-friendly-code-points.sh`), the gate tier of the standing instruction from kriskowal's review on `endojs/endo-but-for-bots#124` (`r3548802060`): "Avoid code points that are difficult for a typist to maintain." First probe with a paired `--fix` mode: the auto-fix stage rewrites the mechanical set (arrows, ellipsis, curly quotes, comparison signs, multiplication/minus signs, no-break space) across each changed `.md` file and re-stages; probe mode then fails only on the judgment-only glyphs (`•`, check/ballot marks) plus anything `--fix` did not run on. Skips fenced blocks and glyph-quoting inline spans; treats a glyph inside a longer span (a signature like `stmt.get(...) -> object`) as content. Verified: fires on the precipitating `designs/daemon-endor-pet-store-sqlite.md` (`slot-machine` branch, U+2192 arrows in both prose and signature spans) and `--fix` clears all five arrows while leaving the em dash to [em-dash-style]; abstains on glyph-quoting spans, fences, vendored `references/`, and `typist-code-points-exempt`-marked files. Rule text and seat wiring: [typist-friendly-code-points](../typist-friendly-code-points/SKILL.md) (typist + copyeditor seats, pedant layered rules).
- _2026-06-25_: widened `no-ascii-banners` to also catch banner horizontal-rule comments (a comment line whose body is four or more repeated `-=*~_` characters, e.g. `// ---------`). Provenance: PR `endojs/endo-but-for-bots#503` review `4573212313`, where the maintainer flagged a `// ----` banner in a test comment and asked the garden to anticipate the feedback going forward. The reconstructed passable-byte-arrays PR carried roughly forty such rules across six files; the old box-only definition missed them. The rule now has a single citeable home at [no-comment-banners](../no-comment-banners/SKILL.md), which the `archivist` (code panel) and `pedant` (design panel) seats reference as the review backstop. When the executable probe is implemented, broaden its match accordingly: a comment-only line (`//`, `#`, ` * `, or `/* … */`) whose stripped body is `^[-=*~_]{4,}$`.
