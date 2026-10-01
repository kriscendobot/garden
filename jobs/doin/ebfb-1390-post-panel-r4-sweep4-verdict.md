---
role: gardener
requires: host=endolin-garden-ece02cb4
tier: mentor
fallback-tier: minion
dispatch: automatic
---

# Post the round-4 panel verdict (gauntlet ebfb-petname-path-only-sweep-4-gauntlet) on PR #1390 (endojs/endo-but-for-bots)

The gauntlet stage `ebfb-petname-path-only-sweep-4-gauntlet-panel-4` ran the panel on https://github.com/endojs/endo-but-for-bots/pull/1390 (head `fa544951bcb77b0c184bfd1db1ca7ed6a22fef55`, disposition **must-fix**, durable record `panel-runs/endojs-endo-but-for-bots-1390/b6501a8b951a.md`). It could not post the review because the oros-studio host PAT gets `Resource not accessible by personal access token (addPullRequestReview)` on endojs.

Write the text between the markers to a file and post it VERBATIM as a COMMENT review. The PR author is the bot, so request-changes is not allowed, and earlier rounds were posted the same way:
`gh pr review 1390 -R endojs/endo-but-for-bots --comment --body-file <file>`.
First check whether the PR head is still `fa544951bc`. If it has moved, post anyway, because the verdict is labelled with its head. Do NOT post twice: skip if a review titled "Gauntlet panel — round 4 (single-round, gauntlet `ebfb-petname-path-only-sweep-4-gauntlet`)" already exists. Do nothing else.

----- REVIEW -----
## Gauntlet panel — round 4 (single-round, gauntlet `ebfb-petname-path-only-sweep-4-gauntlet`): **must-fix**

Head `fa544951bc` vs base `llm-8e53cc0` (`8e53cc0f89`). All 33 seats ran and none errored. **7 seats requested changes**: breaker, changeset-auditor, corner-prober, integrator, migrator, stylist, and typist. 12 were comment-only: assessor, coverage-auditor, curator, duality-auditor, fast-checker, gateway, packager, releaser, saboteur, scribe, surfacer, and wire-watcher. The other 14 approved.

**Deterministic pre-passes:** the related-design check is **clear**. Round 3's items held under attack: `namePathLabel` is total over lone surrogates, `assembleMentionSend` keeps three or more colliding edge names distinct, and the `NamePathArgumentShape` rationale is gone from `AGENTS.md`.

### Must-fix

