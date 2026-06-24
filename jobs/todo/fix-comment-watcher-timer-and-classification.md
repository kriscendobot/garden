# Make the comment-watcher actually fire, and catch plain-language maintainer directives

Wear the **mentor** role. The comment-watcher (`garden-comment-watcher@endojs-endo-but-for-bots`)
was armed today but **two bugs** mean it never reacts. Fix both. Infrastructure on
`main2` (bot identity; isolated worktree off `origin/main2`). You have passwordless
sudo for systemd debugging.

## Bug 1 — the systemd timer never triggers the service

Observed: the timer is `active` with `OnActiveSec=90s`/`OnUnitActiveSec=90s` and
`ActiveEnterTimestamp` set, but `LastTriggerUSec=` is **empty**, the service's
`ExecMainExitTimestamp` is empty, and `journalctl --user -u
garden-comment-watcher@endojs-endo-but-for-bots.service` shows **`-- No entries --`**:
the service has **never run**. The script itself is fine — running
`scripts/jobs/comment-watcher.sh endojs-endo-but-for-bots` by hand works. A
`daemon-reload` + `systemctl --user restart …​.timer` did **not** fix it.

Diagnose why an active `OnActiveSec` timer never fires its `@`-instance service and
fix it durably. Likely suspects to check: the `@.timer`/`@.service` template binding
(does the timer correctly trigger the same-named `@%i.service`? is an explicit
`Unit=` needed?), whether `install-units.sh` installs+`daemon-reload`s the templates
before `enable --now`, persistent/monotonic timer state, and whether the instance
service is `WantedBy`/enabled correctly. Confirm the fix by observing the service
actually run on the timer (a fresh `journalctl` entry and `LastTriggerUSec` advancing)
**without** a manual start. Apply the same fix to the commit-`triager@` timer if it
shares the defect.

## Bug 2 — plain-language maintainer directives are dropped

`comment-watcher.sh`'s `classify()` only acts on a verb
(rebase/retcon/refresh/shepherd/gauntlet), an explicit `@kriscendobot` mention, or a
`CHANGES_REQUESTED` review body. A maintainer comment like **"Please apply this
feedback"** / **"Please finish this"** with **no @-mention and no verb** returns
"none" and is **dropped** — exactly what happened on PR #503
(`issuecomment-4794208524`, kriskowal, "Please apply this feedback").

Fix: a comment **from a trusted maintainer/contributor** (kriskowal and the
endojs/Agoric allowlist used by the mention-watcher) on a watched PR that **reads as
a directive** (imperative "please …", "address …", "apply …", "finish …", etc.) must
be treated as **actionable → fall back to the `claude` triager** (the existing
ambiguous-path that wears the triager role and decides the job), not dropped. Keep the
deterministic verb table as the fast path; widen only the *who-plus-imperative* case,
and do **not** make every chatty comment actionable (require both trusted sender and
an imperative directive). Preserve the monitoring-safety posture (only watched/safe
repos; sender trust is already the gate).

## Tests & verification

- Bug 1: an integration check that the timer triggers the service on schedule.
- Bug 2: a maintainer "please apply this feedback" comment (no @-mention, no verb)
  from a trusted sender → routed to the triager fallback and a job posted; the same
  comment from an untrusted sender → still dropped; a non-directive comment → dropped.
- `shellcheck`/`bash -n` clean.

## Definition of done

The comment-watcher fires on its timer autonomously (verified by journal logs), and
catches trusted-sender plain-language directives via the triager fallback; committed
and pushed to `origin/main2`, redeployed/restarted. Report the SHA, the timer
root-cause + fix, and the classification change. If blocked, report the diagnosis and
ready-to-apply change rather than claiming completion.

Posted by the liaison on behalf of the maintainer.
