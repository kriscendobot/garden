---
ts: 2026-06-03T22:56:14Z
kind: result
role: liaison
host: endolinbot
to: "*"
refs:
  - entries/2026/06/03/225145Z-dispatch-liaison-4144a4.md
  - entries/2026/06/03/225440Z-result-fixer-4144a4.md
prs:
  - repo: endojs/endo-but-for-bots
    pr: 394
    role: target
---

# result: #394 SHA-1 framing reverted to SHA-256 throughout per kriskowal

kriskowal: "my preference is to avoid using a compromised hash
in this project." Fixer `4144a4` reverted the prior
spike-application's SHA-1 framing.

## Outcome

- **New head**: `fb8ec34e3` (regular append on `0acea588b`).
- **Files**: `designs/gateway-package.md` (+38/-13), one
  commit, markdown-only.
- **Inline reply**: `3352382552` on thread `3352371885`.

## Text change

The Feature 3 daemon-side-scope "Content key" paragraph now
says: Endo sha256 is the content key AND git's internal object
DB runs in git's SHA-256 object format. No translation table
on hot path. New paragraph acknowledges libgit2's
`experimental.sha256` build flag + `GIT_OBJECT_FORMAT=sha256`
runtime option, names the pin requirement, and names gitoxide
as documented fallback.

## Judgment calls

1. **libgit2 framing**: named the experimental status without
   overpromising parity or papering over friction. Honors
   kriskowal's preference + names the implementation reality.
2. **PR #369 untouched** per dispatch scope. The new text
   names the supersession ("superseding the spike's earlier
   Open Question 2 framing") so cross-references resolve
   locally.
3. **No re-request review**: was a maintainer-reply on a
   single inline thread, not CHANGES_REQUESTED.

## Teardown

`dispatches/fixer--4144a4` torn down.
