---
role: gardener
requires: host=endolin-garden-ece02cb4
tier: mentor
dispatch: automatic
pr: https://github.com/endojs/endo-but-for-bots/pull/1389
fallback-tier: minion
---

# Post the panel round-2 review on endojs/endo-but-for-bots PR #1389

The gauntlet stage `endojs-endo-but-for-bots-pr1389-gauntlet-panel-2` ran the design panel (single-round) on head `55b47f7c5e` and got **must-fix**. It could not post the review: the bot PAT on `oros-studio-garden-ce242c49` gets `Resource not accessible by personal access token (addPullRequestReview)` on endojs. This job does that one step on a host whose PAT can write.

Steps:
1. Check the review is not already posted: `gh api repos/endojs/endo-but-for-bots/pulls/1389/reviews --jq '.[].body' | grep -c 'garden-panel-verdict: must-fix round=2'`. If it is ≥1, stop and report done.
2. Extract everything between the `=====BEGIN REVIEW BODY=====` and `=====END REVIEW BODY=====` lines below (exclusive) into a file, verbatim.
3. Post it: `GARDEN_ALLOW_BARE_ISSUE_REF=1 gh pr review 1389 -R endojs/endo-but-for-bots --comment --body-file <file>`. The override is correct: every bare `#N` in the body means an endojs/endo-but-for-bots PR (quoted from the design doc). Use `--comment`, not `--request-changes`: the PR is authored by the bot, which cannot request changes on its own PR, and round 1 used the same shape. The `<!-- garden-panel-verdict: must-fix round=2 -->` marker carries the verdict.
4. Do NOT fix, un-draft, or post any other gauntlet stage. Report the review URL.

=====BEGIN REVIEW BODY=====
## Panel review — round 2 (design panel, single-round)

**Disposition: must-fix** · head `55b47f7c5e` · base `7ff30afbce` (llm-7ff30af) · 9 seats, all ok

<!-- garden-panel-verdict: must-fix round=2 -->

<details>
<summary><b>critic</b> — comment-only</summary>

Verdict: comment-only

Findings:

1. **Should-fix: the child-compartment claim is asserted, not derived.** The design says a new `Compartment` builds its global from captured intrinsics, so a global added later is absent from children. That is why the reworked #774 test is renamed to "default: … does not see SturdyRef". The claim is plausible, but the design also labels it "an observed default, not a security property". It then rests the renamed test on it. The test would pin behavior the design itself says is not guaranteed, and it will break the moment layer 2 lands. Suggest marking the test as a temporary characterization, expected to flip in layer 2, or dropping it. [proposed-rule: a test must not pin a default the design disclaims as a non-guarantee]

