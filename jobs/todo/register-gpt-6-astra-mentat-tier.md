---
role: fixer
tier: mentor
fallback-tier: minion
dispatch: automatic
---
# Register GPT-6 Astra as a codex/cleric mentat-tier model

Maintainer directive (kriskowal, 2026-09-21). OpenAI released **GPT-6 Astra**
(2026-09-03), model id **`gpt-6-astra`** — confirmed directly from OpenAI's
own developer docs (https://developers.openai.com/api/docs/models/gpt-6-astra,
"Model ID: `gpt-6-astra`") and the launch announcement
(https://openai.com/index/gpt-6-astra/). It should be registered at
**mentat** tier, claimable by codex/**cleric** workers — mentat is currently
Claude-only (`claude-fable-5`, `claude-mythos-5`); this adds the first
non-Anthropic mentat row, mirroring how `mentor` is already multi-provider.

## Change

Add a row to `scripts/jobs/model-tier-inventory.tsv`:

```
openai	gpt-6-astra	mentat
```

(match the file's existing 3-column tab-separated shape exactly — see the
adjacent `anthropic	claude-fable-5	mentat` row for the pattern; check
whether a 4th throwaway "size" field convention mentioned in the file's own
header comments applies here and follow it if so).

Update `skills/model-selection/SKILL.md`'s mentat row (currently reads
"Claude Fable 5 (`claude-fable-5`; Mythos is equivalent when enabled)") to
also name GPT-6 Astra and note it's claimable by `cleric`, mirroring how the
`mentor` row's prose already explains its own multi-provider claimability
("a mentor job is claimable by whichever provider's worker is live...").

## Verify mentat's manual-only invariant still holds for the new provider

Mentat is deliberately manual-only fleet-wide — "No automatic path may emit
Fable/mentat or any other manual-only pin. The gardener [and] claim-job.sh
both refuse `tier: mentat` unless the job carries [explicit manual
dispatch]." Confirm this refusal is provider-agnostic (keyed on the tier
string, not a specific model/provider), so adding an OpenAI mentat row
doesn't accidentally open an automatic path to `gpt-6-astra` that doesn't
exist for `claude-fable-5` today. If the refusal logic is NOT already
provider-agnostic, that's a gap to fix as part of this job, not just work
around.

Pricing context (not necessarily needed for the tsv itself, but relevant if
`reputation/rate-card.md` or similar needs a corresponding entry — check
and add if the rate-card is keyed per model): OpenAI API standard pricing
$10/M input, $50/M output tokens; a Fast mode exists at 2x speed/2x price.
1.05M context window, 128K max output, knowledge cutoff 2026-04-30.

## Report

Confirm `post-manual-job.sh`/whatever manual-dispatch path is used can
actually route a `tier: mentat` job to `gpt-6-astra` on a cleric worker
end-to-end (a real dispatch, not just a config read), and confirm the
existing Claude-mentat path is unaffected.
