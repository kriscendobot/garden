Completion report:

## Job: minion-town-mcp-endo-guest-design (designer)

**Delivered:** `designs/mcp-endo-guest.md` in kriscendobot/minion.town, commit `c92a66c`, pushed directly to `main` per the repo's established design-delivery convention (direct commits, like `stripe-credits` and `account-creation-open-signup`; no PR opened, matching the project carve-out — minion.town is the bot's own repo with no roadmap-branch entry).

**What the design specifies**, grounded against the live stack (DEPLOYMENT.md Phases 1–10, the Caddy/oauth2-proxy/systemd configs, `src/auth`+`src/billing`, PR #3) and the Endo tree on `endojs/endo-but-for-bots` @ `llm` (real symbols: `makeDaemon`, `makeEndoClient`, `provideGuest`, `makeNetstringCapTP`, the pet-name grammar):

- **(a) Gate 1 — Claude validation:** the exact handshake mapped onto the stack, with the central risk named (Cognito has no DCR; Claude defaults to it) and two ordered mitigations: M1 pre-registered client + captured redirect URIs, M2 reviving the closed PR #2 `/register` bridge with a verifier-allowlist amendment. Acceptance test V1–V5 (discovery, federated connect, authorized round trip, *visible* scope denial, session/refresh continuity), evidence-required, fail-loudly-and-stop semantics.
- **(b) Gate 2 — daemon + control path:** a full `endo-daemon.service` system unit (foreground `endo run-daemon`, XDG state under `/var/lib/endo-daemon`, `ENDO_SOCK` in `RuntimeDirectory`, group-scoped socket via `UMask`, `MemoryMax`/`TasksMax` for the shared box), a `deploy-endo-daemon.sh` mirroring the SSM/presigned-S3 discipline with a pinned `llm` SHA, and the CapTP-over-UDS control path with a 7-tool `guest_*` surface behind a new `mcp/guest` scope (store-ladder invariant preserved; `guest_eval` static-policy-only).
- **(c) Gate 3 — auto-provisioning:** guests keyed on the same `iss+sub` spine, deterministic name `g-<sha256(iss+' '+sub)[:32]>` (valid per `isValidName`, no stored mapping, no IAM widening), lazy idempotent `provideGuest` on first guest-tool call (the web gate never reaches the app, so "first sign-in" hooks are a non-starter — documented), suspension via the existing account-status path, admin-only teardown.
- **(d) Impedance exercises:** seven named experiments (pipelining cliff, pending request, names-as-capabilities, error taxonomy, revocation race, restart asymmetry, meter probe), each with what it reveals; they are the empirical input to the future `@endo/mcp`.
- **(e) Deferred with seams:** metering/payment attenuation (choke-point `authorize()`, reserved `debit()` shape, single provisioning site, gateway-layer resource-ledger decision cited) and S3/EC2 storage/compute decoupling (already an active daemon design line: `daemon-database-aws.js`, `content-store-s3.js`), both explicitly future work.

The design also encodes the maintainer's direction of record (closing endo-but-for-bots#134, 2026-07-09): `@endo/gateway` + `@endo/mcp` grow organically with this deployment; guest control starts as `src/endo/` in minion.town shaped for transplant, and the garden does not pre-emptively open `@endo/mcp` jobs.

**Verification status:** design-only job; no live change made, no daemon stood up, nothing claimed as runtime-verified. Facts in the doc were verified against source (repo files, `gh pr view` on #2/#3/#134, the local endo worktree) rather than memory.

**Follow-ups (not posted; sequencing is the maintainer's/liaison's call):** the gated build chain the design defines — Gate 1 validation job first — plus five open questions for the maintainer in § 9 (canonical Claude surface, DCR-bridge acceptability, `mcp/guest` scope naming/baseline, whether `guest_eval` ships in Gate 2).

**Self-improvement:** created `journal/projects/minion-town/README.md` (journal2 `c02aeb7a7`) recording the project's static facts — direct-to-`main` delivery convention, design-doc shape, SSM deploy discipline, the "deployment layer, not a code home" directive — which previously lived only scattered in PR bodies and `context/operations/aws-bringup.md`.

Worktrees: project worktree torn down after push; job inbox drained (empty throughout).
