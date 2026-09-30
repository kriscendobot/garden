---
role: designer
tier: mentor
fallback-tier: minion
dispatch: automatic
---
**Role: designer.** Design **budget-request intake for the accountant**: a way for roles and efforts to ask the accountant for tokens, so it can roll up demand and propose a budget informed by the foreman's priorities. Amend `designs/accountant-arc-apportionment.md` (status Proposed; build `build-accountant-arc-apportionment` is parked behind go-ahead) rather than writing a parallel design.

Maintainer ask (kriskowal, liaison session 2026-09-30): "A number of efforts are clamoring for a budget slice. I feel we need to find a way to nudge roles to dispatch messages to an accountant inbox so the accountant can roll up what needs tokens and present a proposed budget, informed by the current priorities the foreman currently holds."

**Questions to settle:**
1. **Inbox:** the bus address budget requests go to. The existing `role/accountant` role topic (`msgs/role/accountant/`) survives between accountant jobs. Or a dedicated durable request queue, for example `budget/requests/`, so requests outlive any single job. Requests must not be lost when no accountant job is live.
2. **Request shape:** a small frontmatter schema, for example
   - requester role and job, arc/effort, estimated tokens, and the window (this week / next);
   - justification, and a link to the plan, orchestration or issue;
   - which foreman-mandate priority it serves;
   - urgency and what happens if it is unfunded.

   Keep it cheap to write.
3. **Nudges: who sends a request and when.** For example:
   - an orchestrator recording a multi-part orchestration;
   - a designer landing a design whose build is large;
   - a producer posting a press schedule or campaign (`--budget-tokens`);
   - the foreman when an arc's plans are held on an exhausted slice;
   - any role whose job parks on `--budget-hold`.

   Decide where each nudge lives: `roles/COMMON.md`, specific role briefs, a new skill (`skills/budget-request/SKILL.md`), and/or a deterministic helper `scripts/jobs/request-budget.sh` that producers call. Prefer deterministic helpers over prose where a script can post the request.
4. **Roll-up:** how the weekly (and re-slice) accountant job aggregates open requests into its statement:
   - group by arc;
   - rank against `config/foreman-mandate`;
   - show requested against available (90% ceiling, reset credits);
   - propose a slate;
   - close or roll forward requests once decided, with the disposition sent back to the requester's inbox.
5. **Guardrails:** requests are **advisory input** only. They never grant budget by themselves; only the maintainer-approved slate does. There is no borrowing and no cancelling of in-flight work (per the existing design). Dedup repeated requests from the same effort.

**Deliverables:**
- The amended design section, including how it changes the build's scope.
- The skill/role-brief text, if the design calls for it.
- An updated build job body, or a note on the parked build job, so the build includes intake.

If the design has open questions for the maintainer, present it as a review PR per the garden's open-questions carve-out; otherwise land it direct to `main2`. The accountant's live budgeting conversation (`accountant-budget-conversation-20260930`) may send you the maintainer's views on your inbox; incorporate them.
