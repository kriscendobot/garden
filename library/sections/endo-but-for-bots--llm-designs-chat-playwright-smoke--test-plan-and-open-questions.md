---
title: The injection-test verification (pass on clean tree, fail on deliberate regression, pass again after revert); out-of-scope explicit list; five open questions the maintainer owes the design (browser engine, console-error strictness, failed-request strictness, serve mechanism, screenshot artifact)
source: designs/chat-playwright-smoke.md
source_repo: endojs/endo-but-for-bots
source_branch: design/chat-playwright-smoke
source_commit: 2a97b2d6c4c0e1714631fc42f6c34cd78e18db5b
source_date: 2026-05-06
source_authors: [Kris Kowal]
topics: [chat-ui, testing]
status: current
notes: |
  **Status: Not Started** upstream. The validation + decisions cluster
  of the chat-playwright-smoke design: how to verify the smoke catches
  what it claims to via deliberate injection + revert; what is
  explicitly out of scope; and five open questions the maintainer's
  reading owes the design before it can be implemented.
---

## Abstract

§Test Plan claims the proposed smoke *catches build-and-load regressions in the Chat bundle*; §Test Plan offers two verification steps that prove the claim once the smoke is implemented: (1) **on a clean tree the spec passes** — `cd browser-test && npx playwright test tests/chat.spec.js`; (2) **inject a deliberate regression** (rename a top-level import in `packages/chat/main.js` to a missing module; rebuild; rerun the spec) **and confirm the spec fails** with a `pageerror` or a missing heading; revert and confirm the spec passes again. The §Test Plan also explicitly enumerates what is **out of scope** for this design, deferred to follow-up coverage: interaction tests (typing in the command bar, sending a message, inventory rendering); tests that require a live daemon or a mocked gateway; visual regression / screenshot diffs; cross-browser coverage beyond what the existing `browser-tests` job exercises. §Open Questions lists **five decisions the maintainer's reading owes the design**: (1) browser engine scope — only the `chrome-dev` project the canary uses, or also `chromium` / `firefox` / `webkit`? (2) console-error strictness — fail on `pageerror` only (the proposal) or also fail on `console.error` calls? (3) failed-request strictness — strict on all 404s, or filter to same-origin only? (4) serve mechanism — extend `browser-test/server.js` or add a second `webServer` entry? (the design recommends the former in §Design but the open question explicitly invites a maintainer override) (5) screenshot artifact — should the smoke upload a screenshot to the existing `actions/upload-artifact` step for after-the-fact inspection? §Prompt closes by recording the original ask: *"Please dispatch a designer to propose verifying that the Chat application builds and loads properly in Playwright. This should be added to the existing browser CI job."*

## Body

### The injection-revert verification pattern

The §Test Plan's two-step verification is a *demonstration that the smoke is falsifiable in the right direction*. Step (1) confirms the smoke does not false-fail on a clean tree; step (2) confirms the smoke does not false-pass on a deliberate regression.

The deliberate regression chosen is *rename a top-level import in `packages/chat/main.js` to a missing module*. This targets *one* of the four regression classes from §What is the Problem Being Solved? (top-level import failures); the other three classes (bundle parse failure, asset path mismatch, lockdown-time error) are inferred to be caught by the same `pageerror` / `requestfailed` machinery.

The injection-revert pattern is structurally important: it proves the smoke catches *the actual class of regression the design targets*, not just *that the smoke runs*. A smoke that always passes (or always fails) catches nothing.

The "rebuild; rerun the spec" step is necessary because the smoke targets the *production bundle*, not the source. A regression in `main.js` is not visible to the smoke until `yarn build` re-emits `packages/chat/dist/`. This is consistent with the §Design build step's reliance on the existing workspace `yarn build`.

### Out-of-scope: five explicit exclusions

The §Test Plan explicitly enumerates what is *out of scope* for this design, deferred to follow-up coverage:

1. **Interaction tests**: typing in the command bar, sending a message, inventory rendering. These are *behavior* tests; the smoke is a *load* test.
2. **Tests requiring a live daemon or a mocked gateway**: would defeat the daemon-free property of the smoke.
3. **Visual regression / screenshot diffs**: out of scope here; could be added as a follow-up if the existing `actions/upload-artifact` step proves a good surface (see §Open Questions item 5).
4. **Cross-browser coverage beyond what the existing job exercises**: the existing `browser-tests` job runs the `chrome-dev` (chromium-next) Playwright project; broadening to `chromium` / `firefox` / `webkit` is §Open Questions item 1.

