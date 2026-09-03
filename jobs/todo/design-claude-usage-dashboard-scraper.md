---
role: designer
tier: mentor
fallback-tier: minion
dispatch: automatic
---
Design a host-side Playwright program that authenticates to the Claude.ai usage dashboard and reports readings back into the garden's quota-checkpoint logs, per kriskowal 2026-09-03: *"propose a program that can use Playwright to interrogate the Anthropic Claude usage dashboard through an authenticated session in the headless browser... It will not be run in the garden environment, but on the host. The program can be checked into the garden as a skill. It will need to communicate with the garden by appending to a file in the garden's journal checkout, somewhere the garden can monitor through its shared filesystem mount."*

Target page: `https://claude.ai/chat/<account-identifier>#settings/usage` — shows a weekly-limit percentage + reset time, and a separate 5-hour rolling session-limit percentage + reset time (the same two numbers kriskowal has been reading by hand all session — see references below).

## Starting brief (from the liaison's inline proposal; revise freely, this is a starting point not a mandate)

**1. Execution/trust boundary — the load-bearing constraint.** This runs on the **host**, under the maintainer's own identity, never inside the garden container. Its auth credential material (a Playwright `storageState` — effectively a live session token) must **never** be written anywhere under `<garden-root>`, because the bind mount that lets the container mirror the host filesystem (CLAUDE.md § Container guard, § Host environment) would make it equally readable by the bot-identity fleet. Store it host-only (e.g. `~/.config/garden-usage-scraper/`), restrictive permissions, and say this prominently in the skill's `SKILL.md`, not as a footnote.

**2. Auth: one-time interactive bootstrap, then headless replay.** Don't reimplement whatever login flow kriskowal actually uses (Google OAuth / password+2FA / email link). Playwright's `storageState` mechanism is the standard pattern: a `--bootstrap` mode launches headed, the human logs in by hand once, the script persists `context.storageState()`; every subsequent run launches headless with that state restored — no OAuth dance per run. Detect an expired/invalid session (redirected to login instead of the dashboard) and fail loudly asking for a re-bootstrap, never write garbage on a failed read.

