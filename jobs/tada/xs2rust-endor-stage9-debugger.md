No inbox messages. Slice 1 is complete, verified, and pushed. Writing the completion report.

Completed **slice 1 of 3** of the Debugger row (design row 7 / requirement 1b) on PR #600 branch `xs2rust-endor` — the protocol/transport/parse/serialize core. PR left DRAFT; no comment posted.

## What I did

Landed a new `endor-debug` crate (`rust/engine/endor-debug`), the **7th `#![forbid(unsafe_code)]` engine root** (joining endor-262, endor-compile, endor-fuzz, endor-regexp, endor-snapshot, endor-vm; endor-oracle stays the audited FFI seam). Three pieces, each transliterated from and annotated against `c/moddable/xs/sources/xsDebug.c`:

- **`transport.rs` — `DebugTransport` trait**: XS's five C platform hooks (`fxConnect`/`fxDisconnect`/`fxIsConnected`/`fxReceive`/`fxSend`) plus the derived `fxIsReadable`, collapsed into one Rust seam (design § Debugger). `BufferTransport` is the in-memory reference impl — the shape the daemon's envelope-bus buffers take (daemon-xs-worker-debugger.md layers 1–2), keeping "always compiled, dormant by default" a runtime flag.
- **`command.rs` — `CommandParser`**: a faithful port of `fxDebugParse` + `fxDebugParseTag` + `fxDebugPushTag`/`fxDebugPopTag`. The byte state machine decodes client→VM xsbug XML into typed `Command` values over the full vocabulary (go/step/step-inside/step-outside/abort/logout, set/clear/clear-all/set-all breakpoints, select/toggle, eval, profiling), reproduces the `debugExit` resume/stay classification, and streams across arbitrary `fxReceive` chunk boundaries.
- **`echo.rs` — `Echo`**: the VM→client serializer — `<xsbug>` CRLF framing (`fxEchoStart`/`fxEchoStop`), byte-exact `fxEchoString` numeric-entity escaping (controls, `"` `&` `<` `>`, DEL escaped; everything else incl. high bytes verbatim), the `fxEchoPathLine` guard, `fxEchoAddress` hex handles, and typed `<login>`/`<break>`/`<log>` builders.

## Verification (numbers + exit codes)

- `cargo test -p endor-debug` → **EXIT=0**; three test binaries all `test result: ok. … 0 failed` — **28 tests** (25 unit + 3 integration round-trip).
- `cargo build -p endor-debug` → **zero warnings**.
- `forbid(unsafe_code)` intact at **all 7 roots** (verified by grep).
- Working tree is **purely additive**: `Cargo.toml` (+1 member), `Cargo.lock` (+endor-debug, no deps), new `endor-debug/` tree — **no existing crate touched**, so the oracle, curated compile-diff+SYMB, and boot gate are **structurally unchanged** (correctly not re-run: no VM/oracle/C source changed, and no debugger code yet touches metered paths).
- `c/moddable` set up as detached read-only reference (pin `23b4d6b0`, clean), never staged.
- Push verified by exit code and ref match: `0c7b35bdd25..cf45517211e HEAD -> xs2rust-endor`; local == remote == `cf45517211e`.

## Remainder for re-dispatch (slices 2 & 3)

- **Slice 2 — VM-side inspection hooks behind the trait** (adds the `endor-vm` dep): break/step/step-in/step-out driving the interp; `<frames>`/`<local>`/`<global>` sourced from live endor-vm frame+slot arenas; the breakpoint table; break-on-uncaught via the `firstJump`-equivalent JS/host-flag walk; **metering-neutral when disarmed** (single dormant branch).
- **Slice 3 — bus integration + acceptance**: wire the transport over the daemon `"debug"`/`"debug-attach"`/`"debug-detach"` envelope seam, then turn on the existing **11 Rust debug-protocol tests + 16 CapTP debugger tests** against endor and confirm xsbug connects end-to-end.
- The **full-row acceptance bar** (fresh clean of endor-compile/endor-vm/endor-oracle, workspace all-green incl. oracle, curated compile-diff + SYMB, boot gate 14-green-equivalent, dual-run computron neutrality) applies once slice 2's VM-side hooks land — that is the first point at which debugger code reaches metered paths.
