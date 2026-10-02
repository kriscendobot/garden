---
role: gardener
requires: host=endolin-garden-ece02cb4
tier: mentor
fallback-tier: minion
dispatch: automatic
---

# Post the round-2 panel verdict (gauntlet build-endo-claude-broker-catalog-pruning-gauntlet) on PR #1409 (endojs/endo-but-for-bots)

The gauntlet stage `build-endo-claude-broker-catalog-pruning-gauntlet-panel-2` ran the panel on https://github.com/endojs/endo-but-for-bots/pull/1409 (head `526964f492a16d6c3fd565f6e6676866dc953e9f`, disposition **must-fix**, durable record `panel-runs/endojs-endo-but-for-bots-1409/954f435c6b7f.md`). It could not post the review because the oros-studio host PAT gets `Resource not accessible by personal access token (addPullRequestReview)` on endojs.

Write the text between the markers to a file and post it VERBATIM as a COMMENT review. The PR author is the bot, so request-changes is not allowed, and round 1 was posted the same way:
`gh pr review 1409 -R endojs/endo-but-for-bots --comment --body-file <file>`.
If the PR head has moved, post anyway, because the verdict names its head. Do NOT post twice: skip if a review already contains `<!-- garden-panel-round: build-endo-claude-broker-catalog-pruning-gauntlet-panel-2 -->`. Do nothing else.

----- REVIEW -----
<!-- garden-panel-verdict: must-fix -->
<!-- garden-panel-round: build-endo-claude-broker-catalog-pruning-gauntlet-panel-2 -->
## Garden panel — round 2: **must-fix**

Head `526964f492` vs base `llm-d4124e6`. All 33 seats ran, none errored: 4 request-changes (breaker, changeset-auditor, integrator, pruner), 15 comment-only, 14 approve. Durable record: `panel-runs/endojs-endo-but-for-bots-1409/954f435c6b7f.md`.

(Posted as a COMMENT review: GitHub refuses REQUEST_CHANGES from the PR author. Disposition is **must-fix**.)

