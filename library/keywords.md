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
pending commands region | (see source: endo-but-for-bots--llm-designs-chat-pending-commands)
chat pending commands | (see source: endo-but-for-bots--llm-designs-chat-pending-commands)
indeterminate spinner | (see section: endo-but-for-bots--llm-designs-chat-pending-commands--motivation-and-problems)
blocked command bar | (see section: endo-but-for-bots--llm-designs-chat-pending-commands--motivation-and-problems)
asymmetric command record | (see section: endo-but-for-bots--llm-designs-chat-pending-commands--motivation-and-problems)
asymmetric record | (see section: endo-but-for-bots--llm-designs-chat-pending-commands--motivation-and-problems)
no command history | (see section: endo-but-for-bots--llm-designs-chat-pending-commands--motivation-and-problems)
`executeWithSpinner` | (see section: endo-but-for-bots--llm-designs-chat-pending-commands--unlocking-and-concurrent-commands)
`setCommandSubmitting` | (see section: endo-but-for-bots--llm-designs-chat-pending-commands--unlocking-and-concurrent-commands)
dispatch-then-release | (see section: endo-but-for-bots--llm-designs-chat-pending-commands--unlocking-and-concurrent-commands)
concurrent commands | (see section: endo-but-for-bots--llm-designs-chat-pending-commands--unlocking-and-concurrent-commands)
rename-after-adopt | (see section: endo-but-for-bots--llm-designs-chat-pending-commands--unlocking-and-concurrent-commands)
pending card | (see section: endo-but-for-bots--llm-designs-chat-pending-commands--pending-region-and-card-states)
show result affordance | (see section: endo-but-for-bots--llm-designs-chat-pending-commands--pending-region-and-card-states)
commands as messages | (see section: endo-but-for-bots--llm-designs-chat-pending-commands--relationship-to-commands-as-messages)
daemon-commands-as-messages | (see section: endo-but-for-bots--llm-designs-chat-pending-commands--relationship-to-commands-as-messages)
self-addressed messages | (see section: endo-but-for-bots--llm-designs-chat-pending-commands--relationship-to-commands-as-messages)
near-term UI vs invasive daemon change | (see section: endo-but-for-bots--llm-designs-chat-pending-commands--relationship-to-commands-as-messages)
dual-positioning | (see section: endo-but-for-bots--llm-designs-chat-pending-commands--relationship-to-commands-as-messages)
errors deserve attention | (see section: endo-but-for-bots--llm-designs-chat-pending-commands--pending-region-and-card-states)
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

## Smallcaps encoding (encodeToSmallcaps.js, cycle 69)

smallcaps | smallcaps-encoding
Smallcaps | smallcaps-encoding
smallcaps encoding | smallcaps-encoding
Smallcaps Encoding | smallcaps-encoding
smallcaps wire format | smallcaps-encoding
smallcaps prefix scheme | smallcaps-encoding
smallcaps special characters | smallcaps-encoding
smallcaps cheatsheet | smallcaps-encoding
`encodeToSmallcaps` | smallcaps-encoding
`decodeFromSmallcaps` | smallcaps-encoding
`makeEncodeToSmallcaps` | smallcaps-encoding
`makeDecodeFromSmallcaps` | smallcaps-encoding
`startsSpecial` | (see section: endo--packages-marshal-src-encodetosmallcaps-js--special-character-prefix-scheme)
BANG to DASH range | smallcaps-encoding
reserved characters | smallcaps-encoding
sigil character | smallcaps-encoding
capdata | smallcaps-encoding
`@qclass` | smallcaps-encoding
qclass | smallcaps-encoding
manifest constant | smallcaps-encoding
`#undefined` | smallcaps-encoding
`#NaN` | smallcaps-encoding
`#Infinity` | smallcaps-encoding
`#-Infinity` | smallcaps-encoding
`#tag` | smallcaps-encoding
`#error` | smallcaps-encoding
Hilbert hotel | (see section: endo--packages-marshal-src-encodetosmallcaps-js--special-character-prefix-scheme)
Hilbert hotel string escape | (see section: endo--packages-marshal-src-encodetosmallcaps-js--special-character-prefix-scheme)
canonical encoding | (see section: endo--packages-marshal-src-encodetosmallcaps-js--canonical-encoding-invariants)
canonical smallcaps encoding | (see section: endo--packages-marshal-src-encodetosmallcaps-js--canonical-encoding-invariants)
copyRecord key sort | (see section: endo--packages-marshal-src-encodetosmallcaps-js--canonical-encoding-invariants)
canonical-JSON | (see section: endo--packages-marshal-src-encodetosmallcaps-js--canonical-encoding-invariants)
JCS canonical JSON | (see section: endo--packages-marshal-src-encodetosmallcaps-js--canonical-encoding-invariants)
error-encoding root special case | (see section: endo--packages-marshal-src-encodetosmallcaps-js--error-encoding-root-special-case)
`isErrorLike` | (see section: endo--packages-marshal-src-encodetosmallcaps-js--error-encoding-root-special-case)
`encodeErrorToSmallcaps` | (see section: endo--packages-marshal-src-encodetosmallcaps-js--error-encoding-root-special-case)
diagnostic-information priority | (see section: endo--packages-marshal-src-encodetosmallcaps-js--error-encoding-root-special-case)
pass-by-copy | (see source: endo--pkg-marshal-readme)
pass-by-presence | (see source: endo--pkg-marshal-readme)
jsonable | (see section: endo--pkg-marshal-readme--alternative-to-json)
JSON-representable | smallcaps-encoding
SmallcapsEncoding | smallcaps-encoding
tagged record | (see section: endo--pkg-pass-style-readme--maketagged)

# Concept-page additions, 2026-05-21 (Miller-cluster concept-page batch)
POLA | principle-of-least-authority
principle of least authority | principle-of-least-authority
principle of least privilege | principle-of-least-authority
least privilege | principle-of-least-authority
least authority | principle-of-least-authority
least-authority | principle-of-least-authority
Saltzer-Schroeder least privilege | principle-of-least-authority
need to do | principle-of-least-authority
need-to-do basis | principle-of-least-authority
authority-driven design | principle-of-least-authority
permission-vs-authority | (see section: papers--miller-shapiro-paradigm-regained-2003--permission-vs-authority-and-cp-versus-cat)
de facto access | (see section: papers--miller-shapiro-paradigm-regained-2003--permission-vs-authority-and-cp-versus-cat)
de jure access | (see section: papers--miller-shapiro-paradigm-regained-2003--permission-vs-authority-and-cp-versus-cat)
arrangement-only bound | (see section: papers--miller-shapiro-paradigm-regained-2003--permission-vs-authority-and-cp-versus-cat)
partially behavioral bound | (see section: papers--miller-shapiro-paradigm-regained-2003--permission-vs-authority-and-cp-versus-cat)
cp foo.txt bar.txt | (see section: papers--miller-shapiro-paradigm-regained-2003--permission-vs-authority-and-cp-versus-cat)
cat < foo.txt > bar.txt | (see section: papers--miller-shapiro-paradigm-regained-2003--permission-vs-authority-and-cp-versus-cat)
designation determines authority | (see section: papers--miller-shapiro-paradigm-regained-2003--permission-vs-authority-and-cp-versus-cat)
four ways to acquire references | four-ways-to-acquire-references
Introduction (capability mechanism) | four-ways-to-acquire-references
Parenthood (capability mechanism) | four-ways-to-acquire-references
Endowment (capability mechanism) | four-ways-to-acquire-references
Initial Conditions (capability mechanism) | four-ways-to-acquire-references
only connectivity begets connectivity | four-ways-to-acquire-references
ways B can come to know about C | four-ways-to-acquire-references
reference graph is the access graph | four-ways-to-acquire-references
security as extreme modularity | security-as-extreme-modularity
Table 1 (Structure of Authority) | security-as-extreme-modularity
abstraction as protection | security-as-extreme-modularity
modularity gives access control for free | security-as-extreme-modularity
the lost paradigm | security-as-extreme-modularity
nested POLA | security-as-extreme-modularity
multiplicative attack-surface reduction | security-as-extreme-modularity
spawning tree (nested TCBs) | security-as-extreme-modularity
forbid mutable static state | security-as-extreme-modularity
no global name spaces | security-as-extreme-modularity
say what you mean / mean only what you say | security-as-extreme-modularity
patterns of safe cooperation | security-as-extreme-modularity
Redell's Caretaker | caretaker-pattern
caretakerMaker | caretaker-pattern
carol2Rvkr | caretaker-pattern
filtering facet | caretaker-pattern
factory + factoryMaker | (see section: papers--miller-shapiro-paradigm-regained-2003--access-abstraction-and-confinement)
FactoryStamp | (see section: papers--miller-shapiro-paradigm-regained-2003--access-abstraction-and-confinement)
Cassie + Max | (see section: papers--miller-shapiro-paradigm-regained-2003--access-abstraction-and-confinement)
trademark guard | (see section: papers--miller-shapiro-paradigm-regained-2003--access-abstraction-and-confinement)
controlled subject | (see section: papers--miller-shapiro-paradigm-regained-2003--access-abstraction-and-confinement)
uncontrolled subject | (see section: papers--miller-shapiro-paradigm-regained-2003--access-abstraction-and-confinement)
non-discretionary capabilities | (see section: papers--miller-shapiro-paradigm-regained-2003--access-abstraction-and-confinement)
Boebert 1984 | (see section: papers--miller-shapiro-paradigm-regained-2003--access-abstraction-and-confinement)
*-property | (see section: papers--miller-shapiro-paradigm-regained-2003--access-abstraction-and-confinement)
star-property | (see section: papers--miller-shapiro-paradigm-regained-2003--access-abstraction-and-confinement)
data diode | (see section: papers--miller-shapiro-paradigm-regained-2003--access-abstraction-and-confinement)
diodeWriter | (see section: papers--miller-shapiro-paradigm-regained-2003--access-abstraction-and-confinement)
diodeReader | (see section: papers--miller-shapiro-paradigm-regained-2003--access-abstraction-and-confinement)
arena | (see section: papers--miller-shapiro-paradigm-regained-2003--arena-terms-of-entry-and-mutually-suspicious-composition)
terms of entry | (see section: papers--miller-shapiro-paradigm-regained-2003--arena-terms-of-entry-and-mutually-suspicious-composition)
meta-linguistic abstraction | (see section: papers--miller-shapiro-paradigm-regained-2003--arena-terms-of-entry-and-mutually-suspicious-composition)
virtual machine within a virtual machine | (see section: papers--miller-shapiro-paradigm-regained-2003--arena-terms-of-entry-and-mutually-suspicious-composition)
mutually suspicious composition | (see section: papers--miller-shapiro-paradigm-regained-2003--arena-terms-of-entry-and-mutually-suspicious-composition)
diverse policies over the same graph | (see section: papers--miller-shapiro-paradigm-regained-2003--arena-terms-of-entry-and-mutually-suspicious-composition)
failures of conservatism | (see section: papers--miller-shapiro-paradigm-regained-2003--arena-terms-of-entry-and-mutually-suspicious-composition)
the lost paradigm restored | (see section: papers--miller-shapiro-paradigm-regained-2003--arena-terms-of-entry-and-mutually-suspicious-composition)
more cooperation with less vulnerability | (see section: papers--miller-shapiro-paradigm-regained-2003--arena-terms-of-entry-and-mutually-suspicious-composition)
pointMaker | (see section: papers--miller-shapiro-paradigm-regained-2003--object-capability-model-and-redells-caretaker)
loader.load | (see section: papers--miller-shapiro-paradigm-regained-2003--object-capability-model-and-redells-caretaker)
Dennis and van Horn 1966 | (see section: papers--miller-shapiro-paradigm-regained-2003--object-capability-model-and-redells-caretaker)
DVH | (see section: papers--miller-shapiro-paradigm-regained-2003--object-capability-model-and-redells-caretaker)
Karger-Herbert 1984 | (see section: papers--miller-shapiro-paradigm-regained-2003--object-capability-model-and-redells-caretaker)
Chander-Dean-Mitchell | (see section: papers--miller-shapiro-paradigm-regained-2003--object-capability-model-and-redells-caretaker)
pinchtab | pinchtab
PinchTab | pinchtab
PINCHTAB_TOKEN | pinchtab
pinchtab server | pinchtab
pinchtab bridge | pinchtab
accessibility tree with stable refs | pinchtab
`e0`, `e1` (PinchTab refs) | pinchtab
Browser capability backend | pinchtab

