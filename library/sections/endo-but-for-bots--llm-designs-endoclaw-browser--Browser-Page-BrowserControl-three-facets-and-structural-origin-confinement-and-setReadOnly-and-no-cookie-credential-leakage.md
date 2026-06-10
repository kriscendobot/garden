---
title: "designs/endoclaw-browser.md — Browser/Page/BrowserControl three facets + structural origin confinement + setReadOnly + no cookie/credential leakage"
source-slug: endo-but-for-bots--llm-designs-endoclaw-browser
source-url: https://github.com/endojs/endo-but-for-bots/blob/master/designs/endoclaw-browser.md
authors: [Kris Kowal (prompted)]
repo: endojs/endo-but-for-bots
path: designs/endoclaw-browser.md
total-lines: 93
ingest-cycle: 259
ingest-date: 2026-06-10
lane: designs
---

# Browser/Page/BrowserControl three facets + structural origin confinement + setReadOnly + no cookie/credential leakage

A §93-line **Not Started** design (Created 2026-03-03; Updated 2026-03-03). Parent: [endoclaw](endoclaw.md). A confined Playwright-backed browsing capability — the largest cluster member's use-facet so far (Page has 11 methods).

## §Three facets: Browser + Page + BrowserControl

§The-canonical-caretaker-pattern-extended-to-a-derived-cap: §Browser (the entry point) + §Page (derived from `Browser.goto()`) + §BrowserControl (held by host).

```ts
interface Browser {
  goto(url: string): Promise<Page>;
  help(): string;
}

interface Page {
  url(): string;
  title(): Promise<string>;
  textContent(selector: string): Promise<string>;
  querySelector(selector: string): Promise<Element>;
  querySelectorAll(selector: string): Promise<Element[]>;
  fill(selector: string, value: string): Promise<void>;
  click(selector: string): Promise<void>;
  submit(selector: string): Promise<void>;
  snapshot(): Promise<string>;
  waitForSelector(selector: string): Promise<void>;
  help(): string;
}

interface BrowserControl {
  setAllowedOrigins(origins: string[]): void;
  setReadOnly(flag: boolean): void;
  revoke(): void;
  help(): string;
}
```

