---
ts: 2026-06-03T23:27:16Z
kind: dispatch
role: researcher
host: endolinbot
project: endo-but-for-bots
to: "*"
dispatch_root: /home/kris/dispatches/researcher--91bd98
short_id: 91bd98
refs: []
---

# dispatch: researcher — refine proposed builder prompt for zizmor pinned-action mismatch

Researcher precedes the builder. Subject: address recurring
zizmor pedantic failure "action's hash pin has mismatched or
missing version comment" across `.github/workflows/*.yml`.
Branching off master; running the gamut on the resulting PR.

The proposed prompt asks the builder to audit every `uses:
<action>@<sha> # <comment>` site, verify the SHA resolves to
the commented tag, and update either the pin or the comment
to make zizmor pedantic happy.
