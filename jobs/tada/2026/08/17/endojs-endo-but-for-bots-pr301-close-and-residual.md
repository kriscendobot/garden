Both parts complete. No garden-repo commit is needed (Part 2 concluded no PR should be opened).

## Completion report

**PART 1 — closed #301 as superseded.** Posted a closing comment ([#issuecomment-5312190646](https://github.com/endojs/endo-but-for-bots/pull/301#issuecomment-5312190646)) naming `bbc997dee` as the superseding parallel implementation, confirming every headline capability now lives on `llm` with file-and-symbol citations (trace aggregator `packages/daemon/src/trace-aggregator.js`; `endo trace` verb `packages/cli/src/endo.js` + `commands/trace.js`; marshal save/load hooks + CapTP forwarding `packages/captp/src/captp.js` + `manager.js` `makeOutboundMarshalSaveError`; CTP_DISCONNECT reconstitution `captp.js` + `disconnect-error-display.test.js`; chat surfacing `chat/connection.js` + `spaces-util/error-trace.js`), and linking the Part 2 conclusion. PR is now **CLOSED**. Did not reopen or rebase.

**PART 2 — residual analysis (read the actual `llm` sources, not just filenames).** None of the four candidates is genuinely net-new; no PR opened:

1. **`error-id.js` dedup helper** — *already present*, absorbed as `packages/spaces-util/src/error-trace.js` (`noteDecodedErrorId` + `extractErrorId`: same marshalLoadError WeakMap side-table + SES-tag fallback) plus the daemon's `extractInboundErrorId`/`inboundErrorOrigin` WeakMap in `packages/daemon/src/manager.js`.
2. **`trace-constants.js`** — *obsolete under new structure*. `@daemon` sentinel exists inline (`manager.js`, stub record `workerId: '@daemon'`, `site: 'daemon'`); `@network:` has no equivalent because network scope is a declared non-goal.
3. **Network-side `network-marshal-save-error.js` hook** (the one flagged most likely real) — confirmed **absent** on `llm` (peer transports `networks/tcp-netstring.js`, `ws-relay.js`, `iroh.js` build CapTP with no `marshalSaveError`), **but this is a deliberate documented non-goal**, not an oversight: `docs/error-tracing-design.md` § Non-goals — *"Distributed tracing across remote peers … this design stops at the boundary of a single daemon and the workers it spawns"* — with OCapN peer error-correlation tracked separately. Grafting it would contradict the landed design boundary. → do not graft.
4. **Chat-client trace surfacing** — *already present*; `spaces-util/src/error-trace.js` `resolveErrorTrace`/`watchErrorTrace` consumed by `spaces-util/src/eval-form.js` and `command-executor.js`.

**Follow-ups:** none. Peer-to-peer error tracing remains a separately-tracked OCapN concern per the design doc; if the maintainer ever wants it, it's a design proposal against that boundary, not a residual graft from #301.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr301-close-and-residual.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 53 tokens (1877562 cached reads)
- Output: 21095 tokens
- Cost: $2.2554450000000004
- Wall-clock: 325s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
