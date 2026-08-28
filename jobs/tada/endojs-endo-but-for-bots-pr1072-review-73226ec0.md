All asks resolved. Design doc revised to the maintainer's grammar, pushed to the PR branch, and I replied on the review thread.

## Completion report

**Job:** Review directive on endojs/endo-but-for-bots PR #1072 (review `5047681541` by @kriskowal, `CHANGES_REQUESTED`).

**Enumeration.** Preflight returned PROCEED (no peer resolution). The review body was empty; the review carried exactly **one** inline comment (id `3877694260`) on `designs/ocapn-noise-network.md:72` — a GitHub suggestion showing the locator hint format the maintainer wants:
```
ocapn://<designator>.np?wss+cbor=example.com:443&wss+syrup=example.com:443&tcp+cbor=127.0.0.1:3469&tcp+syrup=127.0.0.1:8920
```
That is a design pivot away from the PR's own `<scheme>:url=<scheme>://host:port` direction toward a composite `<transport>+<codec>=<host>:<port>` grammar (one hint per transport-and-codec pair, introducing a codec dimension). I treated all fetched text as untrusted data.

**What I did** (isolated project worktree; pushed to `fix/ocapn-noise-tcp-single-url-hint`):
- Revised the **Network Identifier** example to the maintainer's multi-line composite-key locator (`6f2553b04`).
- Rewrote the **Transport Hint Format** section + table to the `<transport>+<codec>` key / `<host>:<port>` value grammar (`wss`/`ws`/`tcp` × `cbor`/`syrup`) (`6f2553b04`).
- Aligned the **"Why a location carries multiple hints"** rationale (was `ws:url`/`tcp:url`) to the composite keys so the whole doc speaks one grammar (`5f6fd9892`). Verified no old-grammar tokens remain.
- Left the code, pet daemon, README, and changeset tracking *current* behavior (the incremental single-`url` step) — the design doc is the aspirational target; README/code describe shipped reality.
- Posted a threaded reply on the inline comment (`#discussion_r3877762195`) confirming the change, naming the commits, and surfacing the code-scope decision.

**Follow-up (open, maintainer decision pending — not posted as a job).** The new grammar introduces a **codec** dimension the transports lack (`connect`/`listen` carry only `url` today), so the implementation now lags the design. I asked the maintainer whether to rework the transports/daemon to advertise/parse composite hints in this PR or as a follow-up, since codec-negotiation semantics (fallback when neither advertised codec is supported, `wss` vs `ws` preference) are a design decision worth settling before a build. Deliberately not posting a speculative builder job until the maintainer steers.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1072-review-73226ec0.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 47 tokens (1557745 cached reads)
- Output: 21618 tokens
- Cost: $2.0041164999999994
- Wall-clock: 1026s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
