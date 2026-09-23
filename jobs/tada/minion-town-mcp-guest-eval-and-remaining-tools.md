PR #57 confirmed open (draft). The job is complete.

---

## Completion report

**Job:** flesh out kriscendobot/minion.town's guest-facet MCP tool inventory (§ 5.1), priority `guest_eval` + grant-site policy.

**Opened PR:** kriscendobot/minion.town#57 (draft) — branch `feat/guest-eval-mail-verbs-ocap`, 21 files, +798/−230.

### What I found first
- The stale premise: `guest_eval` + `guest_list/remove/inbox` and an evaluator **ACL** had already landed in commit `709eafc` (B4). The parked `minion-town-mcp-b2-first-guest-tools-gauntlet` job is a gauntlet handoff for PR #17 — no conflict.
- Two mid-flight maintainer amendments **reversed the design**, and I reworked accordingly.

### What the maintainer directed (3 messages, all applied)
1. **Ocap, not ACL** — dropped the "who gets evaluator" question entirely. `evaluate` is now **baseline**; every guest facet gets the full surface uniformly; holding the facet *is* the authorization. Removed `FacetGrants`/`BASELINE_GRANTS`, `GrantPolicy`, `GuestFacetGrant` + `policy.guestFacetGrants`, `config/policy.json`'s `guestFacetGrants` entries, and the `GuestToolDeps.grants` gate.
2. **Proven round trips against a REAL daemon** — done (below).
3. **No metering/rate-limits** — none added.

### Tools shipped
- `guest_eval` (baseline, unconditional), `guest_send`, `guest_dismiss`, `guest_resolve`, `guest_adopt`, `guest_has`.
- `guest_request` **deliberately not shipped**: it can pend for minutes; a synchronous MCP tool awaiting it hangs the transport — needs the async-handle idiom (a separate design). Its underlying `resolve` mechanics are proven regardless.
- `lookup`/`define`/`form` correctly excluded (far-refs/readers, not JSON-representable).
- Fixed two real-daemon impedance issues: message numbers cross the `M.bigint()` exo guard (coerced at the socket edge) and render bigint-safe in `guest_inbox`.

### Real-daemon proof (pinned endo `f6650503`, new integration test, actual responses)
- `guest_eval("2 + 2")` → `4`
- `guest_has` → `✅ "answer" exists.` / `(no such name: "absent")`
- `guest_send("@self","hello-self")` → inbox `strings:["hello-self"]` → `guest_dismiss(0)` → inbox `[]`
- real pending request (`"need the answer"`) answered by `guest_resolve(1,"answer")` → requester promise settles
- `guest_adopt(2,"gift","adopted-gift")` → `guest_read_text` → `42`

**Tests:** 277 green (typecheck + full suite incl. all 5 real-daemon integration tests). I compiled `better-sqlite3` to run the daemon locally; the temporary endo build worktree was removed.

### Follow-ups
- PR #57 is **draft** — awaits `run the gauntlet` (panel review + un-draft), maintainer-triggered.
- `guest_request` + the async-handle idiom remains a future design.
- Open question relayed: I used self-loopback (`@self`) for mail round trips; two-distinct-guest proof is available if wanted.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/minion-town-mcp-guest-eval-and-remaining-tools.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 399 tokens (40343811 cached reads)
- Output: 127899 tokens
- Cost: $26.1904465
- Wall-clock: 1813s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
