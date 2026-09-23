---
ts: 2026-06-02T21:22:00Z
kind: dispatch
role: liaison
host: endolinbot
repo: endojs/endo-but-for-bots
project: endo-but-for-bots
to: fixer
dispatch_root: /home/kris/dispatches/fixer--093367
prs:
  - repo: endojs/endo-but-for-bots
    pr: 351
    role: target
refs:
  - https://github.com/endojs/endo-but-for-bots/pull/351
---

# dispatch: fixer — replace "cf." with English on #351 per kriskowal

kriskowal review at 20:46:27Z on #351 with inline comment at line 73 of
`packages/compartment-mapper/src/link.js` (20:45:07Z): "Please avoid
Latin. Dispatch to gardener to improve style guide."

This dispatch handles the local fix (line 73). The maintainer's
"dispatch to gardener" half is a separate gardener dispatch following
this one.

## The fix

Line 73 currently reads:
```
// cf. section 3.1 of RFC 3986 URI Scheme Generic Syntax
```

"cf." is Latin shorthand for "confer" (compare). Replace with English.
Suggested: "See" or "Per".

```
// See section 3.1 of RFC 3986 URI Scheme Generic Syntax
```

Also scan the rest of `packages/compartment-mapper/src/link.js` for
other Latin shorthand (e.g., "i.e.", "etc.", "et al.", "vs.", "viz.",
"ad hoc", etc.) and replace those too with English. If you find any
elsewhere, list them in the report.

## Procedure

1. `sed -i` or Edit-tool the specific replacement.
2. Verify with `grep -n -E '\\bcf\\.|\\bi\\.e\\.|\\be\\.g\\.|\\betc\\.|\\bet al\\.|\\bvs\\.|\\bviz\\.|\\bad hoc\\b' packages/compartment-mapper/src/link.js`
   — zero matches expected.
3. Commit:
   ```
   style(compartment-mapper): replace Latin shorthand in link.js per kriskowal #351
   ```
4. Push regular append.

## Per-action authorizations

- Edit `packages/compartment-mapper/src/link.js`. Authorized.
- grep verification. Authorized.
- Regular append push. Authorized.
- No PR comments.

## Not authorized

- Editing other files (style-guide update is a gardener follow-up).
- Force-push.
- Un-draft / re-draft / merge.
- PR comments.

## Dispatch protocol

Read:
1. garden/roles/COMMON.md
2. garden/roles/fixer/AGENT.md
3. Skills just-in-time.

Project worktree on `mirror/2422-host-module-exits` (head `fd214c1fc`).

## Report

Result journal entry with: new head SHA, line 73 before/after, list of
any other Latin shorthand found and replaced in the file, grep
exit code, and any deviations.