1. **integrator — the chat command executor has two path grammars.** `packages/spaces-util/src/command-executor.js` wraps typed text as a single segment in `adopt` (:109), `resolve` (:163), `endow` (:286-292), and `evaluate` (:317-323). In the same file, `ls` (:358), `show` (:367), copy/move (:396-409), and the `send` recipient (:75, :228) still split on `/`. `isValidName` never accepts a `/`, so `/js … x=dir/foo` is now always refused while `/show dir/foo` still works. The `['dir/foo']` case in `packages/chat/test/unit/command-executor.test.js` pins a value the daemon always rejects. The PR body also says UI callers "never split it on `/`", and the head contradicts that. The #1343 direction covers the Exo surface. A human-typed command line that converts `a/b` to `['a','b']` is the caller-side conversion that direction expects. Pick one grammar for the executor (splitting at the UI boundary is the coherent choice), fix the test, and correct the body.
2. **breaker / corner-prober / assessor — the `makeUnconfinedFromTree` pre-check misses cases, so scratch mounts leak** (`packages/daemon/src/host.js:1788-1807`). The comment promises that "a refusal leaves no scratch mount behind". The pre-check runs only `namePathFrom`, though. `powersName: ['@bogus']` and `resultName: ['@x']` both pass it, get staged, and are then refused by `assertPowersNamePath` and `petNamePathFrom`. Percent-encoding can expand a character up to 9×, and the label also carries a `scratch-` prefix, so a valid multi-segment `resultName` such as `['a'.repeat(100),'b'.repeat(100),'c'.repeat(60)]` produces a name over 255 characters. That name fails *after* staging with an `Invalid pet name scratch-…` error the caller never typed. Run `assertPowersNamePath`, `petNamePathFrom`, and an `isValidName` check on the full `scratch-${label}` name (or hash or truncate the label) before `stageTreeInternal`. Pin the behavior with tests. `pet-name.test.js:422` currently skips the overlong case.
3. **breaker — lal's own prompts and primer still teach bare-string calls the daemon now refuses.** These are `packages/lal/prompts/system.js:76-79,113-114,124` (`readText("primer", …)`, `list("primer")`, `inspect("name")`, `lookup("increment-result")`) and `packages/lal/primer/tools.md:82-88`, `howto-capabilities.md:18`, and `capabilities.md:147`. A fresh lal agent's first call costs a refused round trip. Update them to path form, the same way commit bfca19b9c updated the help text.
4. **breaker — lal `readText`, `writeText`, and `editText` cannot target a daemon `EndoDirectory`.** `packages/lal/tools/fs.js:34,44,60` declares `fileName: M.string()`, and `tool-dispatch.js:400,412,432,438` forwards it as a string. `directory.js` now refuses that string through `namePathFrom`, and the retry hint can't be followed. Widen it to a path shape or wrap it as `[fileName]` for directories, and add a test against a real `EndoDirectory`.
5. **typist — `packages/agent-tools/src/code-mode/types.ts:11` `LookupPowers.lookup(petName: string | string[])`** advertises a `string` input that every daemon `lookup` now rejects. Narrow it to `string[]`. The hand-copied `evaluate` powers type in `agent-tools/src/code-mode/daemon.js` should derive from `EndoHost['evaluate']` so it stops drifting.
6. **changeset-auditor / migrator / integrator / releaser — the changeset needs three corrections** (`.changeset/pet-name-path-only.md`):
   - (a) Folding in `daemon-type-guards-export.md` dropped the note that `NameShape` and `NamePathShape` are now exported from `@endo/daemon/type-guards.js`. Add that sentence back.
   - (b) The body says `NamePathArgumentShape` accepts only an array, but its definition is `M.or(NamePathShape, M.string())`. Say in one sentence that the string arm exists only so the call can raise a friendly `TypeError`.
   - (c) `@endo/agent-tools` silently changes behavior: a string `'a/b'` used to be a path and is now one segment. It is bumped `patch` with no migration note. Document it, or bump to `minor`. Also confirm that `major` on 0.x `@endo/agentry` and `@endo/lal` (which graduates them to 1.0.0) is intended.

### Should-fix / comment

- **stylist**: new test locals named `ctx` should be `context`. New `@type` cast parameters (`opts`, `n`, `edge`, `pet` in the `share-modal.js` and `adopt` casts) should be spelled out. `anyStringArb`/`pathArb` should become `arbitraryString`/`arbitraryPath`. `toPetNamePath(nameOrPath)` uses the retired `NameOrPath` vocabulary. Rename the evaluate JSDoc's `petNames`/`resultName` to `petNamePaths`/`resultNamePath`. Consider `credentialPetNamePath`.
- **typist**: `→` (U+2192) appears on added lines in `packages/fetch/README.md:39,41`, `packages/lal/LAL-ARCHITECTURE.md`, and `packages/space-whylip/README.md`. Use `->` instead. Consider `@deprecated` on the `string` arm of `InvitationFormula.guestName`.
- **integrator**: the `designs/fs-interface-consolidation.md:111-114` divergence table still says `EndoDirectory` takes `NameOrPathShape`. Correct it, or name the follow-up in the body. The 80-commit history includes repeated sweeps and churn commits (the changeset and prettier ones). Regroup it before the rebase-merge.
- **corner-prober**: the `assembleMentionSend` suffix can push an edge name past 255 characters. Edge cases with no tests: `['bob','bob','bob-author']`, mismatched `recap.petNames`/`edgeNames` lengths (assessor: `[undefined]` reaches the daemon), and non-array inputs to `namePathFrom` (`undefined`, `null`, array-likes, sparse arrays). `q(namePath)` echoes an unbounded string into the error.

<details>
<summary>Request-changes seat output</summary>

<details>
<summary><b>integrator</b> — request-changes</summary>

**Verdict:** request-changes

