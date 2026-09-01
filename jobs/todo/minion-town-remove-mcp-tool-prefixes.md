---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
Repository: kriscendobot/minion.town.

Rename the public MCP tool-call surface to remove the implementation/category prefixes `guest_` and `clip_`, so tool names read like the methods of the Endo agent/guest interface rather than transport routing labels. Audit the actual agent, guest, directory, mailbox, evaluation, and sites/clip facet method vocabulary and make the MCP names align with those methods wherever possible. Preserve clear in-band titles, descriptions, schemas, authority requirements, and error guidance so an agent can discover the surface without repository knowledge.

Resolve the name collision that naïvely removing prefixes creates (notably `guest_list` versus `clip_list`) by choosing interface-native, unambiguous method names rather than retaining category prefixes. Document the full old-to-new mapping and compatibility posture; if aliases are temporarily retained, mark them deprecated and ensure discovery presents the canonical unprefixed names without ambiguity. Update every server registration, client/doc example, test fixture, OAuth/tool policy reference, and deployment check that names these tools. Add an MCP tools/list contract test proving all canonical names are unique and contain neither `guest_` nor `clip_`, plus behavioral tests for evaluation, directory operations, messaging, and clip publication through the renamed surface.

After deployment, run a blind discovery evaluation with an agent that has no repository or prior minion.town context and receives only the directive `evaluate 2 + 2`. Record whether tools/list documentation alone leads it to the correct confined evaluation call and result, and post any documentation deficiencies as explicit follow-ups.
