---
role: shepherd
tier: mentor
fallback-tier: minion
requires: host=endolin-garden-ece02cb4
dispatch: automatic
---
# Post the panel round 2 verdict review on endojs/endo-but-for-bots PR #546

Gauntlet `endojs-endo-but-for-bots-pr546-gauntlet-20261007`, panel round 2 ran on
host oros-studio-garden-ce242c49 against head `678ecb680a21baee46e2938172da017b036b6528`
(base `master-5be15cb`), disposition **must-fix** (durable record
`panel-runs/endojs-endo-but-for-bots-546/a8e2293fc64a.md`). That host's bot PAT
returns 403 on `addPullRequestReview` for endojs, so this job is pinned to endolin.

Task: if the PR head is still `678ecb680…` and no "## Panel round 2" review exists
yet, post the review body below verbatim as a REQUEST_CHANGES review on
https://github.com/endojs/endo-but-for-bots/pull/546 (fall back to `--comment` if
request-changes is refused). Write the body below the BEGIN marker to a file and
use `gh pr review … --request-changes --body-file <file>`. Do nothing else — no
fixing, no un-drafting. If the head has moved, post nothing and report that.

----- BEGIN REVIEW BODY -----
## Panel round 2: must-fix

Single-round panel on head `678ecb680` against `master-5be15cb`. 8 of 33 seats requested changes: archivist, migrator, saboteur, purist, spec-keeper, changeset-auditor, pruner, coverage-auditor. The PR-body concision probe fired (545 words, > 300; 7 file paths), so the pruner also reviewed the description. Request-changes seats are listed first; the full seat output follows (truncated to fit GitHub's limit).

<details>
<summary><b>archivist</b> — request-changes</summary>

**Verdict: request-changes.** Two doc claims contradict the code or each other, and both need fixing before merge. The rest of the prose I checked holds up.

**Findings**

1. **must-fix: `@endo/daemon` does not register the amaro hook for itself.** `AGENTS.md:18` says `@endo/cli` and `@endo/daemon` run `.ts` "by the `amaro/strip` hook they register", and `docs/typescript.md` (Development-time bullet) says they "register the `amaro/strip` hook for themselves and the processes they fork". Only `packages/cli/bin/endo.cjs:11` imports `amaro/strip`. `packages/daemon/index.js:95` and `packages/daemon/src/daemon-node-powers.js:500` pass `makeAmaroExecArgv()` as `execArgv` to children, so the daemon gets the hook only when the endo CLI launched it. Fix: "`@endo/cli` registers the `amaro/strip` hook, and `@endo/daemon` forwards it to the processes it forks through `execArgv`." Apply the same correction in both files. [rule: docs prose claims checked against code; contradiction is must-fix in .md]

2. **must-fix: cross-package `.ts` imports are contradicted within `docs/typescript.md`.** The "Import specifiers" section allows `.ts` specifiers "only for relative imports within the same package, or another workspace package in this repo". The next paragraph says "Cross-package imports must go through the package's normal `.js` entrypoint." `AGENTS.md:22` has the same first-sentence allowance. The lint rule `packages/eslint-plugin/lib/rules/no-nonrelative-ts-import.js` only rejects non-relative specifiers, so it permits `../other-pkg/src/x.ts`. Pick one rule and state it in both docs. If the intent is "relative within the same package only", then the rule's docstring also needs narrowing. [rule: doc's own other statements]

**Checked and accurate**
- The changeset claim that `MatchHelper` and `PatternKit` "now live in `patternMatchers.ts`" and were "never exported from either package" holds. Both are defined there as non-exported `type`s, and `git grep` finds no export of them at HEAD.
- `packages/patterns/index.js` re-exporting from `./src/patterns/patternMatchers.ts` and `no-shim.js` importing `./E.ts` match `AGENTS.md:23`.
- The `engines.node >=22` declarations in `packages/cli/package.json` and `packages/daemon/package.json` match the changeset. The `endo.cjs` version guard throws into the existing `.catch`, which sets `exitCode = 1`, so "exits with an error" holds.
- The Node 22.18 / 23.6 type-stripping defaults and `yarn pack:all` / `release:npm` entries in `package.json` match the docs.
- The `types-index` section that `AGENTS.md:25` points to ("summarized below") exists.
- The `amaro-exec-argv.js` JSDoc matches its implementation.

**Not verified:** the ts-node-pack rewrite and validation steps in `docs/typescript.md` § Packing, since I did not run the tool. I also did not check the `E.js`→`E.ts` JSDoc survival in full.

Self-improvement: when a `.md` describes which process registers a loader, grep for the registration call itself, not just the forwarding call.
<sub><!--garden-provenance-section-->model <code>claude-opus-5-5</code> · harness <code>claude</code> · provider <code>anthropic</code></sub>
</details>

<details>
<summary><b>migrator</b> — request-changes</summary>

**Verdict: request-changes**

**Findings**

1. **must-fix: the changeset bump levels and the `engines` story don't match the impact.**
   - `.changeset/build-ts-support.md` marks `@endo/eventual-send` and `@endo/patterns` as `patch`, and says published tarballs are JS-only. That holds for the registry install path.
   - It does not hold for the workspace path or for a git install. `packages/eventual-send/package.json` still routes `.` → `src/no-shim.js`, which now imports `./E.ts`. `packages/patterns/index.js` re-exports from `./patternMatchers.ts`. Node 22.0–22.17 has no default type stripping, so those two packages fail to load there when linked from a checkout.
   - Neither package declares `engines.node`, and the root `package.json` still says `>=16`. The changeset itself concedes that git and workspace installs are unsupported. Consumers who did this before are now broken, so the public contract moved, which is not patch-level.
   - Fix: either declare `engines` on both packages and the root, or soften the claim in the changeset. Reconsider `minor`, or an explicit callout, for the git and workspace install path.
   - [rule: skills/changeset-discipline/SKILL.md]

2. **must-fix: `@endo/cli` and `@endo/daemon` get `engines.node >=22` as a `minor`, but this is a breaking change.**
   - Node 18 and 20 users get a hard failure: `endo.cjs` throws on `<22`, and `engines` now excludes them. This is a dropped-runtime-support change.
   - The root `engines` is still `>=16`, and `.github/workflows/ocapn-guile-interop.yml` has to move from Node 20 to 22.
   - Under the pre-1.0 semver convention, `minor` can carry a break. The changeset should say so explicitly in a `BREAKING:` line, or use `major` if these packages are past 0.x.
   - Check whether the daemon's `engines` conflicts with consumers such as the Agoric `endo` pins and the other packages that depend on `@endo/daemon`.
   - [rule: skills/changeset-discipline/SKILL.md]

3. **should-fix: deep-import and bundler consumers of `.ts` sources have no changeset coverage.**
   - `exports` on `@endo/patterns` is closed to `.` and `./package.json`, so deep imports are already blocked there.
   - `@endo/eventual-send` has `./shim.js` and others, but `src/E.js` is not exported. I found no in-repo consumers of the removed `E.js` or `patternMatchers.js` paths; only `captp/trap.js` has a comment.
   - Endo's own bundler (compartment-mapper) has no `.ts` language handling. `@endo/patterns` and `@endo/eventual-send` are reachable from bundled caplets and workers when sourced from the workspace.
   - The old AGENTS.md rule, "No `.ts` in runtime bundles", is deleted by this PR. Please state in the PR or changeset which bundle paths (`bundle-source`, daemon worker bundles) are exercised against `.ts` when linked from the workspace, and whether any tests cover it.
   - [rule: skills/pr-dependency-graph/SKILL.md]

4. **should-fix: `@endo/benchmark` and the `no-nonrelative-ts-import` rule.**
   - `packages/benchmark` adds `amaro` to `devDependencies` and a rollup plugin, but has no changeset. That's fine if it's private. The `@endo/eslint-plugin` `minor` is correct, since a new rule in the `internal` config is additive.
   - Confirm that `internal` is not consumed externally. If it is, a new error-level rule is a behavior change for those consumers.

