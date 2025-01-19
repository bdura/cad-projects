<script lang="ts" setup>
import { OBJLoader } from "three/addons/loaders/OBJLoader";
import { STLLoader } from "three/addons/loaders/STLLoader";
import { GLTFLoader } from "three/addons/loaders/GLTFLoader";

const scene = await useLoader(OBJLoader, "/changes.obj");
</script>

<template>
  <primitive :object="scene" />
</template>
