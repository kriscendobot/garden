# Keywords

A grep-friendly index from domain terms and phrases to concept-ids in
[`concepts/`](concepts/). Multiple keywords may resolve to the same
concept; this is how synonyms cluster. Use the
[`library-lookup`](../../../skills/library-lookup/SKILL.md) skill rather
than reading this file by eye — the skill knows how to fall back
gracefully when a term is not yet indexed, and is responsible for
*indexing on the fly* (adding the shortcut that would have made your
current search succeed, so the next reader's search succeeds where
yours did not).

Format: one entry per line, `<keyword or phrase> | <concept-id>`.
Code-symbol keywords are written in backticks; prose keywords are
plain. Letter case in keywords is preserved when meaningful (e.g.
`LOCAL_NODE` as a symbol vs. `local node` as prose).

## Index

`@keypair` | per-agent-keypair
`'0'.repeat(64)` | local-node-sentinel
Aifred | delegates-and-epithets
AI assistant disclosure | delegates-and-epithets
anti-impersonation | delegates-and-epithets
anti-impersonation invariant | delegates-and-epithets
assistant to Alice | delegates-and-epithets
caretaker | caretaker-pattern
caretaker pattern | caretaker-pattern
connector identity guarantee | pass-invariant-handle-equality
chat invariants | (see source: endo-but-for-bots--llm-designs-chat-invariants)
chat principles | (see source: endo-but-for-bots--llm-designs-chat-invariants)
chat components | (see source: endo-but-for-bots--llm-designs-chat-components)
chat package layout | (see section: endo-but-for-bots--llm-designs-chat-components--file-structure-and-component-map)
counter-proposal endowments | (see section: endo-but-for-bots--llm-designs-chat-components--css-variables-and-security)
CSS theme tokens | (see section: endo-but-for-bots--llm-designs-chat-components--css-variables-and-security)
eval proposal | (see section: endo-but-for-bots--llm-designs-chat-components--inventory-and-messages)
inventory panel | (see section: endo-but-for-bots--llm-designs-chat-components--inventory-and-messages)
Monaco sandboxed iframe | (see section: endo-but-for-bots--llm-designs-chat-components--css-variables-and-security)
profile breadcrumb | (see section: endo-but-for-bots--llm-designs-chat-components--profile-system-and-error-handling)
SPECIAL toggle | (see section: endo-but-for-bots--llm-designs-chat-components--inventory-and-messages)
speech-pointer error | (see section: endo-but-for-bots--llm-designs-chat-components--profile-system-and-error-handling)
wrapped powers | (see section: endo-but-for-bots--llm-designs-chat-components--inventory-and-messages)
Familiar Chat | (see source: endo-but-for-bots--llm-designs-chat-invariants)
keyboard-manual parity | (see section: endo-but-for-bots--llm-designs-chat-invariants--overview-and-six-invariants)
modeline completeness | (see section: endo-but-for-bots--llm-designs-chat-invariants--overview-and-six-invariants)
progressive disclosure | (see section: endo-but-for-bots--llm-designs-chat-invariants--principles)
escape consistency | (see section: endo-but-for-bots--llm-designs-chat-invariants--overview-and-six-invariants)
autocomplete list navigation | (see section: endo-but-for-bots--llm-designs-chat-invariants--overview-and-six-invariants)
platform-appropriate modifier keys | (see section: endo-but-for-bots--llm-designs-chat-invariants--principles)
token chip | token-chip
token chips | token-chip
`@`-prefix chip | token-chip
pet-name chip | token-chip
named-value chip | token-chip
path chip | token-chip
removable chip | token-chip
token autocomplete | token-chip
slash command | (see source: endo-but-for-bots--llm-designs-chat-invariants)
chat spaces gutter | space
space (chat) | space
spaces gutter | space
`SpaceConfig` | space
spaces | space
home space | space
Space 0 | space
indelible space | space
user space | space
Cmd+0 | space
configurable home space | space
chat-spaces-home | (see source: endo-but-for-bots--llm-designs-chat-spaces-home)
`data-menu-scope` | (see section: endo-but-for-bots--llm-designs-chat-spaces-home--context-menu-scope-modal-reuse-and-shared-affordances)
`HOME_SPACE_DEFAULTS` | (see section: endo-but-for-bots--llm-designs-chat-spaces-home--indelible-space-zero-and-numbering)
`showName` parameter | (see section: endo-but-for-bots--llm-designs-chat-spaces-home--context-menu-scope-modal-reuse-and-shared-affordances)
icon-selector extraction | (see section: endo-but-for-bots--llm-designs-chat-spaces-home--context-menu-scope-modal-reuse-and-shared-affordances)
merge-on-load normalize-on-save | (see section: endo-but-for-bots--llm-designs-chat-spaces-home--indelible-space-zero-and-numbering)
belt-and-suspenders discipline | (see section: endo-but-for-bots--llm-designs-chat-spaces-home--indelible-space-zero-and-numbering)
`createSpacesGutter` | (see section: endo-but-for-bots--llm-designs-chat-spaces-gutter--interactions-keyboard-and-future)
client-side convention over a complete daemon API | (see section: endo-but-for-bots--llm-designs-chat-spaces-gutter--motivation-and-architecture)
typed namespace over untyped pet-store | (see section: endo-but-for-bots--llm-designs-chat-spaces-gutter--space-model-and-persistence)
Cmd+1..9 | (see section: endo-but-for-bots--llm-designs-chat-spaces-gutter--interactions-keyboard-and-future)
multi-agent context switching | (see source: endo-but-for-bots--llm-designs-chat-spaces-gutter)
profilePath | (see section: endo-but-for-bots--llm-designs-chat-spaces-gutter--space-model-and-persistence)
control facet vs action facet | caretaker-pattern
delegate | delegates-and-epithets
delegates | delegates-and-epithets
delegates and epithets | delegates-and-epithets
delegate/epithet model | delegates-and-epithets
Delegates and Epithets | delegates-and-epithets
epithet | delegates-and-epithets
epithets | delegates-and-epithets
epithet chain | delegates-and-epithets
epithet stripping | delegates-and-epithets
facet split | caretaker-pattern
`handleFor` | pass-invariant-handle-equality
Handle equality | pass-invariant-handle-equality
Handle vs HandleControl | caretaker-pattern
`HandleControl` | caretaker-pattern
`HandleInterface` | delegates-and-epithets
identity / action facet split | caretaker-pattern
Jarvis | delegates-and-epithets
majordomo of Aifred | delegates-and-epithets
obligatory verifiable deniable | delegates-and-epithets
pass-invariant equality of Handles | pass-invariant-handle-equality
pass-invariant Handle equality | pass-invariant-handle-equality
permits buckets | permits-buckets
permits.js buckets | permits-buckets
powered vs powerless intrinsics | permits-buckets
prefer Uint8Array over Buffer | permits-buckets
principal | delegates-and-epithets
SES permits buckets | permits-buckets
`sharedGlobalPropertyNames` | permits-buckets
start compartment vs shared compartment | permits-buckets
`TextDecoder` | permits-buckets
`TextEncoder` | permits-buckets
text codecs shim | permits-buckets
universal vs shared vs initial | permits-buckets
`universalPropertyNames` | permits-buckets
`initialGlobalPropertyNames` | permits-buckets
vetted shim | permits-buckets
service connector | delegates-and-epithets
verification protocol | delegates-and-epithets
verifiable deniable claims | delegates-and-epithets
`0.0.0.0 of Ed25519` | local-node-sentinel
6/7 aspects | six-aspects-of-sharing
acyclic formula graph | formula-graph
agent Ed25519 keypair | per-agent-keypair
agent identity formula | per-agent-keypair
all-zeros sentinel | local-node-sentinel
asymmetry of authority | crdt-in-formula-persistence
bidirectional CRDT | crdt-in-formula-persistence
Bob Alice Carol garage scenario | six-aspects-of-sharing
cohort | cohort-destruction
cohort-aware programming model | cohort-destruction
coalesce-then-deliver | retention-accumulator
coordinated retention | four-tables-coordinated-retention
CRDT | crdt-in-formula-persistence
CRDT abandoned | crdt-in-formula-persistence
CRDT in formula persistence | crdt-in-formula-persistence
daemon persistence strategy | formula-persistence-thesis
dehydrate | dehydrate-hydrate
dehydrate at ingestion hydrate at presentation | dehydrate-hydrate
dehydration and hydration | dehydrate-hydrate
deliberately-unreachable value | sentinel-with-rationale
destruction by cohort | cohort-destruction
disincarnation by cohort | cohort-destruction
do not transcribe upstream rows | shape-not-content
dynamic chained cross-domain composable attenuated accountable revocable | six-aspects-of-sharing
Formula Persistence | formula-persistence-thesis
formula graph | formula-graph
formula key vs locator | dehydrate-hydrate
formula persistence | formula-persistence-thesis
formulas as recipes | formula-graph
formulas as constructors | formula-graph
`formulaGraph` | formula-graph
formatting at the edges | producer-typed-shape-consumer-rendering
fourth revocation mechanism | revocation-by-withdrawal
four tables | four-tables-coordinated-retention
hidden-intrinsic sampling | throwaway-instance-prototype-walk
`%IteratorPrototype%` | throwaway-instance-prototype-walk
IteratorPrototype sampling | throwaway-instance-prototype-walk
immediate local revocation | revocation-by-withdrawal
inviter and accepter tables | four-tables-coordinated-retention
Karp | six-aspects-of-sharing
Karp Stiegler Close | six-aspects-of-sharing
`KeypairFormula` | per-agent-keypair
keypair formula | per-agent-keypair
library captures shape | shape-not-content
local agency CRDT | four-tables-coordinated-retention
`LOCAL_NODE` | local-node-sentinel
microtask-coalesced retention deltas | retention-accumulator
mirrored retention roots | four-tables-coordinated-retention
no daemon-side string formatter | producer-typed-shape-consumer-rendering
no shared truth to converge on | crdt-in-formula-persistence
not one click for security | six-aspects-of-sharing
out-of-band sentinel | sentinel-with-rationale
pass by construction | cohort-destruction
per-agent keypair | per-agent-keypair
persist construction not content | formula-persistence-thesis
petname CRDT | crdt-in-formula-persistence
petname graph as persistence root | formula-persistence-thesis
pet store holds formula keys not locators | dehydrate-hydrate
producers own typed shape | producer-typed-shape-consumer-rendering
consumers own rendering | producer-typed-shape-consumer-rendering
rationale for sentinel choice | sentinel-with-rationale
reconstruction on demand | cohort-destruction
remote-view table | four-tables-coordinated-retention
`RetentionDelta` | retention-accumulator
retention-accumulator | retention-accumulator
`retention-accumulator.js` | retention-accumulator
retention churn collapse | retention-accumulator
return-value prototype walk | throwaway-instance-prototype-walk
revocation by withdrawal | revocation-by-withdrawal
revocation by withdrawal of the constructor | revocation-by-withdrawal
sentinel local node | local-node-sentinel
sentinel-with-rationale | sentinel-with-rationale
SES permit graph seed | throwaway-instance-prototype-walk
seven aspects of sharing | six-aspects-of-sharing
shape-not-content principle | shape-not-content
shape not content | shape-not-content
six aspects of sharing | six-aspects-of-sharing
stable formula key vs ephemeral hints | dehydrate-hydrate
Stiegler | six-aspects-of-sharing
taxonomy capture without rows | shape-not-content
throwaway-instance-prototype-walk | throwaway-instance-prototype-walk
timely revocation through local reachability | revocation-by-withdrawal
Tyler Close | six-aspects-of-sharing
typed-shape-in typed-shape-out | producer-typed-shape-consumer-rendering
formula store JSON vs SQLite | formula-graph
retention table SQLite | formula-graph
`makeNetstringReader` | (see section: endo--pkg-netstring-readme--overview)
`makeNetstringWriter` | (see section: endo--pkg-netstring-readme--overview)
`makeOcapnRecordCodecFromDefinition` | syrup-record-positionality
ocapn-peer record | syrup-record-positionality
OcapnLocation field rename | syrup-record-positionality
positional bindings not on the wire | syrup-record-positionality
record field rename wire-compat | syrup-record-positionality
Syrup field names on the wire | syrup-record-positionality
Syrup record positionality | syrup-record-positionality
transport vs network field rename | syrup-record-positionality
base64 native fallthrough | (see source: endo-but-for-bots--llm-designs-base64-native-fallthrough)
`encodeBase64` | (see source: endo-but-for-bots--llm-designs-base64-native-fallthrough)
`decodeBase64` | (see source: endo-but-for-bots--llm-designs-base64-native-fallthrough)
`ENDO_BASE64_FORCE` | (see source: endo-but-for-bots--llm-designs-base64-native-fallthrough)
`Uint8Array.fromBase64` | (see source: endo-but-for-bots--llm-designs-base64-native-fallthrough)
`Uint8Array.prototype.toBase64` | (see source: endo-but-for-bots--llm-designs-base64-native-fallthrough)
ponyfill-shim pattern | (see source: endo-but-for-bots--llm-designs-base64-native-fallthrough)
TC39 Uint8Array to/from base64 | (see source: endo-but-for-bots--llm-designs-base64-native-fallthrough)
`%URLSearchParamsIteratorPrototype%` | throwaway-instance-prototype-walk
upstream meta-tables | shape-not-content
why it cannot collide | sentinel-with-rationale
`ColorScheme` (typedef) | space
high-contrast mode | space
high-contrast-light | space
high-contrast-dark | space
`prefers-color-scheme` | space
`prefers-contrast: more` | space
`data-scheme` (attribute) | space
`SCHEME_COLORS` | (see source: endo-but-for-bots--llm-designs-chat-high-contrast-mode)
`validateSpaceConfig` | space
`applyScheme` | space
`HOME_SPACE_DEFAULTS` | space
scheme picker | space
`scheme-picker.js` | space
endojs.org brand palette | (see source: endo-but-for-bots--llm-designs-chat-color-schemes)
dual-selector CSS pattern | space
brand-derived palette | (see source: endo-but-for-bots--llm-designs-chat-color-schemes)
shadows-to-borders substitution | (see source: endo-but-for-bots--llm-designs-chat-high-contrast-mode)
substitution of channel | (see source: endo-but-for-bots--llm-designs-chat-high-contrast-mode)
combined media query | (see source: endo-but-for-bots--llm-designs-chat-high-contrast-mode)
mechanical-refactor-then-feature | (see source: endo-but-for-bots--llm-designs-chat-color-schemes)
scheme-aware tokens with intentional exceptions | (see source: endo-but-for-bots--llm-designs-chat-color-schemes)
factor-out-the-orthogonal-axis | (see source: endo-but-for-bots--llm-designs-chat-high-contrast-mode)
ship-with-acknowledged-gaps | (see source: endo-but-for-bots--llm-designs-chat-high-contrast-mode)
Monaco iframe theme bridge | (see source: endo-but-for-bots--llm-designs-chat-color-schemes)
`set-theme` postMessage | (see source: endo-but-for-bots--llm-designs-chat-color-schemes)
SpaceConfig fragmentation | space
`channelPetName` | space
`viewMode` | space
`channelOrder` | space
`bookmarks` (SpaceConfig field) | space
`whylipSystemPrompt` | space
`proposedName` | space
`ownedPersona` | space
`lastChannelPetName` | space

