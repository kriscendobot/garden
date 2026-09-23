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
  **Status: Complete** upstream. The E2E-and-coverage-summary cluster
  of the chat-test-coverage document: Playwright spec files for the
  two test classes that *cannot* be tested under happy-dom (token
  autocomplete in contenteditable; Monaco editor with cross-window
  postMessage); the protocol-documentation-as-tests pattern that the
  monaco-wrapper component test enacts; and the per-module breakdown
  showing 244 unit/component tests across 15 modules plus 39 E2E
  tests across 2 specs (283 total).
parent: endo-but-for-bots--llm-designs-chat-test-coverage--e2e-test-coverage-and-module-count-summary
---

### §E2E Tests (Playwright) — two .spec.ts files in test/e2e/

The §E2E Tests subsection lists the two Playwright spec files:

```
test/e2e/
  README.md                    # Documentation for e2e test approach
  token-autocomplete.spec.ts   # Token @mention autocomplete tests
  monaco-editor.spec.ts        # Monaco editor integration tests
```

The structural choice: **`.spec.ts` (TypeScript) for E2E vs `.test.js` (JavaScript) for unit/component**. The TypeScript extension distinguishes test types at the filename level — a developer scanning the directory can immediately see *which tests need Playwright + a real browser*. The TypeScript type-checking is also more valuable for E2E tests, which interact with Playwright's complex API surface (page.evaluate, locator chains, etc.).

#### `token-autocomplete.spec.ts` — 25 tests across eight coverage areas

The §E2E *Token Autocomplete Tests* paragraph enumerates eight coverage categories:

1. **Menu visibility** — `@` opens menu, `@@` escapes (treats `@` as literal text), Escape/Backspace closes.
2. **Filtering** — case-insensitive matching, "No matches" display when no completions match.
3. **Navigation** — ArrowUp/Down through suggestions, wrap-around at endpoints.
4. **Selection** — Tab, Enter, Space, click — four ways to commit a completion.
5. **Edge names** — `:` enters edge-name mode (per the cycle-89 chat-edit-message-ui §Decision 4 *locator-not-pet-name* discipline); typing edge name modifies the selected token.
6. **Token deletion** — Backspace after token removes the chip (vs. cursor-positioning-only behavior).
7. **`getMessage` parsing** — single token, multiple tokens, edge names — the *what-the-form-emits* contract verified.
8. **Edge cases** — `@` not triggered after alphanumeric (e.g., typing `email@example.com` does not open the autocomplete menu).

The §E2E listing is *exhaustive coverage of the autocomplete state machine*. Each row maps to one or more `.test()` blocks in the spec file. The eight categories enumerate the design's full feature surface — a developer can read the list and immediately know whether their change to autocomplete behavior has corresponding test coverage.

#### `monaco-editor.spec.ts` — 14 tests across six coverage areas

The §E2E *Monaco Editor Tests* paragraph enumerates six coverage categories:

1. **Loading** — iframe loads correctly; editor element receives focus after load.
2. **Content** — typing updates the editor content; initial-value injection works.
3. **Keyboard shortcuts** — Cmd+Enter submit; Escape cancel; Cmd+E add endowment.
4. **Syntax highlighting, line numbers, multi-line** — the Monaco UI features the chat code depends on.
5. **Dispose removes iframe** — cleanup-on-dismiss verified.
6. **postMessage protocol tests** — the cross-window message exchange between the chat-wrapper and the iframe-hosted Monaco editor.

The §E2E coverage for Monaco is *lighter* than for token-autocomplete (14 vs 25) — partly because Monaco's UI features (syntax highlighting, line numbers) are *Monaco's own responsibility*, not the chat package's. The chat tests focus on the *interface* between chat and Monaco (loading, content-injection, keyboard-shortcuts, postMessage-protocol) rather than the Monaco editor's intrinsic behavior.

### §Protocol-documentation-as-tests — monaco-wrapper.test.js

The §E2E subsection closes with a structural observation:

> **Component Tests (happy-dom) include `monaco-wrapper.test.js` which documents the postMessage protocol without requiring a browser.**

The structural pattern is *protocol-documentation-as-tests*:

- The Monaco editor's behavior cannot be exercised under happy-dom (per §Untestable Behaviors / cross-window-messaging).
- But the *protocol* between the chat-wrapper and Monaco can be captured as **skipped tests** or **assertion-light tests** that *describe* the expected messages.
- A future developer reads `monaco-wrapper.test.js` to understand the postMessage contract; the file is *documentation-as-tests* — runnable artifacts that read like protocol specs.

The §Test Count by Module table marks this explicitly:

> `monaco-wrapper | 1 | Protocol documentation (skipped tests document API)`

