# Reinforce: issue/PR-scoped agents communicate via comments only; restrict the maintainer inbox to free-standing roles

Map: **build** (garden meta/library) on branch main2. Isolated worktree off origin/main2;
explicit-pathspec commits; push HEAD:main2 via git-rebase CAS. This is a role/skill/COMMON
edit (meta-evolution — gardener/mentor scope).

Maintainer directive (kriskowal 2026-06-28), to encode for ALL agents:
1. **If you are working on an issue or a pull request, ALL communication with the maintainer
   goes through COMMENTS on that issue/PR — ideally INLINE on the relevant lines of code or
   design documentation — NEVER the garden's maintainer inbox.**
2. **Only roles that may be engaged WITHOUT an issue/PR reference may have maintainer-inbox
   instructions. Every other role must NOT even be presented information suggesting the
   maintainer inbox exists at all** (information-hiding, not just "don't use it").

## What to change
### A. roles/COMMON.md — the standing rule, phrased to NOT reveal the inbox
Add a "Communicating with the maintainer" rule that every subagent reads: when your work is
scoped to an issue or pull request, reply to the maintainer ONLY by commenting on that
issue/PR — prefer an INLINE review comment on the specific code line or an inline comment on
the relevant design-documentation line; add a top-level SUMMARY comment per the existing
summary-comment norm (reconcile with feedback_pr_work_needs_summary_comment /
pr-completion-summary-comment / pr-review-thread-replies). State the inline-preferred rule
WITHOUT mentioning or hinting at the maintainer inbox — COMMON is read by issue/PR-scoped
roles too, so it must not introduce the channel it forbids them.

### B. Audit + classify EVERY role (roles/*/AGENT.md and roles/jurors/*/AGENT.md)
Read each role and classify:
- **Issue/PR-scoped (comment-only):** roles that always operate on a PR/issue — builder,
  fixer, weaver, shepherd, conductor, cleaner, designer, solicitor, barrister, justice,
  appellate, the jurors, boatman, assayer, evaluator, groom, investigator, scout, and any
  other that works against a PR/issue reference. For these: SCRUB every reference to the
  maintainer inbox (`inbox/maintainer/`, `message-user.sh`, "report to the maintainer
  inbox", "the maintainer's inbox") — they must not appear in the role file OR in any skill
  the role is told to load. These roles communicate via inline PR/design-doc comments + a
  summary comment.
- **Free-standing (may reference the maintainer inbox):** roles that may be engaged WITHOUT
  an issue/PR reference — at least liaison, proxy, foreman; audit the rest (scholar,
  journalist, librarian, timekeeper, monitor/review-queue, etc.) and decide per the test
  "can this role be engaged with no issue/PR reference?" Only these role files mention the
  maintainer inbox. (Verify each inbox use is intentional.)
The classification is the deliverable — produce the actual two lists from reading the files;
the names above are guidance, not gospel.

### C. Distinguish the maintainer inbox from the inter-agent message bus
The RESTRICTED channel is the MAINTAINER inbox (`inbox/maintainer/`, `message-user.sh`). The
inter-agent message bus (role inboxes, `send-msg.sh`/inbox-drain for agent-to-agent routing)
is SEPARATE and unaffected — do not scrub legitimate inter-agent messaging. Be precise so the
audit removes only maintainer-inbox references from issue/PR-scoped roles.

### D. Skills audit
Skills that document the maintainer inbox (message-user / "report to the maintainer") are
referenced ONLY by free-standing roles. The PR/issue comment skills (pr-review-thread-replies,
pr-completion-summary-comment) stay with issue/PR roles and are emphasized as the channel —
inline on the relevant lines, then a summary. Confirm the issue-inbox skill (skills/issue-inbox)
already routes to the ISSUE thread, not the maintainer inbox (it does — keep it).

## Verification (a rule-elision-style check)
Add a check (extend the existing checks/grep-gate harness) that asserts NO issue/PR-scoped role
file — nor a skill such a role loads — contains a maintainer-inbox token (`inbox/maintainer`,
`message-user`), and that the set of files mentioning it equals the audited free-standing set.
This makes the information-hiding property machine-enforced going forward.

## Deliverable
COMMON's inline-comment directive (inbox-free), a per-role classification, the scrub of
maintainer-inbox references from every issue/PR-scoped role + its skills, the free-standing
allowlist as the sole inbox-referencing set, and the grep-gate check that keeps it that way.

---
claim:
  host: endolinbot
  gardener: 56
  claimed_at: 2026-06-28T06:04:54Z
