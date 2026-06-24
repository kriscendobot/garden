# Build a GitHub-wide @kriscendobot mention watcher, gated on a verified-trusted sender

Wear the **mentor** role. Build a new service that watches GitHub **generally** for
mentions of **@kriscendobot** and passes a mention to the triager **only after
deterministically verifying the sender is a trusted contributor**. Infrastructure on
`main2` (bot identity; isolated worktree off `origin/main2`).

## Why the sender gate is the whole point (read first — security)

The monitoring-safety constraint (`CLAUDE.md` § Monitoring safety) forbids feeding
untrusted PR/comment text into `claude -p`, which is why watching is normally limited
to repos gated against untrusted contributors. This watcher watches **all of GitHub**,
so it CANNOT rely on repo-gating. Instead, **a deterministic sender-trust check is the
injection defense**: a mention is dropped unless its author is a verified trusted
contributor. The gate runs in **plain code with no LLM** and must execute **before any
mention text reaches the triager or any `claude -p`**. An untrusted sender's mention is
logged and discarded, never triaged. This is a maintainer-authorized widening of the
monitoring posture — **record the authorization in a journal `message` entry** (per the
constraint) and document the sender-gate rationale in the script header and the role.

## The service

`scripts/jobs/mention-watcher.sh` (model the watcher shape on `comment-watcher.sh`:
durable journal cursor, killswitch, quiet-on-success, verify-post-landed before
advancing the cursor). Each tick:

1. **Poll GitHub-wide for new @kriscendobot mentions** since the cursor — use the
   bot's notifications (`gh api notifications` filtered to `reason == "mention"`)
   and/or the search API (`gh api 'search/issues?q=mentions:kriscendobot+updated:>=<cursor>'`),
   whichever reliably catches issue/PR/comment mentions across repos. Resolve each hit
   to its (repo, issue/PR, comment, author-login, body, url).

2. **Sender-trust gate (deterministic, before anything else).** Pass a mention onward
   ONLY if its author is trusted:
   - **Allowlist** (seed; store as journal data, not hardcoded, so it is extensible):
     `kriskowal`, `erights`, `gibson42`, `kumavis`, `0xpatrickdev`, and **mathieu** —
     resolve "mathieu" to the actual GitHub login (likely `mhofman`, Mathieu Hofman);
     confirm and record the resolved login. OR
   - **Current contributor to endo or agoric**: verify via GitHub API — membership of
     the **`endojs`** or **`Agoric`** org (`gh api orgs/endojs/members/<login>` /
     `orgs/Agoric/members/<login>` → 204 = member), or contributor status on their
     repos. Cache results briefly to avoid rate-limit churn.
   - **Otherwise drop** the mention (log "untrusted sender <login>; dropped", do not
     triage). This is the safety property — never bypass it.
   - Note: verifying that a sender is an *Agoric contributor* is a read-only trust
     check; it does **not** mean doing work on agoric-sdk (which stays off-limits per
     the standing scope rule). Keep that distinction explicit.

3. **Pass verified mentions to the triager.** Hand the (now-trusted) mention to the
   triage path — reuse the comment-watcher's verb-mapping + reactji-acknowledge +
   `post-job.sh` pipeline, or post a triage job — so it becomes work a gardener
   claims. Reactji-acknowledge as the **bot** (use the kriscendobot token explicitly;
   the fleet's default gh identity must be the bot — see the fleet-identity hardening).

4. Advance the cursor only after a verified mention's job is confirmed landed (lost
   pushes must re-poll, never drop a trusted directive). Quiet on success.

## Units, data, tests

- `scripts/systemd/garden-mention-watcher.{service,timer}` (single instance — it is
  GitHub-wide, not per-repo), registered in `install-units.sh` (install + enable +
  summary line). Honor the killswitch.
- The allowlist lives in journal data (e.g. `trusted-senders/` or a config file) so it
  can be extended without a code change; document how to add a sender.
- Tests (deterministic stubs for the mention source + the org-membership check): a
  mention from an allowlisted sender is triaged; a mention from an org member is
  triaged; a mention from an **untrusted** sender is **dropped and never reaches the
  triage handler**; idempotent on re-poll; cursor advances only on a confirmed post.
  `shellcheck`/`bash -n` clean.

## Definition of done

`mention-watcher.sh` built with the deterministic sender-trust gate (allowlist +
endojs/Agoric membership) running before any LLM, feeding verified mentions to the
triager, the maintainer authorization recorded in the journal, units registered, the
"mathieu" login resolved, and tests proving untrusted senders are dropped — committed
and pushed to `origin/main2` (bot identity). Report the SHA, the resolved allowlist,
and the gate's drop behavior. If blocked, report the diagnosis and ready-to-apply
content rather than claiming completion.

Posted by the liaison on behalf of the maintainer.
