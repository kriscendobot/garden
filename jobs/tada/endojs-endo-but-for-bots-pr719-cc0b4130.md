Done. The directive had a single ask — link the ferried upstream PR — which I've resolved durably.

## Completion report

**Directive** (endojs/endo-but-for-bots#719, comment 5337803942, kriskowal): "Please link the ferried upstream PR."

**Preflight:** `pr-feedback-preflight.sh` returned exit 2 (HINT). I corroborated: the only correlated artifact was the auto-posted "On it" acknowledgment stub (comment 5337814668) citing the feedback id — not a real resolution. So I treated exit 2 as **PROCEED** and did the work.

**Ferried upstream PR identified:** `endojs/endo#3332` — *feat(ses): permit URL and URLSearchParams as a vetted shim (%URL%/%SharedURL% split)*, OPEN, author kriskowal, head `b43ac9c4`, branch `kriskowal-hardened-url-shim`. Identical title/tree to fork PR #719 (head `43a1a7e6`, base `master-fb9cef4`). The mirror was previously noted only in the timeline (comment 5079090390); the PR body linked only the issue (`endojs/endo#2635`), never the ferried PR.

**What I did:**
- Edited PR #719's description to add `Ferried upstream as endojs/endo#3332.` at the top (durable in the body, GitHub auto-cross-references it). Verified the body now leads with that line.
- Posted a reply comment (issue comment 5337835169) confirming the link with the upstream PR number, state, and head SHA.

**Changed:** PR #719 body + one reply comment on the fork. No garden-repo (main2) changes; nothing to commit/push.

**Follow-ups:** none. Both PRs remain open; the fork↔upstream association is now recorded in the body.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr719-cc0b4130.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 27 tokens (748829 cached reads)
- Output: 5801 tokens
- Cost: $1.0163565
- Wall-clock: 104s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
