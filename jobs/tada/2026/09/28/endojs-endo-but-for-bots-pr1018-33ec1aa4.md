Replied on PR #1018 with a link to the implementation PR, #1150.

**The ask:** kriskowal asked, in comment 5878281861 on #1018 (the merged design for the Ironhorse panic mechanism and message embargo), for a link to the implementation PR.

**Preflight:** the check returned exit 2, but the only matching text was our own "On it" reply (5878310635). No peer had linked anything, so I went ahead.

**Finding:** the implementation is endojs/endo-but-for-bots#1150, "feat(ironhorse,xsnap): formal Panic category + live FFI-abort guard". It is on branch `build/ironhorse-panic`, merged into `llm` on 2026-09-07, and its body says `Refs: #1018`.

**Reply posted:** https://github.com/endojs/endo-but-for-bots/pull/1018#issuecomment-5878324666 (carries the `<!-- garden-reply:5878281861 -->` marker). It links #1150 and says the implementation is partial:
- **Done in #1150:** the `Halt::Panic` category, the `is_panic()` check, the `ExecutionOutcome` classifier, and guards on every xsnap FFI callback so a Rust panic kills only its own worker.
- **Not implemented yet:** the message embargo, the crank-commit boundary, and transcript replay. The design deferred these to a follow-on; the closest open design is #989.
- **Designed separately:** making a reference error panic instead of throw is covered by #1016, which is still open.

**Changes:** no code or garden changes.

**Follow-ups:** none required. The embargo and crank-commit work may need a design or build decision on #989 later.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1018-33ec1aa4.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 16 tokens (401387 cached reads)
- Output: 2283 tokens
- Cost: $0.5212494000000001
- Wall-clock: 34s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
