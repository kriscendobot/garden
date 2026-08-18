CI is green (rc 0). The fix is pushed to the PR head and CI passed.

## Completion report

**Job:** gauntlet FIX round 3 — kriscendobot/minion.town PR #37 (`designs/ocap-mailboxes.md`, the ocap-mailboxes design doc).

**Re-derived state on clean start:** PR head was `f2f5441` (matching the panel-3 verdict's "Head reviewed"), draft, mergeable, prior fix commits through round 2 already landed. Read the latest panel verdict (gauntlet iteration 3, `2026-08-18T05:14:02Z`, disposition **must-fix**).

**Must-fix items applied** (one pass, committed `bd59289`, pushed to `design/ocap-mailboxes`):

- **The convergent core (critic, skeptic, decomplector all flagged it):** § 8's automatic inbound minting of a "receive-side handle" contradicted § 4's coupled-rights claim and § 9's *No unintroduced send* criterion. Reconciled by introducing **two handle kinds** — *send-capable* (the three coupled rights, minted via `admin.mint`) vs. *receive-only* (recognize + corroborate only, auto-minted on inbound, `send` rejects). Replying now requires an explicit `intake.adopt` act, so inbound mail grants no unintroduced send. Updated §§ 3, 4, 8, 9 coherently.
- **Inbound state-growth vector (skeptic #3, decomplector #1):** § 8 now **rate-bounds inbound receive-only minting** (per-mailbox + domain-wide), the inbound complement to § 5's outbound metering.
- **Free-text body detection (skeptic #1):** § 9's *No raw address in the mailbox* scoped to **guaranteed for envelope + headers, best-effort for body**; residual body-leak named as an accepted risk in § 11.
- **Premature "Resolved" (skeptic #2):** § 11 Inter-daemon reach downgraded to *resolved in principle; mechanism open*.
- **Adapter trust tier (critic #2):** § 9 + § 8 now place the shared domain adapter **inside** the trusted daemon/router boundary and the guest-elected personal adapter **outside** it.
- **Audit ambient-access seam (decomplector #2):** § 6's out-of-band path cross-referenced to § 9's trusted-daemon assumption.
- **Mechanical (pedant):** hyphenation consistency (`formula id`, `circuit breaking`).

Comment-only findings (ergonomist/copyeditor/novice) were left as non-blocking to keep the diff surgical.

**Result:** Docs-only change; CI GREEN (`ci-wait-merge` rc 0). Stopped here per stage contract — did not re-run the panel.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr37-gauntlet-fix-3.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 3 on 2 host(s) (2 unmetered)
- Input: 64 tokens (2757681 cached reads)
- Output: 26976 tokens
- Cost: $2.9280254999999995 (2 engagement(s) unpriced)
- Wall-clock: 460s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
