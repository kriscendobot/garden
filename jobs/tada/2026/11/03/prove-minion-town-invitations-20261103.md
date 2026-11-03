Worktree is clean and the proof commit `b5aff5eb10b` is already on main2. Nothing to commit or push. Here is the completion report.

---

## Completion report — `prove-minion-town-invitations-20261103`

### Situation (re-derivation after reaper requeue)

A prior attempt (host `endolin-garden-ece02cb4`, gardener 2, Opus 5.5 monk, claimed 06:12Z) **ran the full live proof against production**, created the two guests, and **committed its findings to `main2`** at **`b5aff5eb10b`** (~28 min before this re-run): *"docs(minion-town-mcp): record the 2026-11-03 invitation proof and root-path gap"*. That session died before emitting the completion signal, so the reaper requeued the job to this host.

I did **not** re-run the live proof. The two guests already exist, minion.town guests cannot be deleted, and the spec caps creation at two — re-running would create surplus, undeletable guests in violation of the spec. The durable deliverable is already on `main2`; this report reconstructs the result from that committed evidence (which carries run-only specifics: exact error codes and idempotency behavior that could only come from actually executing the calls). No code changed, no guests modified, no PRs opened, no clips published. My worktree is clean.

### PASS/FAIL per step

| # | Step | Verdict | Evidence |
|---|------|---------|----------|
| 1 | Create two fresh guests A, B — `POST /api/guest` body `{}` → `201` with `formulaIdentifier`, `contacts`, `messages` | **PASS** | Two fresh guests created; bearer identifiers treated as passwords (never logged/committed). |
| 2 | A mints local invitation `POST /api/guest/invitations` `{petName, kind:"local"}`; B accepts `POST /api/guest/invitations/accept`; each side's contacts show the other under chosen pet names | **PASS** | "invite, accept, contacts on both sides … all worked between two fresh guests." |
| 3 | Exchange mail both ways `POST /api/guest/mail` `{to, message}`; verify delivery each side | **PASS** | "mail both ways all worked." |
| 4 | Acceptor receives a correspondent **handle only**, never the inviter's powers | **PASS** | Accept binds a correspondent handle under a chosen pet name; the observable guest API exposes only contacts + mail — no directory, `sites`, or other guest powers crossed. |
| 5 | Root/owner invitation path (UI + MCP) — document route or gap | **DOCUMENTED (gap)** | Root subject (`ENDO_CLAUDE_ROOT_SUBJECTS`) acts through its **MCP guest**, which has **no `invite`/`accept` tool** (both reserved in `src/endo/mcp-tool-names.ts`). A browser guest **can** invite from Settings, but it is a **different guest** from the root's MCP guest; the `legacy-root` migration that would join them is **not built**. |
| 6 | Remote invitations — record current behavior, no fix | **DOCUMENTED (unchanged)** | `kind:"remote"` returns an `endo://` locator with **no connection hints** (account daemon has only the `loop` network), so it cannot be dialed from elsewhere. No fix attempted. |

### Request shapes used (secrets redacted)

All against `https://minion.town`, `Authorization: Bearer <formulaIdentifier>` (redacted) except creation:
- `POST /api/guest` — `{}`
- `POST /api/guest/invitations` — `{"petName":"<redacted>","kind":"local"}`
- `POST /api/guest/invitations/accept` — `{"invitation":"<redacted link/id>","petName":"<redacted>"}`
- `POST /api/guest/mail` — `{"to":"<petName>","message":"<text>"}`
- (observed) `DELETE /api/guest` — `{"confirm":"<typed confirmation>"}` exists and is irreversible (checked, not exercised on these guests)

Observed edge behaviors: a spent invitation → `404 invitation-unavailable`; re-accept by the same acceptor is **idempotent**; pending invitations live only in the serving process's **memory** (`invitations` map in `guest-web-router.ts`), so a restart/deploy voids every unredeemed link; mail to an unknown name → `503 guest service unavailable` (not a 4xx). The invitation identifier in the link is itself a bearer secret until redeemed.

### Gap list — ranked by what blocks "root invites, others accept"

1. **BLOCKER — the root's MCP guest cannot invite at all.** `invite`/`accept` are reserved (unimplemented) in the MCP tool set, so the maintainer acting through the MCP/root-subject identity has no way to mint an invitation. This is the top blocker for the maintainer's stated goal.
2. **BLOCKER — browser-root ≠ MCP-root.** The browser guest that *can* invite from Settings is a distinct guest from the root's MCP guest. The `legacy-root` migration to unify them is not built, so even the working UI invite isn't issued by "the root" in the MCP/root-subject sense.
3. **Cross-daemon invitations are undialable.** Remote invitations carry no connection hints, so only same-process (local) invitations work; any invitation spanning daemons/nodes cannot be dialed.
4. **Pending invitations are process-memory-only.** A restart or deploy voids every unredeemed link — operationally fragile for any invite that isn't accepted immediately.

**Bottom line:** anonymous guest-to-guest local invitations (invite → accept → mutual contacts → mail both ways) are **proven working end to end on production**. The maintainer's goal — *the root user extends invitations and others accept* — is **blocked**: the root's MCP guest has no invite/accept route, and the only working invite path (browser Settings) is owned by a different guest than the root, with no migration to join them.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/prove-minion-town-invitations-20261103.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 2 on 2 host(s)
- Input: 62 tokens (2072703 cached reads)
- Output: 23574 tokens
- Cost: $2.387939
- Wall-clock: 413s
- Model(s): claude-opus-5-5 ×1, claude-opus-4-8 ×1

<!-- garden-usage-end -->
