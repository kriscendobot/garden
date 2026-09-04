Inbox empty. Both deliverables done. Writing the completion report.

---

## Completion report — `endojs-endo-but-for-bots-pr264-probe`

**Verb:** probe (gap-revealing build). Deliverable is the gap inventory, not a mergeable feature. No cleaner/panel/un-draft chain run; PR stays draft.

**What I did.** Read `designs/compartment-mapper-import-attributes.md` (#264) and the sibling `designs/ses-import-attributes.md` (#248) in full, then attempted the propagation contract against the real code on `design/compartment-mapper-import-attributes` @ `8d141d7bb`.

**Headline finding.** The design's "Landing-order dependency" premise is **false against its own base**: it asserts #248's SES surface "landed on `llm`" and that this base "already includes that design," but every cited primitive is absent — `grep` for `EMPTY_ATTRIBUTES` / `normalizeImportAttributes` / `modulesWithAttributes` returns zero hits; `ses/types.d.ts` still declares a single-arg `ImportHook`; `module-load.js` still keys the memo on the bare specifier; `Compartment` has no `modulesWithAttributes`; `@endo/module-source` still emits bare-string imports; and #248 is an unmerged *Draft* design. The entire runtime of #264 is gated on the #248 **implementation** landing first — a sequencing fact the design misstates as already satisfied.

**Deliverables.**
- **Draft PR #1131** (https://github.com/endojs/endo-but-for-bots/pull/1131), based on the design head branch, confirmed `isDraft: true`. Body carries the four required sections. **9 gaps surfaced** (1: SES surface unimplemented + false landing-order claim; 2: no attribute source in module-source; 3: unnamed `node-modules.js` gather site; 4: under-motivated `CompartmentModuleConfiguration.imports`; 5: companion-field name+placement, design Open Q §1; 6: marker shape, §2; 7: persisted field name, §6a; 8: `ImportHookMaker`/arity-rule/diagnostic all blocked; 9: CJS/bundler/policy guard sites unnamed). Gaps 3 and 4 are genuinely new signal from code contact, not restatements of the design's open questions.
- **Skeleton implemented (1 item):** `packages/compartment-mapper/src/types/compartment-map-schema.ts` (commit `6aff266d9`) — the `PersistedImport` union (with the `default`-named target per the review steer), optional `imports?` on `FileModuleConfiguration`, and the dedicated top-level `importAttributes?: 'v1'` marker (not a `tags` entry). Type-only, additive, well-formed in isolation; each declaration carries an inline `gap:` cross-reference. (No `tsc` in the warm-cache install — devDeps absent — but an optional-field + exported-union addition of this shape cannot introduce a type error on its own.)
- **Skeleton not implemented (7 areas):** all runtime seats — `node-modules.js` gather, `infer-exports.js` companion handling, `link.js` partition + two-arg hooks + upgrade diagnostic, `archive-lite.js` writer, `import-archive-lite.js` two-arg synthetic hook, the `CompartmentModuleConfiguration` parallel field, and the whole test catalogue — each abandoned at first contact and cross-referenced to its blocking gap.
- **Feedback comment on #264** (https://github.com/endojs/endo-but-for-bots/pull/264#issuecomment-5534904667) summarizing the gaps as feedback to the proposal and linking #1131.

**Noted strength (not a gap):** the policy-passthrough invariant (specifier-only gate stays complete because attributes only *select* among already-registered parsers) holds up under code contact.

**Follow-ups for the maintainer.** (1) Correct the landing-order paragraph and add a `Blocked-by: #248 implementation` criterion — highest-value revision. (2) Lock Open Q §1 (companion name `with` + after-`default` placement + reserve-and-lint) in the design before any implementation dispatch. (3) Resolve new Gaps 3 and 4. The probe is a one-shot; a post-revision re-probe is a fresh job, not a fixer round on #1131.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr264-probe.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 52 tokens (2348086 cached reads)
- Output: 25246 tokens
- Cost: $2.8695150000000007
- Wall-clock: 400s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