## Chat /view and /edit commands (chat-view-edit-commands, cycle 70)

/view | (see source: endo-but-for-bots--llm-designs-chat-view-edit-commands)
`/view` | (see source: endo-but-for-bots--llm-designs-chat-view-edit-commands)
view command | (see source: endo-but-for-bots--llm-designs-chat-view-edit-commands)
view slash command | (see source: endo-but-for-bots--llm-designs-chat-view-edit-commands)
blob viewer | (see section: endo-but-for-bots--llm-designs-chat-view-edit-commands--commands-viewer-editor-and-panel-layout)
blob editor | (see section: endo-but-for-bots--llm-designs-chat-view-edit-commands--commands-viewer-editor-and-panel-layout)
edit blob | (see section: endo-but-for-bots--llm-designs-chat-view-edit-commands--commands-viewer-editor-and-panel-layout)
edit blob content | (see section: endo-but-for-bots--llm-designs-chat-view-edit-commands--commands-viewer-editor-and-panel-layout)
blob-leaf gap | (see section: endo-but-for-bots--llm-designs-chat-view-edit-commands--problem-and-blob-access-gap)
inventory blob gap | (see section: endo-but-for-bots--llm-designs-chat-view-edit-commands--problem-and-blob-access-gap)
`endo cat` | (see section: endo-but-for-bots--llm-designs-chat-view-edit-commands--problem-and-blob-access-gap)
v focus shortcut | (see section: endo-but-for-bots--llm-designs-chat-view-edit-commands--loading-blob-content-and-focus-mode)
`v` focus shortcut | (see section: endo-but-for-bots--llm-designs-chat-view-edit-commands--loading-blob-content-and-focus-mode)
focus mode v | (see section: endo-but-for-bots--llm-designs-chat-view-edit-commands--loading-blob-content-and-focus-mode)
content type from extension | (see section: endo-but-for-bots--llm-designs-chat-view-edit-commands--phases-dependencies-and-design-decisions)
content-type from extension | (see section: endo-but-for-bots--llm-designs-chat-view-edit-commands--phases-dependencies-and-design-decisions)
extension-based content type | (see section: endo-but-for-bots--llm-designs-chat-view-edit-commands--phases-dependencies-and-design-decisions)
extension-as-content-type | (see section: endo-but-for-bots--llm-designs-chat-view-edit-commands--phases-dependencies-and-design-decisions)
extension-based language mode | (see section: endo-but-for-bots--llm-designs-chat-view-edit-commands--phases-dependencies-and-design-decisions)
immutable blob save as new | (see section: endo-but-for-bots--llm-designs-chat-view-edit-commands--commands-viewer-editor-and-panel-layout)
save as new blob | (see section: endo-but-for-bots--llm-designs-chat-view-edit-commands--commands-viewer-editor-and-panel-layout)
save-as-new immutability | (see section: endo-but-for-bots--llm-designs-chat-view-edit-commands--commands-viewer-editor-and-panel-layout)
content-addressed immutability | (see section: endo-but-for-bots--llm-designs-chat-view-edit-commands--commands-viewer-editor-and-panel-layout)
new readable-blob formula | (see section: endo-but-for-bots--llm-designs-chat-view-edit-commands--commands-viewer-editor-and-panel-layout)
`readable-blob` formula | (see section: endo-but-for-bots--llm-designs-chat-view-edit-commands--commands-viewer-editor-and-panel-layout)
Monaco read-only viewer | (see section: endo-but-for-bots--llm-designs-chat-view-edit-commands--commands-viewer-editor-and-panel-layout)
Monaco JSON mode | (see section: endo-but-for-bots--llm-designs-chat-view-edit-commands--commands-viewer-editor-and-panel-layout)
markdown synchronized preview | (see section: endo-but-for-bots--llm-designs-chat-view-edit-commands--markdown-synchronized-render-panel)
synchronized scroll preview | (see section: endo-but-for-bots--llm-designs-chat-view-edit-commands--markdown-synchronized-render-panel)
markdown split view | (see section: endo-but-for-bots--llm-designs-chat-view-edit-commands--markdown-synchronized-render-panel)
side-by-side markdown editor | (see section: endo-but-for-bots--llm-designs-chat-view-edit-commands--markdown-synchronized-render-panel)
line-to-element mapping | (see section: endo-but-for-bots--llm-designs-chat-view-edit-commands--markdown-synchronized-render-panel)
modal overlay vs embedded panel | (see section: endo-but-for-bots--llm-designs-chat-view-edit-commands--phases-dependencies-and-design-decisions)
Monaco reuse | (see section: endo-but-for-bots--llm-designs-chat-view-edit-commands--phases-dependencies-and-design-decisions)
`text()` blob read | (see section: endo-but-for-bots--llm-designs-chat-view-edit-commands--loading-blob-content-and-focus-mode)
`write()` parent directory save | (see section: endo-but-for-bots--llm-designs-chat-view-edit-commands--loading-blob-content-and-focus-mode)
`lookup()` tree path walk | (see section: endo-but-for-bots--llm-designs-chat-view-edit-commands--loading-blob-content-and-focus-mode)
pet name path walk | (see section: endo-but-for-bots--llm-designs-chat-view-edit-commands--loading-blob-content-and-focus-mode)
`petNamePath` field type | (see section: endo-but-for-bots--llm-designs-chat-command-bar--field-types-and-autocomplete-mechanics)
ReadableBlob | (see section: endo-but-for-bots--llm-designs-chat-view-edit-commands--commands-viewer-editor-and-panel-layout)
`ReadableBlob` | (see section: endo-but-for-bots--llm-designs-chat-view-edit-commands--commands-viewer-editor-and-panel-layout)
SnapshotBlob | (see section: endo-but-for-bots--llm-designs-chat-view-edit-commands--commands-viewer-editor-and-panel-layout)
`SnapshotBlob` | (see section: endo-but-for-bots--llm-designs-chat-view-edit-commands--commands-viewer-editor-and-panel-layout)
ReadableTree | (see section: endo-but-for-bots--llm-designs-chat-view-edit-commands--commands-viewer-editor-and-panel-layout)
`ReadableTree` | (see section: endo-but-for-bots--llm-designs-chat-view-edit-commands--commands-viewer-editor-and-panel-layout)

## passStyleOf classifier internals (passStyleOf.js, cycle 71)

