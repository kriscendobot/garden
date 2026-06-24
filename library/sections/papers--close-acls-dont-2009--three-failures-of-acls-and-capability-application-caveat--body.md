---
title: Body
source: "ACLs don't (Tyler Close, ~2009)"
source_kind: paper
source_authors: [Tyler Close]
source_year: 2009
source_venue: "Position paper (Hewlett-Packard Labs, Palo Alto)"
source_url: https://papers.agoric.com/papers/acls-dont/
source_pdf_sha256: d1ffe9e6e56f513dc83e8143ef7134ffb01f5f30020b10816e4798913181fc75
source_paper_pages: "3-7 (§2.4 ACLs don't authorize correctly through §2.7 Avoiding Confused Deputy within a capability application)"
ingested: 2026-05-29
ingested_by: liaison-direct-draft
topics: [capability-security, capability-theory]
status: current
parent: papers--close-acls-dont-2009--three-failures-of-acls-and-capability-application-caveat
---

### §2.4 The Speaks-for gap and the multi-party authorization failure

The §2.4 paper quotes the *Speaks-for* paper's [10] characterization of the ACL reference monitor's inputs:

> The reference monitor bases its decision on the principal making the request, the operation in the request, and an access rule that controls which principals may perform that operation on the object.

The §2.4 paper then points out the gap:

> Given these inputs, the ACL reference monitor is unable to produce correct access decisions for scenarios involving more than two principals, since the particulars of the operation may have been determined by a principal other than the request sender or the request receiver, and this information is not available to the reference monitor.

The capability reference monitor, by contrast:

> The capability reference monitor performs access checks earlier in the call chain of messages, when the principal designating a particular object is still known. The result of an access check is reified as a capability that can be transferred to other principals, and so used in messages that combine the permission with those of the other principals. A message at the end of such a call chain may exercise permissions contributed by many principals, each one authorizing some specific, smaller part of the requested operation. In a capability language, this construction of messages from capabilities is expressed using the language's normal argument passing syntax.

The §2.4 paper draws the conclusion in the strongest possible terms:

> Although both models can be construed as algorithms operating on an access matrix object, they use different parts of the matrix at different times and grow the matrix in different ways, resulting in different access decisions for identical scenarios. Therefore, the view presented in the Protection paper that ACLs and capabilities are merely different implementation choices for a single access model embodied by the access matrix is incorrect. Moreover, for a given access policy, access decisions are not results that can benignly differ: one is right, the other wrong.

### §2.4.1 RBAC / ABAC / IBAC — same failure under a different name

The §2.4.1 paper considers the ACL variants that have evolved to address client-identification burdens:

> Variations on this model, such as Role-based Access Control (RBAC) and Attribute-based Access Control (ABAC), which seek to address the burdens of client identification, are still vulnerable to the Confused Deputy attack discussed in this paper. These variations on the IBAC model also suffer from the same problem of delaying the access control check until a late stage, when information needed to make a correct access decision is no longer available.

The §2.4.1 framing: *delaying-the-access-control-check-until-a-late-stage* is the load-bearing structural property; the principal-identification mechanism (identity vs role vs attribute) is irrelevant. *Just as with IBAC, RBAC and ABAC fail to account for effects on the requested operation by principals other than the immediate message sender.*

### §2.4.2 setuid — same failure under a different mechanism

The §2.4.2 paper considers the Unix setuid mechanism as a way to switch principal identities mid-operation:

> It is tempting to believe these attacks can be addressed by switching the principal identifier for a running program, such as can be done with the setuid() command in Unix. In the compilation scenario, none of the existing principals is an appropriate one for execution of the output message. As has been shown, running as the Compiler results in a Confused Deputy attack. The Vendor does not have write permission to the User's output file. The compiler should not be allowed to run as the User, since the User may have access to files that should be protected from the Compiler.

The §2.4.2 conclusion:

> Essentially, none of the divisions of permission embodied by the principals correctly isolates the permission needed for the write message.

There is no setuid-flip that gets the access decision right: the desired authorization is *write-to-a.out-on-User's-behalf-but-not-write-to-other-User-files*, which requires *per-operation per-message permission selection* — exactly what capability transfer provides and ACL does not.

The §2.4.2 paper also flags a deeper concern: *the correct implementation of an access policy cannot be ascertained by an examination of the ACLs configured for an application, but must also include an examination of the program's source code. To date, this technique has been error prone.* The setuid pattern *moves part of the authorization logic out of the access-matrix specification and into the application code*, making the access policy globally non-verifiable.

