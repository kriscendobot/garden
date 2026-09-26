Inbox empty; time 09:42Z (before the 15:00Z deadline); coverage far under 90%; quota healthy — **schedule stays armed**, not retired. This turn's deliverables live in the project repo + journal (PR, gauntlet, issue comment); my garden worktree has no main2 changes to push. Done.

## Completion report

**Job** `test262-coverage-ratchet-20260828-093506` — serial test262-coverage ratchet turn (kriscendobot/garden #51).

**Stop conditions (checked FIRST, none held):** ran ~09:35–09:43Z; deadline `2026-08-28T15:00Z` still ~5h away; whole-corpus coverage far under 90% (23,496 / 51,976 at the 2026-08-14 checkpoint); quota healthy (Opus, foreman braked is a standing maintainer directive, not quota exhaustion; no fleet drain). **Schedule left armed.**

**Serial safety:** `jobs/doin/` held no live coverage *ratchet* worker. The one concurrent activity was the **#1076 gauntlet** (`...-fix-1` in `doin/`) finalizing the prior `%ThrowTypeError%` advance on its own branch. Rather than collide with that in-flight branch, I pressed the two named residual intrinsic families on a fresh branch — honoring the 2026-08-28 "each turn supplements or creates a PR" directive.

**Slice advanced — `%RegExp.prototype%` + `%Promise.prototype%` intrinsic metadata (hardened262 suite):** two new cross-host conformance tests, each reaching a well-known intrinsic **without its constructor global** (matching the established iterator/generator-prototype pattern):
- `%RegExp.prototype%` via a regexp literal's prototype — pins `exec` name/length, the `Object.prototype` chain, the prototype-only `source` (`'(?:)'`) tell that no host smuggled a real RegExp into the slot, and the `match`/`replace`/`search`/`split` well-known-symbol methods.
- `%Promise.prototype%` via an async arrow's returned promise — pins `then`/`catch`/`finally` typeof/name/length, `Symbol.toStringTag` (`'Promise'`), and the `Object.prototype` chain.

**Real-execution evidence:**
- `node scripts/test.js test/intrinsics/{RegExpPrototype,PromisePrototype}/intrinsic-metadata.js` → `# ok` on **module** + **lockdownModule** for all three agents (`xs`, `sesXs`, `sesNode`); every other scenario `# skip`; **0 `not ok`**.
- `yarn test262:update`: **strictly additive — +12 net-new covered scenario-cases** (2 tests × 3 agents × {module, lockdownModule}), **72 added / 0 deleted**, 0 failed additions, no covered-case regression. Reverted the incidental pre-existing bare-`xst` `Compartment/prototype/globalThis/defaults.js` host-version flake to keep the diff additive.
- Golden `node --test 'scripts/**/*.test.js'` → 24 pass / 0 fail; `yarn lint` → rc 0.

**PR:** opened **endojs/endo-but-for-bots#1077** (draft, base `llm`, head `test/hardened262-regexp-promise-intrinsic-metadata`, commit `3baf7bfcf`) via `ensure-pr.sh` with the durable job marker. Staged gauntlet **`endojs-endo-but-for-bots-pr1077-gauntlet-20260828`** (clean → panel → fix → un-draft) owns the merge path.

**Delta recorded** on issue #51 (left open): https://github.com/kriscendobot/garden/issues/51#issuecomment-5450982135

**Whole-corpus total:** unchanged from the 2026-08-14 checkpoint — a hardened262-suite advance, not extrapolated.

**Remaining residuals / next candidates:** `%WeakMap.prototype%` / `%WeakSet.prototype%` / `%Map.prototype%` / `%Set.prototype%` intrinsic metadata (hardened262); engine-side RegExp Unicode, exotic MOP, runtime eval/dynamic import (Intl deferred). Schedule remains armed for the next serial turn.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/test262-coverage-ratchet-20260828-093506.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 73 tokens (2558207 cached reads)
- Output: 25935 tokens
- Cost: $2.650638500000001
- Wall-clock: 454s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
