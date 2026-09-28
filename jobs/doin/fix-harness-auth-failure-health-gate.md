---
role: gardener
tier: mentor
fallback-tier: minion
dispatch: automatic
handler-timeout: 10800
token-budget: 500000
---
# Detect harness auth-failure deterministically, park the host, alert the maintainer

Repository: `kriscendobot/garden`, branch `main2` — land direct, no PR, per
CLAUDE.md's own-repo convention. Work in an isolated project worktree
(`ensure-project-worktree.sh <base> kriscendobot/garden main2`). Never run git
against `$GARDEN_ROOT`.

## Why (maintainer directive, kriskowal 2026-09-28)

> To do better in the future, we just need automation to notice that
> dispatches to a harness are exiting due to authentication needs and surface
> that to the maintainer inbox (if not already flagged). It's critical that
> this occur without a successful agent, obviously.

Concrete incident: `endolin-garden2-5bcdff64`'s Claude Code session
(`endolin-claude2` subscription) had expired credentials. Every claim it won
died on an auth failure. Because nothing recognized that SPECIFIC signature,
this host kept winning claim races with fast, doomed failures for ~24h: 178
claims, 65 completions, 109 non-transient "terminal-failure" escalations —
each one landing only in the per-host gardener inbox as a generic diagnostic,
never surfaced loudly to the maintainer, and nothing stopped the host from
claiming the next job and repeating it.

## The exact precedent to mirror — read this commit first, in full

Commit `916ab48e206` (yesterday, "fix(health-gate): park a host whose agent
CLI is too old for the tier model") solved the SAME SHAPE of problem for a
different signature (a stale CLI rejecting the resolved model, oros-studio
2026-09-27). Read it end to end:
`git show 916ab48e206 -- scripts/jobs/common.sh scripts/jobs/gardener.sh scripts/jobs/test/worker-health-gate-test.sh`
(or the equivalent test file it added/extended — find it if the name differs).
It gives you, in one diff: the classifier shape
(`is_model_unsupported_signature`, a curated `grep -qiE` regex env var), the
latch shape (`worker_model_unsupported_latch`, opens a `reason=`-tagged
episode via the existing `worker_health_gate`/`worker_health_marker`
machinery), the gate's reason-aware refusal-to-auto-clear (checked BEFORE the
generic healthy-path recovery, so a merely-present-but-broken CLI doesn't
immediately un-park itself), the `gardener.sh` wiring (force
`transient=1` — the JOB is fine on a healthy host, requeue it normally — AND
latch the HOST's gate), and the test coverage shape.

**Build the auth-failure case as a sibling of this, not a rewrite.** Same
functions, same file locations, same wiring point in `gardener.sh` (right
next to where the model-unsupported check now sits), same
`_worker_health_report` → `alert_maintainer` path for the maintainer-inbox
surfacing — that mechanism already exists, is already edge-triggered/deduped
(one report per open episode, not per failure), and needs no new code; wiring
into it is what satisfies "surface to the maintainer inbox (if not already
flagged)" for free.

## What's different about auth-failure vs. model-unsupported

1. **Find the real signature text before writing the regex.** Don't guess.
   Pull the actual captured diagnostic from one of endolin-garden2's real
   failures in the last ~30 hours: find a `terminal-failure: hint` commit for
   that host (`git -C journal log --oneline --since="30 hours ago" | grep
   "terminal-failure: hint" | grep endolin-garden2`), then trace it to the
   `report-error.sh` capture it produced (the gardener inbox entry / captured
   blob referenced from that cycle — `skills/gardener-inbox-error-reporting/`
   has the read side) and read the ACTUAL error text Claude Code printed on
   an expired/invalid credential. Cover both providers this host's kinds can
   use (anthropic via `claude`, openai via `codex` if this host runs a
   cleric) — the two CLIs will have different wordings; check both.
2. **The un-park condition can't be a CLI version string — nothing about the
   CLI changes on re-auth.** The natural analog: compare the credential
   file's content (hash, not mtime — a hash catches a rewrite with identical
   mtime-granularity timing) at latch time vs. now, the same shape as the
   model-unsupported check's `cli-version` comparison. `claude_auth_ok()`
   (common.sh, the existing PRESENCE-only credential check just above the
   model-unsupported section) already names the credential file path
   (`${CLAUDE_CONFIG_DIR:-$HOME/.claude}/.credentials.json`) — reuse that
   constant, don't re-derive it. Record the hash at latch time; the gate
   un-parks once it differs (a human re-running the login flow rewrites the
   file) — do NOT spend a live API call to verify auth actually works, that
   defeats the point of a cheap pre-claim gate. If the same broken credential
   somehow gets rewritten identically, the host reopens the episode on its
   next failed claim — acceptable, matches how the model-unsupported case
   would behave under an equivalent edge case.
3. **Cover whichever provider CLIs this fleet actually runs auth-signatures
   for** (anthropic `claude`, openai `codex` at minimum — check
   `worker_kind_field`/`agent_bin` for the full kind registry) rather than
   anthropic only, since the underlying mechanism (`worker_health_gate`) is
   already kind-generic.

## Tests

Extend `worker-health-gate-test.sh` (or wherever `916ab48e206`'s SUBTEST 6
landed) with a sibling subtest: the auth-failure matcher, the latch, the
same-credential-hash park, and the credential-change recovery. Run the full
relevant suite, not just your new cases — the garden's own CI was red for 3
days last week from an undertested edge exactly like this
(`fix-garden-ci-gauntlet-retry-viability-tests`, 2026-09-27); don't repeat
that.

## Report

Confirm: the real signature text you found (quote it), the provider(s)
covered, and that a synthetic/simulated version of the endolin-garden2
scenario (or the real thing, if it's still unresolved when you run) now (a)
forces the job transient instead of doom-cycling it, (b) parks the host after
one failure instead of 109, and (c) produces exactly one maintainer-inbox
notice for the episode, not one per failure.

---
claim:
  host: endolin-garden2-5bcdff64
  gardener: 1
  worker_kind: monk
  tier: 
  provider: anthropic
  model: 
  claimed_at: 2026-09-28T05:44:51Z
