---
role: designer
tier: mentor
posted_at: 2026-11-05T09:37:16Z
handler-timeout: 3600
---
<!-- garden-promoted-from-plan: gate=orchestrated priority=normal at=2026-11-05T09:40:04Z cleared=none -->

---
role: designer
handler-timeout: 3600
tier: mentor
fallback-tier: minion
dispatch: automatic
---
**Role: designer.** **Design file-based secret management for the garden, modeled on the tower's practice, so that adding, changing or removing an API key never requires rebuilding or recreating the container** (maintainer, kriskowal, 2026-11-05: "avoids needing to rebuild the container ... I would like to pursue this option in the garden"). Land as `designs/secret-management.md` on `main2` (direct, per the garden convention, unless it carries real open questions, in which case the CLAUDE.md review-PR carve-out applies). A builder job follows automatically; make the design buildable as written. Include no secret values anywhere.

**Today's problem.** The `garden` launcher (`garden`, ~lines 99-110 and 290-306) forwards `ANTHROPIC_API_KEY`, `MOONSHOT_API_KEY`, `FIREWORKS_API_KEY`, `OPENROUTER_API_KEY`, `OLLAMA_CLOUD_API_KEY` and `TYPESAFE_API_KEY` as container environment variables (`docker run -e …`), so changing a key means recreating the container, and a worker that lacks `TYPESAFE_API_KEY` silently skips every `scholar-ingest-*` job (they implicitly `require` it; `common.sh` `job_requirements`). Consumers include `scripts/jobs/common.sh`, `handlers/{monk-claude,mystic-kimi,opencode,codex-provider-common,kimi-provider-common}.sh`, `classify-foreign-content.sh`, `fetch-source.sh`, `muster-pilot.sh`, `openrouter-promo-tool-canary.sh`. The minion.town MCP token cache already reads a client secret from AWS Secrets Manager at refresh time. Survey the real set of secrets the fleet uses (env vars, `~/.codex`, `~/.claude` credentials, AWS-held secrets, per-host differences across the leader and followers).

**The tower's practice (the maintainer's note, reproduced; the tower is a fork of the garden that already works this way):**

