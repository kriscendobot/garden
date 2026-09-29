---
role: builder
tier: mentor
fallback-tier: minion
dispatch: automatic
issue_spine: issue-kriscendobot-garden-58
---
# minion.town: clip `/.well-known/ocapn-bootstrap` answers 404 on a live clip

----- ISSUE NOTE (copy this block VERBATIM into every follow-on job) -----
issue_spine: issue-kriscendobot-garden-58
issue_url: https://github.com/kriscendobot/garden/issues/58#issuecomment-5884135413
submitter: kriskowal
----- END ISSUE NOTE -----

Posted by `minion-town-press-20260929-054326` for the open #58 checklist item on clip-origin
`/.well-known` endpoints (https://github.com/kriscendobot/garden/issues/58).

Evidence (2026-09-29): `GET https://f45ulxdnsrpxbfu5cuc5f2ukypfobxskyq5jmsomjki4p2ekszzq.ocap.site/.well-known/ocapn-bootstrap`
returns `404 no such clip` with `Cache-Control: no-store`, so the route in
`src/endo/gateway/gateway.ts` (`app.get(OCAPN_BOOTSTRAP_PATH, …)`) IS reached. It 404s when
`configuredHostToClipId` yields nothing for the Host, the vhost record has no `directoryId`,
the directory has no `back` entry, or the lookup throws. The clip itself serves content on the same origin.

1. Root-cause which branch fires for a clip that HAS a `back` power (publish one if needed,
   via the MCP guest tools; the 2026-09-04 clip-isolation run proved powered clips bootstrap
   over the WS endpoints). Suspect first: `configuredHostToClipId` vs the `<hash>.ocap.site`
   host after the clip-isolation move (design `designs/ocap-site-clip-isolation.md`), and the gateway logs over SSM.
2. If the example clip simply has no powers and a powered clip returns its locator, that is the
   correct behavior: report it with evidence and stop (no PR).
3. If it is a defect, fix it in an isolated project worktree with a regression test
   (`test/gateway/powers-plane.test.ts` covers this path), open a DRAFT PR via
   `scripts/jobs/gardening/ensure-pr.sh` (npm: `GARDEN_YARN=npm`), and let the gauntlet stage.
   Do not hand-deploy to production.

Report the live evidence either way. Scope: `kriscendobot/minion.town` only. No identity switch, no ferry.
