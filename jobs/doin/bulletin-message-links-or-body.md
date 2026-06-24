# Bulletin: link each maintainer message, or include its full body

Wear the **mentor** role. The bulletin's **"Messages to the maintainer"** section
currently shows only a one-line summary per message (id, sender, reply_to, first
line). The maintainer wants each message to be **followable**: either **provide a link
to the message** or **include the entire message body**. Adjust on `main2` (bot
identity; isolated worktree off `origin/main2`).

## Change

In `scripts/jobs/bulletin.sh` (`compute_dashboard`, the maintainer-inbox `maint`
loop), make each message actionable rather than a teaser. Implement at least one of
(prefer doing both where clean):

- **Include the full message body** inline under each entry — the bulletin renders as
  the journal's `README.md` on GitHub, so a readable, fenced or block-quoted body is
  self-contained for the maintainer. If a body is very long, you may render the full
  body but ensure Markdown-safety (no broken fences; escape as needed).
- **And/or a link** to the source message file so the maintainer can open it:
  the message lives at `inbox/maintainer/unread/<id>` on the `journal2` branch — link
  to its GitHub blob (e.g. `https://github.com/kriskowal/garden/blob/journal2/inbox/maintainer/unread/<id>`)
  or a relative path that resolves on the journal2 landing page.

Keep the entry's existing header line (id / from / reply_to). Preserve the bulletin's
idempotent change-compare and quiet-on-success behavior; reading the message bodies is
cheap. Do not break the other sections (freshness, Board, Watch set, Hosts, Recent
progress, `## Latest`).

## Redeploy

`garden-bulletin.service` is the running loop; after the change lands on `main2`,
restart it (non-blocking) so the next tick renders the maintainer messages with bodies/
links in `journal/README.md`. If you cannot restart the host service from a dispatch
worktree, flag the restart as a pending deploy step.

## Tests & verification

- With a fixture maintainer message, assert the rendered section contains either the
  full body or a working link to the message file (not just the one-line summary), and
  that a long/Markdown-containing body does not break the bulletin's rendering.
  `shellcheck`/`bash -n` clean.

## Definition of done

The bulletin's "Messages to the maintainer" section links each message and/or includes
its full body, committed and pushed to `origin/main2`, the service redeployed (or the
restart flagged), and a tick confirmed to render it. Report the SHA and a sample
rendering. If blocked, report the diagnosis and ready-to-apply content rather than
claiming completion.

Posted by the liaison on behalf of the maintainer.

---
claim:
  host: endolinbot
  gardener: 17
  claimed_at: 2026-06-24T22:47:04Z
