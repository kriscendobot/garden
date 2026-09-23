Worktree removed, no reply yet. I've surfaced the scope question and the durable record is in the message thread. Finalizing.

---

## Completion report — `endo-hex-tiered-codec-port`

**Outcome: job premise is already satisfied; no code written. Surfaced to the maintainer with a re-scope recommendation.**

### What I found
The job asked to *create a new `@endo/hex` package* in endo-but-for-bots. **It already exists.** `packages/hex` is published upstream as `@endo/hex@1.1.1` (authored at commit `ad7a177e8 "feat(hex): Add hex transcoder"`) and is mirrored on `endo-but-for-bots/master`. It is already:

- **Tiered** — Tier 1 prefers the native TC39 `Uint8Array.fromHex`/`prototype.toHex` intrinsic (captured pre-lockdown, dispatched via `Reflect.apply` so a tampered `Function.prototype.call` can't redirect it); the "floor" is a pure-JS polyfill.
- **XS-safe by the job's own criterion** — the polyfill uses **bounded `for` loops with char-code arithmetic**: no `flatMap`, no large-array spread, and *no module-scope decode `Map` at all*. It cannot hit the v320 metered-value-stack overflow #7 exists to fix.
- **Pin-complete** — `test/main.test.js` already covers every #7 correctness pin and more: full 0..255 round-trip, lowercase-emit, upper/lower/mixed-case accept, empty input, odd-length rejection, invalid-char rejection (incl. `@`/backtick `0x20`-fold guards — no silent truncation), cross-tier agreement, byte-offset diagnostics, and native-path diagnostic preservation.

### What I verified
Ran a standalone witness of the polyfill cores (harden stripped): full byte-space round-trip, mixed-case decode, odd/non-hex/`@`/backtick rejection, and a **1 MiB encode→decode round-trip** — all pass. Confirms correctness and practical XS-safety without needing the full SES build.

### Deltas vs the literal job text (deliberate upstream choices)
1. **No `Buffer` tier (tier 2).** Upstream goes native → pure-JS only.
2. **Floor is char-code arithmetic, not the "map [char-pair] table"** #7 favored on XS. Upstream's bench note claims char-code is ~2.5–3× faster than the table on V8 and that XS is slow regardless until Moddable ships native `fromHex`.

Adding a Buffer tier or swapping to a map-table **in the bot fork** would diverge the mirror from a published upstream package — counter to the mirror's purpose and the hard scope line's intent. So **I made no change to endo-but-for-bots** (throwaway worktree torn down, no commits, no push).

### Recommendation (sent to maintainer via the liaison)
Close this job as already-satisfied. The genuinely remaining work is the **explicitly-separate agoric-sdk #7 slim-down**: make `packages/internal` depend on `@endo/hex` and drop the in-tree `hex.js` body. `@endo/hex`'s `encodeHex`/`decodeHex` are a drop-in — one caveat: #7 throws the literal `Invalid hex string: ${hex}`, while `@endo/hex` throws a hex/odd-length message carrying offset + name (equivalent semantics, different text), so #7 tests asserting the exact string need a tweak. A Buffer perf-tier or map-table floor, if still wanted, is an **upstream `@endo/hex`** design change for endojs/endo proper — not the bot fork.

### Follow-ups
- Awaiting maintainer decision: **(a)** close as already-satisfied, or **(b)** re-scope this to the agoric-sdk #7 slim-down against the existing `@endo/hex`. Message is in the maintainer inbox (`20260630T233833Z-01a1d0`); any reply routes back to this job's inbox.
- No garden-infra or main2 change was required.
