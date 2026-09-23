---
source: endo-but-for-bots--packages-lal-primer-errors-md
cycle: 453
lane: designs
ingested: 2026-06-22
repo: endo-but-for-bots
branch: llm
package: lal
cluster: pivot
shape: agent-facing-error-reference
shape_subtype: verify-before-act-and-error-handling-discipline
authored_conformant: true
post_refactor_era: true
post_refactor_sequence: 101
---

The 31-line primer/errors.md is the agent-facing error handling reference inside @endo/lal's primer corpus. It defines two disciplines: a four-step error response protocol and a "Verify Before You Act" invariant for pet-name operations. Cycle 453's companion section (alongside the formatting.md primary section); ingested in the same cycle as the quasi-markdown dialect discovery.

The four-step error response protocol (lines 3-10) prescribes: (1) examine the error message to understand what went wrong; (2) do NOT retry with the same arguments — try a different approach; (3) if appropriate, inform the sender about the error using `reply()`; (4) still `dismiss()` the message after handling (even if handling failed). The no-retry-with-same-arguments discipline connects to cycle 413's silent-retry discipline (messaging.md: "try a different approach silently"). Cycle 413 named the STYLE rule; this cycle names the MECHANISM: the agent must not just retry silently but must change strategy. §the-named-no-same-argument-retry-as-strategy-change-discipline names the tier-3 meta-pattern.

The three common errors (lines 14-17) are: "Unknown pet name" (remedy: call list() to check what names actually exist); "Invalid arguments" (remedy: check parameter types and formats); "Permission denied" (remedy: the agent may not have access to that capability). The unknown-pet-name remedy is the same defensive-ordering pattern cycle 407 named for the locate tool: call list() BEFORE using a pet name. §the-named-unknown-pet-name-as-canonical-LLM-error names the tier-3 meta-pattern; the unknown-pet-name error is the premier LLM-agent mistake because LLMs confabulate names that do not exist.

The "Verify Before You Act" section (lines 23-31) establishes a PRE-CONDITION discipline for ALL pet-name operations: "Before using a name in any tool call (lookup, locate, adopt, etc.), make sure it exists. Special names like @self and @host are always present. For pet names, call list() to see your directory contents. Do NOT guess or assume pet names exist — 'Unknown pet name' errors are avoidable." The IMPORTANT-marker convention does NOT appear in this document (same as the formatting.md companion). §the-named-verify-before-act-as-universal-pet-name-precondition names the tier-3 meta-pattern; the document elevates the list-before-locate pattern from the locate tool to a GENERAL invariant across all tools. Cycle 407's locate-defensive-prerequisite was tool-specific; cycle 453's verify-before-act is universal.

The always-dismiss-even-on-failure rule (step 4 of the error protocol) extends cycle 413's mandatory-reply-and-dismiss-pair: cycle 413 named "always dismiss messages after handling them — this is essential for proper operation"; cycle 453 extends: dismiss is required EVEN WHEN HANDLING FAILED. §the-named-dismiss-required-regardless-of-handling-success names the tier-3 meta-pattern; the dismiss is not a success signal but a message-management operation that must execute unconditionally.

The cluster count for this section shares the session-level observation with the formatting.md primary section: §the-named-one-hundred-one-conformant-cycles-and-counting. Two citation arcs close on this section. Cycle 407 (3, locate-defensive-prerequisite named as tool-specific; this cycle generalizes to verify-before-act as cross-tool universal). Cycle 413 (3, always-dismiss named; this cycle extends to always-dismiss-even-on-failure). The errors.md section's contribution is depth, not breadth: it sharpens existing framings from tool-specific to universal, and from success-contingent to unconditional.

Source: [packages/lal/primer/errors.md](https://github.com/endojs/endo-but-for-bots/blob/10594d09fa6efff9f7d4271adc2f2f19214fd756/packages/lal/primer/errors.md) at commit `10594d09`.
