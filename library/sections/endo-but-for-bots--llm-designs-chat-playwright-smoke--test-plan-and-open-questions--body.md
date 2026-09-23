---
title: Body
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
parent: endo-but-for-bots--llm-designs-chat-playwright-smoke--test-plan-and-open-questions
---

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
