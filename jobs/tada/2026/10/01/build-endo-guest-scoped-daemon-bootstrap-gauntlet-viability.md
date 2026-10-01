Gauntlet viability report for endojs/endo-but-for-bots PR #1407: **proceed**

**PR facts:** The PR is OPEN and still a draft, and it has not been merged. Title: "feat(daemon,agent-mcp-stdio,claude): guest-scoped daemon bootstrap for the confined turn". Head is `bot/build/guest-scoped-daemon-bootstrap` and base is the frozen `llm-d4124e6`. It was opened 2026-10-01 and has no reviews yet.

Deciding question: Is the "named follow-up item 4" from #1371 still unbuilt anywhere other than #1407? That follow-up is to let the confined-turn broker resolve its guest through a daemon-issued, guest-scoped bootstrap instead of a root-host connection plus `lookupById`. A yes answer means #1407 has not been superseded and its motivation still holds.

Evidence:
- **The motivation still holds.** #1371 is merged. Its review https://github.com/endojs/endo-but-for-bots/pull/1371#pullrequestreview-5375148317 (kriskowal: "conduct and build") asked for these named follow-ups. Merged #1336 and #1226 are the earlier work that #1407 builds on, not replacements for it.
- **No competing implementation.** I searched all PRs, open and closed, for guestBootstrapPath, guest-scoped and "guest bootstrap". No other PR adds a daemon-issued guest-scoped socket or bootstrap.
- **Newer base history doesn't touch it.** `llm` is only 3 commits past `d4124e6`. All three are mount/namespace design docs, and none touches `serve-guest-path`, `agent-mcp-stdio/src`, `confined-turn`, or `designs/endo-guest-stdio-mcp.md`.
- **Related open PRs complement it rather than replace it:**
  - #1404 ("guests neither produce nor consume identifiers or locators") is a draft from the same #1371 thread. It closes host-escalation paths available to the guest; it does not provide a guest-scoped connection.
  - #1409 prunes the guest broker's tool catalog.
- **CI:** The PR's own comment says every check passes except `test (24.x, macos-15)`. It attributes those failures to flaky macOS tests that already fail on the base: an orphaned-daemon teardown test fails on the `d4124e6` macOS run too.

**Risk for the gauntlet (not a viability blocker):** #1404 removes `identify` from `EndoGuest`. #1407's `resolveScopedGuest` checks that the facet names its own `@agent` id, and that check probably relies on `identify`. Whichever lands second will need a rebase and a different self-check.

No garden or project files were changed. No clean, panel, fix, or CI budget was spent.

<!-- gauntlet-stage-result: viability=proceed -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/build-endo-guest-scoped-daemon-bootstrap-gauntlet-viability.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 8 tokens (146037 cached reads)
- Output: 2021 tokens
- Cost: $0.3940274
- Wall-clock: 68s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
