PR #1647 passes the viability gate: it hasn't been superseded, and the problem it fixes still exists on the current `llm` branch. The gauntlet can begin. I didn't spend any clean, panel, fix, CI or un-draft budget.

**Deciding question:** Does current `llm` still put the bind address into OCapN TCP hints (so a daemon on `0.0.0.0` hands out addresses nobody can dial), with no landed or newer change that adds an advertise address?

**Answer:** Yes.

**Evidence:**
- **PR state:** open and draft, created today (2026-11-03T22:28Z), head `a8af366bbb`. Its base is pinned to `llm-48d6f3e`, and the compare shows `llm` is 0 commits ahead of that base, so nothing newer has landed on `llm` that could displace it.
- **The problem still exists on `llm`:**
  - In `packages/ocapn-noise/src/transports/tcp.js`, the listener still emits `host: addr.address` (the bind address), and there is no `advertiseHost` option.
  - `packages/daemon/src/networks/ocapn.js` reads only `ocapn-listen-addr`; there is no `ocapn-advertise-addr`.
- **The reason for the PR still holds:**
  - The tracker, kriscendobot/minion.town#227, is open.
  - minion.town's federation script already stores `ocapn-advertise-addr` and refuses to enable until Endo honors it. That makes this PR a live blocker.
- **Nothing competing has landed:**
  - #1072 (one hint per transport, adds `advertised-hosts.js`) overlaps in area. It is an older draft, untouched since 2026-09-29 and never landed: `advertised-hosts.js` doesn't exist on `llm`.
  - #1335 (binding gateways to peer sessions) is a separate blocker that the PR names explicitly, not a replacement.
- **Reviews and comments:** none yet, so nobody has asked for it to be dropped or redirected.

**Follow-up:** #1647 and the stale #1072 both edit `tcp.js` and `daemon/src/networks/ocapn.js`. If #1072 is ever revived, it will need to be reconciled with #1647's `advertiseHost` option.

<!-- gauntlet-stage-result: viability=proceed -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1647-gauntlet-viability.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 10 tokens (241523 cached reads)
- Output: 1924 tokens
- Cost: $0.46592059999999996
- Wall-clock: 28s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