**Findings**

1. **must-fix: the chat command language now has two path grammars, and the PR description says otherwise.** [rule: roles/jurors/integrator/AGENT.md § Concept-namespace coherence; skills/pr-formation/SKILL.md]
   - In `packages/spaces-util/src/command-executor.js`, `adopt` (:109), `resolve` (:163), `endow` (:286-292) and `evaluate` (:317-323) now wrap typed text as a one-segment path: `[e.petName]`, `[String(resultName)]`.
   - In the same file, `ls` (:358), `show` (:367), the copy/move cases (:396-409) and the `send` recipient (:75, :228) still split typed text on `/`.
   - Under `isValidName` (`packages/daemon/src/pet-name.js:19`), a pet name can never contain `/`. So `/js … x=dir/foo` used to reach `['dir','foo']` and is now a guaranteed daemon rejection, while `/show dir/foo` still works.
   - `packages/chat/test/unit/command-executor.test.js` (from d691ac9b9) pins forwarding `['dir/foo']`, a value the daemon always refuses. The test pins the regression, not a contract.
   - The PR body says UI callers "never split it on `/`". The head contradicts that.
   - The maintainer's direction on #1343 covers the agent-facing **Exo surface**. A human-typed command line that turns `a/b` into `['a','b']` is the caller-side conversion that direction expects.
   - Fix: pick one grammar for the command executor. Splitting at the UI boundary everywhere is the coherent choice. Then correct the description.
   - Overlaps with assessor, prover and corner-prober.

2. **should-fix: `designs/fs-interface-consolidation.md:111-114` now describes the guards wrongly.** [rule: roles/jurors/integrator/AGENT.md § Rename completeness sweep]
   - The divergence table states that `EndoDirectory` accepts `NameOrPathShape = string | string[]`, a daemon shape this PR removes.
   - Commit 93cbfe15f dropped the fix on purpose. The PR body names the parked platform follow-up but not this one.
   - Either land a one-line correction or name the follow-up job in the body.
   - Other designs (`daemon-value-message.md`, `daemon-weblet-application.md`, `daemon-endor-architecture.md`) still use `NameOrPathShape`/`petNameOrPath`. Those are acceptable as historical snapshots.

3. **should-fix: the commit history will read badly after a rebase-merge.** [rule: AGENTS.md § Pull requests (rebase-and-merge); roles/jurors/integrator/AGENT.md § Commit grouping]
   - Rebase-merge keeps all 80 commits in `master` history.
   - Several are repeated sweeps: "pass pet-name paths from remaining string callers" appears three times, plus e1f3522a3 and b7c33a65d.
   - Others are standalone prettier/style commits (3958a0731, 442734287) and changeset churn (12c61653a, 5fb8d8039, dbf3a3fd2, ae16de9b7, f65b1bd9a, 4a60faefb, 93cbfe15f).
   - Regroup into a handful of logical commits: daemon contract, lal renames, adapters per area, tests, docs, changeset, and a separate `chore: Update yarn.lock`.
   - Overlaps with packager.

4. **comment-only: guard and type names.** [proposed-rule: a guard that is deliberately wider than its contract should carry that in its name or sit beside its narrowing call]
   - `NamePathArgumentShape` admits a bare string while `NamePathShape` does not. The JSDoc explains why. The pair works but is easy to misuse.
   - `@endo/platform` still exports its own `NameOrPathShape`, now next to the removed daemon name of the same spelling. `packages/daemon/src/interfaces.js:103` and `:849` explain the difference, and the parked `ebfb-platform-fs-pet-name-path-only` follow-up resolves it.

5. **comment-only: the changeset fold dropped a release note.** [rule: skills/changeset-discipline/SKILL.md]
   - Folding `.changeset/daemon-type-guards-export.md` removed the note that `NameShape`/`NamePathShape` are newly exported from `@endo/daemon/type-guards.js`.
   - Overlaps with releaser.

**Related-design reconciliation:** this PR is the follow-up job requested in the #1343 review (kriskowal, CHANGES_REQUESTED, 2026-09-30), and the daemon Exo surface follows that direction. #1343 rebases onto this PR, so the two compose. Finding 1 is the one place where the PR extends the directive past the Exo surface without saying so.