The §Test Plan's explicit out-of-scope list is the *negative spec*: it tells future readers what *not* to assume the smoke does. Anyone reading the smoke as part of a CI failure investigation can immediately disqualify the smoke from regression classes it does not target.

### The five open questions

The §Open Questions list five decisions the maintainer's reading owes the design before implementation:

#### 1. Browser engine

> The existing `browser-tests` job runs `chrome-dev` (the `chromium-next` Playwright project) against the pre-installed unstable Chrome image. Should the Chat smoke run only against that project, or should it also run against the stock `chromium` / `firefox` / `webkit` projects defined in `browser-test/playwright.config.js`? The narrower scope is faster and matches the existing canary; the broader scope catches engine-specific bundle issues earlier.

The trade-off is *CI runtime* vs *engine-specific bundle coverage*. The chromium-next image is the existing canary's target; running on all four engines multiplies CI runtime by 4x for the smoke. The narrower scope's argument: most regressions caught by this smoke are *bundle-level* (SES, Vite, module-resolution), not engine-specific. The broader scope's argument: a webkit-specific bundle issue (e.g. a Safari-specific Top-Level-Await timing bug) would only surface in webkit.

#### 2. Console-error strictness

> The proposed assertion fails on any `pageerror`. Chat's entry point also writes diagnostic `console.log` / `console.error` lines (e.g. `[Chat] Starting application`). Those are not `pageerror` events, so the strict assertion is safe today. Should the assertion also fail on `console.error` calls, or is `pageerror` the right signal?

The trade-off is *false-positive risk* vs *additional regression-detection*. The proposal's `pageerror`-only signal is the minimum-noise option. Extending to `console.error` would catch deliberate error-logging from the entry point (e.g. a "diagnostic" `console.error` that the engineer left in) — possibly catching a regression that's *currently* logged but should be exception-throwing. The maintainer's call rests on whether `console.error` is *ever* legitimate diagnostic output in the production Chat bundle.

#### 3. Failed-request strictness

> Some asset 404s during a Vite build are benign (e.g. a missing favicon when one is not configured). The current Chat `index.html` declares an inline data-URI favicon, so no 404 is expected. If a future change adds an external asset, the strict `requestfailed` assertion would catch a regression but might also surface a benign change. Maintainer call: keep strict, or filter to same-origin requests only?

The trade-off is *strict-but-occasionally-false-positive* vs *lenient-but-might-miss-a-regression*. The "filter to same-origin" option is the principled middle: most regressions the smoke targets are same-origin (the bundle and its assets); cross-origin assets (e.g. a CDN-loaded font) are inherently external and may legitimately fail in CI without indicating a regression. Same-origin filtering is a defensible default but adds policy.

#### 4. Serve mechanism

> Does the maintainer prefer extending `browser-test/server.js` to mount `/chat/` (no new dependency, touches an existing file) or adding a second Playwright `webServer` entry that runs `npx http-server` (cleaner separation, one new dev dependency)?

The §Design recommends extending `browser-test/server.js`; §Open Questions explicitly invites a maintainer override. The decision is *minimal-dependency* vs *minimal-coupling*: extending `server.js` keeps the dependency surface but couples chat-smoke to the canary's server lifecycle; adding a `webServer` entry decouples lifecycles but adds a dev dependency. The §Design's preference is dependency-minimal; the §Open Question gives the maintainer the option.

#### 5. Screenshot artifact

> Should the smoke upload a screenshot of the loaded page to the existing `actions/upload-artifact` step for after-the-fact inspection? The existing job uploads `playwright-report/`; a screenshot embedded in that report is one extra `await page.screenshot(...)`.

The trade-off is *one-line addition with after-the-fact diagnostic value* vs *extra artifact storage and runtime*. The existing `playwright-report/` upload would carry the screenshot for free; the smoke just needs to invoke `await page.screenshot({ path: ... })` after the heading assertion. Useful for diagnosing *passed-but-looks-wrong* states.

### The §Prompt — the original ask preserved

