# Contributing to cypress-agent-skill

Thanks for helping improve this skill. A few ground rules:

## What We Want

- **Real-world patterns** — patterns you've actually used in production
- **Common failure modes** — flake causes, gotchas, edge cases
- **CI/CD specifics** — real configs from real pipelines
- **New Cypress features** — as new versions ship, the skill should keep up

## What We Don't Want

- Toy examples that don't reflect real usage
- Duplicate patterns already covered in the main SKILL.md
- Changes that break the flat directory structure

## Structure Rules

The repo must stay flat:
```
cypress-agent-skill/
├── SKILL.md          ← root, agents read this directly
├── references/       ← deep dives
└── examples/         ← working .cy.js files
```

**Never add a subdirectory with its own SKILL.md.** Agents install this repo as their skill root. Nesting breaks that.

## How to Contribute

1. Fork the repo
2. Create a branch: `git checkout -b feat/your-pattern`
3. Make your changes
4. Run the validator locally:
   ```bash
   bash -n install.sh        # check install.sh syntax
   node --check examples/*.js  # check JS syntax
   python3 -c "
   with open('SKILL.md') as f: c = f.read()
   assert c.startswith('---'), 'Missing frontmatter'
   assert 'name:' in c[:200], 'Missing name field'
   assert 'description:' in c[:500], 'Missing description field'
   print('Frontmatter OK')
   "
   ```
5. Open a PR with a clear description of what you're adding and why

## Updating References

Each file in `references/` covers one domain. Add to the most relevant file. If a topic genuinely doesn't fit any existing file, propose a new one in your PR description.

## Updating Examples

Examples in `examples/` should be **complete, runnable test files** — not snippets. They should demonstrate real patterns (auth flows, API stubs, POM) not just `cy.visit()` + `cy.get()`.

## Questions

Open a GitHub Discussion or an Issue.