Self-improvement: check pet-name-path PRs against `isValidName` before accepting "wrap as one segment" at UI parse sites. A wrapped name that contains the delimiter is always rejected, so the wrap hides a regression.

</details>

<details>
<summary><b>breaker</b> — request-changes</summary>

**Verdict:** request-changes

**Findings**

1. **should-fix: lal's own prompts still teach bare-string pet-name paths, and the daemon now refuses them.** `namePathFrom` (`packages/daemon/src/pet-name.js:154`) promises that a string "is never split on a delimiter" and that the call is always refused. The lal system prompt (`packages/lal/prompts/system.js:76-79,113-114,124`) and the primer (`packages/lal/primer/tools.md:82-88`, `howto-capabilities.md:18`, `capabilities.md:147`) still tell the agent to call `list("primer")`, `readText("primer", "README.md")`, `inspect("name")` and `lookup("increment-result")`. Commit bfca19b9c updated the sibling help text and READMEs but skipped these files. The attack is a fresh lal agent following its own system prompt: its first `list` call reaches `E(powers).lookup('primer')` and gets a TypeError. The retry hint lets it recover, but every session pays a refused round trip that its own instructions caused. [rule: roles/jurors/breaker/AGENT.md § Sibling-family enumeration]

2. **should-fix: lal's `readText`, `writeText` and `editText` hand `fileName` to `E(capability).readText` / `.writeText` as a string, and the tool schema forces that string.** The relevant spots are `packages/lal/tool-dispatch.js:400,412,432,438` and `packages/lal/tools/fs.js:34,44,60` (`fileName: M.string()`). When `petNamePath` resolves to a daemon `EndoDirectory`, `directory.js` `readText`, `maybeReadText` and `writeText` now pass that string to `namePathFrom` and refuse it. The attack: `makeDirectory({petNamePath:['notes']})`, then `writeText({petNamePath:['notes'], fileName:'a.txt', content:'x'})`. The second call throws, and the retry hint can't be followed because `fileName` must be a string. Mounts and readable trees still accept strings, so the failure only shows up against daemon directories. The fix is to widen `fileName` to `NamePathArgumentShape` or wrap it as `[fileName]` when the target is a directory. Add a test that drives these tools against a real `EndoDirectory`. [proposed-rule: a tool parameter whose value reaches a daemon `namePathFrom` must accept an array shape, or the retry hint is unreachable]

3. **should-fix: `makeUnconfinedFromTree`'s new pre-check promises that "a refusal leaves no scratch mount behind", but it is weaker than the checks that run after staging** (`packages/daemon/src/host.js:1788-1795`). It runs only `namePathFrom` on `powersName` and `resultName`. After staging, `prepareMakeCaplet` applies `assertPowersNamePath`, and the deferred `storeIdentifier` applies `petNamePathFrom`. Two inputs show the gap:
   - `options.powersName: ['@bogus']` passes the pre-check. `namePathLabel` produces a valid scratch name, the scratch mount is stored, and then `assertPowersName` throws.
   - `options.resultName: ['@x']` gets past staging the same way, then the special-name leaf is refused at store time.

   In both cases a scratch mount is left behind. Use `assertPowersNamePath` and `petNamePathFrom` in the pre-check. Separately, a valid long `resultName` produces a `namePathLabel` over 255 characters (the property test concedes this at `pet-name.test.js:422`), and that is refused with an `Invalid pet name scratch-…` error the caller never typed. [rule: roles/jurors/breaker/AGENT.md § Operating norms, claimed-invariant attack]

4. **comment-only: mitigated, with defensive tests already in place.** The `namePathLabel` injectivity across lone surrogates and `%u`, the `assembleMentionSend` edge-name uniqueness (`x`, `x-author`, `x` → `x-author-2`), and the secret-manager `PATH_MUST_BE_ARRAY` fixed code all held under attack. One leftover: host `lookup` at `host.js:2415` still quotes a `'@secrets/use/<grant>'` string before the secret manager's guard runs. This was already true before this PR and is not a regression.