**3. Scraping approach — a real page sample arrived mid-session, use it.** kriskowal pasted the live page's HTML (2026-09-03). Concrete findings, already verified as real markup (not guessed):
   - Each usage meter is a proper **ARIA `role="meter"`** element:
     `<div role="meter" aria-valuemin="0" aria-valuemax="100" aria-valuenow="31" aria-valuetext="31% used" aria-labelledby="_r_6f_">`.
     `aria-valuenow` is the exact integer percent as a plain attribute — read that,
     not the rendered `%` text or any CSS transform/width styling. This is the
     right selector to build on: an accessibility contract Anthropic has a real
     reason not to break, unlike the Tailwind utility classes littering this
     markup (those churn on every rebuild; do not select on them).
   - `aria-labelledby` points at a `<span id="_r_6c_">Current session</span>` /
     `<span id="_r_6f_">All models</span>` (etc.) sibling — that's how to
     distinguish the session meter from the weekly "All models" meter from any
     other per-model weekly row (the sample also showed a `Fable` row at 0% —
     the page lists weekly usage **per model**, not just one aggregate; "All
     models" is the row this design cares about, but note the per-model rows
     exist in case a future need wants them).
   - **Reset times are relative text, not absolute**, in two different formats
     depending on section: `"Resets in 3 hr 12 min"` (session) vs. `"Resets Fri
     8:00 PM"` (weekly) — no date, no explicit timezone in either string. Both
     must be parsed relative to "now" (script run time) and the account's
     apparent timezone (Pacific, per every other reading this session — confirm
     this holds, don't hardcode it blind). Convert to absolute UTC at scrape
     time and store the absolute value, not the relative string, since the
     relative string decays the moment it's saved.
   - The `<span class="... text-footnote text-secondary">31% used</span>` plain-text
     duplicate exists too, as a fallback cross-check against `aria-valuenow`,
     cheap insurance against a future markup change to one but not the other.
   - **A banner worth capturing, not just the two numbers:** `"Your limits are
     temporarily boosted. Your weekly Claude Code limit is 50% higher through
     September 13."` — a real, time-bounded plan-wide multiplier that directly
     confounds any tokens-per-percent calibration if its start time is unknown
     (see `manual-checkpoints/README.md`'s "A confound discovered 2026-09-03"
     section — this is not hypothetical, it already muddies the checkpoint data
     collected earlier today). The scraper should capture this banner's text
     verbatim (or its absence) on every run, appended alongside the two meter
     readings, so a future analysis can at least bound *when* such a boost was
     and wasn't in effect from the scrape history itself, even without knowing
     it started until the first scrape that shows it.
   - Also present on the page but likely **out of scope** for this design's
     first cut: a separate "Usage credits" section ($400/mo spend cap, current
     balance, auto-reload toggle) — a different, dollar-denominated overage
     mechanism, not the weekly/session token-limit tracking this design exists
     for. Note it as a possible future extension, don't build it now.
   - Network-tap fallback (Playwright request interception, checking whether the
     page's own JS calls an internal JSON API) is still worth a quick check
     during implementation — it would avoid DOM parsing entirely if such an
     endpoint exists — but the ARIA-attribute approach above is now a
     confirmed-workable primary path either way, so this is no longer a
     blocking open question.

**4. Output schema — reuse what already exists, extend by one field.** `journal/budget/manual-checkpoints/<host>.jsonl` and `journal/budget/reset-events/<host>.jsonl` (with their READMEs) already define the exact row shapes this session built by hand for this exact data. The scraper should emit rows in that same schema (`reported_by: "playwright-usage-scraper"`), plus a new optional field capturing the temporary-boost banner's verbatim text (or null when absent) — see point 3's banner note; this is new information the manual checkpoints so far mostly lack, since kriskowal wasn't reading the banner out loud each time. Since the script runs on the host, it can also read `journal/budget/live/<host>` directly in the same invocation (no container boundary blocks a host-side read) to grab a near-simultaneous token-meter spend — a real improvement over every manually-paired checkpoint this session, which all had a few minutes of slop at best (the one row sourced from an actual page dump, ironically, has the WORST pairing confidence of the five recorded so far, because the human copy-paste round-trip took 16 minutes against a meter sample that predated it — an automated scraper reading `budget/live` itself, script-side, does not have that problem). `pairing_confidence: "high"` should be achievable on every automated run.

**5. The append should not need git or bot credentials.** Have the host script append to a **plain staging file** under the shared mount (e.g. `journal/inbound/usage-scrapes/<host>.jsonl` — pick the actual path/shape) rather than writing directly into the git-tracked checkpoint logs itself. A garden-side timer (bot identity, inside the container, plain deterministic code per the sysop/reaper/watcher pattern already used throughout `scripts/jobs/`) notices new lines and does the real CAS commit+push into `manual-checkpoints/` and `reset-events/`. This keeps the host script simple and keeps git/identity entirely on the garden side, where every other write path in this repo already lives (see `scripts/jobs/common.sh`'s `ensure_clone`/`sync_clone`/CAS-push discipline for the pattern to match on the garden-side ingest half).

**6. Placement: `scripts/` for the executable, `skills/` for the playbook, per CLAUDE.md's layout rule.** *"roles/ and skills/ hold no executables; scripts/ holds no agent-only context fragments."* The actual Playwright program (presumably Node or Python) belongs under `scripts/` — likely a new `scripts/host/` or similar top-level area since it is explicitly NOT part of the `scripts/jobs/` fleet machinery (never run by a gardener, never claims a job) — with `skills/claude-usage-dashboard-scrape/SKILL.md` as the human-facing playbook (how to bootstrap, how to run, how to read failures) per the existing skill-file convention (purpose, inputs, state, procedure, output shape, notes).

## Scope

1. Land the design doc with the above decided or explicitly left as an open question (bare to `main2` unless it carries real open questions, in which case take the open-questions-PR carve-out per `roles/designer/AGENT.md` § Operating norms — e.g. the exact bootstrap UX, or the staging-file path/shape in point 5, if either is still genuinely unsettled by the time this is drafted).
2. Scaffold the skill (`skills/claude-usage-dashboard-scrape/SKILL.md`) and the script location, even if the script itself is a follow-on build job.
3. Name the garden-side ingest counterpart (the timer/watcher that turns staged scrapes into real committed checkpoint rows) as an explicit follow-on, not silently assumed.

## References

- `journal/budget/manual-checkpoints/README.md` + `endolin-garden-ece02cb4.jsonl` / `endolin-garden2-5bcdff64.jsonl` (the schema to reuse)
- `journal/budget/reset-events/README.md` + its two host files (the sibling log, same reuse expectation)
- `journal/budget/live/<host>` (the token-meter file the host script can read directly for a same-invocation pairing)
- `design-manual-quota-calibration` and `design-reset-time-detection` (posted earlier the same day; this scraper is a *producer* feeding both of their inputs — check their state, don't duplicate their fitting/detection logic here)
- CLAUDE.md § Container guard, § Host environment (the identity/trust boundary this design must respect)
- `scripts/jobs/common.sh` (`ensure_clone`, `sync_clone`, the CAS-push retry pattern the garden-side ingest half should match)
