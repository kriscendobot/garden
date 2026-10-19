I've opened draft PR https://github.com/endojs/endo-but-for-bots/pull/1505 with Phase 1 of the #711 design: the daemon's private socket now accepts both netstring and cbor-frame clients. Nothing that opens a connection changes its framing yet, so existing peers see the same bytes. The new tests pass; the only local failure I saw is the channel-relay suite, explained below.

The PR's head is `feat/daemon-cbor-frame-seam`. Its base is `feat/cbors-package-3ee0814`, a frozen copy of #288's branch at `3ee0814`, which `ensure-pr.sh` required instead of the moving branch. It has three commits: the feature, a changeset, and a separate `chore: Update yarn.lock`.

**What changed**
- **`packages/daemon/src/framing.js` (new):** reader and writer makers for a chosen framing, plus a classifier that picks the framing from a connection's first byte. A "sniffing" reader classifies the connection, then hands off to the matching reader. A "gated" writer holds outbound frames until that choice is made, so the daemon can't guess wrong; closing never waits on it, so a client that connects and stays silent can't hang shutdown.
- **`connection.js`:** adds `makeFramedCapTP(framing, …)` and `makeSniffingCapTP`. `makeNetstringCapTP` is now a one-line alias, so its ten call sites are untouched.
- **`serve-private-path.js`:** each accepted connection replies in whatever framing the client chose.
- **`rust/endo/src/socket.rs`:** the Rust supervisor's socket bridge does the same. It peeks the first byte without consuming it, reads and writes cbor-frame alongside netstring with the same 16 MiB cap, and its write side waits for the classification.
- **Dependencies:** `@endo/cbor-frame` added to the daemon, with the generated tsconfig reference and a changeset (`@endo/daemon` minor).

**Deviation from the design (explained in the PR):** the design wanted CapTP frames written without the CBOR tag-24 prefix. The package in #288 makes that prefix mandatory: its writer has no option to drop it and its reader rejects frames without it. So every cbor-frame frame starts with `0xd8`, and the first-byte check is simply "ASCII digit means netstring, `0xd8` means cbor-frame, anything else is an error naming the stream." Design open question 4 doesn't apply while the prefix is mandatory.

**Tests**
- **New `framing.test.js` (16 pass):** the classifier over all 256 first bytes, byte-exact fixtures (`5:hello,` and `d8 18 45 68 65 6c 6c 6f`), chunk splitting, bad and empty streams, and the gated writer. It also runs a CapTP matrix of each framing against both the sniffing and a fixed-framing server.
- **Real daemon:** a new `endo.test.js` test serves a netstring client and a cbor-frame client on one daemon; it passes, along with `lifecycle`, the `persist*` tests and the `connection-*` tests.
- **Rust:** `cargo test --lib socket::` (6 new tests) passes, using the same fixture bytes as the JS tests. Clippy reports nothing for `socket.rs` and `rustfmt --check` is clean.
- **Lint and types:** eslint shows no errors and the daemon's tsc shows none in the changed files.
- **Failure:** the four `channel-relay` tests fail locally with `endo.sock` ENOENT. That is the known limit on Unix socket path length (about 104 characters), which this deep worktree path exceeds; it isn't caused by this change. I did not run the full daemon suite.

**Process notes**
- Building the Rust crate locally needed `git submodule update --init --depth 1 c/moddable` and empty stand-ins for four generated `xsnap/src/*.js` files. I removed the stand-ins and committed nothing from that setup.
- The PR-body gate couldn't read the design because it exists only on #711's branch. I copied #711's design file into the worktree uncommitted, ran the gate (it returned clear, as no ordered-sequence design), opened the PR, then deleted the copy.

**Follow-ups**
- **Slot-machine half:** `makeFramedSlots` (the slot-machine half of the design's 2×2 test matrix) has to wait for #124, which isn't on this lineage.
- **Phase 2:** switch the worker pipes, the Go-supervisor per-worker sessions and the Rust supervisor's envelope hop to cbor-frame together, and update `docs/daemon-binary-spec.md`.
- **Phase 3:** add the `ENDO_CBOR_FRAME` client flag, then flip the default.
- **Phase 4:** add `networks/tcp-cbor-frame.js` and advertise both addresses; the protocol name spelling is design open question 1.
- **Phase 5:** retire the netstring paths.
- **Base update:** if #288 moves, this PR needs a weave onto a fresh copy of its branch.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/build-daemon-cbor-frame-migration.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 112 tokens (6264723 cached reads)
- Output: 44113 tokens
- Cost: $3.2854686000000006
- Wall-clock: 736s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
