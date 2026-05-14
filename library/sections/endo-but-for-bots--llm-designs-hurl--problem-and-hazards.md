---
title: Problem + two hazards (iterator-proto leak + ambient blob authority)
source: designs/hardened-url-shim.md
source_repo: endojs/endo-but-for-bots
source_branch: llm
source_commit: 6ddaa541d27da22f01ad49437f0d690eaed8329a
source_date: 2026-05-06
source_authors: [Kriscendo Bot]
ingested: 2026-05-14
ingested_by: scholar
topics: [hardened-javascript, capability-security]
status: current
notes: The "iterator prototypes leak past the SES intrinsic graph" hazard is a recurring pattern — same shape applies to any built-in whose methods return iterators with their own prototype chain. The createObjectURL/revokeObjectURL hazard is the canonical "ambient authority disguised as a pure-looking static method" case.
---

> Abstract: Endo's hardened-JavaScript model rests on every shared intrinsic being either a powerless data constructor or carefully tamed. `URL` and `URLSearchParams` would be welcome additions, but **naive `harden(URL)` is not safe** for two reasons. **Hazard 1 — iterator prototypes leak past the SES intrinsic graph**: `URLSearchParams.prototype.entries`, `.keys`, `.values`, and `[Symbol.iterator]` return iterator objects whose `[[Prototype]]` is `%URLSearchParamsIteratorPrototype%`. That prototype is reachable only by walking an instance — not on `globalThis`, not in `permits.js`, not visited by `harden`'s transitive walk unless explicitly seeded. A compartment that gets a single `URLSearchParams` object can mutate that iterator prototype and influence every other compartment's iteration. **Hazard 2 — `createObjectURL` and `revokeObjectURL` are ambient authority**: in a browser they mint/revoke handles into the document's blob registry, observable by every other realm in the page. They are exactly the kind of side-channel ocap discipline forbids; must be removed before any compartment sees them. **Fix**: add `URL` and `URLSearchParams` to SES permits as a vetted shim, with explicit permits for the search-params iterator prototype, and a Date-style split keeping the dangerous static methods on the start compartment only. **On hosts without `URL`** (notably XS): the shim is a no-op; portability story preserved. Targets endojs/endo issue #2635. Companion `TextEncoder`/`TextDecoder` taming split to `hardened-text-codecs-shim.md` (same source issue, no implementation overlap).

# Hardened `URL` Vetted Shim

## What is the Problem Being Solved?

Endo's hardened-JavaScript model rests on the premise that every intrinsic shared between fearlessly coöperating compartments is either a powerless data constructor or has been carefully tamed. The host's `URL` constructor and its companion `URLSearchParams` are broadly useful (parsing, normalization, query manipulation) and would be welcome additions to the permitted intrinsics, but a naive `harden(URL)` is not safe.

Two specific hazards:

1. **Iterator prototypes leak past the SES intrinsic graph.** `URLSearchParams.prototype.entries`, `.keys`, `.values`, and the default `[Symbol.iterator]` return iterator objects whose `[[Prototype]]` is `%URLSearchParamsIteratorPrototype%`. That prototype is reachable only by walking an instance. It is not on `globalThis`, not in `permits.js`, and not visited by `harden`'s transitive walk unless we explicitly seed it. A compartment that gets a single `URLSearchParams` object can mutate the iterator prototype and thereby influence every other compartment's iteration over a `URLSearchParams`.

2. **`URL.createObjectURL` and `URL.revokeObjectURL` are ambient authority.** In a browser they mint and revoke handles into the document's blob registry, which is observable by every other realm in the page. They are exactly the kind of side-channel that ocap discipline forbids. They must be removed from the constructor before any compartment sees it.

The fix is to add `URL` and `URLSearchParams` to the SES permits as a vetted shim, with explicit permits for the search-params iterator prototype, and a Date-style split that keeps the dangerous static methods on the start compartment only. On hosts that do not provide `URL` (notably XS), the shim is a no-op so Endo's portability story is preserved.

This work targets endojs/endo issue [#2635](https://github.com/endojs/endo/issues/2635). The companion `TextEncoder` / `TextDecoder` taming is split into a sibling design at `hardened-text-codecs-shim.md`; it has no implementation overlap with the URL work.

Source: [designs/hardened-url-shim.md](https://github.com/endojs/endo-but-for-bots/blob/6ddaa541d27da22f01ad49437f0d690eaed8329a/designs/hardened-url-shim.md) at commit `6ddaa541` on branch `llm`.
