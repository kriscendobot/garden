---
kind: panel-run
repo: endojs/endo-but-for-bots
pr: 1412
panel_kind: code
base_ref: dc960427fe6734d96748cf68c7ccfc6455f3aeec
pr_body_hash: 27e521aa09367131bc5be829f1b778e86ac9cf0212a3a57aada58cdb330dc45b
rounds: 1
disposition: must-fix
exit_code: 0
reviewed_head: 66dc87ac5680e33eaa36bd1a5ca6a621eb2399f5
must_fix_total: 20
appellate_ran: false
appellate_proposals: 0
epoch:
run_id: 17bfabb6dc40
recorded_by: endolin-garden-ece02cb4
---

# Panel run — endojs/endo-but-for-bots #1412 (code)

Terminal disposition: **must-fix** after **1** round(s).

## Round 1 — head `66dc87ac`

seat verdicts (34): archivist=must-fix assessor=pass benchmarker=pass breaker=must-fix changeset-auditor=comment corner-prober=comment coverage-auditor=pass curator=comment decomplector=comment duality-auditor=comment engine-realist=comment fast-checker=comment gateway=comment integrator=must-fix locksmith=comment migrator=comment orthographer=pass packager=comment procurer=pass prover=pass pruner=must-fix purist=must-fix reexport-auditor=pass releaser=comment saboteur=comment scribe=comment spec-keeper=comment stylist=comment surfacer=must-fix thesaurus=pass transplanter=comment typist=comment warden=comment wire-watcher=comment
must-fix items (20):
- archivist: Decision 3 says "skills and slash commands off" but never names the flag `--disable-slash-commands`.
- archivist: Decision 3 explicitly states: "On CLI versions that have it, add `--permission-prompts none`" — this critical condi...
- archivist: The `buildCliArguments` function does not emit any `--disable-slash-commands` flag.
- archivist: The implementation does conditionally add `--permission-prompts none` when `permissionPromptsNone` is true (line 1000...
- breaker: **should-fix: cleanup is not covered by the termination race.** The `finally` blocks in `cli-backend.js` and `sdk-bac...
- breaker: The cleanups are `release` (`E(admission.release)()`), `projection.close`, and `scratch.remove`.
- breaker: `turn-guard.js` claims "no limit depends on the awaited party settling". That holds for every await in the turn body,...
- breaker: Attack: a credential broker whose `release` never resolves, or a `scratch.remove` that hangs on a wedged mount. The t...
- breaker: Fix: cap cleanup with a timer from the injected `timers`, or fire the cleanups without awaiting them as the SDK `retu...
- breaker: **should-fix: some late-arrival values have no `lateCleanup`.**
- breaker: In the CLI backend, `scratch.writeFile` has no `lateCleanup`. Termination during `writeFile` is covered by the later ...
- breaker: `stdioProjection(guest)` is assigned only after it resolves. If termination wins the race, `lateCleanup` closes it, w...
- breaker: In the SDK backend, `guest.buildMcpServer()` has no `lateCleanup`. If termination wins the race, the in-process MCP s...
- breaker: **comment-only: abort does not revoke the in-process capability (SDK backend).**
- breaker: The SDK's `mcpServers.instance` is the guest's live tool surface.
- breaker: `abortController.abort()` and `signalTerminated()` only stop awaiting. An SDK that ignores the abort, which the code ...
- breaker: The module should either say that limits do not stop tool effects, or detach or close the server instance at terminat...
- breaker: **comment-only (mitigated):**
- breaker: `errorCategory` keeps credential-quoting messages out of details. Its regex-validated `code` and `name` stop an attac...
- breaker: `checkPinnedVersion` returns `error.message`, but it runs before a credential is acquired, so there is nothing to leak.
