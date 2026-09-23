The job is complete.

## Completion report

**Job intent** (dead-lettered from `issue-kriscendobot-garden-58`, which had already completed): kriskowal left a sitrep comment on kriscendobot/garden#58 asking for **a plan to close the remaining gaps** so he can self-publish a `*.ocap.site` weblet from a **local `endo` CLI** — content from a directory plus a set of powers the static site reaches over WebSocket/OCapN — packaged as a demo directory in the minion.town repo, using an invite/accept (or guest-locator) workflow with an authenticated minion.town user.

**What I did:**
- Read the full #58 thread and reconciled it against my deployed-topology memory.
- Grounded the plan in the actual `kriscendobot/minion.town` tree (read-only clone): confirmed publish is **MCP-only today** (`weblet_publish` in `src/endo/guest-tools.ts` → `src/endo/gateway/publish.ts`), the daemon already has an `invite`/`provideGuest` primitive (`src/endo/root-control.ts`), powers-in-caller's-own-guest-facet is **PR #33 (still OPEN)**, and the OCapN edge codecs exist but `ocapn-cbor/-syrup` policy-close pending an `@endo/ocapn` pin while `endo-captp` is armed/verified.
- Posted a structured plan comment carrying the intent forward: https://github.com/kriscendobot/garden/issues/58#issuecomment-5247420596

**Plan shape delivered:** the serving half (weblet → powers over WS/OCapN) is already live; the gap is an **OCapN-native publish front door** onto the same `publish.ts` mechanism. Six ordered gaps — (1) an OCapN-reachable `publishWeblet` guest facet with store-write grant, (2) an authenticated-user invitation-minting workflow, (3) opening the OCapN guest-session transport (endo-captp now vs `@endo/ocapn` pin-and-open), (4) landing #33 for powers-as-pet-name in the caller's own facet, (5) content-from-a-local-dir over CapTP args, (6) owner/account binding + stubbed charge — plus the `demo/ocap-site-weblet/` directory contents and workstation runbook, a critical-path sequencing, and three decisions for the maintainer.

**Verified:** comment authored as `kriscendobot`; issue #58 remains **OPEN** (I did not close it); inbox drained empty.

**Follow-ups (maintainer-gated):** on his go-ahead, turn this into `designs/local-endo-weblet-publish.md` + an orchestrated build chain against `kriscendobot/minion.town` ending with the demo directory as the acceptance artifact. No code was changed and no build was posted — the ask was to describe a plan.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/deadmail-issue-comment-5247362179.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 24 tokens (805735 cached reads)
- Output: 21598 tokens
- Cost: $1.6358505
- Wall-clock: 334s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