`passStyleOf` | (see section: endo--packages-pass-style-src-passstyleof-js--passstylememo-as-mutable-static-state)
passStyleOf | (see section: endo--packages-pass-style-src-passstyleof-js--passstylememo-as-mutable-static-state)
pass style classification | (see section: endo--packages-pass-style-src-passstyleof-js--passstylememo-as-mutable-static-state)
`passStyleMemo` | (see section: endo--packages-pass-style-src-passstyleof-js--passstylememo-as-mutable-static-state)
pass-style memo | (see section: endo--packages-pass-style-src-passstyleof-js--passstylememo-as-mutable-static-state)
`makePassStyleOf` | (see section: endo--packages-pass-style-src-passstyleof-js--passstylememo-as-mutable-static-state)
pass-style cache | (see section: endo--packages-pass-style-src-passstyleof-js--passstylememo-as-mutable-static-state)
static communications channel | (see section: endo--packages-pass-style-src-passstyleof-js--passstylememo-as-mutable-static-state)
proxy observability | (see section: endo--packages-pass-style-src-passstyleof-js--passstylememo-as-mutable-static-state)
mutable static state | security-as-extreme-modularity
forbid mutable static state | security-as-extreme-modularity
cycle detection during passable walk | (see section: endo--packages-pass-style-src-passstyleof-js--passstylememo-as-mutable-static-state)
`inProgress` Set | (see section: endo--packages-pass-style-src-passstyleof-js--passstylememo-as-mutable-static-state)
WeakSet vs Set | (see section: endo--packages-pass-style-src-passstyleof-js--passstylememo-as-mutable-static-state)
`PassStyleOfEndowmentSymbol` | (see section: endo--packages-pass-style-src-passstyleof-js--liveslots-endowment-and-gc-determinism)
PassStyleOfEndowmentSymbol | (see section: endo--packages-pass-style-src-passstyleof-js--liveslots-endowment-and-gc-determinism)
`Symbol.for('@endo passStyleOf')` | (see section: endo--packages-pass-style-src-passstyleof-js--liveslots-endowment-and-gc-determinism)
liveslots passStyleOf | (see section: endo--packages-pass-style-src-passstyleof-js--liveslots-endowment-and-gc-determinism)
liveslot delegation | (see section: endo--packages-pass-style-src-passstyleof-js--liveslots-endowment-and-gc-determinism)
classifier delegation | (see section: endo--packages-pass-style-src-passstyleof-js--liveslots-endowment-and-gc-determinism)
GC detection oracle | (see section: endo--packages-pass-style-src-passstyleof-js--liveslots-endowment-and-gc-determinism)
garbage-collection detector | (see section: endo--packages-pass-style-src-passstyleof-js--liveslots-endowment-and-gc-determinism)
detect GC | (see section: endo--packages-pass-style-src-passstyleof-js--liveslots-endowment-and-gc-determinism)
passStyleOf determinism | (see section: endo--packages-pass-style-src-passstyleof-js--liveslots-endowment-and-gc-determinism)
deterministic classifier | (see section: endo--packages-pass-style-src-passstyleof-js--liveslots-endowment-and-gc-determinism)
authority by substrate | (see section: endo--packages-pass-style-src-passstyleof-js--liveslots-endowment-and-gc-determinism)
install-on-global gate | (see section: endo--packages-pass-style-src-passstyleof-js--liveslots-endowment-and-gc-determinism)
virtualization-aware classifier | (see section: endo--packages-pass-style-src-passstyleof-js--liveslots-endowment-and-gc-determinism)
`toPassableError` | (see section: endo--packages-pass-style-src-passstyleof-js--coercion-to-passable-and-throwable)
toPassableError | (see section: endo--packages-pass-style-src-passstyleof-js--coercion-to-passable-and-throwable)
`toThrowable` | (see section: endo--packages-pass-style-src-passstyleof-js--coercion-to-passable-and-throwable)
toThrowable | (see section: endo--packages-pass-style-src-passstyleof-js--coercion-to-passable-and-throwable)
throwable | (see section: endo--packages-pass-style-src-passstyleof-js--coercion-to-passable-and-throwable)
throwables-only | (see section: endo--packages-pass-style-src-passstyleof-js--coercion-to-passable-and-throwable)
passable error | (see section: endo--packages-pass-style-src-passstyleof-js--coercion-to-passable-and-throwable)
diagnostic preservation | (see section: endo--packages-pass-style-src-passstyleof-js--coercion-to-passable-and-throwable)
diagnostic-information preservation | (see section: endo--packages-pass-style-src-passstyleof-js--coercion-to-passable-and-throwable)
copy-with-cause | (see section: endo--packages-pass-style-src-passstyleof-js--coercion-to-passable-and-throwable)
exo boundary throwable | (see section: endo--packages-pass-style-src-passstyleof-js--coercion-to-passable-and-throwable)
exo-boundary throwable | (see section: endo--packages-pass-style-src-passstyleof-js--coercion-to-passable-and-throwable)
PassableCap | (see section: endo--packages-pass-style-src-passstyleof-js--coercion-to-passable-and-throwable)
PassableCaps | (see section: endo--packages-pass-style-src-passstyleof-js--coercion-to-passable-and-throwable)
`isErrorLike` | (see section: endo--packages-pass-style-src-passstyleof-js--coercion-to-passable-and-throwable)
isErrorLike | (see section: endo--packages-pass-style-src-passstyleof-js--coercion-to-passable-and-throwable)
error-like value | (see section: endo--packages-pass-style-src-passstyleof-js--coercion-to-passable-and-throwable)
`confirmRecursivelyPassableError` | (see section: endo--packages-pass-style-src-passstyleof-js--coercion-to-passable-and-throwable)
`isPassable` | (see source: endo--packages-pass-style-src-passstyleof-js)
isPassable | (see source: endo--packages-pass-style-src-passstyleof-js)
`assertPassable` | (see source: endo--packages-pass-style-src-passstyleof-js)
assertPassable | (see source: endo--packages-pass-style-src-passstyleof-js)

# Focus message mode (chat-focus-message, cycle 73)

focus mode | (see section: endo-but-for-bots--llm-designs-chat-focus-message--motivation-entry-and-exit)
focus message mode | (see section: endo-but-for-bots--llm-designs-chat-focus-message--motivation-entry-and-exit)
chat focus mode | (see section: endo-but-for-bots--llm-designs-chat-focus-message--motivation-entry-and-exit)
deliberate-mode focus | (see section: endo-but-for-bots--llm-designs-chat-focus-message--motivation-entry-and-exit)
focused message | (see section: endo-but-for-bots--llm-designs-chat-focus-message--motivation-entry-and-exit)
`.focused` class | (see section: endo-but-for-bots--llm-designs-chat-focus-message--motivation-entry-and-exit)
`.focus-active` class | (see section: endo-but-for-bots--llm-designs-chat-focus-message--motivation-entry-and-exit)
Cmd+ArrowUp enter focus mode | (see section: endo-but-for-bots--llm-designs-chat-focus-message--motivation-entry-and-exit)
`⌘↑` focus entry | (see section: endo-but-for-bots--llm-designs-chat-focus-message--motivation-entry-and-exit)
Ctrl+ArrowUp focus | (see section: endo-but-for-bots--llm-designs-chat-focus-message--motivation-entry-and-exit)
focus mode entry gesture | (see section: endo-but-for-bots--llm-designs-chat-focus-message--motivation-entry-and-exit)
exit focus mode | (see section: endo-but-for-bots--llm-designs-chat-focus-message--motivation-entry-and-exit)
edge-exit symmetry | (see section: endo-but-for-bots--llm-designs-chat-focus-message--navigation-and-shortcut-keys)
MOI layout | (see section: endo-but-for-bots--llm-designs-chat-focus-message--motivation-entry-and-exit)
message of interest | (see section: endo-but-for-bots--llm-designs-chat-focus-message--motivation-entry-and-exit)
auto-MOI selection | (see section: endo-but-for-bots--llm-designs-chat-focus-message--prefill-mechanism-and-key-files)
reply chain visualization | (see section: endo-but-for-bots--llm-designs-chat-focus-message--indentation-algorithm-and-chain-lines)
chat-reply-chain-visualization | (see section: endo-but-for-bots--llm-designs-chat-focus-message--motivation-entry-and-exit)
focus modeline | (see section: endo-but-for-bots--llm-designs-chat-focus-message--navigation-and-shortcut-keys)
focus shortcut keys | (see section: endo-but-for-bots--llm-designs-chat-focus-message--navigation-and-shortcut-keys)
shortcut key dispatch | (see section: endo-but-for-bots--llm-designs-chat-focus-message--navigation-and-shortcut-keys)
`r` reply shortcut | (see section: endo-but-for-bots--llm-designs-chat-focus-message--navigation-and-shortcut-keys)
`d` dismiss shortcut | (see section: endo-but-for-bots--llm-designs-chat-focus-message--navigation-and-shortcut-keys)
`a` adopt shortcut | (see section: endo-but-for-bots--llm-designs-chat-focus-message--navigation-and-shortcut-keys)
`g` grant shortcut | (see section: endo-but-for-bots--llm-designs-chat-focus-message--navigation-and-shortcut-keys)
`s` submit shortcut | (see section: endo-but-for-bots--llm-designs-chat-focus-message--navigation-and-shortcut-keys)
PageUp PageDown accumulating heights | (see section: endo-but-for-bots--llm-designs-chat-focus-message--navigation-and-shortcut-keys)
viewport-height-accumulating navigation | (see section: endo-but-for-bots--llm-designs-chat-focus-message--navigation-and-shortcut-keys)
flush edge scroll | (see section: endo-but-for-bots--llm-designs-chat-focus-message--navigation-and-shortcut-keys)
global keydown focus | (see section: endo-but-for-bots--llm-designs-chat-focus-message--navigation-and-shortcut-keys)
primary chain walk | (see section: endo-but-for-bots--llm-designs-chat-focus-message--indentation-algorithm-and-chain-lines)
backward `replyTo` walk | (see section: endo-but-for-bots--llm-designs-chat-focus-message--indentation-algorithm-and-chain-lines)
last-reply forward walk | (see section: endo-but-for-bots--llm-designs-chat-focus-message--indentation-algorithm-and-chain-lines)
chronologically last reply | (see section: endo-but-for-bots--llm-designs-chat-focus-message--indentation-algorithm-and-chain-lines)
chain-start class | (see section: endo-but-for-bots--llm-designs-chat-focus-message--indentation-algorithm-and-chain-lines)
chain-through class | (see section: endo-but-for-bots--llm-designs-chat-focus-message--indentation-algorithm-and-chain-lines)
chain-end class | (see section: endo-but-for-bots--llm-designs-chat-focus-message--indentation-algorithm-and-chain-lines)
chain-tee class | (see section: endo-but-for-bots--llm-designs-chat-focus-message--indentation-algorithm-and-chain-lines)
chain line | (see section: endo-but-for-bots--llm-designs-chat-focus-message--indentation-algorithm-and-chain-lines)
sub-start class | (see section: endo-but-for-bots--llm-designs-chat-focus-message--indentation-algorithm-and-chain-lines)
sub-end class | (see section: endo-but-for-bots--llm-designs-chat-focus-message--indentation-algorithm-and-chain-lines)
sub-through class | (see section: endo-but-for-bots--llm-designs-chat-focus-message--indentation-algorithm-and-chain-lines)
sub-indicator class | (see section: endo-but-for-bots--llm-designs-chat-focus-message--indentation-algorithm-and-chain-lines)
secondary connections pass | (see section: endo-but-for-bots--llm-designs-chat-focus-message--indentation-algorithm-and-chain-lines)
gutter-connected reply | (see section: endo-but-for-bots--llm-designs-chat-focus-message--indentation-algorithm-and-chain-lines)
predecessor-connected reply | (see section: endo-but-for-bots--llm-designs-chat-focus-message--indentation-algorithm-and-chain-lines)
reply indicator stub | (see section: endo-but-for-bots--llm-designs-chat-focus-message--indentation-algorithm-and-chain-lines)
indented message classification | (see section: endo-but-for-bots--llm-designs-chat-focus-message--indentation-algorithm-and-chain-lines)
.message-envelope wrapper | (see section: endo-but-for-bots--llm-designs-chat-focus-message--visual-design-and-data-model)
`.message-envelope` | (see section: endo-but-for-bots--llm-designs-chat-focus-message--visual-design-and-data-model)
`data-number` attribute | (see section: endo-but-for-bots--llm-designs-chat-focus-message--visual-design-and-data-model)
`data-message-id` attribute | (see section: endo-but-for-bots--llm-designs-chat-focus-message--visual-design-and-data-model)
`data-reply-to` attribute | (see section: endo-but-for-bots--llm-designs-chat-focus-message--visual-design-and-data-model)
no-margin envelope | (see section: endo-but-for-bots--llm-designs-chat-focus-message--visual-design-and-data-model)
background-image chain line | (see section: endo-but-for-bots--llm-designs-chat-focus-message--visual-design-and-data-model)
gradient chain line | (see section: endo-but-for-bots--llm-designs-chat-focus-message--visual-design-and-data-model)
2ex primary gutter | (see section: endo-but-for-bots--llm-designs-chat-focus-message--visual-design-and-data-model)
6ex secondary gutter | (see section: endo-but-for-bots--llm-designs-chat-focus-message--visual-design-and-data-model)
`--msg-sent-bg` line color | (see section: endo-but-for-bots--llm-designs-chat-focus-message--visual-design-and-data-model)
focus ring highlight | (see section: endo-but-for-bots--llm-designs-chat-focus-message--visual-design-and-data-model)
`box-shadow` focus highlight | (see section: endo-but-for-bots--llm-designs-chat-focus-message--visual-design-and-data-model)
`prefill?` setCommand parameter | (see section: endo-but-for-bots--llm-designs-chat-focus-message--prefill-mechanism-and-key-files)
`setCommand` prefill | (see section: endo-but-for-bots--llm-designs-chat-focus-message--prefill-mechanism-and-key-files)
`skipFilled` focus advance | (see section: endo-but-for-bots--llm-designs-chat-focus-message--prefill-mechanism-and-key-files)
`focus(skipFilled)` | (see section: endo-but-for-bots--llm-designs-chat-focus-message--prefill-mechanism-and-key-files)
generic pre-fill primitive | (see section: endo-but-for-bots--llm-designs-chat-focus-message--prefill-mechanism-and-key-files)
`enterCommandMode` | (see section: endo-but-for-bots--llm-designs-chat-focus-message--prefill-mechanism-and-key-files)
`inline-command-form.js` | (see section: endo-but-for-bots--llm-designs-chat-focus-message--prefill-mechanism-and-key-files)
`chat-bar-component.js` | (see section: endo-but-for-bots--llm-designs-chat-focus-message--prefill-mechanism-and-key-files)
`inbox-component.js` | (see section: endo-but-for-bots--llm-designs-chat-focus-message--visual-design-and-data-model)
arrowheads on chain lines (non-goal) | (see section: endo-but-for-bots--llm-designs-chat-focus-message--prefill-mechanism-and-key-files)
multi-message selection (non-goal) | (see section: endo-but-for-bots--llm-designs-chat-focus-message--prefill-mechanism-and-key-files)
automatic MOI (non-goal) | (see section: endo-but-for-bots--llm-designs-chat-focus-message--prefill-mechanism-and-key-files)

