Inbox empty. Work complete.

## Completion report

**Job:** Review directive on endojs/endo-but-for-bots PR #1072 (review `5059889251` by kriskowal).

**Preflight:** `pr-feedback-preflight.sh` returned exit 0 (PROCEED) — no peer had resolved this feedback.

**Asks enumerated:**
- Review body: `[INLINE-REVIEW]` marker only — no separate top-level ask.
- One inline comment (`designs/ocapn-noise-network.md:72`): do **not** use the query string for connection hints; encode them as `@`-delimited path components (`@<transport>+<codec>:<host>:<port>`), reserving the query string for alleged attributes like `type`. Maintainer asked to "look this up."

**Verification of the format:** Confirmed against the canonical reference `designs/daemon-locator-reference.md`, which states hints are `@`-delimited path components of form `<transport-prefix>:<payload>` and explicitly "Connection hints live in the path, not in query parameters" (query string reserved for `type`/`from`/`fromNode`). The directive matches the repo's own authoritative locator spec.

**Change (commit `8e3e7ef62`, pushed to PR head `fix/ocapn-noise-tcp-single-url-hint`):**
- Network Identifier section: rewrote the example block from `ocapn://<designator>.np ?wss+cbor=example.com:443 &...` to the path-suffix form `ocapn://<designator>.np/ @wss+cbor:example.com:443 @...` and updated the surrounding prose.
- Transport Hint Format section: reframed hints as `@`-delimited path components with a `<transport>+<codec>:` prefix rather than query-parameter key/value; updated the table columns and examples accordingly.
- No code change needed — the PR's transport `hints` record is an internal JS object; only the design doc's locator depiction used the query string.

**Loop closed:** Replied to the inline comment (`r3888435791`) naming the commit and the reference-doc corroboration.

**Follow-ups:** None. The PR remains draft (its own status; unrelated to this review).
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1072-review-c8a0f42b.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 30 tokens (867865 cached reads)
- Output: 11128 tokens
- Cost: $1.2130105
- Wall-clock: 162s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
