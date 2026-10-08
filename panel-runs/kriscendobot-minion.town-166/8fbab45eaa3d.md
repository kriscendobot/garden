---
kind: panel-run
repo: kriscendobot/minion.town
pr: 166
panel_kind: code
base_ref: d750b09b30e9bb6ff00dd13e52e56f2acfdf9b23
rounds: 1
disposition: must-fix
exit_code: 0
reviewed_head: a443478a43ccaadce22b433d96d26a56086c68b9
must_fix_total: 17
appellate_ran: false
appellate_proposals: 0
epoch:
run_id: 8fbab45eaa3d
recorded_by: endolin-garden2-5bcdff64
---

# Panel run — kriscendobot/minion.town #166 (code)

Terminal disposition: **must-fix** after **1** round(s).

## Round 1 — head `a443478a`

seat verdicts (33): archivist=pass assessor=pass benchmarker=pass breaker=comment changeset-auditor=pass corner-prober=comment coverage-auditor=comment curator=pass duality-auditor=comment engine-realist=pass fast-checker=comment gateway=comment integrator=comment locksmith=pass migrator=comment orthographer=pass packager=comment procurer=pass prover=comment pruner=comment purist=must-fix reexport-auditor=pass releaser=comment saboteur=comment scribe=comment spec-keeper=comment stylist=pass surfacer=comment thesaurus=pass transplanter=pass typist=pass warden=pass wire-watcher=must-fix
must-fix items (17):
- purist: **should-fix: the JWT decoder is written by hand even though `jose` is already a dependency.** In `deploy/probe/prod-...
- purist: **should-fix: the summary leaks unchecked server text, against the module's own rule.** Lines 29-31 say the public su...
- purist: **should-fix: two constants are copied from the gateway and kept in sync by scraping source with regex.** `ISOLATION_...
- purist: **comment-only: the WebSocket upgrade is written by hand even though `ws` is a dependency.** `websocketUpgrade` (line...
- purist: **comment-only: only one cross-origin grant header is checked.** `isolationViolations` rejects `Access-Control-Allow-...
- purist: **comment-only: a `null` JSON body produces an unhelpful failure reason.** `parseJsonBody` (line 63) returns `null` f...
- purist: **comment-only: `get` also sends POST requests.** The helper `get` (line 269) is used for POST at lines 337 and 385, ...
- wire-watcher: **should-fix: the hard-cache check parses `Cache-Control` differently from browsers.** `deploy/probe/prod-objectives....
- wire-watcher: **comment-only: `ocapn-bootstrap` is checked only for its shape.** At `prod-objectives.mjs:485-488`, the regex `^endo...
- wire-watcher: **comment-only: header text reaches the issue without escaping.** Failure reasons include header values taken from th...
- wire-watcher: Canary bytes are hashed and compared with the recorded SHA-256 *before* the ETag is trusted.
- wire-watcher: `-text` in `.gitattributes` keeps line-ending normalization from changing the committed bytes.
- wire-watcher: `redirect: "manual"` on the token POST stops the credential from following a redirect.
- wire-watcher: Repeated or extra CSP and isolation headers fail closed. I checked that the joined forms do not produce a false pass.
- wire-watcher: The JWT is decoded without verification only to report its scope. The server still enforces it.
- wire-watcher: `Sec-WebSocket-Accept` is verified against the request key.
- wire-watcher: The `issues: write` token is confined to a job that runs no third-party code. The summary reaches `gh` as an argument...