The §Prompt subsection preserves the original ask in blockquote form:

> Please dispatch a designer to propose verifying that the Chat application builds and loads properly in Playwright. This should be added to the existing browser CI job.

This is a worked example of the *designs-with-Prompt-recorded* convention. The original ask is preserved so future readers can reconcile the design's scope against the original request. The chat-playwright-smoke design is responsive to the prompt: it proposes a Playwright verification, scoped to build-and-load, integrated into the existing CI job. No scope creep.

## Connection to the wider library

This section is the **validation-and-decision template for a narrow CI guard design**. The library can cite this section whenever:

1. **A design needs an injection-revert verification pattern.** The §Test Plan's two-step pattern (clean-tree pass + deliberate-regression fail + revert pass) is the canonical way to prove a regression-catching test is *falsifiable in the right direction*. Generalizes to any test that claims to catch a specific regression class.
2. **A design needs an explicit out-of-scope list.** The §Test Plan's enumeration is the *negative spec*: what the design does *not* claim to do. Worth including in any design that's bounded in scope to avoid future readers misattributing failures to the design's surface.
3. **A design defers decisions to the maintainer via §Open Questions.** Each question is a single, mutually-exclusive decision with the design's preferred default. The form is reusable: *here is the question; here are the trade-offs; here is my recommendation (if any); the maintainer's call*.

## Translation block (design idiom → contemporary practice)

| Design concept | Contemporary practice |
| -------------- | --------------------- |
| Injection-revert verification | A standard test-the-test discipline; `git stash` the regression, run, restore. Used in TDD; the design's §Test Plan formalizes it. |
| §Out-of-scope explicit enumeration | "Negative requirements" in product spec language; the design uses bullet list. Helps future readers understand the design's boundaries. |
| §Open Questions with maintainer-call markers | The convention used across endo-but-for-bots designs; lets the designer surface decisions without resolving them, preserving the maintainer's judgment. |
| §Prompt subsection preserving the original ask | A norm of the *designs-with-Prompt-recorded* convention; lets reviewers reconcile the design against the original ask. |

## See also

- [[testing]] (topic) — the broader CI test-suite design surface this section sits within.
- [[chat-ui]] (topic) — the Chat application under test.
- `endo-but-for-bots--llm-designs-chat-playwright-smoke--problem-framing-and-relationship-to-chat-test-coverage` — the first section: what regression class this smoke targets.
- `endo-but-for-bots--llm-designs-chat-playwright-smoke--build-serve-and-playwright-fixture` — the second section: how the smoke is built, served, and exercised.
- `endo-but-for-bots--llm-designs-chat-pending-commands--motivation-and-problems` — adjacent chat design with a similar problem-framing + out-of-scope structure.

## Common confusions

- **"Why is the §Test Plan so short?"** Because the smoke's claim is also short — *the smoke catches build-and-load regressions in the Chat bundle*. A short claim deserves a short verification. The two-step injection-revert pattern is sufficient to prove the claim is falsifiable in the right direction. Heavier validation (e.g. mutation testing) would be appropriate for a heavier claim.
- **"The §Open Questions delay implementation."** They surface decisions; they do not *block* implementation. The designer can implement the design with the §Design defaults (approach 2 for serve; `pageerror`-only for console-error; strict for failed-request; chrome-dev only for engine; no screenshot artifact) and revisit each question if the implementation surfaces a need to revisit.
- **"`console.error` should always be a failure."** Not if the entry point legitimately uses `console.error` for diagnostic output. The §Open Question makes this explicit; the maintainer must make the call about whether the production Chat bundle's `console.error` calls are *ever* legitimate.
- **"Cross-browser coverage is essential for a web app."** It is essential for the *broader* test surface; it may not be essential for the *smoke*. The smoke catches bundle-load regressions, which are mostly engine-agnostic (SES, Vite, module-resolution). Engine-specific regressions (e.g. webkit-specific timing) are caught by a *separate* test surface that the design explicitly defers. The §Open Question lets the maintainer choose how aggressive to be.
- **"The §Prompt is just historical."** It is *load-bearing context*. Future readers can reconcile the design's scope against the original ask. A design that drifts from its prompt — e.g. by including interaction tests after being asked to "verify Chat builds and loads" — is a signal of scope creep.