2. **Should-fix: Layer 5 may not be buildable on the layer-1 contract.** The forward sketch admits that serializing a ref needs a side-table `WeakMap` in the minting CapTP, so the data lives twice. It also admits that only the minting CapTP can serialize the ref. Open question 7 (a ref minted by CapTP A and passed to CapTP B) is then the core of the layer-5 requirement, not a side issue. It decides whether the handler contract needs a data-yielding hook. Adding a hook after refs exist would be costly to retrofit. Either resolve question 7 before layer 1 freezes, or state that adding an optional hook later is compatible. [proposed-rule: a contract-freezing design must show its forward layers' needs fit the frozen surface]

3. **Should-fix: the `enliven` promise interacts with the "no thenable" rationale.** The design rejects the HandledPromise approach partly because a ref "must not be assimilated by `await`". The ref has no `then`, so that holds. But `SturdyRef.enliven` returns a plain promise, and a handler that returns a thenable will be silently assimilated. That is normal promise behavior, but the design should say so. The "each call runs the hook again" statement plus the absence of memoization also puts identity-of-the-enlivened-presence entirely on the handler. Layer 8 should not have to rediscover that.

4. **Comment-only: the constructor reads `handler.enliven` once, but the hook is called as `enliven.call(handler, ref)`.** Question 3 leans on stability against handler mutation. The `this` binding to a mutable handler still leaks mutation through the hook's own body. Question 4 (hardening the handler) is therefore coupled to question 3 and should be resolved together. Consider proposing that the constructor not harden the handler but document the coupling.

5. **Comment-only: unsafe global naming.** Layer 1 leaves `@endo/ocapn`'s `isSturdyRef` and `enlivenSturdyRef` in place with different semantics until layer 5. The static spelling mitigates this. It is still a documentation hazard for readers who see two `isSturdyRef` functions.

Strengths: the `instanceof` rejection with the forged-prototype rationale is correct. Dropping the pass-style dependency to avoid a layer inversion is the right call. The ordering constraint around `@endo/harden` and `lockdown` is well reasoned. Diagrams: none, so there is no ASCII-art issue. The rejected alternatives (HandledPromise, `E.enliven`) are treated fairly.

Self-improvement: check whether the "child compartments" claim was verified against `packages/ses` source. I did not, and it is worth a code-panel check.
<sub><!--garden-provenance-section-->model <code>claude-opus-5-5</code> · harness <code>claude</code> · provider <code>anthropic</code></sub>
</details>

<details>
<summary><b>skeptic</b> — request-changes</summary>

**Verdict:** request-changes

**Findings**

1. **should-fix: the "confers no authority" premise does not survive layer 2.** The "Child compartments" section drops #774's withholding because the global is no longer an amplifier.
   - That holds only while guests cannot mint refs a host will trust.
   - Once layer 2 propagates `SturdyRef`, a guest can call `new SturdyRef(evilHandler)`. The result passes `SturdyRef.isSturdyRef`, which layer 3 uses as its sole recognizer.
   - If a host or CapTP later auto-enlivens a ref it received, the call runs guest code in the host's turn with the host's ref as argument.
   - The design says a brand check proves origin. It proves only "made by some constructor". The design should say so and name which layer owns minter provenance.
   - [proposed-rule: a design that removes a confinement property must state the new forgery/provenance story for values crossing trust boundaries]

2. **should-fix: the pre-lockdown test row cannot be verified in layer 1.** It asserts "the constructor is frozen and matches SES's permit shape". No permit exists until layer 2, so there is no shape to match.
   - The real layer-1 claim is narrower: `lockdown()` does not throw and does not mutate or reject the extra global.
   - Also state what lockdown does to an unpermitted start-compartment global.
   - Reduce the claim to what a layer-1 build can actually test.

3. **should-fix: the compartment-visibility claim has no cited execution.** The design calls "a global added later is absent from child compartments" "an observed default", but cites no run or test.
   - It is also stated for the pre-lockdown-install case. A pre-lockdown global is not an intrinsic either, which the text concedes.
   - Either cite a real run (output or test name), or downgrade it to "believed, to be verified in the build".
   - [rule: panel-review verified-claim evidence discipline]

4. **should-fix: eval-twin convergence assumes compatible implementations.** Validity is a shallow shape check (a function with two statics).
   - Twins may differ in behavior, such as timing (Open question 1), `this` binding (Open question 2), or hook-read time (Open question 3).
   - The first definer silently dictates semantics to all later copies.
   - The design should add a version or contract marker, or say that semantic drift is accepted.

5. **should-fix: the handler is left mutable (Open question 4) and `this` is the handler.**
   - `enliven` is read once, but `enliven.call(handler, ref)` exposes every other handler property to later mutation. The read-once "stability" claim is partial.
   - Treat hardening as a decision. Hardening is likely the answer, because the hook captures authority.

6. **comment-only: Open question 7 is load-bearing for layer 5 and is left open.** The forward sketch's double-stored data (handler closure plus CapTP side table) assumes refs never travel between CapTPs. Before building layer 1, confirm that no extra handler affordance is needed. Retrofitting one after the contract ships will break the "handler-defined entirely" promise.

7. **comment-only: the "no cached settlement, hook runs each call" stance** has a failure-mode gap. The design says nothing about the hook's own concurrency, for example two simultaneous enlivens racing to open the same connection. The design could state that the handler owns idempotence.

Self-improvement: no new rules proposed beyond finding 1.
<sub><!--garden-provenance-section-->model <code>claude-opus-5-5</code> · harness <code>claude</code> · provider <code>anthropic</code></sub>
</details>

<details>
<summary><b>decomplector</b> — comment-only</summary>

**Verdict:** comment-only

The design keeps its concerns well separated. The shim does three things: construct, brand check, dispatch. Everything else goes to the layer that owns it: what a ref captures, how it is revived, revocation, which enlivened presence it is, and persistence. Several choices keep time and value apart: each `enliven` runs the hook fresh with nothing cached, the hook is read once at construction, and the ref carries no content and offers no equality. Rejecting sturdyref-as-HandledPromise is the right call for the same reason: a promise that settles once cannot model a ref that is revived many times.

**Ownership map (reconstructed and checked).** Durable state: none in the shim. The handler holds captured content, and layers 5–8 own persistence. Commit/discard: layers 5–8. Restart/replay: none in the shim, and revival is the handler's hook. Execution classification: the shim settles the promise (fulfilled if the hook returns, rejected if it throws); the handler decides what that outcome means. No layer claims a responsibility twice, with one small exception in the first finding. No inner type or API is named for an outer-layer lifecycle concept: `enliven` is a dispatch, and line 223 already says the shim owns no durable state despite the name "Sturdy".

**Findings**

1. **should-fix: the forward sketch treats "data lives twice" as forced, but it follows from the per-ref-closure style, not from the contract.** § Forward sketch (lines 241–246) says CapTP data lives both in the handler's closure and in a side table. The design's own provisional answer to Open question 2 is that the hook receives the ref "so one handler can serve many refs". Under that answer, a CapTP keeps one `WeakMap<ref, data>`, and its single shared handler reads that map to revive. The same map serves serialization, so the data lives once. The duplication comes from choosing to close over the data in a function instead of keeping it in a data table. Suggested fix: rewrite the paragraph so the shared-handler + single side-table form is the layer-5 sketch, and note that Open question 2's proposed answer is what makes it possible. That also turns Open question 7 into "may B read A's table?", which is a smaller question than "does the handler need a second hook?". [rule: roles/jurors/decomplector/AGENT.md § Operating norms (e), data > functions]

2. **comment-only: the "harden" cell in the ownership map disagrees with § Packaging.** The row "shim ↔ SES | SES: permit, harden, propagate" (line 220) gives hardening to SES. But lines 131–134 have the shim harden with `@endo/harden` whenever a harden is already present, and freeze otherwise. Suggest wording the cell "shim: freeze, or harden if one is already present; SES: harden at lockdown", so the mechanism and the policy each have one owner. [rule: skills/ownership-map/SKILL.md]

3. **comment-only: Open question 4 (harden the handler) is where handler stability gets decided, and Open question 3 only half answers it.** Reading the hook once at construction protects dispatch from a later swap of `handler.enliven`. It does not protect any other state the handler holds, which the hook reads through `this`. If `this` is kept (Open question 2's `enliven.call(handler, ref)`), cross-reference Open question 4 from Open question 3 so the two are decided together. [proposed-rule: when a design reads a callback once to make it immune to mutation, it states whether the callback's receiver is also frozen]

**Out of scope:** none.

Self-improvement: nothing to encode. The pre-pass lens applied cleanly to a design whose ownership map was already explicit.
<sub><!--garden-provenance-section-->model <code>claude-opus-5-5</code> · harness <code>claude</code> · provider <code>anthropic</code></sub>
</details>

<details>
<summary><b>ergonomist</b> — comment-only</summary>

Verdict: comment-only

I found no must-fix items. The surface is small and mostly coherent, and it follows the `Proxy` and `HandledPromise` precedents. The findings below are should-fix and comment-only.

Findings:

1. **should-fix: sync/async error split on `SturdyRef.enliven`.** A non-ref argument gives a rejected promise, while `new SturdyRef(badHandler)` throws synchronously. The design justifies this ("a send reports every failure through its promise"). It still leaves one caller-visible edge: `SturdyRef.enliven(undefined)` looks like a programmer error yet never throws at the call site. It relies on the caller awaiting. State in the surface block that an un-awaited enliven swallows a mistyped argument as an unhandled rejection. Or state that the rejection is a `TypeError` with a stable message, so tests and logs can recognize it. [proposed-rule: designs that give a promise-returning API a "wrong-type argument rejects" rule must name the rejection's error class.]

2. **should-fix: the bare `isSturdyRef` name is ambiguous.** The design accepts that `@endo/ocapn` exports a free `isSturdyRef` and `enlivenSturdyRef` with different semantics until layer 5. A user who auto-imports the wrong `isSturdyRef` gets a silent `false` on real refs, not an error. The design's mitigation is "always spell the shim's as statics", which is a convention rather than an affordance. Either rename the ocapn functions now (for example, to `isOcapnSturdyRefRecord`) or add a dev-time diagnostic. Otherwise mark this as a known trap in the `@endo/sturdyref` README, not just in this design. [proposed-rule: when two same-named predicates with different domains coexist, the design must give an in-band signal that separates them, not only prose.]

3. **comment-only: sibling spelling of `enliven`.** The design uses the handler hook `enliven(ref)` and the static `SturdyRef.enliven(ref)`. `Proxy` and `HandledPromise` do the same (trap name equals operation name), so this is consistent. The one wrinkle is `E.enliven` (Open question 6). If it lands, `E(ref).enliven()` would look like a remote method call. It would then collide with any remote object that has a real method named `enliven`. Prefer a name that cannot be mistaken for a method, or keep only the static.

4. **comment-only: mental-model naming of "enliven".** The verb is used consistently through the stack (hook, static, later layers), so this is not a coherence problem. A user coming from "resolve/revive" may not find it, which favors a one-line gloss ("revive into a live reference") in the package README. Discoverability from the entry point is otherwise fine: the three-line surface block is a good first read.

5. **comment-only: Open question 4 (hardening the handler) affects ergonomics as well as security.** If the constructor freezes the handler, handlers that keep mutable state on `this` (a natural pattern given `enliven.call(handler, ref)`) fail at first use. That is a surprising failure far from the cause. Record the choice in the surface section so handler authors see it up front, not only in the questions list.

Out of scope: type-signature accuracy for `enliven(ref)` (the `this` type and the return `value | Promise`) belongs on the implementation PR's typist pass.

Self-improvement: no changes proposed to the ergonomist brief. It could add an explicit check that a design's same-named-function overlaps have an in-band disambiguator.
<sub><!--garden-provenance-section-->model <code>claude-opus-5-5</code> · harness <code>claude</code> · provider <code>anthropic</code></sub>
</details>

<details>
<summary><b>copyeditor</b> — approve</summary>

**Verdict: approve**

**Findings**

1. **Jargon introduction — "swiss number" (Forward sketch section, line 236)**

   Line 236 refers to "a Swiss number, a connection hints" as examples of data a CapTP handler might close over, but the term isn't introduced or explained. While this document targets Endo developers, the term is specific enough to warrant a brief gloss for readers unfamiliar with CapTP internals. [proposed-rule: project-specific cryptographic or architectural terms should be introduced or glossed on first use, especially when used in a list of alternatives where the unfamiliar term stands out].

   **Verdict: comment-only** — Add a brief parenthetical gloss (e.g., "peer id, swiss number (a cryptographic unique identifier), connection hints") to aid readers new to CapTP.

2. **Sentence clarity — "silently revived" (Disposition section, line 194)**

   The phrase "none of them is lost or silently revived" is an unconventional word choice. "Revived" typically means "brought back deliberately," but the intended sense here appears to be "slips back into the design unintentionally." [proposed-rule: colloquial or archaic word pairs should be clear without requiring readers to infer the metaphor].

   **Verdict: comment-only** — Substitute "silently reintroduced," "accidentally recreated," or "forgotten and reimplemented later" for clarity.

**Self-improvement**

The document reads end-to-end as technically rigorous and well-structured. Prose mechanics are solid throughout—no grammar or sentence-structure errors, tense is consistent, paragraph flow is logical, and most jargon is introduced correctly. The two findings are minor stylistic refinements that would improve readability for newcomers to the codebase without altering the document's technical substance. This seat's primary observation: the design successfully reconciles multiple prior proposals and layers into a coherent contract, and the prose reflects that synthesis clearly.
<sub><!--garden-provenance-section-->model <code>claude-opus-5-5</code> · harness <code>claude</code> · provider <code>anthropic</code></sub>
</details>

<details>
<summary><b>pedant</b> — request-changes</summary>

Looking at the diff for PR #1389, I'll review the new design document and README entry through the pedant's style lens.

**Verdict: request-changes**

**Findings:**

1. **Heading capitalization inconsistency** [rule: Chicago Manual of Style § headings]
   - The document mixes title case and sentence case across heading levels. Examples:
     - Title case: `## What is the Problem Being Solved?`, `### Surface`, `### Packaging`
     - Sentence case: `## Open questions`, `### Child compartments`, `### Ownership map`, `### Forward sketch`
   - Select one convention (title case or sentence case) and apply it consistently across all heading levels (both `##` and `###`). Chicago Manual permits both, but the chosen style must be uniform throughout.
   - **Verdict: should-fix**

**Other observations:**

- ✓ No em-dashes (project rule enforced correctly)
- ✓ Relative paths used consistently within the document tree (`../packages/...`)
- ✓ No hard-to-type code points (arrows, ellipses, curly quotes avoided per project rule)
- ✓ Serial commas used correctly ("what the ref captures, and how it is revived")
- ✓ Citation form consistent (PR #774, #695, kriscendobot/garden#47)
- ✓ Link text discipline applied
- ✓ README table entry follows existing format conventions

The document is well-structured and professionally written. The single inconsistency is heading capitalization, which is straightforward to remedy by selecting one style and applying it uniformly.
<sub><!--garden-provenance-section-->model <code>claude-opus-5-5</code> · harness <code>claude</code> · provider <code>anthropic</code></sub>
</details>

<details>
<summary><b>novice</b> — comment-only</summary>

**Verdict:** comment-only

The design reads well overall. The problem, the nine-layer stack, the surface, and the open questions follow in order. The gaps below are ones a new reader would hit.

**Findings**

1. **[should-fix] Background assumed in "What is the Problem Being Solved?".** The section leans on #774, #695, the directive, and the `HandledPromise` shim. A new reader does not know what any of them are. Only the `#695` link is given, and the section never says what #774 is beyond a one-line gloss. Add two or three sentences that say what a HandledPromise shim is and why a "handler" is the chosen pattern (as with `Proxy`). Without them, "constructed the way a Proxy or HandledPromise is" is opaque. [proposed-rule: designs cited by number must give a one-sentence gloss on first mention]

2. **[should-fix] The enliven mental model is never shown end to end.** The Surface section describes the parts but gives no worked example. A ~10-line snippet would close the gap. It should mint a ref with a handler that closes over a locator, call `SturdyRef.enliven(ref)`, and show the resolved value. Without it, "what a SturdyRef captures is defined entirely by that handler" stays abstract until the Forward sketch. [rule: novice § example clarity]

3. **[should-fix] Dense paragraphs.** The `SturdyRef.enliven(ref)` bullet mixes six ideas: later turn, hook call form, rejection, non-ref rejection, the send asymmetry, and no caching. The `provideSturdyRef` bullet mixes installation timing, the harden conflict, and the layer-2 ordering. Split each into short sentences or sub-bullets. [rule: novice § prose density]

4. **[should-fix] The lockdown/harden explanation skips a step.** It says `@endo/harden` installs `Object[@harden]` and that `lockdown` then throws. It never says why the shim would call harden before lockdown at all. Add one sentence of motivation before the constraint.

5. **[comment-only] Forward references.** The Surface section cites "Open question 3", "Open question 5", and the like before the reader has seen the questions. The question numbers are useful, but a one-line summary next to each *provisional* marker would spare readers the jump.

6. **[comment-only] Terms used before they are defined.** "Eval twins", "amplifier", and "presence" are used before they are introduced. "Eval twins" gets a gloss in parentheses, but "amplifier" and "presence" do not.

7. **[comment-only] Withdrawn-vision section.** It refers to a garden job, `endo-sturdyref-enliven-design`, that a reader of this repo cannot see. It should say in one sentence what that vision was before disposing of its parts. It could also be moved to an appendix, since it is history rather than the contract.

Self-improvement: none proposed.
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

=====END REVIEW BODY=====
