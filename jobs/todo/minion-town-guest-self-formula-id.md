---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
# Build: guest self-formula-identifier reveal (OAuth → HTTPS route + home-page copy)

Feature build on `kriscendobot/minion.town`. Requested by kriskowal on issue #58
(comment 5447180549) as the prerequisite for "fetch a guest knowing their formula
identifier" over the now-open OCapN-CBOR-Noise route.

## What to build
A guest authenticated with OAuth should be able to fetch **their own** daemon
guest formula identifier:
1. **HTTPS API route** (behind the existing OAuth/oauth2-proxy gate) that returns
   the authenticated caller's own daemon guest formula id — and nothing else
   (strictly self-scoped; a guest can learn only its own id, never another's).
2. **Home-page UI**: a read-only field on the guest's home page showing that
   formula id with a **copy button**.

## Constraints / grounding
- Route must be self-scoped via the existing OAuth→daemon-guest mapping; do not
  expose any lookup of other guests' ids.
- Reuse the existing oauth2-proxy gate and the OAuth→guest mapping already wired
  for the MCP surface. See `designs/weblet-ocap-synthesis.md`,
  `designs/mcp-oauth.md`, `src/endo/guest-control.ts`.
- Standard build → gauntlet; this arc has a maintainer-delegated proxy reviewer
  (the `ocapn-cbor-noise-press`, comment 5445930539) with approve/merge/deploy
  authority for bot-owned repos, so a green PR advancing this goal can land.
- Once landed, close the loop: a guest can read its formula id, and a peer can
  then `enlivenSturdyRef(location, <guestFormulaId>)` over the OCapN-CBOR-Noise
  route to fetch that guest — completing the verification chain kriskowal asked
  for. Verify that final guest-fetch end to end and report it on issue #58.

----- ISSUE NOTE (copy this block VERBATIM into every follow-on job) -----
issue_spine: issue-kriscendobot-garden-58
issue_url: https://github.com/kriscendobot/garden/issues/58#issuecomment-5447180549
submitter: kriskowal
----- END ISSUE NOTE -----