Self-improvement: when a PR tightens a validator, grep for prompt and primer prose that teaches the old call form and treat it as a sibling site.

</details>

<details>
<summary><b>corner-prober</b> — request-changes</summary>

**Verdict:** request-changes

The core helpers are well covered for injectivity and lone surrogates. A few corners on the label-length and edge-name paths are not exercised.

**Findings**

1. **`namePathLabel` can exceed the 255-character name limit, and the `scratch-` prefix is not accounted for.** `packages/daemon/src/host.js:1799-1805` builds `scratch-${resultLabel}` and then uses it as a pet name. Percent-encoding expands each character up to 9 times (`%uXXXX` is 6 characters, a 3-byte UTF-8 character is 9). `['a'.repeat(100), 'b'.repeat(100), 'c'.repeat(60)]` gives a 262-character label. Even a 248 to 255 character label fails once `scratch-` is added.
   - The test at `pet-name.test.js:422` is `label.length > 255 || isValidName(label)`, which skips the overlong case entirely.
   - No test covers `makeUnconfined` with a long or multi-segment `resultName`.
   - I did not run these cases. Recommended action: add tests pinning the overlong-label behavior, and either throw a clear error or truncate and hash the label.
   - Disposition: `must-fix-loop`, because the PR claims the label "yields a valid name".
   - [rule: skills/adversarial-tests/SKILL.md § Boundary sweep]

2. **`assembleMentionSend` can build an edge name over 255 characters or one that is not a valid name.** `mention-send.js` appends `-author` or `-author-N` to a base edge name that may already be 255 characters.
   - No test covers a 255-character base name.
   - There is also no test for `recap.petNames.length` differing from `recap.edgeNames.length`, or for `recap.strings` shorter than `edgeNames.length + 1`. The `|| ''` fallback is untested.
   - Disposition: `summary-fix`.
   - [rule: skills/adversarial-tests/SKILL.md § Boundary sweep]

3. **A collision between a suffixed edge name and a later literal one is untested.** For example, `['bob','bob','bob-author']` hits the `usedEdgeNames` loop; the code looks correct, but no test pins the case. The same gap applies to a recap edge name equal to the channel name when the channel name is already suffixed. Disposition: `summary-fix`.
   - [rule: skills/regression-evidence/SKILL.md]

4. **`namePathFrom` has no test for non-array, non-string inputs.** `undefined`, `null`, `{length: 1, 0: 'a'}` and a sparse array such as `[ , 'a']` all go through `assertNamePath`. A sparse array's hole is `undefined`, which `assertName` should reject, but nothing asserts that. Also check that the `isName` guard behind the "wrap the string" suggestion handles a string containing `@` or `\0`. Disposition: `summary-fix`.
   - [rule: skills/adversarial-tests/SKILL.md § Boundary sweep]

5. **`NamePathArgumentShape` admits any `M.string()`, including an empty string, a lone-surrogate string or a 10 MB string.** `q(namePath)` echoes the whole string into the error message. A long string produces a very long error, and an empty string produces `Invalid pet-name path ""`. Neither is covered by a test. Disposition: `summary-fix`.
   - [proposed-rule: error messages that quote caller input should truncate it to a bounded length]

Everything else I sampled looks closed: the empty path, the one-segment path, `%` and `%u` literals, a surrogate pair against a lone surrogate, and `.` and `..` segments.

</details>

<details>
<summary><b>typist</b> — request-changes</summary>

Verdict: request-changes

Findings:

1. **should-fix** `packages/agent-tools/src/code-mode/types.ts:11`. `LookupPowers.lookup` is declared `(petName: string | string[])`, but every daemon `lookup` in this PR is now `string[]` only (`packages/daemon/src/types.d.ts` `NameHub`/`ReadableNameHub`). `packages/agentry/src/code-mode.js:101` wraps a bare string into a one-element array before calling it, so the runtime always passes `string[]`. The `string` arm of the type advertises an input the real host rejects. A caller that passes `lookup('x')` to a real host type-checks here and fails at runtime. Narrow it to `string[]`. [proposed-rule: when a PR narrows an exported signature, grep dependent packages for hand-copied structural types of that signature, such as `LookupPowers`.]

