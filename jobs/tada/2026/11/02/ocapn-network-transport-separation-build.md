I built the next unfinished step of the design and opened it as draft PR endojs/endo-but-for-bots#1636: `@endo/ocapn-noise/hints`, which parses and renders `<transport>+<codec>` connection hints. CI isn't fully green yet. One test leg failed, in an unrelated sandbox test, and the other test legs were still running when I stopped.

**What had already landed.** None of the design's earlier steps is on `llm`. Each one is still an open PR:
- **Step 1, single TCP hint:** #1072, which has the maintainer's changes requested.
- **Step 2, `tcp+cbor` framing:** #1513, draft.
- **Step 3 and part of step 4, separating `addTransport` from `network.listen`:** #1507, draft.
- **Step 4, keying `.np` sessions on network and designator:** #1477, also with the maintainer's changes requested.

The piece nothing covered was the grammar for the new hint keys: Migration Plan step 1 and the "hint grammar" item in the design's Test Plan. That can merge on `llm` without waiting for any of the four.

**What changed** (all in `packages/ocapn-noise` unless noted):
- **New module `src/hints.js`**, exported as `./hints`:
  - `makeHintKey` / `parseHintKey` handle the `<transport>+<codec>` key, such as `tcp+cbor` or `wss+cbor`.
  - `formatHint` / `parseHint` handle a decoded locator component, `<transport>+<codec>:<value>`.
  - `formatAuthority` / `parseAuthority` handle the TCP value, `host:port`. IPv6 addresses are bracketed in the hint and come back unbracketed.
  - `formatAuthorityPath` / `parseAuthorityPath` handle the WebSocket value, `host:port/path`, where the path is required.
  - The parsers are strict: they reject a user name before the host, a scheme, a query, whitespace and control characters, an unbracketed IPv6 address, and a port outside 1–65535 or with a leading zero.
- **New tests, `test/hints.test.js`:** 10 tests that round-trip hints through a percent-encoded `@`-separated locator path. They cover IPv6, a `wss+cbor` value with a path, an `@` inside a path, and the design's two-hint example, plus the rejection cases.
- **Docs:** a "Connection hint grammar" section at the end of the README and a minor changeset (`.changeset/ocapn-noise-hint-grammar.md`). The PR also adds the `./hints` export to `package.json`.
- **Base branch:** the PR targets a frozen snapshot of `llm`, `llm-48d6f3e`, from branch `feat/ocapn-noise-hint-grammar`.

**Checks.**
- **Locally:** the package's full suite passes (88 tests), as do its type check, eslint on the new files and prettier.
- **On the PR:** lint, coverage, build and release checks pass. The `test (24.x, ubuntu-latest)` leg failed on one test, `bwrap timeout and repeated cancellation reap process groups` in the sandbox code. That test isn't touched by this PR, and the same red is already being fixed in #1591 and #1542. The ubuntu 22.x and both macOS test legs were still pending when I stopped. The gauntlet will need to rerun or wait out that failure.

**Follow-ups.**
- **Decision for the maintainer:** in the #1072 reviews (2026-08-31 and 09-03), the maintainer asked for hints to be a priority-ordered list that can hold several hints for one transport-and-codec pair (one per network address). The design on `llm` still says exactly one hint per pair, stored in a string table. The design doc needs to be brought in line with that review. The new module handles one hint at a time, so it works either way. The PR body flags this.
- **Remaining work:** have the TCP and WebSocket transports publish these hints, collect them in `locationFor`, reject duplicates, and fall back through hints in order. That depends on #1507 and #1513 landing first.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/ocapn-network-transport-separation-build.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 82 tokens (3729097 cached reads)
- Output: 23105 tokens
- Cost: $2.0337114
- Wall-clock: 2704s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
