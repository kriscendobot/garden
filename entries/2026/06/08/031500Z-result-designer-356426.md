---
ts: 2026-06-08T03:15:00Z
kind: result
role: designer
host: endolinbot
project: endo-but-for-bots
worktree: dispatches/designer--356426/project
repo: endojs/endo-but-for-bots
refs:
  - entries/2026/06/08/030000Z-dispatch-designer-356426.md
  - entries/2026/06/08/025500Z-result-researcher-c19e1e.md
  - https://github.com/endojs/endo-but-for-bots/pull/404
  - https://github.com/endojs/endo-but-for-bots/pull/404#pullrequestreview-4415614938
  - https://github.com/endojs/endo-but-for-bots/pull/404#pullrequestreview-4414531688
  - https://github.com/endojs/endo-but-for-bots/pull/404#issuecomment-4645127967
---

# result: designer on PR #404 (chat-inventory-create-menu) — rebase + 10 inline + COMMENTED applied

Applied kriskowal's CHANGES_REQUESTED review `pullrequestreview-4415614938` (ten inline) and COMMENTED review `pullrequestreview-4414531688` (Ollama supported-models discovery + download) on `endojs/endo-but-for-bots#404` per the RSVP dispatch. PR rebased onto the frozen-base snapshot `llm-11a76ae`, PR base retargeted via `gh pr edit 404 --base llm-11a76ae`, and a single follow-up commit `531ddd648` lands all ten inline answers plus the COMMENTED-review answer. Per-inline replies posted on all ten threads (`3370645296`, `3370645570`, `3370645655`, `3370645860`, `3370645975`, `3370646315`, `3370646342`, `3370646612`, `3370646711`, `3370646862`), each citing the SHA, with the top-level summary at `issuecomment-4645127967` enumerating every inline-id → disposition. Review re-request deliberately not performed per the dispatch's explicit *NOT re-request review* directive.

## Deliverables

- Branch `design/chat-inventory-create-menu` force-with-leased to `531ddd648` (was `7b2bf91f6`). Rebased one commit; one merge conflict in `designs/README.md` (milestone renumbering on `llm` vs. M4-era insertions from the original commit) resolved by adopting the modern M9 numbering and inserting `chat-inventory-create-menu` rows under M9, bumping counts (M9: 12 → 13; total: 55 → 56) and cumulative timeline rows.
- PR #404 base retargeted from `llm` to `llm-11a76ae` (frozen-base snapshot at the same SHA as `origin/llm` currently; per `skills/frozen-base-branch/SKILL.md`).
- Follow-up commit `531ddd648 design(chat): fold maintainer review into create-menu (#404)` lands per `skills/review-feedback-followup-commits/SKILL.md` (one substantive commit on top of the rebased original; not amended).
- 10 per-inline-thread replies (`POST /pulls/404/comments/<id>/replies`) under the standing broad-comment authorization.
- Top-level summary comment `issuecomment-4645127967` covering both reviews, the inline-id → disposition table, the rebase context, and the sibling-designer-dispatches inventory.

## Design body changes (file: `designs/chat-inventory-create-menu.md`)

- **Metadata**: added `Updated: 2026-06-08`.
- **Pane 2 (Inference source selection)**: provider table expanded from 4 rows to 5 (Ollama split into local + Ollama Remote; OpenRouter row notes optional attribution disclosure). Mermaid flowchart redrawn to add Ollama-Remote branch, OpenRouter-attribution branch, and the `not-downloaded → pull model` Ollama sub-state. New § Model download (Ollama) paragraph encodes the COMMENTED-review ask (`listModels()` returns both local and not-yet-downloaded; picker shows badges; `/api/pull` with progress + cancel). Routed through the daemon's `pi-ai` Ollama adaptor, not Chat → Ollama HTTP directly.
- **Pane 3 (Endowment selection)**: row table grew from 4 ad-hoc rows to the nine-row `daemon-capability-bank` roster (filesystem, process execution, network, git operations, env vars, credential store, user I/O, timer, delegates). Filesystem stays shippable today; the other eight are documented placeholders. Defaults are *omitted* per capability-bank principle 4. New § Posix sandbox composition encodes the `@fs` + `@main` coupling as a wizard checkbox (not a third endowment type), per inline 289. Extensibility paragraph + Open Question 8 commit to "system is extensible: new capability families surface as new rows without reshaping the wizard".
- **Submit § endowment-delivery**: collapsed to the existing `provideGuest({ introducedNames })` shape per inline 495. The earlier "follow-up `introduce` per endowment" framing was an artifact; the wizard maps picked endowments to a `{ <picked-pet-name>: <cap-pet-name> }` record threaded through `introducedNames`, no new form field.
- **Cross-Design Alignment § Relationship to `lal-fae-form-provisioning`**: rewritten as "Chat absorbs the provisioning entry point; daemon-side substrate stays" per inline 363. New § Root host agent as a special place encodes the user / user-profile split and the `@root` endowment as a Specials entry (precedent: `@apps` in `familiar-bundled-agents`; alongside `@self` / `@host` / `@agent` / `@keypair` / `@main` / `@endo` per `d256 § Per-agent keypairs`). Pet-store shape paragraph cites `chat-spaces-gutter`'s typed-namespace-over-untyped-pet-store discipline as the precedent.
- **Design Decision 7**: rewritten from "Extends, never replaces" to "Chat absorbs the provisioning entry point; daemon-side substrate stays".
- **Open Questions**: Q1 commits provider credentials to the root host agent pet store with encryption per a sibling design `chat-inventory-encrypted-formulas`; Q2 defers provider-key recovery to a sibling design (slug TBD by maintainer); Q3 reframed (Ollama Remote is now a distinct provider, not an Advanced disclosure); Q4 marked Resolved (introducedNames is the field); Q5 acknowledges inline 499; new Q6 surfaces the `@root` + user-host sibling design; Q7 (provider-registry discovery) and Q8 (item-type extensibility) preserved with extensibility prose strengthened. New § Sibling designer dispatches table enumerates the three sibling dispatches with proposed slugs.
- **Dependencies summary table**: added rows for `daemon-capability-bank`, `daemon-mount`, `d256`; refined the `familiar-bundled-agents`, `endopi-provider-registry-and-oauth`, and `lal-fae-form-provisioning` row descriptions.

