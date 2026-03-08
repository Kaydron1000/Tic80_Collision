# Tic80_Collision
Collision Example using Tic80

This project uses the [ticbuild](https://github.com/thenfour/ticbuild_vscode) in VSCode.

This project is creating collision functions to trail, explore, and understand.

This project is also trailing structure of code tic loop.

Key Items:
- Each frame or tic is agnostic of other frames
- Each sprite should contain and resolve as much as possible on their own
  - On multiple collsions this is not possible
    - Example: Player pushes block into wall - player movement is dependent on block movement

General structure:
- clear movement/actions
- Build Current Grid (intended for NPC AI)
- Actions
- Build Next Grid (used to resolve actions)
- Check Collisions
- Reactions
