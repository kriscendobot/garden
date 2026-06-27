# Garden bulletin

_As of 2026-06-27T05:12:25Z · updated continuously as the job board advances (garden-bulletin.service). Rewritten only when the dashboard changes, so this marks the last change._

The maintainer dashboard: what needs a human first, then the state of ongoing
autonomous work. Regenerated deterministically by scripts/jobs/bulletin.sh; the
journalist's narrative leads in the Latest section above. This page (the journal's
README.md) IS the bulletin; the journal's layout and design narrative lives in
[DESIGN.md](DESIGN.md).

## Latest

A corrective follow-up on [endo-but-for-bots#96](https://github.com/endojs/endo-but-for-bots/pull/96) landed: after a stand-down (the work had been duplicated by an already-departed gardener under `aa78d8329`), the journalist-flagged gardener found two real defects in that commit — 13 dangling references to the moved design-doc path and a prose-only Node parity claim where a code-backed test was asked for — and pushed a conflict-safe non-force fix (`3aa37bbd`), with the full compartment-mapper suite green and a PR summary plus inline replies posted. Two items want a human eye: the watchman reports **main2 on host endolinbot is WEDGED**, with tracked edits to `scripts/jobs/self-heal-run.sh` (and earlier `gardener.sh`) blocking the fast-forward, so this host will not pick up new roles/skills/scripts until the tree is cleaned; and the `cognito-mcp-metadata-bridge` build is paused on two design Open Questions (Cognito-plus-bridge vs. an MCP-native IdP, and whether to ship RFC 7591 Dynamic Client Registration), proceeding on the gardener's recommendations unless redirected. Six infra jobs remain in flight, most hardening offline/transient-connectivity classification across the job scripts.

## Parked for maintainer feedback

- [endojs/endo-but-for-bots#379](https://github.com/endojs/endo-but-for-bots/pull/379) — fix(ses): cyclic star export with renaming reexport (issue #59) - refresh for #3276 feedback (waiting 23h)
- [endojs/endo-but-for-bots#440](https://github.com/endojs/endo-but-for-bots/pull/440) — feat(daemon,cli,chat): drop @info name hub for formula-inspector design (#439) (waiting 19h)
- [endojs/endo-but-for-bots#503](https://github.com/endojs/endo-but-for-bots/pull/503) — feat(immutable-arraybuffer,pass-style): passable byte arrays (freezable TypedArray emulation + byteArray brand check) (waiting 1d)
- [endojs/endo-but-for-bots#403](https://github.com/endojs/endo-but-for-bots/pull/403) — feat(registry-capability): EndoRegistry capability + @registry special name (#358 layer 1) (waiting 2d)
- [endojs/endo-but-for-bots#58](https://github.com/endojs/endo-but-for-bots/pull/58) — feat(daemon,cli): error tracing across CapTP workers (#1879) (waiting 4d)
- [endojs/endo#3137](https://github.com/endojs/endo/pull/3137) — feat: support .ts runtime modules via erasable type syntax (waiting 11d)
- [endojs/endo-but-for-bots#182](https://github.com/endojs/endo-but-for-bots/pull/182) — test(ses): isImmutableDataProperty regression for iOS Safari fix (closes #947) (waiting 36d)
- [endojs/endo-but-for-bots#186](https://github.com/endojs/endo-but-for-bots/pull/186) — feat(eventual-send): eager-shim/lazy-main delegate ponyfill (per #175) (waiting 36d)
- [endojs/endo-but-for-bots#101](https://github.com/endojs/endo-but-for-bots/pull/101) — feat(chat): voice input via Web Speech API (waiting 36d)
- [endojs/endo-but-for-bots#266](https://github.com/endojs/endo-but-for-bots/pull/266) — design: opencode comparative analysis + gap-closing raft (endopen) (waiting 37d)

_Showing top 10 of 29 parked PRs (ranked by recency + roadmap relevance)._
## Messages to the maintainer

- `20260627T050652Z-664d4d` — from watchman, reply_to `watchman-dirty-tree` · [open message](https://github.com/kriskowal/garden/blob/journal2/inbox/maintainer/unread/20260627T050652Z-664d4d.md)

> watchman: main2 on host endolinbot is WEDGED — this host's deploy is frozen.
>
> origin/main2 has advanced to 1d94c7895f24763d49bd80d45248d7bb8e79083b but the live tree is stuck at beede51e900bf95309ed5d43baaa66b9a03bcc56: tracked working-tree changes block the fast-forward.
> Until the tree is clean this host will NOT pick up new roles/skills/scripts.
>
> Tracked changes blocking the fast-forward:
> ```
>  M scripts/jobs/gardener.sh
>  M scripts/jobs/self-heal-run.sh
> ```
>
> Verify these are not unsaved work, then clean the tree (checkout/stash) so the watchman can deploy.

- `20260627T050802Z-599fab` — from gardener:cognito-mcp-metadata-bridge, reply_to `cognito-mcp-metadata-bridge` · [open message](https://github.com/kriskowal/garden/blob/journal2/inbox/maintainer/unread/20260627T050802Z-599fab.md)

> Building job `cognito-mcp-metadata-bridge` (the Cognito↔MCP OAuth bridge for kriscendobot/minion.town). Two design Open Questions to confirm before I build (designs/mcp-oauth.md §9):
>
> **#1 — Cognito + bridge, or an MCP-native IdP (Stytch/WorkOS/Auth0/Keycloak)?**
> Recommendation: stay with Cognito + the small API Gateway + Lambda bridge. It is what the design defaults to and what this job is scoped for; the bridge is ~2 small Lambdas we own and keeps the toy on one managed AWS service with no third-party dependency. Switching IdP later is a config-only change (OAUTH_ISSUER + JWKS), so this is reversible.
>
> **#2 — Do we need RFC 7591 Dynamic Client Registration?**
> Recommendation: yes, build it, but it is the one piece truly gated on your answer. Real MCP clients (Claude, IDE integrations) still attempt DCR, and the metadata doc will advertise client_id_metadata_document_supported anyway. I will ship all three pieces — RFC 8414 metadata doc, RFC 7591 /register, RFC 8707 audience binding — with /register behind a stack toggle (default on) so you can disable DCR to "metadata + audience only" without code changes if clients turn out to be fixed/known.
>
> Plan unless you redirect: build the full bridge (metadata + /register + audience) as CDK constructs + Lambda source in infra/, cdk synth passing, local unit tests of the metadata/register handlers. Bot repo only, no live AWS. I'll proceed on these recommendations and adjust if you reply otherwise.

- `20260627T050856Z-f7b77a` — from watchman, reply_to `watchman-dirty-tree` · [open message](https://github.com/kriskowal/garden/blob/journal2/inbox/maintainer/unread/20260627T050856Z-f7b77a.md)

> watchman: main2 on host endolinbot is WEDGED — this host's deploy is frozen.
>
> origin/main2 has advanced to 9f5642360cd1b2fb6c07fdebc00b836ac460004f but the live tree is stuck at beede51e900bf95309ed5d43baaa66b9a03bcc56: tracked working-tree changes block the fast-forward.
> Until the tree is clean this host will NOT pick up new roles/skills/scripts.
>
> Tracked changes blocking the fast-forward:
> ```
>  M scripts/jobs/self-heal-run.sh
> ```
>
> Verify these are not unsaved work, then clean the tree (checkout/stash) so the watchman can deploy.

- `20260627T051104Z-4e241c` — from gardener:finish-ebfb-pr96-review-followup-20260625, reply_to `finish-ebfb-pr96-review-followup-20260625` · [open message](https://github.com/kriskowal/garden/blob/journal2/inbox/maintainer/unread/20260627T051104Z-4e241c.md)

> Heads-up on a judgment call on endo-but-for-bots #96 (kriskowal's 2026-06-25 review).
>
> I received a STAND-DOWN: my job duplicated `finish-ebfb-pr96-ts-and-design-doc`
> (gardener-63), which had already landed both asks as `aa78d8329`. I honored the
> "don't redo the work" intent, but on verifying that commit I found two real
> defects, and the superseding gardener had already departed (not in
> doin/work/tada, not on the alive list), so there was no active second writer:
>
>   1. The design-doc move left 13 references in src/ and test/ comments pointing
>      at the removed repo-root path (dangling).
>   2. The review asked for "parity confirmation with Node.js"; the landed test
>      asserted Node's classification in prose only, not a code-backed parity test
>      (the exact gap the node-parity-test skill, from kriskowal's own #379 review,
>      exists to close).
>
> I pushed a CONFLICT-SAFE non-force follow-up (`3aa37bbd`, fast-forward on top of
> `aa78d8329`) fixing the references and adding a real Node parity test pair
> (shared assertions, mirror fixture outside node_modules). Full compartment-mapper
> suite 928 passed / 12 known failures unchanged; tsc/eslint/prettier clean. Posted
> a PR summary comment and replied on both inline threads.
>
> Rationale for proceeding despite the stand-down: it was corrective (not duplicate)
> work, no active writer existed, and a non-force push cannot clobber (it degrades
> to a clean rejection). If you'd rather it had routed differently, the commit is
> trivially revertible. Flagging for visibility.


## Board
### todo (0)
(none)

### doin (6)
- `cognito-mcp-metadata-bridge` — Build the Cognito↔MCP OAuth metadata/DCR/audience bridge for minion.town
- `design-synth-and-deploy-minion-town-aws` — Design the minion.town AWS synth + live-deploy work (surface maintainer quest...
- `foreman-token-quota-backoff` — Foreman: deterministically check the weekly token quota and back off near the...
- `improve-classify-offline-as-tempfail-in-journal-fetch` — In scripts/jobs/common.sh, make journal_fetch/sync_clone distinguish a connec...
- `improve-gardener-classify-empty-output-nonzero-as-transient-requeue` — Both failed jobs (improve-classify-offline-as-tempfail-in-journal-fetch, impr...
- `improve-self-heal-treat-offline-as-clean-exit` — In scripts/jobs/self-heal-run.sh, treat the offline/transient-connectivity ca...

### tada (295)
- `finish-ebfb-pr96-review-followup-20260625` — Completion report — finish-ebfb-pr96-review-followup-20260625
- `improve-gardener-fold-report-and-rc-into-failure-capture` — Message delivered. The work is complete.
- `deadmail-20260627T050451Z-08fe7e` — Verified. Reporting.
- `finish-ebfb-pr96-ts-and-design-doc` — Completion report — finish-ebfb-pr96-ts-and-design-doc
- `pr-ebfb-96-review-followup` — Completion report — pr-ebfb-96-review-followup
- … and 290 more

## Plan queue (parked — not claimable until promoted)
### awaiting go-ahead (maintainer authorization)
- `synth-and-deploy-minion-town-aws` — _normal_ · Synth, wire custom domain, and live-deploy minion.town to AWS

### deferred (top by priority; foreman auto-promotes when idle)
- `investigate-systemd-run-vs-gardener-loops` — _normal_ · PLAN: investigate systemd-run vs. the fixed 100-gardener-loop pool → garden d...
- `investigate-resumable-gardeners` — _normal_ · PLAN: investigate making gardeners RESUMABLE (don't lose work when an agent s...
- `ingest-ocap-library-sections` — _normal_ · PLAN: scholar — ingest sources for six missing ocap library sections
- `ingest-ocap-kernel` — _normal_ · PLAN: scholar — ingest MetaMask/ocap-kernel into the library
- `formula-inspector-retention-paths-table` — _normal_ · PLAN (follow-on): add a retention-paths table to the formula inspector
- `classify-lint-endo-master` — _low_ · PLAN: classify lint errors on endo master, then post per-class fix plans
- `endojs-endo-but-for-bots-pr442-revisit-reusable-test-powers` — _low_ · Revisit: reusable file/crypto powers for the @endo/daemon-cas tests
- `endo-but-for-bots-parallel-sync-browser-design` — _low_ · Design: parallel cis/trans file-tree browser with CapTP direct-sync (Endo sho...
- `endo-but-for-bots-harden-exported-literals-followup` — _low_ · follow-up PR: harden exported function literals (evasive-transform first)

## Watch set
(none)

## Hosts
- endolinbot: 100 gardeners
