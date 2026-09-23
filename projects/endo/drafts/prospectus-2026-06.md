---
created: 2026-06-11
updated: 2026-06-11
author: journalist
status: draft-for-maintainer-triage
---

# The Capability Node: A Prospectus

*An essay for the investor who already believes in user agency, and is deciding whether this team, now.*

## The window is open and it will not stay open

You already accept the decentralization thesis, so this essay will not spend its budget convincing you that platform giants have captured the user. Kris Kowal's 2024 essay "A Choice of Giants" made that case: the social, search, and artificial-intelligence giants have herded users into pens, the browser we still politely call a "user agent" no longer represents the user, and the app store offers to guard the gate while collecting the rent. You can read it for the argument. What follows is about timing, about the moat, about the plan, and about the money.

The timing is the part that is new since that essay was written, and it is the part most worth your attention. The thing that has changed in two years is not the theory. It is the demand.

In November 2024 Anthropic published the Model Context Protocol, a JSON-RPC standard for connecting agent hosts (Claude Desktop, Cursor, VS Code) to tools and data. Within a year the reference server repository had passed eighty-seven thousand stars, OpenAI had declared support, and several cloud platforms had stood up general-purpose MCP hosting. The protocol succeeded. And in succeeding it created, at scale, exactly the problem that thirty years of capability theory was built to solve.

The problem has a name in MCP's own security specification: ambient authority. The spec's Scope Minimization section is candid about it. The common pattern is to publish every scope a server can offer, request them all up front, and bundle unrelated privileges "to preempt future prompts." The result is that today's typical MCP integration hands an agent a bearer token to your *entire* GitHub, your *whole* Notion, the full surface of whatever it touches. The spec recommends least privilege; the spec is advisory; most shipping integrations do not follow it. An April 2025 safety audit (Radosevich and Halloran, arXiv:2504.03767) went further and demonstrated that leading models can be coerced through MCP tools into remote-access takeover and credential theft, and shipped a scanner to prove the point.

This is the acute, named enterprise anxiety. It is not a slide we drew; it is in the protocol's own documentation and in the security literature. Agent sprawl has made over-permissioning a board-level worry, and it arrived on a schedule that no capability project before this one enjoyed. The first wave (E, CapDesk, Polaris) had the remedy and no demand. We have the remedy and the demand has come to us.

## The moat is the discipline, not the bridge

It would be a mistake to describe this company as "MCP hosting," and I want to be plain about why, because the distinction is the whole investment thesis.

Hosting an MCP server is becoming a commodity. The protocol treats local and remote servers as equivalent; the hosting function is, structurally, infrastructure that any compliant provider can run, and Cloudflare, Sentry, and others already run it. If the pitch were "we host MCP servers too," the category would compete the margin to nothing inside two years. We would be selling a substitutable input.

The differentiator is one layer down: *what authority model governs the grant.* Where a commodity MCP host hands the agent your whole GitHub token, an Endo node grants the agent an **attenuated capability**: one repository, not your GitHub; a directory, not your disk; revocable, auditable, and scoped per agent. The agent never holds the broad authority in the first place. It proposes the attenuation it needs, as code derived from interface and behavior descriptions, holding nothing; review and endowment stay with the party that actually holds the authority, ultimately the user. The trusted compute base is the user's own agent, the **Familiar**.

That is the moat, and it has two reinforcing parts.

The first is the discipline itself, which is genuinely hard to retrofit. Attenuation is not a feature you bolt onto an ambient-authority system; it is a property of the substrate or it is theater. You cannot take a service that holds a broad bearer token and credibly claim per-agent revocability after the fact. A competitor who starts from ambient grants has to rebuild from the bottom to catch up, and most of them have no reason to: their customers have not yet felt the bill come due.

