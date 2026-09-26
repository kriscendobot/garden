---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
handler-timeout: 5400

# Build: journal-backed foreman spend-ramp and priority mandate

Maintainer directive (kriskowal, 2026-09-26), to take effect over the
2026-09-26/27/28/29 weekend while unattended. Two small, additive,
backward-compatible reads. Ground yourself first: read
`scripts/jobs/usage-meter.sh` lines ~57-100 (GARDEN_TOKEN_BACKOFF_FRACTION),
`scripts/jobs/foreman.sh` lines ~340-365 (the digest build passed to the
handler) and `scripts/jobs/handlers/foreman-claude.sh` (confirm it includes
the whole digest file verbatim in its prompt — if it does NOT, say so in your
report and stop rather than silently building a mandate field nobody reads).

## Part 1: journal-backed token-backoff fraction

Today `GARDEN_TOKEN_BACKOFF_FRACTION` (default 0.85, the high-water fraction
of a subscription's weekly cap at which `usage-meter.sh` triggers backoff for
both `foreman.sh`'s pump gate and `budget-level.sh`'s smooth worker-count
scaling) is settable only via each systemd unit's own `Environment=` line —
host-local, not portable across a leader handoff.

Add a journal-backed override, checked BEFORE the existing `0.85` default:
a new file `config/token-backoff-fraction` (plain text, one float 0 < f <= 1,
mirroring the read style of `config/foreman-brake`'s existence-as-signal
pattern but with actual content this time — closer to how
`config/budget-pools` is a plain read). If the file is absent or unparseable,
fall back to the existing behavior byte-for-byte (env var if set, else 0.85) —
zero behavior change for any host/test that doesn't create this file. Absolute
precedence order: explicit `GARDEN_TOKEN_BACKOFF_FRACTION` env (tests already
rely on this) > journal `config/token-backoff-fraction` > the 0.85 default.

Validate the parsed value is a number in (0, 1]; an invalid file content logs
a WARN and falls back rather than failing closed (this gates live spend —
never let a malformed config silently zero out the fleet's pump).

## Part 2: foreman priority mandate, folded into the pump-generation prompt

`foreman.sh`'s digest (the file passed to `$GARDEN_FOREMAN_HANDLER`) currently
carries `project:`, `board:`, `last_step_posted:`. Add one more field,
`priority_mandate:`, sourced from a new journal file `config/foreman-mandate`
(free-text, multi-line) if it exists and is non-empty; omit the field entirely
when the file is absent/empty (so existing behavior is unchanged with no
mandate configured). Confirm (per the grounding step above) that
`foreman-claude.sh` passes the digest's full content into its `claude -p`
prompt verbatim, so this field actually reaches the generative step rather
than being silently dropped.

## Tests

Extend whatever existing suite covers `usage-meter.sh`'s fraction resolution
and `foreman.sh`'s digest construction (`scripts/jobs/test/*.sh` — find them,
don't guess names) with: journal override present/absent/malformed for part
1; mandate file present/absent/empty for part 2. Run the full relevant suite,
not just your new cases, before reporting done.

## After landing

Land direct to `main2` (garden's own repo convention, no PR, unless you
discover open questions worth surfacing — this should not have any, it is a
narrow additive read). Do NOT write `config/token-backoff-fraction` or
`config/foreman-mandate` yourself — the maintainer/liaison sets the actual
values and schedule after this lands and deploys. Say clearly in your report
once this is confirmed deployed and ready for those files to be written.

<!-- garden-reaped: 0 -->
