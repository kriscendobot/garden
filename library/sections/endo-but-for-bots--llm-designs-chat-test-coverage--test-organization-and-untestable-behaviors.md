---
title: How the chat package's tests are organized across `helpers/` + `unit/` + `component/` + `e2e/`; the mock-powers Far()-remotable test fixture; happy-dom for component tests with the *DOM-globals-must-be-set-before-importing-chat-modules* constraint; the three classes of *untestable-with-happy-dom* behavior that require a full browser (token autocomplete in contenteditable, Monaco editor cross-window messaging, WebSocket connection)
source: designs/chat-test-coverage.md
source_repo: endojs/endo-but-for-bots
source_branch: llm
source_commit: 3b031592e5f97a86e317cb96f1b7c44abb4e41f9
source_date: 2026-03-02
source_authors: [Kris Kowal]
topics: [chat-ui, testing]
status: current
notes: |
  **Status: Complete** upstream. Extracted from
  `packages/chat/DESIGN.md`. This section captures the test-organization
  cluster: directory layout (helpers / unit / component / e2e); the
  mock-powers Far()-remotable approach; happy-dom with the
  DOM-globals-before-import discipline; and the explicit enumeration of
  three test surfaces that *cannot* be tested with happy-dom and
  require Playwright (token-autocomplete-in-contenteditable; Monaco-
  editor-cross-window-messaging; WebSocket-connection).
---

## Abstract

§Test Organization establishes the `packages/chat/test/` directory layout: `index.test.js` (infrastructure verification); `helpers/` (`mock-powers.js` + tests for the mock itself; `dom-setup.js` for happy-dom; `keyboard-events.js` for event simulation); `unit/` (eight pure-logic test files — command-registry, command-executor, message-parse, ref-iterator, time-formatters, markdown-render, value-render); `component/` (seven happy-dom-based component tests — send-form, two petname-path-autocomplete variants, inline-command-form, monaco-wrapper protocol docs, form-request-inbox, spaces-gutter-home); `e2e/` (Playwright tests requiring a real browser). §Testing Approach makes two structural commitments: (1) **mock powers via `Far()` remotable** — `makeMockPowers()` returns a Far-remotable that *simulates the daemon's powers interface*, *tracks method calls, supports async iteration, and can be configured with initial names, values, and IDs*; (2) **happy-dom with global setup before chat-module imports** — *happy-dom provides a lightweight DOM implementation; global setup is done BEFORE importing chat modules because they reference DOM globals at module load time*. §Untestable Behaviors enumerates three specific behaviors that *cannot be tested with happy-dom due to Selection API limitations*: (1) **token autocomplete in contenteditable** — *typing `@`, filtering suggestions, arrow navigation, and Escape to close menu all require the browser's Selection API for cursor positioning in contenteditable elements*; (2) **Monaco editor integration** — *runs in an iframe with cross-window messaging*, requiring a real browser; (3) **WebSocket connection** — *requires actual or mock server*. The §Untestable framing is honest about the test surface's limits: *these behaviors require Playwright for proper E2E testing*. The three-class enumeration is a worked example of the *what-can-be-tested-where* discipline: pure logic → unit tests; DOM-event-driven UI → component tests under happy-dom; Selection-API-or-iframe-or-network → E2E tests under Playwright.

## Body

### §Test Organization — directory layout that maps to test-runtime requirements

The chat package organizes tests by *required test-runtime*:

