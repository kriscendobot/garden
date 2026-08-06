---
kind: result
role: gardener
host: endolin-garden-ece02cb4
at: 2026-08-06T06:22:13Z
---
kind: result
role: jurors/stylist
repo: endojs/endo-but-for-bots
pr: 909
project: endo-but-for-bots

## stylist

**Verdict:** comment-only

Diff base `origin/llm...HEAD` (2 commits) in worktree
`/home/kris/garden/scratch/project-wt-endojs-endo-but-for-bots-pr909-5e6ae075-7ae0a131`.
Line numbers are HEAD's; the worktree carries an uncommitted edit to
`packages/cli/src/cli-archive.js:70` that I did not review.

### Findings

1. **should-fix** `_powers` at `packages/cli/demo/typescript-runlet.ts:1`.
   The sibling demo it is modeled on, `packages/cli/demo/runlet.js:1`, names the
   same unused first parameter plainly: `main = async (powers, ...args)`. The new
   file diverges to `_powers` for no reason the changeset gives, and `AGENTS.md`
   § Lint-rule gotchas standing-rejects exactly that move ("do not rename an
   intentionally unused identifier solely to silence `no-unused-vars`... rather
   than adding a leading underscore"). It is also unnecessary: `args` follows and
   is used, so the default `after-used` behavior never reports `powers`. Rename to
   `powers`. [rule: AGENTS.md § Lint-rule gotchas]

2. **should-fix** The three module-level defaults at
   `packages/cli/src/cli-archive.js:70-72` carry the exact identifiers of the
   option keys they are merged into, so `:102-113` reads
   `workspaceLanguageForExtension: { ...workspaceLanguageForExtension, ...options.workspaceLanguageForExtension }`
   where the outer name and the inner name denote different things (the merge
   versus one input to it). Prefix them `default`, matching the convention this
   very file imports two lines up (`defaultParserForLanguage as
   sourceParserForLanguage`, `:9`). Parity with
   `packages/bundle-source/src/endo.js:252-254` does not carry: there the same
   names hold the final values, not defaults. [rule: roles/jurors/stylist/AGENT.md
   § Operating norms, name that lies about what the value is]

3. **should-fix** `makeCliArchive` (`packages/cli/src/cli-archive.js:84`, file
   `cli-archive.js`) reads as "an archive of the CLI". The docstring at `:78`
   says "the **source** archive", all four test titles say "CLI **source**
   archive", and "source" is the load-bearing contrast with compartment-mapper's
   transforming `makeArchive` (which the replaced code disambiguated as
   `makeCompartmentArchive`). `makeCliSourceArchive` in `cli-source-archive.js`
   says what it is. Name-versus-docstring disagreement.
   [rule: roles/jurors/stylist/AGENT.md § Operating norms, secondary surface]

4. **comment-only** Verb drift for one concept.
   `packages/cli/test/typescript-archive.test.js:15,52` say "erase"; the code and
   the changeset say strip throughout (`makeTypeScriptParser`, `mode:
   'strip-only'`, `Cannot strip types from ...` at `:47`, ".ts, .mts, and .cts
   files are type-stripped"). Pick one verb, "strip".
   [rule: roles/jurors/stylist/AGENT.md § Operating norms, consistent patterns
   carry into new code]

5. **comment-only** `packages/cli/test/typescript-archive.test.js:67`, "CLI
   source archives **locate** unsupported TypeScript syntax". The test is a
   `t.throwsAsync`; the behavior is rejection, and the assertions check the error
   names the file and the construct. Suggest "CLI source archives reject
   unsupported TypeScript syntax and name the offending file".
   [rule: roles/jurors/stylist/AGENT.md § Operating norms, name that lies about
   what the value does]

### Clean

No abbreviated fresh identifiers (`mts`/`cts`/`cjs`/`mjs`/`commonjs` are platform
spellings; `args` is forced, `arguments` being unbindable in module code). No
redundant-word concatenations. No gratuitous renames: the deletions in
`commands/{archive,make,run}.js` are the extraction this PR claims, and
`typescript-runlet.ts` / `typescript-confined-script.js` / the
`typescript-archive*` fixtures all follow the existing demo and fixture naming.

Self-improvement: nothing this time.
