---
kind: result
role: gardener
host: endolin-garden-ece02cb4
at: 2026-08-06T05:55:02Z
---
---
kind: result
role: critic
repo: kriscendobot/minion.town
project: minion-town
---

# Design-panel critic block for kriscendobot/minion.town#21

Diff base: origin/main. Reviewed worktree: /home/kris/garden/scratch/project-wt-minion-town-pr21-a96e97d-design-land-0d8f4e76 (design-only, designs/weblet-gateway.md, 850 lines added).

### critic (design panel, kriscendobot/minion.town#21)

**Verdict:** request-changes

**Findings:**

- **must-fix.** § 3 makes label canonicity a "required invariant" (16 labels decode to one id, so `ask` mints up to 16 certs per weblet against a 50-per-week ceiling the design itself calls attacker-reachable), and § 4.4 lists refusing a non-canonical variant as an Increment-1 done criterion. Yet neither recorded verification run (2026-08-02, 2026-08-05) lists that observation, § 10 row 1 omits it, and the gate survives only as a floating "Increment-1 code follow-up" in § 3 with no owner and no gate. The worktree confirms it is still absent: `src/endo/gateway/base32.ts` `labelToId` checks length only, so the live edge accepts all 16 variants today. Either bind the gate to a named precondition or move it into § 9 with a trigger. [rule: roles/COMMON.md § Reporting, a verified claim cites the observation]
- **must-fix.** § 4.3 calls the control-port split "an Increment-2 precondition" and § 5.2 requires the `__Host-` cookie rename "before the wildcard serves untrusted content", listing it in the Increment-2 DoD. § 10 row 2 then records Increment 2 as landed with both outstanding. A precondition a landed increment skipped, never restated, has stopped constraining anything. Restate both as explicit Increment-4 gates (publish is when untrusted content arrives) and say plainly that Increment 2 landed with its DoD unmet. [proposed-rule: when a design records an increment as landed, any precondition or DoD criterion it skipped must be re-bound to a named later gate, not left as prose]
- **should-fix.** § 4.2 sells on-demand TLS chiefly on "the strongest fail-closed" at the TLS layer, and §§ 4.4 and 5 encode "unknown hash's handshake is refused" as done criteria. But the same section makes the DNS-01 wildcard cutover an Increment-4 precondition, and a wildcard cert discards exactly that property: every garbage SNI then completes a handshake and reaches the gateway, demoting fail-closed to an application 404. The DNS-01 cost column does not list this loss. Add it, and mark the handshake-refusal criteria transitional. [proposed-rule: an options table must list, under the escape hatch, any property of the chosen option the escape hatch removes]
- **should-fix.** § 3 anticipates two guests publishing byte-identical `{ content, powers }` ("the first registration owns it"), but § 7.1's `publishWeblet` result has no case for it. The second caller is charged (§ 7.2 charges before interning), receives `{ hash, url, serving }` for an origin it does not own, its `weblet_unpublish` will answer `not-owner`, and the first owner's unpublish silently removes its weblet. Name the outcome in the § 7.1 `reason` taxonomy and say whether the charge is levied. [proposed-rule: a stated collision case must have a stated result in the capability's return contract]
- **should-fix.** The "As built" reconciliation discipline is applied to Increment 1 only. §§ 5 and 6 read as fully delivered although § 10 records CBOR and Syrup routes policy-closed and browser CORS enforcement unverified. Relatedly, open question 6's own recommendation ("decide in Increment 2 with the cache design") was settled by default when Increment 2 shipped one-year `immutable` caching, while § 9's preamble still says all questions remain open. Give §§ 5 and 6 inline "As built" notes and mark question 6 settled-by-shipping or restate its deadline. [rule: skills/gricean-maxims/SKILL.md § Quality]

**Notes (out of scope but worth flagging):**

- The code-level fixes behind findings 1 and 2 (the canonicity check, the control-port bind, the cookie rename) belong to the implementation PRs' code panel. They are raised here only because this document records them as satisfied or as preconditions that held. [rule: roles/jurors/critic/AGENT.md § In-scope vs out-of-scope]
- § 7.2's charge-before-intern ordering does not bound the bytes already carried over MCP as base64 before the measure is computed. Implementation concern for Increment 4. [proposed-rule: a resource gate should name the point past which the resource is already consumed]

Self-improvement: the critic brief tells the seat to read the design end to end, but its sharpest findings here came from cross-checking the document's "as built" claims against the worktree source (`labelToId`, the missing control port). Worth adding to the brief: when a design carries "As built" reconciliation notes, verify each against the checkout, since a stale note is a premise failure the design panel is the last reader positioned to catch.