```
test/
  index.test.js              # Infrastructure verification
  helpers/
    mock-powers.js           # Mock daemon powers for testing
    mock-powers.test.js      # Tests for the mock itself
    dom-setup.js             # happy-dom setup utilities
    keyboard-events.js       # Keyboard event simulation
  unit/
    command-registry.test.js # Command definitions and utilities
    command-executor.test.js # Command execution logic
    message-parse.test.js    # Message parsing for @references
    ref-iterator.test.js     # Remote async iterator wrapper
    time-formatters.test.js  # Date/time formatting
    markdown-render.test.js  # Markdown parsing and rendering
    value-render.test.js     # Value rendering and type inference
  component/
    send-form.test.js        # Send form component state
    petname-path-autocomplete.test.js  # Single path autocomplete
    petname-paths-autocomplete.test.js # Multi-path chip autocomplete
    inline-command-form.test.js        # Inline command form rendering
    monaco-wrapper.test.js             # Monaco postMessage protocol docs
    form-request-inbox.test.js         # Form-request message workflow
    spaces-gutter-home.test.js         # Home space config, context menu, modal
  e2e/                       # Playwright tests (requires real browser)
    README.md                # E2E test documentation
    token-autocomplete.spec.ts  # Token @mention autocomplete
    monaco-editor.spec.ts       # Monaco editor integration
```

The structural reading:

- **`helpers/`** contains shared test infrastructure — mock daemon powers, happy-dom setup, keyboard event simulation. Tests for the helpers themselves live alongside (`mock-powers.test.js`).
- **`unit/`** contains pure-logic tests with no DOM dependency — command parsing, message parsing, time formatting, markdown rendering, value rendering. These run fastest and have no DOM scaffolding.
- **`component/`** contains DOM-component tests using happy-dom — send-form, autocomplete, inline-command-form, etc. These require the happy-dom setup but no real browser.
- **`e2e/`** contains Playwright tests requiring an actual browser — token-autocomplete and Monaco-editor integration tests use `.spec.ts` (TypeScript) extension, distinguishing them from the `.test.js` (JavaScript) pattern used elsewhere.

The directory split is *not arbitrary* — it maps to *required test-runtime*:

| Directory | Required runtime | Test count (per §Test Count by Module) |
|---|---|---|
| `helpers/` | Node + happy-dom | 10 (mock-powers verification) |
| `unit/` | Node | 155 (across seven files) |
| `component/` | Node + happy-dom | 79 (across seven files) |
| `e2e/` | Node + Playwright + real browser | 39 (across two spec files) |

The split lets the CI run faster suites first (unit) and slower suites last (e2e), failing-fast on the cheapest tests.

### §Testing Approach — mock powers + DOM-globals-before-import discipline

#### Mock Powers via Far() remotable

The §Testing Approach subsection establishes the *Far()-remotable mock daemon powers* pattern:

> **Mock Powers**: The `makeMockPowers()` function creates a `Far()` remotable that simulates the daemon's powers interface. It tracks method calls, supports async iteration, and can be configured with initial names, values, and IDs.

The structural choice: **the mock is a `Far()`-remotable, not a plain JavaScript object**. Why? Because the chat code's call sites use `E(powers).method(...)` — the eventual-send pattern. If the mock were a plain object, the `E(...)` machinery would treat it as a near-reference and short-circuit some behaviors that the chat code depends on. The `Far()`-remotable shape ensures the mock behaves *exactly like a remote daemon* from the chat code's perspective.

The mock's responsibilities:

1. **Track method calls** — record which methods were called, with what arguments. Tests can then assert on the call history.
2. **Support async iteration** — many daemon methods return async-iterable streams (per cycle 89's `chat-voice-command-parser` notes on the eventual-send pipeline). The mock supports the same protocol.
3. **Configurable initial state** — *names, values, and IDs*. Each test sets up the mock's initial state to match the scenario being tested.

#### happy-dom + DOM-globals-before-import

The §Testing Approach subsection's second commitment:

> **DOM Testing**: happy-dom provides a lightweight DOM implementation. Global setup is done BEFORE importing chat modules because they reference DOM globals at module load time.

The structural reading:

- **happy-dom is lighter than jsdom** — faster startup, smaller memory footprint, sufficient for most component tests.
- **DOM globals must be installed before chat-module imports** — chat modules reference `document`, `window`, etc. at module-load time (per the §1 SES_light constraints around top-level imports). If happy-dom's globals aren't installed when the chat module is imported, the import fails or the module captures `undefined` for the globals.

The structural fix: `helpers/dom-setup.js` is imported *first* in every test file that needs the DOM. The import has side effects that install `globalThis.document`, `globalThis.window`, etc. before any chat-module import.

The §Testing Approach pattern generalizes: *side-effecting setup imports must precede the module-under-test's imports*. This is a hardened-JavaScript-friendly version of the *fixture-before-test* discipline.

### §Untestable Behaviors — three classes that require a full browser

The §Untestable Behaviors subsection enumerates *three classes* of test surface that cannot be exercised under happy-dom:

#### Class 1: Token autocomplete in contenteditable

> **Token autocomplete in contenteditable**: Typing `@`, filtering suggestions, arrow navigation, and Escape to close menu all require the browser's Selection API for cursor positioning in contenteditable elements.

The structural reason: **contenteditable selection management depends on the browser's Selection API**, which happy-dom does not implement fully. happy-dom provides a basic Selection API stub, but the cursor-positioning behaviors that the autocomplete depends on (where the `@` is; where to insert the chip; what to delete on Backspace) require the real browser's selection model.

The §Untestable framing is honest about *which specific operations fail*: typing `@`, filtering, arrow navigation, Escape. All of these depend on cursor position; happy-dom cannot reliably simulate cursor position in contenteditable.

#### Class 2: Monaco editor integration

> **Monaco editor integration**: Runs in an iframe with cross-window messaging.

The structural reason: **Monaco runs in an iframe**, and the chat code communicates with Monaco via `postMessage` across the iframe boundary. happy-dom does not implement cross-window `postMessage` correctly; the iframe-message round-trip cannot be tested without a real browser.

The mitigation: **the protocol is documented in `component/monaco-wrapper.test.js`** — even though the actual integration cannot be tested under happy-dom, the *expected* postMessage protocol is captured as documentation-as-tests. The behavior tests run under Playwright.

#### Class 3: WebSocket connection

> **WebSocket connection**: Requires actual or mock server.

The structural reason: **WebSockets are stateful network connections** that require either a real server (which the component-test runtime can't provide on demand) or a sophisticated mock (which the test suite hasn't built). The connection-establishment, message-routing, and reconnection behaviors are not tested at the component level.

The mitigation: **WebSocket-dependent behaviors live in the daemon-connection layer**, which is tested separately by the daemon's own test suite. The chat package's tests *mock the daemon powers* and assume the daemon-WebSocket layer works correctly.

### The structural lesson — Playwright fills the gaps

The §Untestable Behaviors subsection closes with:

> These behaviors require Playwright for proper E2E testing.

The structural lesson: **the chat test surface decomposes into three runtime-budget classes** — pure-logic unit tests (fast, deterministic, no DOM); happy-dom component tests (moderate, DOM-mocked, no real browser); Playwright E2E tests (slow, deterministic, real browser). The decomposition is *not based on what should be tested*, but on *what can be tested where*.

The three classes correspond to a *cost-tier hierarchy*: unit tests run *every commit* in CI; component tests run *every commit* with slightly more setup; E2E tests run *less often* (typically pre-merge or in nightly CI) because of the browser-startup cost.

This decomposition is the contemporary best-practice for component-based frontend testing. The chat package's design extracts the cost-vs-coverage trade-off explicitly into the directory layout.

## Connection to the wider library

This section is the **canonical *test-decomposition-by-required-runtime* worked example** at the chat-UI level. Three threads:

1. **The Far()-remotable mock-daemon-powers pattern** generalizes to any chat-or-daemon-adjacent test. The library can cite this section whenever a test design needs to mock the daemon's powers interface.

2. **The DOM-globals-before-import discipline** is a hardened-JavaScript-friendly version of the *fixture-before-test* pattern. Reusable for any module that references globals at module-load time.

3. **The three-class enumeration (pure-logic / happy-dom-component / Playwright-E2E)** is the canonical decomposition for component-based frontend testing. Any chat-or-frontend test design should make this decomposition explicit.

## Translation block (design idiom → contemporary practice)

| Design concept | Contemporary practice |
| -------------- | --------------------- |
| Far()-remotable mock daemon | Test infrastructure that mimics the eventual-send pattern; structurally analogous to GraphQL/RPC mocking. |
| happy-dom global setup before chat imports | The *side-effecting-setup-import-first* discipline; reusable for any DOM-dependent module. |
| Selection API limitations in happy-dom | A standard happy-dom caveat; documented across the testing community. |
| iframe cross-window messaging requires Playwright | A common Playwright use-case; postMessage flows across iframes are testable only with a real browser. |
| WebSocket connection requires mock server | The daemon-test-suite's responsibility; chat tests mock the daemon-powers layer above. |
| Three-class cost-tier hierarchy | Unit (cheap) / Component (moderate) / E2E (expensive); the standard frontend-test cost decomposition. |

## See also

- [[chat-ui]] (topic) — the broader chat-UI surface this test suite covers.
- [[testing]] (topic) — the broader test-discipline surface.
- `endo-but-for-bots--llm-designs-chat-test-coverage--e2e-test-coverage-and-module-count-summary` — the next section in this source: E2E tests (Playwright) + test count tables.
- `endo-but-for-bots--llm-designs-chat-playwright-smoke--*` (cycle 86) — the *narrow CI guard* that complements this broader test suite; the playwright-smoke targets *the bundle builds and loads*, while this suite targets *the loaded UI behaves correctly*.
- `endo-but-for-bots--llm-designs-chat-voice-command-parser--design-decisions-test-plan-and-open-questions` (cycle 89) — the chat-voice-command-parser test plan composes with this broader test suite via the *stub SpeechRecognition* approach.
- `endo-but-for-bots--llm-designs-chat-command-bar` — the command-bar component whose tests live under `component/inline-command-form.test.js`.
- `endo-but-for-bots--llm-designs-chat-spaces-gutter` — the spaces-gutter design whose tests live under `component/spaces-gutter-home.test.js`.

## Common confusions

- **"happy-dom is jsdom."** They are different libraries with different trade-offs: happy-dom is *faster but less complete*; jsdom is *slower but more complete*. The chat test suite picks happy-dom for the cost-tier-hierarchy reason — component tests should be *fast enough* to run on every commit, which happy-dom enables.
- **"The mock-daemon Far() is overkill — a plain object would do."** A plain object would behave subtly differently when accessed via the `E(...)` eventual-send pattern. The `Far()` shape ensures the mock is indistinguishable from a real remote daemon from the chat code's perspective. The cost is small; the fidelity benefit is substantial.
- **"Selection API limitations are happy-dom's fault."** It is happy-dom's *intentional minimalism* — supporting the full Selection API would slow happy-dom down and most use cases don't need it. The chat test suite *accepts the limitation* and pushes the relevant tests to E2E.
- **"All chat tests should run in Playwright."** The cost-tier argument: Playwright is *much slower* than happy-dom (browser startup ~1-5 seconds vs happy-dom startup ~10-100ms). Running 244 unit/component tests under Playwright would be prohibitive for every-commit CI. The decomposition favors fast tests for fast feedback.
- **"DOM-globals-before-import is a JavaScript quirk."** It is a *hardened-JavaScript-friendly version* of fixture-before-test. The constraint comes from how SES + Compartment + chat-module structure work: top-level imports execute synchronously, so any global the imports depend on must already be set.
- **"The 7 untestable behaviors break the test suite's value."** The decomposition is explicit: *what cannot be tested here* is pushed to E2E. The component tests still cover most of the chat package's surface; the E2E tests cover the gaps. The combined coverage is comprehensive.
