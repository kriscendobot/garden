---
kind: panel-run
repo: endojs/endo-but-for-bots
pr: 1538
panel_kind: code
provider: anthropic
base_ref: 54d3d2a682e7b17fc06beadc52370d3e41283280
pr_body_hash: 6228240b56bcdd3ab3bc7ff389c5c9719cf38e8716c5c8546d90065f888cc0b6
rounds: 1
disposition: must-fix
exit_code: 0
reviewed_head: a4898713d72c7542754aa90f9f6852f024a593f3
must_fix_total: 20
appellate_ran: false
appellate_proposals: 0
epoch:
run_id: accca0f56a74
recorded_by: endolin-garden-ece02cb4
---

# Panel run — endojs/endo-but-for-bots #1538 (code)

Terminal disposition: **must-fix** after **1** round(s).

## Round 1 — head `a4898713`

seat verdicts (34): archivist=must-fix assessor=must-fix benchmarker=comment breaker=must-fix changeset-auditor=must-fix corner-prober=must-fix coverage-auditor=must-fix curator=comment decomplector=must-fix duality-auditor=comment engine-realist=comment fast-checker=comment gateway=pass integrator=must-fix locksmith=must-fix migrator=comment orthographer=comment packager=comment procurer=pass prover=comment pruner=must-fix purist=comment reexport-auditor=pass releaser=must-fix saboteur=must-fix scribe=comment spec-keeper=comment stylist=comment surfacer=comment thesaurus=pass transplanter=comment typist=comment warden=comment wire-watcher=comment
must-fix items (20):
- archivist: **should-fix**: `packages/floot/src/system-prompt.js:529` says "a failed clone leaves the mount empty, so the same ca...
- archivist: **comment-only**: `.changeset/daemon-git-clone-bootstrap.md:21` narrows the timeout and kill fix to "over HTTPS". The...
- archivist: The `provideGitClone` signature, the `{ git, remote }` return, the origin policy keys (`gitCloneOriginKeys` in `host....
- archivist: `designs/daemon-git-next-steps.md` records Phase 2 as shipped, which supports the "has since landed" claim in `daemon...
- assessor: **should-fix** `packages/daemon/src/manager.js:8909-8930` (`removeStaleMountStagingEntries`). Every record file in `m...
- assessor: One truncated or corrupt record, for example from a crash mid-`writeFileText`, makes every later `provideGitClone` on...
- assessor: The same happens when a record is unreadable.
- assessor: The stale-cleanup pass is best-effort by design, so it should skip or forget an unparseable record rather than propag...
- assessor: The live-path check also joins the current mount's path to a record name that may belong to another mount. That is ha...
- assessor: [rule: skills/panel-review error-path handling] [proposed-rule: best-effort recovery passes must not turn one corrupt...
- assessor: **should-fix** `packages/daemon/src/manager-node-powers.js:618-626` (`renameNoReplace`, non-directory and symlink bra...
- assessor: If `lstat` or `unlink` throws after the target was created, the caller has no record of the entry now at `target`.
- assessor: In `moveMountEntries` (`manager.js:8959`) `moved.push` is skipped, so the failed-clone discard does not remove the ha...
- assessor: Source and target both exist, and the target is orphaned in the user's mount.
- assessor: The file branch also returns `sourceStat`'s identity, taken before `link`. A swap of the source between `lstat` and `...
- assessor: Suggest `lstat`-ing the target after `link` and rolling back by unlinking the target if `unlink(source)` fails.
- assessor: **comment-only** `packages/daemon/src/manager-node-powers.js:606-612`. The directory case relies on `rename` over an ...
- assessor: **comment-only** `packages/daemon/src/host.js:1957-1982`. The `catch` handler is sound:
- assessor: `staging` stays set when `moveMountEntries` throws midway, so both the partial moves and the remaining staging direct...
- assessor: The origin name is restored only if it still holds `originId`.
