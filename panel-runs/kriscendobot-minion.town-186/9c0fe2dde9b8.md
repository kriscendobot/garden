---
kind: panel-run
repo: kriscendobot/minion.town
pr: 186
panel_kind: code
provider: anthropic
base_ref: origin/main-e3ffcbb
pr_body_hash: d4004783256b33e5ad304c576ba6424b7d8b03b60f94f0a95fd32bfb57f3572e
rounds: 1
disposition: must-fix
exit_code: 0
reviewed_head: a074fe7bbb565a7cbf2700742bd08d19e7b13504
must_fix_total: 20
appellate_ran: false
appellate_proposals: 0
epoch:
run_id: 9c0fe2dde9b8
recorded_by: oros-studio-garden-ce242c49
---

# Panel run — kriscendobot/minion.town #186 (code)

Terminal disposition: **must-fix** after **1** round(s).

## Round 1 — head `a074fe7b`

seat verdicts (34): archivist=must-fix assessor=must-fix benchmarker=pass breaker=must-fix changeset-auditor=pass corner-prober=comment coverage-auditor=comment curator=comment decomplector=must-fix duality-auditor=comment engine-realist=pass fast-checker=comment gateway=comment integrator=comment locksmith=must-fix migrator=comment orthographer=pass packager=comment procurer=comment prover=must-fix pruner=must-fix purist=comment reexport-auditor=pass releaser=comment saboteur=comment scribe=comment spec-keeper=must-fix stylist=comment surfacer=comment thesaurus=pass transplanter=comment typist=pass warden=pass wire-watcher=pass
must-fix items (20):
- archivist: **must-fix**: `designs/root-canary-principal.md` § 2.6, the component table row for `root-canary-exec.mjs`, says the...
- archivist: **should-fix**: The design's Status block says "Section 6 items 1 to 5 are implemented", but § 6 item 3 is marked "*...
- archivist: **comment-only**: `designs/root-canary-principal.md` § 2.6, the paragraph still listing `auth-unavailable reason=<mi...
- archivist: **comment-only, unverifiable here**: The Status block and § 2.3 cite `designs/root-canary-reader-identity.md`. That ...
- archivist: DEPLOyMENT.md's reason strings and exit codes for `missing` (75), `unreadable`, `refused`, `mismatched` and `unreacha...
- archivist: The `ROOT_CANARY_CREDENTIAL_FILE` override and the `~/.garden-state/root-canary/credential.json` default match `root-...
- archivist: File modes 0600 and 0700 match `root-canary-common.mjs:163-193`.
- archivist: `root-canary-revoke.mjs --yes` matches the script's argument check.
- archivist: The § 2.1, § 2.4, § 2.5, § 2.8 and § 6 item 0 cross-references resolve to headings in the design.
- archivist: No banner-style comment rules were added in the code diff.
- archivist: The new JSDoc blocks in `src/` and `test/` describe the code beside them.
- assessor: **should-fix — credential tmp-file collision.** `writeCredential` in `deploy/aws/scripts/root-canary-common.mjs` (t...
- assessor: **comment-only — callback response may be truncated.** In `awaitCallback` (`root-canary-mint.mjs`), `finish(code)` ...
- assessor: **comment-only — audit failure blocks the tool.** In `src/endo/guest-tools.ts`, `run()` calls `deps.auditClaudeTool...
- assessor: **comment-only — status file after a recovered refresh.** In `root-canary-exec.mjs`, the post-run `recordedReason` ...
- assessor: `storeMintedCredential` writes the predecessors into `superseded` before revoking them. A death in between leaves the...
- assessor: `refreshRootToken` separates `refused` (HTTP 400/401 with `invalid_grant`) from `unreachable`. `reasonStatus` maps th...
- assessor: `verifyRootAccessToken` maps any `JOSEError` to `Mismatch`, and anything else (a JWKS fetch failure) to `unreachable`.
- assessor: The probe `finally` cleanup is wrapped in `attempt`, so cleanup failures cannot mask the original error. A failed cle...
- assessor: `refreshingFetch` retries a 401 once, only if the token has not already been rotated by a concurrent refresh.