# makeMarshal constructor rationale (marshal.js, cycle 74)
`makeMarshal` | (see section: endo--packages-marshal-src-marshal-js--dual-format-body-discriminator)
`MakeMarshalOptions` | (see section: endo--packages-marshal-src-marshal-js--dual-format-body-discriminator)
`serializeBodyFormat` | (see section: endo--packages-marshal-src-marshal-js--dual-format-body-discriminator)
`serializeBodyFormat: 'smallcaps'` | (see section: endo--packages-marshal-src-marshal-js--dual-format-body-discriminator)
`serializeBodyFormat: 'capdata'` | (see section: endo--packages-marshal-src-marshal-js--dual-format-body-discriminator)
ontogeny recapitulates phylogeny | (see section: endo--packages-marshal-src-marshal-js--dual-format-body-discriminator)
capdata-as-default | (see section: endo--packages-marshal-src-marshal-js--dual-format-body-discriminator)
`#`-prefix body sentinel | (see section: endo--packages-marshal-src-marshal-js--dual-format-body-discriminator)
JSON-illegal first byte | (see section: endo--packages-marshal-src-marshal-js--dual-format-body-discriminator)
body.charAt(0) === '#' | (see section: endo--packages-marshal-src-marshal-js--dual-format-body-discriminator)
dual-format wire | (see section: endo--packages-marshal-src-marshal-js--dual-format-body-discriminator)
dual-format coexistence | (see section: endo--packages-marshal-src-marshal-js--dual-format-body-discriminator)
`fromCapData` dual decode | (see section: endo--packages-marshal-src-marshal-js--dual-format-body-discriminator)
smallcaps body prefix | (see section: endo--packages-marshal-src-marshal-js--dual-format-body-discriminator)
`makeFullRevive` | (see section: endo--packages-marshal-src-marshal-js--dual-format-body-discriminator)
backward-compat default flip | (see section: endo--packages-marshal-src-marshal-js--dual-format-body-discriminator)
`encodeErrorCommon` | (see section: endo--packages-marshal-src-marshal-js--error-diagnostic-priority)
`encodeErrorToCapData` | (see section: endo--packages-marshal-src-marshal-js--error-diagnostic-priority)
`encodeErrorToSmallcaps` | (see section: endo--packages-marshal-src-marshal-js--error-diagnostic-priority)
`decodeErrorCommon` | (see section: endo--packages-marshal-src-marshal-js--error-diagnostic-priority)
"rather send it anyway" | (see section: endo--packages-marshal-src-marshal-js--error-diagnostic-priority)
deliberate no-stack-sharing | (see section: endo--packages-marshal-src-marshal-js--error-diagnostic-priority)
no stack on the wire | (see section: endo--packages-marshal-src-marshal-js--error-diagnostic-priority)
stack as privileged information | (see section: endo--packages-marshal-src-marshal-js--error-diagnostic-priority)
privileged correlator | (see section: endo--packages-marshal-src-marshal-js--error-diagnostic-priority)
`errorId` | (see section: endo--packages-marshal-src-marshal-js--error-diagnostic-priority)
`errorIdNum` | (see section: endo--packages-marshal-src-marshal-js--error-diagnostic-priority)
`nextErrorId` | (see section: endo--packages-marshal-src-marshal-js--error-diagnostic-priority)
"Sent as ${errorId}" annotation | (see section: endo--packages-marshal-src-marshal-js--error-diagnostic-priority)
errorId allocation | (see section: endo--packages-marshal-src-marshal-js--error-diagnostic-priority)
local-to-remote error correlation | (see section: endo--packages-marshal-src-marshal-js--error-diagnostic-priority)
Remote<Name>(errorId) | (see section: endo--packages-marshal-src-marshal-js--error-diagnostic-priority)
`marshalSaveError` | (see section: endo--packages-marshal-src-marshal-js--error-diagnostic-priority)
`marshalName` | (see section: endo--packages-marshal-src-marshal-js--error-diagnostic-priority)
`errorTagging: 'on'` | (see section: endo--packages-marshal-src-marshal-js--error-diagnostic-priority)
`errorTagging: 'off'` | (see section: endo--packages-marshal-src-marshal-js--error-diagnostic-priority)
late-addition tolerance | (see section: endo--packages-marshal-src-marshal-js--error-diagnostic-priority)
decoder-first encoder-second ratchet | (see section: endo--packages-marshal-src-marshal-js--error-diagnostic-priority)
forward-compatibility ratchet | (see section: endo--packages-marshal-src-marshal-js--error-diagnostic-priority)
`cause` late-addition tolerance | (see section: endo--packages-marshal-src-marshal-js--error-diagnostic-priority)
`errors` late-addition tolerance | (see section: endo--packages-marshal-src-marshal-js--error-diagnostic-priority)
diagnostic priority over validation | (see section: endo--packages-marshal-src-marshal-js--error-diagnostic-priority)
diagnostic salvage | (see section: endo--packages-marshal-src-marshal-js--error-diagnostic-priority)
`annotateError` (marshal-side) | (see section: endo--packages-marshal-src-marshal-js--error-diagnostic-priority)
descriptor-properties no decodeRecur | (see section: endo--packages-marshal-src-marshal-js--error-diagnostic-priority)
agoric-sdk#2780 errorIdNum | (see section: endo--packages-marshal-src-marshal-js--error-diagnostic-priority)
endojs/endo#2052 capData string transform | (see section: endo--packages-marshal-src-marshal-js--error-diagnostic-priority)
`decodeSlotCommon` | (see section: endo--packages-marshal-src-marshal-js--slot-typing-security-hazard)
`decodeRemotableOrPromiseFromCapData` | (see section: endo--packages-marshal-src-marshal-js--slot-typing-security-hazard)
TODO SECURITY HAZARD (marshal) | (see section: endo--packages-marshal-src-marshal-js--slot-typing-security-hazard)
slot-typing security hazard | (see section: endo--packages-marshal-src-marshal-js--slot-typing-security-hazard)
remotable-vs-promise wire ambiguity | (see section: endo--packages-marshal-src-marshal-js--slot-typing-security-hazard)
under-typed slot encoding | (see section: endo--packages-marshal-src-marshal-js--slot-typing-security-hazard)
implementation restriction (marshal) | (see section: endo--packages-marshal-src-marshal-js--slot-typing-security-hazard)
identical decode handlers | (see section: endo--packages-marshal-src-marshal-js--slot-typing-security-hazard)
agoric-sdk#4334 | (see section: endo--packages-marshal-src-marshal-js--slot-typing-security-hazard)
agoric-sdk#4337 | (see section: endo--packages-marshal-src-marshal-js--dual-format-body-discriminator)
`encodeSlotCommon` | (see section: endo--packages-marshal-src-marshal-js--slot-typing-security-hazard)
slot-table | (see section: endo--packages-marshal-src-marshal-js--slot-typing-security-hazard)
`convertValToSlot` | (see section: endo--packages-marshal-src-marshal-js--slot-typing-security-hazard)
`convertSlotToVal` (kind dispatch) | (see section: endo--packages-marshal-src-marshal-js--slot-typing-security-hazard)
`Nat(index)` non-security-check | (see section: endo--packages-marshal-src-marshal-js--slot-typing-security-hazard)
wire-level type-tagged slots | (see section: endo--packages-marshal-src-marshal-js--slot-typing-security-hazard)
`makeDecodeSlotFromSmallcaps` | (see section: endo--packages-marshal-src-marshal-js--slot-typing-security-hazard)
`makeDecodeFromCapData` | (see section: endo--packages-marshal-src-marshal-js--slot-typing-security-hazard)
`makeDecodeFromSmallcaps` | (see section: endo--packages-marshal-src-marshal-js--dual-format-body-discriminator)

