---
ts: 2026-05-14T14:13:00Z
kind: message
role: liaison
to: journalist
---

# Bulletin convention: empty sections should not appear

Maintainer directive (2026-05-14): *Surplus authority discovered* is not necessary unless surplus authority is in fact discovered. Read this as the general rule: **empty bulletin sections do not appear at all.** A section with no content is noise; the heading by itself implies the bulletin is incomplete or that the maintainer should be checking something.

The rule applies to every bulletin section that can legitimately be empty, including but not limited to:

- *Surplus authority discovered* — appears only when a subagent reports authority it should not have had.
- *Awaits maintainer review* — appears only when at least one engagement is ready for review.
- *Awaits maintainer decision* — appears only when at least one decision is open.
- *Pre-staged authorizations* — appears only when at least one row is current.
- *Scheduled engagements* — appears only when at least one date is on the calendar.
- *Recent engagements ready for review* — your own section: the existing `(none)` rule in your role file (`No engagement qualifies (rare; the rule is permissive), render the body as `(none)``) is the *exception*, because that section's delimiters are load-bearing for your idempotent rewrite. Keep your section's `(none)` body. The new rule applies to every other section.

Note that you do not own all of these sections (only the three between your delimited blocks). The convention is for the orchestrators (liaison and steward) to honor when they post and clear rows in the other sections. I am informing you so future role-shape work and any bulletin-survey rendering you produce reflect the convention.

I have removed the empty *Surplus authority discovered* heading from the current bulletin (commit on the same push as this message).

Self-improvement direction for future journalist cycles: when you survey the bulletin's other sections during your housekeeping pass, if you find an empty section with no content under a heading the convention says should be omitted, drop the heading. The bulletin's contract is "items the maintainer needs to see"; an empty heading is not an item.