§Two-method-Browser (goto + help) + §eleven-method-Page (most methods of any use-facet we've ingested in the cluster) + §four-method-BrowserControl (setAllowedOrigins + setReadOnly + revoke + help). §The-Page-is-a-derived-capability — not minted directly by the host, but returned from `Browser.goto()` after origin validation.

§Six-cycles-with-canonical-caretaker-two-facet-pattern (234 + 238 + 244 + 246 + 253 + 259). §First-explicit-observation in library of §a-derived-capability-from-the-use-facet (`Browser.goto()` returns a `Page`) as named pattern. §When-the-use-facet's-API-returns-further-capabilities, §each-derived-capability-IS-also-confined-by-the-original-control-facet's-policy.

§Sibling-pattern-to-cycle-244's-TickResponse-as-one-shot-exo — §two-cycles-with-derived-capability-from-the-use-facet: §cycle-244's-TickResponse (one-shot, returned by the scheduler when delivering a tick) + §cycle-259's-Page (long-lived, returned by `Browser.goto()`). §Two-different-shapes-of-derived-capability (one-shot vs long-lived).

## §Structural origin confinement

§The-Endo-Idiom: *The agent cannot navigate to `https://evil.example.com` to exfiltrate data because the `Browser` exo rejects URLs outside the allowed origins. This is structural — no URL the agent can construct will reach a disallowed origin.*

§Structural-origin-confinement as named discipline. §The-confinement-is-structural-not-policy — §the-Browser-exo-validates-every-URL-before-navigating + §rejection-is-not-best-effort-it-is-by-construction.

§Three-cycles-with-structural-confinement-discipline (234 path-restrictions + 238 origin-allowlist + 259 origin-confinement). §Each-cycle-applies-the-discipline-to-a-different-substrate: §cycle-234-OAuth-path-restrictions + §cycle-238-CLI-HTTP-origin-allowlist + §cycle-259-Browser-origin-confinement.

§Sibling-pattern-to-cycle-238's-the-allowlist-IS-the-strict-by-default-mode — §two-cycles-with-origin-allowlist-as-strict-by-default-substrate-policy (238 + 259).

## §setReadOnly — three named mutation methods disabled

§The-Endo-Idiom: *`BrowserControl.setReadOnly(true)` disables all mutation methods (`fill`, `click`, `submit`).* §Three-named-mutation-methods that the read-only-toggle controls. §Read-only-mode preserves extraction methods (textContent, querySelector, querySelectorAll, snapshot, waitForSelector) but disables mutation.

§Three-cycles-with-setReadOnly-mode-toggle now (226 + 234 + 259) — the discipline recurs across the endoclaw cluster. §Each-cycle's-setReadOnly disables a different set of mutation methods relevant to that capability. §First-explicit-observation in library of §three-cycles-with-setReadOnly-mode-toggle (was previously two: 226 + 234).

§Useful-for-web-research-without-side-effects (the design's stated use case). §When-an-agent's-needs-can-be-decomposed-into-extraction-and-mutation, §the-setReadOnly-flag-IS-the-orthogonal-axis + §the-host-can-grant-extraction-only-without-rewriting-the-capability.

## §Caretaker revocation propagates to derived caps

§The-Endo-Idiom: *The host can revoke the browser capability at any time, closing the Playwright context and invalidating all `Page` references.*

§Revocation-propagates-to-derived-caps. §When-the-Browser-is-revoked, §all-Page-references-derived-from-`Browser.goto()`-are-invalidated-too + §the-Playwright-context-IS-closed-at-revocation-time.

§First-explicit-observation in library of §revocation-propagates-to-derived-caps as named cleanup discipline. §When-a-use-facet-derives-further-capabilities-from-its-API, §revocation-of-the-use-facet-MUST-invalidate-the-derived-caps + §the-substrate-cleanup-IS-part-of-revocation.

§Five-cycles-with-revocation-as-named-permanent-state (238 + 244 + 246 + 253 + 259). §Cycle-259-adds-derived-cap-invalidation as a new dimension.

## §No cookie/credential leakage — three named non-exposures

§The-Endo-Idiom: *The `Page` interface does not expose cookies, localStorage, or network requests. The agent interacts with page content through DOM methods only.*

§Three-named-non-exposures (cookies + localStorage + network requests). §The-agent-interacts-with-page-content-through-DOM-methods-only.

§First-explicit-observation in library of §three-named-non-exposures-on-Page-interface as named confinement-by-omission. §When-a-browsing-capability-could-leak-credentials-via-Cookie-or-localStorage-or-Network-introspection, §omit-those-APIs-from-the-use-facet + §the-omission-IS-the-defense.

§Sibling-pattern-to-cycle-234's-the-agent-never-sees-the-token + cycle-238's-the-controller-and-client-cap-split — §three-cycles-with-explicit-confinement-by-omission (234 token-not-exposed + 238 controller-not-exposed-to-guest + 259 cookies-localStorage-network-not-exposed-to-agent).

## §Eleven-method Page — the largest use-facet yet in the cluster

§Eleven-method-Page is the largest use-facet of any endoclaw-cluster ingest:

| Cycle | Capability | Use-facet methods | Control-facet methods |
|---|---|---|---|
| 234 | OAuth | 4 | 6 |
| 238 | CLI HTTP | 3 | 7 |
| 244 | Timer (Interval) | 3 (+ 6 on derived Interval) | 6 |
| 246 | Webhook | 5 | 4 |
| 253 | Notify | 2 | 3 |
| 259 | Browser | 2 + 11 (derived Page) | 4 |

§Cycle-259-introduces-the-largest-use-facet-via-the-derived-Page. §When-the-substrate-is-the-DOM-and-the-DOM-has-many-relevant-operations, §the-use-facet-grows-to-match + §the-control-facet-stays-compact (still 4 methods).

§First-explicit-observation in library of §use-facet-size-correlates-with-substrate-API-size as named-design-axis.

## §Three-bullet Depends-On with optional dependency

§The-Depends-On-section:

- Playwright or Playwright as a daemon dependency
- Daemon worker infrastructure for headless Chrome lifecycle
- Optional: [daemon-os-sandbox-plugin](daemon-os-sandbox-plugin.md) for additional Chrome process confinement

§Three-bullet-list-with-the-third-marked-Optional. §First-explicit-observation in library of §Optional-prefix-on-Depends-On-bullet as named-dependency-shape. §When-a-dependency-is-not-required-but-recommended-for-defense-in-depth, §prefix-the-bullet-with-`Optional:` + §the-prefix-IS-the-strength-signal.

§Sibling-pattern-to-cycle-253's-Depends-On-bullet-list and cycle-255's-conditional-dependencies — §three-cycles-with-Depends-On-bullet-list-variants (253 standalone + 255 conditional-per-option + 259 with-Optional-prefix). §Three-different-shapes-of-Depends-On-bullet-list.

## §Four named Use-Cases

§Four-named-uses:

1. Flight check-in (navigate to airline, fill form, submit)
2. Web research (navigate to pages, extract text content)
3. Price monitoring (periodically snapshot a product page)
4. Form automation (fill and submit web forms)

§Three-cycles-with-Use-Cases-section-enumerating-named-use-cases (234 + 257 + 259). §The-use-cases-are-concrete-and-each-cites-a-different-substrate-aspect.

## §`snapshot()` returns text or screenshot

§The-`snapshot()`-method's-JSDoc-comment: *returns page text or screenshot*. §Two-named-return-shapes via the same method — §the-method-overloads-its-return-type-by-context.

§First-explicit-observation in library of §two-named-return-shapes-via-same-method-by-context. §When-a-method's-return-can-be-either-of-two-shapes-by-implementation-choice, §the-doc-comment-names-both-shapes + §the-caller-handles-either.

## §The Playwright instance runs with `--no-sandbox` because already in a confined worker

§How-It-Works-step-5: *The backing Playwright instance runs in the daemon worker with `--no-sandbox` (already in a confined worker) or in a separate headless Chrome process.*

§`--no-sandbox`-with-named-justification: §the-Playwright-process-runs-inside-the-daemon-worker-which-is-already-confined + §running-Chrome's-sandbox-on-top-would-double-up + §the-confinement-is-at-the-worker-boundary-not-the-Chrome-process-boundary.

§First-explicit-observation in library of §running-without-platform-sandbox-when-substrate-IS-the-sandbox as named-defense-layering-discipline. §When-a-substrate-IS-the-sandbox, §don't-double-up-with-platform-level-sandbox + §the-substrate-IS-the-confinement-boundary.

## §Borrowable patterns

**Tier-1 (highest borrowing value):**

- §Three-facets: Browser + Page + BrowserControl — a derived capability from the use-facet.
- §A-derived-capability-from-the-use-facet (`Browser.goto()` returns a `Page`).
- §Structural-origin-confinement — the Browser exo rejects URLs outside the allowed origins; structural not policy.
- §setReadOnly with three named mutation methods disabled — third instance of this discipline.
- §Caretaker-revocation propagates to derived caps — invalidates all Page references and closes the Playwright context.
- §No cookie/credential leakage — three named non-exposures on Page interface.
- §Confinement-by-omission — three cycles with this discipline (234 + 238 + 259).
- §Use-facet-size correlates with substrate-API-size (Page has 11 methods because DOM has many relevant ops).

**Tier-2 (design-doc shape patterns):**

- §Three-bullet Depends-On with Optional-prefix on third bullet.
- §`Optional:` prefix on Depends-On bullet as named dependency-shape.
- §Three-cycles-with-Depends-On-bullet-list-variants (253 standalone + 255 conditional-per-option + 259 with-Optional-prefix).
- §Two-named-return-shapes-via-same-method-by-context (`snapshot()` returns text or screenshot).

**Tier-3 (named comparisons):**

- §Three-cycles-with-setReadOnly-mode-toggle (226 + 234 + 259).
- §Three-cycles-with-structural-confinement-discipline (234 path + 238 origin + 259 origin).
- §Three-cycles-with-explicit-confinement-by-omission (234 + 238 + 259).
- §Three-cycles-with-Use-Cases-section-enumerating-named-use-cases (234 + 257 + 259).
- §Five-cycles-with-revocation-as-named-permanent-state (238 + 244 + 246 + 253 + 259).
- §Six-cycles-with-canonical-caretaker-two-facet-pattern (234 + 238 + 244 + 246 + 253 + 259).
- §Seven-cycles-with-explicit-capability-by-construction-discipline (234 + 238 + 244 + 246 + 253 + 257 + 259).
- §Running-without-platform-sandbox-when-substrate-IS-the-sandbox as named defense-layering discipline.

## §Synthesis target — slot machine library

For a slot machine library:

- §Game-machine + game-session + game-control three-facet pattern with game-session derived from game-machine.start().
- §A-derived-capability-from-the-use-facet for §game-session-from-game-machine-start.
- §Structural-game-rule-confinement — game-machine rejects game-actions outside the allowed game-rules.
- §setReadOnly mode for §game-spectator-mode-disables-bet-fold-call (three named mutation methods).
- §Caretaker-revocation propagates to derived game-sessions.
- §No game-secret-leakage — three named non-exposures on game-session interface (game-RNG-seed + game-internal-state + game-network-events).
- §Confinement-by-omission for game-internal-state-not-exposed-to-player.
- §Use-facet-size correlates with substrate-API-size for §game-session-with-many-actions-when-game-has-many-actions.
- §Optional-prefix-on-Depends-On-bullet for §optional-game-defense-in-depth.

## §Library meta-counters

- §Library-reaches-765-sections at cycle 259 (designs-lane endoclaw-browser).
- §Ninety-second-consecutive designs-chat alternation cycle (cycles 166-250 + 252-259; cycle 251 was out-of-band papers).
- §Six-cycles-with-canonical-caretaker-two-facet-pattern (234 + 238 + 244 + 246 + 253 + 259).
- §Seven-cycles-with-explicit-capability-by-construction-discipline (234 + 238 + 244 + 246 + 253 + 257 + 259).
- §Five-cycles-with-revocation-as-named-permanent-state (238 + 244 + 246 + 253 + 259).
- §Three-cycles-with-setReadOnly-mode-toggle (226 + 234 + 259).
- §Three-cycles-with-structural-confinement-discipline (234 path + 238 origin + 259 origin).
- §Three-cycles-with-explicit-confinement-by-omission (234 + 238 + 259).
- §Three-cycles-with-Use-Cases-section-enumerating-named-use-cases (234 + 257 + 259).
- §Three-cycles-with-Depends-On-bullet-list-variants (253 standalone + 255 conditional-per-option + 259 with-Optional-prefix).
- §First-explicit-observation of six patterns: §a-derived-capability-from-the-use-facet + §revocation-propagates-to-derived-caps + §three-named-non-exposures-on-Page-interface (confinement-by-omission) + §use-facet-size-correlates-with-substrate-API-size + §Optional-prefix-on-Depends-On-bullet + §running-without-platform-sandbox-when-substrate-IS-the-sandbox + §two-named-return-shapes-via-same-method-by-context.

(Kris Kowal (prompted) authored)
