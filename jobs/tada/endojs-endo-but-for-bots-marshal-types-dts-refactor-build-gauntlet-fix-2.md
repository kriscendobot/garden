CI is green (rc 0, 14/14 checks passed, 0 failed). All panel round-2 items applied and pushed.

## Completion report

**Job:** FIX round 2 — endojs/endo-but-for-bots PR #1061 (`refactor(marshal): move public types to declarations`)

**Panel verdict applied** (round-2 must-fix + should-fix, from the request-changes review at 04:08:52Z):

1. **prover — parameter arity not pinned** — Added tuple pins via `Parameters<…>` for `ConvertValToSlot`/`ConvertSlotToVal` in `types.test-d.ts`. A callback `expectType` stays green when a trailing param is dropped; the tuple form catches a dropped/added param, notably `ConvertSlotToVal`'s optional `iface`.
2. **EncodingUnion coverage subset** — Extended `expectAssignable<EncodingUnion>` pins to every `@qclass` member: added `NaN`, `Infinity`, `-Infinity`, `@@asyncIterator`, and the `hilbert` escape hatch (with and without `rest`).
3. **integrator — bogus `(#475)` in first commit title** — Reworded the first commit's title to drop the wrong-PR link (`move public types to declarations (#475)` → `move public types to declarations`) via a clean history rebuild; both prior commits' trees are byte-identical (verified `git diff backup HEAD` empty), only the title changed.
4. **integrator — `spell-out-exempt:` markers name a nonexistent check** — Replaced the markers in `types.d.ts` and `types.test-d.ts` with plain prose explaining why the `ConvertValToSlot`/`val` public names are kept verbatim.
5. **scribe — missing round-1 completion-summary** — Posted a top-level summary comment mapping each finding to its fix with head SHA and local status.

**Push:** history-rewriting push (reworded first commit) via `safe-push-pr-head.sh --mode rewrite`, `67bafbe00 → 372003861`.

**Local verification @ `372003861`:** `tsc` (lint:types) green, eslint green, prettier green.

**CI:** GREEN — 14/14 checks, 0 failed.

**Notes/follow-ups:** Non-blocking comment-only items (`TreeOf`/`MakeMarshalOptions` corner pins, the documented `PartialComparison` `NaN`→`number` TS-literal limitation) left as-is per the panel's disposition. tsd is a devDependency but is not wired as a CI runner for this package (no `index.d.ts`/tsd config); the test-d assertions are validated by `tsc` — the tuple pins are still strictly stronger than the callback pins there. Per stage instructions I did not re-run the panel; the driver re-posts panel-3.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-marshal-types-dts-refactor-build-gauntlet-fix-2.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 47 tokens (1711520 cached reads)
- Output: 20972 tokens
- Cost: $2.101245
- Wall-clock: 677s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
