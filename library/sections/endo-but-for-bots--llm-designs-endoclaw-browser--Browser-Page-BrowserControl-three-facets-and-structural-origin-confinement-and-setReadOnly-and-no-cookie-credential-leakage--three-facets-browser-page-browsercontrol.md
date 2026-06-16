---
title: "§Three facets: Browser + Page + BrowserControl"
source-slug: endo-but-for-bots--llm-designs-endoclaw-browser
source-url: https://github.com/endojs/endo-but-for-bots/blob/master/designs/endoclaw-browser.md
authors: [Kris Kowal (prompted)]
repo: endojs/endo-but-for-bots
path: designs/endoclaw-browser.md
total-lines: 93
ingest-cycle: 259
ingest-date: 2026-06-10
lane: designs
parent: endo-but-for-bots--llm-designs-endoclaw-browser--Browser-Page-BrowserControl-three-facets-and-structural-origin-confinement-and-setReadOnly-and-no-cookie-credential-leakage
---

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
