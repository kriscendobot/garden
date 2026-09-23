Landed on `main2` as `1f3f123186`, prose only, zero behavior change.

## The definition as landed

`context/operations/scaling.md` § Pausing: drain now opens with:

> **Drain enacts a moratorium on undertaking further work, while allowing work already in progress to finish.** **Lift** (`drain off`) relaxes the moratorium and workers resume claiming.

followed by the not-a-fixture note: what is being drained is the `doin/` board — it empties because inflow stopped while outflow continues; that is **draining as a process**, a pool emptying, **not a physical drain** with a fixture to plug, uncork, or open.

## Files touched (10)

| File | Change |
| --- | --- |
| `context/operations/scaling.md` | Canonical definition + not-a-fixture note; intro gloss now says "declares a moratorium on new claims … **lift** relaxes it" |
| `context/operations/starting.md` | Step 6 retitled "Check for a stale drain and **lift** it", with a one-clause moratorium gloss deferring to scaling.md |
| `roles/liaison/AGENT.md` | § stand up ("**lifting** it", "the lift step"); § stand down/drain carries the moratorium definition and an explicit "never speak of uncorking or plugging it"; § Drain aftermath's "un-drain"/"uncork" → "lifting the drain"/"lift" |
| `README.md` | Vocabulary row is now **stand up / stand down / drain / lift** with a one-clause gloss + link; the fleet-operations bullet glosses drain/lift inline |
| `CLAUDE.md` | One clause added to the existing sentence (drain = moratorium, lift relaxes it, link to scaling.md) |
| `context/first-run/README.md` | New paragraph at first contact with "drain state" teaching drain-as-act / lift, and naming plug/cork/floodgate as the wrong reading |
| `scripts/jobs/drain-fleet.sh` | Header comment + the prose body written into the marker file only |
| `context/operations/deploy.md` | "uncorks a stale drain" → "**lifts** a stale drain"; "The un-drain" → "The lift" |
| `context/control-surface-gallery.md` | "operator-confirmed uncork" → "operator-confirmed lift" |
| `context/operations/leader-follower.md` | Disambiguated the sense collision in step 4: "drains its liaison bus" → "reads its liaison bus to empty" |

## Judgement calls on the overloaded second sense

Only where the two senses actually collide. `README.md` line 262 "when the board **drains** entirely, the foreman…" → "**empties** entirely" (it means the `todo/` board running dry — a consequence of the fleet working, the near-opposite of a moratorium), and the leader-follower step above. Left alone: the many idiomatic "drain your inbox / drain the merge queue" uses in `roles/`, `skills/`, and the `drain_reopen` field in `skills/review-retrospective/SKILL.md` — no fixture metaphor, no collision with the operator verb. `designs/` untouched per the job's instruction not to retcon design history.

## Verification

- Sweep for `uncork|floodgate|plug the drain|unblock the drain` across `roles/`, `skills/`, `context/`, `README.md`, `CLAUDE.md`: the only survivors are the three new sentences that *name* the wrong metaphor in order to forbid it.
- Zero behavior change: the `drain-fleet.sh` diff is comment lines and `echo` strings. `bash -n` passes; `on`/`off`/`status` smoke-tested against an isolated `GARDEN_STATE` under `$TMPDIR` (marker written with the new body, then removed) — the real fleet was never drained. No command name, marker path, or env var moved.
- Pre-dispatch gates: `bench-engines-rename`, `claude-md-inventory-drift`, `double-space-sentence-separator`, `verified-claim-requires-evidence` all clean.

## Follow-ups

- `scripts/checks/maintainer-inbox-information-hiding/check.sh` fires on this tree, with 13 pre-existing leaks in files this job did not touch (`roles/{COMMON,orchestrator,prosecutor,botanist}`, `skills/{orchestration,restore,review-retrospective,schedule}`). Unlike the double-space gate it is whole-tree rather than diff-scoped, so it fires on the unmodified checkout too. Unrelated to this job; worth its own job to either scrub those references or extend the gate's allowlist.
