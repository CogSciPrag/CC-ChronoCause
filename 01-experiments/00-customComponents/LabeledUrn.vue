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
-->


<script setup>
import Vue from 'vue';
import Ball from "./Ball.vue"
import LabeledBall from "./LabeledBall.vue";

defineProps({
  firstColor: {
    type: String,
    default: "green",
  },
  secondColor: {
    type: String,
    default: "red",
  },
  thirdColor: {
    type: String,
    default: "green",
  },
  fourthColor: {
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
  thirdType: {
    type: String,
    default: "solid",
  },
  fourthType: {
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
  },
  thirdCount: {
    type: Number,
    default: 0,
  },
  fourthCount: {
    type: Number,
    default: 0,
  },
  firstLabel: {
    type: String,
    default: "A",
  },
  secondLabel: {
    type: String,
    default: "B",
  },
  thirdLabel: {
    type: String,
    default: "A",
  },
  fourthLabel: {
    type: String,
    default: "B",
  },
  highlight: {
    type: Boolean,
    default: false,
  }
})

</script>

<template>
  <div class="urn" :class="highlight">
    <div class="col">
      <LabeledBall
          v-for="n in firstCount"
          :key="'first-' + n"
          :color="firstColor"
          :type="firstType"
          :label="firstLabel"
      />
      <LabeledBall
          v-for="n in thirdCount"
          :key="'third-' + n"
          :color="thirdColor"
          :type="thirdType"
          :label="thirdLabel"
      />
    </div>
    <div class="col">
      <LabeledBall
          v-for="n in secondCount"
          :key="'second-' + n"
          :color="secondColor"
          :type="secondType"
          :label="secondLabel"
      />
      <LabeledBall
          v-for="n in fourthCount"
          :key="'fourth-' + n"
          :color="fourthColor"
          :type="fourthType"
          :label="fourthLabel"
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

.blackHighlight {
  border: 2px solid black;
}

.magentaHighlight {
  border: 6px solid #A8326F;
}

.tealHighlight {
  border: 6px solid #1F8A8A;
}


</style>