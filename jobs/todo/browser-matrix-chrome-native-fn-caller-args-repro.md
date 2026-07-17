# Follow-up: collect cross-browser results via Playwright for chrome-native-function-caller-arguments-repro and post them in the README

Repo: **`kriscendobot/chrome-native-function-caller-arguments-repro`** (branch `main`), a zero-
dependency static page (`index.html` + `app.js`) that probes own `arguments`/`caller` properties on
`TextEncoder`, `TextDecoder`, and ordinary strict/sloppy functions, and renders live observations +
raw JSON. Pages URL: https://kriscendobot.github.io/chrome-native-function-caller-arguments-repro/ .
Today `test.mjs` is only a **Node** unit test of the render/probe logic; the browser probe itself is
run by hand. This follow-up automates it across many browsers with **Playwright** and records the
results in the README.

## Do
1. **Add a Playwright harness** (as a **devDependency** — keep the static page itself zero-dependency;
   Playwright is test-only, add e.g. a `test:browsers` script, do not pull deps into `app.js`/the
   page). The harness loads the page (serve `index.html` locally, or use the Pages URL), waits for the
   probes to complete, and extracts the **result JSON** the page produces. Read `app.js` to find where
   that JSON is exposed (a DOM node / a `window` global / `formatResult` output) and pull it out
   programmatically rather than scraping rendered text where possible.
2. **Run a broad browser matrix**, emphasizing **Chromium** (the repro targets Chrome behavior):
   - Playwright's three engines: **chromium**, **firefox**, **webkit**.
   - Branded channels + extra versions **where the environment permits**: `chrome`, `msedge` (and
     beta channels) via `channel:`; if a channel/browser cannot be installed in this environment, skip
     it and record that — do NOT fabricate a result.
   - For each browser actually run, capture **name, engine, and version** (`browser.version()` /
     the UA).
   - Flag the caveats honestly: Playwright **chromium is not branded Chrome**, and **WebKit is not
     Safari** — call out where the `arguments`/`caller` descriptor observation could differ from the
     real shipping browser, since that distinction is the whole point of this repro.
3. **Collect results**: per browser, the per-probe observations (does `arguments`/`caller` exist? is
   it callable? the descriptor shape) — the same data the page shows, plus the raw JSON.
4. **Post results in the README**: add a "Cross-browser results (Playwright)" section with a scannable
   **table** (Browser | Engine | Version | `arguments` | `caller` | notes) covering every probe fixture,
   the **run date**, the Playwright version, the environment, and an explicit list of browsers that
   could NOT be exercised and why. Commit the raw per-browser JSON as an artifact (e.g. `results/`) and
   link it, or inline it under a details block.
5. **Commit + push to `main`** (this is the bot's own repro repo; direct-to-main is fine, no PR
   gauntlet). Make the run reproducible via the `test:browsers` script.

## Norms
- The static page stays **zero-dependency**; Playwright lives only in the test harness. Honest
  reporting only — never invent results for a browser that did not actually run; say what the
  environment could and could not exercise. ASCII prose; fully-qualified references.

## Done
`kriscendobot/chrome-native-function-caller-arguments-repro` `main` has a reproducible Playwright
`test:browsers` harness and a README "Cross-browser results" section with a real per-browser results
table (Chromium emphasized) + raw JSON artifacts, dated, with the not-run browsers and the
chromium!=Chrome / webkit!=Safari caveats stated. The `tada` report summarizes which browsers ran and
the headline finding.
