# Encode: erights has full maintainer authority (so directives aren't re-routed)

**Maintainer directive** (kriskowal, 2026-06-30, on endo-but-for-bots PR #572):
> erights has all the authority of a maintainer.

**Context / why this matters:** a gardener routed erights' PR-review disposition
("withdraw all three and open fresh") to the maintainer inbox **for authorization**,
because closing PRs exceeds the bot's standing "comments / reactjis only" action-scope
on endo-but-for-bots — even though erights is already on `trusted-senders/allowlist`.
That routing should NOT recur: erights' directive **is** the authorization. erights is
now also on `journal2:maintainers/allowlist` (done), but that allowlist drives the
issue-inbox, not the PR-action authorization scope — so the elevation must be **encoded
in the always-read docs** the PR-handling gardeners actually consult, or the next
erights lifecycle directive gets routed again.

**Task:** encode erights-as-maintainer wherever the garden documents *who can authorize
maintainer-level / lifecycle actions* (PR-close, withdraw-and-open-fresh, design
dispositions), so a gardener treats an `erights` directive the same as a `kriskowal`
directive. Per the "put it in the role's always-read procedure doc" rule
(`feedback_encode_directive_in_always_read_procedure_doc`), add it to the docs read every
cycle — likely the journal `library/conventions.md` and/or the relevant role/skill files
(the endo-but-for-bots monitor/standing-authorization notes, the gardener/judicial trust
notes). Add `erights` alongside `kriskowal` as a maintainer-authority for lifecycle
directives; do not merely note it in one ephemeral place.

**Hard boundary to preserve in the wording:** authority ≠ credentials. erights' maintainer
authority does **not** let the bot act on **upstream endojs/endo** (it has no upstream
credentials on the bot host). Upstream endojs/endo actions (e.g. closing kriskowal-authored
endojs/endo#3226) stay with kriskowal / the boatman path. State this caveat explicitly so
the encoding can't be misread as "bot may now touch upstream."

**Land** the doc edits through the proper path (journal library edits via
`land-journal-edit.sh`; any role/skill files on `main2` via an isolated worktree off
origin/main2). Keep it short and factual.