# Cycle-76 decomposition batch (2026-05-29) — four new concept pages
Granovetter Operator | granovetter-operator
Granovetter Diagram | granovetter-operator
Granovetter step | granovetter-operator
Mark Granovetter | granovetter-operator
three-object reference-passing | granovetter-operator
bob.foo(carol) | granovetter-operator
b.foo(c) | granovetter-operator
introduction by message passing | granovetter-operator
six perspectives (Granovetter) | granovetter-operator
the strength of weak ties | granovetter-operator
agoric system | agoric-system
agoric open system | agoric-system
agoric approach | agoric-system
agoric systems | agoric-system
agora (computational) | agoric-system
agora-style computation | agoric-system
market-based computation | agoric-system
computational market | agoric-system
Agoric (the company) | agoric-system
Agoric mission | agoric-system
Miller-Drexler 1988 | agoric-system
The Ecology of Computation | agoric-system
Huberman 1988 | agoric-system
encapsulation as property right | agoric-system
encapsulation of resources | agoric-system
charge-per-use | agoric-system
opaque box | agoric-system
marketplace of mind | agoric-system
the scandal of idle time | agoric-system
business agent | agoric-system
spontaneous order | agoric-system
competence vs performance modularity | agoric-system
post-facto simulation | agoric-system
Pareto-preferred compiler | agoric-system
subjective aggregation | subjective-aggregation
only trust makes distinctions | subjective-aggregation
mistrust is ignorance | subjective-aggregation
mistrust = ignorance of internal structure | subjective-aggregation
vat as TCB | subjective-aggregation
vat as Trusted Computing Base | subjective-aggregation
per-bundle trust model | subjective-aggregation
inter-vat mutual suspicion | subjective-aggregation
inter-object mutual suspicion | subjective-aggregation
reason as if only suspicious of objects | subjective-aggregation
economy of suspicion | subjective-aggregation
fully paranoid actor | subjective-aggregation
monolithic conspiracy assumption | subjective-aggregation
vat | vat-and-compartment
vat model | vat-and-compartment
compartment | vat-and-compartment
HardenedJS compartment | vat-and-compartment
SES compartment | vat-and-compartment
Endo compartment | vat-and-compartment
vat-compartment translation | vat-and-compartment
vat as unit of persistence | vat-and-compartment
vat as unit of migration | vat-and-compartment
vat as unit of partial failure | vat-and-compartment
vat as unit of resource control | vat-and-compartment
vat as unit of DoS-defense | vat-and-compartment
vat incarnation | vat-and-compartment
Joule tank | vat-and-compartment
heap + thread + pending-delivery queue | vat-and-compartment
unit of sequentiality | vat-and-compartment
turn boundary | vat-and-compartment
computational firm | vat-and-compartment

# Cycle-77 decomposition batch two (2026-05-29) — three more concept pages
MintMaker | mint-purse-money
mint | mint-purse-money
purse | mint-purse-money
sealed decr | mint-purse-money
capability-based money | mint-purse-money
six security properties | mint-purse-money
six security properties (mint-purse) | mint-purse-money
Alice pays Bob $10 | mint-purse-money
Agoric ERTP ancestor | mint-purse-money
ERTP issuer-kit ancestor | mint-purse-money
makeIssuerKit | mint-purse-money
issuer-kit | mint-purse-money
mint-purse-money | mint-purse-money
brand | brand-and-trademark
brands | brand-and-trademark
trademark | brand-and-trademark
trademarks | brand-and-trademark
sealer/unsealer | brand-and-trademark
sealer-unsealer pair | brand-and-trademark
sealer | brand-and-trademark
unsealer | brand-and-trademark
BrandMaker | brand-and-trademark
BrandMaker pair | brand-and-trademark
FactoryStamp | brand-and-trademark
factoryStamp | brand-and-trademark
interface guards | brand-and-trademark
rights amplification primitive | brand-and-trademark
rights amplification | brand-and-trademark
envelope and can-opener | brand-and-trademark
can and can-opener | brand-and-trademark
can-opener analogy | brand-and-trademark
@endo/marshal brand | brand-and-trademark
Endo brand | brand-and-trademark
makeBrand | brand-and-trademark
types-by-fiat | brand-and-trademark
smart contract | smart-contract
smart contracts | smart-contract
Szabo smart contract | smart-contract
Nick Szabo | smart-contract
Szabo 1996 | smart-contract
computational contract | smart-contract
self-enforcing computational contract | smart-contract
self-enforcing computational embodiment of a contract | smart-contract
CoveredCallOption | smart-contract
covered call option | smart-contract
CoveredCallOptionMaker | smart-contract
Zoe contract | smart-contract
Agoric Zoe | smart-contract
Agoric contract | smart-contract
TitleCompanyMaker | smart-contract
escrowedStock | smart-contract
escrowedMoney | smart-contract

# Cycle-78 decomposition batch three (2026-05-30) — agoric-machinery cluster (3 concept pages)
competence vs performance modularity | competence-vs-performance-modularity
competence-vs-performance modularity | competence-vs-performance-modularity
competence modularity | competence-vs-performance-modularity
performance modularity | competence-vs-performance-modularity
safety and liveness | competence-vs-performance-modularity
what programs can do vs how efficiently they do it | competence-vs-performance-modularity
object-orientation modularizes competence | competence-vs-performance-modularity
markets modularize performance | competence-vs-performance-modularity
business agent | business-agent
business agents | business-agent
data-type agent | business-agent
lookup-table agent | business-agent
manager agent | business-agent
agent-selection agent | business-agent
performance-domain delegate | business-agent
subcontractor vs agent | business-agent
specialized resource-allocation agent | business-agent
compilation speculator | business-agent
Pareto-preferred compiler | business-agent
positive vs negative reputation | positive-vs-negative-reputation
positive reputation | positive-vs-negative-reputation
positive reputation system | positive-vs-negative-reputation
negative reputation | positive-vs-negative-reputation
negative reputation system | positive-vs-negative-reputation
reputation system | positive-vs-negative-reputation
reputation service | positive-vs-negative-reputation
pseudonyms and reputation | positive-vs-negative-reputation
cheap pseudonyms vulnerability | positive-vs-negative-reputation
cash bond performance guarantee | positive-vs-negative-reputation
cash bond pattern | positive-vs-negative-reputation
performance guarantee bond | positive-vs-negative-reputation
crypto staking (1988 ancestor) | positive-vs-negative-reputation
Better Business Bureau (computational) | positive-vs-negative-reputation
Underwriters Laboratories analogy | positive-vs-negative-reputation
Axelrod iterated prisoner's dilemma | positive-vs-negative-reputation
iterated relationship | positive-vs-negative-reputation

# Cycle-79 decomposition batch four (2026-05-30) — visionary cluster (2 concept pages; decomposition campaign closure)
marketplace of mind | marketplace-of-mind
marketplace-of-mind | marketplace-of-mind
intelligence as emergent property | marketplace-of-mind
intelligence separated from individuality | marketplace-of-mind
multi-agent societal AI | marketplace-of-mind
agoric AI | marketplace-of-mind
Stefik knowledge medium | marketplace-of-mind
knowledge medium | marketplace-of-mind
knowledge-as-service vs knowledge-as-representation | marketplace-of-mind
knowledge-engineering bottleneck | marketplace-of-mind
opaque box | opaque-box
opaque-box | opaque-box
hardware encapsulation | opaque-box
tamper-responding box | opaque-box
tamper-evident hardware | opaque-box
secure enclave | opaque-box
Intel SGX | opaque-box
AMD SEV | opaque-box
ARM TrustZone | opaque-box
Apple Secure Enclave | opaque-box
AWS Nitro Enclave | opaque-box
Microsoft Pluton | opaque-box
trusted execution environment | opaque-box
TEE | opaque-box
hardware-attested companion channel | opaque-box
Confidential Computing Consortium | opaque-box
TPM 2.0 | opaque-box
confidential computing | opaque-box

## encodePassable.js rank-order-preserving encoder (cycle 81)