2. **should-fix** `packages/agent-tools/src/code-mode/daemon.js:~20`. The `powers` type is inlined as `evaluate: (workerName: undefined, ..., petNames: string[][], resultName?: string[])`. It is a hand-copied structural type that has to track `EndoHost.evaluate` (now `workerNamePath: string[] | undefined`). That copy is the kind of thing that drifts. Prefer an `@import`ed type derived from `EndoHost['evaluate']`.

3. **comment-only** `packages/daemon/src/types.d.ts:668-671`. `InvitationFormula.guestName: NamePath | string` is documented as legacy-record tolerance. This is the typedef-hides-invariant pattern: the comment is good. It would be tighter to mark the `string` arm `@deprecated`, since the maker always revives it.

4. **comment-only** `packages/daemon/src/types.d.ts` `DeferredTask`/`DeferredTasks` (~2747) and `packages/daemon/src/deferred-tasks.js:6`. They still use `Record<string, string | string[]>`. These are formula-id maps rather than pet-name paths, so this is probably correct. Confirm that was intended and not a missed sweep.

5. **should-fix** (typist-hostile glyphs). The `→` (U+2192) appears on added lines in `packages/fetch/README.md:39,41`, `packages/lal/LAL-ARCHITECTURE.md` (two lines), and `packages/space-whylip/README.md`. The lines were edited by this diff, so the glyph is now on added lines. Replace it with `->`. [rule: skills/typist-friendly-code-points/SKILL.md]

Checked and clean:
- No inline `import()` in JSDoc tags was added.
- No new multi-field `@typedef` blocks were added to `.js` files.
- Removing `NameOrPath` and `NamesOrPaths` from `types.d.ts` is matched by the JSDoc updates in `guest.js` and `host.js` (`NamePath`, `NamePath[]`).
- `Mail.resolve(messageNumber, resolutionName: string[])` agrees with the `resolutionNamePath` parameter in `mail.js:940`.

I did not run `tsc` or the test suite, and I read only part of the 225-file diff. I covered `types.d.ts`, the `guest.js`/`host.js` JSDoc, and the grep sweeps for leftover `string | string[]` and typist-hostile glyphs. I did not look at the test files or the other packages in detail.

Self-improvement: add a checklist item to sweep downstream packages for hand-copied structural types of a narrowed daemon API.

</details>

<details>
<summary><b>changeset-auditor</b> — request-changes</summary>

**Verdict:** request-changes (summary-fix; the package set and bump levels are sound)

**Findings**

1. **Dropped release note: the deleted `daemon-type-guards-export.md` changeset.**
   - The diff deletes the base's `.changeset/daemon-type-guards-export.md` (`@endo/daemon: minor`, `@endo/lal: patch`). That changeset announced the new exports `NameShape` and `NamePathShape` from `@endo/daemon/type-guards.js`.
   - Both exports still exist (`packages/daemon/type-guards.js:21,25`).
   - `pet-name-path-only.md` only mentions the removal of `NameOrPathShape` and `NamesOrPathsShape` and the arrival of `NamePathArgumentShape` and `NamePathsArgumentShape`. The "now exports `NameShape`/`NamePathShape`" note is lost from the changelog.
   - The `major` bump subsumes the semver level, but the migration note should name the surviving exports. Add one sentence, or restore the original changeset.
   - [rule: skills/changeset-discipline/SKILL.md § Body-vs-diff coherence]

2. **Body naming: the changeset describes the rejection and the stored `guestName` retention, not the `Name`/`NamePath` surface.**
   - The body says `NamePathArgumentShape` is the replacement. Its definition, `M.or(NamePathShape, M.string())`, is the shape that still accepts a string. That sits oddly beside "accepts only … an array".
   - If the `M.or` string branch exists only so the guard can raise the friendly `TypeError`, say so in one sentence. As written, a reader checking the shape against the claim will see a contradiction.
   - [rule: skills/changeset-discipline/SKILL.md § Body-vs-diff coherence]

