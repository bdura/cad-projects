<script lang="ts" setup>
import { STLLoader } from "three/addons/loaders/STLLoader";
const scene = await useLoader(STLLoader, "/changes.stl");
</script>

<template>
  <primitive :object="scene" />
</template>
