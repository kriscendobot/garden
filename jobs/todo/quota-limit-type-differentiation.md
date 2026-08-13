---
role: builder
tier: mentor
fallback-tier: minion
dispatch: automatic
---
repo: the garden itself (this repo, `main2` branch)
role: builder

# Differentiate session/usage/5-hour vs weekly quota-limit refusals

Garden-infra build: land straight onto `main2` from an isolated per-job
worktree off `origin/main2` — no branch, no PR.

## Ground truth, established before this job starts

**Checked against Anthropic's own documented API surface**: a 429
`rate_limit_error` carries NO structured field distinguishing a session-level
limit from a weekly plan-level limit — same `type`, same shape, both cases.
The `*-reset` response headers give a timestamp but no semantic label. There
is no better signal at the raw API level. **Do not spend time trying to find
one there.**

**But `claude`'s own printed text already IS more specific than the API**:
the fleet has captured real refusals reading "You've hit your weekly limit ·
resets Jul 25, 3am (UTC)" and "You've hit your session limit · resets 2am
(UTC)" — distinct wording per limit class, plus an absolute/relative reset
time. This is CLI-level text, not an API field, but it's real and already
flowing through the fleet's capture pipeline (`gardener.sh`'s handler
capture, `self-heal-claude.sh`'s diagnostic blobs, `follow-up-claude.sh`).
**Part 1 of this job is to verify empirically** (against any captured
examples still in the transcript spool, or `--output-format json`'s result
envelope on a synthesized case) **whether the JSON envelope's `result`/error
fields carry this same wording verbatim, or something richer** — report
plainly either way rather than assuming.

## The actual bug: an asymmetry already sitting in `common.sh`

Two sibling signature lists exist and have drifted apart:

- `GARDEN_PROVIDER_QUOTA_SIGNATURES` (~line 1346): alternation includes
  `(session|usage|weekly|5-hour)` — all four wordings.
- `GARDEN_EXPLICIT_CAP_SIGNATURES` (~line 3171): alternation is only
  `(session|usage)` — **`weekly` and `5-hour` are missing.**

`GARDEN_EXPLICIT_CAP_SIGNATURES` is what `gardener.sh` (~line 993-1001)
consults to decide whether a handler that died implausibly fast (under
`GARDEN_MIN_PLAUSIBLE_OVERRUN_SECS`, default 5s) is a real cap rejection
(exempt from the floor, correctly kept transient) or a deterministic defect
(escalated as a real failure). The code comments there document exactly this
class of bug already happening once for session/usage wording (2026-07-17,
"killing a review job and a press claim until the reaper's TTL") and being
fixed for those two words — but **the same bug is still live today for a
fast-dying weekly or 5-hour limit refusal**, because the exemption list never
picked up those two words. This is very likely the concrete mechanism behind
what the maintainer is seeing: a fast weekly-limit death gets misclassified
as a deterministic defect instead of the self-resolving account-level
condition it actually is.

## What to build

1. **Fix the asymmetry.** Bring `GARDEN_EXPLICIT_CAP_SIGNATURES` back in sync
   with `GARDEN_PROVIDER_QUOTA_SIGNATURES` (all four words). Better: derive
   one from the other (or share a common word-list variable) so they cannot
   drift apart silently again — that drift is the root cause here.

2. **Add a type-extraction helper.** Alongside the existing
   `provider_quota_reset_clause <text>` (which already extracts the "resets
   …" clause), add `provider_quota_limit_type <text>` that echoes which of
   `session`/`usage`/`weekly`/`5-hour` actually matched. Both helpers read
   the same captured text; today only the reset time is extracted; the type
   is thrown away the moment `is_provider_quota_text` collapses it to a
   boolean.

3. **Wire the type into the fleet notice.** `alert_maintainer`'s
   provider-quota reclassification block (~line 1374-1384) currently folds
   every occurrence into one generic "provider quota/usage limit reached"
   notice. Include the extracted type so the maintainer (and any future
   automation reading the notice) can tell "this is a 5-hour blip, ignore it"
   from "this is the weekly cap, back off until Friday" without reading raw
   diagnosis text.

4. **Close the explicitly-flagged, previously-deferred follow-on.** The
   comment at ~line 3142-3144 already names this exact gap: "when the
   signature carries an explicit reset time, back off the reaper requeue
   until that time instead of re-failing every TTL cycle." Now that both
   type and reset-time are extractable, wire this into the reaper's requeue
   scheduling: a session/5-hour/usage cap backs off to its (short) named
   reset; a weekly cap backs off to its (long) named reset — instead of
   uniform TTL-interval retries that either hammer a still-capped account or
   sit needlessly idle past a session limit that already cleared.

## Tests

Regression coverage that specifically reproduces the bug this job fixes: a
captured handler death worded as a fast (<5s) weekly-limit or 5-hour-limit
refusal must be recognized by `is_explicit_cap_signature` and kept transient
— not escalated as a deterministic defect. Also cover
`provider_quota_limit_type` against all four wordings, and the reaper backoff
scheduling honoring a parsed reset time for both a short (session) and long
(weekly) case.

## Report

State plainly: what the JSON-envelope investigation found (Part 1), the
asymmetry fix, and confirm the specific misclassification bug (fast weekly/
5-hour death treated as deterministic) is now covered by a test that fails
on the pre-fix code.
