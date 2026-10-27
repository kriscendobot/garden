I folded all seven of the maintainer's answers into the #1543 design, removed the Open questions section, and pushed. The new head of `design/claude-api-key-agents` is `069b429c169f2bc6bdfbfde73c6cab325b6c0203`. CI passed on it; I did not re-run the review panel.

**Where each answer went** (in `designs/api-key-inference-providers-and-pinned-agents.md`):
- **Q1, provider kinds:** Anthropic is the only kind in the first release. The type is now `kind: 'anthropic'`, the base-URL field is gone, and OpenAI-compatible is listed as a later phase throughout.
- **Q2, harness menu:** `lal` is the default and `fae` the advanced choice. Floot and Jaine stay hidden until they have their own powers profiles.
- **Q3, deleting key material:** a root operator may call `SecretAdmin.delete` once the key is revoked and backups have expired. The provider's tombstone and audit rows stay permanently.
- **Q4, default caps:** a new table in the cost section sets provider defaults of 2 concurrent turns, 20 requests/min and $5/day, and agent defaults of 1, 10 and $2. Lowering a cap needs no confirmation. Raising one does, and the server refuses an unconfirmed raise with `limit-raise-unconfirmed`, not just the UI. Tests for this are in phases 2 and 3.
- **Q5, sharing:** a new "Explicit endowment" section says nothing is shared implicitly. A provider reaches an agent only when the creation request names it, and UI defaults are just pre-checked boxes. The text on endowments in the user-experience section, the confinement table and the actors table now match. Phase 4 now builds a subagent-creation slot (a pre-checked **Can create subagents** box), tested with a fake spawner. The spawner itself is left to `design-claude-api-agent-workbench-20261027`.
- **Q6, model catalogs:** a new "Model catalogs" section prefers the live model list. If that fails, a typed id with a valid shape is accepted, marked unverified, and checked on its first turn (`model-not-available` if the provider rejects it). Tests are in phase 2.
- **Q7, owner-wide cap:** there is now one cap across all of an owner's providers, defaulting to the provider defaults, so importing the same key twice can't double the budget. Each request is checked against the agent, provider and owner limits together. It is built in phase 2 and tested in phases 2 and 3.
- I also added a Decisions row to the design's header table linking the maintainer's comment, and bumped the date in `designs/README.md`.

**Phase 1 (registry) impact:** only narrowing, so nothing it may already have built conflicts. Phase 1 now accepts only the `anthropic` kind and checks model ids by shape alone; checking against the live list moved to phase 2. The default values, the raise confirmation and the owner-wide cap are all phase 2 additions. I updated the phase 1 text in the design but did not edit the phase 1 job. I explained the impact in a PR comment and on the tracker, and messaged the phase 1 builder's inbox.

**Comments posted:**
- PR: https://github.com/endojs/endo-but-for-bots/pull/1543#issuecomment-6434259635
- Tracker, with the new head SHA: https://github.com/kriscendobot/minion.town/issues/227#issuecomment-6434260167

The British-spelling and AI-cliché checks found nothing in the new text.

**Follow-up:** the job asked to keep the panel green, but the new text (the Explicit endowment and Model catalogs sections and the default-caps table) hasn't been through a panel. If you want that confirmed, a gauntlet run on #1543 would cover it.

## Panel-head freshness

Disposition: **review required**. The last completed panel reviewed `81e5e47ae3d16223e94692e9f6fd0bf821621dc9`; this job presented `069b429c169f2bc6bdfbfde73c6cab325b6c0203`. The old panel verdict does not cover the current head. No gauntlet was staged; the maintainer review docket received a deduplicated re-review action.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/apply-claude-api-open-question-answers-20261027.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 54 tokens (2593774 cached reads)
- Output: 23356 tokens
- Cost: $1.8522507999999995
- Wall-clock: 921s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