3. **Private packages bumped without comment (non-blocking).**
   - Of the 31 listed packages, 28 are `private: true`. Only `@endo/agent-tools`, `@endo/agentry`, and `@endo/platform` are public.
   - `.changeset/config.json` has `privatePackages.version: true`, so listing them is valid, and the front-matter matches the diff exactly: all 31 touched packages are listed and none are stale.
   - The `major` on the private `@endo/lal` and `@endo/sandbox` is defensible. The `major` on `@endo/agentry` is correct for the breaking `NormalizedGitRemoteSpec.credential` change.
   - The `patch` on `@endo/agent-tools` and `@endo/platform` is acceptable. Both gain only a `fast-check` devDependency plus call-site changes, and platform's guards still accept strings.
   - [rule: skills/changeset-discipline/SKILL.md § Bump level]

**Checked and clean**

- Bundling: a single changeset covers the PR.
- Style: sentence-per-line, with no process commentary.
- `yarn.lock`: in its own commit (`5762b151c chore: Update yarn.lock`).
- New packages: none introduced, so the initial-release shape rule does not apply.

</details>

<details>
<summary><b>migrator</b> — request-changes</summary>

**Verdict:** request-changes

**Findings**

1. **[should-fix] `@endo/agent-tools` silently changes behavior and is bumped `patch`.**
   - `packages/agent-tools/src/code-mode/daemon.js:8` wraps a string `petName` or `resultName` as a one-segment path. Before, the daemon accepted a string and treated `'a/b'` as a path. Now it is one segment named `a/b`.
   - Published code-mode callers that pass delimited strings will resolve to different names, or none.
   - The changeset lists `@endo/agent-tools` under "the remaining packages pass pet-name paths to the daemon". It does not mention this contract shift.
   - Either document it in the Migration section, or raise the bump to `minor`. Since 0.0.1 is pre-stable, `minor` is the 0.x breaking-change signal.
   - [rule: skills/changeset-discipline/SKILL.md]

2. **[should-fix] `@endo/agentry` (0.1.0) and `@endo/lal` (0.1.0) are bumped `major`.**
   - Changesets will turn this into 1.0.0, which may not be intended for 0.x packages.
   - The type narrowing of `NormalizedGitRemoteSpec.credential` (`string | string[]` → `string[]`, `packages/agentry/src/code-mode-provisioning-types.ts`) and the lal tool-argument renames are real breaking changes.
   - Please confirm that a 1.0 graduation is the intent. If it isn't, use `minor`.
   - [rule: skills/changeset-discipline/SKILL.md]

3. **[comment-only] Deleting `.changeset/daemon-type-guards-export.md` drops the `@endo/lal: patch` and daemon `minor` entries.**
   - That changeset announced the new `NameShape` and `NamePathShape` exports from `@endo/daemon/type-guards.js`.
   - The replacement changeset covers `@endo/daemon` and `@endo/lal` at `major`, so the bump levels are covered.
   - The release notes now only describe the removal of `NameOrPathShape` and `NamesOrPathsShape`. They never mention that `NameShape` and `NamePathShape` are public.
   - Add one sentence about the exports, or restore a note for them.

4. **[comment-only] Cascade and downstream coverage look sound.**
   - All 30 changed packages are named in the changeset. I found none missing.
   - Unchanged callers such as `packages/chat/setup-lal.js`, `packages/cli/src/commands/inbox.js`, and `packages/reminder/src/store.js` use the variadic `locate('@self')`, `has('x', 'y')` forms. Those stay valid, and `remove` there goes to a directory, not the daemon host.
   - The platform name-hub guards keep `string | string[]`, so the one-segment arrays that `layer-module.js` now sends are accepted.
   - Stored `guestName` strings still revive, which the changeset notes.
   - I found no remaining string-callers in unchanged files.

5. **[comment-only] `fast-check` was added as a devDependency to `@endo/daemon` and `@endo/agent-tools`.**
   - `yarn.lock` is updated in the same diff. It should live in a separate `chore: Update yarn.lock` commit, per AGENTS.md.
   - I did not check the commit split. Please confirm it.
   - [rule: skills/yarn-lock-separate-commit/SKILL.md]

Self-improvement: for 0.x packages, a `major` changeset bump forces graduation to 1.0, so check the package's current version before accepting it. I proposed no new rule.

