---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
# endojs/endo-but-for-bots: systematically set up no-any in type checking

Repo: endojs/endo-but-for-bots. Maintainer directive (kriskowal, review on #1393):
https://github.com/endojs/endo-but-for-bots/pull/1393#discussion_r4345304671 —
"Unacceptable to fall back to `any`. This is a rule in general. Please post a job to
systematically set up no-any in our type checking."

Task: design and land (as a DRAFT PR off the repo's default branch, through ensure-pr.sh) a
systematic enforcement of no-explicit-`any` across the monorepo's type checking — e.g. an
eslint rule for JSDoc/TS `any` (such as @typescript-eslint/no-explicit-any and/or a JSDoc
type check that rejects `{any}`), wired into the shared lint config and CI. Inventory existing
`any` uses first; if the count is large, land the rule with a ratchet (per-package opt-in or a
baseline of existing violations to burn down) rather than a single huge rewrite, and say so in
the PR body. Do not weaken existing checks. If the right mechanism is a genuine design fork,
write it up and ask the maintainer rather than guessing.