`encodePassable` | rank-order-preserving-encoding
encodePassable | rank-order-preserving-encoding
`makePassableKit` | rank-order-preserving-encoding
makePassableKit | rank-order-preserving-encoding
rank-order encoding | rank-order-preserving-encoding
rank order encoding | rank-order-preserving-encoding
rank-order preserving encoding | rank-order-preserving-encoding
sort-preserving encoding | rank-order-preserving-encoding
lexicographic order matches numeric order | rank-order-preserving-encoding
lexicographic byte order matches sort order | rank-order-preserving-encoding
compactOrdered | rank-order-preserving-encoding
legacyOrdered | rank-order-preserving-encoding
compactOrdered format | rank-order-preserving-encoding
legacyOrdered format | rank-order-preserving-encoding
`rankOrder` | rank-order-preserving-encoding
rankOrder | rank-order-preserving-encoding
rank-order | rank-order-preserving-encoding
`passStylePrefixes` | rank-order-preserving-encoding
passStylePrefixes | rank-order-preserving-encoding
ordinal-mapping prefix | rank-order-preserving-encoding
remotable-to-ordinal mapping | rank-order-preserving-encoding
bit-complement for sort order | rank-order-preserving-encoding
Elias delta encoding | rank-order-preserving-encoding
Elias-delta encoding | rank-order-preserving-encoding
sign-aware alphabets | rank-order-preserving-encoding
ten's complement digit encoding | rank-order-preserving-encoding
sign-aware unary alphabet | rank-order-preserving-encoding
`encodeBinary64` | rank-order-preserving-encoding
encodeBinary64 | rank-order-preserving-encoding
`encodeBigInt` | rank-order-preserving-encoding
encodeBigInt | rank-order-preserving-encoding
`stringEscapes` | rank-order-preserving-encoding
stringEscapes | rank-order-preserving-encoding
`encodeCompactArray` | rank-order-preserving-encoding
encodeCompactArray | rank-order-preserving-encoding
`encodeLegacyArray` | rank-order-preserving-encoding
encodeLegacyArray | rank-order-preserving-encoding
`decodeCompactArray` | rank-order-preserving-encoding
`decodeLegacyArray` | rank-order-preserving-encoding
`verifyEncoding` | rank-order-preserving-encoding
verifyEncoding | rank-order-preserving-encoding
double-decode embeddability check | rank-order-preserving-encoding
embeddability verify | rank-order-preserving-encoding
embeddable encoding | rank-order-preserving-encoding
liberal decode | rank-order-preserving-encoding
`liberalDecode` | rank-order-preserving-encoding
liberalDecoders | rank-order-preserving-encoding
`canonicalNaN` | rank-order-preserving-encoding
canonical NaN constant | rank-order-preserving-encoding
WebIDL canonical NaN | rank-order-preserving-encoding
lockdown-independent NaN canonicalization | rank-order-preserving-encoding
BigUint64Array DataView aliasing | rank-order-preserving-encoding
C union trick | rank-order-preserving-encoding
JavaScript C union | rank-order-preserving-encoding
`isEncodedRemotable` | rank-order-preserving-encoding
isEncodedRemotable | rank-order-preserving-encoding
`getSuffix` | rank-order-preserving-encoding
`zeroPad` | rank-order-preserving-encoding
`recordNames` | rank-order-preserving-encoding
`recordValues` | rank-order-preserving-encoding
BANG escape prefix encodePassable | rank-order-preserving-encoding
C0 control character escape | rank-order-preserving-encoding
`rC0` | rank-order-preserving-encoding
~ format discriminator | rank-order-preserving-encoding
v2 encoding marshal | rank-order-preserving-encoding
encodePassable v2 | rank-order-preserving-encoding
keyed-store key encoding | rank-order-preserving-encoding
CopyMap key encoding | rank-order-preserving-encoding
CopySet key encoding | rank-order-preserving-encoding
CopyBag key encoding | rank-order-preserving-encoding
slow substring XS | rank-order-preserving-encoding
XS substring performance | rank-order-preserving-encoding
PR #1260 marshal | rank-order-preserving-encoding
endojs/endo#1260 | rank-order-preserving-encoding
endojs/endo#1984 | rank-order-preserving-encoding
sign-aware bit complement | rank-order-preserving-encoding
two's-complement-by-sign | rank-order-preserving-encoding
ten's complement | rank-order-preserving-encoding
unary length-of-length prefix | rank-order-preserving-encoding
Elias delta variant | rank-order-preserving-encoding
slot slash command | (see source: endo-but-for-bots--llm-designs-chat-slot-slash-commands)
slot input slash mode | (see source: endo-but-for-bots--llm-designs-chat-slot-slash-commands)
slash mode | (see source: endo-but-for-bots--llm-designs-chat-slot-slash-commands)
slashCompose | (see source: endo-but-for-bots--llm-designs-chat-slot-slash-commands)
chipRetained | (see source: endo-but-for-bots--llm-designs-chat-slot-slash-commands)
`/js` slot | (see source: endo-but-for-bots--llm-designs-chat-slot-slash-commands)
`/json` slot | (see source: endo-but-for-bots--llm-designs-chat-slot-slash-commands)
`/locator` slot | (see source: endo-but-for-bots--llm-designs-chat-slot-slash-commands)
`/ref` slot | (see source: endo-but-for-bots--llm-designs-chat-slot-slash-commands)
inline capability provisioning | captp-bounded-transient-pin
throwaway capability | captp-bounded-transient-pin
slot filler without pet name | captp-bounded-transient-pin
transient pin | captp-bounded-transient-pin
transient-pin | captp-bounded-transient-pin
`pinTransient` | captp-bounded-transient-pin
pinTransient | captp-bounded-transient-pin
`unpinTransient` | captp-bounded-transient-pin
unpinTransient | captp-bounded-transient-pin
`transientRoots` | captp-bounded-transient-pin
transientRoots | captp-bounded-transient-pin
`makeRetainedValue` | captp-bounded-transient-pin
makeRetainedValue | captp-bounded-transient-pin
RetainedValueSpec | captp-bounded-transient-pin
retained value | captp-bounded-transient-pin
release exo | captp-bounded-transient-pin
release capability | captp-bounded-transient-pin
release Exo | captp-bounded-transient-pin
captp-bounded transient pin | captp-bounded-transient-pin
captp partition handler | captp-bounded-transient-pin
captp partition signal | captp-bounded-transient-pin
partition-triggered release | captp-bounded-transient-pin
disk before graph | (see section: endo-but-for-bots--llm-designs-chat-slot-slash-commands--daemon-changes-makeretainedvalue-and-captp-bounded-pin)
disk-before-graph | (see section: endo-but-for-bots--llm-designs-chat-slot-slash-commands--daemon-changes-makeretainedvalue-and-captp-bounded-pin)
real locator over opaque ephemeral identifier | captp-bounded-transient-pin
ephemeral identifier | captp-bounded-transient-pin
slot input component | (see source: endo-but-for-bots--llm-designs-chat-slot-slash-commands)
`slot-input.js` | (see source: endo-but-for-bots--llm-designs-chat-slot-slash-commands)
`createSlotInput` | (see source: endo-but-for-bots--llm-designs-chat-slot-slash-commands)
SlotInputAPI | (see source: endo-but-for-bots--llm-designs-chat-slot-slash-commands)
petname drop-down | (see section: endo-but-for-bots--llm-designs-chat-slot-slash-commands--chat-ui-slot-input-component-and-submission)
command drop-down | (see section: endo-but-for-bots--llm-designs-chat-slot-slash-commands--chat-ui-slot-input-component-and-submission)
two-stage drop-down | (see section: endo-but-for-bots--llm-designs-chat-slot-slash-commands--chat-ui-slot-input-component-and-submission)
slot picker | (see section: endo-but-for-bots--llm-designs-chat-slot-slash-commands--chat-ui-slot-input-component-and-submission)
formula ID submission | (see section: endo-but-for-bots--llm-designs-chat-slot-slash-commands--chat-ui-slot-input-component-and-submission)
formula identifier as endow binding | (see section: endo-but-for-bots--llm-designs-chat-slot-slash-commands--chat-ui-slot-input-component-and-submission)
`endowmentFormulaIdsOrPaths` | (see section: endo-but-for-bots--llm-designs-chat-slot-slash-commands--chat-ui-slot-input-component-and-submission)
`formulateMarshalValue` | (see section: endo-but-for-bots--llm-designs-chat-slot-slash-commands--chat-ui-slot-input-component-and-submission)
formulateMarshalValue | (see section: endo-but-for-bots--llm-designs-chat-slot-slash-commands--chat-ui-slot-input-component-and-submission)
slot as the unit of transient retention | (see section: endo-but-for-bots--llm-designs-chat-slot-slash-commands--security-phases-decisions-and-known-gaps)
transient pin over deferred formulation | (see section: endo-but-for-bots--llm-designs-chat-slot-slash-commands--security-phases-decisions-and-known-gaps)

## rankOrder.js in-memory rank-order regime (cycle 84)

`rankOrder.js` | rank-order-preserving-encoding
rankOrder.js | rank-order-preserving-encoding
`sameValueZero` | rank-order-preserving-encoding
sameValueZero | rank-order-preserving-encoding
SameValueZero | rank-order-preserving-encoding
`compareNumerics` | rank-order-preserving-encoding
compareNumerics | rank-order-preserving-encoding
`compareByCodePoints` | rank-order-preserving-encoding
compareByCodePoints | rank-order-preserving-encoding
`trivialComparator` | rank-order-preserving-encoding
trivialComparator | rank-order-preserving-encoding
`ENDO_RANK_STRINGS` | rank-order-preserving-encoding
ENDO_RANK_STRINGS | rank-order-preserving-encoding
`utf16-code-unit-order` | rank-order-preserving-encoding
`unicode-code-point-order` | rank-order-preserving-encoding
`error-if-order-choice-matters` | rank-order-preserving-encoding
utf16-code-unit-order | rank-order-preserving-encoding
unicode-code-point-order | rank-order-preserving-encoding
`passStyleRanks` | rank-order-preserving-encoding
passStyleRanks | rank-order-preserving-encoding
`getPassStyleCover` | rank-order-preserving-encoding
getPassStyleCover | rank-order-preserving-encoding
`RankCover` | rank-order-preserving-encoding
RankCover | rank-order-preserving-encoding
rank cover overestimate | rank-order-preserving-encoding
cover may be an overestimate | rank-order-preserving-encoding
`getIndexCover` | rank-order-preserving-encoding
getIndexCover | rank-order-preserving-encoding
`FullRankCover` | rank-order-preserving-encoding
`coveredEntries` | rank-order-preserving-encoding
`unionRankCovers` | rank-order-preserving-encoding
`intersectRankCovers` | rank-order-preserving-encoding
`makeComparatorKit` | rank-order-preserving-encoding
makeComparatorKit | rank-order-preserving-encoding
`compareRank` | rank-order-preserving-encoding
compareRank | rank-order-preserving-encoding
`compareAntiRank` | rank-order-preserving-encoding
compareAntiRank | rank-order-preserving-encoding
`antiComparator` | rank-order-preserving-encoding
antiComparator | rank-order-preserving-encoding
`comparatorMirrorImage` | rank-order-preserving-encoding
comparatorMirrorImage | rank-order-preserving-encoding
`RankComparatorKit` | rank-order-preserving-encoding
RankComparatorKit | rank-order-preserving-encoding
`FullComparatorKit` | rank-order-preserving-encoding
FullComparatorKit | rank-order-preserving-encoding
`makeFullOrderComparatorKit` | rank-order-preserving-encoding
makeFullOrderComparatorKit | rank-order-preserving-encoding
full order comparator | rank-order-preserving-encoding
full-order comparator | rank-order-preserving-encoding
observable mutable state comparator | rank-order-preserving-encoding
covert channel comparator | rank-order-preserving-encoding
`sortByRank` | rank-order-preserving-encoding
sortByRank | rank-order-preserving-encoding
`isRankSorted` | rank-order-preserving-encoding
isRankSorted | rank-order-preserving-encoding
`assertRankSorted` | rank-order-preserving-encoding
assertRankSorted | rank-order-preserving-encoding
`rankSearch` | rank-order-preserving-encoding
rankSearch | rank-order-preserving-encoding
Array.prototype.sort undefined quirk | rank-order-preserving-encoding
undefined at end of sort | rank-order-preserving-encoding
reverse comparator undefined fixup | rank-order-preserving-encoding
shortlex | rank-order-preserving-encoding
shortlex comparison | rank-order-preserving-encoding
subset ranks earlier | rank-order-preserving-encoding
prefix ranks earlier | rank-order-preserving-encoding
inverse sorted property names | rank-order-preserving-encoding
NaN compareRemotables default | rank-order-preserving-encoding
deep-tied remotables | rank-order-preserving-encoding
`memoOfSorted` | rank-order-preserving-encoding
comparator memoization | rank-order-preserving-encoding
`comparatorMirrorImages` | rank-order-preserving-encoding
first-seen ordering of remotables | rank-order-preserving-encoding
`nameForPassableSymbol` | rank-order-preserving-encoding