## Capability theory (Miller-Yee-Shapiro 2003)

object capability | object-capability
object-capability | object-capability
object-capability model | object-capability
ocap | object-capability
OCAP | object-capability
pure capability | object-capability
true capability model | object-capability
Model 4 | object-capability
Model 3 | object-capability
Model 2 | object-capability
Model 1 | object-capability
capabilities as keys | (see section: papers--miller-capability-myths-demolished-2003--four-models-and-seven-properties)
capabilities as rows | (see section: papers--miller-capability-myths-demolished-2003--equivalence-myth)
capabilities-as-keys | (see section: papers--miller-capability-myths-demolished-2003--four-models-and-seven-properties)
capabilities-as-rows | (see section: papers--miller-capability-myths-demolished-2003--equivalence-myth)
ACLs as columns | (see section: papers--miller-capability-myths-demolished-2003--equivalence-myth)
ACL system | (see section: papers--miller-capability-myths-demolished-2003--equivalence-myth)
access control list | (see section: papers--miller-capability-myths-demolished-2003--equivalence-myth)
access matrix | (see section: papers--miller-capability-myths-demolished-2003--equivalence-myth)
Lampson access matrix | (see section: papers--miller-capability-myths-demolished-2003--equivalence-myth)
Equivalence Myth | (see section: papers--miller-capability-myths-demolished-2003--equivalence-myth)
Confinement Myth | (see section: papers--miller-capability-myths-demolished-2003--confinement-myth)
Irrevocability Myth | (see section: papers--miller-capability-myths-demolished-2003--irrevocability-myth)
Delegation Myth | (see section: papers--miller-capability-myths-demolished-2003--four-models-and-seven-properties)
No Designation Without Authority | object-capability
Property A | object-capability
Dynamic Subject Creation | object-capability
Property B | object-capability
Subject-Aggregated Authority Management | object-capability
Property C | object-capability
No Ambient Authority | object-capability
Property D | object-capability
Composability of Authorities | object-capability
Property E | object-capability
Access-Controlled Delegation Channels | object-capability
Property F | object-capability
Dynamic Resource Creation | object-capability
Property G | object-capability
ambient authority | object-capability
no ambient authority | object-capability
principle of least privilege | (see section: papers--miller-capability-myths-demolished-2003--advantages-pola-confused-deputy)
principle of least authority | (see section: papers--miller-capability-myths-demolished-2003--advantages-pola-confused-deputy)
POLA | (see section: papers--miller-capability-myths-demolished-2003--advantages-pola-confused-deputy)
least privilege | (see section: papers--miller-capability-myths-demolished-2003--advantages-pola-confused-deputy)
confused deputy | (see section: papers--miller-capability-myths-demolished-2003--advantages-pola-confused-deputy)
confused deputy problem | (see section: papers--miller-capability-myths-demolished-2003--advantages-pola-confused-deputy)
unconfusable deputy | (see section: papers--miller-capability-myths-demolished-2003--advantages-pola-confused-deputy)
chain of designation | (see section: papers--miller-capability-myths-demolished-2003--advantages-pola-confused-deputy)
forwarder revoker | caretaker-pattern
forwarder/revoker | caretaker-pattern
forwarding facet | caretaker-pattern
revoking facet | caretaker-pattern
facet | caretaker-pattern
Redell 1974 | caretaker-pattern
KeyKOS | (see section: papers--miller-capability-myths-demolished-2003--four-models-and-seven-properties)
EROS | (see section: papers--miller-capability-myths-demolished-2003--four-models-and-seven-properties)
KeyKOS factories | (see section: papers--miller-capability-myths-demolished-2003--confinement-myth)
Boebert | (see section: papers--miller-capability-myths-demolished-2003--confinement-myth)
*-Property | (see section: papers--miller-capability-myths-demolished-2003--confinement-myth)
star property | (see section: papers--miller-capability-myths-demolished-2003--confinement-myth)
Simple Security Property | (see section: papers--miller-capability-myths-demolished-2003--confinement-myth)
POSIX capabilities | (see section: papers--miller-capability-myths-demolished-2003--four-models-and-seven-properties)
SPKI | (see section: papers--miller-capability-myths-demolished-2003--four-models-and-seven-properties)
password capability | (see section: papers--miller-capability-myths-demolished-2003--confinement-myth)
Amoeba | (see section: papers--miller-capability-myths-demolished-2003--confinement-myth)
Saltzer Schroeder | (see section: papers--miller-capability-myths-demolished-2003--advantages-pola-confused-deputy)
Saltzer & Schroeder | (see section: papers--miller-capability-myths-demolished-2003--advantages-pola-confused-deputy)
Hardy confused deputy | (see section: papers--miller-capability-myths-demolished-2003--advantages-pola-confused-deputy)
Capability Myths Demolished | (see source: papers--miller-capability-myths-demolished-2003)
Miller Yee Shapiro | (see source: papers--miller-capability-myths-demolished-2003)
Mark Miller | (see source: papers--miller-capability-myths-demolished-2003)
Ka-Ping Yee | (see source: papers--miller-capability-myths-demolished-2003)
Jonathan Shapiro | (see source: papers--miller-capability-myths-demolished-2003)
SRL2003-02 | (see source: papers--miller-capability-myths-demolished-2003)

