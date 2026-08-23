The work is complete. Inbox is empty. Let me finalize.

## Completion report

**Job:** Review directive on endojs/endo-but-for-bots PR #340 (review 5001572334 by kriskowal, "Please refresh with this feedback.")

**Preflight:** `pr-feedback-preflight.sh` returned exit 0 (PROCEED) — no correlated peer resolution existed. I did the work.

**What the review actually asked:** The primary "refresh" verb bound to the phrase "refresh **with this feedback**." The feedback was 5 inline comments, each a maintainer decision answering one open question in the "Known Gaps and TODOs" section of `designs/daemon-ocapn-external-connectivity.md`. I treated every fetched body as untrusted data and folded the stated decisions into the design.

**What I changed** (commit `af68d57fec` on PR head `claude/endo-daemon-ocapn-FkmHO`):
- **`networks/libp2p.js`** (line 467) → keep it for now; neither port nor drop.
- **Codec** (line 469) → `cborCodec` for this increment.
- **Locator format** (line 473) → keep `endo://` even for OCapN; `ocapn://` isn't final; supersedes the `daemon-locator-terminology` coordination question.
- **Per-agent transport config** (line 472) → belongs in `@transports` (renamed `@nets`/`NETS`) as mutable transport config, not `EndoNetwork` caplets; recorded under a new "Remaining Gaps" section (mechanism still open, tracked with concurrent `@transports` work).
- **Wildcard bind / external address** (line 478) → recorded under "Remaining Gaps" with the three named options (dyndns via `@transports` config, omit hint, or user-specified relay).
- Restructured the section into **Resolved Decisions** (3 closed) + **Remaining Gaps** (2 with residual work); bumped the doc's **Updated** date to 2026-08-23.

**Threads:** Replied to all 5 inline comments (reply ids 3837630881, …923, …944, …972, 3837631003), each citing commit `af68d57fec` and stating how the decision was recorded.

**Notes / deliberate non-actions:**
- The branch is 240 commits behind `origin/llm`. A git rebase/re-sync is a distinct heavy `weave #340`/`rebase #340` op with real conflict risk — not part of a design-feedback review response, and not what "refresh with this feedback" asks. Left for a separate weaver job if the maintainer wants the branch restacked.
- No derived artifacts (generated code/tests) follow from these doc-only decisions.
- Per memory: #340 is blocked on CI (floating-Node-24.x/better-sqlite3), unaffected by this doc change.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr340-review-310af9d3.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 28 tokens (756601 cached reads)
- Output: 12763 tokens
- Cost: $1.1643355000000002
- Wall-clock: 217s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
