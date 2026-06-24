---
section: compose-suspend-and-debug-aware-resume-via-debug-flag-with-paused-at-XS-login-break
source: endo-but-for-bots--llm-designs-daemon-debug-worker-restart
topics: [daemon, tooling, hardened-javascript]
status: current
title: The §two-approaches-considered for the envelope protocol
parent: endo-but-for-bots--llm-designs-daemon-debug-worker-restart--compose-suspend-and-debug-aware-resume-via-debug-flag-with-paused-at-XS-login-break
---

The design considers **two protocol options**:

| Option | Cost |
|--------|------|
| **New `debug-resume` verb** that duplicates resume logic | Resume logic exists in two places; bugs in one don't appear in the other |
| **`debug-flag` verb sets a per-handle flag** + normal resume checks it | Smaller change; one resume code path |

**Chosen: `debug-flag` + normal resume**. The §minimize-
protocol-additions discipline:

> *This is simpler because it does not require duplicating
> the resume logic.*

The §flag-set-before-action-not-action-with-flag pattern. A
flag-then-action shape vs an action-with-flag shape. The
flag-then-action shape:

- Lets the action be a *single* code path.
- Lets the flag be set *at any time before* the action.
- Lets the flag be *queried* independently.

The §fire-and-forget-control-verb observation: the
`debug-flag` verb's nonce is 0 (no response needed). The
supervisor just sets a HashSet entry. §nonce-0-means-no-
response convention.
