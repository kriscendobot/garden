# Carry kriskowal's review feedback on endo-but-for-bots PR #405 (inventory grouping — round 2)

Map: **fix** on **endojs/endo-but-for-bots** PR #405 (OPEN; head `feat/inventory-grouping-by-type`)
via the gamut (builder/fixer → judge panel). Bot fork; standing comment authorization. COMMUNICATE
ON THE PR: address inline where it makes sense and post a top-level summary comment on #405 (comms
directive) — do NOT use the maintainer inbox. Push to the existing PR branch.

Continuation of `endo-but-for-bots-pr405-inventory-taxonomy-reshape` (done; the five-group reshape
landed at the 06:24 fixup). kriskowal's follow-up review ("getting closer"):
https://github.com/endojs/endo-but-for-bots/pull/405#issuecomment-4825162435 — five concrete asks:

1. **Per-header count must honor the "special names" filter.** Each header's item count currently
   shows the TOTAL; it must instead match the number of items that will actually appear WHEN THE
   SECTION IS EXPANDED (i.e. the post-special-names-filter count). Make the count and the expanded
   contents agree.
2. **Aggregate Handles into their own top-level category.** Handles currently fall under general
   Capabilities; promote them to a dedicated **Handles** group — they're one of the most important
   categories.
3. **Manually order the headings in this exact order:** **Handles, Directories, Values,
   Capabilities, Agents, Personas.** (A fixed manual order, not alphabetical/derived. Note this
   supersedes the earlier order and adds Handles, so the bucket set is now these six.)
4. **Remove the speech-bubble prefix** currently carried by Handles as a special case.
5. **Slightly increase the indent under disclosure-triangle sections** (~3px).

## Scope
Cross-package as before: `packages/space-chat` (the Handles bucket + the manual ordering + the
filtered count), `packages/chat` (CSS for the ~3px indent + removing the speech-bubble prefix +
tests), `packages/cli` (`endo list --grouped` bucket set/order + tests if the CLI mirrors the
grouping), `packages/daemon` (types only if the Handles bucket needs them). Keep the existing
empty-group hiding working with the new six-group set.

## Deliverable
The five asks implemented on the PR branch, chat/cli tests updated and passing (especially the
filtered-count ↔ expanded-contents agreement), reviewed through the panel, with a top-level summary
comment on #405 enumerating how each of the five points was addressed.