5. **comment-only: `makeAmaroExecArgv` and the `execArgv` forwarding.**
   - It forwards the parent's own `execArgv` plus the amaro hook.
   - Callers that previously passed their own `execArgv` are unaffected only if nothing else in `daemon-node-powers.js` overrides it. I did not verify the worker fork sites.

Self-improvement: add a migrator checklist line, "engines additions go with a bump-level rationale, and a workspace-only runtime dependency needs the root engines floor checked".
<sub><!--garden-provenance-section-->model <code>claude-opus-5-5</code> · harness <code>claude</code> · provider <code>anthropic</code></sub>
</details>

<details>
<summary><b>saboteur</b> — request-changes</summary>

**Verdict:** request-changes

**Findings**

1. **Must-fix. Real concern: Endo bundling of workspace code that imports `@endo/eventual-send` (or `@endo/patterns`) now fails.** `packages/eventual-send/src/no-shim.js:1` now imports `./E.ts`, and `packages/patterns/index.js:69` re-exports from `./src/patterns/patternMatchers.ts`. The compartment-mapper's `defaultLanguageForExtension` (`packages/compartment-mapper/src/node-modules.js:346`) has no `ts` entry, and `bundle-source/src/endo.js:245-252` registers only `mts` and `cts`. I reproduced this by running `makeArchive` from `packages/far` on a two-line entry that imports `{ E } from '@endo/eventual-send'`. It fails with `Cannot parse module ./src/E.ts … no parser configured for the language ts`. That affects every archive or bundle built in this repo whose dependency graph reaches `E` or `M`, including daemon caplets, `bundleSource` fixtures and downstream workspace links. The old AGENTS.md rule this PR deletes ("Never use `.ts` files in modules that are transitively imported into an Endo bundle") still describes a real constraint. Either teach the compartment-mapper and bundle-source a `ts` strip-only language, or keep runtime modules that bundles reach as `.js`. Add a regression test that archives an entry importing `@endo/eventual-send`. [rule: roles/jurors/saboteur/AGENT.md § Review variant, adversarial inputs that falsify the happy path] [proposed-rule: when a PR renames a runtime module to `.ts`, archive at least one workspace entry that reaches it through `@endo/compartment-mapper` before landing]

2. **Should-fix. Real concern: the `any` handling in the E types changed without notice.** In `packages/eventual-send/src/E.ts`, `PickCallable`, `RemoteFunctions`, `ECallableOrMethods` and `ESendOnlyCallableOrMethods` no longer check for `any` first (`0 extends (1 & T) ? any`). For `E(x as any)`, the `T extends Callable` conditional now resolves to the union of both branches rather than `any`. Downstream code that relied on `E(anyValue).foo()` being `any` gets different inference after what the changeset calls a pure "patch" refactor. Restore the `any` checks, or name the change in the changeset. The breaker and typist own this axis, so I'm passing it on. [rule: roles/jurors/saboteur/AGENT.md § Secondary surface]

3. **Mitigated. `no-nonrelative-ts-import` misses some specifier shapes.** `packages/eslint-plugin/lib/rules/no-nonrelative-ts-import.js:38` checks only `Literal` nodes, so a template-literal `import(\`pkg/a.ts\`)` passes. The rule also has no visitor for `import x = require('pkg/a.ts')`, `type T = import('pkg/a.ts').T`, or JSDoc `@import … from '@endo/x/src/y.ts'`. I read these gaps from the AST handling; I couldn't run them because `@typescript-eslint/parser` isn't installed in this worktree. Node's resolver still fails loudly at runtime, so this is defensive coverage. It's cheap to add `TemplateLiteral` with no expressions, `TSImportEqualsDeclaration` and `TSImportType`. [proposed-rule: a lint rule that keys on import specifiers covers every node type that carries a specifier, not only `Literal`]

4. **Mitigated. `makeAmaroExecArgv` (`packages/daemon/src/amaro-exec-argv.js:17`) handles a duplicate hook in the parent's arguments.** It recognizes `--import amaro/strip` and `--import=<url>` in the parent's `execArgv`. If the hook comes in through `NODE_OPTIONS`, the child registers it twice. That's idempotent in practice, so it's out of scope.

5. **Mitigated. The Node version check in `packages/cli/bin/endo.cjs:5`.** `Number('22')` handles pre-release strings like `22.0.0-nightly` correctly.

Attack count: 5 (1 must-fix, 1 should-fix, 3 mitigated).
<sub><!--garden-provenance-section-->model <code>claude-opus-5-5</code> · harness <code>claude</code> · provider <code>anthropic</code></sub>
</details>

<details>
<summary><b>purist</b> — request-changes</summary>

**Verdict:** request-changes

**Findings**

1. **should-fix**: `packages/eventual-send/src/E.ts:118-128, 148-158` (`ECallableOrMethods`, `ESendOnlyCallableOrMethods`, `PickCallable`, `RemoteFunctions`). The JSDoc-to-TS port reverts the `0 extends (1 & T) ? any` guard that base commit `c88bc8311` added to all four helpers. `PickCallable` and `RemoteFunctions` lost the guard completely. In the two `*OrMethods` types it was moved under `T extends Callable`, where it now returns `never` instead of `any`. Because `any` distributes over a conditional, `E(x as any)` once again shows the wide `ECallable<any> & EMethods<Required<any>>` type that `c88bc8311` was written to remove. The sibling helpers `EAwaitedResult` and `ECallableReturn` kept their guards, so the family no longer behaves the same way. Fix: restore the guard as the outermost conditional in all four, and add a `test-d` case for `E(any)`. [rule: roles/jurors/purist/AGENT.md § Family-consistency across related symbols]

2. **should-fix**: `packages/patterns/src/patterns/patternMatchers.ts:2115-2128` (`M.split`, `M.partial`). Commit `26756d246`, titled "syntax-only", changes how the base is classified: `passStyleOf(harden(base)) === 'copyArray'` became `Array.isArray(base)`. `makeTagged` still hardens later and `assertPattern` still validates, so passability holds. But the code now decides on an array test, not the pass-style, and it no longer hardens up front. An array that is not passable (holes, extra properties) now fails later in `splitArray`, and a proxy over an array takes the array branch. Restore the pass-style check, or move the change into its own commit and explain it. [proposed-rule: a refactor that only changes syntax must not change runtime classification or harden calls; behavior changes go in separately described commits]

3. **should-fix**: `packages/eventual-send/src/E.ts` `makeEMethod` / `makeESendOnlyMethod`. Pulling these helpers out dropped the comment that explained the invariant: the method is defined with concise method syntax so it can check `this`, and it avoids `function` syntax so it cannot be constructed. That comment is the only thing protecting those choices from a later "simplify to arrow" refactor. Restore it. [rule: roles/jurors/purist/AGENT.md § Side-channel closure / invariant-claim integrity]

4. **comment-only**: `E.ts` `toBreakpointProperty`. A Proxy `get` trap only receives `string | symbol` keys, so the `number` branch can never run. Typing `propertyKey: string | symbol` in the two helpers removes the need for this function. [rule: roles/jurors/purist/AGENT.md § Minimum viable abstraction]

5. **comment-only**: `E.ts` `makeProxy`. This helper exists only to hide an `as T` cast. Writing `new Proxy(...) as T` at each call site keeps the unchecked cast visible to readers. [rule: roles/jurors/purist/AGENT.md § Minimum viable abstraction]

6. **comment-only**: `packages/eslint-plugin/lib/rules/no-nonrelative-ts-import.js:37`. The rule checks only `Literal` sources. A template-literal `import(`pkg/x.ts`)` or a `require('pkg/x.ts')` gets through. Either cover those cases or say in the docs that they are out of scope. [rule: roles/jurors/purist/AGENT.md § Edge-case enumeration on values]