> # How the tower manages API keys and other secrets
> 
> Liaison, 2026-11-05. A summary of the practice as it stands, drawn from `CLAUDE.md` § Privacy,
> the `set-key.sh` scripts and the wrappers. No secret values appear here.
> 
> ## The rules
> 
> 1. **One home for the tower's own secrets:** `.tower-state/secrets/`, directory mode 700, each
>    file mode 600. It is gitignored host-local state: never committed, never on the hub, never in
>    the journal.
> 2. **Kris places every key himself.** Each kind has a `set-key.sh` that reads it from the
>    terminal, unechoed (or from stdin), checks its shape, and writes it to a temporary file in the
>    secrets directory, renamed into place. Agents never type, paste or choose a key.
> 3. **Never in the environment, on a command line, in a repository or in the journal.** A wrapper
>    reads the file at the moment of the call and hands it to `curl` on its config stdin (`curl -K -`),
>    so it never appears in `ps`, shell history, logs or run captures. Keys are never printed, not
>    even in part.
> 4. **One wrapper per service, and it is the only caller.** Each wrapper allows only its own
>    endpoints, refuses without `--authorized-by`, and **ledgers every request in
>    `journal:outbound/<service>/` before sending**: method, path and body, never the key.
> 5. **Least privilege.** Where a service offers restricted keys, the tower holds the narrowest one
>    that does the job. It holds none at all where it doesn't need one.
> 6. **The egress firewall is the second lock** (when it is enforcing, which it has not been yet):
>    a service's host is reachable only while Kris has its window open.
> 
> ## Key by key
> 
> | Service | What the tower holds | Where | Placed by | Used only through |
> | --- | --- | --- | --- | --- |
> | Anthropic (Claude) | `ANTHROPIC_API_KEY` | the host's environment, forwarded into the container by `./tower` | Kris | Claude Code itself. **The one key in an environment variable**, and the only one the container forwards |
> | TypeSafe | API key | `secrets/typesafe-api-key` | Kris, `scripts/typesafe/set-key.sh` | `scripts/typesafe/systemone.sh` (foreign content only; ledger `outbound/typesafe/` records questions and input hashes, never input text) |
> | Stripe (catalog) | a **restricted** key, Products: Write and Prices: Write only (`rk_test_`/`rk_live_`; `sk_`/`pk_` refused) | `secrets/stripe-catalog-key` | Kris, `scripts/stripe/set-key.sh` | `scripts/stripe/catalog.sh` (`/v1/products`, `/v1/prices` only; ledger `outbound/stripe/`) |
> | Stripe (the shop's own keys) | **nothing**. The secret key and webhook secret live in AWS SSM Parameter Store as SecureStrings | SSM | Kris | the shop's Lambda alone. The tower may confirm one exists by name and metadata (`describe-parameters`), never `get-parameter` (and `role/tower` cannot describe them today) |
> | books wish-list pepper | **nothing**. `/books.kriskowal.com/wish/pepper` in SSM | SSM | Kris | the wish function alone |
> | OpenAI (images, Codex workers) | **no API key**. The pinned Codex CLI on Kris's ChatGPT login, its credentials in a file under `.tower-state/openai/codex-home` | Kris logs in by hand | `scripts/openai/imagegen.sh` (jailed; cannot read the tower) and `scripts/jobs/worker.sh --kind codex`; ledger `outbound/openai/` |
> | AWS | **no access keys** (no IAM users, no long-lived keys). Short sessions from `aws login`: profile `tower`/`lab` assume `role/tower`, held by a permissions boundary (`tower-boundary`); `[default]` is root, Kris's choice | `~/.aws` sessions | Kris, `aws login --profile tower --remote` | the scripts under `scripts/aws/` and `scripts/deploy/`, every mutation ledgered in `outbound/aws/`. Per-job widenings are time-boxed windows Kris opens (`aws-window.sh open …`) |
> | GitHub | **no account, no token.** A read-only deploy key for kriskowal.com | `secrets/github-deploy-kriskowal-com` | Kris | `skills/deploy-kriskowal-com`. Everything that needs a GitHub identity goes to the garden by hand |
> | Kris's Mac (`bot`) | an ssh key, the host key pinned | `secrets/mac-bot-key`, `secrets/mac-known_hosts` | Kris | `scripts/mac/` (`mac.sh`), each session ledgered in `outbound/mac/` |
> | minion.town | a guest credential | `secrets/minion-town-guest` | Kris | `scripts/minion-town/guest.sh` |
> 
> ## Loose ends I noticed while writing this
> 
> - **`secrets/doral-forge-kowbot`** has no current user that I can find: no script reads it, and it
>   appears only in a 2026-10-14 scholar study (doral-forge against minion.town). If it is not
>   needed, it should be revoked at its source and removed.
> - **`mac-bot-key.pub`** is mode 644. That's harmless, since it's a public key, but the private
>   files are all 600.
> - **`role/tower` cannot `ssm:DescribeParameters`** (the boundary denies it), so jobs that are meant
>   to confirm a key "by name only" (the books preview's test key, the live pepper) cannot. Either
>   allow `DescribeParameters` on those paths, or Kris confirms them by hand.
> - **Rotation is not scripted.** Each `set-key.sh` replaces a key in place, and `--remove` deletes
>   it, but nothing reminds anyone to rotate. Stripe and TypeSafe keys could carry a date in their
>   ledger record.

**The design should settle:**
1. A host-local secrets directory (the tower uses `.tower-state/secrets/`; here under `.garden-state/secrets/`, mode 700, files 600, gitignored, bind-mounted so the container sees changes live) and how the container reads it at the moment of use, so a key change needs no container recreation and no service restart.
2. `set-key.sh`-style placement tools (one per kind, or one with a registry): reads the key from the terminal unechoed or from stdin, checks its shape, writes temp-then-rename; `--remove`; the maintainer places every key himself and agents never type, paste or choose one.
3. A **wrapper per service** as the only caller, which reads the file at call time and hands it to the client without it appearing in `ps`, argv, env, logs, shell history or run captures; each wrapper allows only its own endpoints, refuses without an authorization argument, and **ledgers every request in the journal `outbound/<service>/` before sending** (method, path, body; never the key). Say how this applies to harness CLIs that insist on an env var (Claude Code, codex, kimi, opencode): an env-injecting launcher that reads the file at process start per job, in the child only, so a rotated key takes effect on the next job. Be honest about which keys cannot avoid being in a child's environment.
4. Fleet semantics: per-host secrets (each host's maintainer places its own; nothing in the journal or on the hub), how a job's `requires: typesafe`-style capability is satisfied by "the secret file exists and the shape check passes" instead of an env var, the host capability probe, and what a follower or an AWS host does. Keep AWS-held secrets (Secrets Manager/SSM) as-is where they are already the right home.
5. Migration from env forwarding with no flag day: the launcher keeps forwarding env keys as a fallback for one release, a command imports existing env keys into files, then drops forwarding; the order in which consumers move.
6. Least privilege, rotation (record the placement date in the ledger record; a watchdog reminder when a key is older than a configurable age), a loose-ends audit (unused keys), and the egress-lock idea as a later layer.
7. Threat model in a short section: what an agent in the container can and cannot read (a job's worktree vs the secrets directory; a prompt-injected agent), and which wrappers/paths the sandbox must deny.

Keep it short and concrete; the maintainer wants to pursue the tower's option and improve it with use.

