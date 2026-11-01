# Completion report: design-ironhorse-in-crank-string-garbage-chunk-ceiling

I wrote the design and opened it as **draft PR https://github.com/endojs/endo-but-for-bots/pull/1622**. Its base is the frozen snapshot `llm-9a14ddf`, which is the current `llm` tip. The diff has two files: `designs/ironhorse-in-crank-string-garbage.md` and one new row in the index in `designs/README.md`. I confirmed the PR is draft and that those are the only changed files.

## What the design says
- **Problem:** about 820 test262 rows halt with `HeapExhausted` at the 256 MiB chunk ceiling. The harness function `buildString` concatenates about 110 times, and each step copies the whole string, leaving about 250 MiB of garbage. Collection is only allowed at quiescence, so none of it is reclaimed during the crank. The code backs this up: `concat_add` builds a new chunk with a copy of the whole result on every `+`.
- **Recommended, option (a):** run full collection inside a crank, but only at a dispatch-loop safepoint. That means between instructions, with native depth zero, no pending halt, and the `gc_failed` latch clear.
  - The trigger depends only on machine state, so every replica collects at the same instruction. It fires when used bytes exceed half the ceiling and at least a quarter of the ceiling has been allocated since the last collection. The second condition stops a guest from forcing collections over and over.
  - Collection charges nothing to the meter, so guest results and meter receipts are the same with or without it.
  - Weak-reference targets are kept alive until quiescence, so weak behavior is unchanged.
  - The design includes the ownership map the designer role requires.
  - The main catch: this changes the completed `ironhorse-quiescent-gc` design. That design's concern was guest values held in Rust locals while native code runs, and native depth zero rules that out. This is the first open question for the maintainer.
- **Option (b), avoiding the full-string copy:**
  - Growing the string in place isn't possible with the current layout. The length lives in the chunk header, a slot holds only an offset, and nothing tracks whether a string is uniquely held.
  - Ropes would work but are a large change: about 183 `Payload::String` sites, 38 direct payload reads, the collector would have to trace chunk-to-chunk links, and the snapshot schema needs a new chunk kind. They also fix only strings, not object garbage.
  - I kept ropes as a possible separate performance design rather than part of this fix.
- **Option (c), a larger ceiling for the test harness only:** rejected. It hides the gap, and 512 MiB is already the maximum ceiling a consensus build accepts.
- **RGX-1 review points:**
  - When a match exceeds the matcher's limits, throw a `RangeError` the guest can catch instead of halting the machine. The limit only covers the matcher's own scratch storage and leaves the heap untouched, so a halt isn't needed. This fits the rule the NVAL-9 review finding asks for.
  - Clamp quantifier bounds above 2^31-1 to `0x7FFFFFFF`, as XS does, instead of halting with `ResourceLimit`. The `{m,n}` check for `m > n` must use the exact values before clamping. Today digits saturate at `u32::MAX`, so `{4294967296,4294967295}` wrongly passes when it should be a SyntaxError.
- The design also has a test plan, a build order, and three open questions:
  1. Does the maintainer agree to change the quiescent-collection rule?
  2. Should the trigger thresholds be fixed or set by the embedder?
  3. Which skip class should test262 rows use when they now throw the matcher's `RangeError`?

## Follow-ups
- **The design depends on PR #1618 (matcher run compression), which is still open.** It is step 1 of the build order.
- **Build:** `build-ironhorse-in-crank-string-garbage` (the completion handoff posts it). Order:
  1. The RegExp changes (catchable limit, quantifier clamp). These are small and don't depend on the collection decision.
  2. Safepoint collection, once the maintainer agrees to the change to the quiescent rule.
- Ropes for the string-append slowdown (review finding NVAL-3) would be a separate design. Not yet filed.
- I'm leaving the PR as a draft; the design-review gauntlet is recorded automatically when this job completes.

<!-- garden-design-build-handoff: successor=build-ironhorse-in-crank-string-garbage-chunk-ceiling state=recheck:endojs-endo-but-for-bots-pr1622-gauntlet pr=https://github.com/endojs/endo-but-for-bots/pull/1622 -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/design-ironhorse-in-crank-string-garbage-chunk-ceiling.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 64 tokens (2920199 cached reads)
- Output: 25185 tokens
- Cost: $1.9774518
- Wall-clock: 452s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
