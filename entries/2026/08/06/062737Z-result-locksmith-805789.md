---
kind: result
role: locksmith
host: endolin-garden-ece02cb4
at: 2026-08-06T06:27:39Z
---
project: endo-but-for-bots
repo: endojs/endo-but-for-bots
pr: 909
seat: locksmith
base: origin/llm
worktree: scratch/project-wt-endojs-endo-but-for-bots-pr909-5e6ae075-7ae0a131

### Locksmith (capability flow and attenuation)

**Verdict:** request-changes

**Findings:**

- **`packages/cli/src/cli-archive.js:77-99`** — the attenuator grants more than its
  docstring claims. The doc says options "augment the CLI defaults", but
  `options.parserForLanguage` *replaces* the pinned source parsers per language.
  Before this PR, `commands/archive.js` set `parserForLanguage: sourceParserForLanguage`
  **last** in the spread, so a caller could not substitute a parser at all; now the
  caller wins for `mjs`, `cjs`, `json`, `text`, and `bytes` as well as the new
  `mts`/`cts`. A parser implementation sees and rewrites every module's source bytes
  before they land in the archive, so this is the most authority-bearing member of
  `ArchiveOptions`. The delegation feature the test at
  `test/typescript-archive.test.js:25` exercises only needs `mjs`/`cjs`/`mts`/`cts`;
  narrow the accepted override set to those, or say in the docstring that a caller is
  trusted to replace archive parsers wholesale. The only in-tree caller today passes
  `{ commonDependencies }` (`src/endo.js:694`), so this is a widened surface, not a
  live hole. [rule: roles/jurors/locksmith/AGENT.md, attenuator must narrow the
  surface it claims to]

- **`packages/cli/src/cli-archive.js:85`** — ambient filesystem authority, not
  parameterized. `makeCliArchive` builds `makeReadPowers({ fs, url, crypto, path })`
  from module-scope imports, so no caller can pass attenuated powers and the archive
  path's read authority is no longer visible at the call sites
  (`commands/archive.js:37`, `commands/make.js:60`, `commands/run.js:143`), where it
  used to be. Every peer takes powers as a parameter: `makeArchive(readPowers, ...)`,
  and `makeBundlingKit(io, options)` in `packages/bundle-source/src/endo.js:23`.
  Prefer `makeCliArchive(readPowers, moduleLocation, options)`. `@endo/cli` is
  `private` with `"exports": {}`, so this grants nothing outside the package.
  [rule: AGENTS.md, Modules and exports: unconfined guest modules export
  `make(powers)`]

- **`packages/cli/src/cli-archive.js:33-64`** — the factory-returned parser object is
  not hardened, while the three extension maps at :67-69 and the export at :116 are.
  The default this replaces is frozen (`compartment-mapper/src/import-parsers.js:16`),
  and the merged `parserForLanguage` at :86-96 is a fresh mutable object handed across
  into `@endo/compartment-mapper` (`archive-lite.js:201` shallow-freezes a copy, so the
  parser records themselves stay mutable). Use `return harden({ ... })`.
  [rule: AGENTS.md, harden() is mandatory: objects returned from factory functions
  should be hardened]

**Notes (out of scope but worth flagging):**

- Verified positive, and the reason this is not a boundary finding: I built the fixture
  archive and read its `compartment-map.json`. `.ts` and `.mts` modules are recorded as
  `"parser": "mjs"` with position-preserving stripped source, and the recorded `sha512`
  is over the stripped bytes in the zip. So type-stripping stays entirely on the CLI
  host side and the daemon's archive importer gains no TypeScript capability and no
  `amaro` dependency. `workspace*LanguageForExtension` folds only into the
  not-under-`node_modules` maps (`compartment-mapper/src/node-modules.js:381` and
  :1124-1141), so the changeset's "dependencies under `node_modules` must still be
  built" claim holds.
- `commands/run.js:139` lazy-imports `../cli-archive.js` while `make.js` and
  `archive.js` import it statically. `src/endo.js` already lazy-loads the command
  modules, and the read powers are constructed per call, so the deferral buys nothing;
  match the siblings or say what it is for.
  [proposed-rule: within one package, sibling call sites should not switch between
  static and dynamic import of the same module without a comment stating what the
  deferral buys]

Self-improvement: `roles/jurors/locksmith/AGENT.md` should name a third recurring
finding, "an options-merge that changes which side wins": a refactor that hoists a
pinned option into a spread silently converts a non-overridable default into a
caller-controlled one, and the diff reads as pure extraction. Checking spread order
against the pre-refactor order is a cheap, mechanical locksmith pass, and it is what
found the first finding above.