## Chat Markdown rendering (chat-markdown-render, cycle 64)

`@endo/markmdown` | (see source: endo-but-for-bots--llm-designs-chat-markdown-render)
markmdown | (see source: endo-but-for-bots--llm-designs-chat-markdown-render)
markdown rendering | (see source: endo-but-for-bots--llm-designs-chat-markdown-render)
markdown parser | (see source: endo-but-for-bots--llm-designs-chat-markdown-render)
CommonMark | (see source: endo-but-for-bots--llm-designs-chat-markdown-render)
CommonMark alignment | (see section: endo-but-for-bots--llm-designs-chat-markdown-render--delimiter-realignment-and-flanking-rules)
GFM | (see source: endo-but-for-bots--llm-designs-chat-markdown-render)
GitHub-Flavored Markdown | (see source: endo-but-for-bots--llm-designs-chat-markdown-render)
flanking delimiter run | (see section: endo-but-for-bots--llm-designs-chat-markdown-render--delimiter-realignment-and-flanking-rules)
left-flanking | (see section: endo-but-for-bots--llm-designs-chat-markdown-render--delimiter-realignment-and-flanking-rules)
right-flanking | (see section: endo-but-for-bots--llm-designs-chat-markdown-render--delimiter-realignment-and-flanking-rules)
intraword underscore | (see section: endo-but-for-bots--llm-designs-chat-markdown-render--delimiter-realignment-and-flanking-rules)
delimiter stack | (see section: endo-but-for-bots--llm-designs-chat-markdown-render--delimiter-realignment-and-flanking-rules)
state-machine scanner | (see section: endo-but-for-bots--llm-designs-chat-markdown-render--delimiter-realignment-and-flanking-rules)
`parseInline` | (see section: endo-but-for-bots--llm-designs-chat-markdown-render--delimiter-realignment-and-flanking-rules)
`parseBlocks` | (see section: endo-but-for-bots--llm-designs-chat-markdown-render--package-extraction-and-typed-ast)
`renderBlocks` | (see section: endo-but-for-bots--llm-designs-chat-markdown-render--package-extraction-and-typed-ast)
`renderInlineTokens` | (see section: endo-but-for-bots--llm-designs-chat-markdown-render--package-extraction-and-typed-ast)
multi-backtick code span | (see section: endo-but-for-bots--llm-designs-chat-markdown-render--delimiter-realignment-and-flanking-rules)
N-character code fence | (see section: endo-but-for-bots--llm-designs-chat-markdown-render--delimiter-realignment-and-flanking-rules)
backslash escape | (see section: endo-but-for-bots--llm-designs-chat-markdown-render--delimiter-realignment-and-flanking-rules)
backslash escapes | (see section: endo-but-for-bots--llm-designs-chat-markdown-render--delimiter-realignment-and-flanking-rules)
inline nesting | (see section: endo-but-for-bots--llm-designs-chat-markdown-render--delimiter-realignment-and-flanking-rules)
escape sequences (Markdown) | (see section: endo-but-for-bots--llm-designs-chat-markdown-render--delimiter-realignment-and-flanking-rules)
GFM tables | (see section: endo-but-for-bots--llm-designs-chat-markdown-render--motivation-and-gap-analysis)
table block (Markdown) | (see section: endo-but-for-bots--llm-designs-chat-markdown-render--motivation-and-gap-analysis)
chip slot placeholder | (see section: endo-but-for-bots--llm-designs-chat-markdown-render--package-extraction-and-typed-ast)
Private Use Area character | (see section: endo-but-for-bots--llm-designs-chat-markdown-render--package-extraction-and-typed-ast)
`md-chip-slot` | (see section: endo-but-for-bots--llm-designs-chat-markdown-render--package-extraction-and-typed-ast)
`md-table` | (see section: endo-but-for-bots--llm-designs-chat-markdown-render--motivation-and-gap-analysis)
`md-link` | (see section: endo-but-for-bots--llm-designs-chat-markdown-render--render-mode-toggle-and-phased-rollout)
HighlightCode callback | (see section: endo-but-for-bots--llm-designs-chat-markdown-render--package-extraction-and-typed-ast)
code highlighter injection | (see section: endo-but-for-bots--llm-designs-chat-markdown-render--package-extraction-and-typed-ast)
DI for code highlighting | (see section: endo-but-for-bots--llm-designs-chat-markdown-render--package-extraction-and-typed-ast)
happy-dom | (see section: endo-but-for-bots--llm-designs-chat-markdown-render--package-extraction-and-typed-ast)
md/html fixture pair | (see section: endo-but-for-bots--llm-designs-chat-markdown-render--package-extraction-and-typed-ast)
fixture-driven testing | (see section: endo-but-for-bots--llm-designs-chat-markdown-render--package-extraction-and-typed-ast)
render mode toggle | (see section: endo-but-for-bots--llm-designs-chat-markdown-render--render-mode-toggle-and-phased-rollout)
per-message render mode | (see section: endo-but-for-bots--llm-designs-chat-markdown-render--render-mode-toggle-and-phased-rollout)
Markdown / Literal / Preformatted | (see section: endo-but-for-bots--llm-designs-chat-markdown-render--render-mode-toggle-and-phased-rollout)
timestamp tooltip toggle | (see section: endo-but-for-bots--llm-designs-chat-markdown-render--render-mode-toggle-and-phased-rollout)
soft break | (see section: endo-but-for-bots--llm-designs-chat-markdown-render--delimiter-realignment-and-flanking-rules)
hard break | (see section: endo-but-for-bots--llm-designs-chat-markdown-render--delimiter-realignment-and-flanking-rules)
visually-invisible phase | (see section: endo-but-for-bots--llm-designs-chat-markdown-render--render-mode-toggle-and-phased-rollout)
phased rollout | (see section: endo-but-for-bots--llm-designs-chat-markdown-render--render-mode-toggle-and-phased-rollout)
gap analysis (design shape) | (see section: endo-but-for-bots--llm-designs-chat-markdown-render--motivation-and-gap-analysis)
`HandledPromise` | (see section: endo--packages-eventual-send-src-handled-promise-js--forwarding-forest-union-find)
`makeHandledPromise` | (see section: endo--packages-eventual-send-src-handled-promise-js--forwarding-forest-union-find)
handled promise | (see section: endo--packages-eventual-send-src-handled-promise-js--forwarding-forest-union-find)
`shorten` | (see section: endo--packages-eventual-send-src-handled-promise-js--forwarding-forest-union-find)
`forwardedPromiseToPromise` | (see section: endo--packages-eventual-send-src-handled-promise-js--forwarding-forest-union-find)
`promiseToPendingHandler` | (see section: endo--packages-eventual-send-src-handled-promise-js--forwarding-forest-union-find)
`promiseToPresence` | (see section: endo--packages-eventual-send-src-handled-promise-js--forwarding-forest-union-find)
`presenceToHandler` | (see section: endo--packages-eventual-send-src-handled-promise-js--forwarding-forest-union-find)
`presenceToPromise` | (see section: endo--packages-eventual-send-src-handled-promise-js--forwarding-forest-union-find)
union-find | (see section: endo--packages-eventual-send-src-handled-promise-js--forwarding-forest-union-find)
union-find forest | (see section: endo--packages-eventual-send-src-handled-promise-js--forwarding-forest-union-find)
path splitting | (see section: endo--packages-eventual-send-src-handled-promise-js--forwarding-forest-union-find)
disjoint-set data structure | (see section: endo--packages-eventual-send-src-handled-promise-js--forwarding-forest-union-find)
forwarding graph | (see section: endo--packages-eventual-send-src-handled-promise-js--forwarding-forest-union-find)
forwarding forest | (see section: endo--packages-eventual-send-src-handled-promise-js--forwarding-forest-union-find)
promise forwarding | (see section: endo--packages-eventual-send-src-handled-promise-js--forwarding-forest-union-find)
forwarded promise | (see section: endo--packages-eventual-send-src-handled-promise-js--forwarding-forest-union-find)
pending handler | (see section: endo--packages-eventual-send-src-handled-promise-js--forwarding-forest-union-find)
`isSafePromise` | (see section: endo--packages-eventual-send-src-handled-promise-js--safe-vs-passable-promise)
safe promise | (see section: endo--packages-eventual-send-src-handled-promise-js--safe-vs-passable-promise)
passable promise | (see section: endo--packages-eventual-send-src-handled-promise-js--safe-vs-passable-promise)
reentrancy attack | (see section: endo--packages-eventual-send-src-handled-promise-js--safe-vs-passable-promise)
promise reentrancy | (see section: endo--packages-eventual-send-src-handled-promise-js--safe-vs-passable-promise)
`HandledPromise.resolve` | (see section: endo--packages-eventual-send-src-handled-promise-js--safe-vs-passable-promise)
promise safety check | (see section: endo--packages-eventual-send-src-handled-promise-js--safe-vs-passable-promise)
`dispatchToHandler` | (see section: endo--packages-eventual-send-src-handled-promise-js--operation-reduction-and-sendonly)
operation reduction | (see section: endo--packages-eventual-send-src-handled-promise-js--operation-reduction-and-sendonly)
handler protocol | (see section: endo--packages-eventual-send-src-handled-promise-js--operation-reduction-and-sendonly)
handler operation | (see section: endo--packages-eventual-send-src-handled-promise-js--operation-reduction-and-sendonly)
minimum handler | (see section: endo--packages-eventual-send-src-handled-promise-js--operation-reduction-and-sendonly)
minimum viable handler | (see section: endo--packages-eventual-send-src-handled-promise-js--operation-reduction-and-sendonly)
`applyMethod` | (see section: endo--packages-eventual-send-src-handled-promise-js--operation-reduction-and-sendonly)
`applyFunction` | (see section: endo--packages-eventual-send-src-handled-promise-js--operation-reduction-and-sendonly)
`applyMethodSendOnly` | (see section: endo--packages-eventual-send-src-handled-promise-js--operation-reduction-and-sendonly)
`applyFunctionSendOnly` | (see section: endo--packages-eventual-send-src-handled-promise-js--operation-reduction-and-sendonly)
`getSendOnly` | (see section: endo--packages-eventual-send-src-handled-promise-js--operation-reduction-and-sendonly)
SendOnly | (see section: endo--packages-eventual-send-src-handled-promise-js--operation-reduction-and-sendonly)
SendOnly variant | (see section: endo--packages-eventual-send-src-handled-promise-js--operation-reduction-and-sendonly)
`SEND_ONLY_RE` | (see section: endo--packages-eventual-send-src-handled-promise-js--operation-reduction-and-sendonly)
forwardingHandler | (see section: endo--packages-eventual-send-src-handled-promise-js--operation-reduction-and-sendonly)
nanoq | (see source: endo--packages-eventual-send-src-handled-promise-js--handler-protocol)
infix-bang | (see source: endo--packages-eventual-send-src-handled-promise-js--handler-protocol)
wavy-dot | (see source: endo--packages-eventual-send-src-handled-promise-js--handler-protocol)
promise pipelining | promise-pipelining
pipelined eventual-send | promise-pipelining
`E(E(x).foo()).bar()` | promise-pipelining
round-trip elimination | promise-pipelining
answer slot | promise-pipelining
`<desc:answer>` | promise-pipelining
pipelined message send | promise-pipelining

