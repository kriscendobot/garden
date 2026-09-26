The follow-up job is confirmed live in `journal/jobs/todo/`, claimable by any gardener.

## Completion report

**Job:** attention directive on `endojs/endo-but-for-bots#1094` (kriskowal, comment `5473318493`).

**Directive (untrusted comment, treated as data):** "post a follow-up job to upgrade vite to the latest major, including a read through the release notes for major breaking changes that require migrations and the corresponding build out."

**Route:** attention → post one follow-up build job.

### Corroboration of preflight exit 2 (HINT)
- The correlated text the preflight found is the feedback comment itself plus the two closed-PR botanist reviews (`endojs-endo-but-for-bots-pr1094-dependabot`, `botany-ebfb-pr273`) — none of which is the requested board artifact.
- Board swept (`journal/jobs/{plan,todo,doin,tada}/`): no vite-upgrade job existed (earlier grep hits were "invite" false positives). The single ask is a **board artifact** and it was unmet → treated exit 2 as PROCEED.

### Context established (verified 2026-08-31)
- PR #1094 was a Dependabot `@vitejs/plugin-react` 4.7.0→6.1.0 bump, **REJECTED/closed** by the botanist because plugin-react 6.x needs peer `vite: ^8.0.0` exclusively, but `@endo/chat` pins `vite: ^6.0.0` (resolves 6.4.2).
- Latest Vite = **8.2.2** (`previous` 7.3.6) — so the upgrade crosses **two majors (6→7→8)**, each with its own migration guide.

### What I did
- Posted builder job **`endo-chat-vite-major-upgrade`** to the board (now in `journal/jobs/todo/`), with a body naming the repo/branch (`endojs/endo-but-for-bots` @ `llm`), the target package (`packages/chat`), the current pins, both migration guides to read (6→7 and 7→8), concrete migration scope (config, plugin peers, yarn-lock separate commit, Node-baseline reconciliation), and the source directive URL for provenance.
- First post deduped (my body cited comment `5473318493`, which *this* job already owns as its directive identity); re-posted with explicit `--identity endo-chat-vite-major-upgrade` so it minted as a distinct job. Verified present in `todo/`.

### Follow-ups
- The new builder job carries the substance (release-note reading + migration build-out); its draft PR auto-runs the gauntlet. It flags the Node-support-window question (Vite 7 drops Node 18) for maintainer decision rather than silently narrowing support.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1094-a93260ad.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 22 tokens (470145 cached reads)
- Output: 7591 tokens
- Cost: $0.8426175
- Wall-clock: 170s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