</details>

<details>
<summary><b>stylist</b> — request-changes</summary>

**Verdict:** request-changes

**Findings**

1. **must-fix: fresh `ctx` abbreviation.** The new tests in `packages/spaces-util/test/chat-bar-component.test.js` add `const ctx = setup()` and use `ctx.` throughout. They do this twice, once in each new `test.serial` (diff lines ~669 and ~695). The command-executor test also adds `const ctx = createMockContext()` and uses `ctx.powers`, `ctx.calls` and `ctx.showValueCalls` in the new `[10n, ['feature/foo']]` case. The fix is `context`, or a more specific name such as `chatBar`. The existing `ctx` in sibling tests does not exempt new uses. [rule: roles/jurors/stylist/AGENT.md § Abbreviated identifiers]

2. **must-fix: abbreviated parameter names in new type annotations.**
   - Several new `@type` casts in `space-channel/src/share-modal.js` and nearby files write `provideHost: (name: string[], opts: { agentName: string[] })`. `opts` should be `options`.
   - The new `adopt` cast writes `(n: bigint, edge: string, pet: string[])`. Spell these out as `number`, `edgeName` and `petNamePath`.
   - The `adopt` cast also names the first parameter `n`, a bare abbreviation. [rule: roles/jurors/stylist/AGENT.md § Abbreviated identifiers]

3. **should-fix: `anyStringArb` in the daemon-evaluate test.** `Arb` abbreviates "arbitrary". Prefer `anyStringArbitrary`, or `arbitraryString`, which reads as an ordinary noun. `pathArb` has the same problem. This is fast-check community shorthand, so it is borderline. The never-abbreviate rule still applies to freshly authored names. [rule: roles/jurors/stylist/AGENT.md § Abbreviated identifiers]

4. **should-fix: `toPetNamePath(nameOrPath)` parameter name and its doc disagree.** The helper's JSDoc says it wraps a lone pet name as a one-segment path. The parameter is named `nameOrPath`, after the vocabulary this PR retires (`NameOrPath` is replaced by `NamePath`). The new `makeDaemonEvaluate` JSDoc also still calls the evaluate parameters `petNames: string[][]` and `resultName?: string[]`, although both are now paths. Rename the parameter to `nameOrNamePath`, or `petNameOrPath` if that matches the module. Rename the evaluate parameters to `petNamePaths` and `resultNamePath` so the name and the docstring agree. The changeset already renames the lal tool-call keys this way, so the evaluate call sites should follow it. [rule: roles/jurors/stylist/AGENT.md § Secondary surface (doc-name accuracy)]

5. **comment-only: inconsistent path-parameter names across the PR.** The new code uses `petNamePath`, `namePath`, `name: string[]`, `credentialPetName: string[]` and `channelPetName` (a string, so correctly named). One convention is clearly intended: `...NamePath` or `...PetNamePath` for `string[]`, and the unsuffixed `...Name` for a string. Examples of names that fall outside it:
   - `@param {string[]} credentialPetName` in the sandbox factory
   - `credential?: string[]`
   - `name: string[]` in the provideHost and storeLocator casts

   Consider renaming the first one to `credentialPetNamePath` for consistency.

I found no redundant-word concatenations. The renames the changeset lists are justified by the PR's claim and appear in its migration notes.

Self-improvement: the abbreviation check should also cover identifiers inside `@type` cast signatures, which are easy to miss, and `Arb`-style suffixes from property-test libraries.

</details>

</details>

<sub><!--garden-provenance-->model <code>claude-opus-5-5</code> · harness <code>claude</code> · provider <code>anthropic</code> · host <code>oros-studio-garden-ce242c49</code> · garden <a href="https://github.com/kriscendobot/garden/commit/697976e718f354af3b121874c52a6cdbc8d6c87c"><code>697976e7</code></a></sub>
----- END REVIEW -----

---
claim:
  host: endolin-garden-ece02cb4
  gardener: 1
  worker_kind: monk
  tier: 
  provider: anthropic
  model: 
  claimed_at: 2026-10-01T22:58:25Z
