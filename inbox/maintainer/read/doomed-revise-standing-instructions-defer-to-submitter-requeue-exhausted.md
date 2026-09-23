from_host: endolin-garden-ece02cb4
from: reaper:endolin-garden-ece02cb4
sent_at: 2026-08-19T02:03:23Z
doom_base: revise-standing-instructions-defer-to-submitter
doom_signature: requeue-exhausted
notice_count: 1
first_seen: 2026-08-19T02:03:23Z
last_seen: 2026-08-19T02:03:23Z
---
DOOM job PARKED in jobs/plan/ (held, gate=go-ahead) after 5 requeue cycles on endolin-garden-ece02cb4.
Its handler appears to fail every time; the reaper stopped requeueing it.
The work is preserved at jobs/plan/revise-standing-instructions-defer-to-submitter; it stays HELD until a human promotes it
(promote-plan.sh revise-standing-instructions-defer-to-submitter) or removes it, so nothing is lost.
Original job base: revise-standing-instructions-defer-to-submitter

--- original job body ---
---
role: gardener
tier: minion
model-burned: mentor
fallback-tier: 
dispatch: automatic
---
# Standing instructions: generalize "never close, defer to the submitter" fleet-wide, and extend it to PR review conversations

Repository: this repo (garden). Garden-infra work — edit and push directly to
`main2`, no PR (CLAUDE.md § Conventions).

## The two rules to land

1. **No agent ever closes a GitHub issue.** The issuer (the person who filed
   it) closes it when satisfied. This rule **already exists**, but only
   narrowly, in `skills/issue-inbox/SKILL.md` (its § on the consumer loop,
   "3. **Never close the issue.** You **defer to the submitter** to close it
   when they..."). That skill is specific to the garden's own
   issue-driven-workflow consumer loop — a role handling an issue on
   `endojs/endo-but-for-bots` or any other repo would never read it and has
   no reason to know this rule applies to them too. **Generalize it** into
   `roles/COMMON.md` § External-repo etiquette, which every role reads and
   is already the canonical home for the closely-related existing line
   "Issue or PR opens, edits, or closes" (currently listed as an action
   needing a maintainer-originated per-action authorization). State the
   sharper default explicitly: an issue close is not just
   authorization-gated like an ordinary action, it is **presumptively never
   the bot's to do at all** — the issuer closes it. Have
   `skills/issue-inbox/SKILL.md` **cite** the canonical rule rather than
   restate it (skills are canonical for procedure, but a *standing
   behavioral rule* that binds every role belongs in `COMMON.md`; per
   `skills/self-improvement/SKILL.md`'s own routing guidance, this is
   exactly a "behavioral… your role file" vs "structural, cross-cutting"
   distinction — this rule is cross-cutting enough that `COMMON.md`, not a
   single skill, should be its source of truth).

2. **No agent ever resolves a conversation thread on a pull request
   review.** Resolving a review thread (GitHub's "Resolve conversation"
   button / the `resolveReviewThread` mutation) is the submitter of that
   conversation's call — the reviewer who opened the thread, not the agent
   replying to it. This is a **new** rule; nothing in the current standing
   instructions covers it (confirmed: no code path anywhere in
   `scripts/jobs/` calls a thread-resolve mutation today, and
   `skills/pr-review-thread-replies/SKILL.md` only says to **reply** on each
   inline thread after addressing it — it says nothing about resolving, so
   there's no existing behavior to walk back, only a gap to close before it
   becomes a habit). Add it to `roles/COMMON.md` § External-repo etiquette
   alongside rule 1, and add a one-line note to
   `skills/pr-review-thread-replies/SKILL.md` making the reply-not-resolve
   split explicit (reply substantively, cite the addressing commit SHA, but
   leave the thread open for the reviewer to resolve).

## The override

**In both cases, a maintainer may override.** This is not a new mechanism —
it's the same shape `roles/COMMON.md` § External-repo etiquette already uses
for issue/PR closes generally ("Exception: the job that dispatched you
explicitly authorizes the action. Such authorizations originate with the
maintainer...") and the same shape the erights maintainer-authority passage
in the same section already documents for PR-level lifecycle actions
("closing a pull request, withdraw-and-open-fresh... the directive **is**
the authorization"). Write the override for these two rules to read
consistently with that existing language — a maintainer's explicit
per-action directive (closing this issue, resolving this specific thread) is
the authorization, carried the same way (through the liaison after user
confirmation, or a journal `message`/inbox entry at claim time); no
autonomous role originates that authorization for itself.

## Where exactly to land this

- `roles/COMMON.md` § External-repo etiquette: extend the existing
  "Issue or PR opens, edits, or closes" bullet (or add adjacent bullets) to
  state the issue-close default explicitly, and add the new
  review-thread-resolve rule. Keep the existing per-role authorization table
  and the erights maintainer-authority passage intact — this is an addition
  and a generalization, not a rewrite of what's already there.
- `skills/issue-inbox/SKILL.md`: replace its standalone "Never close the
  issue" prose with a citation to the now-canonical `COMMON.md` rule (a
  relative link), per the standing "skills are canonical; roles/skills cite,
  they don't duplicate" convention. Preserve the surrounding procedural
  detail about the submitter-close being the terminal signal for
  dispatching — that's issue-inbox-specific procedure and stays.
- `skills/pr-review-thread-replies/SKILL.md`: add the one-line
  reply-not-resolve note, citing `COMMON.md` for the rule and reasoning
  rather than restating it.

## Acceptance

- Grep the result for any place that now states the same rule twice in
  different words — consolidate to the single `COMMON.md` source with
  citations, not copies.
- Report which files changed and quote the final wording of both rules in
  the completion report.
