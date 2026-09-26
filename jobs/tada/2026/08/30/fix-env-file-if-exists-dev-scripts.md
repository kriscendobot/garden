The work is complete. Let me write the completion report.

Job **fix-env-file-if-exists-dev-scripts** complete.

## What I did

Fixed the `--env-file` ENOENT trap in `kriscendobot/minion.town` and verified the README quickstart end to end from a clean clone.

**Change (`package.json`, one file):**
- Switched all five scripts — `dev:as`, `dev:mcp`, `start`, `client`, `billing:demo` — from `--env-file=.env` to `--env-file-if-exists=.env`.
- Raised the `engines` floor deliberately from `>=20` to `>=20.12` (the true requirement of `--env-file-if-exists`; the old `>=20` floor also under-stated the pre-existing `--env-file`, which needs 20.6).

**Verification (fresh clone in an isolated scratch worktree, `npm ci`, Node v22):**
- Confirmed `tsx` forwards `--env-file-if-exists` to node: loads when the file is present; prints `… not found. Continuing without it.` and continues when absent — for `dev:as`, `dev:mcp`, `client`, and `billing:demo`.
- **Without `.env`:** `npm run dev` now boots both servers cleanly (previously died with ENOENT); MCP serves the guest tools from the in-memory host; `npm run client` completes the OAuth/PKCE flow and lists all **12 tools, matching the README exactly**.
- **With `.env` (`cp .env.example .env`):** `npm run client` output matches the README quickstart verbatim — the same 12-tool list, `guest_write_text: ✓ ✅ wrote "b5-daemon-note" (31 char(s)).`, and `guest_read_text: ✓ B5 Endo daemon durability probe`.

## Residual gap (reported, not silently patched)

Without a `.env`, the client's write/read step returns `insufficient_scope` instead of the successful write/read the README shows. This is **not** a README/output mismatch: `ACCOUNT_AUTOPROVISION` defaults to `off`, and the README's own step 1 (`cp .env.example .env`, which sets `ACCOUNT_AUTOPROVISION=on`) is the documented precondition for the demo identity to be provisioned as a guest. The `--env-file-if-exists` fix does exactly its job — the scripts no longer crash before that `cp` step — and the promised output holds under the documented `.env`-present path. No README or code edit was made to force a match.

## Deliverable

- Branch `fix/env-file-if-exists-dev-scripts` pushed to `kriscendobot/minion.town`.
- **Draft PR kriscendobot/minion.town#67** opened via `ensure-pr.sh` (carries the `garden-job` marker). As a draft fork-side PR it auto-runs the gauntlet; no further action from me.

## Follow-ups

None required. The gauntlet (clean → panel → fix-loop → un-draft) will proceed on #67 under its supervising gardener.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/fix-env-file-if-exists-dev-scripts.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 64 tokens (1857694 cached reads)
- Output: 13567 tokens
- Cost: $1.8190849999999996
- Wall-clock: 267s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
