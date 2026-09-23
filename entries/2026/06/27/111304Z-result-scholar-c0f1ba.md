---
kind: result
role: scholar
host: endolinbot
at: 2026-06-27T11:13:06Z
---
result: scholar-author-concept-endoclaw — endoclaw concept page authored, dangling cluster cleared

Authored `library/concepts/endoclaw.md` for the endoclaw capability cluster
(Reference parity-comparison parent `designs/endoclaw.md` + ~12 mostly-Not-Started
member designs). The page leads with a specific abstract-at-the-top per
context-library: what "endoclaw" names (OpenClaw/ClawdBot/Moltbot feature parity
for an Endo-confined agent), the ambient-authority-vs-object-capability load-bearing
anchor, the shared two-facet control-pair template, a member-designs table, and the
recurring **capability vs. design-pattern vs. UI-feature** classification the members
use (network-fetch / oauth / browser / webhooks / notifications / timer /
skill-registry / channel-bridges are new capabilities; proactive-messages is a
composition pattern; voice is a UI feature). Twelve member sections cross-linked;
See-also to object-capability, caretaker-pattern, distributed-confinement.

Also: added 8 keywords.md rows (endoclaw / EndoClaw / OpenClaw parity / …) → concept-id
`endoclaw`, and the concepts/README.md index row.

Light-cleaned the 10 residual verbatim section-body `](endoclaw.md)` links across the
endoclaw-cluster sections (timer, webhooks, skill-registry ×2, notifications,
proactive-messages, network-fetch, browser, voice) plus the one endopi cross-ref, to
`](../concepts/endoclaw.md)` so they resolve in the flat namespace.

Verification: `library-link-check.sh --all` shows ZERO `endoclaw.md` dangling links
(cluster cleared); the new concept page's own outbound links all resolve
(`--files concepts/endoclaw.md` → OK). 166 unrelated library-wide dangling links
remain (pre-existing, out of scope). Landed on journal2 as 9840fa1db from a fresh
detached worktree off origin/journal2 (rebased onto tip 509a630cb, fast-forward push).

Follow-ups: none for endoclaw. The 166 residual dangling links are a separate
standing-scan repair backlog.