## Reasoning about Risk and Trust (Drossopoulou-Noble-Miller-Murray 2015, cycle 85)

`obeys` | object-capability
o obeys Spec | object-capability
obeys predicate | object-capability
hypothetical trust | object-capability
hypothetical trust predicate | object-capability
trust as hypothesis | object-capability
trust as a hypothetical | object-capability
first-class trust predicate | object-capability
runtime trust bit | object-capability
trust bit | object-capability
`MayAccess` | four-ways-to-acquire-references
MayAccess | four-ways-to-acquire-references
`MayAccess(o, p)` | four-ways-to-acquire-references
transitive points-to closure | four-ways-to-acquire-references
points-to closure | four-ways-to-acquire-references
abstract reachability closure | four-ways-to-acquire-references
`MayAffect` | principle-of-least-authority
MayAffect | principle-of-least-authority
`MayAffect(o, p)` | principle-of-least-authority
mutation closure | principle-of-least-authority
mutation reach | principle-of-least-authority
only connectivity begets connectivity | object-capability
only-connectivity-begets-connectivity | object-capability
connectivity begets connectivity | object-capability
risk bound | principle-of-least-authority
risk bounds | principle-of-least-authority
open world specification | object-capability
open-world specification | object-capability
closed world assumption | object-capability
closed-world assumption | object-capability
open world | object-capability
open-world | object-capability
ValidPurse | mint-purse-money
`ValidPurse` | mint-purse-money
ValidPurse specification | mint-purse-money
`Pol_deposit_1` | mint-purse-money
`Pol_deposit_2` | mint-purse-money
`Pol_sprout` | mint-purse-money
`Pol_can_trade_constant` | mint-purse-money
`Pol_protect_balance` | mint-purse-money
purse sprouting | mint-purse-money
sprout | mint-purse-money
`sprout` | mint-purse-money
sprouted purse | mint-purse-money
sprouted malicious purse | mint-purse-money
sprouted-malicious-purse attack | mint-purse-money
ValidEscrow | smart-contract
`ValidEscrow` | smart-contract
four-case ValidEscrow | smart-contract
four-case spec | smart-contract
four-case specification | smart-contract
case analysis on participant trust | smart-contract
participant purses | smart-contract
PPrs | smart-contract
GoodPrs | smart-contract
OthrPrs | smart-contract
BadPPrs | smart-contract
matching pairs of untrustworthy purses | smart-contract
jointly conspiring untrustworthy | smart-contract
return value does not communicate trustworthiness | smart-contract
deal_version1 | smart-contract
`deal_version1` | smart-contract
deal_version2 | smart-contract
`deal_version2` | smart-contract
escrow exchange | smart-contract
escrow purse | smart-contract
escrow purses | smart-contract
escrowMoney | smart-contract
sellerMoney | smart-contract
buyerMoney | smart-contract
mutual trust by reciprocal deposits | smart-contract
reciprocal zero-amount deposit | smart-contract
zero-amount deposit handshake | smart-contract
biconditional on obeys | smart-contract
mutual-trust handshake | smart-contract
two-way trusted transfer | smart-contract
CanTrade | brand-and-trademark
`CanTrade` | brand-and-trademark
`CanTrade(prs1, prs2)` | brand-and-trademark
CanTrade abstract predicate | brand-and-trademark
CanTrade reflexive | brand-and-trademark
Focal | object-capability
`Focal` | object-capability
Featherweight Object Capability Language | object-capability
Chainmail | object-capability
`Chainmail` | object-capability
Chainmail specification language | object-capability
named policy | object-capability
named policies | object-capability
specification policies | object-capability
invariant policy | object-capability
any_code policy | object-capability
`any_code` | object-capability
Hoare four-tuple | object-capability
Hoare four-tuples | object-capability
four-tuple Hoare logic | object-capability
during-execution invariant | object-capability
intermediate state invariant | object-capability
code-agnostic inference rule | object-capability
code-agnostic rules | object-capability
code agnostic rules | object-capability
`METH-CALL-2` | object-capability
METH-CALL-2 | object-capability
`FRAME-METHCALL` | principle-of-least-authority
FRAME-METHCALL | principle-of-least-authority
POLA framing rule | principle-of-least-authority
POLA framing | principle-of-least-authority
`CODE-INVAR-1` | object-capability
CODE-INVAR-1 | object-capability
`CODE-INVAR-2` | object-capability
CODE-INVAR-2 | object-capability
trust preserved across execution | object-capability
linking operator | vat-and-compartment
module linking | vat-and-compartment
`M * M'` | vat-and-compartment
Arising configurations | object-capability
Reach function | object-capability
Drossopoulou-Noble-Miller-Murray | object-capability
Drossopoulou et al | object-capability
defensive consistency formal | object-capability

## Chat Playwright Build-and-Load Smoke (chat-playwright-smoke, cycle 86)

chat-playwright-smoke | chat-ui
chat playwright smoke | chat-ui
chat bundle smoke | chat-ui
playwright smoke | chat-ui
browser-tests workflow | chat-ui
browser-tests job | chat-ui
canary spec | chat-ui
`canary.spec.js` | chat-ui
Vite production bundle | chat-ui
production bundle smoke | chat-ui
`packages/chat/dist/` | chat-ui
chat dist | chat-ui
`vite build` chat | chat-ui
SES lockdown smoke | chat-ui
SES bundle regression | chat-ui
Gateway not configured heading | chat-ui
Gateway not configured | chat-ui
deterministic fallback heading | chat-ui
fragment-less navigation | chat-ui
daemon-free smoke | chat-ui
daemon-free Playwright test | chat-ui
fixture-free Playwright test | chat-ui
`pageerror` | chat-ui
pageerror handler | chat-ui
`requestfailed` | chat-ui
requestfailed handler | chat-ui
silent bundle regression | chat-ui
bundle parse failure | chat-ui
top-level import failure | chat-ui
asset path mismatch | chat-ui
lockdown-time error | chat-ui
chat-test-coverage | chat-ui
chat test coverage | chat-ui
chat e2e suite | chat-ui
yarn dev vs production bundle | chat-ui
dev-server bundle divergence | chat-ui
`browser-test/server.js` | chat-ui
extend browser-test/server.js | chat-ui
mount /chat/ prefix | chat-ui
static-file route | chat-ui
second Playwright webServer | chat-ui
`webServer` config | chat-ui
http-server dependency | chat-ui
`http-server` | chat-ui
`browser-test/tests/chat.spec.js` | chat-ui
chat.spec.js | chat-ui
injection-revert verification | chat-ui
injection-revert pattern | chat-ui
test-the-test discipline | chat-ui
falsifiable in the right direction | chat-ui
out-of-scope enumeration | chat-ui
negative spec | chat-ui
console-error strictness | chat-ui
failed-request strictness | chat-ui
browser engine scope | chat-ui
chromium-next | chat-ui
chrome-dev project | chat-ui
screenshot artifact | chat-ui
`page.screenshot` | chat-ui
playwright-report artifact | chat-ui
maintainer call open question | chat-ui
deliberate regression | chat-ui
deliberate-regression test | chat-ui
zero-cost CI step | chat-ui
zero new dependencies | chat-ui
dependency-minimal CI | chat-ui

## packages/pass-style/src/error.js (cycle 87, seventh comment-fragment ingest)

`makeTypeError` | object-capability
makeTypeError | object-capability
belt and suspenders | object-capability
belt-and-suspenders | object-capability
suspenders on our overalls | object-capability
realm intrinsic TypeError | object-capability
realm intrinsic by language syntax | object-capability
syntax-constructed exception | object-capability
`null.null` trick | object-capability
null.null syntax trick | object-capability
Start Compartment | vat-and-compartment
start compartment | vat-and-compartment
primary realm | vat-and-compartment
guest compartment | vat-and-compartment
gratuitously frozen globalThis | vat-and-compartment
gratuitiously frozen | vat-and-compartment
multi-guest shared compartment | vat-and-compartment
unfrozen globalThis | vat-and-compartment
incoherent compartment | vat-and-compartment
no mutual safety | vat-and-compartment
SES initializes first | object-capability
prior code is benign | object-capability
boot-order assumption | object-capability
pre-SES attacker | object-capability
host configuration regimes | object-capability
`makeRepairError` | object-capability
makeRepairError | object-capability
repairError | object-capability
`repairError` | object-capability
V8 own stack accessor | object-capability
V8 stack accessor | object-capability
undeniable channel | object-capability
undeniable capability channel | object-capability
stack internal slot | object-capability
arbitrary capabilities through stack | object-capability
same-realm getter equality | object-capability
same-realm-getter-equality repair | object-capability
`feralStackGetter` | object-capability
feralStackGetter | object-capability
Hermes stack accessor | object-capability
captureStackTrace proposal | object-capability
`Error.captureStackTrace` | object-capability
proposal-error-capturestacktrace | object-capability
FF/SpiderMonkey stack | object-capability
Moddable/XS stack | object-capability
error stack proposal | object-capability
hardenTaming unsafe | object-capability
`hardenTaming: "unsafe"` | object-capability
unsafe hardenTaming | object-capability
hardenIsNoop | object-capability
`hardenIsNoop` | object-capability
fake harden | object-capability
non-actually-freezing harden | object-capability
calls getter during harden | object-capability
PASS_STYLE_UNEXPECTED_ERROR_OWN_STACK_ACCESSOR | object-capability
`PASS_STYLE_UNEXPECTED_ERROR_OWN_STACK_ACCESSOR` | object-capability
SES_UNEXPECTED_ERROR_OWN_STACK_ACCESSOR | object-capability
SES error-code document | object-capability
isErrorLike | pass-invariant-handle-equality
`isErrorLike` | pass-invariant-handle-equality
assertError | pass-invariant-handle-equality
confirmErrorLike | pass-invariant-handle-equality
`confirmErrorLike` | pass-invariant-handle-equality
confirmRecursivelyPassableError | pass-invariant-handle-equality
`confirmRecursivelyPassableError` | pass-invariant-handle-equality
confirmRecursivelyPassableErrorPropertyDesc | pass-invariant-handle-equality
ErrorHelper | pass-invariant-handle-equality
`ErrorHelper` | pass-invariant-handle-equality
passable error | pass-invariant-handle-equality
malformed error | pass-invariant-handle-equality
passable by itself | pass-invariant-handle-equality
passable as part of a structure | pass-invariant-handle-equality
two-tier passability | pass-invariant-handle-equality
diagnostic preservation | pass-invariant-handle-equality
diagnostic-vs-security tension | pass-invariant-handle-equality
security-vs-diagnostic-preservation | pass-invariant-handle-equality
validity complaints as notes | pass-invariant-handle-equality
notes on the error | pass-invariant-handle-equality
attach notes to malformed error | pass-invariant-handle-equality
four-property allowlist | pass-invariant-handle-equality
error own property allowlist | pass-invariant-handle-equality
error message stack cause errors | pass-invariant-handle-equality
own data property | pass-invariant-handle-equality
extra unpassed property | pass-invariant-handle-equality
error constructor registry | object-capability
errorConstructors map | object-capability
`errorConstructors` | object-capability
getErrorConstructor | object-capability
`getErrorConstructor` | object-capability
AggregateError construction non-uniformity | object-capability
AggregateError errors iterable | object-capability
non-uniformity disclaimer | object-capability
makeError encapsulates | object-capability
SES whitelist coordination | object-capability
maintenance hazard | object-capability
SES whilelist | object-capability
passStyleOf side effect | object-capability
passStyleOf side-effect | object-capability
side effect during passStyleOf | object-capability
alters object as side effect | object-capability
deliberately accepted defensive-consistency violation | object-capability
deliberate controlled risk | object-capability
acknowledge the hazard then bound it | object-capability
NOTE calls getter during harden | object-capability
hazards we think we understand | object-capability
diagnostic priority over validity bug | object-capability
fail loud on unexpected accessor | object-capability
captureStackTrace forward-compatibility | object-capability