The second is lineage. The attenuation model is not a research bet placed last quarter. It is the productization of object-capability security, a body of work with a thirty-year track record of technical success: Mark Miller's E language in 1997, HP Labs' CapDesk and Polaris in the early 2000s. Polaris is worth naming precisely, because it demonstrated, around 2005, the exact interaction this product sells. It confined an unmodified Excel spreadsheet on an unmodified Windows: when the spreadsheet tried to open a file, Polaris intercepted, asked the user, and conveyed only the chosen file, not a file-system handle. That is "agent proposes, user endows, authority stays attenuated at the boundary," demonstrated twenty years before the agent that needed it existed. The same lineage runs through Hardened JavaScript (SES), which the same people built into the language that now runs everywhere, and into Endo. You are not buying an unproven idea. You are buying a proven idea that has finally met its market.

I will be candid about the other half of that lineage in the bear-brief that accompanies this prospectus: those same systems achieved no commercial adoption, and the reasons matter. The short version is that they had to replace platforms that gave them no foothold, started from zero installed base, and arrived before the failure they prevented had happened at scale. What is different now is that the discipline ships *inside* JavaScript rather than as a new runtime, the demand exists in the form of MCP over-permissioning, and there is a commercial vehicle to fund the work. Those three differences are the thesis; the bear-brief tests them at full strength.

## The plan ships in stages, and each stage is a product

A commons vision tends to fail as a business because it asks an investor to fund an ideology and wait. This plan does not. The hosted-gateway north star resolves into two staged objectives built on one body of technology, and each stage is independently shippable and independently saleable.

**O1, the turn-key self-custodial node.** A user deploys a node from a cloud marketplace listing, AWS first, in one sitting. The node terminates MCP for external clients (Claude Desktop, Cursor, OpenAI-compatible), bonds an OAuth identity to the user's public-key identity, meters and bills resources, and grants agents attenuated capabilities instead of ambient authority. The customer is the operator, and the operator is the user. This is a product a developer buys for themselves: always-online agent tools without handing a SaaS the keys to everything.

**O2, the community hub.** The same node software, operated by one person for many members, providing the services a good internet service provider once did: relaying and NAT traversal, mail delivery, anonymization, curation, always-online capabilities. Members onboard by invitation. The unit of trust widens from the single operator to the community.

The structural elegance, the part to underline, is that **O2 is the federation bootstrap and the commercial channel is what seeds it.** Every O1 customer is a latent O2 operator. We do not have to solve federation's cold-start problem by evangelism; we sell single-operator nodes that happen to be community hubs waiting for a second member. The commercial channel and the federation seed are the same artifact. There are no app stores in this model and therefore no app-store rents; the artifacts a user makes are durable, and the capabilities underneath are substitutable, including the inference itself, which is a purchased input and never a load-bearing dependence on any one giant.

## The execution evidence, in the ledger's own terms

Here I will be careful, because the temptation in a prospectus is to round work up. The project keeps a design ledger (`designs/README.md` on the `llm` branch of `endojs/endo-but-for-bots`), and it is the only source of truth I will cite for status. Where the ledger says Proposed or In Progress, I say Proposed or In Progress.

What the ledger records as done is not a demo reel. As of the current ledger, of one hundred thirty-five tracked designs, thirty-nine are Complete or Implemented. Two foundational milestones are closed outright: a downloadable Familiar application that a person can install and use to drive an agent with their own key and local capabilities (Milestone 1, seven designs Complete, exit criterion met), and a project-hygiene milestone that factored the shared libraries and hardened the build (Milestone 2). The secure peer transport that federation rests on, OCapN-Noise, is **Complete** and landed via a merged pull request. The bearer-token authorization model the gateway extends is **Implemented**. These are not aspirations; they are merged.

The product itself, the gateway, is mid-construction and the ledger shows it honestly. The gateway implementation stack is **In Progress**: of eleven phases, nine are open as pull requests right now (UDS bootstrap, admin, the OCapN WebSocket transport, relay policy, Git-over-HTTP, the apps name hub, the resource ledger, and the Familiar-bundled fallback), with two phases pending (HTTPS proxy compatibility and operating-system packaging). That last one matters commercially and the roadmap now treats it as load-bearing rather than a tail: for a marketplace listing, the packaged image *is* the product.

