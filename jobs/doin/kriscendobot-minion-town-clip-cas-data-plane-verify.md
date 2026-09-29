---
role: researcher
tier: mentor
fallback-tier: minion
dispatch: automatic
issue_spine: issue-kriscendobot-garden-58
---
# minion.town: does clip content bypass CapTP via the CAS data plane?

----- ISSUE NOTE (copy this block VERBATIM into every follow-on job) -----
issue_spine: issue-kriscendobot-garden-58
issue_url: https://github.com/kriscendobot/garden/issues/58#issuecomment-5884135413
submitter: kriskowal
----- END ISSUE NOTE -----

Posted by `minion-town-press-20260929-054326`. The #58 checklist item "The weblet subdomain hosts the
content of the designated virtual file system, able to bypass CapTP via the CAS data plane, with hard cache
(E-tags)" (https://github.com/kriscendobot/garden/issues/58) is unchecked ONLY because nobody has verified
the CapTP-bypass half. ETag + `immutable` caching is already verified live (2026-09-28).

Answer, with code citations (`kriscendobot/minion.town` `src/endo/gateway/`, and the Endo daemon side in
`endojs/endo-but-for-bots` at the pinned commit) and read-only live evidence:
- On a cache miss, how does the gateway obtain clip bytes: a CapTP call into the daemon (`@sites` exo /
  readable-tree `text()`/`streamBase64()`), or a direct read of the daemon's content-addressed store on disk?
- If it goes through CapTP, what minimal change would serve content-addressed blobs straight from the CAS
  (the sha256 layout the daemon already writes), and what the integrity/authority story is.

Deliver the answer as your completion report (plus a comment on
https://github.com/kriscendobot/garden/issues/58 ONLY if it definitively checks the box or names a concrete gap).
Do not change code or production. If a build is warranted, name it as a follow-up; do not post it.
Scope: read-only. No identity switch, no ferry.

---
claim:
  host: endolin-garden-ece02cb4
  gardener: 1
  worker_kind: cleric
  tier: 
  provider: openai
  model: 
  claimed_at: 2026-09-29T09:27:45Z
