---
title: Three-layer dispatch chain as imperfect ponyfill with Eval-Twin defense via registered symbol, infinite-regress check, and throw-rather-than-infinite-loop with reasoned justification — @endo/panic index.js + README.md
source: endo packages/panic/{index.js,README.md,SECURITY.md,CHANGELOG.md}
source-slug: endo--packages-panic
ingest-cycle: 197
ingest-date: 2026-06-06
lane: chat
authors: [Mark Miller, Kris Kowal]
keywords:
  - ponyfill-vs-shim distinction
  - Eval Twin Problem
  - registered-symbol vs novel-subclass
  - three-layer dispatch chain
  - infinite-regress check
  - throw-rather-than-infinite-loop
  - lastResortError as identity check (forgeable + non-forgeable both honestly named)
  - prepare-commit-transactional-pattern as canonical use-case
  - Don't Remember Panicking TC39 proposal
  - PanicEndowmentSymbol following passStyleOfEndowmentSymbol precedent
  - default-erroneous-exit + no-ambient-normal-exit
  - historical-note-explaining-why-ambient-panic-no-longer-loses-security
related:
  - endo--packages-pass-style (sibling: PassStyleOfEndowmentSymbol precedent + Eval Twin Problem)
  - endo--packages-errors (panic README: makeError/X/q template tag)
  - endo--packages-marshal-src-marshal-justin-and-marshal-stringify-js (cycle 189: also cites Eval Twin defenses + qp-vs-q template tag pair)
  - endo--packages-init-and-lockdown (cycle 183: two-phase init also depends on SES primordials)
---

# @endo/panic — three-layer dispatch chain as imperfect ponyfill with Eval-Twin defense, infinite-regress check, and throw-rather-than-infinite-loop with reasoned justification

## Source

