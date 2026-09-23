---
title: Body
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
parent: endo-but-for-bots--llm-designs-chat-test-coverage--test-organization-and-untestable-behaviors
---

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
