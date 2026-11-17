I opened draft design PR **endojs/endo-but-for-bots#1671**, which turns `endopi-prompt-templates` into a buildable design. It targets the frozen base `llm-0368767` and changes only three design files.

**Two things weren't as the job described:**
- **A build already exists.** Draft PR #1640 implements this feature from the old, thin design. Its gauntlet halted on red CI at head `24cd13406c`. The design keeps #1640's approach to template access, which is sound, and lists exactly what needs reworking.
- **The old design had Pi's syntax wrong.** It said Pi templates use `{{var}}` placeholders. Pi's own docs show `$1`, `$@`, `$ARGUMENTS`, `${1:-default}`, `${@:N}` and `${@:N:L}`, plus an `argument-hint` frontmatter key. The design adopts Pi's syntax so a Pi template expands the same way in Endo.

**What the design covers:**
- **Template format:** how names are formed, `description`, `argument-hint` (`<required>` / `[optional]`), and other keys being ignored.
- **Argument splitting:** Pi's five quoting rules.
- **Substitution:** done in one pass, so substituted values are never re-expanded, and `$` text that isn't a placeholder stays as typed.
- **Chat behavior:** expanding a template fills the editor and never sends. Missing required arguments open the chat bar's inline form, labelled from `argument-hint`. Extra arguments are an error only when the template has no "all arguments" placeholder. Built-in commands always win, and the `skill:` prefix is reserved.
- **Where templates come from:** read-only daemon mounts under the `prompt-templates` pet name. Only the Node setup script creates them, which is the user's equivalent of granting project trust. The design gives the directory order and which directory wins on a name clash.
- **Shared directory search:** one `listConventionalDirectories` function shared with `@endo/skills` (#1643), placed in whichever package merges first.
- **Fit with work in flight:**
  - The expanded text is recorded as an ordinary user message in the JSONL transcript (#669, #1669).
  - Templates don't affect provider choice.
  - The stdio RPC bridge (#667) doesn't expand templates.
  - Templates from extension packages are a later source.
- **Also included:** an ownership map, security notes, a test plan, three build phases, and a numbered "Delta from #1640" list.

I also replaced the wrong `{{var}}` wording in `designs/endopi.md` and `designs/README.md`, and bumped the design's Updated date to 2026-11-17. The one diagram passes a parse-only mermaid check; nothing else needed checking for a design-only change.

**Questions for the maintainer (in the PR):**
1. Should `{{name}}` placeholders survive as an Endo-only extension? I recommend no.
2. Should agents, not just the user, be able to invoke templates? I recommend user only.

## Follow-ups
- **Build:** rework the existing draft #1640 to match this design (the "Delta from #1640" list), rather than opening a new build PR. #1640 also edits this design file, so it will need a rebase.
- I left #1671 as a draft; the completion machinery records its design-panel gauntlet.

<!-- garden-design-build-handoff: successor=build-endopi-prompt-templates state=recheck:endojs-endo-but-for-bots-pr1671-gauntlet pr=https://github.com/endojs/endo-but-for-bots/pull/1671 -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/design-endopi-prompt-templates.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 62 tokens (2605821 cached reads)
- Output: 18812 tokens
- Cost: $1.6732074000000003
- Wall-clock: 456s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
