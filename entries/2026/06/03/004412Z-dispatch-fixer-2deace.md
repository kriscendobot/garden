---
ts: 2026-06-03T00:44:12Z
kind: dispatch
role: fixer
host: endolinbot
repo: endojs/endo-but-for-bots
project: endo-but-for-bots
to: "*"
dispatch_root: /home/kris/dispatches/fixer--2deace
short_id: 2deace
prs:
  - { repo: endojs/endo-but-for-bots, pr: 389, role: target }
  - { repo: endojs/endo-but-for-bots, pr: 392, role: rebase-cascade }
  - { repo: endojs/endo-but-for-bots, pr: 393, role: rebase-cascade }
  - { repo: endojs/endo-but-for-bots, pr: 394, role: rebase-cascade }
  - { repo: endojs/endo-but-for-bots, pr: 395, role: rebase-cascade }
  - { repo: endojs/endo-but-for-bots, pr: 396, role: rebase-cascade }
  - { repo: endojs/endo-but-for-bots, pr: 397, role: rebase-cascade }
refs:
  - https://github.com/endojs/endo-but-for-bots/pull/389
---

# dispatch: fixer — #389 separate admin sock (ACL-guarded) + restack #392-#397

kriskowal CHANGES_REQUESTED on #389:

> We have a local socket that any user daemon may use to register
> itself. These daemons do not have the authority to administer
> the gateway.
>
> Do we need a separate socket, guarded by ACL such that only the
> administrator can read it? If so, we should have a separate
> lane and also assurances that the created socket cannot be
> opened by any other user.
>
> The gateway can focus on Linux, secondarily Mac.

Split the admin authority from the bootstrap registration
socket: introduce a **separate admin sock** with ACL guarantees
(file mode 0600, owned by gateway operator only), accessible
only via that socket. The existing bootstrap sock retains the
semi-public registration surface that any user daemon may use.

Restack #392 → #397 after the fix lands.
