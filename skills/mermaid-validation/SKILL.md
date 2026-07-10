---
created: 2026-07-10
updated: 2026-07-10
author: gardener
---

# Skill: mermaid-validation

Validate that every ` ```mermaid ` fence in a document actually parses, before committing, without a browser. The designer role mandates mermaid for diagrams; an invalid diagram renders as an error box on GitHub and has already cost a dedicated fix PR (kriscendobot/minion.town#5). Rendering with `@mermaid-js/mermaid-cli` (`mmdc`) needs Chromium, which fails inside the garden container (puppeteer sandbox, then missing shared libraries such as `libnspr4.so`). Parse-only validation needs neither.

## Purpose

Catch mermaid syntax errors at authoring time. `mermaid.parse()` runs the real grammar for every diagram type and throws on the same inputs GitHub's renderer rejects; it needs only a fake DOM, not a browser.

## Inputs

- One or more markdown files containing ` ```mermaid ` fences (or extracted `.mmd` files).

## State

None. A throwaway `npm` directory holding `mermaid` and `jsdom`.

## Procedure

1. Extract each fenced block to its own file:

   ```sh
   awk '/^```mermaid$/{f=1;n++;file="/tmp/mm-"n".mmd";next} /^```$/{f=0} f{print > file}' path/to/doc.md
   ```

2. One-time setup in a scratch directory:

   ```sh
   mkdir -p /tmp/mmcheck && cd /tmp/mmcheck && npm init -y && npm i mermaid jsdom
   ```

3. Run the checker (`check.mjs`):

   ```js
   import { JSDOM } from 'jsdom';
   const dom = new JSDOM('<!DOCTYPE html><body></body>');
   globalThis.window = dom.window;
   globalThis.document = dom.window.document;
   Object.defineProperty(globalThis, 'navigator', { value: dom.window.navigator, configurable: true });
   globalThis.DOMPurify = { sanitize: (x) => x, addHook: () => {} };
   const mermaid = (await import('mermaid')).default;
   mermaid.initialize({ startOnLoad: false });
   import { readFileSync } from 'fs';
   let fail = 0;
   for (const f of process.argv.slice(2)) {
     try {
       const r = await mermaid.parse(readFileSync(f, 'utf8'));
       console.log(f, 'OK', r.diagramType);
     } catch (e) {
       fail = 1;
       console.log(f, 'PARSE-FAIL:', e.message?.slice(0, 300));
     }
   }
   process.exit(fail);
   ```

   ```sh
   node check.mjs /tmp/mm-*.mmd
   ```

## Output shape

One line per block: `OK <diagramType>` or `PARSE-FAIL: <message>`; nonzero exit if any block failed. Cite the OK lines as the real-execution evidence in a completion report ("diagrams validated" needs this, not eyeballing).

## Notes

- `globalThis.navigator` is getter-only on recent Node; assign it with `Object.defineProperty` (a bare assignment throws).
- Parse-only does not catch layout-level problems (label overflow, giant graphs), only grammar. Grammar is what breaks GitHub rendering.
- Do not reach for `mmdc`/puppeteer inside the container first; it fails on the sandbox and then on missing system libraries, and parse-only answers the actual question.
