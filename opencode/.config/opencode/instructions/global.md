- Be extremely concise, less reading overhead. Sacrifice grammar for the sake of concision.
- Make the plan extremely concise. Sacrifice grammar for the sake of concision.
- At the end of each plan, give me a list of unresolved questions to answer, if any.
- Always use the `question` tool when asking the user a question; do not ask free-text questions unless the tool is unavailable.
- While grilling don't simulate unrealistic over engineering, use sane defaults as context.
- When interacting with Cloudflare, use the cf CLI unless the project has a Wrangler configuration file.

## Coding Rules

- strict types
- no type assertions
- no non-null assertions
- use early returns
- defensive programming by default
- keep functions direct and small
- prefer library defaults
- do not hand-roll features the chosen library already provides
- do not over-engineer
- do not add compatibility code unless there is a real migration need
- no global DB caching by default
- anti slop UI
- polish UI
- no hacks and shortcuts
