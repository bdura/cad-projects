<script lang="ts" setup>
import { GLTFLoader } from "three/addons/loaders/GLTFLoader";

const { scene } = await useLoader(GLTFLoader, "/changes.gltf");
</script>

<template>
  <primitive :object="scene" />
</template>
