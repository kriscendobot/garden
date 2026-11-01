gauntlet-status: not-viable
viability-result: overtaken
repo: endojs/endo-but-for-bots
pr_number: 1616
# gauntlet endojs-endo-but-for-bots-pr1616-gauntlet - not viable

the premise was overtaken. Deciding question: Is #1616 still the only open implementation that makes every native `await` read the awaited promise's `constructor` (the `suspend.rs` change behind the `for-await-of/...constructor-lookup-two.js` +2)? Option: close as superseded.

## Viability report

**PR #1616 viability: overtaken.** A newer open PR, #1621, makes the same change and more, so I'm not starting the gauntlet. I spent nothing on clean, panel, fix, CI-wait or un-draft.

**Current state of #1616:** open, draft and unmerged. Its head is `fdeeaad2`. It is stacked on #1615's branch `ironhorse-test262-ratchet-agen-return-broken-promise-20261101`, and #1615 is itself an open draft based on `llm-9a14ddf`. #1616 was opened at 2026-11-01T14:59Z and has no reviews or comments yet.

Deciding question: Is #1616 still the only open implementation that makes every native `await` read the awaited promise's `constructor` (the `suspend.rs` change behind the `for-await-of/...constructor-lookup-two.js` +2)?

Evidence:
- **A newer PR does the same work.** #1621 (slice 16, opened 15:51Z, about 50 minutes after #1616) is an independent, unstacked implementation based directly on `llm-9a14ddf`. It rewrites the same `schedule_native_await` path in `rust/engine/ironhorse-vm/src/interp/suspend.rs` and adds a file with the same name, `tests/await_promise_resolve_constructor.rs`. It also changes the same expectations shard, `for-await-of@@0012`.
- **#1621 covers both earlier PRs.** It ratchets #1616's rows (`ticks-with-async-iter-resolved-promise-and-constructor-lookup-two.js`, sloppy and strict) and #1615's rows (`AsyncGeneratorPrototype/return/*-broken-promise*`). It adds a RegExp `groups` fix for +10 rows in total.
- **The two PRs can't both land.** They edit the same function and the same test file, and both claim the same rows. Running a gauntlet on #1616 would mostly duplicate #1621's work.
- **They disagree about XS, and the maintainer has to decide which is right.** #1616 says it checked against the pinned XS oracle and found that XS and Ironhorse agree: a `try` around the `await` catches the getter's throw. #1621 describes a "known XS departure": it says XS's `fxStepAsync` rejects the function's own promise, so the `try` never sees the error, and it pins that departure in a test. Whichever PR is kept, its XS claim needs a check before review.

Option: close as superseded

The alternative is to keep #1616 (stacked on #1615) and narrow #1621 down to its RegExp fix. If you choose that, the gauntlet can be posted again for #1616. I changed no files in the garden or the project and opened no PR.

<!-- gauntlet-stage-result: viability=overtaken -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1616-gauntlet-viability.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 8 tokens (180761 cached reads)
- Output: 2118 tokens
- Cost: $0.45265620000000006
- Wall-clock: 29s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