The "1 test" count is misleading at first read — but the *skipped tests* in the file *document the API*. The pattern is *tests-as-documentation-when-tests-cannot-execute*. Reusable for any protocol that cannot be exercised in the current test runtime.

### §Test Count by Module — 244 unit/component tests across 15 modules

The §Test Count by Module table is the *coverage snapshot* of the chat package:

| Module | Tests | Coverage |
|--------|-------|----------|
| command-registry | 16 | Complete - all utilities |
| command-executor | 32 | Complete - all 20+ commands |
| message-parse | 20 | Complete - parsing edge cases |
| ref-iterator | 8 | Complete - async iteration |
| time-formatters | 16 | Complete - formatting utilities |
| markdown-render | 27 | Complete - parsing and rendering |
| value-render | 36 | Complete - all pass-style types |
| mock-powers | 10 | Complete - mock verification |
| send-form | 4 | Partial - state management only |
| petname-path-autocomplete | 17 | Complete - API, navigation, selection |
| petname-paths-autocomplete | 20 | Complete - chips, callbacks, navigation |
| inline-command-form | 24 | Complete - rendering, validation, submission |
| monaco-wrapper | 1 | Protocol documentation (skipped tests document API) |
| form-request-inbox | 3 | Complete - form rendering, submission, settlement |
| spaces-gutter-home | 5 | Complete - context menu, modal, config persistence |
| **Unit/Component Total** | **244** | |

The structural reading:

- **Most modules are *Complete*** — `command-registry`, `command-executor`, `message-parse`, `ref-iterator`, `time-formatters`, `markdown-render`, `value-render`, `mock-powers`, `petname-path-autocomplete`, `petname-paths-autocomplete`, `inline-command-form`, `form-request-inbox`, `spaces-gutter-home` — 13 of 15 modules.
- **Two modules are explicitly *Partial* or *Protocol documentation only***:
  - `send-form: 4 Partial - state management only` — the send-form component has *state-management* tests but not full UI-behavior tests (the UI behaviors are tested at E2E via `token-autocomplete.spec.ts`).
  - `monaco-wrapper: 1 Protocol documentation` — the actual integration tests are at E2E via `monaco-editor.spec.ts`.

The structural lesson: **the coverage table is *honest* about partial coverage**. The "Complete" label is reserved for modules whose tests cover the full design surface; "Partial" with a one-line scope-note tells the reader what is *not* covered. This is *coverage-honesty-with-scope-notes* discipline.

### §E2E Test Count — 39 across 2 specs

The §E2E Test Count table:

| Spec File | Tests | Coverage |
|-----------|-------|----------|
| token-autocomplete.spec.ts | 25 | Menu, filtering, navigation, selection, edge names |
| monaco-editor.spec.ts | 14 | Loading, content, shortcuts, protocol |
| **E2E Total** | **39** | |

The structural reading:

- **E2E tests target the gaps left by happy-dom**: token-autocomplete (Selection-API-dependent) + Monaco (iframe-cross-window-messaging-dependent). Each spec corresponds to one of the *Untestable Behaviors* from the prior section.
- **The E2E test count is small relative to unit/component (39 vs 244)** — the cost-tier hierarchy is reflected in the count. Fast tests are abundant; expensive tests are reserved for what *only* they can cover.

#### Combined total: 283 tests

The chat package's test surface decomposes as:

- **Unit (155 tests across 7 modules)**: `command-registry` + `command-executor` + `message-parse` + `ref-iterator` + `time-formatters` + `markdown-render` + `value-render`.
- **Helpers (10 tests)**: `mock-powers`.
- **Component (79 tests across 7 modules)**: `send-form` + two `petname-path-autocomplete` variants + `inline-command-form` + `monaco-wrapper` + `form-request-inbox` + `spaces-gutter-home`.
- **E2E (39 tests across 2 specs)**: token-autocomplete + monaco-editor.

**Total: 283 tests**. The decomposition's ratio (244 fast : 39 slow ≈ 6.3:1) reflects the cost-tier discipline: prefer fast tests; reserve slow tests for what *only* they can cover.

### The §Source-extraction note

The §Source footer at the top of the document records:

> **Source** | Extracted from `packages/chat/DESIGN.md`

The structural meaning: **this document is *extracted* from a longer design document** that lives inside the chat package. The chat-test-coverage document is the *test-coverage portion* of the broader chat package design. The extraction lets the test-coverage be auditable as a standalone artifact (referenced by the chat-playwright-smoke design from cycle 86, the chat-voice-command-parser design from cycle 89, and any future test-related designs) without bringing the full chat DESIGN.md into scope.

The §Status: **Complete** (with no PR-merge link, unlike chat-rename-dismiss-to-clear's PR #93 annotation) — meaning the document is *finished as reference documentation*, not *waiting for implementation*. The tests it describes already exist in the chat package's test/ directory.
