# Agent Info — Project Aurora Controller

## Quick Facts
- Engine: Godot 4.5 (Forward Plus renderer)
- Language: Primarily GDScript, C# considered for perf-critical systems
- Target platforms: Desktop PC first, console-friendly architecture
- Character assets: Stylised anime humanoids (VRM + custom rigs)
- Working title proposal: **Project Aurora Controller** (anime-inspired, Bethesda-style hybrid)

## Vision
Deliver a responsive hybrid character controller that supports both third-person and first-person perspectives in the spirit of modern Bethesda RPGs, while retaining anime aesthetics and eventual fully simulated secondary motion (hair, cloth, soft-body regions).

### Player Experience Goals
- Seamless walk/run/sprint locomotion with terrain-dependent modifiers and tight camera control.
- Toggleable first-person / third-person camera with configurable shoulder offset, FOV, and zoom.
- Rich environmental interaction hooks (ladders, swimming, mounts) prepared for later phases.
- Expressive anime presentation with space for physics-driven secondary motion (hair, cloth, body soft-body response).

## Current State Snapshot
- Modular scene structure in place (`PlayerController`, `ThirdPersonCamera`, `DebugHUD`).
- Three-stage ground locomotion (walk/run/sprint) partially implemented; tuning in progress.
- Basic debug HUD, reset workflow, and camera recapture logic operational.
- Animation, stats, physics-driven secondary motion, and NPC controllers not yet implemented.

## First Implementation Milestones
1. **Ground Locomotion Tier**  
   - Finalise walk/run/sprint tiers with clean acceleration/deceleration and stamina hooks.  
   - State machine support for idle, walk, run, sprint, jump, fall, land, crouch (placeholder).  
   - Terrain material sampling for speed modifiers (mud, snow, foliage) queued for later.

2. **Camera Suite**  
   - Third-person orbit rig with anti-clip, shoulder swap, zoom.  
   - First-person camera module sharing input with sensitivity overrides.  
   - Smooth transition between perspectives.

3. **Input & Settings**  
   - Centralised input abstraction for player/NPC control hand-off.  
   - Debug menu to tweak movement tiers and camera parameters at runtime; save loadouts.

4. **Stats & Resources**  
   - `CharacterStats` resource for health, stamina, magicka placeholders.  
   - Stamina drain/regeneration powering sprint/jump; extension-ready for combat.

5. **Animation & Physics Layer (Phase 2)**  
   - Separate animation controller fed by locomotion state data.  
   - Plan for secondary motion: hair/cloth/breast/belly physics via skeleton constraints or soft-body proxies.  
   - Evaluate Godot’s soft body/cloth options and third-party addons.

6. **NPC & AI Integration (Phase 2)**  
   - Convert controller into reusable pawn interface for AI.  
   - Navigation hooks (NavAgent3D) and behaviour tree integration stub.

7. **VRM & Avatar Pipeline**  
   - VRM importer evaluation, retargeting profiles, anime-specific shading pipeline.  
   - Document requirements for physics-ready skeletons (extra bones, constraints).

## Technical Guidelines
- **Scene Layout**: Favor a world root scene that instantiates the player, camera rig, and temporary test environment. Use reusable sub-scenes for controller, camera, and UI.  
- **Scripting**: Follow Godot 4 GDScript style (snake_case functions, PascalCase classes). Organize scripts under `res://scripts/`.  
- **State Machines**: Use enums or string constants for state IDs, encapsulate transitions to keep logic explicit.  
- **Physics**: Use `CharacterBody3D` as the base node for the controller. Keep physics tick deterministic by limiting per-frame impulses.  
- **Config**: Expose tunable values via exported variables grouped with `@export_group` for designer-friendly tweaking.

## Testing & Tooling
- Add a simple debug HUD (Godot `Control`) that surfaces velocity, current state, and grounded flag.  
- Record small Godot `*.tres` test scenes that stress slopes, steps, and moving platforms.  
- Keep playtest checklist updated once traversal mechanics land (feel, camera stability, input edge cases).

## Asset & Animation Notes
- Store VRM files under `res://avatars/` (git-lfs recommended once repo grows).  
- Maintain retargeting profiles and animation resources in `res://animations/`.  
- Use placeholder animations from Mixamo or CC0 packs until bespoke anime motions are ready.  
- Document requirements for secondary motion bones and physics constraints early to avoid re-rigging.

## Open Questions / Follow-Ups
- Finalise project rename (proposed “Project Aurora Controller” vs. legacy title).  
- Decide when to introduce first-person camera and weapon handling.  
- Establish roadmap for NPC parity and AI driving of the controller.  
- Research cloth/soft-body workflow (built-in vs. plugin) and performance constraints.  
- Define how terrain material data feeds locomotion modifiers.

Keep this document updated as systems land so future agents have an accurate snapshot of project direction and conventions.
