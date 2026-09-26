Ratchet turn complete. Summary of what I did:

**Serial-safety check:** The prior 19:53 peer (`test262-coverage-ratchet-20260827`) was doomed by the reaper for deadline-overrun and parked in `plan/`; the 20:05 fire deferred. No live coverage worker held the ratchet, so I pressed.

**Stop conditions (checked first):** none held — deadline 2026-08-28T15:00Z not yet reached (now ~2026-08-27T21:32Z), whole-corpus coverage well under 90%, quota fine. Schedule left armed.

**Slice advanced (Hardened Test262 intrinsics family):** added a sync **Generator** intrinsic-metadata test262 case (`packages/hardened262/test/intrinsics/GeneratorPrototype/intrinsic-metadata.js`), the companion to the merged `AsyncGeneratorPrototype` case from #1060 — pinning `%GeneratorPrototype%` constructor identity, `next`/`return`/`throw` name+length, the `[object Generator]` toStringTag, and the assignable function prototype.

**Real-execution evidence** (local, all three agents including bare XS via `xst` at `/home/kris/garden/bin/xst`): passes in `module::` and `module:lockdown:` under `sesNode`, `sesXs`, and `xs`. Baselines regenerated with `--update-baseline`; diff is **purely additive** — 36 baseline files each `+1` plus the new test, **+6 net-new passed scenario-cases, no covered-case regression** (I reverted an unrelated bare-xs flake on `Compartment/prototype/globalThis/defaults.js` that the full run incidentally drifted, keeping the commit strictly additive).

**PR:** opened **endojs/endo-but-for-bots#1065** (draft, base `llm`, commit `e780e91f1`) via `ensure-pr.sh` with the durable job marker; CI running, MERGEABLE.

**Recorded delta** on issue #51: https://github.com/kriscendobot/garden/issues/51#issuecomment-5445464364 (left open for the submitter, as directed).

**Merge path owned:** posted follow-on `endojs-endo-but-for-bots-pr1065-gauntlet-20260827` to drive #1065 clean→panel→fix→un-draft.

**Follow-ups / remaining named residuals:** RegExp Unicode, TypedArray/ArrayBuffer, exotic MOP, runtime eval/dynamic import (Intl deferred). Next intrinsics-family candidates: `%GeneratorFunction%`/`%AsyncGeneratorFunction%` and `%IteratorPrototype%`/`%AsyncIteratorPrototype%` metadata. The whole-corpus Ironhorse total remains the 2026-08-14 checkpoint (23,496/51,976) — not extrapolated.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/test262-coverage-ratchet-20260827-212008.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 96 tokens (3731636 cached reads)
- Output: 29291 tokens
- Cost: $3.4587760000000003
- Wall-clock: 681s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
