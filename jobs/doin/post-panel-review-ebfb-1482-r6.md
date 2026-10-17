---
requires: host=endolin-garden-ece02cb4
role: gardener
tier: mentor
fallback-tier: minion
dispatch: automatic
---
# Post panel round-6 verdict on endojs/endo-but-for-bots#1482

The round-6 panel (job endojs-endo-but-for-bots-pr1482-gauntlet-panel-6, run on oros-studio) returned **must-fix** for head `a46821cc0`. That host's bot PAT cannot write reviews on endojs (403 on addPullRequestReview), so this job posts it from here.

1. Check https://github.com/endojs/endo-but-for-bots/pull/1482 for an existing review containing `<!-- garden-panel-round: endojs-endo-but-for-bots-pr1482-gauntlet-panel-6 -->`. If one exists, stop: it's already posted.
2. Copy the text between the BEGIN/END markers below **verbatim** into a temp file (extract it mechanically, don't retype it) and post it with
   `gh pr review 1482 -R endojs/endo-but-for-bots --comment --body-file <file>`
   (as a COMMENT, because the bot authored the PR and GitHub refuses request-changes from the author).
3. Report the review URL. Do not fix anything or un-draft the PR.

----- BEGIN REVIEW BODY -----
<!-- garden-panel-round: endojs-endo-but-for-bots-pr1482-gauntlet-panel-6 -->

**Panel round 6 verdict: must-fix**

## Panel round 6 — must-fix (single-round)

Head `a46821cc0`, base `4d8b59b6ed`. 33 seats ran. Request-changes: breaker, integrator, pruner, coverage-auditor, decomplector. Approve (bodies elided): curator, warden, engine-realist, benchmarker, changeset-auditor, gateway, releaser, transplanter, orthographer, thesaurus, procurer, reexport-auditor. All others comment-only.

### Deterministic pre-passes (binding)

- **Phase/evidence: BLOCKED.** `phase-evidence-verdict=blocked disposition=orchestrated-slice designs=[designs/README.md] phases=[] findings=[missing-design:designs/README.md]`
- **PR-body template: NONCONFORMING.** The heading "Documentation considerations" from `.github/PULL_REQUEST_TEMPLATE.md` is missing. Keep every heading, with one sentence where a section doesn't apply.
- **PR-body concision:** size: 316 words (> 300 for a body); files: 3 distinct file paths — cut to what the reviewer needs (skills/pr-formation, skills/gricean-maxims)
- **Repeated mechanism:** rounds 4 and 5 (heads 77b8ed83, e8832141) both raised must-fix findings on the same mechanism (`dialing`, `network.js`, `prefersOwnDial`). The decomplector's is-it-needed question was forced.

### Request-changes seats (full text)

<details>
<summary><b>breaker</b> — request-changes</summary>

**Verdict: request-changes**

I reviewed the diff from base `4d8b59b` to head `a46821c` in `packages/ocapn-noise`. I also read `test/reconnect.test.js` and the fixed-length-at-offset framing at `src/network.js:1820`, `:1921` and `:2317`.

**Findings**

1. **should-fix: the deference bound resets on every redial, so a winner whose dials keep failing can hold the session down until `hardTimeoutMs`.**
   - The claim: the typedef at `src/network.js:395-398` says the first dropped dial "in a run of redials starts the window after which the session stops deferring". The comment at `:1068-1072` says a dial whose connect hangs "cannot keep refusing a peer dial that has a working path".
   - The problem: the `finally` at `:1372` clears `deferringSince` whenever `dialing === 0`, and that happens after every failed dial, before the backoff timer even fires. So the window lasts one dial, not one run of dials.
   - Attack 1: the winner W's `transport.connect` rejects after time T, with T shorter than `sessionTimeoutMs` (for example an OS connect timeout, or a blackholed SYN behind an RST-ing middlebox). The window restarts on every attempt and never expires. The loser L gets through only if its dial happens to land in one of W's backoff gaps.
   - Attack 2: W's connect succeeds but the handshake stalls (data dropped after the SYN). `connectedDials > 0` makes W defer outright for the full `handshakeTimeoutMs` (`:1699`), and that branch never starts a window at all.
   - In both cases, once `handshakeTimeoutMs` is at least `backoffMaxMs`, W is dialing for most of each cycle. L's backed-off retries mostly hit W while it is still deferring, so the session can run out its `hardTimeoutMs` budget even though L has a working path the whole time.
   - The only test, `test/reconnect.test.js:302`, covers a connect that never returns, so neither attack is exercised.
   - Fix: keep `deferringSince` until `attach` or `current !== undefined`, not until `dialing === 0`. Also start the window on the connected path. Add a test where W's connect rejects after `sessionTimeoutMs / 2`.
   - [proposed-rule: a time bound described as covering "a run" must be reset only where the run ends (here, attach or abort), never at the end of each attempt inside it]

2. **comment-only: a dial that connects late can make the two sides attach different instances at the same epoch.**
   - Attack: W's deference expires, so W accepts L's dial A and attaches it at epoch e+1. At the same moment, W's hung connect completes. L receives W's hello before W's answer to A arrives. L is the loser, so it accepts, and attaches W's dial B at e+1.
   - Each side then closes the other's instance through the `current !== undefined` branch at `:1380`. Both lose their instance and redial at e+2.
   - This recovers: replay is driven by `peerReceived`, and the backoff rule added at `:1383` stops it spinning. But the invariant "the tiebreaker keeps one of the two instances" (`:1308`, README § Session reconnect) does not strictly hold. Either note this or have W ignore a connect that completes after its window has expired.

3. **comment-only (mitigated): an authenticated peer can jump the epoch ahead.**
   - The relaxed check at `:2232` accepts any later epoch. A peer could send `epoch = 2n**64n` and force `epoch + 1n` comparisons onto that value.
   - The comment at `:2229-2231` scopes the damage to the session the peer authenticated into, and the session token plus the handshake-authenticated initiator key gate the resume. No action needed, but a codec-level bound on epoch width would make the "only orders dials" claim mechanical rather than argued.

4. **comment-only (mitigated): equal ephemerals.**
   - `initiatesOnCrossedHellos` picks exactly one side, even when the peer echoes our ephemeral back. Test `:346` pins this. No attack found.

5. **comment-only (mitigated): replaying a stale epoch.**
   - The old behavior answered a stale epoch with a refusal, which an attacker could use to abort the session. A stale epoch now closes the dial without an answer (`:2232`), and the dialer treats that as an ordinary failed attempt. Test `:253` covers it.

Self-improvement: the "time bound reset per attempt vs. per run" class is a recurring way to falsify invariants in retry and backoff code. Consider adding it to `skills/saboteur-adversarial-review/SKILL.md`.
<sub><!--garden-provenance-section-->model <code>claude-opus-5-5</code> · harness <code>claude</code> · provider <code>anthropic</code></sub>
</details>

<details>
<summary><b>integrator</b> — request-changes</summary>

**Verdict: request-changes**

**Findings**

1. **must-fix — PR body is missing a template heading.** The body has no `### Documentation Considerations` section. The base template's order is Description, Security, Scaling, Documentation, Testing, Compatibility, Upgrade, so it belongs between Scaling and Testing. This PR edits `packages/ocapn-noise/README.md` (§ Session reconnect), the design's new § Status, and `designs/README.md`, so the section has real content to report. Please refill the body section by section. [rule: skills/pr-formation/SKILL.md § Use the upstream template]

2. **should-fix — Testing Considerations just says "See CI."** That gives a future `git log` reader nothing. Name what the PR adds:
   - the `initiatesOnCrossedHellos` unit pin (`test/reconnect.test.js:349-354`);
   - the crossed-hellos convergence test for cbor and syrup;
   - the hung-winner and straggler-drop cases;
   - the `_loss-injector.js` hold-redial extension;
   - the widened heartbeat windows in `session-queue.test.js` and the `integration.test.js` assertion that changed from `getConnects() >= 2` to `getOpenStreams() >= 1`.
   
   [rule: skills/pr-formation/SKILL.md]

3. **should-fix — commits should be regrouped for the merge-commit reader.** The repo merges by rebase (AGENTS.md § Pull requests), so all 13 commits land in `git log` as written. That includes `fix: address panel round 1 …` and `fix: address panel round 3 …`, a pair of "widen … loaded runner" test tweaks, and a chain of deference-window fixes (`d73c0ec10`, `d3130e4b2`, `e8832141b`) that revise each other. Please reset and redistribute into a few logical commits: tiebreaker plus either-side redial (feat), loss-injector and test harness (test), timing widenings (test), and docs. Overlaps with packager. [rule: roles/jurors/integrator/AGENT.md § Commit grouping]

4. **should-fix — the design's § Status points at the wrong symbol and leaves out a deviation.**
   - `designs/ocapn-noise-session-reconnect.md:26` says designator comparison lives in `prefersOwnDial`. The comparison is actually `initiatesOnCrossedHellos` in `src/crossed-hellos.js`; `prefersOwnDial` is only the deference gate.
   - The deviation list doesn't mention two behaviors that differ from § 3's procedure (steps 3–4: "responder cancels its outbound socket"). First, the winner's deference is time-bounded by `sessionTimeoutMs` and falls back to accepting the peer's dial. Second, an equal-ephemeral tie goes to the session opener.
   
   A reader settling P3 needs both. Overlaps with archivist. [rule: roles/jurors/integrator/AGENT.md § Concept-namespace coherence]

5. **comment-only — phase/evidence status.** The pre-pass reports `blocked` with `missing-design:designs/README.md`. That looks like an artifact: it took the index the diff edits to be the governing design. The ledger correctly names `designs/ocapn-noise-session-reconnect.md`. With that design as the reference:
   - Phases 1–3 are on the stack below (#1476, #1478, #1481).
   - Phase 5 is what this diff implements.
   - Phase 4 (Resume) is deferred on C1 and has a named `Successor:`.
   
   Disposition is `orchestrated-slice` and the PR is draft, so the ledger hangs together. Un-drafting is withheld mechanically until Phase 4 lands, and I'm not requesting changes on that basis. [rule: roles/jurors/integrator/AGENT.md § Ordered-phase and acceptance-evidence reconciliation]

6. **comment-only — the code fits existing structure.** Extracting `src/crossed-hellos.js` and testing it through a direct import gives the tiebreaker one checked home. The `designs/README.md` row update keeps the index in step with the design's status, and the diagram stays mermaid.

Self-improvement: the phase-evidence pre-pass should skip `designs/README.md` (an index, not a design) when picking the governing design, and use the ledger's `Design:` line when one is present.
<sub><!--garden-provenance-section-->model <code>claude-opus-5-5</code> · harness <code>claude</code> · provider <code>anthropic</code></sub>
</details>

<details>
<summary><b>pruner</b> — request-changes</summary>

**Verdict: request-changes.** Two concrete cuts are needed: one README sentence that leaks design internals, and one test comment that restates the assertion under it. The PR body and the rest of the comment surface are borderline; I flag them as acknowledge.

**Findings**

1. **README leaks the tiebreaker design into the public package doc.** `packages/ocapn-noise/README.md:122` ("If both sides dial at once (crossed hellos), the side whose handshake ephemeral is the greater keeps its own dial and drops the other side's unanswered.") is protocol-internal narrative. The README describes how to use the package. The rule itself lives in `designs/ocapn-noise-session-reconnect.md` § 3 and is already linked from the new section.
   - Failure scenario: a user reading the README to configure `reconnect` learns a wire-level tiebreaker rule they cannot act on, and the copy drifts when the design changes.
   - Required action: delete the sentence at line 122. Keep the link to the design.
   - Disposition: `summary-fix`.
   - [rule: roles/jurors/pruner/AGENT.md § Primary surface, "Implementation-internal narrative leakage"]; [rule: skills/gricean-maxims/SKILL.md].

2. **Test comment restates the assertion beneath it.** `packages/ocapn-noise/test/reconnect.test.js:230` ("// The greater side's dial wins.") is a one-line comment that repeats what the next check asserts. I have not read that check in full, so confirm it matches before deleting.
   - Required action: delete the comment, or replace it with the non-obvious reason the greater side is the one that wins.
   - Disposition: `summary-fix`.
   - [rule: skills/gricean-maxims/SKILL.md]; [rule: roles/jurors/pruner/AGENT.md § All added code comments are in scope].

3. **PR body over the concision probe (316 words) with restated rationale.** The Description's first bullet argues why either side redials, quoting the design prompt. The Security Considerations first bullet points at open question P3, which `designs/ocapn-noise-session-reconnect.md` § Status already says.
   - Required action: cut the quoted-prompt justification to one clause, and drop the P3 pointer from the Security section. The "Testing Considerations: See CI." and "Upgrade Considerations: None…" sections are each one sentence and may stay.
   - Disposition: `summary-fix`.
   - [rule: roles/jurors/pruner/AGENT.md § PR body and thread replies].

4. **Borderline, acknowledge: narration of adjacent slices.** `packages/ocapn-noise/src/network.js:1920` ("// The SYNACK opens with the responder's x25519 ephemeral.") restates `synack.slice(0, 32)`. It does record a wire-layout fact, so I would keep it. The JSDoc at `packages/ocapn-noise/test/reconnect.test.js:88` ("read off A's SYN (bytes 32 to 64) and B's SYNACK (its first 32 bytes)") repeats the offsets in the code directly below it. Either is acceptable to keep; the maintainer may prefer deletion.
   - Disposition: `acknowledge`.
   - [rule: skills/gricean-maxims/SKILL.md].

5. **Repetition across surfaces, low severity.** The phase status appears in three places: the `designs/README.md` table row, the design doc's new `## Status` section, and the PR body's evidence ledger. The ledger is a template and the design doc's § Status carries the real deviations, so I would keep both. The README row is the only one that could be dropped if the maintainer wants a single source.
   - Disposition: `acknowledge`.
   - [proposed-rule: status facts for a design should be stated in the design document, with indexes linking to it rather than restating the phase list].

Self-improvement: the PR-body probe fired on a 316-word body, and the template sections it flagged were one sentence each, so the concision rule held. The `[proposed-rule]` in item 5 is the one new candidate I would raise.
<sub><!--garden-provenance-section-->model <code>claude-opus-5-5</code> · harness <code>claude</code> · provider <code>anthropic</code></sub>
</details>

<details>
<summary><b>coverage-auditor</b> — request-changes</summary>

**coverage-auditor: PR #1482** (`feat(ocapn-noise): crossed-hellos tiebreaker on reconnect`)

**Verdict: request-changes**

I could not check the uncovered-line list. The pre-pass had no c8 report (`coverage/coverage-final.json` is absent), so this review is from reading the diff against the reconnect tests, not from measured line coverage. The gate did not assume coverage either. Re-run the pre-pass with `c8 --all --reporter=json` and re-dispatch if the list is needed to close the gap.

**Findings**

1. **`packages/ocapn-noise/src/network.js`, the `dial` reschedule after an overtake.** When a redial's result arrives after the session has moved past its epoch (`epoch + 1n !== nextEpoch`), the code closes the instance. If the session is then also unattached, it backs off and calls `scheduleRedial(delayMs)`. Nothing in `reconnect.test.js` appears to drive that path. The closest test, "dials for an epoch the session has reached are dropped unanswered" (line 253), drops the dial but never has the overtaking instance fail too. Reachable from the public surface through the loss injector, so this is a gap.
   Recommended test: in `reconnect.test.js`, hold the lesser side's connects, let the greater side's dial win epoch 1, then sever that instance before it is attached. Assert both sides converge on epoch 2 and the lesser side redials after backoff instead of stalling. [rule: skills/coverage-driven-testing/SKILL.md]

2. **`src/network.js`, `prefersOwnDial` when `connectedDials > 0`.** The branch that returns `true` once one of our own dials has connected is probably covered by the crossed-hellos test (line 200). Confirm this from the c8 report. If it is uncovered, the test is to hold a peer dial while one of ours has connected and assert the peer's dial is dropped. [rule: skills/coverage-driven-testing/SKILL.md]

3. **Platform arm (C-platform-arm): no new platform arm, so no platform test is required by this PR.** The probe fired on `packages/ocapn-noise`. Its `exports` map has a `browser` condition on `./platform`, and `test:xs` is `exit 0`. The diff touches neither: `network.js`, `crossed-hellos.js`, `types.d.ts`, and the tests are all platform-neutral, with no condition-keyed branches and no `*-browser*` or `*-xs*` files. The `browser` and `xs` arms were already there before this change, and their stub status predates it. Not a request on this PR. [rule: skills/coverage-driven-testing/SKILL.md § Platform-conditional arms]

4. **Accepted without a test.** The `prefersOwnDial` `deferringSince` expiry and the `dialHandshake` default `onConnected` no-op look covered by the hang test (line 302) and by every reconnect that uses the default. Both are fine if the c8 report agrees. [rule: skills/coverage-driven-testing/SKILL.md]

[proposed-rule: the coverage pre-pass should state when it ran without a report and when the report is a stale or partial one. Here the gate correctly refused to assume coverage, but the verdict would be firmer with a measured list.]

Self-improvement: the report-less pre-pass forced a read-from-diff review. Next time, run c8 `--all` on the touched package before dispatching so the seat judges measured lines.
<sub><!--garden-provenance-section-->model <code>claude-opus-5-5</code> · harness <code>claude</code> · provider <code>anthropic</code></sub>
</details>

<details>
<summary><b>decomplector</b> — request-changes</summary>

**Verdict:** request-changes

**Findings**

1. **must-fix: a second crossed-hellos arbiter sits next to the one network.js already has.** [rule: roles/jurors/decomplector/AGENT.md § Code-panel mode, question 1]
   - **What exists.** `packages/ocapn-noise/src/network.js` already solves "two handshakes to the same peer are in flight; keep exactly one, and don't wait forever on a hung one." The pieces are the `candidates`/`inProgress`/`outboundInFlight` bookkeeping, `settle()` (it picks a candidate by a tiebreaker both sides compute and closes the rest), and `settleDeadlines`, which bounds the wait to `handshakeTimeoutMs` once no local dial is in flight.
   - **What this PR adds.** A parallel arbiter for reconnect: `dialing`, `connectedDials`, `deferringSince`, `prefersOwnDial`, and refusal on the responder side. It has its own gating, its own time bound (`sessionTimeoutMs` measured from the first dial it dropped), and the opposite ordering convention (the greater ephemeral wins here; `settle` keeps the lesser).
   - **Why the extra pieces exist.** The deference window and connected-dial counter are there only because the winner refuses the peer's dial before its own dial has proven itself. That refusal is what makes a one-way partition fatal, and it is the mechanism the last two rounds kept patching (`dialing`, `prefersOwnDial`).
   - **The alternative.** Let both reconnect dials complete as candidates. Pick the instance dialed by the designator winner, using the same `localEphemeral`/`peerEphemeral` comparison #252 settled on. Let the existing settle deadline promote the other instance if the winner's dial hangs.
   - **Ask.** Fold reconnect arbitration into the `settle` shape and delete `prefersOwnDial` and its counters. Or state in the PR body why `settle` cannot serve a session that is already attached, for example the `if (existing)` early drop. Missing that justification alone would be should-fix.

2. **should-fix: `prefersOwnDial` is a query that changes state.** [proposed-rule: a predicate on a Reconnector-style handle must not mutate the state it reports on; anything that starts a timer belongs on the event that starts it]
   - The first `true` answer sets `deferringSince`, so how long deference lasts depends on when and how often the responder path happens to ask.
   - Start the window in `redial` when a dial begins, or drop the window entirely under finding 1.

3. **should-fix: the § Status text contradicts maintainer decisions on #252.** [rule: roles/jurors/decomplector/AGENT.md § Code-panel mode, question 2]
   - It says "P3 stays open". kriskowal answered P3 on #252 with "Designator." and "Agree for designator".
   - It says "reconnect uses Rekey only, pending Open question C1". The #252 guidance was "Resume is good" and "Tentatively run with resume and rekey-cap".
   - The Rekey choice may now rest on the cryptographic review in #1487, but the Status section should cite that instead of describing C1 as untouched. Move P3 to the settled list.
   - The relaxed epoch check ("any later epoch") is also a change from the design. Recording it as a deviation is fine; record that the maintainer has not ruled on it.

4. **comment-only: two tiebreak conventions in one module.** [proposed-rule: one module, one crossed-hellos ordering]
   - `settle` keeps the lesser initiator ephemeral; `initiatesOnCrossedHellos` keeps the greater one.
   - The design's § 3 does specify greater-as-initiator. Still, either align the two or put a comment at both sites saying why they differ.

**Out of scope:** the epoch-ordering straggler redial and the backoff loop belong to the breaker and the assessor.

Self-improvement: when a code PR adds a tiebreaker, grep the base for an existing arbiter (`settle`, `tiebreaker`) before reading how the new one works inside.
<sub><!--garden-provenance-section-->model <code>claude-opus-5-5</code> · harness <code>claude</code> · provider <code>anthropic</code></sub>
</details>

### Comment-only seats

<details>
<summary><b>assessor</b> — comment-only</summary>

**Verdict:** comment-only

The control flow holds up. I traced the crossed-dial paths and found no must-fix defect. I did not run the tests. I read only the diff of `src/` and the design doc, not the test files.

**What I traced**
- Both sides now redial. The winner is the side with the greater session-opening ephemeral, with the session opener winning an exact tie.
  - The winner drops the loser's dial when `prefersOwnDial()` is true. That requires a winner dial in flight and either a connected transport or a deferral window under `sessionTimeoutMs`.
  - The loser's dial arrives while the winner's `prefersOwnDial` is false only if the winner is not dialing; otherwise it is dropped and retried with backoff. The loser itself never defers.
- The ephemeral bookkeeping is symmetric. The dialer's `localEphemeral` is the SYN ephemeral (`prefixedSyn.slice(32, 64)`, `src/network.js:1820`). The responder's `peerEphemeral` is that same value, and its `localEphemeral` is the first 32 bytes of the SYNACK. Both sides therefore compare the same pair.
- The `dialing`, `connectedDials` and `deferringSince` counters are balanced in the `finally` at `src/network.js:1370`.
- The discard path at `src/network.js:1376` checks `epoch + 1n !== nextEpoch`. It closes the stale instance and redials with backoff, so a peer that keeps overtaking cannot spin the loop.

**Findings**
1. **Comment-only: a stale-epoch dial is now dropped silently where it used to be refused (`src/network.js:2230`).**
   - Before this PR, a hello with the wrong epoch got an explicit `epoch: 0n` refusal. Now `peerHello.epoch <= getEpoch()` closes the stream with no answer, and the dialer sees that as an ordinary failed attempt.
   - The dialer then retries with backoff until `hardTimeoutMs` instead of learning at once that the responder is past that epoch. The cost is a slower abort, not a wrong result.
   - Consider a short comment saying the silent drop is intentional, or keep the refusal for `epoch <= getEpoch()` when `dialing === 0`. [rule: roles/jurors/assessor/AGENT.md § Primary surface — error paths]

2. **Comment-only: `deferringSince` is only reset when `dialing` reaches 0 (`src/network.js:1373`).**
   - If the winner's redials overlap back to back (one starts as the previous ends), `dialing` never hits 0. The deferral window then stays anchored at the first drop and expires after one `sessionTimeoutMs`.
   - That is probably the intended bound, and it favours liveness. It is worth stating in the comment on `deferringSince`. [proposed-rule: document the lifetime of timing anchors that are reset on a counter reaching zero]

3. **Comment-only: the design doc's tiebreaker text is looser than the code.**
   - The new Status paragraph says designator comparison is "implemented (see `prefersOwnDial`)". The code compares handshake ephemerals, not designators, and `prefersOwnDial` adds a timeout escape.
   - Reword it so the doc matches the code. [rule: designs/ocapn-noise-session-reconnect.md § Status]

**Out of scope:** nothing noted.

Self-improvement: no new standing rule needed. The proposed rule in finding 2 is the only candidate.
<sub><!--garden-provenance-section-->model <code>claude-opus-5-5</code> · harness <code>claude</code> · provider <code>anthropic</code></sub>
</details>

<details>
<summary><b>typist</b> — comment-only</summary>

**Verdict:** comment-only

**Findings**

1. **should-fix**: `packages/ocapn-noise/src/network.js` (`prefersOwnDial`, about line 1700) uses a cast instead of a narrowing: `/** @type {{ sessionTimeoutMs: number }} */ (heartbeatSettings).sessionTimeoutMs`.
   - `reconnectSettings` is already derived from `heartbeatSettings !== undefined`, and a reconnector exists only when that holds. Capture `sessionTimeoutMs` inside the `reconnectSettings` branch, or read it from the already-narrowed `reconnectSettings`. That removes the cast and keeps the types tied to the invariant.
   - [rule: AGENTS.md § Type-assertion discipline]

2. **comment-only**: the `StreamState` multi-field `@typedef` is declared inline inside `makeLossyTransport` in `test/_loss-injector.js`.
   - It is module-private and single-use, and it lives in a test helper rather than `src/**`, so it falls under the escape hatch. No change is needed.
   - [rule: roles/jurors/typist/AGENT.md, typedef-location, escape hatch]

3. **comment-only**: `dial` in the `Reconnector` typedef now takes `onConnected` as a required third parameter.
   - `dialHandshake` correctly declares it optional (`[onConnected]`) with a default, and the one call site passes it, so the types match the runtime.
   - The `types.d.ts` doc comment for the reconnect option is reflowed awkwardly (a short orphan line, `transport instance (…) , the session epoch`). It is accurate; tidying the wrap is optional.

4. **comment-only**: `synack.slice(0, 32)` supplies `peerEphemeral` and `localEphemeral`, and `tiebreaker` supplies the other side. Both are used as `Uint8Array`, which matches the new `@param {Uint8Array}` declarations. The `synack` length check happens earlier in the handshake, so the slice is safe. In `crossed-hellos.js` the `@param` and `@returns` types match the body, and the file starts with `// @ts-check`.

**Checks that came back clean**
- No inline `import()` types in JSDoc.
- No typist-hostile code points in the added text.
- No bare `Function` types.
- `[param]` brackets are used only on the genuinely optional `onConnected`.

Self-improvement: no new standing rule proposed. The "prefer narrowing over `@type` cast on an option bag already checked for `undefined`" case is already covered by AGENTS.md.
<sub><!--garden-provenance-section-->model <code>claude-opus-5-5</code> · harness <code>claude</code> · provider <code>anthropic</code></sub>
</details>

<details>
<summary><b>stylist</b> — comment-only</summary>

**Verdict:** comment-only

**Findings**

1. **Inconsistent tiebreaker naming (should-fix).**
   - `packages/ocapn-noise/src/network.js` (the `dialHandshake` return) passes `localEphemeral: tiebreaker` in the dial path.
   - The responder path passes `peerEphemeral: tiebreaker`.
   - `tiebreaker` names the role the value plays. At the call site the value is the local or peer x25519 ephemeral, and the same variable ends up under different parameter names depending on the side.
   - Name it for what it is, for example `localEphemeral` in the dial path and `peerEphemeral` in the responder path. Alternatively, name it once as `initiatorEphemeral`, since both paths hold the initiator's ephemeral.
   - [proposed-rule: a local variable should be named for the value it holds, not for the use a distant consumer makes of it.]

2. **`initiatesOnCrossedHellos` and `winsCrossedHellos` disagree (should-fix).**
   - The exported function is `initiatesOnCrossedHellos`. Its docstring says it returns "whether this side's dial is the one both sides keep".
   - The caller binds the result to `winsCrossedHellos`, and the resumable exposes `prefersOwnDial`.
   - One concept now has three names: initiates, wins, prefersOwnDial. "Initiates" is also ambiguous because `isInitiator` already means "opened the session".
   - Pick one term. `keepsOwnDialOnCrossedHellos` matches the docstring.
   - Cite both the name and the doc: `src/crossed-hellos.js` and `src/network.js`.

3. **`prefersOwnDial` reads like a pure predicate but has side effects (should-fix).**
   - Its docstring says the first `true` answer starts the deferral window (`deferringSince`), so the call mutates state.
   - Name it for the action, for example `shouldDropPeerDial`. Alternatively, split the query from the window bookkeeping.
   - The same function appears in the design doc as `prefersOwnDial`, so rename both.

4. **Ambiguous `onConnected` argument and name (comment-only).**
   - `onConnected` is a plain callback. The `dial` type signature gives it a bare `() => void` with no explanation beyond the docstring, which says "called once the transport connects".
   - It is acceptable. Consider `onTransportConnected` to distinguish it from the session-level "connected" state, since `connected` and `connectedDials` are also local variables.

5. **`dialing` and `connectedDials` are counters named like state (comment-only).**
   - Neither name says it is a count. `dialsInFlight` and `connectedDialCount` would read more clearly.

6. **`known` in the responder's hello check (comment-only).**
   - `known` is used for "the hello names this session", which was `resumes` before. The rename is motivated by the changed semantics.
   - A name like `namesThisSession` would be more specific.

7. **Abbreviations (none).** No new bare abbreviations. `Ms` suffixes on `delayMs` and `backoffMs` follow existing package convention.

**Renames:** the `resumes` → `known` change is motivated by the PR and is not gratuitous. No public identifier is renamed.

**Docs:** the new "Session reconnect" README section names `prefersOwnDial` in the design doc but "crossed hellos" in the README, so the vocabulary is inconsistent across the three places.
<sub><!--garden-provenance-section-->model <code>claude-opus-5-5</code> · harness <code>claude</code> · provider <code>anthropic</code></sub>
</details>

<details>
<summary><b>packager</b> — comment-only</summary>

**Verdict:** comment-only

**Findings**

1. **comment-only: no changeset, and none is needed.** `@endo/ocapn-noise` is `"private": true` at 0.1.0, so the tiebreaker, the behavior change in `src/network.js`, and the test-harness work don't need one. Other changesets already name this package, but that doesn't change the answer for a private package. [rule: skills/changeset-discipline/SKILL.md]

2. **should-fix: the design doc names the wrong thing for the tiebreaker.**
   - `designs/ocapn-noise-session-reconnect.md` § Status says "Designator comparison is implemented (see `prefersOwnDial` in `src/network.js`)".
   - The code compares handshake ephemerals in `src/crossed-hellos.js`, via `initiatesOnCrossedHellos`. A designator comparison would be a different rule.
   - `prefersOwnDial` is only a callback parameter on a helper at `network.js:395-404`, not the tiebreaker.
   - Reword the Status bullet to "handshake-ephemeral comparison, `initiatesOnCrossedHellos` in `src/crossed-hellos.js`", and make clear whether § 3's designator rule or the ephemeral rule is the spec. [proposed-rule: a design's "Deviations" entry must name the symbol that actually implements it.]

3. **should-fix: commit history carries panel-round churn.**
   - There are 13 commits. They include `address panel round 1`, `round 3`, several "widen timeout" test commits, and a final `cut crossed-hellos narrative duplicated across…` docs commit.
   - The `d73c0ec10`, `d3130e4b2`, and `e8832141b` fixes rework the deference logic that `9376e7e05` introduced.
   - The final docs commit removes prose that `77b8ed839` added.
   - Squash each fix into its originating commit. The series is rebase-merged, so the history lands as written. [rule: roles/jurors/packager/AGENT.md § Conflated autofix]

4. **comment-only: `types.d.ts` JSDoc wrap.** The edited paragraph at `src/types.d.ts:127-132` leaves a short orphan line ("dial, the session epoch"), so rewrap it. The prose itself is accurate.

5. **comment-only: scope is clean.**
   - The diff is confined to `packages/ocapn-noise`, the design doc, and the `designs/README.md` index row.
   - There are no `yarn.lock` or generated-file changes, so there's nothing to split out.
   - The index row "In Progress (Phase 4 open)" matches the design's Status.

Self-improvement: for private packages, check design-doc symbol references against the code before reading the changeset.
<sub><!--garden-provenance-section-->model <code>claude-opus-5-5</code> · harness <code>claude</code> · provider <code>anthropic</code></sub>
</details>

<details>
<summary><b>archivist</b> — comment-only</summary>

**Verdict:** comment-only

**Findings**

1. **should-fix**, `designs/ocapn-noise-session-reconnect.md:26-27` (Status) and `§ 3`, lines 227-258 (Crossed-Hellos Tiebreaker). The design's procedure says the loser "cancels its outbound socket" and the winner "cancels its inbound socket." The implementation works differently. The winner's `prefersOwnDial()` (`packages/ocapn-noise/src/network.js`, around line 1697) makes the responder close an incoming hello with no answer (around line 2225), and the dialer treats that as an ordinary failed attempt. The implementation also adds a timeout-bounded deferral window (`deferringSince`, `connectedDials`) for a connect that hangs. Neither the design's § 3 nor the Status section mentions the window or the refusal mechanism. Status says only "designator comparison is implemented." A reader of the design would expect socket cancellation and no timeout fallback. This is not unsafe on its own, so it does not block. Suggested fix: add one paragraph to Status or § 3 that names the refuse-without-answer mechanism and the `sessionTimeoutMs` window, and note that P3 is still open for the window.

2. **comment-only**, `packages/ocapn-noise/README.md` (new "Session reconnect" section). The text "the side whose handshake ephemeral is the greater keeps its own dial and drops the other side's unanswered" matches `initiatesOnCrossedHellos` and `prefersOwnDial`. It omits the hang fallback from finding 1. Adding "until a session timeout passes without a connected dial of its own" would make the README match the code.

3. **comment-only**, `packages/ocapn-noise/src/crossed-hellos.js:9-14`. The JSDoc says equal ephemerals would "leave both sides deferring" under a naive comparison. That is a fair reason for the initiator tie-break, and the code matches the stated result: exactly one side keeps its dial. No change needed.

Checked and consistent: the Status section's test-file names all exist. Open questions C1 and P3 exist. `hardTimeoutMs` matches `types.d.ts`. The phase numbering matches the Phased Implementation section. The `designs/README.md` row and the `Updated` date are consistent with the new Status.

Self-improvement: none. The review did not turn up a recurring pattern beyond the existing design-vs-implementation drift check.
<sub><!--garden-provenance-section-->model <code>claude-opus-5-5</code> · harness <code>claude</code> · provider <code>anthropic</code></sub>
</details>

<details>
<summary><b>prover</b> — comment-only</summary>

**Verdict:** comment-only

The new tests are mostly load-bearing, and I found no must-fix. I did not run the suite or revert the production change. This review is by reading the diff and reasoning about each test against the code it covers.

**Findings**

1. **should-fix: the "accept any later epoch" deviation has no test.**
   - `network.js` (responder branch) drops a dial only when `peerHello.epoch <= resumable.getEpoch()` or `prefersOwnDial()` is true.
   - The Status section says a dialer "that missed an answer still converges", and the new comment in `network.js` says a far-ahead epoch can only stall that peer's own authenticated session.
   - Every test in `reconnect.test.js` produces dial epochs of exactly `getEpoch() + 1`, or ones already reached.
   - Restoring the old `epoch === getEpoch() + 1n` check would therefore still pass the new tests. The one that comes closest, "dials for an epoch the session has reached…", only reaches the `<=` side of the guard.
   - A test is needed in which a dialer's answer is lost and it redials at `epoch + 2`, and the responder accepts it. [proposed-rule: when a PR relaxes a protocol check, add a test that the relaxed case is now accepted, not only tests for the cases still rejected.]

2. **should-fix: the dialer-side "session moved past this epoch" branch is probably untested.**
   - The new `epoch + 1n !== nextEpoch` clause in `scheduleRedial` closes the dialed instance and re-dials with backoff.
   - For a dial to reach it, the peer must accept a stale-epoch dial while this side's own epoch has advanced. The responder now drops `<= getEpoch()` dials unanswered, so in the tests that case reaches the `catch` path instead.
   - Reverting this clause changes no test outcome I can identify. Either add a test that reaches it or confirm the branch is unreachable and delete it.

3. **comment-only: `droppedDials` is brittle.**
   - It counts inbound streams with `writesAtReturn === 2`, a hard-coded number of writes (SYNACK plus the identity greeting).
   - A change to the greeting framing would silently turn `t.is(droppedDials(greater), 1)` into a miscount.
   - The counter does pin the drop-versus-refuse distinction, which is useful. Derive the constant from a baseline stream instead of hard-coding it.

4. **comment-only: the `compareUint8Arrays` wiring is pinned only indirectly.**
   - The unit test of `initiatesOnCrossedHellos` covers the tie-break logic, including the equal-ephemeral case.
   - The `isInitiator` argument passed in `network.js` is exercised only by the equal-ephemeral unit test, which calls the helper directly. No network-level test produces a tie.
   - The ephemeral wiring itself is well pinned by `byEphemeral` against both the SYN and the SYNACK. A swapped `localEphemeral`/`peerEphemeral` would flip the winner and redden "crossed hellos … converge".

5. **comment-only: other tests that look sound.**
   - "either side redials" would fail on the old initiator-only redial, because `refuseOutbound(true)` stops A and only B can dial.
   - The hanging-dial test fails if deferral is unbounded, because the session stays down until `hardTimeoutMs`.
   - The `integration.test.js` change from `getConnects() >= 2` to `getOpenStreams() >= 1` is a reasonable adjustment, since either side may now dial.

Self-improvement: when a PR relaxes a protocol guard, check the tests for a positive case of the newly accepted input.
<sub><!--garden-provenance-section-->model <code>claude-opus-5-5</code> · harness <code>claude</code> · provider <code>anthropic</code></sub>
</details>

<details>
<summary><b>migrator</b> — comment-only</summary>

**Verdict:** comment-only

**Findings**

1. **Comment-only: no changeset, and none is needed.** `@endo/ocapn-noise` is `"private": true` at 0.1.0 (`packages/ocapn-noise/package.json`), so nothing consumes a bump. The existing `.changeset/ocapn-noise-session-reconnect-rekey.md` covers only the `@endo/ocapn` record additions. This PR adds nothing to `@endo/ocapn`, so no cascade entry is missing. [rule: skills/changeset-discipline/SKILL.md]

2. **Comment-only: the contract change for the responder is intentional and bounded.** Before this PR, the responder answered a reconnect `op:session-hello` only when `epoch === getEpoch() + 1n`. Otherwise it refused with an `epoch: 0n` hello. Now:
   - A hello naming the right session with a stale or equal epoch (`<= getEpoch()`) is closed silently. The dialer sees an ordinary failed attempt and retries with backoff, not a refusal.
   - A later epoch (a jump) is accepted.
   - A hello naming an unknown session is still refused.

   The reconnect feature is gated on both peers advertising `FEATURE_RECONNECT`, so peers without it are unaffected. Nothing outside `src/network.js` depends on the old refusal-on-stale-epoch path. The in-package callers are `reconnect.test.js` and `session-queue.test.js`, and the PR updates them. [rule: roles/jurors/migrator/AGENT.md § Primary surface]

3. **Comment-only: the "initiator only redials" invariant is gone, and the docs follow.** `scheduleRedial(0)` now runs on both sides. A peer built from an earlier revision of this branch would never dial from its responder side. It would therefore sit in the window where `prefersOwnDial()` returns false and `dialing === 0`, and it would accept the other side's dial. That is compatible. The `README.md` "Session reconnect" section and the `HeartbeatOptions` JSDoc in `types.d.ts` were updated to describe the both-sides behavior, so nothing stale remains.

4. **Comment-only: the `Reconnector.dial` signature gained a required third argument `onConnected`.** `Reconnector` is an internal typedef, and the only implementer is the `reconnector.dial` assignment in `network.js`. The `dialHandshake` parameter defaults to a no-op, so any external caller of the dial path is unaffected. No downstream workspace package imports it.

5. **Comment-only: behavior to watch on a lossy or partitioned link.** `prefersOwnDial` defers to a connecting dial for at most `sessionTimeoutMs`, and the loser redials with backoff. If the winner's connect hangs, the loser's dial is dropped for up to one session timeout. The hard timeout (`hardTimeoutMs`) bounds the worst case. The PR documents this in comments and covers it with tests, and it needs no compatibility action.

No must-fix or should-fix items from the migrator axis.

Self-improvement: when a package is `private`, a missing changeset is a non-finding. A reviewer should check `package.json` before flagging bump-level issues.
<sub><!--garden-provenance-section-->model <code>claude-opus-5-5</code> · harness <code>claude</code> · provider <code>anthropic</code></sub>
</details>

<details>
<summary><b>locksmith</b> — comment-only</summary>

I've finished reading the diff. The one thing worth flagging is that a responder now dials outbound to addresses the peer supplies. Here is the block:

**Verdict:** comment-only

**Findings**

1. **should-fix: an inbound peer can now make the responder connect out to addresses the peer picks.** At `packages/ocapn-noise/src/network.js:1308`, `if (isInitiator) scheduleRedial(0)` became an unconditional `scheduleRedial(0)`. On the responder side, `reconnector.dial` (`network.js:2001-2008`) calls `dialHandshake` with `identity.peerLocation`, which `selectOutgoingTransport` (`network.js:824`) turns into `transport.connect(hints)`.
   - **Where the hints come from:** the peer's own `op:start-session` (`network.js:940`). The signature only proves the peer owns the key that signed them. It says nothing about whether the addresses are ones this node should contact. Any keypair holder that connects in and advertises `FEATURE_RECONNECT` can supply them.
   - **What changes:** before this PR, accepting a connection gave the peer no way to trigger an outbound connect from the listener. Now, by dropping its transport, the peer makes the listener retry `connect` to hints of its choosing, with backoff, until `hardTimeoutMs`. That works like SSRF for connect attempts (the listener connects wherever it is told) and reaches internal addresses the listener can see.
   - **Docs:** the README (`packages/ocapn-noise/README.md:111-125`) and `types.d.ts:130` describe "either side dials" but don't say that the dial goes to addresses the peer advertised.
   - **Suggested fixes:** make responder redial opt-in, for example a `reconnect.redialAsResponder` setting, so a listen-only deployment never holds authority to dial out for an unsolicited peer. Alternatively, allow it only when this side already had its own reason to dial that peer (a location it resolved locally). At minimum, document the new outbound reach.
   - [proposed-rule: a code path that dials, fetches, or connects to peer-supplied addresses on behalf of a connection the local side did not start is a new authority grant; gate it behind an explicit option or a locally obtained location]

2. **comment-only: dropping the exact-epoch check keeps authority with the session token and authenticated key, which is acceptable.** `network.js:2207-2238` now accepts any `peerHello.epoch > getEpoch()`. The authorization is still the handshake-authenticated `initiatorKeyHex` plus `sessionToken` (`network.js:2213-2215`), and the inline comment says so correctly. A peer that jumps the epoch ahead can only stall its own session. Nothing changes here.

3. **comment-only: `prefersOwnDial` stays inside the network.** It is a closure on the internal `Reconnector` record (`network.js:1697`). No export, guest, or CapTP surface gains it, and `crossed-hellos.js` exports a pure predicate that grants no authority. The new `_loss-injector.js` controls (`holdConnects`, `refuseOutbound`, `getStreams`) are test-only and hardened.

Self-improvement: when a change turns a one-sided action into a two-sided one, trace where the newly enabled side gets its inputs. Here the edit was one line, but it gave every listener the power to dial out.
<sub><!--garden-provenance-section-->model <code>claude-opus-5-5</code> · harness <code>claude</code> · provider <code>anthropic</code></sub>
</details>

<details>
<summary><b>saboteur</b> — comment-only</summary>

**Verdict:** comment-only

**Findings**

1. **Should-fix: a peer dial accepted before an `await` can still replace our own dial that attached during that `await`.** `network.js:2232-2244`. The accept path checks `peerHello.epoch <= resumable.getEpoch() || resumable.prefersOwnDial()` and then `await`s `writeSessionHello(...)` before it calls `resumable.attach(instance, peerHello.epoch, …)`. `attach` (`network.js:1414`) never re-checks the epoch. It calls `detach(current)` without condition.
   - Here is the input that breaks it. The winner's deference window has just expired, so it accepts the lesser's dial. At the same moment the lesser accepts the winner's dial. Both sides now have a dial at epoch N+1 in flight in both directions. The lesser passes the check, then suspends on the hello write (backpressure on a slow transport). Its own dial completes and attaches at N+1. The resumed accept then detaches that freshly attached instance.
   - Each side then keeps the instance the other side closed. Both see loss and redial at N+2. This heals, but under sustained load it can flap.
   - The redial comment ("no peer dial is accepted after ours lands but before it attaches") guards one direction only.
   - The fix is to re-check `getEpoch()` (or `isAttached()`) after the write, or to make `attach` refuse `newEpoch <= epoch` while `current !== undefined`.
   - [proposed-rule: when an `await` separates an admission check from a state mutation, repeat the check after the `await`, or have the mutator enforce it itself (extends the async-loop abort guard in `roles/jurors/saboteur/AGENT.md`)]

2. **Mitigated: a peer that jumps the epoch far ahead.** `network.js:2225-2235` now accepts any epoch above the current one. The session token and the authenticated initiator key bound the effect to the attacker's own session. Our in-flight redial is discarded by `epoch + 1n !== nextEpoch` (`network.js:1381`), and that path backs off rather than spinning. No action needed. [rule: skills/adversarial-tests/SKILL.md]

3. **Mitigated: equal ephemerals (a peer that echoes ours back).** `crossed-hellos.js:26` breaks the tie on `isInitiator`, which exactly one side holds. Both sides can no longer defer to each other. [rule: skills/adversarial-tests/SKILL.md]

4. **Mitigated, with a comment: a hung `connect` in a one-way partition.** `prefersOwnDial` (`network.js:1697`) limits deference to `sessionTimeoutMs` from the first dial it dropped. A connected dial is bounded by `handshakeTimeoutMs`.
   - The window uses `Date.now()`. If the wall clock jumps backwards, `now - deferringSince` goes negative and the winner keeps refusing past the intended bound. The hard timeout still applies, so this is a liveness delay, not a correctness bug.
   - A monotonic clock, or a timer-driven flag, would remove the clock dependence.
   - [proposed-rule: deadlines that guard liveness use a monotonic source or `setTimeout`, never wall-clock subtraction]

5. **Comment-only: deference resets after every failed dial.** `finally` (`network.js:1370-1373`) clears `deferringSince` whenever `dialing` reaches 0. Redials never overlap, so the "run of redials" in the comment is always a single dial.
   - If `connect` fails after T < `sessionTimeoutMs` each time, the winner refuses the lesser's dials for most of every cycle. It accepts only during its own backoff gaps.
   - The two sides should still converge, but the comment overstates the mechanism. [rule: skills/adversarial-tests/SKILL.md]

6. **Out of scope:** tight-try and JSON located-error. The new `try/finally` in `redial` wraps only the `dial` `await`. No new parsing.

Attacks: 6 (1 real, 4 mitigated, 1 out of scope).
<sub><!--garden-provenance-section-->model <code>claude-opus-5-5</code> · harness <code>claude</code> · provider <code>anthropic</code></sub>
</details>

<details>
<summary><b>purist</b> — comment-only</summary>

**Verdict: comment-only**

The reconnect change doesn't add any passable value, any change to a frozen prototype, or any new opening across the network boundary. The responder's silent close (no answer) stays distinct from its refusal (`epoch: 0n` hello), and both show the peer only what it could already infer. The findings below are about naming and keeping related code consistent.

**Findings**

1. **should-fix — two different "crossed-hello tiebreakers" in one module.** The existing one for simultaneous first contact (`src/network.js:668-673`, also described at `:1816` and `:2153`) keeps the candidate whose *initiator* ephemeral is the **lesser**. The new reconnect tiebreaker (`src/crossed-hellos.js:21-28`) compares *local against peer* ephemerals from the opening handshake, and the **greater** one wins. Both are called "crossed-hello(s) tiebreaker" and both carry the word `tiebreaker`. At `:1918-1919`, the same bytes even appear under two names (`tiebreaker` and `localEphemeral: tiebreaker`). A reader can't tell from the names that the inputs and the direction of the comparison differ. Rename one of them (for example, call the first-contact one a "simultaneous-open" tiebreaker), or add a cross-reference comment explaining why the directions are opposite. [proposed-rule: one name per tiebreaker in a module; a second tiebreaker over the same material must state how it relates to the first]

2. **should-fix — the SYNACK offset is a bare number while the SYN offset has a named helper.** `synack.slice(0, 32)` is written out at `src/network.js:1921` and `:2317`. The matching SYN extraction has its own documented accessor, `tiebreakerFromPrefixedSyn` (`:1820`). Add a matching `ephemeralFromSynack` so the byte layout is documented in one place. [rule: roles/jurors/purist/AGENT.md § Family-consistency across related symbols]

3. **should-fix — the Status note in the design points at the wrong symbol and leaves out a deviation.** `designs/ocapn-noise-session-reconnect.md:26` says the designator comparison is in `prefersOwnDial`. The comparison is actually `initiatesOnCrossedHellos` in `src/crossed-hellos.js`; `prefersOwnDial` holds the deference policy. That policy also isn't listed under "Deviations": the winner gives up the tiebreaker after `sessionTimeoutMs` when none of its own dials has connected, and defers outright while one has. Design § 3 steps 3-4 describe a pure tiebreak. [rule: roles/jurors/purist/AGENT.md § Minimum viable abstraction (state the minimum the abstraction carries)]

4. **comment-only — `prefersOwnDial` is phrased as a question but changes state.** At `src/network.js:1697-1707`, the first call starts the `deferringSince` window. The typedef at `:395-398` says so, but whether the window starts depends on the order and number of calls. Splitting it into a pure query plus an explicit "note a deferred peer dial" step would make it side-effect-free.

5. **comment-only — the new export isn't hardened.** `initiatesOnCrossedHellos` (`src/crossed-hellos.js:21`) has no `harden(...)`. Its sibling `bytewise-compare.js` doesn't either, so the file matches local practice but not the repo rule. [rule: AGENTS.md § `harden()` is mandatory]

6. **comment-only — an avoidable type cast.** `/** @type {{ sessionTimeoutMs: number }} */ (heartbeatSettings)` at `:1704-1706` could read from the `reconnectSettings` already narrowed in that scope. [rule: AGENTS.md § Type-assertion discipline]

Self-improvement: the purist brief could add one more check — when a PR adds a second tiebreaker or ordering rule next to an existing one, compare their inputs and direction, not just their names.
<sub><!--garden-provenance-section-->model <code>claude-opus-5-5</code> · harness <code>claude</code> · provider <code>anthropic</code></sub>
</details>

<details>
<summary><b>wire-watcher</b> — comment-only</summary>

I've finished reading the diff and am writing up the review block.

**Verdict:** comment-only

**Findings**

1. **should-fix: a winner that is one epoch behind can refuse the dial that would catch it up.** Location: `packages/ocapn-noise/src/network.js:2232-2238` together with `prefersOwnDial` at `:1697-1707`.
   - **Before:** a responder answered a stale-epoch hello with a refusal.
   - **Now:** it closes the dial silently. Suppose the responder attached at epoch e+1, but its `op:session-hello` answer was lost before the dialer read it. The dialer stays at e and keeps redialing e+1. Every one of those dials is dropped as `<= getEpoch()`.
   - **How it recovers:** only if the peer notices the loss and redials at e+2.
   - **The problem:** if the stale side is the crossed-hellos winner, `prefersOwnDial()` returns `true` outright whenever `connectedDials > 0`. So it drops the peer's e+2 dial whenever that dial lands while its own doomed e+1 dial is connected. Whether the session recovers then depends on how the two backoff timers interleave, and it can stay down until `hardTimeoutMs`.
   - **Fix:** pass `peerHello.epoch` into `prefersOwnDial`. Return `false` when the peer asks for an epoch beyond `getEpoch() + 1n`, because the peer has proved it is ahead, so deferring to our own dial cannot win.
   - **Test to add:** lose the responder's answer after it attaches, and make the stale side the `greater` ephemeral.

   [proposed-rule: in a crossed-dial tiebreaker, a peer hello carrying a strictly newer epoch than our in-flight dial overrides the tiebreaker]

2. **should-fix: no failure-mode test for the relaxed epoch check.** Location: `network.js:2225-2236`.
   - The responder now accepts any later epoch, and the comment argues this is safe because the session token plus the handshake-authenticated initiator key authorize the resume.
   - Several cases are not pinned by any test:
     - a hello with the correct session and a far-ahead epoch (for example `2n ** 64n`) is accepted, and the next reconnect then needs a still-later epoch;
     - a hello with the correct session token but a different authenticated initiator key is refused (the `reconnectors.get(initiatorKeyHex) === resumable` arm);
     - a hello with a token that differs by one byte is refused.
   - `a peer that no longer holds the session refuses the reconnect` covers only the restarted-peer case.

   [rule: roles/jurors/wire-watcher/AGENT.md § Failure-mode test catalog]

3. **comment-only: the tiebreaker inputs agree on both sides.**
   - The initiator uses `local = SYN[32:64]` and `peer = SYNACK[0:32]`. The responder uses the mirror image (`network.js:1919-1921`, `:2317-2318`), so both sides compute one answer.
   - It rests on authenticated handshake ephemerals rather than on anything said in the hello, so a reconnect hello cannot influence it.
   - The echoed-ephemeral tie falls back to `isInitiator`, and the test at `test/reconnect.test.js:346` pins that tie.
   - No change needed.

4. **comment-only: the deference window uses the wall clock.** `deferringSince` and `now` come from `Date.now()`. If the clock steps backward, the winner can keep deferring past `sessionTimeoutMs`, up to the hard timeout. A monotonic source (`performance.now()` or an injected clock) would bound the window as documented.

   [proposed-rule: protocol timeouts that bound trust or liveness decisions use a monotonic clock]

5. **comment-only:** the design's § Status records the Rekey deviation, where the responder accepts any later epoch instead of only `previous_epoch + 1`. The § 4 cross-reference keeps the spec and the code from silently disagreeing. Good.

Self-improvement: when a responder turns an explicit refusal into a silent close, check whether the dialer still has any signal that it has fallen behind. Check the same thing for every side that can win the tiebreaker.
<sub><!--garden-provenance-section-->model <code>claude-opus-5-5</code> · harness <code>claude</code> · provider <code>anthropic</code></sub>
</details>

<details>
<summary><b>surfacer</b> — comment-only</summary>

**Verdict:** comment-only

The package's public surface is coherent across the four sources. The PR touches none of them in a way that breaks agreement.

**Findings**

1. **[follow-up] The README links to a path outside the published package.** The new "Session reconnect" section links to `../../designs/ocapn-noise-session-reconnect.md`. That resolves in the monorepo but not in the published tarball, because `files` does not include `designs/`. The npm README will show a dead link. Use an absolute GitHub URL, or drop the link and name the design doc in prose. [proposed-rule: links in a package README must resolve inside the published package or be absolute URLs]

2. **[follow-up] The README names the `heartbeat` and `reconnect` options but not where they are declared.** The types are in `src/types.d.ts` (`HeartbeatOptions` plus the reconnect option). The README does not say which constructor option takes them or which `./types` subpath declares them. This is a documentation gap only. The runtime and the types agree, and the `types.d.ts` doc comment was updated to say "either side dials". [rule: roles/jurors/surfacer/AGENT.md, README documented surface]

**Checked and coherent**
- `index.js` and the `package.json` `exports` map are unchanged.
- `src/crossed-hellos.js` is new but internal. It is imported only by `network.js`, not re-exported, and `src` is in `files`. It is not a thunk, and `exports` has no subpath for it, which is correct.
- `Reconnector.prefersOwnDial` and the new `dial(..., onConnected)` parameter live in a JSDoc typedef inside `network.js`, not in the published `.d.ts`, so no declared type drifts from runtime.
- The `types.d.ts` change is prose only. The README's reconnect description matches the new either-side-dials semantics and the tiebreaker.
<sub><!--garden-provenance-section-->model <code>claude-opus-5-5</code> · harness <code>claude</code> · provider <code>anthropic</code></sub>
</details>

Elided for GitHub's size limit: duality-auditor, scribe, corner-prober, fast-checker.

----- END REVIEW BODY -----

---
claim:
  host: endolin-garden-ece02cb4
  gardener: 1
  worker_kind: monk
  tier: 
  provider: anthropic
  model: 
  claimed_at: 2026-10-17T13:55:54Z