## ACLs Don't (Tyler Close ~2009, cycle 88)

ACLs don't | object-capability
ACLs Don't | object-capability
ACL model | object-capability
ACL critique | object-capability
access matrix | object-capability
access matrix model | object-capability
1971 Protection paper | object-capability
Lampson Protection | object-capability
column-stored access matrix | object-capability
row-stored access matrix | object-capability
ACL checking | object-capability
capability transfer | four-ways-to-acquire-references
construction-time access check | object-capability
receipt-time access check | object-capability
Confused Deputy | object-capability
Confused Deputy attack | object-capability
deputy software agent | object-capability
Vendor User Compiler | object-capability
compilation scenario | object-capability
log.txt overwrite attack | object-capability
A_R,c,p entry | object-capability
access matrix entry notation | object-capability
file descriptors not filenames | object-capability
capabilities by reference everywhere | object-capability
crucial step Confused Deputy | object-capability
object identifier through intermediate | object-capability
RBAC IBAC ABAC | object-capability
role-based access control | object-capability
attribute-based access control | object-capability
identity-based access control | object-capability
setuid | object-capability
stack introspection | object-capability
single authorization chain per operation | object-capability
multi-argument authorization | object-capability
delaying-the-access-check | object-capability
Speaks-for paper | object-capability
client authentication misleading | object-capability
who said this | object-capability
who relayed vs who intended | object-capability
accountability assignment | object-capability
deputy held accountable | object-capability
Horton capability protocol | object-capability
Horton protocol | object-capability
capability-application caveat | object-capability
re-implementing ACL on capabilities | object-capability
string name to capability mapping | object-capability
CSRF | object-capability
Cross-Site Request Forgery | object-capability
cross-site request forgery | object-capability
clickjacking | object-capability
click fraud | object-capability
unguessable token | object-capability
unguessable URL | object-capability
web-key | object-capability
web key | object-capability
web-key paper | object-capability
mashing with permission | object-capability
no infrastructure change | object-capability
URL namespace migration | object-capability
capability-Web migration | object-capability
Same Origin Policy | object-capability
SOP integrity boundary | object-capability
Table 3 mapping | object-capability
HTTP cookie principal | object-capability
opening then writing pattern | object-capability
IFRAME clickjacking | object-capability
transparent IFRAME | object-capability
click on a private page | object-capability
Norm Hardy 1988 | object-capability
Hardy 1988 Confused Deputy | object-capability
SIGOPS 1988 | object-capability
Shiflett CSRF | object-capability
Hansen Grossman clickjacking | object-capability
Speaks-for Lampson | object-capability
Tyler Close | object-capability
HP Labs Palo Alto | object-capability
ACL doesn't authorize correctly | object-capability
ACL doesn't authenticate reliably | object-capability
ACL doesn't assign accountability correctly | object-capability
contradictory access decisions | object-capability
not benignly differ | object-capability
multi-party scenario | object-capability
more than two principals | object-capability

## Chat Voice Command Parser (chat-voice-command-parser, cycle 89)

voice command parser | chat-ui
voice transcript parser | chat-ui
chat voice | chat-ui
Web Speech API | chat-ui
SpeechRecognition | chat-ui
`SpeechRecognition` | chat-ui
voice-input.js | chat-ui
`voice-input.js` | chat-ui
microphone button | chat-ui
asynchronous parse monad | chat-ui
async parse monad state machine | chat-ui
ParseState | chat-ui
ParseStep | chat-ui
ParseFn | chat-ui
parse-monad | chat-ui
voice effects | chat-ui
inert passable effects | chat-ui
enter-mode effect | chat-ui
commit-token effect | chat-ui
set-field effect | chat-ui
open-command-menu effect | chat-ui
pick-command effect | chat-ui
submit effect | chat-ui
cancel effect | chat-ui
append-text effect | chat-ui
wake word | chat-ui
wake-word table | chat-ui
per-mode wake-word | chat-ui
voiceHints | chat-ui
modeline voice line | chat-ui
voice modeline | chat-ui
literal quote escape | chat-ui
quote prefix | chat-ui
`quote` escape | chat-ui
quote unquote | chat-ui
framing pause | chat-ui
framing-pause submit | chat-ui
framed pause cue | chat-ui
silence threshold | chat-ui
endpointing parameter | chat-ui
600 ms silence | chat-ui
send now wake word | chat-ui
push-to-talk | chat-ui
push to talk | chat-ui
mic release submit | chat-ui
buffer and rollback | chat-ui
interim result retraction | chat-ui
roll back on retraction | chat-ui
effect inverse | chat-ui
inverse of commit-token | chat-ui
rollback at word boundary | chat-ui
end event flushes parser | chat-ui
flush on end | chat-ui
command-registry vocabulary | chat-ui
registry-driven vocabulary | chat-ui
vocabulary as data | chat-ui
new command gets voice automatically | chat-ui
field-name as wake word | chat-ui
nine-mode inventory | chat-ui
Empty Send Mode | chat-ui
Token Autocomplete Visible | chat-ui
Token Only | chat-ui
Token plus Message Text | chat-ui
Text Only mode | chat-ui
Command Selecting mode | chat-ui
Inline Command Form mode | chat-ui
Eval Command Inline | chat-ui
Value Modal mode | chat-ui
Google Assistant okay disambiguation | chat-ui
Apple Dictation press period | chat-ui
voice-assistant prior art | chat-ui
five interaction patterns | chat-ui
one-line message pattern | chat-ui
immediate command pattern | chat-ui
inline command form fill pattern | chat-ui
cancel mid-command pattern | chat-ui
edit-a-value cancel-and-restart | chat-ui
no invented edit gestures | chat-ui
dual mechanism disambiguation | chat-ui
wake-word vs prose collision | chat-ui
escape and enter | chat-ui
why two mechanisms not one | chat-ui
modal toggle context switch | chat-ui
confidence threshold not enough | chat-ui
pure parser test | chat-ui
stub SpeechRecognition test | chat-ui
feature flag voice migration | chat-ui
4-phase implementation | chat-ui
parser scaffold phase | chat-ui
effect dispatcher phase | chat-ui
modeline voice line phase | chat-ui
voice-input.js migration phase | chat-ui
canonical command-menu wake word | chat-ui
inline vs deferred pet-name lookup | chat-ui
modeline aural cue | chat-ui
session isolation vs resume | chat-ui
literal-escape word alternative | chat-ui
framing-pause threshold tunability | chat-ui
non-voice long-press submit | chat-ui

## packages/eventual-send/src/track-turns.js (cycle 90, eighth comment-fragment ingest)

track-turns | object-capability
track-turns.js | object-capability
trackTurns | object-capability
`trackTurns` | object-capability
TurnStarterFn | object-capability
`TurnStarterFn` | object-capability
TurnStartFn | object-capability
causal console | object-capability
causal annotation | object-capability
assert.note | object-capability
`assert.note` | object-capability
annotateError | object-capability
sending event | object-capability
receiving event | object-capability
sending event causes receiving events | object-capability
event causality DAG | object-capability
turn number | object-capability
event-within-turn counter | object-capability
hiddenPriorError | object-capability
hiddenCurrentTurn | object-capability
hiddenCurrentEvent | object-capability
hidden- prefix | object-capability
meta-level privilege | object-capability
meta-level-privilege framing | object-capability
deliberate global mutable state | object-capability
no observably mutable state | object-capability
diagnostic-only mutable state | object-capability
cyclic dependency disclaimer | object-capability
not in scope before lockdown | object-capability
agoric-sdk 9515 | object-capability
TRACK_TURNS env option | object-capability
`TRACK_TURNS=enabled` | object-capability
TRACK_TURNS=enabled | object-capability
TRACK_TURNS disabled by default | object-capability
DEBUG=track-turns | object-capability
DEBUG track-turns verbose | object-capability
environmentOptionsListHas | object-capability
getEnvironmentOption | object-capability
inert-fallback guard | object-capability
inert when disabled | object-capability
returns funcs unchanged | object-capability
zero-impact-when-disabled | object-capability
closure hoisting | object-capability
closures retain too much | object-capability
HandledPromise retention | object-capability
HandledPromise argument retention | object-capability
hoist out of trackTurns | object-capability
wrapFunction | object-capability
`wrapFunction` | object-capability
addRejectionNote | object-capability
`addRejectionNote` | object-capability
bidirectional error annotation | object-capability
sync throw via try catch | object-capability
async rejection via Promise.catch | object-capability
must capture this now | object-capability
must-capture-this-now timing rule | object-capability
detailsNote eager capture | object-capability
detailsNote string | object-capability
THROWN to top of event loop | object-capability
REJECTED at top of event loop | object-capability
top of event loop | object-capability
microturn top | object-capability
microturn top callback | object-capability
this-free TurnStarterFn | object-capability
this-sensitive function | object-capability
bottom of stack to start a new turn | object-capability
finally clear hiddenPriorError | object-capability
inter-turn hygiene | object-capability
do not leak state across turn boundaries | object-capability
Caused by chain | object-capability
sendingError | object-capability
Event: T.E format | object-capability
Mark S. Miller track-turns | object-capability
