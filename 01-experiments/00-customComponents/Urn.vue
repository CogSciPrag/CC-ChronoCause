<!--
An urn with two kinds of balls (Ball.vue).

Parameters:
  'firstColor' - color of balls in the left column in the urn; Options: as defined in Ball.vue
  'secondColor' - color of balls in the right column in the urn; Options: as defined in Ball.vue
  'firstCount' - number of balls in the left column in the urn;
  'secondCount' - number of balls in the right column in the urn;
  'firstType' - type of balls in the left column in the urn; Options: as defined in Ball.vue
  'secondType' - type of balls in the right column in the urn; Options: as defined in Ball.vue

Example usage:
  <Urn
    firstColor="green"
    secondColor="red"
    :firstCount="3"
    :secondCount="2"
    firstType="solid"
    secondType="stripe"
  />

-->


<script setup>
import Vue from 'vue';
import Ball from "./Ball.vue"

defineProps({
  firstColor: {
    type: String,
    default: "green",
  },
  secondColor: {
    type: String,
    default: "red",
  },
firstType: {
    type: String,
    default: "solid",
  },
  secondType: {
    type: String,
    default: "solid",
  },
  firstCount: {
    type: Number,
    default: 5,
  },
  secondCount: {
    type: Number,
    default: 5,
  }
})

</script>

<template>
<div class="urn">
        <div class="col">
          <Ball
            v-for="n in firstCount"
            :key="'first-' + n"
            :color="firstColor"
            :type="firstType"
          />
        </div>
        <div class="col">
          <Ball
            v-for="n in secondCount"
            :key="'second-' + n"
            :color="secondColor"
            :type="secondType"
          />
        </div>
      </div>
</template>

<style scoped>
.urn {
  width: 120px;
  border: 2px solid black;
  border-bottom-left-radius: 30px;
  border-bottom-right-radius: 30px;
  display: grid;
  grid-template-columns: auto auto;
  margin-bottom: 10px;
  padding-bottom: 5px;
  padding-top: 10px;
  justify-self: center;
}

.col {
  display: flex;
  flex-direction: column;
  align-items: center;
  gap: 12px;
}
</style>