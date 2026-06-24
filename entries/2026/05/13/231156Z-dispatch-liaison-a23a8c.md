---
ts: 2026-05-13T23:11:56Z
kind: dispatch
role: liaison
project: garden
to: "*"
---

# Dispatch: gardener — terser bulletin (no explanatory prose) + new top section "5 most recent engagements ready for another round of review"

Dispatch root: `dispatches/gardener--journalist-bulletin-shape-and-recent--20260513-231156--a23a8c/`.

The maintainer's directive (forwarded verbatim):

> Please remind the journalist that the bulletin board does not need explanatory prose. It needs to just list what needs attention. While removing the introductory paragraphs, please add a top section with the five most recent engagements that are ready for another round of review.

## Tasks

### A. Reinforce the no-explanatory-prose rule in the journalist's role file

`roles/journalist/AGENT.md` already encodes "procedural matter belongs in the role file, not the bulletin" from an earlier dispatch. The reminder is that the *items themselves* should be terse: a one-line item per row, named-link + status, no longer a paragraph with rationale. Update the operating norms to spell this out as a hard rule:

- **No explanatory prose in the bulletin.** Each row is one line listing what needs attention: name + link + state (e.g. "ready to merge", "awaits decision", "draft review pending"). If a row needs deeper context, the context lives in a journal entry the row cites, not in the row body.
- The maintainer reads a long bulletin top-to-bottom; the explanatory paragraphs the bulletin currently carries (especially in *Awaits maintainer decision*) are noise. Strip them.

The journalist's role file should keep its existing "how this section is maintained" section that names the rendering rules; what changes is the *rendered content* discipline (terser rows; no per-row paragraph).

### B. Add a top section "Recent engagements ready for review"

New bulletin section at the top of `journal/README.md` § Bulletin board, listed above all the other sections (above *Pending kriskowal reviews*). The section is a snapshot of the **five most recent engagements** the garden has produced that are ready for the maintainer to take another look at.

"Engagement" here means: a journal `result` entry from the garden side (`role` is anything except `monitor`; ignore tick-only quiet cycles), or equivalently any work that produced an external artifact (a PR opened, a comment posted, a design landed). "Ready for another round of review" means: the engagement is complete from the bot's side, and the maintainer is the next actor.

Suggested row format (gardener decides the exact rendering):

```
- <one-line summary> — <kind> · <date/time UTC> · [<external artifact URL>] · [<journal entry path>]
```

The list is **capped at five**. Each render replaces the prior set; older entries fall off (they remain queryable via the journal but are not in the bulletin).

The journalist refreshes this section on the same cadence as the other sections (its existing per-dispatch render). Order: newest first. Selection: the most recent five `result` entries from the garden that have an outward-facing artifact link or that the steward / liaison would naturally want a maintainer to look at.

### C. Apply the rule to the existing bulletin sections

Rewrite each section's body to remove explanatory prose, keeping only the items themselves:

- *Awaits maintainer review*: currently `(none)`. No change unless the journalist or another role posts here.
- *Awaits maintainer decision*: currently carries longer prose rows (workflow-failure note, scholar kick-off, timekeeper kick-off, PR-creation-flow rework). Tighten each to one-liner shape; the journal-entry citation captures the detail.
- *Pre-staged authorizations*: the rows here are intentionally longer because they encode constraints. Keep them as-is for THIS section only; document the exception in the journalist role file.
- *Surplus authority discovered*: `(none)`. No change.
- *Scheduled engagements*: tighten the date-keyed rows; one line each with the date as the lead.
- *Pending kriskowal reviews* and *PR backlog*: these are already terse per the journalist's existing rendering; no change unless the journalist's renderer is currently inserting prose.

### D. Inventory and steward subordinate-roles

No new role; this is a journalist-only refinement. CLAUDE.md does not need an update.

## Out of scope

- Do not touch other role files beyond the journalist's.
- Do not re-render the *Pending kriskowal reviews* or *PR backlog* in this dispatch (those are rendered by the journalist on its next dispatch); only the section's body shape (i.e., one-liner rows) gets the new rule.
- Do not write the *Recent engagements ready for review* section's content in this dispatch; document the rule, but the actual first render of the new section is a separate journalist dispatch.
- Per `journal/README.md` § Pre-staged authorizations: the *Pre-staged authorizations* section's rows are intentionally longer; keep them.

## Style and discipline

Em-dash sweep, frontmatter on every edited file (bump `updated:` on `roles/journalist/AGENT.md`), relative paths. Do not invoke `Agent`.

## Report

Commit SHAs on `main` (journalist role file) and `journal` (any bulletin-section edits that strip prose; the new top section's structural delimiter + placeholder body if you choose to seed an empty section header). One-line confirmation that the next journalist render will produce the new top section.