### §2.4.3 Stack introspection — closer, but bounded

The §2.4.3 paper considers Java's stack-introspection mechanism (as implemented in Java 2 Platform Security [6]) as a partial mitigation:

> Since principal identities are too coarse grained to segment authority received from separate sources, perhaps an intersection of identities could provide the needed specificity. Stack introspection, as implemented in the Java platform, bases access decisions on the intersection of the permissions held by a list of principals. By default, this list of principals includes each caller in the call chain leading up to an access check. The access is only allowed if every principal in the list possesses the required permission.

This gets closer:

> If the value of the object identifier used in an access check was determined solely by principals represented in the call chain, this technique defends against a Confused Deputy attack. Since each principal has permission to perform the operation on its own, none of the principals can increase their authority by having another principal execute the operation on their behalf.

But §2.4.3 identifies two structural gaps:

**Gap 1: the call chain may not include the principal who supplied the object identifier.**

> If a principal not represented in the call chain could have an effect on the value of the object identifier, the Confused Deputy vulnerability remains. For example, if any of the callers computed the identifier value based on the value of state held in their lexical scope, such as by reading an object member field, there may be principals who could affect the value of the identifier without being in the call chain.

The §2.4.3 paper acknowledges the Java API's manual workaround (`java.security.AccessController.getContext()`), which lets a caller capture a snapshot of the current principal list, but notes that *this model introduces a need to maintain a corresponding principal list for every member field, and to keep this list consistent with the sequence of assignments done to the member field. If ever a principal has an effect on the value of a member field, without being represented in the corresponding principal list, there is an opportunity for a Confused Deputy attack.*

**Gap 2: a single authorization chain per operation cannot express multi-argument constraints.**

> There are also additional opportunities for Confused Deputy in a stack introspection design. The purpose of a software agent like the Compiler is to mediate an interaction between two or more other principals. Often this mediation involves using the union of their permissions. For example, consider an operation of two parameters. The software agent is to use an object specified by principal A as the first argument and an object specified by principal B as the second argument. Principal A should be prohibited from using principal B's object as the first argument, and vice-versa. In this case, no single principal list can fully express these access constraints, so access checks done by the operation's implementation are necessarily vulnerable to Confused Deputy attacks.

The §2.4.3 conclusion:

> By providing an indivisible representation of an access matrix entry, a capability essentially enforces the discussed tracking of the authorizing principal for every object identifier held by a caller. Since the representation is indivisible, any principal who had an effect on the object identifier must also have held the corresponding permission. Under stack introspection, this tracking of principals is manually implemented at the discretion of the application programmer. ... Such access decisions cannot be correctly done using stack introspection, since at best the model supports tracking of a single authorization chain per operation.

Stack introspection is *closer* to capability transfer than naïve IBAC/RBAC/ABAC, but it cannot express *multi-argument per-argument-principal* authorization. The capability model handles this naturally — each argument carries its own permission, and the operation wields each separately.

### §2.5 Client authentication is misleading for access decisions

The §2.5 paper turns to ACL's other foundational mechanism — *client authentication on every message* (the *who said this* question):

> One of the core features of an ACL message system is the provision of an identifier on every message that identifies the sender. The ability to know "Who said this?" for any given message is generally thought to be important and useful information, and so many deployed systems provide this client authentication. As has already been shown, client authentication is actually misleading when used as the input to an access decision. Other message recipient routines may also rely on client authentication for purposes for which it is unreliable.

The §2.5 paper develops the misleading-authentication argument with a worked example — the User-supplies-second-argument case. In the compilation scenario, the User can provide *any object identifier* as the output filename:

> Since the message target is determined by the User, the User can cause the Compiler to send a write message to any target object of the User's choosing. Depending on the particular implementation, the target object may be limited to one of type file in this case; however, in other implementations and in general, this type restriction may not apply. Consequently, it should in general be assumed that a first principal that can call a second principal can cause that second principal to send a message to any target object of the first principal's choosing. Therefore, a message recipient must not assume that the mere sending of a message represents an expression of intent by the message sender. The targeting of a message may not be something that the message sender exerts control over.

The §2.5 conclusion: *In general, a security reviewer should approach any use of client authentication in a software system with suspicion. Little can be reliably concluded based on client authentication.* The principal identifier on a received message tells you *who relayed the request*, not *who originated the intent*.

### §2.6 ACLs don't assign accountability correctly