Checked with no issue: the `harden` and `hideAndHardenFunction` coverage in `patternMatchers.ts` matches the base, apart from finding 2. `MatchHelper` and `PatternKit` becoming module-private is safe because `exports` exposes only `.`. The `amaro-exec-argv.js` lookup by URL does not make any new value reachable across the boundary.

Self-improvement: when a `.js` file is ported to `.ts`, diff it against the latest base version of the `.js` file, not the upstream PR's starting version. Base commits that land after the port started, like the `any` guards here, get silently dropped.
<sub><!--garden-provenance-section-->model <code>claude-opus-5-5</code> · harness <code>claude</code> · provider <code>anthropic</code></sub>
</details>

<details>
<summary><b>spec-keeper</b> — request-changes</summary>

**Verdict: request-changes**

**Findings**

1. **must-fix**: `packages/patterns/src/patterns/patternMatchers.ts:2116` and `:2123`. `M.split` and `M.partial` used to test `passStyleOf(harden(base)) === 'copyArray'`. They now test `Array.isArray(base)`. That changes runtime behavior inside commit `26756d246` ("refactor: .ts syntax"), which claims to be syntax-only. The two tests are not equivalent:
   - [IsArray (§7.2.2)](https://tc39.es/ecma262/#sec-isarray) returns true for an array with extra own properties, an array with holes, and a Proxy whose target is an array. `passStyleOf` rejects all three as `copyArray` and sends them to the `splitRecord` path or throws.
   - The old code also hardened and validated `base` before branching. The new code does neither.

   Either restore the original test or move this change to its own commit with a changeset and a test. [rule: roles/jurors/spec-keeper/AGENT.md § Primary surface, *Spec citation*; a refactor that claims to only erase types must keep runtime behavior the same]

2. **should-fix**: `patternMatchers.ts:2224`. `assertRawGuard` changed from an arrow function to a `function` declaration, and nothing hardens it.
   - Per [§10.2.4 MakeConstructor](https://tc39.es/ecma262/#sec-makeconstructor), a function declaration is constructible and carries its own mutable `prototype` object. An arrow function has neither.
   - The sibling `assert*Guard` functions pass through `hideAndHardenFunction`, which freezes them. `assertRawGuard` is exported as-is.

   Keep it as a `const` arrow with an `asserts` return type annotation (TypeScript accepts that), or harden it. `assertPattern` (line 473) is only safe because the kit's `harden({...})` reaches it. [proposed-rule: when converting JS to TS, do not turn `const` arrows into `function` declarations just to use `asserts`; an annotated `const` is enough and doesn't add a constructor and `prototype`]

3. **should-fix**: `packages/eventual-send/src/E.ts` `toBreakpointProperty`. The `typeof propertyKey === 'number'` branch can never run. A Proxy `get` trap always receives a property key that is a String or a Symbol, because [ToPropertyKey (§7.1.19)](https://tc39.es/ecma262/#sec-topropertykey) runs before [[[Get]] (§10.5.8)](https://tc39.es/ecma262/#sec-proxy-object-internal-methods-and-internal-slots-get-p-receiver) is invoked. Type `propertyKey` as `string | symbol` and remove the helper rather than adding a runtime branch only to satisfy the type checker. [rule: roles/jurors/spec-keeper/AGENT.md § *Less coupling*]

4. **comment-only**: `patternMatchers.ts:1858` adds `.filter(name => typeof name === 'string')` to `ownKeys` (the result of [OrdinaryOwnPropertyKeys, §10.1.11.1](https://tc39.es/ecma262/#sec-ordinaryownpropertykeys)). A CopyRecord has no symbol keys, so the filter changes nothing. It is still a runtime addition in a type-only commit; a cast would do the same job.

5. **comment-only**: `packages/cli/bin/endo.cjs`. The check only rejects Node.js majors below 22, while the docs give 22.18 as the version where type stripping is on by default. Since the CLI loads `amaro/strip` itself, the major-version check looks correct. Please confirm that amaro `^1.1.9` doesn't need a newer minor release of 22.

6. **comment-only**: `packages/eslint-plugin/lib/rules/no-nonrelative-ts-import.js`. `isRelative` doesn't match `.` or `..` on their own, or `file:` URLs. That's fine for real use, but the rule could note it.

Self-improvement: when a JS-to-TS conversion says it is syntax-only, strip the types from the new file and diff it against the old file with whitespace removed. That surfaced findings 1, 2 and 4, which reading the textual diff would have missed.
<sub><!--garden-provenance-section-->model <code>claude-opus-5-5</code> · harness <code>claude</code> · provider <code>anthropic</code></sub>
</details>

<details>
<summary><b>changeset-auditor</b> — request-changes</summary>

**Verdict:** request-changes

Findings:

1. **Raising `engines.node` to `>=22` is breaking but bumped `minor`.** [rule: skills/changeset-discipline/SKILL.md § Bump level]
   - `.changeset/cli-ts-runtime.md` bumps `@endo/cli` and `@endo/daemon` as `minor`.
   - The diff adds `engines.node >=22` to both packages. Its own body says `endo` "exits with an error on older versions of Node.js".
   - That drops support for Node 20 and below, which is a breaking change for consumers. It should be `major`, or the floor should be justified in the body as already enforced.
   - Disposition: must-fix-loop, because the wrong semver bump would publish.

2. **`@endo/eventual-send` and `@endo/patterns` are `patch`, but the install story changed.** [rule: skills/changeset-discipline/SKILL.md § Bump level]
   - The body says installs from a git checkout or workspace link are now "not supported". The sources moved from `.js` to `.ts`, and the internal specifiers changed to `.ts`.
   - That is a consumer-visible break for those install modes. The `patch` level understates it.
   - Either raise the bump to `minor` or `major`, or state in the body why this is behavior-preserving for supported consumers.
   - Disposition: summary-fix, escalating if the maintainer agrees it is breaking.

3. **Package-set coherence looks right.** [rule: skills/changeset-discipline/SKILL.md § Bundling]
   - The published packages the diff touches are `@endo/eventual-send`, `@endo/patterns`, `@endo/cli`, `@endo/daemon` and `@endo/eslint-plugin`, and all appear in the front-matter.
   - `@endo/captp` has a comment-only change, which needs no entry.
   - `@endo/benchmark` is `private: true`, so it needs none.
   - Splitting into three changesets is justified by their independent semver implications.

4. **Body style is not sentence-per-line.** [rule: skills/changeset-discipline/SKILL.md § Sentence-per-line]
   - `build-ts-support.md` and `cli-ts-runtime.md` wrap multiple sentences onto shared lines. For example, "The package entrypoints and exports are unchanged. When the packages are packed…" runs on one line.
   - `eslint-ts-import-rule.md` has the same wrapping.
   - Put each sentence on its own line.
   - Disposition: summary-fix.

5. **Body-vs-diff identifiers are coherent.** `E.ts`, `patternMatchers.ts`, the removed `src/patterns/types.ts`, the `amaro/strip` dependency and `@endo/no-nonrelative-ts-import` all match the diff. There is no process commentary.

No new-package initial release is in the diff, so that rule does not apply.
<sub><!--garden-provenance-section-->model <code>claude-opus-5-5</code> · harness <code>claude</code> · provider <code>anthropic</code></sub>
</details>

<details>
<summary><b>pruner</b> — request-changes</summary>

**Verdict: request-changes.** The PR body and `docs/typescript.md` carry the most padding. The new lint-rule JSDoc and a few rule-test comments also restate what the code and docs already say. The `amaro-exec-argv.js` and `endo.cjs` comments record non-obvious constraints and can stay.

**Findings**

1. **PR body (545 words, over the ~300 threshold).** Disposition: `summary-fix`. Cut the following:
   - The "files most worth reviewing" sentence in Description. The diff shows the files.
   - Scaling Considerations. Its startup-cost point repeats the amaro dependency already named under Security. Fold it into one sentence or drop it.
   - Documentation Considerations. It paraphrases `docs/typescript.md` and `AGENTS.md`. Replace it with a link.
   - Upgrade Considerations. The Node 22 floor is already in Compatibility. Keep only the "Publishing `.ts` source is deferred" sentence, which is new information.
   - Each template heading stays. A section that repeats another becomes one sentence.
   - [rule: skills/pr-formation] and [rule: roles/pruner/AGENT.md § PR body and thread replies]

2. **`docs/typescript.md`, Packing section.** Disposition: `summary-fix`. Steps 1–7 narrate ts-node-pack internals (staging, derived tsconfig, package.json rewriting, validation). That is implementation narrative for a third-party tool. Replace the list with two sentences: what `yarn pack:all` produces, and a link to ts-node-pack.
   - [rule: roles/COMMON.md § Documentation: no implementation narrative] (cite the nearest standing rule; the pruner brief does not name one for this case, so treat as [proposed-rule: README and design prose should describe use, not walk through a dependency's internals])

3. **`docs/typescript.md`, emitDeclarationOnly and Migration path.** Disposition: `summary-fix`. The numbered rationale (items 2 and 3, with the TS5055 example) is history for a constraint that `AGENTS.md` already states. The Migration path steps are transitional and will age out. Cut both to the one-line constraint.

4. **Same normative rule stated four times.** `docs/typescript.md`, `AGENTS.md`, the rule's JSDoc, and two changesets all restate "relative `.ts` imports only" and "entrypoints stay `.js`." Disposition: `summary-fix`. Keep one canonical statement (`docs/typescript.md`) and link from the others.
   - [proposed-rule: a normative rule appears in one canonical document; other surfaces link to it rather than restating it]

5. **`AGENTS.md`, signpost sentence.** "Where each kind of type definition belongs is summarized below." Delete it. The heading below does the job.

6. **`packages/eslint-plugin/lib/rules/no-nonrelative-ts-import.js:1-10`.** The 10-line JSDoc restates the changeset and docs. Cut it to the first sentence plus the Node.js resolution reason. Drop "reach other packages through their published entrypoint. See `docs/typescript.md`."

7. **Same file, lines 50–56.** The comments `// import ... from '...'; and import type ...` and the rest of that list enumerate the selectors the adjacent code already matches. Delete them.

8. **Same file, rule tests (added comments around lines 291–298 in the diff).** `// Relative .ts imports are the supported pattern.` and `// Non-relative imports without a .ts extension are fine.` restate the assertions beneath them. Delete both. Keep `// A .ts substring that is not the extension must not trip the rule`, which records a real invariant.

9. **`AGENTS.md`, "Two rules keep this compatible..."** Acceptable, but it duplicates item 4. Fold it into the link once that is in place.

**Keep (no finding):** `packages/cli/bin/endo.cjs:4` (Node 22 floor), `packages/daemon/src/amaro-exec-argv.js:4-5` (resolution from the package, not the child's cwd), and the `amaro-exec-argv.js` JSDoc. Moved JSDoc in `E.ts` and the `captp/src/trap.js` provenance line show as additions only because of the `E.js` → `E.ts` rename. I did not assess them as new padding.
<sub><!--garden-provenance-section-->model <code>claude-opus-5-5</code> · harness <code>claude</code> · provider <code>anthropic</code></sub>
</details>

<details>
<summary><b>coverage-auditor</b> — request-changes</summary>

**Per-juror block: coverage-auditor, PR #546** (`feat: support .ts runtime modules via erasable type syntax`, base `master-5be15cb`)

**Verdict: request-changes**

**Caveat on evidence.** No c8 report was present (`coverage/coverage-final.json` missing), so new-line coverage is unverified, not assumed covered. This verdict rests on reading the diff. Re-run c8 with `--all` before trusting a clean pass.

**Findings**

1. **`packages/daemon/src/amaro-exec-argv.js`, `makeAmaroExecArgv`: the "hook already present" branch is untested, and so is the split-argument form.** The `hasAmaro` predicate has three reachable outcomes: `--import=<specifier>` already present, `--import` followed by the bare or URL specifier, and neither present (append). No test in the PR references this module (grep of `packages/` finds only its three call sites). The function reads `process.execArgv` directly, so a test cannot inject inputs.
   - Recommend a unit test that sets `process.execArgv` (or, better, refactors the helper to take `execArgv` as a parameter) and asserts three cases: (a) `['--import=amaro/strip']` returns the array unchanged, (b) `['--import', amaroStripUrl]` returns it unchanged, (c) `[]` returns `['--import', amaroStripUrl]`.
   - The refactor is the lower-risk route: the helper becomes pure and the test needs no global mutation.
   - [rule: skills/coverage-driven-testing/SKILL.md]: reachable from an exported entry point, unexercised. **request-changes** (must-fix-loop).

2. **`packages/cli/bin/endo.cjs`, the `nodeMajor < 22` throw: accepted with rationale.** The guard fires only on a Node runtime older than 22, which the test environment cannot select. It is an environment-specific branch. [rule: skills/coverage-driven-testing/SKILL.md]. No demand.

3. **Moved `.js` → `.ts` lines (`eventual-send/src/E.ts`, `patterns/src/patterns/patternMatchers.ts`): accepted, pending the c8 re-run.** These are renames with content carried over; existing suites exercise them. Coverage of these lines is a question for the report, not a new test gap. Confirm against the c8 run.

4. **Platform-conditional arms: no requirement.** The `C-platform-arm` probe fired because `packages/captp` is touched and its `test:xs` is `exit 0`. The captp change is a comment-only edit to `src/trap.js:1`. I found no new `exports`/`imports` condition (`browser`, `xs`, `endor`, `node`, `default`), no `*-browser*`/`*-xs*`/`*-endor*` source file, and no edit to any `test:xs`/`test:endor` script in this diff. The pre-existing captp `test:xs` stub is not this change's arm to cover. [rule: skills/coverage-driven-testing/SKILL.md § Platform-conditional arms]

5. **[proposed-rule]: run c8 with `--all` for the panel.** The pre-pass cannot see wholly-untested new files without it. This PR adds `packages/daemon/src/amaro-exec-argv.js`, and the gate's missing report is the reason this review cannot confirm its coverage. Proposed rule: the coverage pre-pass runs c8 with `--all` so untested new files surface.

Self-improvement: the gate's missing-report path should say explicitly which files it could not measure, so the next seat does not have to infer that from the verdict.
<sub><!--garden-provenance-section-->model <code>claude-opus-5-5</code> · harness <code>claude</code> · provider <code>anthropic</code></sub>
</details>

<details>
<summary><b>assessor</b> — comment-only</summary>

**Verdict:** comment-only

Nothing I found breaks logic or control flow. The conversion of `patternMatchers.js` and `E.js` to `.ts` looks mechanical, and I ran no tests. Two checks and one minor item remain.

**Findings**

1. **should-fix: verify that the `.ts` sources load under every runtime path.** [proposed-rule: when a package switches its published entry to `.ts`, add a smoke test for each consumer launch path: the CLI, the daemon `fork`, the worker `fork`, rollup/XS and any other bundler.]
   - The `.ts` sources load only if `amaro/strip` is registered in each process that imports `@endo/patterns` or `@endo/eventual-send`.
   - The PR covers the `endo` CLI (`bin/endo.cjs`), the daemon `fork` (`packages/daemon/index.js:95`), the worker `fork` (`daemon-node-powers.js:500`) and the benchmark rollup.
   - Any other `node` entry point that imports these packages outside the monorepo test harness is not covered. Examples are `packages/*/bin` scripts, the `packages/cli/src/commands/*` spawns, and `ses`-based scripts.
   - I did not enumerate those entry points. The author should confirm none exist, or that each one has the hook.

2. **comment-only: `packages/daemon/src/amaro-exec-argv.js:5` resolves `amaro/strip` at module load.**
   - `import.meta.resolve` throws if `amaro` is missing, and it throws at import time rather than inside `makeAmaroExecArgv`. That is acceptable because `amaro` is now a declared dependency.
   - The `hasAmaro` check at lines 18-22 does the right thing in the `--import=x` and `--import x` forms. It would not recognize a differently-resolved path to the same file, which only causes a harmless double-registration.

3. **comment-only: `packages/cli/bin/endo.cjs` version guard.**
   - It runs before `import('amaro/strip')`, so a Node 20 user gets the clear error and not a loader failure. That control flow is correct.
   - The guard covers only the `endo` binary. Other consumers on Node 20 would hit an opaque `.ts` error. The `engines` field was added only to `cli` and `daemon`, not to `patterns` or `eventual-send`, which now need Node 22 at runtime.

4. **should-fix: confirm the removal of `eslint-disable no-continue` in `patternMatchers.ts` is intentional.**
   - A grep for `continue;` in that file returned no matches, so the removal is consistent with the file as it stands.
   - The `/* eslint-disable no-use-before-define */` addition and the inline `MatchHelper` and `PatternKit` types match the deleted `./types.ts` and look correct.

**Rule: ESLint `no-nonrelative-ts-import`.**
- The rule checks `ImportDeclaration`, `ExportNamedDeclaration`, `ExportAllDeclaration` and `ImportExpression`. Its tests cover the valid and invalid forms, including the `.ts-utils` edge case.
- `ExportNamedDeclaration` without a source is handled by the `!sourceNode` guard.
- It does not cover `require('x.ts')` or `import.meta.resolve`. This is low risk.

**CI.** The `ocapn-guile-interop` workflow moves from Node 20 to Node 22, which matches the new floor. The other workflow edits only expand version comments on pinned SHAs and change nothing behaviorally.

Self-improvement: no assessor brief change proposed.
<sub><!--garden-provenance-section-->model <code>claude-opus-5-5</code> · harness <code>claude</code> · provider <code>anthropic</code></sub>
</details>

<details>
<summary><b>typist</b> — comment-only</summary>

**Verdict:** comment-only

**Findings**

1. **should-fix**: `docs/typescript.md:44` has a typist-hostile `…` (U+2026) in prose: `` `import … from '@endo/foo/src/bar.ts'` ``. It sits in a code span, but it abbreviates the statement and isn't quoting the glyph, so the exemption doesn't apply. Spell it with ASCII, e.g. `import { x } from '@endo/foo/src/bar.ts'`. [rule: skills/typist-friendly-code-points/SKILL.md]

2. **should-fix**: `packages/eslint-plugin/lib/rules/no-nonrelative-ts-import.js:19` has `/** @type {import('eslint').Rule.RuleModule} */`, an inline `import()` in a JSDoc `@type` tag. The fix is a top-of-file `/** @import { Rule } from 'eslint' */` with `@type {Rule.RuleModule}`. The rule says to mark this must-fix. I've left it at should-fix because the same shape already appears in sibling rules (`no-multi-name-local-export.js:11`, `no-harden-pattern-maker.js:87`), so it follows local convention. [rule: roles/jurors/typist/AGENT.md, inline `import()` in JSDoc]

3. **comment-only**: `packages/patterns/src/patterns/patternMatchers.ts` and `packages/eventual-send/src/E.ts` use many `any` annotations. This looks like a faithful port of the JSDoc `*` and `any` types, and I found no `@ts-` suppressions. The `rawM as unknown as MatcherNamespace` cast (`patternMatchers.ts`, around diff line 2156) and the `maker as unknown as MethodGuardMaker` cast (around diff line 2315) are escape hatches that assert a shape rather than check it. Both are inherited from the old JSDoc casts. Worth confirming that `tsc --build` still passes without them hiding drift.

4. **comment-only**: The helper types from the removed `src/patterns/types.ts` now live inline in `patternMatchers.ts`. The changeset says they were never exported, so the multi-field-typedef-in-impl-file rule's escape hatch applies only if each is single-use. Types such as `MatcherNamespace`, `MatchHelper` and `AwaitArgGuard` look reused across the file. If any are exported or shared, consider moving them to a `.d.ts` types module and importing them.

5. **comment-only**: `EReturn`, `ECallableReturn` and the other helper types use `(...args: any[]) => any` generic constraints. These are standard for the conditional-type helpers, with no bare `Function` found. No type-versus-runtime drift found in the JSDoc-to-TS conversion of `E` signatures.

Self-improvement: no new rule proposed. Findings 1 and 2 are existing rules.
<sub><!--garden-provenance-section-->model <code>claude-opus-5-5</code> · harness <code>claude</code> · provider <code>anthropic</code></sub>
</details>

<details>
<summary><b>stylist</b> — comment-only</summary>

**Verdict:** comment-only

Naming holds up. I found nothing that blocks the PR. I read the diff for identifiers and did not read every line of the large `patternMatchers.ts` and `E.ts` conversions.

**Findings**

1. **Comment-only: the `.ts` renames are motivated.** `E.js`→`E.ts` and `patternMatchers.js`→`patternMatchers.ts` are the PR's stated claim, and the changeset (`.changeset/build-ts-support.md`) says so. The package entrypoints and exports are unchanged, so these are not gratuitous renames. [rule: roles/jurors/stylist/AGENT.md § Operating norms, gratuitous renames]

2. **Comment-only: no fresh abbreviations or redundant-word names.** The new identifiers are:
   - `makeAmaroExecArgv`, `amaroStripUrl`, `amaroSpecifiers`, `hasAmaro` (`packages/daemon/src/amaro-exec-argv.js`)
   - `stripTypesPlugin`
   - `TS_EXTENSION`, `isRelative`, `check`, `sourceNode`
   - `nodeMajor`, `Container`, `MatchHelper`, `PatternKit`

   All are spelled out. `execArgv` is Node's own name for `process.execArgv`, so it stays. The `ERef`, `EResult`, `ECallable` and `EPromiseKit` types and `FilteredKeys` and `DataOnly` were moved from the old `E.js`/`types.ts`. They are carried over, not freshly authored. [rule: roles/jurors/stylist/AGENT.md § Abbreviated identifiers]

3. **Comment-only: the helper types moved.** The helper types from the deleted `src/patterns/types.ts` (`Container`, `MatchHelper`, `PatternKit`) now sit in `patternMatchers.ts` with their names unchanged. The changeset says they were never exported, so the move breaks no contract.

4. **Comment-only: `check` in `no-nonrelative-ts-import.js`.** It is terse, but it is local to the rule and the sibling ESLint rules use the same shape. The name `no-nonrelative-ts-import` is a mild double negative, "no non-relative". It is clear enough, and `no-relative-…` would mean the opposite, so I would not change it.

5. **Comment-only: `stripTypesPlugin` and its plugin name `amaro-strip-types`.** The variable is generic where the string names the tool. This is acceptable in a benchmark-only rollup config.

Self-improvement: no new rule is needed. Renames that just change the file extension for a TypeScript migration belong in the stylist checklist as "motivated by the PR claim" cases.
<sub><!--garden-provenance-section-->model <code>claude-opus-5-5</code> · harness <code>claude</code> · provider <code>anthropic</code></sub>
</details>

<details>
<summary><b>packager</b> — comment-only</summary>

**Verdict:** comment-only

**Findings**

1. **Should-fix: CI pin-comment churn is unrelated to the PR.** [rule: roles/jurors/packager/AGENT.md § Primary surface (diff carries only what the PR claims)]
   - Commit `678ecb680` ("ci: name exact tags in setup-node and paths-filter pin comments") rewrites `# v6` to `# v6.4.0` across `.github/workflows/{browser-test,ci,depcheck,release,update-action-pins*}.yml`.
   - None of that relates to `.ts` support. It is isolated in its own commit, so it is not conflated.
   - It should still be dropped from this PR and landed separately. If it stays, the PR description should say so.
   - `089a93a46` (guile-interop Node 22 bump) is justified by the amaro floor and is fine.

2. **Should-fix: weak commit history around the changesets.** [rule: roles/jurors/packager/AGENT.md § Be specific]
   - `2f2c0a3bf` ("docs: changes") adds `build-ts-support.md`, `cli-ts-runtime.md` and `ts-eslint-jsdoc.md`. The subject names none of them.
   - `4f7875c99` later rewrites them and deletes `ts-eslint-jsdoc.md`.
   - The net state is correct, with three changesets. A squash or fixup of `4f7875c99` into `2f2c0a3bf` with an accurate subject would tidy this. It does not block.

3. **Should-fix: the `@endo/cli` and `@endo/daemon` changeset bump level and private flag.** [rule: skills/changeset-discipline/SKILL.md]
   - `cli-ts-runtime.md` marks both as `minor`. The same changeset adds an `engines.node >=22` floor and a new runtime dependency, which drops Node 20/21 users and is a breaking-ish change.
   - Both packages are `"private": true` (cli 2.3.13, daemon 3.0.0), so no tarball reaches npm consumers. The bump therefore only drives the changelog.
   - The changeset should state that the packages are private. It should also say that `minor` was chosen deliberately despite the engines floor.

4. **Comment-only: changeset coverage looks complete.**
   - `build-ts-support.md` covers `@endo/eventual-send` and `@endo/patterns` (patch). It also mentions the removal of `types.ts` and the unsupported git-checkout install.
   - `@endo/captp` has only a comment change, so no changeset is needed.
   - `@endo/benchmark` is private, and the `amaro` devDependency needs no changeset.
   - The `@endo/eslint-plugin` minor for the new rule is accurate.

5. **Comment-only: `yarn.lock` is not in its own commit.** [rule: skills/yarn-lock-separate-commit/SKILL.md]
   - The `yarn.lock` hunks (three `amaro` entries) ride along in `eb7b31251` ("feat: import .ts by syntax erasure") and `55c2aa536` ("build(benchmark): strip .ts types in rollup via amaro").
   - The churn is tiny, but the policy prefers a separate `chore: Update yarn.lock` commit. A retcon would split it out.

6. **Comment-only: `exports` and publish surface.**
   - No `exports["."]` changes point at `src/`. The `patterns/types-index.js` re-exports now reference `./src/patterns/patternMatchers.ts`, which is a typing-only internal entry and is not exposed via `exports`.
   - `patterns/tsconfig.build.json` newly excludes `src/exports.*`. The reason is not explained in the changeset. Confirm the exclusion is intentional.

Self-improvement: I should add a packager check that flags a vague "docs: changes" subject on a commit that adds changesets.
<sub><!--garden-provenance-section-->model <code>claude-opus-5-5</code> · harness <code>claude</code> · provider <code>anthropic</code></sub>
</details>

<details>
<summary><b>prover</b> — comment-only</summary>

**Verdict:** comment-only

The only new test is the ESLint rule test. The rest of the runtime change has no new test, but the existing suites should break if it regresses, and the one real gap is small.

**Findings**

1. **should-fix: `makeAmaroExecArgv` has no unit test.** The function is in `packages/daemon/src/amaro-exec-argv.js:15-25`. It has real branching: it detects an existing `--import amaro/strip` in the parent's flags in four forms (`--import=<spec>`, and `--import` followed by `<spec>`, for both the bare specifier and the resolved URL). It then appends the flag only when none is found. If someone broke the dedup (always append, or never detect), the result would be a duplicate `--import` or a missing one. Nothing in `packages/daemon/test` mentions amaro (grep found nothing), so only a daemon integration run could catch it. I did not run the daemon suite. A small test that stubs `process.execArgv` would pin all four forms and the append case. [rule: skills/regression-evidence/SKILL.md]

2. **comment-only: the ESLint rule test is load-bearing.** `packages/eslint-plugin/test/no-nonrelative-ts-import.test.js` covers `import`, `import type`, `export … from`, `export *` and dynamic `import()` as invalid cases. It also has valid controls for relative `.ts`, extensionless bare specifiers, and `foo.ts-utils`. Removing the rule or any of its four visitors would redden at least one invalid case. Two small gaps, neither blocking:
   - The `.cts` extension is covered only via `export … from`.
   - There is no case for a template-literal `import()`, which the rule intentionally skips.

3. **comment-only: no regression evidence for the main migration.** `E.js` → `E.ts` and `patternMatchers.js` → `patternMatchers.ts` have no new tests. The existing `patterns` and `eventual-send` suites now import the `.ts` files (several test imports were repointed), so they do exercise the stripped code. Because those suites run under type stripping, they would fail if the migration broke at load time. That is acceptable evidence, but the diff itself shows no run of the suites. `packages/benchmark/rollup.config.js` gets a new amaro transform plugin with no test. It is only exercised by the benchmark bundle build.

4. **comment-only: the `endo.cjs` Node-version guard is untested.** The guard rejects Node <22. It is a trivial branch, but an untested one.

Self-improvement: a stripped-syntax migration with no behavior change should be judged on whether the existing suites run against the new `.ts` files. New helper functions with branching still need their own unit test.
<sub><!--garden-provenance-section-->model <code>claude-opus-5-5</code> · harness <code>claude</code> · provider <code>anthropic</code></sub>
</details>

<details>
<summary><b>curator</b> — comment-only</summary>

**Verdict: comment-only**

The public surface is preserved. `eventual-send` `exports` (`.`, `./shim.js`, `./utils.js`) and `patterns` `exports` (`.`) are untouched. The `index.js` and `types-index.js` re-exports keep the same names. Deleting `src/patterns/types.ts` removes no public identifier, as the changeset says. The new rule `@endo/no-nonrelative-ts-import` is exported through the plugin's `internal` config.

**Findings**

1. **should-fix, `.changeset/build-ts-support.md` and `packages/eventual-send/src/types.d.ts:9`.**
   - The published `types.d.ts` says `export type * from './E.ts'`.
   - The changeset says ts-node-pack erases types and rewrites relative `.ts` specifiers in the tarball. A `types.d.ts` re-export may not be covered by that rewrite.
   - If `E.ts` is shipped as `E.js` and no `E.ts` remains, the published `types.d.ts` points at a missing file. Consumers would lose `ERef`, `ECallable` and the other `E` types.
   - Please verify the packed tarball with `yarn pack:all` and a consumer `tsc`. Either confirm the `.d.ts` rewrite or keep a resolvable target.
   - [proposed-rule: when a package's types entry re-exports a source file renamed `.js` to `.ts`, the packed artifact's consumer type resolution must be verified.]

2. **should-fix, `.changeset/build-ts-support.md:2-3`, bump level.**
   - A `patch` bump is defensible for the declared surface.
   - The changeset itself says git-checkout and workspace-link installs are no longer supported. That is a consumption-mode change on two core packages, and I'd argue it goes beyond a patch.
   - Raise it with the migrator and judge. If the maintainers accept this as an unsupported mode, `patch` stands, but the changeset should say so explicitly. [rule: skills/changeset-discipline/SKILL.md]

3. **comment-only, `.changeset/cli-ts-runtime.md`.**
   - The `minor` bump with new `engines.node >=22` on `@endo/cli` and `@endo/daemon` is a consumer-visible constraint: older Node versions are rejected.
   - Dropping a Node range is normally `major`. Confirm that 20 is already unsupported in this repo, or reclassify. [rule: skills/changeset-discipline/SKILL.md]

4. **comment-only, `packages/daemon/index.js` and `packages/daemon/src/amaro-exec-argv.js`.**
   - These add a new file and a two-line change to `index.js`.
   - If `amaro-exec-argv.js` is re-exported from `index.js`, it widens the daemon's public surface without a mention in the changeset. If it is internal, no action is needed.

I found no sibling-surface duplication and no cross-package duplicate option types.

Self-improvement: add a curator check that `types.d.ts` re-exports of `.ts`-authored sources survive the pack step.
<sub><!--garden-provenance-section-->model <code>claude-opus-5-5</code> · harness <code>claude</code> · provider <code>anthropic</code></sub>
</details>

<details>
<summary><b>locksmith</b> — approve</summary>

**Verdict:** approve

I found no capability-flow regressions. This PR changes the build and module format: it converts `E.js` to `.ts` and `patternMatchers.js` to `.ts`, adds an `amaro/strip` loader hook, and adds an ESLint rule. It adds no new exports, parameters, or call paths that hand a caller authority it did not have before. Checked edges:

- **`packages/eventual-send/src/E.ts` `makeEMethod` / `makeESendOnlyMethod` (moved out of the proxy `get` traps).** The trap closures now live in named helpers but cover exactly what they did before. Each generated method still closes over only `recipient`, `propertyKey`, `receiver` and `HandledPromise`. It still checks `this !== receiver` before sending, and it is still `harden`ed. The handlers still use `baseFreezableProxyHandler`, so no new proxy trap leaks a property descriptor. `toBreakpointProperty` only changes how the key is passed to `onSend.shouldBreakpoint`, which is debug-only. A `get` trap never receives a number key, so this has no effect.
- **`packages/patterns/src/patterns/patternMatchers.ts` exports and the `M` namespace.** The export set is unchanged. `M` is still the hardened `rawM` (`:2024`, `:2150`), and the cast is type-only. The guard assertions changed from `const` arrows to `function` declarations with `asserts` signatures. They keep their names and runtime bodies.
- **comment-only: `patternMatchers.ts:2116` / `:2123` (`M.split` / `M.partial`).** These replace `passStyleOf(harden(base)) === 'copyArray'` with `Array.isArray(base)`. This is a runtime change inside a commit described as a syntax refactor. It does not widen what a guard accepts. `makeMatcher` → `makeTagged` (`packages/pass-style/src/makeTagged.js:22`) still runs `harden(payload)`, which hardens `base`, and then `assertPassable`. `assertPattern` follows that. A non-passable or proxied array is still rejected, only later and with a different error message. The commit message should mention the change, or the original check should be kept.
- **comment-only: `packages/daemon/src/amaro-exec-argv.js`, `packages/daemon/index.js:95`, `packages/daemon/src/daemon-node-powers.js:500`.** The daemon and its workers now load a third-party `--import` hook before `lockdown`. That hook has full ambient authority in the most privileged process. The hook path is resolved from the package itself, not the child's working directory, which keeps a planted `node_modules/amaro` in the working directory from being picked up. That fixes a real ambient-resolution hazard. Guest code still loads through Compartments, not Node's loader, so guests gain no authority. Passing `execArgv: [...process.execArgv, …]` matches `fork`'s default, so no new flags reach the children. The remaining cost is a bigger trusted computing base for the daemon, and `docs/typescript.md` could say so.
- **`packages/cli/bin/endo.cjs`.** The Node version floor check and the `amaro/strip` import run before `main`, and nothing new is handed to `main`.
- **ESLint rule and CI changes.** These involve no capabilities.

Rules applied: [rule: roles/jurors/locksmith/AGENT.md § Operating norms, primary surface; runtime-flag attenuation; `Far` vs `makeExo`]. None of the three recurring findings applies.

Self-improvement: no brief change needed. A future refinement could have the locksmith flag pre-lockdown loader hooks added to the daemon's trusted computing base as a recurring secondary item [proposed-rule: a new `--import`/`--loader` hook in a daemon or worker `execArgv` is a TCB grant; require it to be resolved from the package itself and documented].
<sub><!--garden-provenance-section-->model <code>claude-opus-5-5</code> · harness <code>claude</code> · provider <code>anthropic</code></sub>
</details>

<details>
<summary><b>warden</b> — approve</summary>

**Verdict: approve**, with one comment-only finding.

I found no must-fix or should-fix harden-discipline problems in this diff. It doesn't touch `globalThis` or prototypes and doesn't add any new boundary objects.

**Findings**

1. **comment-only: `M.split` / `M.partial` no longer call `harden(base)` before checking its type.** `packages/patterns/src/patterns/patternMatchers.ts:2115-2128` used to test `passStyleOf(harden(base)) === 'copyArray'`. It now tests `Array.isArray(base)`. This change sits inside the commit titled "refactor: .ts syntax for patternMatchers" (26756d246), so it is a behavior change hidden in a refactor.
   - **Freezing still happens:** `makeMatcher` → `makeTagged` deep-hardens the payload, so `base` is still hardened before anything leaves the function.
   - **Bad input is still rejected:** an array that isn't a valid CopyArray (holes, extra properties, a proxy) now goes to `splitArray` and fails in `assertPattern`, where before it threw in `passStyleOf`. Only the error message changes.
   - **What to do:** say so in the commit message, or restore `passStyleOf(harden(base))` so the refactor stays behavior-neutral. A test that sends a malformed array through `M.split` would lock in the rejection.

   [proposed-rule: a commit labelled "refactor" or "syntax-only" in a hardened-JS package must not change `harden` / `passStyleOf` call sites; any such change gets its own commit or a sentence in the message]

2. **No finding: `E.ts` keeps the boundary guarantees.**
   - `packages/eventual-send/src/E.ts:217-287`: `makeEMethod` / `makeESendOnlyMethod` still return `harden(methods[propertyKey]!)`. They still check the receiver with `this !== receiver`, and still use concise-method syntax, so the method can't be called with `new`.
   - All three handler factories are still `harden({...baseFreezableProxyHandler, ...})`.
   - `funcTarget` / `objTarget` are still only `freeze`d, so the proxy keeps trapping, and they stay private to the module.
   - `makeE` still returns `harden(assign(...))`.
   - The new `toBreakpointProperty` only converts number keys to strings, which a `get` trap never receives, so it does nothing in practice.

3. **No finding: SES bundle loading still works.** I bundled a module that imports `@endo/eventual-send` (so it pulls in `E.ts`) with in-tree `bundle-source`, then loaded it with `importBundle` under `@endo/init` lockdown. It loaded and `E` came back as a function. Whether the published tarballs are free of `.ts` is for the packager seat to confirm.

4. **No finding: `packages/daemon/src/amaro-exec-argv.js`** only reads `process.execArgv` and returns a fresh array to local `fork` calls; nothing crosses a hardened boundary. `packages/cli/bin/endo.cjs` imports `amaro/strip` before `src/endo.js`. It is a Node host entry point, not code that runs inside SES.

Self-improvement: when a file is converted from `.js` to `.ts`, comparing a count of `harden(` calls before and after is a cheap way to catch call sites lost in the rewrite. That is how finding 1 surfaced. It is worth adding to the warden brief.
<sub><!--garden-provenance-section-->model <code>claude-opus-5-5</code> · harness <code>claude</code> · provider <code>anthropic</code></sub>
</details>

<details>
<summary><b>breaker</b> — comment-only</summary>

**Verdict:** comment-only

**Findings**

1. **`patternMatchers.ts`: `M.split`/`M.partial` now dispatch on `Array.isArray(base)`, not `passStyleOf(harden(base)) === 'copyArray'`** (`packages/patterns/src/patterns/patternMatchers.ts:2116`, `:2123`). The changeset claims these entrypoints are unchanged, and that claim is mostly true. I stripped the types from both files and diffed them. The routing is the same for every passable input. A non-passable array (one holding a function, or carrying an extra own property) is still rejected, but later, by `makeMatcher`→`assertPattern`, so the error message changes. The caller's `base` also gets hardened later than before. This change appeared in a commit labeled a pure syntax refactor. Verdict: mitigated, comment-only. Either revert to the original predicate or name the change in the commit message. [proposed-rule: a `.js`→`.ts` syntax migration must strip back to the same runtime code as the original, or list each deviation in its commit message]

2. **Exported `assert*Guard` helpers changed from `const` arrow functions to `function` declarations** (`patternMatchers.ts:2200`, `:2224`, `:2265`, `:2326`). Each export now has a mutable `.prototype` object and can be called with `new`, e.g. `new assertRawGuard(x)`. Nothing hardens these exports, so a compartment sharing the module instance gets one more mutable object to tamper with. Verdict: should-fix. Typed `const` declarations (`export const assertRawGuard: (s: any) => asserts s is RawGuard = s => …`) satisfy TypeScript's assertion-function rule and keep the arrow shape. [rule: roles/jurors/breaker/AGENT.md]

3. **`E.ts`: `toBreakpointProperty` converts a numeric key to a string** (`E.ts`, `makeEMethod`/`makeESendOnlyMethod`). A Proxy `get` trap only ever receives a string or symbol key, so this branch is dead code. Otherwise the stripped `E.ts` matches `E.js`. Verdict: mitigated, comment-only.

4. **`no-nonrelative-ts-import` misses some import forms** (`packages/eslint-plugin/lib/rules/no-nonrelative-ts-import.js:38`). It only checks string-literal sources. These all get past it:
   - ``import(`pkg/a.ts`)`` (template literal)
   - `import x = require('pkg/a.ts')` (TypeScript import-equals)
   - `require('pkg/a.ts')` in `.cjs` files

   Separately, it flags `import type … from 'pkg/x.d.ts'`, which is erased at runtime, so that is a false positive. Verdict: should-fix for the template-literal and import-equals cases. [rule: roles/jurors/breaker/AGENT.md]

5. **The docs say relative `.ts` imports into another workspace package are allowed** (the rule's docstring, and `AGENTS.md` "Runtime `.ts` imports must be relative — same package, or another workspace package"). A path like `../../eventual-send/src/E.ts` leaves the package. ts-node-pack rewrites the extension, but that target file is not in the tarball, so the stated rule (`.ts` imports never break consumers) fails for anything published. Verdict: should-fix in the docs: allow relative `.ts` imports within the same package only. [proposed-rule: a relative specifier must not leave its package root]

6. **`makeAmaroExecArgv` only spots an existing hook if it is spelled `amaro/strip` or matches this package's resolved URL** (`packages/daemon/src/amaro-exec-argv.js:7`). A parent that loaded a different copy of amaro by `--import <path>` gets the hook registered twice. The two stripping hooks just chain, so nothing breaks. Verdict: mitigated, comment-only.

7. **Publishing still produces `.js`-only tarballs.** `release-npm.mjs`→`scripts/pack-all.mjs` always packs through ts-node-pack, and nothing in the repo still imports the renamed `patternMatchers.js`, `E.js` or `patterns/types.ts`. Verdict: mitigated, no action.

Self-improvement: checking a type-syntax migration is quicker by stripping both versions (`node:module` `stripTypeScriptTypes`), removing comments, running prettier and diffing. That surfaced findings 1–3 straight away. It is worth adding to `skills/saboteur-adversarial-review` as the "erasure-equivalence" check.
<sub><!--garden-provenance-section-->model <code>claude-opus-5-5</code> · harness <code>claude</code> · provider <code>anthropic</code></sub>
</details>

<details>
<summary><b>wire-watcher</b> — approve</summary>

**Verdict:** approve

This PR changes how the code is built and loaded, and converts two files' syntax. It adds no wire format, identifier, hash or integrity check. I stripped the types from `patternMatchers.ts` with `module.stripTypeScriptTypes` and compared it token by token with the old `patternMatchers.js`. I read the `E.js` → `E.ts` conversion side by side. Most of the differences are cast parentheses and variables moving to a new scope. Four differences change runtime code, and none of them weakens a check.

**Findings**

1. **comment-only.** `M.split` and `M.partial` now pick the array or record form with a different test (`packages/patterns/src/patterns/patternMatchers.ts:2116` and `:2123`). The old code ran `passStyleOf(harden(base)) === 'copyArray'`; the new code runs `Array.isArray(base)`. Patterns still accept and reject the same inputs. Any array that passes `passStyleOf` is a `copyArray`, and `makeMatcher` (`:1947`) still runs `makeTagged` and `assertPattern` on the payload. So a base that cannot be passed is still rejected. What changes is where it fails and the error it gives: an array with extra properties or holes now fails inside `assertPattern` on the `splitArray` path, where before `passStyleOf` threw. This is the security-critical guard code, so I'd add one test that `M.split` rejects an array with an extra property, as the paranoid extra. [proposed-rule: a refactor that only changes syntax but swaps one validation predicate for another needs a test showing the same inputs are still rejected]

2. **comment-only.** In the `splitRecord` matcher, symbol keys are now filtered out of `partialNames` (`patternMatchers.ts:1857-1859`, `.filter((name): name is string => typeof name === 'string')`). The old code cast `ownKeys(optionalSpecimen)` to `string[]` and kept every key. Silently skipping keys is the kind of change that can let a match pass without being checked. Here nothing can reach it: `confirmKind(specimen, 'copyRecord', reject)` runs first, and a copyRecord cannot have symbol keys. A short comment saying the filter only narrows the type would stop a later reader from treating it as a real filter. [rule: roles/jurors/wire-watcher/AGENT.md § In-band-marker trust-bypass]

3. **comment-only.** The new `amaro/strip` loader hook runs with full authority in the CLI, daemon and worker processes, before lockdown, and transforms every `.ts` module those processes load (`packages/cli/bin/endo.cjs:11`, `packages/daemon/src/amaro-exec-argv.js:6`). Guest code goes through compartment-mapper and SES, not Node's loader, so the hook adds nothing to what guests can do. But a third-party runtime dependency (`amaro ^1.1.9`) now sits in the module-load path of the trusted process. That trade-off belongs in the dependency review, so I've noted it rather than marking it should-fix. The specifier is resolved from the daemon package with `import.meta.resolve`, not from the child's working directory, which is correct and avoids a cwd-planted resolution.

4. **No finding** on `E.ts`. Moving the method out into `makeEMethod` and `makeESendOnlyMethod` keeps the computed-key method name, the `this !== receiver` check, and the reject-versus-`Fail` split between `E` and `E.sendOnly`. `toBreakpointProperty` only changes how a number key is given to the breakpoint tester, and a proxy `get` never receives a number key, so it is a no-op.

Self-improvement: a syntax-only conversion is reviewed best by stripping the types and diffing tokens against the old file. That brought up the predicate swap and the symbol filter, which reading the diff by eye would likely miss. Worth adding to `skills/panel-review` as a technique for refactors that only change syntax.
<sub><!--garden-provenance-section-->model <code>claude-opus-5-5</code> · harness <code>claude</code> · provider <code>anthropic</code></sub>
</details>

<details>
<summary><b>orthographer</b> — approve</summary>

**Verdict:** approve

**Findings:**
- none — the deterministic divergence grep found no British spellings introduced by this change. [rule: skills/american-english-normalization/SKILL.md]
<sub><!--garden-provenance-section-->model <code>claude-opus-5-5</code> · harness <code>claude</code> · provider <code>anthropic</code></sub>
</details>

<details>
<summary><b>thesaurus</b> — approve</summary>

**Verdict:** approve

**Findings:**
- none — the deterministic cliché grep found no Botese phrases introduced by this change. [rule: skills/botese-normalization/SKILL.md]
<sub><!--garden-provenance-section-->model <code>claude-opus-5-5</code> · harness <code>claude</code> · provider <code>anthropic</code></sub>
</details>

<details>
<summary><b>procurer</b> — approve</summary>

**Verdict:** approve

**Findings:**
- none — no added declaration shares a name with a function another package exports. [rule: skills/build-vs-buy/SKILL.md]
<sub><!--garden-provenance-section-->model <code>claude-opus-5-5</code> · harness <code>claude</code> · provider <code>anthropic</code></sub>
</details>

_12 seat section(s) omitted for length; full output in the garden panel-run record._

---
claim:
  host: endolin-garden-ece02cb4
  gardener: 1
  worker_kind: monk
  tier: 
  provider: anthropic
  model: 
  claimed_at: 2026-10-17T23:43:22Z
