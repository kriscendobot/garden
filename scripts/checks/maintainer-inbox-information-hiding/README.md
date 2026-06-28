# maintainer-inbox-information-hiding gate

## What it catches

An issue/PR-scoped role -- or a skill such a role loads -- that
references the **maintainer inbox**. Per the maintainer's 2026-06-28
directive, an agent working on an issue or a pull request communicates
with the maintainer **only through comments on that issue/PR** (inline
on the relevant line, plus a summary), never the maintainer inbox. The
property is information-hiding: a scoped role must not even be presented
anything suggesting the inbox exists. Only **free-standing** roles (ones
engageable with no issue/PR reference) may reference it.

The restricted tokens are the maintainer inbox: `inbox/maintainer`,
`message-user`, `maintainer-watch` / `-reply` / `-archive`, and the
prose "maintainer inbox". The inter-agent message bus (role inboxes,
`inbox-send.sh`, `send-msg.sh`, `read-msgs.sh`, broadcast) is a separate
facility for agent-to-agent routing and is deliberately NOT matched.

## How it fires

Exit non-zero when any of:

1. An issue/PR-scoped role file carries a maintainer-inbox token.
2. A skill referenced by an issue/PR-scoped role carries a token.
3. The set of token-bearing files under `roles/` + `skills/` is not
   exactly the allowlist baked into `check.sh` (a leak anywhere, or a
   stale allowlist entry). This is the machine-enforced "the set of files
   mentioning the inbox equals the audited free-standing set."

## The historical incident

Before this gate, the maintainer inbox was referenced from the
issue/PR-scoped `boatman` role and the juror-linked `pr-creation-flow`
skill, alongside the legitimate free-standing references (liaison, proxy,
foreman, gardener). The 2026-06-28 audit scrubbed the scoped references,
moved the standing rule into `roles/COMMON.md` § Communicating with the
maintainer (phrased without naming the inbox), and froze the result with
this gate.

## Widening or disabling

The free-standing set and the allowlist live together in `check.sh`
(`FREE_STANDING_ROLES`, `INBOX_ALLOWLIST`). Adding a genuinely
free-standing role or skill that needs the inbox means editing both in
the same commit -- that visible edit is the audit trail, the same shape
as the monitoring safety constraint. To disable the gate, remove this
directory; the runner enumerates gates by the presence of
`check.sh` + `prompt.md`.
