Fae's subagent delegation no longer uses locators, and CI is green on the PR #1404 head `9809f6d979` (17 checks passed, 16 skipped, no failures; that includes all four `test` legs and `lint`).

**The matching key I chose.** Each subagent is bound in its parent under a top-level pet name, `subagent.<name>`. The daemon only reports top-level names in `fromNames`/`toNames`, so the old `subagents/<name>` binding would never have shown up. Agent names can't contain a dot, so the name after `subagent.` is always exactly the subagent's name.

**The binding moved to the host side.** The parent guest can no longer store locators, so the spawner (which holds `host-agent`) now does it: `spawn` copies the child's handle into the parent's guest (`profile-for-<parent>`) under `subagent.<name>`, and `stop` removes that name after the child is released. If that binding can't be written, the spawner releases the child rather than leave it running where nothing can reach it. `spawn` now returns `{ name }` without a locator. I removed `isSameFormula` and `SUBAGENT_DIRECTORY` because nothing uses them any more.

**How replies are matched now.** The delegation registry in `src/subagent.js` works entirely on pet names:
- **Echo of the parent's own send:** `fromNames` includes `@self` and `toNames` includes `subagent.<name>`.
- **Reply:** `replyTo` matches the sent message and `fromNames` includes `subagent.<name>`.
- **Unsolicited mail from a subagent:** still consumed, keyed on its pet name, so the loop-prevention guard still works.

`askSubagent` checks with `has` that the subagent exists, then sends to `subagent.<name>`.

**Floot changed too.** It uses the same registry and tools, so it needed the same fixes:
- Its session spawner now writes and removes `subagent.<name>` in the parent session's guest.
- Its inbox loop still called `locate('@self')`, read `from`, and called `reverseLocate`, all of which would fail in a real guest. It now recognises its own mail by `@self` in `fromNames`, and names senders from `fromNames`.

**Tests.** All four mocks now behave like a real guest: messages carry only `fromNames`/`toNames`, and the powers offer no `locate` or `storeLocator`. That covers Fae's `subagent.test.js`, `subagent-loop.test.js` and `subagent-host.test.js`, and Floot's `inbox-delegation.test.js`. I added host tests showing the spawner writes and removes the parent's binding, and releases the child if the binding fails. Floot's hosted-agent startup-delay test now delays `followMessages` instead of the removed `locate`. Locally, fae passes 158 tests (plus 2 failures that were already marked as known) and floot passes 195. eslint reports no errors, prettier passes, and the root `tsc` is clean. `SUBAGENTS.md` describes the new design.

**Follow-ups:**
- Other packages still use guest `locate('@self')`, `reverseLocate`, or a message's `from`, which this PR removes for guests: `jaine/router.js`, `chat/setup-lal.js`, `chat/setup-llm-provider.js`, `lal/setup.js`, `cli/src/commands/inbox.js`, `space-chat` and `space-whylip`. I didn't check whether these run as guests or hosts; if any run as guests they will fail the same way. That is outside this job.
- After a daemon restart, a parent still holds `subagent.<name>` for subagents that weren't pinned. This was already a documented gap; only the binding's name changed.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/ebfb-1404-fae-subagent-delegation-names.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 138 tokens (9770335 cached reads)
- Output: 41886 tokens
- Cost: $4.263482999999998
- Wall-clock: 2391s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