The §2.6 paper turns the lens on accountability — *who is responsible when a wrong action occurs?*

> In a Confused Deputy attack, the deputy's permissions are exercised in a way the deputy did not intend and may have been unable to prevent. For example, in the compilation scenario, the User provides the impetus for overwriting the log.txt file, not the Compiler. Holding the Compiler accountable for this abuse is neither fair, nor useful. Redress of the situation requires identification of the User, not the Compiler.

The §2.6 paper argues that accountability requires *intent*:

> For a principal to be usefully held accountable for a message, that principal must have had intent associated with that message. The previous section showed the client authentication attached to a message in an ACL system does not provide a reliable indication of intent. Consequently, this authentication is not a reliable means of assigning accountability for messages.

The §2.6 paper extends the argument to legitimate-use cases — even non-attack scenarios suffer:

> Interestingly, ACLs also fail to assign accountability correctly in legitimate cases. For example, in the non-attack case of the compilation scenario, the Compiler is held accountable for the write to a.out file. Again the Compiler is acting at the impetus of the User; and this time is also using permission received from the User. Holding the Compiler accountable for this write operation makes little sense, but the ACL model provides no alternative.

The §2.6 paper closes with the *capability accountability* discipline. In a capability system:

> In contrast to the ACL model, the capability model doesn't perform delegation by providing the delegate with its own unique representation of a permission. Instead, the delegate directly manipulates the same capability held by the principal that performed the delegation. For example, in the current scenario the first author would create a capability to a file. This capability would then be passed to the co-author. The co-author then passes the same capability to the student. When the student exercises the capability, a simple equality test shows it to be the same one created by the first author. Accountability for the write operation is therefore assigned to the first author. Again through a simple equality test, the first author can determine that the exercised capability is the one delegated to the co-author and so in turn blame the co-author. The co-author, having sent the capability to the student under false pretenses, is ill-equipped to further pass the buck. Regardless of whether or not the co-author in turn blames someone else, the first author has collected sufficient information to know that delegation to the co-author ultimately resulted in unwanted operations and so take action by revoking the capability and not granting the co-author write access in future.

The §2.6 paper points to the **Horton capability protocol** [13] as the comprehensive way to track delegations and take appropriate redress action in dynamic multi-party scenarios.

### §2.7 The crucial caveat — capability applications can re-introduce ACL vulnerabilities

The §2.7 paper provides the caveat that prevents over-reading the previous sections:

> Although the capability model itself is not vulnerable to Confused Deputy attacks, an application built for a capability system could make itself vulnerable to a Confused Deputy attack by effectively re-implementing an ACL design on top of capabilities. For example, an application that keeps a mapping from string names to capabilities and communicates with its clients in terms of these string names is effectively re-implementing the ACL model and so makes itself vulnerable to Confused Deputy attacks.

The §2.7 paper identifies *the crucial step* in a Confused Deputy attack:

> The crucial step in a Confused Deputy attack occurs when an object identifier passes through an intermediate principal without being checked against the access matrix.

This is the structural test. Any system where an object identifier (a string, an integer, a URL, a path) is passed across a protection boundary and *looked up* on the receiving side against a permission table is structurally equivalent to ACL and *will exhibit Confused Deputy vulnerabilities*.

The §2.7 paper gives the canonical fix:

> Wherever a message parameter is of a raw data type, like a text string or integer, and its value identifies an object for which access permission is required, there is a possibility of a Confused Deputy attack. Determining whether or not there is an attack requires examination of the inputs to the routine that eventually performs the dereference operation of looking up the corresponding permission for a given identifier. In a capability system, one of the inputs to this dereference routine must be the list of all permissions that an identifier could map to. If all principals who can determine the value of the identifier have the ability to exercise any of the permissions in the list, there is no Confused Deputy vulnerability. Otherwise, the application may be vulnerable to a Confused Deputy attack, which can be constructed by identifying a principal who can inject the unexpected identifier but should not be able to exercise the corresponding permission.

The §2.7 paper recommends *modifying the API to use the corresponding capability wherever the object identifier is used*:

> In a Unix-like system, the compiler API should be modified to use file descriptors, instead of filenames. Before calling the Compiler, the User opens an output file and includes the file descriptor in the compile message, in place of the output filename. The input filename and log file-name should similarly be replaced with corresponding file descriptors.

This is the canonical *capabilities-by-reference everywhere* discipline. Strings are bait for Confused Deputy attacks; capabilities-by-reference close the gap.
