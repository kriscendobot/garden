---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
# Scholar: research Mark Miller's "relative routing"

Ingest Mark Miller's notion of **relative routing** into the cross-cutting
reference library (`journal/library/`), abstracted and derived per the scholar
conventions (erights' public-text reuse license applies: mark the derived
material as *derived from, not the original*).

## What to research

Mark Miller's concept of **relative routing** — establishing a session with a
third party by choosing the nearest, shortest, and most reliable path, rather
than a single absolute address. Capture:

- The core idea and where erights writes about it (papers, thesis, erights.org,
  public GitHub postings).
- How it maps onto **CapTP / OCapN connection hints**: a locator can carry
  multiple candidate routes and the connecting party selects the best available.
- Its relevance to the ocap-mailbox adapter (kriscendobot/minion.town): an
  email-backed synthetic guest is one route to a peer; an in-daemon
  OCapN-over-Noise session is another; relative routing is the frame for
  short-circuiting to the nearest reliable path when both exist.

## Provenance

Maintainer directive by @kriskowal on the design review of
https://github.com/kriscendobot/minion.town/pull/37 (inline comment
https://github.com/kriscendobot/minion.town/pull/37#discussion_r3781520494):
*"Please post a scholar job to research Mark Miller's notion of 'relative
routing' because this concept applies equally well to CapTP connection hints and
choosing the nearest, shortest, and most reliable path to establish a session."*

Output: a library concept/topic file under `journal/library/` with source
indexes, and (optionally) a `project:minion-town` topic note linking it to the
ocap-mailboxes design.
