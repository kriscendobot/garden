I built Phase 1 of the endor-bus-tui design and opened it as draft PR https://github.com/endojs/endo-but-for-bots/pull/1533 (branch `endor-bus-tui/phase-1-region-store`, base `llm-54d3d2a`, which is the current `llm` tip). The new tests pass locally; I did not wait for CI, which the staged gauntlet will run.

**What Phase 1 adds (all in `rust/endo`, commit `3ffd88673c`):**
- **Store:** a new `src/tui_store.rs` holds each worker's windows and regions, keyed by the worker's own handle, so a worker can't see or change another worker's state. It has one screen (ID `1`), and `dispatch()` decodes a request, applies it and encodes the reply.
- **Verbs:** `getScreen`, `createWindow`, `configureWindow`, `destroyWindow`, `createRegion`, `destroyRegion`, `setText` and `appendLines`. Region roles `status`, `input` and `canvas` return `wrong-role`; `initialRegions` returns `bad-argument`.
- **Codec:** `src/codec.rs` gets a small CBOR reader/writer plus encode/decode for every Phase 1 request, reply and error, using exactly the keys in the design's Layer 1. A missing key, a wrong type, an unexpected or duplicate key, or an unknown verb returns `bad-argument`.
- **Daemon:** one `tui.*` branch in `handle_control_message` in `src/endo.rs` replies with the request's nonce. Success echoes the request verb; failure sends an `error` envelope with `{ code, message }`.
- **Cleanup on exit:** the supervisor owns the store, and `Supervisor::unregister` deletes everything a worker owned. The terminated-worker path in `process_meter_report` goes through that too.
- **Limits:**
  - Buffer scrollback is capped at 10,000 lines, which is also the default. The oldest lines are dropped first and line numbers keep counting.
  - More than 1 MiB of text in one `setText` or `appendLines` returns `too-large`.
  - CBOR nesting is capped at depth 16.

**Tests:** all 41 tests in the tui, codec and supervisor modules pass. They cover every acceptance test the design lists for Phase 1 (store, codec round-trip, dispatch and the supervisor cleanup test). `cargo clippy -p endo --all-targets` shows no warnings in the new code.

**Decisions and things to know:**
- **Choices the design left open:** success replies reuse the request verb. `scrollback` on a text region, `scrollback < 1`, an empty `lines` array and `screenId != 1` all return `bad-argument`. `createWindow` requires a `layoutHint` map, but every field in it is optional. The PR description lists these for reviewers.
- **Design is unmerged:** #1528 is still open, so the design file isn't in this branch. The PR's phase/evidence check refused the body while it named `designs/endor-bus-tui.md` by path, because it couldn't find that file. I changed the body to link the design PR's URL instead.
- **Local build setup:** to build, I ran `git submodule update --init c/moddable` and created placeholder `xsnap/src/*.js` bundle files in the project worktree. Neither is committed.
- **Shared temp files:** while hunting for my PR body file I ran a `sed` on another job's temp file in `$TMPDIR` by mistake. My search patterns weren't in that file, so it was left unchanged.

**Follow-ups:**
- The gauntlet for #1533, which completion stages automatically.
- Phases 2 (`endor tui` renders worker windows; also needs #1525) and 3 (the XS `endor:tui` module) can be built in parallel once this merges.
- There is no limit yet on how many windows or regions one worker can create; the design leaves that to Phase 7.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/build-endor-bus-tui-phase-breakdown-open-pr.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 72 tokens (3257120 cached reads)
- Output: 39692 tokens
- Cost: $2.3200559999999997
- Wall-clock: 577s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
