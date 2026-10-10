# Weave report: endojs/endo-but-for-bots#179

https://github.com/endojs/endo-but-for-bots/pull/179 is woven onto the current `llm` tip and every CI check that runs on it passes (19, including lint, cover, and the four test legs). One exception: the Browser Tests workflow does not run on this PR at all. I ran its new spec locally instead.

## Rebase and base move
- **New base:** the PR base moved from floating `llm` to frozen `llm-7d2eb30`, which was already pushed and points at the `llm` tip `7d2eb307a2`. The head was rebased with `--onto` from the old merge base `438d30809a`. The full clone was shallow, so I unshallowed it first to find the real merge base.
- **Head:** `feat/daemon-chat-commands-as-messages` is now `a9241aa8fe` (was `e7506fa3e4`), force-pushed with lease. It is 18 commits on the frozen base, touching 23 files, and GitHub reports it MERGEABLE.
- **Dropped commit:** `153975507e` (a Prettier-only change to `index.css`) was skipped as already upstream.

## Conflicts that needed judgment
- **Chat rendering moved packages.** On `llm`, the inbox view moved out of `packages/chat/inbox-component.js` (imperative DOM) into `@endo/space-chat` (`src/inbox.js`, a confined Preact tree). So I:
  - kept `llm`'s host wrapper unchanged;
  - added the command cards as a Preact `CommandCard` in `packages/space-chat/src/command-message.js`, exported from the package, replacing the PR's DOM-based `packages/chat/command-message.js`;
  - routed `command`/`command-result` to it in the inbox and kept the `command-envelope` class and CSS;
  - adapted the unit and component tests to Preact and the reader-based message feed.
- **Browser fixture.** It now uses `llm`'s lockdown preamble (`pre-lockdown.js` + `@endo/init`) and the reader-based `followMessages`, and signals ready once every card has rendered. The `tsconfig` excludes were combined.
- **Daemon tests.** On `llm`, `followMessages()` returns a reader, so `nextConversational` takes a local iterator and the new tests wrap their subscriptions with `iterateReader`.
- **Daemon source.**
  - `daemon.js` was renamed to `manager.js` on `llm`; git carried the PR's `makeMessageHub` changes over and the `command`/`command-result` branches are kept. `llm` gained no new message types there.
  - `llm` made `done` a required field on stamped messages, so I added it to both command branches in `mail.js`.

## Fixes needed to get CI green
- **Message-order tests added on `llm`:** the two `editMessage` tests in `endo.test.js` and the restart test in `request-result.test.js` now skip command records. The restart test was failing intermittently on macOS.
- **New CLI behavior (please review).** The PR was already broken against the CLI walkthrough tests at the old base; CI just never ran.
  - `endo inbox` printed command records as "unrecognizable message… consider upgrading". It now prints them, e.g. `you ran "adopt …"` and `succeeded "…" in reply to #N`, mirroring the chat cards (new commit `fix(cli)`).
  - The CLI demo walkthrough tests are renumbered: alice's message is 5 rather than 1, and the host's message from alice is 7 rather than 3.
  - `packages/cli/demo/README.md` was left unchanged, so its numbering no longer matches. Its host numbering already disagreed with the tests before this PR.
- **Lint:** the new Playwright spec used `getComputedStyle` without declaring it, and a peer job's type-cast commit (`8201130d4b`, from the `endojs-endo-but-for-bots-pr179-address-review-20261007` job) moved an `await` off its lint-disable line. I fixed that with a commit on top and messaged the peer job to fetch before pushing again.

## Local verification
- Chat unit and component tests: 12/12 pass.
- Daemon `endo.test.js`: all pass except one mount test that failed on leftover tmp state from my own earlier local run (`EEXIST`), not the PR. `request-result` passes, and daemon and chat type checks pass.
- CLI walkthrough tests: 8/8 pass.
- Browser fixture: builds, and `chat-command-messages.spec.js` passes 4/4 in local headless Chromium. I compared `browser-test/server.js` and the workflow against `llm`; they merged cleanly.

## Follow-ups for the maintainer
1. **Browser Tests never runs on frozen-base PRs.** `browser-test.yml` only triggers for PRs based on `master`/`llm`, so it is absent (not skipped) here. Widening the trigger to `llm-*` is a CI-policy decision, and I did not change it.
2. **CLI choices made during the weave:** how `endo inbox` shows command records, and the renumbered walkthrough (plus the README numbers, still unchanged). Both depend on the open `dismiss` question; if `dismiss` stops recording, the numbers shift again.
3. Command records store `send` arguments as joined arrays, which shows up as `send Please enjoy this  . alice`. That is existing PR behavior and I left it alone.
4. I did not change behavior for either open question from the PR comment. The row stays arc unallocated, milestone M9.

## Manual gauntlet handoff

The completion guard found https://github.com/endojs/endo-but-for-bots/pull/179 ready without gauntlet coverage. A deduplicated review-docket decision was recorded; the PR was not re-drafted and no gauntlet was staged.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr179-weave-20261010.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 4 on 1 host(s) (3 unmetered)
- Input: 8 tokens (974229 cached reads)
- Output: 3449 tokens
- Cost: $7.832751800000001 (3 engagement(s) unpriced)
- Wall-clock: 7246s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
