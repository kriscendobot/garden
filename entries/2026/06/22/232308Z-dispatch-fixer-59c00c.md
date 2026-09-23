---
kind: dispatch
role: fixer
host: endolinbot
posture: liaison
short_id: 59c00c
dispatch_root: dispatches/fixer--59c00c
repo: endojs/endo-but-for-bots
branch: feat/inventory-grouping-by-type
pr_number: 405
model: sonnet
---

RSVP kriskowal's comment on PR #405 (id 4765703096,
2026-06-22T06:59:24Z):

> Let's only show a group if the group is not empty.
>
> Add a test where the user creates a directory. The directory should
> show up in a group for directories. Add similar tests for each
> category of entity.
>
> I am noticing that manual creation of a directory with `/mkdir`
> appears to create a usable petname for the directory but that the
> inventory view does not reflect the existence of the new value.
> There is likely a bug in the reactive visual update loop, projected
> through the grouping.
>
> Also, please take a moment to wear your librarian and scholar hat
> and read up the relevant projections for collection transformations
> at github.com/kriskowal/frb.
>
> Please also rebase. There was a migration to Preact that merged
> concurrently.

Compound:
1. Rebase onto current `origin/llm` (tip `65b0abe27`). New frozen-
   base branch needed.
2. Read FRB collection-transformation projections at
   github.com/kriskowal/frb to inform the reactive-update fix.
3. Only show a group if non-empty (UI behavior).
4. Add per-category tests (directory, etc.) verifying that creation
   surfaces the new entity in the right group.
5. Fix the `/mkdir`-doesn't-update-inventory bug in the reactive
   visual update loop projected through grouping.
