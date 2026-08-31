All four review asks are resolved, verified, pushed, and the review threads answered. The PR remains a draft. Job complete.

---

## Completion report

**Job:** Address kriskowal's CHANGES_REQUESTED review on endojs/endo-but-for-bots PR #1072 (reverse the "single hint per transport" direction → priority-ordered list of hints).

**Delivered** (commit `d41e3846e` on `fix/ocapn-noise-tcp-single-url-hint`, pushed; PR still DRAFT):

- **Ask 1 — scheme rename.** The doc's sole `ocapn://<designator>.np/…` locator example is now `endo://…`, with a note that `endo:` is deliberate so as not to front-run consensus on a registered `ocapn:` scheme (protocol family still OCapN, network still `np`).
- **Ask 2 — wss path.** The `wss`/`ws` hint form now carries a path `wss+cbor:<host>:<port><path>`, canonical `/ocapn-cbor-np` (the gateway's OCapN-CBOR-on-`np` endpoint per `gateway-package.md` § Feature 8, matching minion.town). Updated the example, the Transport Hint Format prose+table, and the `ws-node` transport (dial URLs default to that path, `path` override).
- **Ask 3 — omit-localhost / ipv6-first / pluggable discovery.** Removed the wildcard→`127.0.0.1` substitution. Wildcard binds enumerate routable interface addresses (IPv6-first) and omit the hint rather than advertise loopback; specific binds advertise the chosen host. Added a pluggable seam (`hosts` override + `discoverHosts` callback, no STUN shipped), factored into a shared `advertised-hosts.js` so tcp/ws stay symmetric; IPv6 literals stay bracketed.
- **Ask 4 — priority-ordered list.** `TransportListener.hints` is now an ordered array of self-describing dial URLs; `connect(hint)` takes one URL; `aggregatedHints`/`buildLocationFor` build the list and `selectOutgoingCandidates` walks it in priority order, trying each until one connects. Carried through `types.d.ts`, `ws-node`, `mock`, and the daemon consumer.

**Files:** `advertised-hosts.js` (new), `network.js`, `types.d.ts`, `tcp.js`, `ws-node.js`, `mock.js`, `daemon/src/networks/ocapn.js`, `designs/ocapn-noise-network.md`, changeset renamed/rewritten (`ocapn-noise-priority-hint-list.md`), and 8 test files (updated shapes + new coverage for omit-loopback, ipv6-first, discovery fold, positional-locator, skip-unmatched-hint).

**Deliberate wire-format judgment call (surfaced in-thread, in the changeset, and via message-user):** I kept the OCapN `OcapnLocation.hints` *component* a spec `Record<string,string>` rather than a raw array — it is Syrup-**signed** via `@endo/ocapn`'s dictionary-of-strings locator codec and shared with the `tcp-testing-only`/`websocket` netlayers and the Python interop suite, so a true-array codec change is OCapN-wide and beyond this PR. The ordered list is carried across it as a **positional dictionary** (index keys → dial URLs), and is a genuine ordered list at every layer the review commented on. Can be promoted to a first-class list codec later if the OCapN locator serialization itself is evolved.

**Verification:** `tsc` clean, `eslint` 0 errors (pre-existing warnings only), `@endo/ocapn-noise` 63/63 tests pass, `@endo/daemon` networks-ocapn 9/9 pass.

**Follow-ups:** none blocking. Optional future work already sketched in the doc: first-class list locator codec, relay hints + speculative race-to-connect. Awaiting maintainer's re-review; PR intentionally left draft.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endo-1072-address-review-multihint.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 176 tokens (17662319 cached reads)
- Output: 61857 tokens
- Cost: $12.725184500000003
- Wall-clock: 948s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
