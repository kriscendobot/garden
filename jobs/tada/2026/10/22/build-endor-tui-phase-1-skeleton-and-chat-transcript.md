**Completion report: `build-endor-tui-phase-1-skeleton-and-chat-transcript`**

I built Phase 1 of `designs/endor-tui.md` (skeleton and chat transcript) and opened it as draft PR https://github.com/endojs/endo-but-for-bots/pull/1525. The PR is based on the frozen base `llm-f02cd81` (the current `llm` tip) and its head branch is `endor-tui-phase-1` (commit `f14943228e`). The 26 new unit tests pass, but I didn't wait for CI and haven't tried it against a live daemon.

**Biggest limitation:** the daemon doesn't serve the TUI's bus verbs yet. They are specified in `designs/endor-bus-tui.md`, which is still Not Started. So the messages carry provisional JSON payloads, and against today's daemon the TUI connects, shows "live", and then receives nothing. Changing the payload format later only touches two functions, `encode_request` and `decode_event`.

**What's in the PR** (new module `rust/endo/src/tui/`):
- **`endor tui` subcommand**, added to `endor.rs` with its help text. It is built on `ratatui` 0.29 and `crossterm` 0.28, which are new dependencies in `rust/endo/Cargo.toml` and `Cargo.lock`. The terminal is put back to normal on every exit path, including a panic.
- **`state.rs`:** the screen's logic, separate from the drawing so it can be unit-tested:
  - the normal, insert and focus modes;
  - the modeline at the bottom, which changes with the mode;
  - `@name text` sends a message, and Space on an empty bar pre-fills the last recipient;
  - `/dismiss`, `/adopt` and other slash commands go through `command.submit`, and their results show in the pending area;
  - `:quit`, `:reconnect`, and `Ctrl+C` / `Ctrl+L`;
  - in focus mode, `d`, `a` and `r` pre-fill a command for the selected message.
- **`bus.rs`:** the connection to the daemon, using the existing CBOR envelope framing. It subscribes to the inbox and inventory on each connect. If the daemon goes away it retries with growing delays, capped at 10 s, and keeps the last screen visible.
- **`ui.rs`:** the layout from the design: inventory, header, transcript, pending area and command bar.
  - The inventory hides below 60 columns.
  - A banner appears when the daemon is lost.
  - The transcript scrolls to keep the focused message on screen.
- **`mod.rs`:** the main loop. A window resize triggers a redraw.
- **Design doc:** I set the status of `designs/endor-tui.md` to "In Progress (Phase 1)".

**Verification:**
- `cargo test -p endo --lib tui`: 26 passed. These include a real Unix-socket test that drops the server and checks the reconnect, and screen-rendering tests at 80×24 and 50×24.
- `cargo build --bin endor` succeeds and `endor help tui` prints the new help.
- `cargo clippy` is clean on the new module, and the new files are formatted with rustfmt.
- To build locally I had to initialise the `c/moddable` submodule and create empty, gitignored bootstrap `.js` files; neither is committed.

**Process notes:**
- `ensure-pr.sh` had to be run from inside the project checkout: its phase-evidence check reads the current directory as the repo.
- That check also can't resolve design paths written as full GitHub blob URLs, so the PR body refers to the designs by repo path instead.

**Follow-ups:**
- CI on #1525 still needs to run, then the gauntlet (clean → panel → fix-loop → un-draft).
- Implementing `designs/endor-bus-tui.md` is what will make the TUI actually show messages.
- Phase 2 (spaces and focus mode) is next.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/build-endor-tui-phase-1-skeleton-and-chat-transcript.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 70 tokens (2944642 cached reads)
- Output: 33456 tokens
- Cost: $2.0284804000000003
- Wall-clock: 532s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
