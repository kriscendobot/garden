---
source: designs/chat-test-coverage.md
source_repo: endojs/endo-but-for-bots
source_branch: llm
source_commit: 3b031592e5f97a86e317cb96f1b7c44abb4e41f9
source_date: 2026-03-02
source_authors: [Kris Kowal]
ingested: 2026-05-29
ingested_by: scholar
section_count: 2
status: current
notes: |
  **Status: Complete** upstream. The test-coverage portion of the chat
  package's design, extracted from `packages/chat/DESIGN.md`. The
  document is *reference documentation* describing the existing test
  suite, not a design proposal. Two argument-cluster sections capture
  the document's organization: (1) test-organization + testing-approach
  (mock-powers Far-remotable + happy-dom DOM-globals-before-import) +
  untestable-behaviors (token-autocomplete-in-contenteditable +
  Monaco-iframe-postMessage + WebSocket); (2) E2E tests (Playwright;
  token-autocomplete.spec.ts 25 tests + monaco-editor.spec.ts 14
  tests) + protocol-documentation-as-tests pattern + per-module
  coverage tables (244 unit+component + 39 E2E = 283 total tests).
---

> Abstract: The chat package's test suite organized by required-runtime
> tier: `unit/` (pure logic; no DOM); `component/` (DOM-component
> tests under happy-dom); `e2e/` (Playwright E2E with real browser).
> The `helpers/mock-powers.js` returns a `Far()`-remotable that
> simulates the daemon's powers interface — *tracks method calls,
> supports async iteration, and can be configured with initial names,
> values, and IDs*. happy-dom's DOM globals must be installed before
> chat-module imports because the modules reference DOM globals at
> module load time. Three classes of behavior *cannot* be tested under
> happy-dom and require Playwright: (1) token-autocomplete in
> contenteditable (Selection-API-dependent); (2) Monaco editor in
> iframe with cross-window postMessage; (3) WebSocket connection (real
> or mock server required). The two Playwright spec files cover these
> gaps: `token-autocomplete.spec.ts` (25 tests across 8 areas) and
> `monaco-editor.spec.ts` (14 tests across 6 areas). The `monaco-
> wrapper.test.js` component-test uses *protocol-documentation-as-
> tests* — skipped tests document the postMessage API. The per-module
> coverage table marks each module with *Complete* / *Partial -
> scope-note* / *Protocol documentation* — coverage-honesty-with-
> scope-notes discipline. Total: 244 unit+component tests across 15
> modules + 39 E2E tests across 2 specs = 283 tests.

## Sections

| Section | Topics | Status |
|---------|--------|--------|
| [test-organization-and-untestable-behaviors](../sections/endo-but-for-bots--llm-designs-chat-test-coverage--test-organization-and-untestable-behaviors.md) | chat-ui, testing | current |
| [e2e-test-coverage-and-module-count-summary](../sections/endo-but-for-bots--llm-designs-chat-test-coverage--e2e-test-coverage-and-module-count-summary.md) | chat-ui, testing | current |

The document's six top-level sections collapse to two argument-cluster sections (cohesion-honest split — the source is bounded enough that two sections capture the material without padding). §Test Organization + §Testing Approach + §Untestable Behaviors → section 1. §E2E Tests + §Test Count by Module + §E2E Test Count → section 2.

## Provenance

- Fetched 2026-05-29 from `endojs/endo-but-for-bots@3b031592e5f97a86e317cb96f1b7c44abb4e41f9` (the file's last-modifying commit on `origin/llm`).
- File last modified 2026-03-02 by Kris Kowal; *extracted from `packages/chat/DESIGN.md`* per the source's frontmatter.
- Verified via bare-clone listing before drafting (cycle 73 / 74 verify-bare-clone discipline).
- **Nineteenth chat-cluster source**.

## Cycle 92 chat-branch-discovery note

Cycle 86's bare-clone-verification reported that `chat-test-coverage` and `chat-rename-dismiss-to-clear` were not on the remote. That was a *partial* check — cycle 86 scanned `origin/design/chat-*` branches but **not the `origin/llm` branch**. The `llm` branch is the legacy chat-designs branch where the earlier (pre-`design/chat-*`-split) chat designs live; chat-test-coverage and chat-rename-dismiss-to-clear *are* on `origin/llm/designs/`.

**Discipline reinforcement**: chat-lane candidate verification should check `origin/llm` *and* `origin/design/chat-*` branches. Future chat-lane cycles must scan both branch families.

The cycle-91 result's *capability-theory cluster status* observation that *all currently-known chat designs are now ingested* was based on the cycle-86 partial check. Three more chat candidates are now visible:
- `chat-rename-dismiss-to-clear` (75 lines; Status: Complete, PR #93 merged 2026-05-06; small enough for a single-section ingest)
- `chat-reply-chain-visualization` (502 lines; Status: Deprecated — superseded by chat-focus-message)
- This document (`chat-test-coverage`; Status: Complete; now ingested cycle 92)

`chat-reply-chain-visualization` is *Deprecated*; future chat-lane cycles may still ingest it for the design-rationale-history record but it's not urgent. `chat-rename-dismiss-to-clear` is small but Complete; a future chat-lane cycle could ingest it as a single-section *PR-merged refactor decision record*.
