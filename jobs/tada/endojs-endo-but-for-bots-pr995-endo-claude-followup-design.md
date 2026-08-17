Done. The PR head matches my pushed commit, and it remains `MERGEABLE` (the `UNSTABLE` status is just pending/non-required checks, not a merge conflict).

## Completion report

**Job:** Address PR #995 inline review (kriskowal, comment 3793884126) on `designs/endo-claude.md` — model an optional threaded/follow-up session.

**Re-derived state:** Clean start (cross-host reaper requeue). No prior attempt had committed the change — `origin/design/endo-claude` was still at `7109ac22e7` (round-6 must-fixes) — and no reply had been posted to the review thread.

**What I did:**
- Extended the **"Fresh process per call; memory is Endo's job"** section of `designs/endo-claude.md` with a new subsection: *"An optional threaded session models follow-up — as an Endo capability, not `--resume`."* It frames the maintainer's idea as an **optional, capability-gated** facet method:
  - The harness stays **stateless per call by default**; each threaded turn is still a fresh `claude -p` with the same fail-closed tools, constructed env, and pooled credential.
  - Continuity is an **Endo-side capability** (an opaque, host-held session handle the guest opts into per thread), **not** harness-owned `--resume`/`--continue` transcript replay.
  - The handle threads only **guest-authored conversational turns**, not prior **tool results** — so a follow-up cannot leak results across the confinement boundary that `--resume` would breach. Continuity of *thought* is preserved; continuity of *authority* is not.
  - Ocap properties (unforgeable, no more powerful than the minting facet, revocable) keep every confinement invariant intact.
- Added a one-line pointer from the existing section to the new subsection.
- No mermaid diagrams touched; no `designs/README.md` estimate/dependency change (pure prose refinement, as anticipated).

**Committed & pushed:** `1e2385743b` on `design/endo-claude` (rebase CAS push, clean).

**Review reply:** Posted a threaded reply to comment `3793884126` (reply id `3793959607`, correctly `in_reply_to`) citing the commit and summarizing the extension. Did not resolve the maintainer's thread.

**PR status:** `#995` OPEN, `MERGEABLE`, head = `1e2385743b`.

**Follow-ups:** None for this design job. Package implementation is intentionally out of scope (a separate builder is orchestrated to follow the merge).
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr995-endo-claude-followup-design.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 3 on 1 host(s) (2 unmetered)
- Input: 23 tokens (527476 cached reads)
- Output: 7383 tokens
- Cost: $0.8202480000000001 (2 engagement(s) unpriced)
- Wall-clock: 138s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
