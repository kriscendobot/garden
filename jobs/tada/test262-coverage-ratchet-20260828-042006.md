Turn complete. Summary of this serial ratchet engagement:

## Completion report

**Job:** `test262-coverage-ratchet-20260828-042006` — serial test262-coverage ratchet turn (kriscendobot/garden issue #51).

**Stop conditions (checked FIRST, none held):** turn ran ~04:22Z; deadline `2026-08-28T15:00Z` was still ~10.6h away; whole-corpus coverage far under 90%; quota healthy (Opus, no fleet drain). **Schedule left armed** — not retired.

**Serial-safety:** `jobs/doin/` clear of coverage workers; the prior turn's PR **#1073 merged at 03:56Z** via its staged gauntlet. No live worker held the ratchet, so I pressed.

**Slice advanced (TypedArray/ArrayBuffer residual family):** added `test/intrinsics/TypedArray/intrinsic-metadata.js` to `@endo/hardened262` — pins the abstract `%TypedArray%` superclass metadata (`name`/`length`), that every concrete typed-array constructor and `.prototype` chains through the single shared `%TypedArray%`/`%TypedArrayPrototype%` intrinsics, the coherent `values`/`subarray`/`Symbol.iterator` method metadata, and the `@@toStringTag` accessor (getter yields the per-instance constructor name, `undefined` for non-typed-array receivers, no setter).

**Real-execution evidence:** `node scripts/test.js test/intrinsics/TypedArray/intrinsic-metadata.js` → `# ok` on `module` + `lockdownModule` across all three agents (`xs`, `sesXs`, `sesNode`), every other scenario correctly `# skip`. Baselines regenerated with the real harness (`yarn test262:update`): **strictly additive — +6 net-new covered scenario-cases, 0 `failed` additions, no covered-case regression** (36 insertions / 0 deletions). Golden test `node --test 'scripts/**/*.test.js'` → **24 pass / 0 fail**; `yarn lint` → clean. Reverted the incidental pre-existing bare-`xst` `Compartment/prototype/globalThis/defaults.js` flake (host-XS-version mismatch vs CI-pinned Moddable XS) to keep the diff additive.

**PR:** opened **endojs/endo-but-for-bots#1074** (draft, base `llm`, commit `36f55f833`) via `ensure-pr.sh` with the durable job marker. Staged gauntlet **`endojs-endo-but-for-bots-pr1074-gauntlet-20260828`** (clean → panel → fix → un-draft) owns the merge path.

**Delta recorded** on issue #51 (left open): https://github.com/kriscendobot/garden/issues/51#issuecomment-5448434233

**Remaining named residuals / next candidates:** RegExp Unicode, more TypedArray/ArrayBuffer (DataView, view methods beyond #1064), exotic MOP, runtime eval/dynamic import (Intl deferred). Next hardened262 intrinsic-metadata candidates: `%RegExpPrototype%`, `%PromisePrototype%`, `%DataView%`/`%ArrayBufferPrototype%`. Whole-corpus Ironhorse total remains the 2026-08-14 checkpoint (23,496 / 51,976) — not extrapolated. Schedule remains armed for the next serial turn.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/test262-coverage-ratchet-20260828-042006.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 72 tokens (2651512 cached reads)
- Output: 22263 tokens
- Cost: $2.658355999999999
- Wall-clock: 373s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
