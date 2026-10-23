---
role: gardener
requires: host=endolin-garden-ece02cb4
tier: mentor
pr: https://github.com/endojs/endo-but-for-bots/pull/1367
fallback-tier: minion
dispatch: automatic
---

# Replace PR #1367's body (host-pinned: oros PAT lacks PR write on endojs)

Gauntlet fix-2 for https://github.com/endojs/endo-but-for-bots/pull/1367 pushed its
commits (head 8b5bc8a3b7b) but could not edit the PR body from oros-studio (403
`updatePullRequest`). The integrator juror's must-fix is that the body follow the repo's
`.github/PULL_REQUEST_TEMPLATE.md`. Your only task: write the body below (between the
BODY markers, verbatim) to a file and run
`gh pr edit 1367 -R endojs/endo-but-for-bots --body-file <file>`, then confirm with
`gh pr view 1367 -R endojs/endo-but-for-bots --json body` that it starts with the
`garden-job: design-daemon-git-remotes` marker. Do not change anything else.

----- BODY -----
<!-- garden-job: design-daemon-git-remotes -->

Refs: #378
Refs: kriscendobot/minion.town#41

## Description

Adds [`designs/daemon-git-remote-capability-urls.md`](../blob/design/daemon-git-remote-capability-urls/designs/daemon-git-remote-capability-urls.md), the next mergeable slice of M3's `daemon-git-remotes` row, and reconciles the git-stack docs with what has landed. The design is a document only; no code changes.

**The slice (one implementation PR, size S):**
- `EndoHost.provideGitCapabilityCredential(petName, { capabilityUrl })` splits a minion.town git capability URL (`https://x-access-token:<token>@git.minion.town/<partition>`) in the daemon into a non-extractable `BasicCredential` and a credential-free endpoint URL.
- `provideGitClone` gains an optional `allowedDirections` (default unchanged, `['fetch', 'push']`), so an ingestion origin can be fetch-only before it is granted to a guest.
- It fixes a live leak. `normalizeGitRemoteUrl` currently rejects embedded credentials with a message that quotes the whole URL, token included, back over CapTP.
- With these changes the git half of the M3 exit criterion runs on landed substrate: an external client runs `git push` to a partition, and a daemon `GitRemote` fetches it into a `Git` whose `filesystemAt(ref)` is the Endo directory view.

**Reconciliation:**
- `daemon-git-remotes` now records #706 and the hardening since 2026-07-11 (#532, #633, #734, #929, #973, #1022, #1145, #705, #958).
- The README M3 rows split minion.town § 12's Endo follow-on into a **client** half (this stack) and a **server** half (served today by minion.town's deployed increment 1, kriscendobot/minion.town#86; moving it into the daemon needs a separate design, not filed yet). The `daemon-git-next-steps` row now records `provideGitClone` (#538) and commit identity (#706) as landed.
- README summary table, milestone rows, dependency graph, and estimate are synced, and the status totals are re-derived from the summary table (257 indexed records).

Most critical to review: § Fetch-only `provideGitClone`, § Redaction boundary, and § Implementation plan in the new design.

### Security Considerations

The design's subject is a secret: the token in a capability URL. The redaction boundary is the body of `provideGitCapabilityCredential`; the token reaches only the process-local credential material map and the git process through the landed fd-pipe askpass. Formula records, the pet-name store, errors, and any future audit entry carry only the pet name, credential kind, audience, and credential-free URL. Authority stays stated, not inferred: the host picks `allowedDirections`, the minion.town server enforces its own `read` / `readwrite` attenuation, and the new `provideGitClone` option prevents the landed fetch+push origin from being granted where only fetch was meant.

### Scaling Considerations

None. One extra host call per adopted URL; packfiles move on the HTTPS data plane, never over CapTP.

### Documentation Considerations

The implementation PR adds help text for `provideGitCapabilityCredential` and the new `provideGitClone` option, and documents restart recovery (re-supply material through `rotate`).

### Testing Considerations

The design specifies the implementation PR's tests: parser unit tests; redaction assertions on the existing embedded-credential rejections; an integration test that pushes from an independent client, fetches, reads through `filesystemAt`, and checks that guest `push()` is rejected (also after a restart) with no `git-receive-pack` request reaching the fixture; a raw-bytes scan of the daemon state directory and log for the token; and an extension of the landed fake-git argv/env/temp-file test. This PR changes Markdown only; every Mermaid block parses.

### Compatibility Considerations

Additive. `provideGitClone`'s default is unchanged; the redacted error messages keep the `/embedded credentials/` wording existing assertions match.

### Upgrade Considerations

None. Credential material stays process-local, as landed, so no persisted state changes shape.

🤖 Generated with [Claude Code](https://claude.com/claude-code)
----- END BODY -----
