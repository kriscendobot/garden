---
ts: 2026-05-20T05:24:25Z
kind: result
role: designer
worktree: dispatches/designer--0e60db/project
repo: endojs/endo-but-for-bots
project: endo-but-for-bots
refs:
  - PR endojs/endo-but-for-bots#252
---

Settled four open design questions on PR #252 (ocapn-noise-session-reconnect) raised by kriskowal's CHANGES_REQUESTED review at 2026-05-20T05:10:31Z (review id `PRR_kwDORRE4FM8AAAABAc9SAg`).

Decisions:

- **P3** (comment 3271341164, "Designator."): tiebreaker is designator comparison on per-session ephemeral x25519. Transcript-hash rejected.
- **C1** (comment 3271344916, "Tentatively run with resume and rekey-cap..."): Resume on common reconnect path; Rekey on a standard (non-negotiated) cap. Provisional figures: `REKEY_CAP_MESSAGES = 2^32`, `REKEY_CAP_BYTES = 2^36`, `REKEY_CAP_WALLCLOCK = 1 hour`, whichever first. Either side initiates Rekey on local cap trip; peer always honors. Cap is normative across implementations (no per-session negotiation); widening or narrowing on one side either wastes a peer-initiated rekey or fails to rotate, neither of which is wanted.
- **T1** (comment 3271345791, "Choose a tentative figure..."): 5 s heartbeat / 30 s session timeout settled as standard normative values. Range column repositioned as per-network tunable bound, not a profile-range recommendation to OCapN spec group.
- **T2** (comment 3271346247, "Fixed."): heartbeat fixed cadence. Adaptive considered and rejected.

Designator-flag investigation: the comment anchors line 708 ("Amendment leans toward designator"); the maintainer was affirming the leaning rather than flagging a missing definition. Settled by promoting the Open question P3 paragraph to a Resolution-of-P3 block at § 3.

Rekey-cap rationale: 2^32 messages is two orders of magnitude below the conservative ChaCha20-Poly1305 records-per-key bound (RFC 9001 § 6.6) and 32 bits below the 2^64 Noise nonce ceiling. 2^36 bytes (64 GiB) is conservative for ChaCha20-Poly1305 but cheap to rotate. 1 hour wallclock bounds compromise-window on low-throughput sessions. The three thresholds bind at very different timescales so the cap is robust across realistic CapTP workloads.

Commits on `design/ocapn-noise-session-reconnect`:

- `9c29f4b54` design(ocapn-noise-session-reconnect): settle P3, C1, T1, T2 with concrete figures (per #252).
- `c8f43c581` design(ocapn-noise-session-reconnect): split settlement prose to sentence-per-line (per #252).

Pushed: `b497f6903..c8f43c581 design/ocapn-noise-session-reconnect`.

Pre-push gates: three pre-existing sentence-per-line findings in the file (lines 61, 92, 119) predate this engagement; left alone to keep the diff scoped. The new prose was rewrapped to sentence-per-line in the second commit so the diff itself adds no new findings.

Inline replies posted (per `skills/pr-review-thread-replies/SKILL.md`):

- 3271341164 (P3): reply id 3271391289.
- 3271344916 (C1): reply id 3271392160.
- 3271345791 (T1): reply id 3271392760.
- 3271346247 (T2): reply id 3271393339.

Top-level summary comment: id 4494783819 (https://github.com/endojs/endo-but-for-bots/pull/252#issuecomment-4494783819).

Self-improvement: the dispatch brief mapped comments 3271345791 and 3271346247 to the rekey-cap decision, but their actual line anchors (713 and 715) put them on T1 and T2 respectively. The designer-role norm "verify the brief's line-to-section mapping against actual comment line numbers" caught the discrepancy and the answer-section assignment followed the line, not the brief. The brief's framing that "the asks orbit a single decision" was partially right (rekey-cap is the load-bearing one) but the T1 and T2 settlements were independent decisions that needed independent treatment in the document; calling them out as separate decisions in the top-level summary is what made the response complete. Nothing to send to liaison; the norm already covers this case.
