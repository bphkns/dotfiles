import { formatSkillsForPrompt, type ExtensionAPI } from "@earendil-works/pi-coding-agent";

// Everything else stays available through /skill:name, without advertising it every turn.
const automaticSkills = new Set([
  "add-dark-mode",
  "agent-browser",
  "animate",
  "animation-accessibility",
  "animation-performance",
  "animation-vocabulary",
  "brand-kit",
  "canonicalize-tailwind",
  "componentize",
  "css-animations",
  "dark-mode-image",
  "debug-animation",
  "defensive-css",
  "design",
  "gesture-ui",
  "ideas",
  "make-responsive",
  "markup-from-image",
  "motion-brief",
  "motion-react",
  "pi-lens-ast-grep",
  "pi-lens-lsp-navigation",
  "ponytail",
  "scroll-animations",
  "supabase-postgres-best-practices",
  "tdd",
  "workers-best-practices",
  "wrangler",
]);

export default function skillContext(pi: ExtensionAPI) {
  pi.on("before_agent_start", ({ systemPromptOptions: options }) => {
    const skills = options.skills ?? [];
    options.skills = skills.map((skill) =>
      skill.sourceInfo.scope === "project" || automaticSkills.has(skill.name)
        ? skill
        : { ...skill, disableModelInvocation: true },
    );

    // Ponytail can force a complete prompt. Preserve it, replacing only Pi's skill catalog.
    if (options.forceSystemPrompt === undefined) return;
    const reader = options.selectedTools?.includes("read") ? "read" : "bash";
    const previous = formatSkillsForPrompt(skills, reader).trim();
    if (!previous) return;
    const next = formatSkillsForPrompt(options.skills, reader).trim();
    options.forceSystemPrompt = options.forceSystemPrompt.replace(
      `<skills>\n${previous}\n</skills>`,
      () => next ? `<skills>\n${next}\n</skills>` : "",
    );
  });
}