## Chat edit-message UI (chat-edit-message-ui, cycle 68)

`editMessage` | (see source: endo-but-for-bots--llm-designs-chat-edit-message-ui)
`messageHistory` | (see source: endo-but-for-bots--llm-designs-chat-edit-message-ui)
edit message | (see source: endo-but-for-bots--llm-designs-chat-edit-message-ui)
edit affordance | (see source: endo-but-for-bots--llm-designs-chat-edit-message-ui)
chat edit | (see source: endo-but-for-bots--llm-designs-chat-edit-message-ui)
/edit | (see source: endo-but-for-bots--llm-designs-chat-edit-message-ui)
`/edit` | (see source: endo-but-for-bots--llm-designs-chat-edit-message-ui)
edit slash command | (see source: endo-but-for-bots--llm-designs-chat-edit-message-ui)
e shortcut | (see section: endo-but-for-bots--llm-designs-chat-edit-message-ui--problem-and-authority)
hover pencil | (see section: endo-but-for-bots--llm-designs-chat-edit-message-ui--problem-and-authority)
pencil button | (see section: endo-but-for-bots--llm-designs-chat-edit-message-ui--problem-and-authority)
sender-only edit authority | (see section: endo-but-for-bots--llm-designs-chat-edit-message-ui--problem-and-authority)
revision panel | (see section: endo-but-for-bots--llm-designs-chat-edit-message-ui--in-flight-and-revision-history)
revision history | (see section: endo-but-for-bots--llm-designs-chat-edit-message-ui--in-flight-and-revision-history)
edited caption | (see section: endo-but-for-bots--llm-designs-chat-edit-message-ui--in-flight-and-revision-history)
edited timestamp | (see section: endo-but-for-bots--llm-designs-chat-edit-message-ui--in-flight-and-revision-history)
edit in flight | (see section: endo-but-for-bots--llm-designs-chat-edit-message-ui--in-flight-and-revision-history)
racing edits | (see section: endo-but-for-bots--llm-designs-chat-edit-message-ui--in-flight-and-revision-history)
last edit wins | (see section: endo-but-for-bots--llm-designs-chat-edit-message-ui--in-flight-and-revision-history)
saving affordance | (see section: endo-but-for-bots--llm-designs-chat-edit-message-ui--in-flight-and-revision-history)
chip carries locator | token-chip
locator-bearing chip | token-chip
chat parity gap | (see section: endo-but-for-bots--llm-designs-chat-edit-message-ui--design-decisions)
proposed name | (see section: endo-but-for-bots--llm-designs-chat-edit-message-ui--design-decisions)
indefinite edit window | (see section: endo-but-for-bots--llm-designs-chat-edit-message-ui--design-decisions)
pre-populate from model | (see section: endo-but-for-bots--llm-designs-chat-edit-message-ui--design-decisions)
