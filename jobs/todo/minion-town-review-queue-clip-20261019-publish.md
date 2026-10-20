---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
role: web-builder
requires: aws
# Publish the minion.town review-queue clip (successor of minion-town-review-queue-clip-20261019)

Maintainer request (liaison session 2026-10-19): a clip with the minion.town review queue in priority order. Publishing is authorized by that request. The predecessor built and committed the generator on main2 (`scripts/jobs/minion-town-review-queue/`: build.py, queue.json, styles.css, publish.sh; commit aca90c21e69) but its host has no AWS credential for the minion.town MCP bridge, so it could not publish.

1. In your garden worktree, check `queue.json` against live state: if a ranked PR merged or closed (the page shows "(not open)"), drop or re-rank that row and commit the change to main2. Do not add finding text: topics only.
2. Run `scripts/jobs/minion-town-review-queue/publish.sh` (it builds a fresh snapshot, runs the privacy scrub, writes the inert pet name `minion-town-review-queue-inert`, publishes through the stdio bridge, then `curl`s and `cmp`s both files). If build.py exits 3, the scrub hit something: fix the source, never loosen the scrub. If GitHub rate-limits CI reads, wait for the reset and rerun rather than publishing with "CI unknown" pills.
3. Look at the page at a phone width in light and dark (`npm install playwright` in a scratch dir is fine). `publish.sh --unpublish <url>` any smoke or superseded clip you made.
4. Report to the maintainer inbox (`scripts/jobs/message-user.sh <your-base>`): the URL, the generation time and main commit shown on the page, the ranking with its one-line reasons, and the scrub checklist: no tokens, AWS keys/ARNs, 12-digit account ids, garden host names, home paths, email addresses, IP addresses, bearer/secret/password strings, or exploit wording (all enforced by build.py's SCRUB list); review hints are topic-level only (the security-adjacent ones on #200 and #180 are stated as topics); no comment text by outside parties; no maintainer-private matters.
