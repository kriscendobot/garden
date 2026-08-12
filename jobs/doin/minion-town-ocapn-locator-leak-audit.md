---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
role: gardener
handler-timeout: 3600

Read-only audit. Deliverable is a report. Change nothing, post nothing anywhere,
and do not touch production.

## Why this job exists

Job `deadmail-20260812T225323Z-c7db45` established that minion.town's public
`/ocapn-daemon` bootstrap is indirectly host-powerful: anyone holding a valid
Noise location/designator for that daemon can walk `getGreeter().hello()` to the
`localGateway`, enumerate the local formula index via an unbound
`followRetentionSet`, and `provide` any formula, including `make-unconfined`.

The gate on that is the Noise designator, which is computationally unguessable
and not served by Caddy. **But every OCapN address embeds the complete
location/designator in its `loc=` parameter**, and every legitimate invitation's
`locate()` includes `addresses()`. So the true audience is "everyone who has ever
held an address or invitation for this daemon, plus anywhere such a string was
ever written down."

**This job answers exactly one question, and the answer decides how urgent the
containment decision is: has a minion.town OCapN address or invitation for the
CURRENT daemon location ever been written somewhere it should not have been?**

If the answer is "only a small set of trusted people hold these", the maintainer
can let the code fix land normally. If addresses were pasted into a public issue,
a PR body, a design doc, a demo report, or a committed file, the endpoint is
effectively open and containment becomes urgent. The recent OCapN-over-Noise
milestone work involved cross-host invite/accept demos, which is exactly the
activity that produces pasted addresses in write-ups.

## Where to look

Search read-only for OCapN addresses / Noise designators / invitation strings
(`loc=` parameters, `ocapn:` URIs, base32 designators of the shape used by the
daemon location):

- `endojs/endo-but-for-bots` issues, PRs, and PR/review comment bodies,
  especially anything around the OCapN-over-Noise milestone and demo reports.
- `kriscendobot/minion.town` issues, PRs, comments, and repository contents.
- The garden's own journal (`journal2`): job reports in `jobs/tada/`, messages,
  and design docs. Demo reports are a likely home for a pasted address.
- Any committed file in the garden or the above repos containing a location or
  invitation string.
- Public design docs or published pages under the garden's GitHub Pages, if any.

First establish what the CURRENT daemon location/designator actually is (it lives
at `/data/ocapn-daemon-location.json` on the host; the peer job read it). An
address is only dangerous if it matches the current designator: if the daemon's
location has been rotated since a string was published, that string is spent.
Report matches against the current value specifically, and say clearly whether
older published strings are stale.

## Report

- Every place a current-designator address or invitation appears, with the URL or
  path, whether that surface is public or private, and when it was written.
- If nothing is exposed, say so plainly with the list of surfaces you searched,
  so the maintainer knows the negative is well-founded. State what you could NOT
  search.
- Do not quote a live address in full in your report; identify it by location and
  a truncated prefix. Do not post it anywhere.
- Message the maintainer immediately if you find a current address on a public
  surface. That converts a capability-gated exposure into an open one.

---
claim:
  host: endolin-garden-ece02cb4
  gardener: 2
  worker_kind: gardener
  tier: 
  provider: anthropic
  model: 
  claimed_at: 2026-08-12T23:04:53Z
