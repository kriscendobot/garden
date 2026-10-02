# Fix round 5 for endojs/endo-but-for-bots#1390: fix pushed, CI green

I fixed the panel's blocking finding and pushed it. CI finished green with all 33 checks passing and none failed (`ci-wait-merge` exit 0).

**What the panel found:** the latest verdict was posted at head `e8097d6d`. Its main must-fix, raised by assessor and breaker, was that nested `@` mentions were always refused. When you drill into a directory, the autocomplete builds a token like `team/bob`. Every place that sends that token to the daemon wrapped it as the single name `['team/bob']`. A pet name can never contain `/`, so the daemon refused every nested mention.

**What I changed:** the chat UI now splits on `/` wherever it turns a mention token or typed name into a pet-name path. This applies both to the `identify` call and to the path that gets sent or posted:
- **`packages/spaces-util/src/send-form.js`:** the channel post, the conversation send, the plain send, and the single-token value modal.
- **`packages/spaces-util/src/command-executor.js`:** `reply` in channel and inbox mode, plus `accept` and `adopt-locator`. That last pair was the panel's should-fix: those two still wrapped typed names as one segment, so the whole command line now uses the same split rule.
- **`packages/spaces-util/src/chat-bar-component.js`:** the eval and endow modals, for endowments, worker name and result name.
- **`packages/space-channel/src/outliner/controller-intents.js`:** posting edits and drafts, including the ID lookup.
- **`packages/chat/chat.js`:** the check that a mentioned name is valid before a mention notification goes out.
- **`packages/chat/mention-send.js`:** both the channel name and the recap pet names.

I updated the tests that had pinned the old one-segment behaviour: `send-form.test.js`, `command-executor-channel.test.js` and `mention-send.test.js`. I also corrected the PR body, which still said UI widgets never split names on `/`. It now says the chat UI splits at its boundary while agent adapters still wrap names as `[name]`.

**Commits** (pushed with `safe-push-pr-head.sh`, `e8097d6deb` → `28ca4024b7`):
- `08b4ced3bb` fix(chat,spaces): split slash-joined mention tokens into pet-name paths
- `28ca4024b7` fix(spaces-util): split typed names for accept and adopt-locator too

**Checks before pushing:** 92 tests passed across the affected `@endo/chat` unit and component files. `tsc` found no errors for spaces-util, chat or space-channel, either per package or in the repo-root check. eslint reported warnings only, and prettier made no changes.

**Not addressed:** six seats (changeset-auditor, migrator, saboteur, stylist, typist, wire-watcher) voted must-fix, but the stored panel record was cut off before their findings were written down. There was nothing concrete for me to fix. The next panel round re-runs those seats on the new head, which should surface what they want.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/ebfb-petname-path-only-sweep-4-gauntlet-fix-5.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 92 tokens (3778011 cached reads)
- Output: 15644 tokens
- Cost: $1.8189462000000003
- Wall-clock: 2531s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
