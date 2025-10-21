# Agent Info — Anime 3rd Person Movement

## Quick Facts
- Engine: Godot 4.5 (Forward Plus renderer)
- Language: GDScript unless a specific subsystem benefits from C#
- Target platforms: desktop PC, later adaptable to console
- Character assets: VRM humanoid avatars with anime aesthetics

## Vision
Deliver a responsive, weighty third-person controller inspired by Genshin Impact movement and combat pacing, while leveraging the flexibility of VRM models so creators can drop in custom characters without re-rigging.

### Player Experience Goals
- Snappy locomotion with clear acceleration, deceleration, and short dash bursts.
- Highly readable camera framing that keeps the avatar visible and anticipates platforming needs.
- Context-aware animation blending (idle, jog, sprint, glide, climb) that feels expressive for anime characters.
- Hook points for future combat, gliding, stamina, elemental abilities, and co-op extensions.

## Current State Snapshot
- Godot project scaffolded under `anime-3-rd-person-movement/`.
- Root scene `main.tscn` is empty and ready for a world/level container.
- No scripts or assets committed yet; movement, camera, UI, and gameplay logic remain to be implemented.

## First Implementation Milestones
1. **Core Locomotion**  
   - Third-person controller node with walk/run, sprint toggle, jump, short-air control, configurable acceleration curves.  
   - Ground detection using raycasts and slope/step handling.  
   - State machine covering Idle, Move, Sprint, Jump, Fall, Land.

2. **Camera Rig**  
   - Spring-arm or custom follow camera with collision avoidance and aim offset.  
   - Shoulder swap and sensitivity settings exposed for input remapping.

3. **Input System**  
   - Use Godot's `InputMap` for keyboard/mouse and gamepad parity.  
   - Provide an input abstraction layer so VRM gestures or future network input can reuse the same interface.

4. **Animation Layer**  
   - AnimationTree with blend spaces keyed to velocity and state machine transitions.  
   - Hooks for additive upper-body blends (e.g., aiming, casting).

5. **VRM Integration**  
   - Evaluate the `godot-vrm` add-on (https://github.com/saturday06/godot-vrm) for loading humanoid avatars.  
   - Confirm compatibility with Godot 4.5; if issues arise, pin to the recommended commit or vendor the necessary subset.  
   - Provide a lightweight character loader scene that pairs the VRM skeleton to the controller rig and inserts avatar-specific animation retargeting profiles.

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

## Open Questions / Follow-Ups
- Confirm whether glide/climb systems are part of MVP or future milestone.  
- Decide on stamina/energy system integration for sprinting or dashing.  
- Determine UI/UX requirements (e.g., lock-on, minimap, dialogue).

Keep this document updated as systems land so future agents have an accurate snapshot of project direction and conventions.
