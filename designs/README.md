# Garden designs

Meta-designs for the garden itself: architectural proposals for how the garden's roles, skills, journal, and host infrastructure should evolve. Each design is one Markdown file in this directory, named after the design's short slug.

Project-specific designs (e.g. for `endojs/endo-but-for-bots`) do not live here; they live under that project's upstream repo (typically `designs/<slug>.md` on a roadmap branch like `llm`). The garden's own infrastructure is the subject of this directory.

## Convention

Each design carries a metadata table at the top:

| Created | YYYY-MM-DD |
| Author  | <role-or-name> |
| Status  | Proposed \| Accepted \| Implemented \| Withdrawn |

Status semantics:

- **Proposed**: the design has a PR open against the garden and is under maintainer review. The PR is the discussion venue.
- **Accepted**: the maintainer has approved the design; implementation is in flight or queued. The merged design document is the canonical statement of the agreed approach.
- **Implemented**: the roles / skills / scripts described by the design exist on `main` and are in active use. The design document remains as historical context.
- **Withdrawn**: the design was opened but not adopted. The document remains as the record of what was considered and why it was not pursued.

## PR-against-garden exception

The garden's `CLAUDE.md` § Conventions states that the garden does not generally open pull requests against itself. Garden designs are the deliberate exception: a substantial architectural change is opened as a PR so the maintainer can review and comment in GitHub's PR interface, rather than landing directly on `main`. Smaller changes (single role edits, skill additions, notes-from-the-field rows) continue to land directly on `main` per the existing convention.

## Index

| Design | Status | Summary |
| --- | --- | --- |
| [multibot-leader-follower.md](multibot-leader-follower.md) | Implemented | Gardeners run on every host; singletons run only on the leader host named by the journal `leader` marker, via the `GARDEN` knob and the `is-main-host` predicate. |
| [gardener-bid-accept-market.md](gardener-bid-accept-market.md) | Proposed | Generalize the straight claim-race into a bid/accept market: gardeners differentiated by role and model, bid on jobs; a pluggable broker awards; a per-kind reputation ledger and the AMiX objective/subjective acceptance oracle feed selection. Race stays the default; market is opt-in, shadow-first, permanently dual-mode. |
| [gardener-reputation-bootstrapping.md](gardener-reputation-bootstrapping.md) | Proposed | Companion to the bid/accept market: effectiveness is the acceptance gate, cost is the free variable (notional dollars and duration, unified as cost per accepted job). Bootstrap reputation from journal `todo`/`tada` history plus synthetic replay; explore/exploit via Thompson sampling over per-arm cost posteriors; a reputation-driven role refiner mints fresh-prior bidders, bounded by a cap plus a consolidator (hierarchy as the follow-on). |
| [bot-email-dedicated-domain.md](bot-email-dedicated-domain.md) | Proposed | Counter-plan to FastMail masking: run bot email on a dedicated domain (`minion.town`) the bot fully controls. Compares AWS SES, Hetzner self-hosted, Cloudflare Email Routing, ImprovMX/ForwardEmail/Migadu, and Postmark/Mailgun on inbound/read-path/catch-all/outbound/deliverability/cost/ops for a receive-mostly bot. Recommends Cloudflare Email Routing (free catch-all inbound + Email Workers) with a managed sender deferred for rare outbound; carries the ToS/abuse and identity-blast-radius caveats. |
| [review-retrospective-loop.md](review-retrospective-loop.md) | Proposed | The double loop: every substantive PR comment also indicts the review process. The comment-watcher mints a second, deferred `-retro` job (deterministic verb-class gate, no LLM); a `prosecutor` role discriminates real review misses from new direction, records them with grounds in a journal `review-misses/` store, clusters them by a failure taxonomy mapped to juror seats, and past a floored subjective threshold dispatches a dual-goal `review-improve-*` job: prevent the error at the producing role AND make the panel catch it next time (seat-brief line plus panel-hints probe, or a deterministic gate). |
| [streamlined-onboarding.md](streamlined-onboarding.md) | Proposed | Collapse onboarding to clone → `./garden` → "help": the launcher auto-builds, seeds `.claude/settings.json` (SessionStart container-guard hook) like `.garden`, and execs an interactive `claude --dangerously-skip-permissions` liaison on enter (`./garden shell` is the escape hatch; CMD stays systemd). A first-class `help` verb drives an ask-before-acting first-run tutorial whose script *is* the new on-demand `context/` tree on `main2` (`first-run/` + `operations/`, context-library discipline), and a migration map moves the operational command detail out of README.md and CLAUDE.md § Job system into it. |
| [transcript-journal-capture.md](transcript-journal-capture.md) | Proposed | Durable fleet transcript archive plus fleet-wide deletion disable: every host spools finished session transcripts (a completion hook in `gardener-claude.sh` before its transcript `rm`, plus an hourly every-host `garden-transcript-capture` sweep of idle sessions), gzips and lightly redacts them, and CAS-pushes them to a dedicated `transcripts2` orphan branch on a configurable transcripts remote (`config/transcripts-remote`, inert until armed; a private repo is recommended because the origin is public). The same tick idempotently reconciles `cleanupPeriodDays: 36500` into `~/.claude/settings.json`, which the `garden` launcher also seeds for new instances. |
