---
model: opus
---
# builder: Proxy-based freezable-TypedArray emulation + cross-platform (Node/XS) parity tests

**Repo:** `endojs/endo-but-for-bots`, `packages/immutable-arraybuffer` (bot-pushable; standing comment auth on this repo — comment/link-back is authorized). No upstream `endojs/endo` touch.

## Maintainer directive (kriskowal, PR #472 review comment 3517387215, 2026-07-03)

> "I am interested in seeing the alternative emulation with a Proxy, and the tests that confirm parity for property assignment regardless of whether emulated or not-emulated across node and XS platforms, using the packages/test262-harness for parity testing. Please post a job for a builder to produce that and link back here."

## Context (design tradeoff on #472, `designs/freezable-typedarray.md`)

The current design emulates the frozen TypedArray view as a **plain object**, so an integer-indexed assignment silently creates a wrapper-local own property instead of throwing. @gibson042 argued for a **Proxy `set` trap that rejects canonical-numeric-index writes** (pass-through for everything else), raising three points: (1) freezability must survive the Proxy — `Object.freeze(view)`/`Object.isFrozen(view)===true` and transitive SES `harden()` must still hold (his stated non-risk: "basically pass-through except for property keys that are canonical numeric indices"); (2) cost is bounded (only where the shim is needed and only on direct-indexed-read hot paths, which the codebase avoids in favor of `@endo/bytes` helpers); (3) throwing on write surfaces otherwise-silent bugs under strict mode. kriskowal wants the Proxy alternative **built and measured against the plain-object one**, not decided on paper.

## Task

1. **Implement the Proxy-based emulation** of the freezable TypedArray view in `packages/immutable-arraybuffer`: a Proxy whose `set` trap **throws on canonical numeric index writes** and is otherwise pass-through, and which **remains freezable/hardenable** — `Object.freeze` → `Object.isFrozen === true`, transitive SES `harden()` works, all proxy invariants satisfied. Keep it alongside (not replacing) the current plain-object emulation so both can be compared.
2. **Parity tests for property assignment** confirming the emulated view and a not-emulated (native immutable ArrayBuffer, where available) view agree on property-assignment behavior — including that a canonical-index write throws under the Proxy and that reads/freezing/harden behave identically. Use **`packages/test262-harness`** for the parity testing.
3. **Run the parity tests on BOTH platforms — Node and XS** — and record the results (this is the crux of kriskowal's ask: parity across node and XS). Cite the real runs per `garden/roles/COMMON.md` § Reporting; do not claim parity without the actual cross-platform runs.
4. Open a PR (base per `journal/projects/endo-but-for-bots/README.md` base-inference rules) carrying the Proxy emulation + parity tests, and **post a comment on PR #472 linking back to it** with a short summary of the Node/XS parity results (the "link back here" kriskowal requested).

## Definition of done

A PR with the Proxy-based freezable-TypedArray emulation (freezability + harden preserved, canonical-index writes throw) and `test262-harness` parity tests for property assignment, **run and reported green on both Node and XS**, cross-linked from PR #472 with a results summary. Leave the merge/design disposition to the maintainer. Journal a `result` entry with the PR + comment URLs.
