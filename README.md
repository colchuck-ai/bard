# bard

<p align="center">
  <img src="docs/hero.jpg" alt="A merry bard with a lute raises a tankard of mead, a castle in the distance" width="480">
</p>

An [Agent Skill](https://agentskills.io/home) that makes an agent act as a bard: it gathers a story's raw material, then shapes it with well-known storytelling structures so the audience stays captivated and learns something.

The skill itself lives in [`bard/`](bard/). Its workflow:

1. **Frame**: audience, occasion, length, one-sentence takeaway, and fidelity (documentary, dramatized, or invented).
2. **Gather**: interview the user in rounds, mine repos and files, research, and prepare interview guides for other stakeholders. Every fact goes in a source ledger.
3. **Brief**: a one-page story brief, confirmed with the user before drafting when there was an interview.
4. **Structure**: pick one structure by genre, then by purpose (SCQA, Sparkline, Customer-as-hero, Mystery, Kishōtenketsu, Story Spine, Three-act, Story Circle, Hero's Journey), compressed to ABT form for short pieces.
5. **Draft** to the target format (talk script, case study, and so on), 6. **Critique** against a checklist, 7. **Adapt** into extra formats or a length ladder and deliver with short notes.

It can stop early and deliver just a story brief or outline, or just an interview guide for someone else.

```mermaid
flowchart TD
    A["1. Frame<br/>audience, length, takeaway, fidelity"] --> B{"Material lives<br/>with the user?"}
    B -- yes --> C["2. Gather<br/>interview rounds, mine files, research"]
    B -- "no: supplied, general, or invented" --> E
    C --> D["3. Brief<br/>confirm with the user"]
    C -. "guide only" .-> G1(["Deliver interview guide"])
    D --> E["4. Structure<br/>pick one, outline beats"]
    E -- "beat has no material" --> C
    E -. "brief or outline only" .-> G2(["Deliver brief / outline"])
    E --> F["5. Draft"]
    F --> H["6. Critique"]
    H -- "a check fails" --> F
    H --> I["7. Adapt and deliver<br/>piece + short notes"]
```

For fun, the bard's voice is opt-in medieval, measured in tankards of mead: from 0 (sober scribe) up to "the whole barrel" (rhyming recaps and toasts to you). It flavors only the bard's chat, never the story, and facts stay exact. Say "bard, two tankards" or "sober up" any time.

It covers technical, business, educational, and creative/personal stories.

## Usage

Ask an agent for a story, e.g. "help me turn our database migration into a 5-minute talk" or "write a short story that teaches new hires how DNS works".

## Install

```bash
./install.sh                  # ~/.cursor/skills/bard (default)
./install.sh --agent claude   # ~/.claude/skills/bard
./install.sh --help           # other agents and custom directories
```

Run from a clone, it installs that checkout. Run on its own (e.g. piped from curl), it clones `main` first. It refuses to overwrite a non-empty directory that isn't already a bard install.

## Contents

- `bard/SKILL.md`: the workflow
- `bard/references/interviewing.md`: interview rounds, source mining, stop criteria
- `bard/references/structures.md`: structure selection table and beats
- `bard/references/craft.md`: openings, tension, specificity, teaching, endings, revision
- `bard/references/formats.md`: talk scripts, slides, length ladder, written formats
- `bard/references/voice.md`: the opt-in Mead Measure voice levels
- `bard/assets/story-brief.md`: story brief and source ledger template
- `bard/assets/interview-guide.md`: stakeholder interview guide template
- `bard/evals/evals.json`: eval cases (run with and without the skill; not copied by install.sh)

## License

MIT. See [LICENSE](LICENSE).
