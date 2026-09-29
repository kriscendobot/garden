## Completion report: `design-daemon-git-remotes`

I wrote the design for the next `daemon-git-remotes` slice and opened it as draft PR **endojs/endo-but-for-bots#1367** (`design/daemon-git-remote-capability-urls`, frozen base `llm-1aba3ca`). The design slug is `daemon-git-remote-capability-urls`.

### What the design proposes
The next slice is one small implementation PR (about 1–2 days):
- **New host method `EndoHost.provideGitCapabilityCredential(petName, { capabilityUrl })`.** It takes a minion.town git capability URL (`https://x-access-token:<token>@git.minion.town/<partition>`) and splits it inside the daemon into two parts:
  - a `BasicCredential` whose token can't be read back out;
  - the same URL with the token removed.
  
  The existing `provideGitRemote` and `provideGitClone` then work unchanged.
- **A fix for a token leak in the existing code.** When a URL carries embedded credentials, `normalizeGitRemoteUrl` in `@endo/exo-git` rejects it with an error that quotes the whole URL, token included. That error goes back to the caller over CapTP. The fix removes the credentials from the message.
- **What it enables:** an outside client runs `git push` to a minion.town partition, and a daemon `GitRemote` fetches it. `git.filesystemAt(ref)` then shows the pushed files as an Endo directory. Everything else that path needs has already landed.

### How it reconciles the landed work with the minion.town remote
- **What has landed:** Phases 1–5 (#365), the askpass credential pipe (#368), `provideGitClone` (#538) and commit identity (#706). Hardening since the July review is #532 through #1145, plus #705 and #958. Phases 6–7 are still open, and issue #378 tracks follow-ups on the existing code.
- **Correction to the README:** the M3 rows said minion.town § 12's Endo follow-on "is the git trio". That is only half of it, and the rows now say so.
  - **Client half** (a daemon agent fetching from or pushing to a partition): this stack, plus the new slice.
  - **Server half** (creating partitions, minting and revoking capability URLs, storing git objects in the content store): runs today in minion.town's deployed increment 1 (#86, `git.minion.town`). Moving it into the daemon needs a separate design, which nobody has filed yet.
- The design includes an ownership map covering the host caller, daemon, minion.town server and guest.
- A URL doesn't say whether its token is read or read-write. So the host states the allowed directions itself, and the server still enforces its own limits.

### What changed
- **New:** `designs/daemon-git-remote-capability-urls.md`, status Proposed.
- **Updated:** `designs/daemon-git-remotes.md`, with a new updated date, status pointer, implementation-plan note and the list of what has shipped.
- **Updated:** `designs/README.md`: the summary table, recent-additions list, dependency graph, M3 milestone row, the corrected § 12 statement, the estimate row and the totals note. Totals are now 24 Proposed and 241 records.
- Both Mermaid files parsed cleanly: the new sequence diagram and the full README graph. Prettier also passes on the new file.

### Open questions for the maintainer
1. Should a capability-URL credential only work with its exact URL? Today it works with any URL on the same host.
2. Should git capability URLs join the `#v=1` locator family from #1360?
3. Should `provideGitClone` and `provideGitRemote` also accept `{ capabilityUrl }` directly?
4. Credentials are held only in process memory, so a daemon restart loses the token. Who keeps the show-once URL until the credential bank lands?

### Follow-ups
- The implementation build job for this slice, after review.
- A daemon-side server-half design, not filed yet.

The PR is left as a draft so the design-panel review can be recorded automatically.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/design-daemon-git-remotes.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 88 tokens (5141539 cached reads)
- Output: 28955 tokens
- Cost: $2.7902878
- Wall-clock: 358s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
