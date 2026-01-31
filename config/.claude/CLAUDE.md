## Development Principles

### Agent-First
- Delegate complex work to specialized agents
- Use Task tool with appropriate subagent_type

### Parallel Execution
- Execute independent tasks in parallel
- Send multiple Task tool calls in a single message

### Plan Before Execute
- Use Plan Mode for complex operations
- Understand the full picture and get user approval before implementation
- Use AskUserQuestion tool to clarify requirements or confirm approach

### Test-Driven Development
- Write tests before implementation
- Follow twada's TDD methodology: Red → Green → Refactor
- Commit after confirming the test fails
- Write minimal implementation to pass the test

### Security-First
- Never compromise on security
- Never write code containing vulnerabilities

---

## Testing Rules

- Minimize the use of mocks
- **Database mocking is prohibited** - Use actual databases for testing
- Mocks are only allowed when unavoidable (e.g., external APIs)

---

## Comment Rules

- **Write Why**: Document the reasoning and intent behind decisions
- Comments that only explain What (processing content) are allowed only for:
  - Complex processing spanning multiple lines
  - Complex logic with multiple control statements
- No comments needed for self-explanatory code

---

## JavaScript/TypeScript Rules

- Always use the packageManager defined in the project
- **`npx` is prohibited**: Commands that download and execute tools on-the-fly pose security risks
- Only use tools already installed in the project

---

## Git Rules

- **Conventional commit**: `feat:`, `fix:`, `build:`, `chore:`, `ci:`, `docs:`, `refactor:`, `perf:`, `test:`
- **Never work directly on main branch** - Create pull requests for each feature/fix
- Make small, frequent commits per logical unit of work
- **History rewriting is prohibited**: Do not use `--amend`, `--force`, or any commands that alter commit history

---

## Always Follow

### Use Latest Practices
- Research and use the latest features and patterns
- Leverage context7, deepwiki for documentation reference
- Prefer modern best practices over legacy approaches

### Be Honest
- Clearly state "I cannot do this" or "This is not possible" when applicable
- Never proceed based on assumptions
- Ask questions when something is unclear

### Answer Questions First
- When the user asks a question (especially ending with `?`), answer the question first
- Do not start working without permission
- After answering, propose work if necessary

---

**Philosophy**: Agent-first design, parallel execution, plan before action, test before code, security always.