Must-fix: integrator (PR description contradicts the head: `allowedToolNames` *replaces* rather than narrows, and the changeset bump is `major` not `minor`; fold the round-1 fix-up commit into the feature commit), changeset-auditor (a `major` changeset on the unpublished `@endo/agent-mcp-stdio`, whose initial release is already pending as `major`; fold it in or make it `minor`/`patch` without the "Breaking:" framing — note these two seats pull opposite ways on the bump, and changeset-auditor's reading governs), breaker (served `listMessages`/`followMessages`/`followNameChanges` results still expose the locators and identifiers the module claims to withhold: narrow the claim or scrub, with a test), pruner (the `confined.js` module comment duplicates the README). Comment-only seats carry summary-fix notes; approving seats' prose is elided to fit GitHub's review size limit.

<details>
<summary><b>assessor</b> — approve</summary>
Verdict: approve — no findings requiring action. (Full seat prose elided to fit GitHub's 65,536-character review limit.)
<sub><!--garden-provenance-section-->model <code>claude-opus-5-5</code> · harness <code>claude</code> · provider <code>anthropic</code></sub>
</details>

<details>
<summary><b>typist</b> — approve</summary>
Verdict: approve — no findings requiring action. (Full seat prose elided to fit GitHub's 65,536-character review limit.)
<sub><!--garden-provenance-section-->model <code>claude-opus-5-5</code> · harness <code>claude</code> · provider <code>anthropic</code></sub>
</details>

<details>
<summary><b>stylist</b> — comment-only</summary>

**Verdict:** comment-only

Naming is crisp and consistent with the surrounding package. No gratuitous renames, and no bare abbreviations in freshly authored identifiers. `dir` and `parentDir` in `broker.js` are pre-existing, and the diff adds no new abbreviation.

**Findings**

1. **should-fix, `confinedToolNames` and `allowedToolNames` do not agree on what is allowed.**
   - `packages/agent-mcp-stdio/src/confined.js:34` names the default list `confinedToolNames`.
   - `packages/agent-mcp-stdio/src/broker.js:105` takes the replacement as `allowedToolNames`.
   - The doc says `allowedToolNames` is not intersected with the default and can serve a withheld tool again, so a caller can widen the set past what the "confined" name promises.
   - Name and doc disagree on whether the served set is "confined" or "allowed".
   - Suggested names: `confinedToolNames` → `defaultAllowedToolNames`, or the option → `servedToolNames`.
   - [proposed-rule: an option that replaces a default must be named for what it is, not for the default's adjective.]

2. **should-fix, `selectConfinedTools` is misnamed for its job.**
   - `confined.js:84` takes an arbitrary `allowedNames`, and the broker passes it caller-supplied names that need not be confined.
   - The function is a generic filter by name: `selectToolsByName`, or `selectAllowedTools`.
   - "Confined" in the name misleads when it is called with a widened list.
   - Its parameter `allowedNames` also differs from the broker option `allowedToolNames`. Pick one spelling.

3. **comment-only, the variable `served` and the file name.**
   - `broker.js:~115`, `served`, is fine.
   - `confined.js` holds an allow-list plus a selector. The file name is acceptable and matches the exports.

4. **comment-only, the test title is imprecise.**
   - `broker.test.js`: "an explicit allow-list narrows the served catalog further".
   - By the doc and the changeset, an explicit list replaces the default rather than narrowing it.
   - The test itself only shows the narrowing case. Reword it to "replaces", or add a widening case.

Self-improvement: when an option's doc says it overrides rather than intersects, check that the identifier names for the default and the option do not claim a restriction the override can break.
<sub><!--garden-provenance-section-->model <code>claude-opus-5-5</code> · harness <code>claude</code> · provider <code>anthropic</code></sub>
</details>

<details>
<summary><b>packager</b> — comment-only</summary>

Verdict: comment-only

The diff is clean and tightly scoped. It has two commits: `32f76e466` is the substance and `526964f49` is a docs and changeset follow-up. All ten touched files belong to the confined-catalog change. There is no yarn.lock churn, no generated files and no drive-by edits.

Findings:

1. **comment-only: `@endo/agent-mcp-stdio` is `"private": true` at 0.1.0, so the `major` bump has no consumer effect.**
   - `.changeset/agent-mcp-stdio-confined-catalog.md` declares `major`, and the "Breaking:" prose is accurate. The only in-repo dependent is `@endo/claude`, which is the consumer this change targets.
   - Changesets does not publish private packages, and a major on a 0.x package would normally become 1.0.0 in the changelog.
   - Keep the major if it is the repo's convention for 0.x or private packages. If it is not, `minor` is the more usual choice, and the changeset could be dropped. This is minor.
   - [rule: skills/changeset-discipline/SKILL.md]

2. **comment-only: no changeset for `@endo/claude`.**
   - Its README and test changed because the new broker behaviour feeds the confined turn's tool list. The change is documentation and tests only, with no runtime or API change.
   - A missing changeset is acceptable. A one-line `patch` note would only be warranted if `@endo/claude` is published and meant to advertise the behaviour change.
   - [rule: skills/changeset-discipline/SKILL.md]

3. **comment-only: the changeset describes everything that landed.**
   - It covers the default allow-list, the `tools/list` absence, the `tool-not-permitted` refusal with `error.data.reason: name-scope`, the `allowedToolNames` override, which is not intersected with the default, and the new exports `confinedToolNames` and `selectConfinedTools`.
   - Those exports are the changes to `index.js` and `test/exports.test.js`, so the changeset is consistent with the diff.
   - `exports["."]` already points at the top-level `index.js` shim, so the `src/` internal-path rule is not triggered. No new `exports` entries were added, and no peer-dependency or typedoc/tsconfig changes were made.

4. **comment-only: `packages/claude/README.md` has a long line.**
   - The sentence "An empty post-prune catalog is a hard error, never a silent pass." now sits on the same line as the end of the new sentence and runs past 100 columns.
   - Markdown style asks for 80–100 columns and one sentence per line. Move that sentence to its own line.
   - [rule: AGENTS.md § Markdown style]

No must-fix or should-fix items.

Self-improvement: add a standing packager check that a `major` changeset on a `private: true` or 0.x package is deliberate and matches the repo convention.
<sub><!--garden-provenance-section-->model <code>claude-opus-5-5</code> · harness <code>claude</code> · provider <code>anthropic</code></sub>
</details>

<details>
<summary><b>archivist</b> — approve</summary>
Verdict: approve — no findings requiring action. (Full seat prose elided to fit GitHub's 65,536-character review limit.)
<sub><!--garden-provenance-section-->model <code>claude-opus-5-5</code> · harness <code>claude</code> · provider <code>anthropic</code></sub>
</details>

<details>
<summary><b>prover</b> — approve</summary>
Verdict: approve — no findings requiring action. (Full seat prose elided to fit GitHub's 65,536-character review limit.)
<sub><!--garden-provenance-section-->model <code>claude-opus-5-5</code> · harness <code>claude</code> · provider <code>anthropic</code></sub>
</details>

<details>
<summary><b>curator</b> — comment-only</summary>

**Verdict:** comment-only

**Findings**

1. **comment-only — bump level is consistent.** `.changeset/agent-mcp-stdio-confined-catalog.md` marks `@endo/agent-mcp-stdio` as `major`. That fits the change: `startGuestBroker`'s default served set narrows from the full catalog to the allow-list. Its sole in-repo consumer, `packages/claude/src/confined-turn.js:185`, wants exactly that narrowing. The package is `0.1.0` and `private`, and sibling changesets such as `add-endo-claude.md` also use `major` for first-increment packages, so the level matches precedent. [rule: skills/changeset-discipline/SKILL.md]

2. **comment-only — default-versus-override asymmetry in `allowedToolNames`.** `src/broker.js:105` defaults `allowedToolNames` to `confinedToolNames`, and the option replaces the default rather than intersecting with it. The README and changeset say so plainly, which is good. The exported `selectConfinedTools(tools, allowedNames = confinedToolNames)` repeats that same default (`src/confined.js:88`). Because the broker always passes a value, the second default is redundant. Keeping it is harmless and gives a standalone caller the same safe default. The name `selectConfinedTools` becomes slightly misleading once a caller passes a widened list that serves `evaluate` again. That is acceptable, since the docs state the replace semantics. [proposed-rule: an exported helper's default should have one owner, with the other call site passing it explicitly.]

3. **comment-only — new public surface.** `index.js:18` adds two exports, `confinedToolNames` and `selectConfinedTools`. Both are hardened and covered by `test/exports.test.js`. `confined.js` is `.js`, and the types come from JSDoc. `types-index.types.d.ts` is `export * from './index.js'`, so no `.d.ts` definition is needed. The package has no `src/types.ts` entry to update for them. This follows the `types-index` convention.

4. **comment-only — sibling-surface check.** `@endo/claude`'s pinned catalog and `--allowedTools` prune (`packages/claude/src/confined-turn.js`) already withhold code-eval names. The new broker-level allow-list is a second layer over the same concern, not a competing route. Both docs say so: the `confined.js` header notes the belt is no longer the only thing withholding them, and the claude README is updated. The two lists could drift, since the eval-name list is maintained in each package. If the claude package ever needs the same names, it should import `confinedToolNames` rather than redeclare them. I found no redundancy or composition problem. [proposed-rule: when two packages withhold the same tool names, one owns the list and the other imports it.]

5. **comment-only — `@endo/claude` has no changeset.** `README.md` there changes its documented behavior, and `confined-turn.js` is unchanged, so no bump is needed. The behavior shift lands in `agent-mcp-stdio`, and the `claude` package consumes it as a workspace dependency. That is acceptable, because no `@endo/claude` surface changed.

No must-fix items.

Self-improvement: no curator-lens gap found. A probe that flags a documented allow-list duplicated across sibling packages could help (finding 4).
<sub><!--garden-provenance-section-->model <code>claude-opus-5-5</code> · harness <code>claude</code> · provider <code>anthropic</code></sub>
</details>

<details>
<summary><b>migrator</b> — comment-only</summary>

**Verdict:** comment-only

**Findings**

1. **should-fix, `.changeset/agent-mcp-stdio-confined-catalog.md` (bump level and package scope)**
   - `major` is the correct level for `@endo/agent-mcp-stdio`. `startGuestBroker`'s default catalog shrinks. `evaluate`, `define` and the identifier and locator tools were served before and are now refused with `tool-not-permitted`.
   - The package is at `0.1.0` and its own earlier changeset (`agent-tools-mcp-adapter.md`) also uses `major`, so the repo's convention is consistent.
   - The in-repo consumer is `packages/claude/src/confined-turn.js:185`, which calls `startGuestBroker` without `tools` or `allowedToolNames`. It inherits the narrower catalog with no source change. That is intended, and the added `confined-turn.test.js` assertions cover it.
   - `@endo/claude` ships behavior changes: its `init.tools` report now omits the withheld names. It also gets README edits, so it has no changeset entry of its own. The repo's own changesets, for example `endo-claude-confined-turn.md` and `add-endo-claude.md`, record `@endo/claude` as `major`, and `@endo/claude` is still at `0.0.0`. Consider adding a short `'@endo/claude': patch` entry (or `minor`) naming the broker pruning. The alternative is to state in the changeset that the cascade is intentionally omitted.
   - [rule: skills/changeset-discipline/SKILL.md]

2. **comment-only, `startGuestBroker` `allowedToolNames` semantics**
   - The override replaces the default allow-list and is not intersected with it. A caller that passes a custom list can re-serve `evaluate`, `define` and the rest. The changeset and README state this explicitly, so it is a documented contract, not a silent one.
   - It is a footgun for later callers, but not a migration defect. `claude`'s `--allowedTools` pruning remains the second belt.

3. **comment-only, allow-list drift protection**
   - The allow-list is an allow-list by design. A tool added later to `makeAgentTools()` is withheld from confined callers until it is named in `confinedToolNames`.
   - `confined.test.js` ("every declared tool is either confined or withheld") forces an explicit decision for each new tool. This is good forward-compatibility hygiene.

4. **comment-only, new public exports**
   - `confinedToolNames` and `selectConfinedTools` are added to the package entry, and `exports.test.js` is updated. The addition is purely additive and needs no further bump.

5. **comment-only, `packages/claude/README.md` formatting**
   - The sentence "An empty post-prune catalog is a hard error…" now runs past 100 columns.
   - It also is not on its own line, which the markdown style rule requires (one sentence per line, wrapped at 80 to 100 columns).

No peer-dependency cascade is needed. `@endo/claude` already depends on `@endo/agent-mcp-stdio` via `workspace:^`. No other workspace package imports `startGuestBroker`. `agent-tools/src/adapters/mcp.js` only mentions the package name.

Self-improvement: none for this review.
<sub><!--garden-provenance-section-->model <code>claude-opus-5-5</code> · harness <code>claude</code> · provider <code>anthropic</code></sub>
</details>

<details>
<summary><b>locksmith</b> — approve</summary>
Verdict: approve — no findings requiring action. (Full seat prose elided to fit GitHub's 65,536-character review limit.)
<sub><!--garden-provenance-section-->model <code>claude-opus-5-5</code> · harness <code>claude</code> · provider <code>anthropic</code></sub>
</details>

<details>
<summary><b>warden</b> — approve</summary>
Verdict: approve — no findings requiring action. (Full seat prose elided to fit GitHub's 65,536-character review limit.)
<sub><!--garden-provenance-section-->model <code>claude-opus-5-5</code> · harness <code>claude</code> · provider <code>anthropic</code></sub>
</details>

<details>
<summary><b>saboteur</b> — approve</summary>
Verdict: approve — no findings requiring action. (Full seat prose elided to fit GitHub's 65,536-character review limit.)
<sub><!--garden-provenance-section-->model <code>claude-opus-5-5</code> · harness <code>claude</code> · provider <code>anthropic</code></sub>
</details>

<details>
<summary><b>breaker</b> — request-changes</summary>

**Verdict: request-changes**

The broker-side pruning holds up. `selectConfinedTools` copies the allow-list into a `Set` before anything listens, so mutating the caller's array afterwards changes nothing. A string, `null`, or empty `allowedToolNames` gives an empty catalog, and `makeGuestMcpServer` then refuses to start ("no tools"). `callTool` refuses any name it can't find with `Object.hasOwn(catalog.byName, …)` (`packages/agent-tools/src/adapters/mcp.js:423`). The "classified exactly once" test catches a newly added tool that nobody classified. The finding below is about what tools that are still served leak.

**Findings**

1. **should-fix: tools that are still served leak the identifiers and formula locators this PR says it withholds.**
   - **Claimed invariant:** `src/confined.js:19-26` and the package README say identifiers and formula locators are withheld. That list includes read-only lookups (`identify`, `listIdentifiers`, `listLocators`, `reverseLocate`).
   - **Leak 1:** `listMessages` and `followMessages` (served) return each message's `from`/`to`/`ids`/`promiseId` as formula locators (`packages/daemon/src/mail.js:268-281`).
   - **Leak 2:** `followNameChanges` followed by `readFollower` yields `{ add, value: IdRecord }`, which carries the formula number (`packages/daemon/src/pet-sitter.js:77`).
   - **Effect:** the confined `claude` can read every locator and identifier that `listLocators` would have shown it.
   - **Severity:** turning one back into authority still needs `storeLocator` or `accept`, which are withheld. So this is not escalation, but the documented invariant is false.
   - **Fix:** either narrow the claim to "tools that *consume* a designation", or scrub those fields from served results. Add a test that runs `listMessages` against a fake message carrying `ids` and asserts that nothing locator-shaped comes back.
   - [proposed-rule: an allow-list that withholds a capability on disclosure grounds must also audit the served tools' *results* for the same data, not only the tool names]

2. **comment-only: the claim that content locators "carry no authority" is broader than the code supports** (`src/confined.js:28`).
   - `loadContent` sends the daemon to fetch from the source hints inside a locator the attacker writes (`packages/daemon/src/manager.js:6670-6676`).
   - That gives the confined side a way to make the daemon fetch over any registered data plane, which is a weak egress capability.
   - The registry bounds which planes it can reach, so this is mitigated. The comment should still say "no *designation* authority" instead.
   - [proposed-rule: a "carries no authority" comment must name which authority it means, and say whether the daemon does I/O on the tool's behalf]

3. **comment-only, mitigated / out of scope.**
   - `allowedToolNames` replaces the default list instead of intersecting with it, so a caller can serve `evaluate` again. This is documented and the option is in the caller's own trust domain, so no finding.
   - `help(methodName)` can describe withheld methods. This is disclosure only, with no way to call them.
   - Sibling check: the served set is pruned in exactly two places, the validating `makeGuestMcpServer` and the per-session one. Both use `served`, so they agree and there is no finding.

Self-improvement: when a module withholds tools by name, a breaker pass should grep what the served tools *return* (externalize/locator/`IdRecord` shapes) for the withheld data, as well as checking the tool names.
<sub><!--garden-provenance-section-->model <code>claude-opus-5-5</code> · harness <code>claude</code> · provider <code>anthropic</code></sub>
</details>

<details>
<summary><b>purist</b> — comment-only</summary>

I've read the diff and checked the surrounding code. Here is the purist block.

**Verdict:** comment-only

The change is a sound ocap move. A fixed allow-list replaces trusting the client, so a tool added to the catalog later stays withheld until someone names it. Every session is built over the same hardened `served` selection, so the list and the call dispatch can't disagree. Passability is fine: `confinedToolNames` is hardened and `served` is hardened before it reaches the catalog. There are no blocking findings.

**Findings**

1. **should-fix: `allowedToolNames` can widen the "confined" broker as well as narrow it.**
   - `packages/agent-mcp-stdio/src/broker.js:105`: the option replaces the default rather than intersecting with it. Passing `allowedToolNames: ['evaluate', …]` serves code evaluation again from a function the README now calls the confined boundary.
   - With this option the broker is confined only by convention, not by construction, which is weaker than the name promises.
   - The test title `test/broker.test.js` "an explicit allow-list narrows the served catalog further" describes the intersection semantics the code doesn't have.
   - Fix: either intersect with `confinedToolNames`, so the option can only narrow, or keep replace semantics, name the option for what it does (for example `servedToolNames`) and retitle the test. [proposed-rule: an option on an authority-attenuating constructor may narrow its default attenuation but not widen it, unless the option name says it widens.]

2. **should-fix: the name `selectConfinedTools` doesn't match what the function does.**
   - `packages/agent-mcp-stdio/src/confined.js:88`: it filters by *any* allow-list. Nothing about it is specific to the confined list except the default argument.
   - It's now public API (`index.js:18`) under a name that suggests a guarantee its second parameter can override.
   - Something like `selectToolsByName` describes the behavior, with the confined list remaining only the default. [rule: roles/jurors/purist/AGENT.md § Minimum viable abstraction]

3. **comment-only: the client-side tool list and the broker's served list are inconsistent.**
   - `packages/agent-mcp-stdio/src/config.js:18`: `renderGuestAllowedTools` still defaults to the full `makeAgentTools()` list.
   - `packages/claude/src/tool-permissions.js:63`: `CODE_EVAL_NAMES` still holds a separate deny-list (`evaluate`, `eval`, `define`).
   - So there are now three definitions of "what the confined side may see": the broker's allow-list, the config's full list, and claude's code-evaluation deny-list. Deriving the first two from `confinedToolNames`, or noting why they differ, keeps them one family. [rule: roles/jurors/purist/AGENT.md § Family-consistency]

4. **comment-only: the withheld set is written out by hand three times.**
   - The copies are in the `confined.js` header comment, `README.md:45-49`, and `test/confined.test.js:10`.
   - Only the test copy is checked against the code. The comment and README copies will drift silently the next time the catalog changes.
   - Better to point the prose at the test's list than to repeat it.

5. **comment-only: the single-tenant server still serves the full catalog.**
   - `src/server.js:176` serves `evaluate`, `define` and the identifier tools.
   - The README says this is deliberate, but the reason given for withholding identifiers (turning a designation in the prompt into authority) applies to any LLM client of that server too.
   - Worth one sentence on whether endo-but-for-bots#1404 covers that path.

Self-improvement: no change to the brief this time. The "option widens an attenuator's default" pattern in finding 1 may be worth adding as an inquiry axis if it comes up again.
<sub><!--garden-provenance-section-->model <code>claude-opus-5-5</code> · harness <code>claude</code> · provider <code>anthropic</code></sub>
</details>

<details>
<summary><b>spec-keeper</b> — approve</summary>
Verdict: approve — no findings requiring action. (Full seat prose elided to fit GitHub's 65,536-character review limit.)
<sub><!--garden-provenance-section-->model <code>claude-opus-5-5</code> · harness <code>claude</code> · provider <code>anthropic</code></sub>
</details>

<details>
<summary><b>wire-watcher</b> — approve</summary>
Verdict: approve — no findings requiring action. (Full seat prose elided to fit GitHub's 65,536-character review limit.)
<sub><!--garden-provenance-section-->model <code>claude-opus-5-5</code> · harness <code>claude</code> · provider <code>anthropic</code></sub>
</details>

<details>
<summary><b>engine-realist</b> — approve</summary>
Verdict: approve — no findings requiring action. (Full seat prose elided to fit GitHub's 65,536-character review limit.)
<sub><!--garden-provenance-section-->model <code>claude-opus-5-5</code> · harness <code>claude</code> · provider <code>anthropic</code></sub>
</details>

<details>
<summary><b>integrator</b> — request-changes</summary>

**Verdict:** request-changes

**Findings**

1. **must-fix: the PR description contradicts the head on two points it states as fact.** [rule: skills/pr-formation/SKILL.md; roles/jurors/integrator/AGENT.md § Merge-commit readability]
   - *Change* bullet 3 says "A new `allowedToolNames` option narrows the set further." That is wrong at the head. `src/broker.js:88-91`, the README (`packages/agent-mcp-stdio/README.md:50-52`) and the changeset all say the option *replaces* the allow-list rather than intersecting with it, so it can widen the served set as well.
   - *Documentation Considerations* says "`minor` on the private `@endo/agent-mcp-stdio`", but `.changeset/agent-mcp-stdio-confined-catalog.md:2` is `major`.
   - The description becomes the merge-commit message, so a future reader would get both the semantics and the bump level wrong. Fix it before the gauntlet proceeds: "Please refresh the title and description consistent with standing instructions."
   - The description also still lists file paths (`packages/agent-mcp-stdio/src/confined.js` (new) …), which works as a per-file pointer list. Describe the behavior instead.

2. **should-fix: commit grouping. The round-1 fix-up commit should be folded into the feature commit.** [rule: roles/jurors/integrator/AGENT.md § Commit grouping; overlaps packager]
   - `526964f49` ("Address garden panel round 1: changeset-auditor… archivist…") puts review-process metadata into history.
   - It also leaves `32f76e466`'s body saying "allowedToolNames narrows the set further", which the next commit contradicts.
   - Reset and redistribute into one `feat(agent-mcp-stdio)!:` commit, since the changeset declares a breaking change. Its body should state the override semantics. If the docs read better on their own, a separate `docs(...)` commit is fine.
   - Under conventional commits a `major` bump calls for the `!` marker on the commit and on the PR title.

3. **comment-only: the name `selectConfinedTools` no longer matches what the option allows.**
   - The function takes any `allowedNames`. Under override semantics a caller can pass `['evaluate']` and get a "confined" selection that serves code evaluation.
   - Either rename it to a neutral selector (e.g. `selectTools`) and keep "confined" for the default constant alone, or make the option an intersection so the "confined" name stays true. Narrow-only fits the PR's *Security Considerations* framing ("tightens the confinement boundary") better.
   - [proposed-rule: an option on a confinement boundary should be narrow-only unless the PR justifies widening.]

4. **comment-only: there are now two lists for the same concept.**
   - `@endo/claude`'s `CODE_EVAL_NAMES` deny-list (`packages/claude/src/tool-permissions.js:63`, which also names `eval`) and the new allow-list in `@endo/agent-mcp-stdio` both encode "withheld from confined turns".
   - The PR presents them as independent belt and boundary, which is coherent. It would still help for the claude README or the `confined.js` header to say which list is canonical and that the two are not kept in sync.

5. **Related-design reconciliation: OK.**
   - The governing design `designs/endo-guest-stdio-mcp.md` (shape 1) is cited.
   - The related PR #1404 is open, draft and has no review decision, so no changes-requested direction is outstanding.
   - The body explicitly reconciles the two landing orders: the classification test does not require withheld names to still be declared. This is fine as it stands.

6. **Rename sweep / concept namespace / diagrams: none of these come up.** The PR renames nothing, adds no diagrams and touches no dependency edges.

Self-improvement: when a fix-up commit changes semantics (here, narrow → override), the integrator should diff the PR body and the earlier commit bodies against the new wording. Stale prose in both places was the main integration defect in this PR.
<sub><!--garden-provenance-section-->model <code>claude-opus-5-5</code> · harness <code>claude</code> · provider <code>anthropic</code></sub>
</details>

<details>
<summary><b>duality-auditor</b> — comment-only</summary>

**Verdict:** comment-only

I found no must-fix or should-fix pair problems. I checked the endpoints below and found one naming asymmetry worth a comment.

**Pair inventory**

- `confinedToolNames` and `selectConfinedTools` (`packages/agent-mcp-stdio/src/confined.js`) are a data/filter pair, not an inverse pair. `selectConfinedTools` takes `allowedNames` defaulting to `confinedToolNames`. The names share the subject "confined" and read coherently.
- `withheldToolNames` (`test/confined.test.js`) is the complement of `confinedToolNames`. The test asserts they partition `makeAgentTools()`, and the pairing is explicit in the test title and comment. The test-local name is fine.
- The existing pairs `locate`/`reverseLocate`, `identify`/`reverseIdentify`, `locateContent`/`reverseLocateContent` and `invite`/`accept` are untouched. The allow-list and the test's withheld list treat each pair consistently: the confined list holds only the Content pair, and the withheld list holds the others. I found no split pair.
- `evaluate` and `define` are withheld together.

**Findings**

1. **Comment-only: one concept goes by two subjects.**
   - The exported default is `confinedToolNames` (`src/confined.js`).
   - The option that replaces it is `allowedToolNames` (`src/broker.js`, `startGuestBroker`).
   - The option is `allowedToolNames = confinedToolNames`, and the changeset and README say it replaces the default. It is the same list under two names.
   - `selectConfinedTools(tools, allowedNames)` takes a parameter named `allowedNames`. With an override, the function no longer selects "confined" tools. It selects allowed ones.
   - The repo already uses "allowed" for a related notion: `renderGuestAllowedTools` in `src/config.js`, which renders `--allowedTools`.
   - Suggested spelling: keep `confinedToolNames` as the default value, since it names the confined broker's policy. Name the filter `selectAllowedTools`, or rename the option to `confinedToolNames`. That makes the "default value / override / filter" triple share one subject. Because `confinedToolNames` and `selectConfinedTools` are newly exported in this PR, renaming now costs no migration. [rule: roles/jurors/duality-auditor/AGENT.md]

2. **Comment-only: a test title contradicts the documented semantics.**
   - The title `an explicit allow-list narrows the served catalog further` (`test/broker.test.js`) implies narrowing only.
   - The changeset and README state the option replaces the default and can also widen it. A test with a withheld name in `allowedToolNames` would back that up.
   - Suggested title: `an explicit allow-list replaces the default`. [rule: roles/jurors/duality-auditor/AGENT.md]

Self-improvement: I should add a check to the brief for default-value, override-option and filter-function triples, where one concept ends up under two subjects.
<sub><!--garden-provenance-section-->model <code>claude-opus-5-5</code> · harness <code>claude</code> · provider <code>anthropic</code></sub>
</details>

<details>
<summary><b>benchmarker</b> — approve</summary>
Verdict: approve — no findings requiring action. (Full seat prose elided to fit GitHub's 65,536-character review limit.)
<sub><!--garden-provenance-section-->model <code>claude-opus-5-5</code> · harness <code>claude</code> · provider <code>anthropic</code></sub>
</details>

<details>
<summary><b>changeset-auditor</b> — request-changes</summary>

**Verdict:** request-changes (summary-fix)

**Findings**

1. **Bump level is wrong for an unpublished package.** `.changeset/agent-mcp-stdio-confined-catalog.md` declares `'@endo/agent-mcp-stdio': major`.
   - `packages/agent-mcp-stdio/package.json` is still `0.1.0` and `private: true`, so it has never been published.
   - The package's initial-release changeset `.changeset/agent-tools-mcp-adapter.md` already lists it as `major`.
   - The first release is therefore already pending as `1.0.0`.
   - "Breaking: `startGuestBroker` now serves only…" describes a break against a surface no consumer has ever received. Changesets would also fold this `major` into the same 1.0.0 release, so the body would read as a migration note for a version that doesn't exist.
   - Fix: either fold this behavior into the existing initial-release changeset, or make this one a `minor` or `patch` with the "Breaking:" framing dropped. The brief's `major` rule applies to a package's first release, which is already covered once.
   - [rule: skills/changeset-discipline/SKILL.md § Bump level / § New-package initial release]

2. **Same-PR coherence is otherwise fine.**
   - The package set matches. `@endo/claude` appears only in a README and a test change, so omitting it from the changeset is correct.
   - The body names `startGuestBroker`, `confinedToolNames`, `allowedToolNames` and `selectConfinedTools`, all of which match the diff. `index.js` exports the two new names.
   - Style is sentence-per-line with no process commentary. The body does run long for a changeset. Optional tightening: drop the `error.data.reason` detail, which belongs in the README.
   - [rule: skills/changeset-discipline/SKILL.md § Sentence-per-line]

3. **Stale-wording check.** Nothing in the body contradicts the diff. The "not intersected with it" statement matches the `allowedToolNames` JSDoc and the `broker.js` default-replacement behavior.

Disposition: summary-fix. Finding 1 is the only must-address item, and it would not publish a wrong semver bump because the package is already majoring.
<sub><!--garden-provenance-section-->model <code>claude-opus-5-5</code> · harness <code>claude</code> · provider <code>anthropic</code></sub>
</details>

<details>
<summary><b>surfacer</b> — comment-only</summary>

Verdict: comment-only

The four surfaces agree on the new exports. `confinedToolNames` and `selectConfinedTools` appear in all of the following:
- `index.js` (`packages/agent-mcp-stdio/index.js:18`).
- The `exports.test.js` allow-list, which pins the exact surface.
- The types shim, `types-index.types.d.ts`, which re-exports `./index.js`. It needed no edit.
- The README, which names `confinedToolNames` and the `allowedToolNames` option, and says "the allow-list and `selectConfinedTools` are exported".

`package.json` `exports` is unchanged. It still has a single `.` entry plus `./package.json`, and `src/confined.js` is not exposed as a subpath. The `files` globs are unaffected.

Findings:

1. **[follow-up] The README says the allow-list is in `src/confined.js` but not that it is exported.**
   - The README cites the allow-list as `confinedToolNames`, in `src/confined.js`. That points a reader at an internal file, and the package's only public subpath is `.`.
   - It never names `selectConfinedTools`, the second new export. The changeset does name both.
   - Suggested fix: say once in the README that both are importable from `@endo/agent-mcp-stdio`, and drop or soften the `src/` path.
   - [proposed-rule: every identifier added to `index.js` is named in the package README, and README source-file pointers do not stand in for the public import path.]

2. **[follow-up] `startGuestBroker`'s `allowedToolNames` option is documented only in JSDoc and prose.**
   - The README's "Pass `allowedToolNames` to replace it" is accurate. Because the shipped `.d.ts` is derived from the JSDoc, the types match the README.
   - I found no incoherence here. This is a note that the "not intersected" semantics is a deliberate widening escape hatch on a public option, so the curator may want to rule on whether it belongs in the public surface. That is outside this seat.

3. **[comment] `packages/claude/README.md` ends the edited paragraph in an overlong line.**
   - The paragraph ends "…`init` tool list `claude` reports) and are refused if called by name. An empty post-prune catalog is a hard error…", which runs past 100 columns and puts two sentences on one line.
   - This breaks the Markdown style rule in `AGENTS.md` (sentence per line, wrap at 80–100 columns).
   - It is a README presentation fix, not a surface mismatch.
   - [rule: AGENTS.md § Markdown style]

Not flagged:
- The `major` changeset on a `private: true` package is a changeset-auditor matter.
- No thunk filtering applies: `index.js` re-exports whole symbols from `confined.js`.
<sub><!--garden-provenance-section-->model <code>claude-opus-5-5</code> · harness <code>claude</code> · provider <code>anthropic</code></sub>
</details>

<details>
<summary><b>scribe</b> — comment-only</summary>

**Verdict:** comment-only

**Findings**

1. **No maintainer note-this asks found, so nothing is open there.** The PR has no human inline review comments and no top-level comments. The only review is the bot panel's round-1 COMMENT (`5378932545`, must-fix). I found no "note this", "record this", "add to CLAUDE.md" or "future builders" ask to close. [rule: skills/panel-review/SKILL.md § Cite-or-propose]

2. **Knowledge capture in the diff is adequate.** The diff adds `.changeset/agent-mcp-stdio-confined-catalog.md`. It updates `packages/agent-mcp-stdio/README.md` and `packages/claude/README.md` with the new confined-catalog behavior and the exact refusal wording. The behavior is documented where future builders would look, and no CLAUDE.md or AGENTS.md edit is needed. [rule: skills/panel-review/SKILL.md § Cite-or-propose]

3. **Completion-summary closure is not yet due.** The only review is the panel's own round-1 verdict, and no responding push has followed it. When the fixer pushes to address the must-fix items, it should post a top-level summary comment. That comment should name the head SHA, what changed, anything declined and why, and the verification status. [rule: skills/pr-completion-summary-comment/SKILL.md]

I made no check of the journal for `to: gardener` messages, because no ask exists to close.
<sub><!--garden-provenance-section-->model <code>claude-opus-5-5</code> · harness <code>claude</code> · provider <code>anthropic</code></sub>
</details>

<details>
<summary><b>pruner</b> — request-changes</summary>

Verdict: **request-changes**

**Finding: Duplicated confinement documentation in `src/confined.js`**

In `packages/agent-mcp-stdio/src/confined.js` (lines 7–20 and 22–29), the module-level comment restates information already documented in `packages/agent-mcp-stdio/README.md`:

- Lines 7–11 repeat the README's explanation of how withheld names are absent from `tools/list` and refused at `tools/call` with specific error codes.
- Lines 15–20 re-explain the allow-list vs. deny-list semantics.
- Lines 22–29 duplicate the list of withheld tools and their rationale.

**Recommended action:** Reduce the module comment to a concise summary (design reference + key implementation notes). Keep: the design doc reference, the note about `@endo/claude`'s separate `--allowedTools` pruning (implementation context the README doesn't detail), and the note that content locators carry no authority. Remove the sections narrating what the broker does and the documented behavior — developers reading this code will already have read the README.

**Citation:** [proposed-rule: Module-level comments should not duplicate public documentation; keep only design rationale and implementation-specific context.]
<sub><!--garden-provenance-section-->model <code>claude-opus-5-5</code> · harness <code>claude</code> · provider <code>anthropic</code></sub>
</details>

<details>
<summary><b>gateway</b> — approve</summary>
Verdict: approve — no findings requiring action. (Full seat prose elided to fit GitHub's 65,536-character review limit.)
<sub><!--garden-provenance-section-->model <code>claude-opus-5-5</code> · harness <code>claude</code> · provider <code>anthropic</code></sub>
</details>

<details>
<summary><b>corner-prober</b> — comment-only</summary>

Verdict: comment-only

Enumerated corners (covered / missing):

- **Empty allow-list `[]`**: covered indirectly, since `['noSuchTool']` fails closed with `/no tools/`. The literal `[]` and a missing name are the same path, so the fail-closed case is closed.
- **Allow-list naming a tool that exists once**: covered.
- **Duplicate names in `allowedToolNames`** (`['list','list']`): missing. A `Set` dedups the names, so this should be harmless, but nothing pins it. The served `tools/list` must show `list` exactly once.
- **Order**: `selectConfinedTools` keeps declaration order, not allow-list order, and that is tested for `['list','help']` → `['help','list']`. Covered.
- **`allowedToolNames` is a non-array iterable** (a `Set`, a string): missing. The JSDoc says `ReadonlyArray`. A string `'list'` would become `Set{'l','i','s','t'}` and silently fail closed, but a string like `'help'` would do the same. This is safe, so it is low priority.
- **Names that collide with `Object.prototype`** (`__proto__`, `constructor`, `toString`) in `allowedToolNames` or in the tool-call `name`: missing. `Set.has` is not prototype-sensitive, so selection is safe. The dispatch check (`name-scope`) in `server.js` was not touched by this PR, and no test calls the broker with `tools/call` `{name:'constructor'}` or `{name:'__proto__'}` to confirm they get `name-scope` rather than a TypeError or a hit on the prototype.
- **Case and whitespace variants** (`Evaluate`, `evaluate `, a zero-width-joiner suffix): missing. The refusal test covers only exact withheld spellings. Add one case with `'Evaluate'` and one with `'evaluate\u200b'` expecting `name-scope`, pinning exact-match semantics.
- **Override widens** (`allowedToolNames: ['evaluate']`): missing. The changeset and README document this explicitly as "serves it again", but no test pins it. The documented contract is untested, and a later "intersect for safety" refactor would break it silently. Add one test.
- **Allow-list mutated after the call**: the frozen-list test covers the default. A caller-supplied array is copied into the `Set` per call to `selectConfinedTools`, but the broker calls it once and then hardens the result, so this is closed.
- **Withheld-set coverage in the live refusal test**: only 3 of the 13 withheld names (`define`, `evaluate`, `storeIdentifier`) are called, and `locate`, `invite`, and `accept` are only checked absent from the list. The `name-scope` path is name-agnostic, so the risk is low.
- **Concurrent arrival**: `Promise.all` fires the three refusals concurrently. Covered.
- **Sessions**: each connection builds its own catalog over `served`. A second concurrent session was not checked for a stale or divergent catalog. Existing tests probably cover multi-session, so this is a minor gap.

Findings:

1. **Documented widening contract is unpinned** — add a test where `allowedToolNames: ['evaluate','list']` serves `evaluate`. [rule: skills/adversarial-tests/SKILL.md § Boundary sweep] Disposition: summary-fix.
2. **Name-spelling and prototype-key refusals untested** — add `tools/call` with `constructor`, `__proto__`, `Evaluate`, and `evaluate\u200b`, each expecting `name-scope`. [rule: skills/adversarial-tests/SKILL.md § Boundary sweep] Disposition: summary-fix.
3. **Duplicate entries in the allow-list** — assert `['list','list']` yields a single `list` in `tools/list`. [proposed-rule: when a PR accepts a name list, test the duplicate, empty, and non-string-element corners] Disposition: summary-fix.
4. **Non-string elements** (`[undefined, 1, null]`) in `allowedToolNames` are silently ignored, and the all-ignored case reaches the `no tools` error. The tests exercise only the unknown-string version of this. Disposition: summary-fix, optional.

No must-fix-loop items. The core selection logic is correct at every boundary I walked, and the classification test (every declared tool is either confined or withheld) is a good guard against drift.
<sub><!--garden-provenance-section-->model <code>claude-opus-5-5</code> · harness <code>claude</code> · provider <code>anthropic</code></sub>
</details>

<details>
<summary><b>fast-checker</b> — comment-only</summary>

**Verdict:** comment-only

The package already depends on `@fast-check/ava` and uses it in `test/agent-interface.test.js`. Property tests would need no new infrastructure. The `selectConfinedTools` contract is universally quantified and tested only with one fixed example, so the findings below are test additions.

**Findings**

1. **`selectConfinedTools` is tested with two hand-picked inputs** (`test/confined.test.js`). The function has algebraic contracts, and the example test misses most of them: duplicates, empty inputs, order, and the claim in the README and changeset that the allow-list option is not intersected. Disposition: `summary-fix`. [proposed-rule: a function with a universally-quantified contract gets a `fc.assert(fc.property(...))` alongside its example test.]
   Suggested property, using `@fast-check/ava` as `agent-interface.test.js` does:
   ```js
   const names = fc.array(fc.string({ maxLength: 8 }), { maxLength: 20 });
   fc.assert(fc.property(names, names, (declared, allowed) => {
     const tools = declared.map(name => ({ name }));
     const out = selectConfinedTools(tools, allowed);
     const set = new Set(allowed);
     return (
       out.every(({ name }) => set.has(name)) &&
       out.length === tools.filter(({ name }) => set.has(name)).length &&
       out.every(tool => tools.includes(tool))
     );
   }));
   ```
   This covers subset, completeness, identity preservation and declaration order. Duplicate declared names are not asserted unique, which matches the implementation. Add an idempotence check, `select(select(t, a), a)` deep-equals `select(t, a)`, in the same property.

2. **The "no tool reaches the confined side unless allowed" claim rests on a few spot checks** (`test/broker.test.js`). The test calls three withheld names, `define`, `evaluate` and `storeIdentifier`. The changeset and README claim every withheld name is refused with `name-scope`. Disposition: `summary-fix`. Generate the call name from `fc.constantFrom(...withheldToolNames)`. Alternatively, loop over all 13 withheld names, which is cheap because the set is finite and enumerable. Starting a broker per run is slow, so use a small `numRuns` or reuse one broker across runs. Moving `withheldToolNames` to a shared export would let the broker test reuse the list instead of keeping its own 8-name copy that can drift from `confined.test.js`.

3. **The classification test is already property-shaped and good.** "Every declared tool is either confined or withheld" is an exclusive-or check over the catalog, and it closes the "new tool silently withheld" gap. No change needed.

4. **No round-trip or equivalence pairs were introduced.** I have no further property proposals.

Self-improvement: when a PR adds a filter or selection helper to a package that already has fast-check, propose the subset, completeness and idempotence property by default.
<sub><!--garden-provenance-section-->model <code>claude-opus-5-5</code> · harness <code>claude</code> · provider <code>anthropic</code></sub>
</details>

<details>
<summary><b>releaser</b> — comment-only</summary>

**Verdict:** comment-only

The changeset is warranted, correctly aimed at the upgrading user, and addresses the one package whose public behavior changes. Two minor points remain.

**Findings**

1. **Major bump, justified.** [rule: skills/changeset-discipline/SKILL.md § When to add a changeset]
   - `startGuestBroker`'s default `tools/list` shrinks, and calls to withheld tools now fail.
   - A caller that relied on `evaluate`, `define`, or the locator tools through the broker must now pass `allowedToolNames`.
   - From the user's side this is breaking, so `major` is the right level. No bump change is needed. Disposition: none.

2. **Missing migration step in the changeset body.** [proposed-rule: a breaking changeset names the migration action, not only the new behavior] Disposition: `summary-fix`.
   - The body says an override exists, but the migration reads as incidental ("An `allowedToolNames` option overrides…").
   - Suggest one sentence up front, for example: "Migration: callers that need a withheld tool must now pass it in `allowedToolNames`."
   - The body already notes that the option replaces the default rather than intersecting with it, so it only needs to be framed as the upgrade step.

3. **`@endo/claude` has no changeset.** [rule: skills/changeset-discipline/SKILL.md] Disposition: `summary-fix`, only if that package is published.
   - `packages/claude/README.md` and `confined-turn.test.js` changed, but there is no runtime change in `packages/claude`.
   - If `runConfinedTurn` users now see a narrower `init` tool list, that follows from the `@endo/agent-mcp-stdio` bump. The README-only change doesn't justify a separate changeset.
   - Check whether `@endo/claude` depends on `agent-mcp-stdio` through `workspace:^`. If so, changesets will bump it automatically.

4. **Changeset prose.** The changeset is declarative and release-note shaped, with no narration of process. No change needed.
<sub><!--garden-provenance-section-->model <code>claude-opus-5-5</code> · harness <code>claude</code> · provider <code>anthropic</code></sub>
</details>

<details>
<summary><b>transplanter</b> — approve</summary>
Verdict: approve — no findings requiring action. (Full seat prose elided to fit GitHub's 65,536-character review limit.)
<sub><!--garden-provenance-section-->model <code>claude-opus-5-5</code> · harness <code>claude</code> · provider <code>anthropic</code></sub>
</details>

<details>
<summary><b>coverage-auditor</b> — comment-only</summary>

**Verdict:** comment-only

**Findings:**
- coverage of new lines could not be verified: no c8 coverage report at '/Users/dom/garden/scratch/project-wt-build-e-d7b6f6b8fcb1-ccb4f8c3/coverage/coverage-final.json' (run c8 with --all --reporter=json, or set GARDEN_COVERAGE_JSON); cannot verify new-line coverage — NOT assuming covered. Produce a c8 report (`c8 --all --reporter=json`) so new-line coverage can be checked, or confirm this package is intentionally outside coverage. This is surfaced, NOT treated as covered. [rule: skills/coverage-driven-testing/SKILL.md]
<sub><!--garden-provenance-section-->model <code>claude-opus-5-5</code> · harness <code>claude</code> · provider <code>anthropic</code></sub>
</details>

<details>
<summary><b>orthographer</b> — approve</summary>
Verdict: approve — no findings requiring action. (Full seat prose elided to fit GitHub's 65,536-character review limit.)
<sub><!--garden-provenance-section-->model <code>claude-opus-5-5</code> · harness <code>claude</code> · provider <code>anthropic</code></sub>
</details>

<details>
<summary><b>thesaurus</b> — approve</summary>
Verdict: approve — no findings requiring action. (Full seat prose elided to fit GitHub's 65,536-character review limit.)
<sub><!--garden-provenance-section-->model <code>claude-opus-5-5</code> · harness <code>claude</code> · provider <code>anthropic</code></sub>
</details>

<details>
<summary><b>procurer</b> — approve</summary>
Verdict: approve — no findings requiring action. (Full seat prose elided to fit GitHub's 65,536-character review limit.)
<sub><!--garden-provenance-section-->model <code>claude-opus-5-5</code> · harness <code>claude</code> · provider <code>anthropic</code></sub>
</details>

<details>
<summary><b>reexport-auditor</b> — approve</summary>
Verdict: approve — no findings requiring action. (Full seat prose elided to fit GitHub's 65,536-character review limit.)
<sub><!--garden-provenance-section-->model <code>claude-opus-5-5</code> · harness <code>claude</code> · provider <code>anthropic</code></sub>
</details>

<sub><!--garden-provenance-->model <code>claude-opus-5-5</code> · harness <code>claude</code> · provider <code>anthropic</code> · host <code>oros-studio-garden-ce242c49</code></sub>
----- END REVIEW -----
