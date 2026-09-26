Done. Here's what was done:

**Changes made:**

1. **`packages/ses/docs/guide.md`** — Removed `URL` and `URLSearchParams` from the "What Lockdown removes from standard JavaScript" section (the WHATWG additions line, the unavailable bullet, and the surprising removals summary). Added a new entry in "What HardenedJS adds to standard Javascript" documenting them as now-permitted universal intrinsics with cauterized dangerous static methods.

2. **`docs/guide.md`** — Same three-location updates for consistency.

3. **`docs/lockdown.md`** — Added a new `## Shared Intrinsics` section after the Math example code block, describing what lockdown permits as shared/intrinsics across all compartments, with specific detail on URL/URLSearchParams being permitted with `createObjectURL` and `revokeObjectURL` cauterized, and the XS skip-when-missing behavior.

4. Committed as `c9fa9a82b` and pushed to `origin/feat/hardened-url-shim`.

**Follow-ups:** The maintainer (kriskowal) can now review the docs update and potentially clear their `CHANGES_REQUESTED` status on PR #719.