The MCP termination layer, the bridge that turns this into the product an MCP-client user buys, has its design written and merged but its implementation **Not Started** in the ledger's terms. The four pieces that make O1 a *commercial* product rather than a self-host story (OAuth-to-identity bonding, key recovery, the Stripe billing adapter, and the resource-class metering taxonomy) are named **design gaps** in the ledger, scheduled, not yet built. I am not going to tell you they are shipped. The honest read is that the substrate is largely built and merged, the product layer is in flight, and the commercial layer is specified-and-scheduled. That is the candid stage of a company raising now: past the risky foundations, in front of the revenue work.

A word on the timeline numbers, since you will want them. The roadmap estimates the shortest route to a working hosted node (gateway phases 10 and 11, MCP termination, AWS hosting, Stripe, and OAuth bonding with key recovery) at roughly six to nine weeks of focused work, with the binding constraint being review throughput rather than authorship. I report that as the team's own estimate against its own velocity calibration, not as a promise; the bear-brief discusses the single-maintainer concentration that makes review the constraint.

## Funding the commons, honestly in both directions

The relationship between the product and the commons is the place where projects like this most often deceive their investors or their communities, usually both, so let me state it plainly and in both directions.

The commons is not a loss leader. The capability discipline, the substitutable inference, the durable artifacts, the federated hubs: these are the point, not the bait. We are not building a free tier to upsell a cage.

And the product is not a betrayal of the commons. O1 and O2 are the commons, sold. The hosted node a customer pays for is the same software a community runs for itself, and the revenue from operators is what funds the development that the commons needs and that no commons funds on its own. The commercializable component pays for the part that does not commercialize. That is the whole financial logic, and it only works because, as above, the product and the federation seed are the same artifact rather than two roadmaps competing for one team.

On vocabulary, one honest note that the writing should never blur: the node meters resources in units the roadmap names computrons (compute), cogitrons (inference), and counts for storage and network. These are **metering units, not crypto assets.** They are how a customer predicts a bill, in the way an electricity meter counts kilowatt-hours. There is no token sale, no chain, no speculative instrument. Customers forgive rough edges in a young product; they do not forgive metering they cannot predict, which is why pricing legibility is treated as a design requirement and not an afterthought, and why the vocabulary stays deliberately un-crypto.

## What you are deciding

You are not deciding whether decentralization matters; you already think it does. You are deciding whether *this* remedy, from *this* team, *now*, is the one to back.

The remedy is capability attenuation, which has thirty years of technical proof and, for the first time, a demand pulling it into the market in the shape of agent over-permissioning that the MCP ecosystem documents in its own specification. The team is the lineage that built E, the SES discipline in JavaScript, and Endo, now turning a working implementation into a packaged product. The plan ships in two stages that are each a sellable product and that together bootstrap a federation through the commercial channel rather than against it. And the money funds a commons that is the point rather than the pretext.

What I cannot offer you is a finished product; the ledger would catch me if I tried, and I would rather you trusted the ledger than me. What I can offer is a foundation that is built and merged, a product layer in flight with its phases visible as open pull requests, and a commercial layer specified down to its named gaps. The window the MCP moment opened is the asset that depreciates. Everything else is on the table to be inspected.

---

*Status claims in this essay trace to `designs/README.md` on the `llm` branch of `endojs/endo-but-for-bots` as of 2026-06-11. Market and historical claims trace to scholar-shelved library research: the MCP gateway-hosting landscape, the object-capability history (E, CapDesk, Polaris, Waterken), and "A Choice of Giants." No metrics, customers, or market sizes are invented; where the ledger marks work Proposed, In Progress, or a design gap, this essay says so.*
