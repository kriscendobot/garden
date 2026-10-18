---
kind: panel-run
repo: endojs/endo-but-for-bots
pr: 764
panel_kind: code
provider: anthropic
base_ref: origin/master-2708cac
pr_body_hash: bfa4f7949f08c88b43b9599a7631077cc3d229578ae95af479629204d22b3fe2
rounds: 1
disposition: must-fix
exit_code: 0
reviewed_head: 02b806d2f492844f2b1b59bfff506fb2f756dff5
must_fix_total: 20
appellate_ran: false
appellate_proposals: 0
epoch:
run_id: af7f6b1dca52
recorded_by: oros-studio-garden-ce242c49
---

# Panel run — endojs/endo-but-for-bots #764 (code)

Terminal disposition: **must-fix** after **1** round(s).

## Round 1 — head `02b806d2`

seat verdicts (33): archivist=pass assessor=pass benchmarker=pass breaker=must-fix changeset-auditor=must-fix corner-prober=comment coverage-auditor=comment curator=comment duality-auditor=pass engine-realist=comment fast-checker=pass gateway=pass integrator=must-fix locksmith=pass migrator=comment orthographer=pass packager=must-fix procurer=pass prover=must-fix pruner=must-fix purist=comment reexport-auditor=pass releaser=pass saboteur=comment scribe=comment spec-keeper=comment stylist=comment surfacer=pass thesaurus=pass transplanter=pass typist=pass warden=comment wire-watcher=comment
must-fix items (20):
- breaker: **must-fix: `node-powers.js` still reads `URL` from the global scope.** The file now captures `Function` and `Promise...
- breaker: **should-fix: other compartment-mapper modules still resolve locations with the global `URL`.** These are `url.js:42-...
- breaker: **should-fix: the patched files still look up some globals at call time.** In `import-hook.js`, `new Map(...)` (lines...
- breaker: **comment-only: capturing the constructor does not protect its methods.** `Promise.resolve(undefined)` (`node-powers....
- breaker: **comment-only, out of scope:** the capture only defends against mutation that happens after this module is evaluated...
- breaker: **should-fix: no test covers the claim.** Add one: import the module, replace `globalThis.URL` / `Set` / `Proxy`, run...
- changeset-auditor: **Missing changeset for a published package.** The diff changes runtime source in three files of `@endo/compartment-m...
- changeset-auditor: Proposed fix: add a bundled changeset with front matter `'@endo/compartment-mapper': patch`.
- changeset-auditor: Patch is the right level because the change preserves behavior and adds no public surface.
- changeset-auditor: The body should be sentence-per-line with no process commentary. For example: "Cache `URL`, `Function`, `Promise`, `P...
- changeset-auditor: The body should name only identifiers the diff actually touches.
- changeset-auditor: [rule: skills/changeset-discipline/SKILL.md § Presence / Bundling]
- changeset-auditor: Disposition: summary-fix. The semver risk is low, so this does not need `must-fix-loop`.
- changeset-auditor: **Style:** there is no changeset body to audit for sentence-per-line or stale draft language yet. Re-check once findi...
- integrator: **must-fix: the PR body does not follow the template.** The deterministic pre-pass found these problems in the body, ...
- integrator: These seven template headings are missing: *Description*, *Security Considerations*, *Scaling Considerations*, *Docum...
- integrator: The body uses two headings the template does not have: "What it does" and "Note".
- integrator: **should-fix: the title promises more hardening than the diff delivers** (overlap: archivist). The title and commit m...
- integrator: In the same package, `node-modules.js`, `search.js` and `url.js` still call bare `new URL(`.
- integrator: `import-hook.js` caches `URL` but still uses bare `Map`/`Set`/`Error` at lines 200, 602–614, 781–790 and 857.
