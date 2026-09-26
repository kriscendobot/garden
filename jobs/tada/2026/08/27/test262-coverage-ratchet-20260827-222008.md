Ratchet turn complete.

**Serial-safety check:** No live coverage worker held the ratchet — the prior ratchet dispatches (`-212008`, `-200508`) are completed in `tada/`, and `#1065` (their Generator prototype slice) merged at 21:50Z. So I pressed.

**Stop conditions (checked first, none held):** Deadline `2026-08-28T15:00Z` not reached (now ~2026-08-27T22:36Z); whole-corpus coverage well under 90%; quota healthy (claimed on Opus; foreman brake is a standing pump-silence, not a quota stop; no fleet drain). **Schedule left armed.**

**Slice advanced (Hardened Test262 intrinsics family — generator function constructors):** Added two intrinsic-metadata test262 cases for `%GeneratorFunction%` and `%AsyncGeneratorFunction%` — the constructor companions to the merged `%Generator%`/`%AsyncGenerator%` prototype cases (#1060, #1065):
- `packages/hardened262/test/intrinsics/GeneratorFunction/intrinsic-metadata.js`
- `packages/hardened262/test/intrinsics/AsyncGeneratorFunction/intrinsic-metadata.js`

An initial over-broad version regressed under lockdown/XS; I diagnosed the cause empirically (lockdown tames these evaluator constructors into inert stand-ins, non-uniformly across hosts — the SES shim keeps the name/length, XS native lockdown blanks the name, every lockdown drops length and reparents off tamed `Function`) and narrowed each case to the identity relationships coherent on **every** host: the `.prototype` back-link, reciprocal `.constructor` edge, `Symbol.toStringTag`, and `-> %Function.prototype%` link.

**Real-execution evidence:** Verified the stable subset across all four host modes — node native, node SES-shim lockdown, bare XS native (`xst`), and bare XS native lockdown (`xst scripts/lockdown.js …`), all yielding `true|true|GeneratorFunction|true` (and `…AsyncGeneratorFunction…`). Baselines regenerated with `yarn test262:update`; diff is **purely additive — 36 baseline files, +72 insertions, 0 deletions, +12 net-new passed scenario-cases** (2 files × `module`+`lockdownModule` × `sesNode`/`sesXs`/`xs`), **no covered-case regression**. Reverted an incidental pre-existing bare-xs flake on `Compartment/prototype/globalThis/defaults.js` to keep the commit strictly additive. Package unit tests: `node --test 'scripts/**/*.test.js'` → **24 pass / 0 fail**. Test files are eslint-ignored fixtures by design.

**PR:** Opened **endojs/endo-but-for-bots#1067** (draft, base `llm`, commit `073297760`) via `ensure-pr.sh` with the durable job marker (needed `GARDEN_ENSURE_PR_LIST_LIMIT=600` — the repo has 200+ open PRs). MERGEABLE, CI running.

**Merge path owned:** Recorded staged gauntlet `endojs-endo-but-for-bots-pr1067-gauntlet-20260827` via `post-gauntlet.sh` (confirmed durably on `origin/journal2`); the deterministic driver walks clean → panel → fix → un-draft.

**Recorded delta** on issue #51 (left open): https://github.com/kriscendobot/garden/issues/51#issuecomment-5446030767

**Follow-ups / remaining named residuals:** RegExp Unicode, TypedArray/ArrayBuffer, exotic MOP, runtime eval/dynamic import (Intl deferred). Newly surfaced: the `%GeneratorFunction%`/`%AsyncGeneratorFunction%` inert-constructor **name/length divergence between the SES shim and XS native lockdown** — a real shim-vs-native gap worth a dedicated divergence-documenting case or alignment fix. Next intrinsics candidates: `%IteratorPrototype%`/`%AsyncIteratorPrototype%` metadata (lockdown-stable). Whole-corpus Ironhorse total remains the 2026-08-14 checkpoint (23,496/51,976) — not extrapolated.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/test262-coverage-ratchet-20260827-222008.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 139 tokens (6555142 cached reads)
- Output: 51361 tokens
- Cost: $5.730309
- Wall-clock: 989s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
