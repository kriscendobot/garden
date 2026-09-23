All deliverables are complete. Here is my completion report.

---

## Completion report: production validation for kriscendobot/minion.town#53

**Outcome: live `@sites` weblet publish is verified end-to-end in production; the PR is mergeable/green and a conductor merge job is posted.** PR head `5d931c7`.

### Diagnosis — the production `Connection stream ended` had three distinct causes
My local reproduction against the pinned Endo daemon (`f66505034…`, built as an `ENDO_CHECKOUT`) surfaced the first; production surfaced the other two:

1. **Fully-qualified formula ids** (`2511895`). The pinned daemon's `identify` returns `<formulaNumber>:<nodeId>` (both 32-byte hex), not a bare 256-bit id; `site-registry-exo` ran it through `idToLabel`, whose hex guard rejects `:`, aborting the register worker. Fix: derive the weblet hash from the formula **number**, pin under the full id.
2. **Daemon task cap** (`aef7166`). `endo-daemon.service` `TasksMax=64`; the steady working set was ~57, so the per-publish eval worker (a Node process, ~7-10 threads) crossed the cap and was killed. Raised to 1024.
3. **Edge 404 under powers-plane containment** (`aef7166` + `5d931c7`). I discovered a **maintainer-authorized security containment** (`zz-containment-20260812.conf`) that disables the gateway powers plane — resolving a publisher powers string via `E(host).lookup()` would hand any weblet-URL holder a full `EndoHost` (RCE) as the daemon user. I did **not** touch it. Instead the publish path now captures the interned content root into `record.contentRoot` and the gateway serves it from the **content plane** (content-addressed blobs, no capability resolved — safe under containment).

### Verification
- `npm run typecheck` / `build` / `test` (270 passed, 4 `ENDO_CHECKOUT`-gated skips in CI) all green.
- The gated `@sites units 1-2` integration test now runs and passes against pinned Endo `f66505034…` (made the guest-facet caplet specifier overridable; fixed the test's owner to match production's `identityKey`). Added regression unit tests for all three fixes.
- **Prod end-to-end** (MCP machine client, Cognito `client_credentials`, scope `mcp/tools mcp/guest`): `weblet_publish` → `serving:true`; `GET https://<hash>.ocap.site/index.html` → **200 with the exact marker**; `weblet_list` contained the hash; `weblet_unpublish` → `removed:true`, list empty. Evidence recorded on #53 (issue-comment 5445036291).

### Production posture (restored safe)
`WEBLET_SITES_LIVE` unset (non-serving scaffold, healthz 200); test weblets unpublished; gateway powers-plane **containment left intact**; `endo-daemon TasksMax=1024`. All three services active.

### Follow-ups / notes
- `TasksMax=1024` is applied via a box drop-in now and is in the committed unit (lands on the next `deploy-endo-daemon`/CD run after merge).
- The gateway powers plane stays contained — a separate, maintainer-tracked security issue, out of scope here. Flipping `WEBLET_SITES_LIVE` on permanently remains a deliberate maintainer decision.
- Posted conductor job `merge-kriscendobot-minion-town-53` (no merge method named) to land the PR.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion-town-pr53-prod-validation-followup-20260827.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 423 tokens (46750372 cached reads)
- Output: 198205 tokens
- Cost: $32.04619500000001
- Wall-clock: 3127s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
