## Viability for kriscendobot/endo-but-for-bots PR #1: proceed

PR #1 ("feat(daemon): add capability-scoped XS directory watches") is still needed and nothing newer has replaced it, so the gauntlet can begin. It is open, not a draft and not merged. Head is `979641659`, base is `llm-e2c6ff8`. The only review so far is the bot's own earlier panel review (COMMENTED, verdict "pass", 23/23 CI green on this head). No maintainer has reviewed it and there is no discussion.

**Deciding question:** Does `llm` on endojs/endo-but-for-bots still ship the Rust/XS `watchDirectory` stub that ends immediately, with no other merged or open change giving it a capability-scoped watch backend?

**Answer: yes.**

**Evidence:**
- **Issue #606 is still open.** The PR says "Closes #606", and endojs/endo-but-for-bots#606 ("Rust/XS supervisor: watchDirectory is snapshot-only…") has not been closed. The maintainer asked for this direction on 2026-07-18: "Let's explore producing our own watcher bindings to augment cap-std … eg cap-std-watch".
- **The design is accepted.** endojs/endo-but-for-bots#793 (design(cap-std-watch)) is MERGED, and this PR implements it.
- **Current `llm` still has the stub.** In `packages/daemon/src/bus-manager-rust-xs-powers.js:442`, `watchDirectory` returns an iterator that is done at once. `rust/endo/xsnap/src/powers/` has no `watch.rs`, and neither `fs.rs` nor `lib.rs` mentions "watch". The last three commits to that JS file (09-20, 09-04, 07-17) do not touch watching.
- **No competing implementation.** No upstream PR uses `build/cap-std-watch` or a similar branch.
- **The nearest sibling doesn't replace it.** endojs/endo-but-for-bots#592 is a draft, idle since 09-02, and only refactors the Node watcher into `@endo/platform`. In the XS file it keeps the stub that ends immediately, and its comment says real events are blocked on cap-std. That is exactly the gap this PR fills. The two will conflict, though: #592 changes `watchDirectory`'s signature to `(path, options)` and its return value from `{events, cancel}` to bare `events`.

**Notes for later stages (no budget spent here):**
- The base `llm-e2c6ff8` is 2826 commits behind `llm` (0 ahead). The PR will need a weave (pin the merge base) before it can merge.
- Whichever of #1 and #592 lands second must reconcile the `watchDirectory` signature and return value.
- The earlier panel's non-blocking follow-ups still stand:
  - no `cargo test` CI lane covers `watch.rs`;
  - the kqueue wakeup path is untested;
  - non-UTF-8 file names collapse to one key, and some changes between polls go unreported.

<!-- gauntlet-stage-result: viability=proceed -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-endo-but-for-bots-pr1-gauntlet-20261007-viability.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 14 tokens (339953 cached reads)
- Output: 3150 tokens
- Cost: $0.5091186
- Wall-clock: 48s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
