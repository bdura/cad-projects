# OpenSCAD diff-viewing

The goal of this application is to allow a way to generate visual diffs from OpenSCAD source files.

For now, the working workflow has been:

1. Generate an OFF file (which handles colours)
2. Convert it to GLTF format somehow (I've used [this](https://imagetostl.com/convert/file/off/to/gltf)...)
3. View it using the [`GltfModel.vue` component](components/GltfModel.vue)

I need to figure out a way to display actual diffs. Possible avenues:

- find a way to load OFF files directly
- find a way to convert to GLTF offline
- generate different pieces (additions, deletions and noops) separately, and load them with different colours

## The app

This project uses Nuxt and TresJS.

```bash
bun install
bun run dev
```

Look at the [Nuxt documentation](https://nuxt.com/docs/getting-started/introduction) to learn more.