## README updates (file: `designs/README.md`)

Bumped recently-added entry (now reflects the 2026-06-08 revision); inserted `chat-inventory-create-menu` row in the summary table; added the design to the M9 milestone table; added the M9 estimates table row; bumped M9 milestone summary count (12 → 13) and effort (8-11 → 9-12 weeks); bumped cumulative timeline (M9: 34-45 → 35-46 weeks; downstream cumulative bumped accordingly); bumped totals (Not Started 37 → 38; total 135 → 136 designs).

## Line-to-section discrepancy noted

Per the role norm (*Verify the brief's line-to-section mapping against actual comment line numbers*): inline 363's `line` field anchors inside Cross-Design Alignment § Relationship to `endopi-provider-registry-and-oauth`, but the comment body is clearly about the `lal-fae-form-provisioning` "replace, not extend" directive. Trusted the body over the anchor line; folded the answer into the lal-fae section and Design Decision 7. Surfaced in the top-level summary comment for the maintainer's awareness.

## Sibling-designer dispatches

Three sibling-designer dispatches surface as separate `message: designer → steward` entries (siblings of this result entry). The maintainer's directives are explicit: each sibling design originates its own designer dispatch when the slug is confirmed. This designer does *not* author the sibling designs in PR #404.

1. `chat-inventory-encrypted-formulas` (proposed slug) — root host agent pet store with encrypted-at-rest formula storage; inline 477 trigger.
2. (slug TBD by maintainer) — provider-key recovery and rotation; inline 484 trigger.
3. (slug TBD; candidate `endo-root-special-and-user-host`) — `@root` endowment + `user` / `user-profile` split; inline 363 trigger.

## Constraints honored

- Rebase + push: authorized in dispatch; force-with-lease against the prior tip `7b2bf91f6`.
- PR-base retarget: authorized in dispatch; ran `gh pr edit 404 --base llm-11a76ae`.
- Ten per-inline replies + top-level summary + COMMENTED-review coverage (in the same top-level summary): authorized in dispatch under standing broad-comment authorization for `endojs/endo-but-for-bots`.
- NOT re-request review (per explicit dispatch directive).
- Out of scope respected: no sibling designs authored in this PR; no packages/ source touched; no panel chain triggered.

## Reading order from a future archaeologist

1. The PR `endojs/endo-but-for-bots#404` for the user-visible artifact.
2. `designs/chat-inventory-create-menu.md` at commit `531ddd648` for the substance.
3. This result entry for the disposition + sibling-dispatch inventory.
4. The three `message: designer → steward` entries (siblings of this entry) for the sibling-design dispatch prompts.
5. The researcher result `entries/2026/06/08/025500Z-result-researcher-c19e1e.md` for the library + project references that grounded the rewrite.

Self-improvement: nothing this time. The dispatch fit cleanly within the designer role: the researcher's library section pre-loaded every reference the rewrite needed (introducedNames as the endowment-delivery field, the @apps / @root Specials precedent, the daemon-capability-bank nine-row roster, the encrypted-at-rest credential discipline, the typed-namespace-over-pet-store idiom), and the frozen-base-branch skill drove the rebase cleanly with one expected conflict on the milestone-renumbered README. The line-to-comment-anchor discrepancy on inline 363 surfaced naturally and was handled per the existing role norm; flagging it in the top-level summary closes the loop with the maintainer.
