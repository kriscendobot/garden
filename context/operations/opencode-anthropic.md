---
created: 2026-09-01
updated: 2026-09-30
author: gardener
status: Declined — see § Declined 2026-09-30
---

# OpenCode Anthropic probe lane

`opencode-anthropic` is a disabled-by-default harness-diversity canary. It calls
Anthropic through OpenCode while the native `monk` kind calls the same provider
through Claude Code. The distinct worker kind gives the two harnesses distinct
reputation arms.

## Routing and safety

The lane accepts only a namespaced explicit pin:

```yaml
model: opencode-anthropic/haiku
```

The garden-only prefix selects the OpenCode harness and is stripped before the
provider call. The event and arm retain the concrete underlying model, such as
`claude-haiku-4-5-20251001`, so an equivalent native canary can be compared on the
same provider/model/thoughtfulness tuple. A plain `model: haiku`, an unpinned job,
and a tier-only job are never eligible for this lane.

The handler requires `opencode` and `ANTHROPIC_API_KEY`. It gives each job private
XDG data, config, and cache directories under the worker state namespace. OpenCode
1.18.25 stores sessions in SQLite and no longer documents `OPENCODE_DATA_DIR`, so
the implementation uses the XDG directories instead. On completion it exports the
session and feeds that file into the existing transcript spool before deleting the
private state.

## Bounded canary

After installing OpenCode and placing a metered Anthropic key in the user manager
environment, deploy the garden, declare exactly one worker, and post this body:

```yaml
---
model: opencode-anthropic/haiku
role: probe
target: main2
---
In this dedicated worktree, create `.opencode-canary`, verify its contents are
`reversible canary`, then remove it. Make no tracked changes. Report the create,
read, and removal observations and finish normally.
```

```sh
scripts/jobs/set-workers.sh opencode-anthropic 1 "$(hostname -s)"
```

After the verification, stand the lane down with the same command and count `0`.
Do not post the canary before the new eligibility code is deployed: an older worker
does not know the harness namespace and can treat that model string as unclassified.

## Probe status on 2026-09-01

The host had neither an installed OpenCode binary nor an Anthropic API key. A
temporary OpenCode 1.18.25 binary verified that a refused key returns rc 1 with a
parseable `sessionID`, and that `--session <id>` reuses that exact id. Killing the
real CLI returned rc 143. The hermetic handler probe verified the sidecar resume,
summed `step_finish` accounting, distinct kind arm, rc 143 preservation, and rc 75
normalization for a 401 refusal.

The paid canary, real non-zero USD row, and a live mid-successful-run resume remain
unverified until a metered Anthropic key is provisioned. This is an environment
gap, not evidence that those paths pass.

## Declined 2026-09-30

kriskowal declined to provision an Anthropic API key for this lane (liaison
session, 2026-09-30): "I decline to give the garden an Anthropic API key. That
presumably strands an opencode exploration. I would like to explicitly archive
that work." This is a deliberate stop, not an oversight — do not re-ask for the
key and do not re-post the bounded-canary probe above.

**What stays and what doesn't.** The `opencode-anthropic` worker kind itself
(routing, eligibility, handler, reputation arm — commit `77b82f7f2d`) is
already-landed code and is not being reverted; it costs nothing sitting idle
at zero declared workers. What's archived is only the **live paid-canary
verification** described above: the real non-zero USD row, the live
mid-successful-run resume, and the un-refused-key path all remain permanently
unverified by this decision, not by a gap that a future job should try to
close. A future maintainer directive would be needed to reopen this, not a
routine probe or muster follow-up.
