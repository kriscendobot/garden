---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
# Fork the Public Suffix List and open a LOCAL PR for `ocap.site` (design kriscendobot/minion.town#34)

Maintainer directive (kriskowal, kriscendobot/minion.town#34
issuecomment-5247080255): "... fork the public suffix list and create a local
PR, and notify the maintainer here and in their inbox when it is time to ferry
the PR upstream." The nameservers for `ocap.site` are updated and DNS delegation
is VERIFIED-PROPAGATED (Route53 NS resolve on Google + Cloudflare; SOA serial 1).

This is the bot-safe PREP the design explicitly permits (`designs/ocap-site-weblet-isolation.md`
§4.2: "A bot can prepare the one-line patch and run tests, but it cannot make
ownership, user-count, renewal, abuse-response, or impact attestations on the
owner's behalf"). Prepare the local PR now; the UPSTREAM ferry + owner
attestations are the maintainer's, deferred until they say go.

DO:
1. Fork `publicsuffix/list` to `kriscendobot/list` (`gh repo fork publicsuffix/list
   --org kriscendobot --clone=false` or equivalent; upstream default branch is
   `main`). Get an ISOLATED project checkout with
   `scripts/jobs/ensure-project-worktree.sh <your-base> kriscendobot/list main`
   — do NOT hand-name a checkout by repo/PR.
2. In `public_suffix_list.dat`, add a PRIVATE-section subsection sorted by the
   operator's organization/product name. Per design §4.2 the shape is exactly:
       // Minion Town : https://minion.town/
       // Submitted by Authorized Representative <security@minion.town>
       ocap.site
   The single rule is `ocap.site` (NOT `*.ocap.site`). Place it in correct
   alphabetical sort position within the PRIVATE section; the final organization
   spelling determines exact placement — re-check the file's current sort rules.
3. Run the repository's documented local test command (currently `make test`) and
   fix EVERY format, sort, and syntax failure until it passes. Capture the output
   as evidence.
4. Open a LOCAL PR on the fork (base `kriscendobot/list:main`, head your branch) —
   NOT an upstream PR to publicsuffix/list (that is the ferry, maintainer-gated).
   In the PR body, DRAFT the repository's automated submission template with the
   mechanical/factual fields filled and every OWNER ATTESTATION field (user
   count, registration-term commitment, abuse-response, ownership) clearly marked
   "[owner to complete at ferry]". Include the expected parsing results for the
   three §2.1 examples. Do NOT invent user-scale numbers or ownership attestations.
5. Note in the PR that `_psl.ocap.site TXT "https://github.com/publicsuffix/list/pull/N"`
   (design §4.2 step 5) is published only AFTER the upstream PR gets its number N
   at ferry time, from the live `ocap.site` zone — so it is out of scope for this
   local-PR prep.

THEN NOTIFY (the directive's final ask):
- Comment on kriscendobot/minion.town#34 that the PSL local PR is prepared and
  green (`make test` passing), linking the local PR, and that it is READY TO
  FERRY upstream to `publicsuffix/list` pending the owner's attestations — which
  a bot cannot make. Do NOT open or push anything to `publicsuffix/list` yourself.
- Also `message-user.sh <your-base>` the same, so it lands in the maintainer
  inbox as the directive requests.

If any step needs credentials/authority this host lacks, stop and report the gap
rather than improvising. Related: parked plan `minion-town-ocap-site-build-deploy`
(zone/deploy/validate units), live build peer
`fu-minion-town-design-ocap-site-weblet-isolation-ed888d3-1`.

---
claim:
  host: endolin-garden-ece02cb4
  gardener: 1
  worker_kind: cleric
  tier: 
  provider: openai
  model: 
  claimed_at: 2026-08-10T23:21:44Z