- `endo packages/panic/index.js` — 75 lines (one default export `panic`, one symbol export `PanicEndowmentSymbol`, one identity export `lastResortError`)
- `endo packages/panic/README.md` — 58 lines (canonical-use-case + ponyfill-vs-shim distinction + three-layer explanation + design rationale)
- `endo packages/panic/CHANGELOG.md` — 11 lines (v0.2.0 introduced 2025-06-02 via PR [#2815](https://github.com/endojs/endo/pull/2815))
- `endo packages/panic/package.json` — name `@endo/panic`, version `1.0.1`, `type: module`, single `main`/`module`/`exports` entry pointing at `./index.js`.

Cycle 197 of `/loop resume the librarian work.` (chat-lane; alternates from cycle 196's designs-lane endoclaw.md; §thirty-first consecutive designs/chat alternation cycle 166-197).

## Single most structurally interesting move

§three-layer-dispatch-chain-as-imperfect-ponyfill — `panic(err)` is the ponyfill for the TC39 proposal "[Don't Remember Panicking](https://github.com/tc39/proposal-oom-fails-fast)" whose semantics are *terminate the agent immediately so its internal data state (stack and heap) become unobservable*. JavaScript has no portable primitive that achieves that. So this ponyfill tries three increasingly-imperfect approximations in order, and explicitly throws-instead-of-infinite-loop as the last resort with §a-reasoned-justification.

The three layers, in order:

1. **§Registered-symbol delegation**: look up `globalThis[PanicEndowmentSymbol]`; if function, call it. (`PanicEndowmentSymbol = Symbol.for('@endo panic')` — registered, so all instances of this package in a single agent share the same symbol — see [Agoric/agoric-sdk Draft PR #11173 Don't remember panicking](https://github.com/Agoric/agoric-sdk/pull/11173) for swingset-liveslots integration.)
2. **§Platform-specific immediate-exit**: currently only `globalThis.process.abort()` (Node). README names this as growable as the team becomes aware of similar primitives on other platforms.
3. **§Last-resort `throw lastResortError`** — explicitly violates the spec but is the only remaining option once you reject the "infinite loop" alternative (see §throw-rather-than-infinite-loop-with-reasoned-justification).

Between layers 2 and 3 there's an additional §Moddable-XS-branch: if `typeof globalThis.panic === 'function' && panic !== globalThis.panic` then defer to that. This is the §infinite-regress-defense (a future shim built on the same ponyfill might install its own `globalThis.panic = panic` from this module, and a naïve check would create an infinite call cycle).

## §Ponyfill-vs-shim distinction named explicitly in the README

> By "ponyfill" vs "shim", we mean that a ponyfill does not modify the primordial intrinsics/built-ins, but rather just exports its new functionality as conventional package/module exports. By contrast, a "shim" does modify the primordial intrinsics/built-ins as needed to most closely emulate the proposal it shims.

The README continues:

> Our normal style for a package that emulates a proposal is to default-export the ponyfill, and then when ready, separately export the shim built on that ponyfill.

§Two-stage-rollout-discipline: §ponyfill-first-then-shim. The README acknowledges that v1.0.1 is too early for the shim because the TC39 proposal hasn't advanced enough. §Honest-deferral-of-the-shim. Sibling pattern to cycle 187's shim+prepare-endo cluster which used two shim strategies (declare-and-then-shim vs shim-on-import).

§Important-consequence: "a ponyfill by itself is subject to the [Eval Twin Problem](https://github.com/endojs/endo/issues/1583), whereas a shim is not." The §Eval-Twin-Problem-as-the-cost-of-being-a-ponyfill is explicit. The choice to mitigate via §registered-symbol (rather than a novel `class PanicError extends Error`) is the design's load-bearing move.

## §Eval-Twin-defense-via-registered-symbol (modeled on PassStyleOfEndowmentSymbol)

From the source comment:

> Modeled on `PassStyleOfEndowmentSymbol` of `@endo/pass-style`.

The Eval Twin Problem (issue #1583) is the failure mode where two copies of the *same* package (loaded by two compartments / two import paths / two iframes) end up with different identities. A `class FooError extends Error` defined by one copy will not be `instanceof FooError` to the other copy's check — `===` on the class is different. A registered symbol (`Symbol.for(...)`) is **the** canonical fix: registered symbols are globally interned per-agent, so all twins share the same key. The forgeability is the price of that compatibility (anyone can create an object with the same symbol property; the symbol is not a capability).

The design names this trade-off honestly:

> However, as a necessary price for avoiding Eval Twin Problems, this marking is forgeable -- anyone can create and throw a similar error.

And it offers a §second-identity-check that is §non-forgeable but with §false-negatives:

> We also export this error so that importers can use it as an identity check. This is not forgeable, i.e., not give false positives, but due to the Eval Twin Problem, may produce false negatives. Use this identity check with caution.

§Two-identity-checks-with-explicitly-named-trade-offs: §PanicEndowmentSymbol-property-presence is §forgeable-but-twin-safe; §`===` lastResortError-import-comparison is §non-forgeable-but-twin-vulnerable. Both are exported so the consumer chooses. §Library-pattern: §when-mitigating-Eval-Twin-document-both-trade-offs-so-consumer-can-choose.

## §The Moddable-XS infinite-regress check

```js
} else if (
  typeof globalThis.panic === 'function' &&
  panic !== globalThis.panic
) {
  // Primarily for Moddable XS.
  ...
  globalThis.panic(err);
}
```

The comment is unusually long for a single branch. It anticipates a §future-shim that takes this ponyfill's `panic` and installs it at `globalThis.panic`. Without the §`panic !== globalThis.panic` guard, the shim's installation would create an infinite call cycle: this ponyfill's `panic` would defer to `globalThis.panic` which would be this ponyfill's `panic` which would defer to `globalThis.panic`...

> In an Eval Twins scenario, the first to import the shim will cause that shim to install its own `globalThis.panic` from its ponyfill, and then its ponyfill would skip this case. All other instances of this package would then defer to the whose shim ran first.

§Eval-Twins-as-the-shim-coordination-mechanism — the first-to-load-wins-and-installs pattern, and all other twins defer to it. Subtle but the comment names it: §"defer to the whose shim ran first" (typo in source).

§Defense-against-self-referential-shim-installation is a pattern worth borrowing wherever a ponyfill might later become its own shim.

## §Throw-rather-than-infinite-loop with reasoned justification

The README explicitly considers and rejects the alternative:

> (As noted in the proposal, a higher fidelity emulation could, as a last resort, go into an infinite loop. But the consequences of this are too painful for both manual and CI testing. Besides, on some engines (browsers), in violation of the current JS spec, resume execution of user-code within the agent after the "infinite" loop exceeds a timeout. So even this strategy would not be safe on such engines.)

§Two-reasons-stacked:
1. **§CI-and-manual-testing-pain** — an infinite loop is *worse* than a thrown error for developers. The developer-experience argument is given equal weight to the security argument.
2. **§Browser-spec-violation-makes-infinite-loop-unsafe-too** — some browsers cap the infinite loop at a timeout and resume user-code. So even the "higher fidelity" alternative isn't actually higher fidelity on those engines.

§The-honest-naming-of-the-imperfection: the package is called `@endo/panic`, the README calls it "imperfect ponyfill" in the very first sentence, and the very last paragraph cautions:

> Because this `panic` ponyfill will, as a last resort, throw an error, users of this ponyfill on a platform where the first two strategies might fail, should cope with this possibility of the resumption of user-mode execution as best they can.

§Caveat-emptor-at-the-end: §the-library-does-not-promise-what-it-cannot-deliver. Sibling pattern to cycle 187 lockdown's NOTE-TO-REVIEWERS — both name the cost honestly.

## §Prepare-commit-transactional-pattern as canonical use-case

The README's primary worked example is the §all-or-none transaction:

```js
function transaction() {
  // prepare phase with no side effects, which might exit early with `return`
  // or `throw`. Such an early exit is the "none" of "all or none" side effects.
  prepare();
  try {
    // commit phase, where exit by `throw` must not happen, so all side effects
    // expressed by normal *local* control-flow happen.
    localSideEffect1();
    localSideEffect2();
  } catch (err) {
    // Neither "all" or "none" happened, leaving behind unrecoverable corrupt
    // local data, which therefore must not be observable to user code.
    panic(Error(`unrecoverable transaction fail due to ${err}`));
  }
}
```

§Prepare-commit-with-panic-on-mid-commit-throw is the §canonical-pattern-for-using-panic-correctly. The comment explicitly aligns:
- §prepare-phase: early exit OK (= "none" side of all-or-none)
- §commit-phase: §should-be-straight-line-no-control-flow §to-make-set-of-side-effects-clear
- §exception-in-commit: §unrecoverable-state-must-not-be-observable → `panic`

The pattern matches cycle 162's Ken-properties (§atomic-checkpoint) and cycle 194's daemon-endo-rust-sqlite (§re-prepare-instead-of-caching-Statement) — three different libraries, three different storage layers, three implementations of the same §all-or-none-transactional-discipline. The §panic-as-the-escape-hatch-for-when-commit-detects-impossible-state is the contribution @endo/panic makes to the pattern.

The README then offers an §upgrade-path: if `@endo/errors` is also available, use `makeError(X${...}${q(err)})` for §better-diagnostic-on-the-ses-console. §Cross-package-composition is named.

## §Default-erroneous-exit + no-ambient-normal-exit asymmetry

The README's last paragraph is a §security-rationale-paragraph:

> If `panic` can immediately exit, then, if in an environment that distinguishes normal exit vs erroneous exit, `panic` always causes an erroneous exit. By contrast, we do not propose for there to be any similarly ambient form for normal non-erroneous exit, because that should be a privilege to be granted explicit by an object-capability.

§Asymmetry-with-rationale: §erroneous-exit-is-ambient (because: see historical note below); §normal-exit-must-be-capability-granted (because: §process-spawning-and-graceful-shutdown-are-rights-not-defaults).

The historical note that follows is striking — it admits the team *changed its mind*:

> Historical note: Before this proposal, we had been treating the ability to erroneously exit as an explicit privilege as well. But we are not in a position to prevent user code from going into an infinite loop, which is at least as bad as an erroneous exit. Thus, there is no further loss in security by providing an ambient `panic` operation.

§The-§"no-further-loss-in-security"-argument: §if-the-untrusted-party-can-already-DoS-via-infinite-loop, §denying-them-erroneous-exit-as-well-buys-nothing. §Honest-design-evolution recorded in the README — this is a §retroactive-justification-paragraph that names the prior position before naming the new one. Sibling to cycle 178 daemon-xs-worker-snapshot's §Revised-scope-2026-04-15 and cycle 192's engo-vs-endor §implicit-supersedes (engo did *not* document the supersedes explicitly; @endo/panic *does*).

## §Five-line-control-flow-table

| Layer | Branch condition | Action | Notes |
| --- | --- | --- | --- |
| 0 | `globalThis.console.error` is function | log diagnostic via `console.error('Panic', err)` | §best-effort-not-required-for-correctness; fall through afterward |
| 1 | `globalThis[PanicEndowmentSymbol]` is function | `globalThis[PanicEndowmentSymbol](err)` | §the-Eval-Twin-safe-delegation-path; expected for swingset-liveslots |
| 2 | `globalThis.process` exists and `.abort` is function | `globalThis.process.abort()` | §the-Node-path; non-zero exit code |
| 3 | `typeof globalThis.panic === 'function'` AND `panic !== globalThis.panic` | `globalThis.panic(err)` | §the-Moddable-XS-path; §infinite-regress-defense via identity check |
| 4 | (fallthrough) | `throw lastResortError` | §the-last-resort; violates spec but documented |

Layer 0 is *not* gated — it always runs first if the predicate matches, then falls through to the next four layers (which are mutually exclusive `else if` branches). §Diagnostic-logging-is-orthogonal-to-termination-strategy: §even-if-termination-fails-the-diagnostic-was-recorded.

§TODO-in-the-source for §Moddable-XS-print-function: the team knows there's a path to add a logging-fallback for XS but can't reliably distinguish `print` in Moddable from `print` in browsers. §Honest-named-deferred-work.

## §`Object.freeze` discipline

```js
Object.freeze(lastResortError);
// ...
Object.freeze(panic);
```

Both exports are §frozen-but-not-hardened. Sibling to cycle 146 E.js's §freeze-but-not-harden-the-proxy-target (both cite §preparing-for-stabilize-doc rationale). The author cannot use `harden` here because `@endo/panic` is loaded before SES might have run lockdown; freezing without `harden` provides §non-trapdoor-immutability without depending on the SES whitelist.

§Why-freeze-`panic`: §so-attackers-cannot-monkey-patch-the-exported-function to swap it for something that returns rather than terminates. §Why-freeze-`lastResortError`: §so-the-identity-check-cannot-be-spoofed-via-property-replacement.

## §Comment-density per line

@endo/panic is comment-heavy. Of 75 lines in `index.js`:
- ~25 lines are JSDoc and pure-comment lines
- ~17 are blank
- ~33 are executable

§Two-thirds-of-the-file-is-prose-rationale. The package is small not because the design is shallow but because §each-line-required-a-paragraph-of-rationale. The README adds another 58 lines of prose. Total prose vs code is roughly 5:2 — §the-knowledge-density-is-deliberately-in-the-text-not-the-tokens.

This puts @endo/panic in the §small-files-with-large-knowledge-density family alongside cycles 165 (where), 167 (where index.js), 169 (where browser-stub), 171 (where node), 173 (where xs), 175 (harden-selector), 177 (lockdown-noop), 179 (lp32), 181 (base64), 183 (init + lockdown), 185 (check-bundle), 187 (shim+prepare-endo cluster), 189 (marshal-justin), 191 (zip src cluster), 193 (compartment-wrapper), 195 (cli/src utility cluster). §Fourteenth-member of the family.

## §Future-work-named-in-source

The package's own design documents §three-future-extensions explicitly:
1. **§Shim-export**: "once the proposal gets farther along in the tc39 stage process, we will likely add a `panic-shim` export to this package."
2. **§Platform-specific-immediate-exit-on-other-platforms**: "As we become aware of similar functionality on other platforms, we expect to add them here."
3. **§Moddable-XS-print-function-detection**: TODO comment in source.

§Roadmap-in-the-readme is honest about §what-is-deferred-and-why. Sibling pattern to cycle 161 daemon-capability-filesystem's §Seven-Open-Questions and cycle 196 endoclaw's §gap-priority-classification.

## §Borrowable patterns (tier-1)

1. **§Three-layer-dispatch-chain-as-imperfect-ponyfill** — when a primitive isn't portable, try N approximations in order with documented fallback semantics.
2. **§Eval-Twin-defense-via-registered-symbol** following PassStyleOfEndowmentSymbol precedent — `Symbol.for(...)` for cross-twin identity; novel-subclass-for-identity-is-anti-pattern.
3. **§Two-identity-checks-with-named-trade-offs**: forgeable + twin-safe vs non-forgeable + twin-vulnerable. Export both so the consumer chooses.
4. **§Infinite-regress-defense via identity check** (`thisFn !== globalThis.fn`) for when your ponyfill might be installed as the very global it's checking for.
5. **§Throw-rather-than-infinite-loop with reasoned justification** — name the alternative, name why CI/dev-experience and browser-spec-violation rule it out.
6. **§Ponyfill-vs-shim-distinction named explicitly** with §two-stage-rollout-discipline (ponyfill first, shim later when the proposal advances).
7. **§Prepare-commit-transactional-pattern with panic-as-mid-commit-escape** — three-phase shape (prepare / try-commit / catch-panic) for unrecoverable-state-must-not-be-observable.
8. **§Default-erroneous-exit + no-ambient-normal-exit** asymmetry as a security stance; §"no-further-loss-in-security" argument when ambient functionality is debated.
9. **§Honest-design-evolution-in-the-README** — when the team's stance has changed, document the prior position alongside the new one.
10. **§Two-thirds-prose-one-third-code** comment density discipline for small files that carry large design decisions.
11. **§Caveat-emptor-at-the-end** of the README — name the platforms where the imperfect ponyfill is most imperfect.
12. **§Freeze-but-not-harden** for pre-lockdown packages that need integrity but cannot depend on SES whitelist.
13. **§Cross-package-composition** named in README: optional upgrade path that uses `@endo/errors` for better diagnostics when available.
14. **§Roadmap-in-the-README** — three named future-extensions with §what-blocks-them.

## §Synthesis-target

Slot machine library §panic-equivalent: §if-the-deck-state-becomes-impossible (e.g. integrity hash mismatch between two replicas, or a transaction's commit detects pre-condition failure), §do-not-resume-as-if-nothing-is-wrong. The §three-layer-dispatch-chain pattern adapts directly: registered-symbol delegation first (let the embedder install a panic handler), platform-immediate-exit second, throw-with-identity-check as the documented imperfect fallback. §Eval-Twin-defense applies if the slot machine library is loaded into multiple compartments. §Prepare-commit-with-panic-on-mid-commit-throw is the canonical shape for any §multi-step-side-effecting-transaction in slot machines (e.g. payout computation + ledger write + UI update).

## §Eighteenth-cycle-of-§small-files-with-large-knowledge-density family discipline

(166 daemon-mount + ...) — actually let me recount. The family I named in cycle 189 was: 165, 167, 169, 171, 173, 175, 177, 179, 181, 183, 185, 187, 189. That's 13 chat-lane cycles in the family. Plus cycles 191 (zip), 193 (compartment-wrapper), 195 (cli/src utility cluster), and now 197 — four more chat-lane additions makes 17. §Seventeenth-member-of-§small-files-with-large-knowledge-density family (not 14th as I wrote in §Comment-density above; the family is cycle-defined not source-defined). Let me correct: §@endo/panic is the §seventeenth-chat-lane-source in this family running 165-197.

## §Cycle 197 meta-observations

§The-thirty-first-consecutive-designs/chat-alternation-cycle 166-197.

§Papers-lane-blocked 91+ consecutive cycles (since cycle ~106 when the last papers-lane source was successfully ingested). §The-rotation-discipline gracefully pivots away from papers-lane every cycle.

§Library-reaches-702-sections at cycle 197.
