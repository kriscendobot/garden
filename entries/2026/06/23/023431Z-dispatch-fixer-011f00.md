---
kind: dispatch
role: fixer
host: endolinbot
posture: liaison
short_id: 011f00
dispatch_root: dispatches/fixer--011f00
repo: endojs/endo-but-for-bots
branch: feat/lal-pi-harness
pr_number: 290
model: sonnet
---

RSVP kriskowal's comment on PR #290 (issue comment 4775079797,
2026-06-23T02:33:11Z, https://github.com/endojs/endo-but-for-bots/pull/290#issuecomment-4775079797).

Maintainer pushed `0fc0183f` (fix(lal): detect installed inference
engine; serialize BigInt message numbers) as a tacked-on commit
and asks:

1. **Retcon**: fold the tacked-on commit into the right per-package
   commits rather than leaving as a fixup. The three conflict
   resolutions to preserve:
   - `lal/setup.js` — `qwen3.6` default bump now feeds the probe as
     `defaultModel` (preserve maintainer's comment/intent)
   - `chat/setup-lal.js` + `chat/setup-llm-provider.js` — kept
     `iterateReader`, dropped `makeRefIterator`
2. **Run the gamut**: `yarn format`, `yarn lint` (lal/chat/jaine/
   fae), `tsc`, lal `ava` suite, Familiar's `bundle-smoke` test.
   Watch:
   - chat `tsc` around `iterateReader` message-loop typing
   - `@endo/exo-stream` resolution under `@endo/lal` (needs fresh
     `yarn install` due to dep churn from the force-push)

Current branch shape (`git log --oneline origin/llm-0458d1f..HEAD`):
- 139270131 refactor(daemon): export pet-name shapes from @endo/daemon/type-guards.js
- e9a9afd96 refactor(lal): adopt @endo/genie pi-based harness; default ollama model qwen3.6; swap pi-agent-core/pi-ai to @earendil-works per llm convention
- e068baf80 chore: Update yarn.lock
- 0fc0183fc fix(lal): detect installed inference engine; serialize BigInt message numbers (maintainer's fix)

Expected post-retcon shape:
- daemon commit (pet-name shapes) — unchanged
- lal commit (pi-based harness + qwen3.6 + earendil + engine detect +
  BigInt serializer; this is where the maintainer's lal/setup.js
  changes fold in)
- chat commit (or fold into existing) for setup-lal.js +
  setup-llm-provider.js (kept iterateReader)
- jaine commit (setup.js engine detect)
- fae commit (submit-provider.js engine detect)
- yarn.lock commit

Net diff invariant against `0fc0183fc`. Run the maintainer's named
gamut steps locally before pushing.
