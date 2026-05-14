---
title: %URLSearchParamsIteratorPrototype% sampling (the hidden one)
source: designs/hardened-url-shim.md
source_repo: endojs/endo-but-for-bots
source_branch: llm
source_commit: 6ddaa541d27da22f01ad49437f0d690eaed8329a
source_date: 2026-05-06
source_authors: [Kriscendo Bot]
ingested: 2026-05-14
ingested_by: scholar
topics: [hardened-javascript]
status: current
notes: The "sample by constructing a throwaway instance and walking its prototype" pattern is the canonical way to seed a hidden intrinsic into SES's permits graph. Same pattern already used for %IteratorPrototype% and %ArrayIteratorPrototype% in SES today. The `[Symbol.toStringTag]` permit prevents `Object.prototype.toString.call(...)` from losing the iterator's host-defined tag and falling back to `'[object Object]'`.
---

> Abstract: `%URLSearchParamsIteratorPrototype%` has no name on `globalThis`; reachable only as `Object.getPrototypeOf(new URLSearchParams().entries())`. The shim must: (1) **sample it** during the intrinsics-collection pass by constructing a throwaway `URLSearchParams`, calling `.entries()`, walking to its prototype; (2) add to the permitted-intrinsics graph under the synthetic name `%URLSearchParamsIteratorPrototype%`; (3) **list the standard iterator methods** (`next`, `return`) and `[Symbol.toStringTag]` value (`'URLSearchParams Iterator'`) as permitted properties so the whitelist pass does not strip them; (4) be hardened along with the rest of the intrinsics. **Same pattern already used in SES** for `%IteratorPrototype%` and `%ArrayIteratorPrototype%` — the URLSearchParams iterator simply joins that list.

#### `%URLSearchParamsIteratorPrototype%` (the hidden one)

This intrinsic has no name on `globalThis`. It is reachable only as `Object.getPrototypeOf(new URLSearchParams().entries())`. The shim must:

1. Sample it during the intrinsics-collection pass by constructing a throwaway `URLSearchParams`, calling `.entries()` on it, and walking up to its prototype.
2. Add it to the permitted-intrinsics graph under a synthetic name (e.g. `%URLSearchParamsIteratorPrototype%`).
3. List the standard iterator methods (`next`, `return`) and the `[Symbol.toStringTag]` value (`'URLSearchParams Iterator'` in current host implementations) as permitted properties so the whitelist pass does not strip them.
4. Be hardened along with the rest of the intrinsics.

The same pattern is already used in SES for the analogous `%IteratorPrototype%` and `%ArrayIteratorPrototype%`; the URL search params iterator simply joins that list.

Source: [designs/hardened-url-shim.md](https://github.com/endojs/endo-but-for-bots/blob/6ddaa541d27da22f01ad49437f0d690eaed8329a/designs/hardened-url-shim.md) at commit `6ddaa541` on branch `llm`.
