The comment posted cleanly. The job is complete.

## Completion report

**Directive** (PR #51 comment `5384220646`, kriskowal): validate on minion.town that we can publish and then update a weblet's content and powers via a sequence of `git push` + evaluation tool calls — explicitly *not* the `weblet_publish`/`weblet_upgrade` tool calls.

**Preflight:** exit 2 (hint only); the sole correlated "resolution" was the bot's own "On it" ack — proceeded with the work.

**What I found (the deliverable is evidence, not a demo):** PR #51 was merged (`5e88fe6`) and CD-deployed at ~04:35Z today, so the `@sites`/front-back redesign is live. But the requested primitive-level live sequence **cannot be produced against the deployed code**, because #51 ships an in-process scaffold, not a daemon-backed runtime. I triple-confirmed this:
- **Design self-inconsistency + code:** `src/http.ts` builds the registry in-memory with placeholder `formulaId="5".repeat(64)` ("the live service replaces this…"); `createDirectory` mints `makeMemorySiteDirectory(randomBytes(32))`, not a real Endo formula; minion-mcp and endo-gateway hold separate registries that never connect; the gateway reads via `E(host).lookup("sites").directory(id)` against a daemon capability nothing creates.
- **Live box (read-only via SSM):** daemon top-host `endo list` has no `sites`/`@sites`; `E(HOST).lookup("sites")` errors; a provisioned guest has no `sites` power in scope; the powers plane is still contained (`zz-containment-20260812.conf` unsets `GATEWAY_ENDO_SOCK`).
- **The security win is real and verified:** #51 deletes the top-host caller-string resolver (`powers-source.ts` 174→12 lines), drops the `powers` string field, makes legacy records unservable, and serves the introduced directory's `back`; the only residual host lookup is the fixed name `"sites"`. Re-arming would be fail-closed-safe — but wouldn't produce a served weblet without the missing runtime, so I did **not** re-arm anything.

**Actions taken:**
- Posted an evidence-backed reply to the maintainer on PR #51 (`#issuecomment-5384264359`), correlated to the feedback with `<!-- garden-reply:5384220646 -->`, laying out the security win, the three concrete gaps with live evidence, the exact missing piece (design §9 units 1–2: a real daemon-hosted `@sites` exo + real Endo directory minting shared across the two processes), and an offer to post the follow-on build on his say-so.
- Only read-only probes on the box (no mutations, no secrets read, powers plane left contained).
- Recorded the finding in the `minion-town-deployed-topology` memory.
- Cleaned up the temporary read-only project worktree.

**Follow-ups (not yet posted — awaiting maintainer go):** a builder job for the daemon-hosted `@sites` registry exo + real directory minting, after which the git-push + `endo eval` publish→update-content→update-powers sequence becomes demonstrable with edge verification.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr51-776f7ed7.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 91 tokens (4149315 cached reads)
- Output: 43876 tokens
- Cost: $5.92846125
- Wall-clock: 740s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
