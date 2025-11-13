<!--
The component is comprised of two urns with a variable number of black and orange marbles.
After the user presses the button, balls with specified colors appear under each urn.
Each can appear with a specified delay.
The indicator shows that the game is underway; it stops when the longer delay has elapsed.

(Optional) parameters:
':timingLeft' - delay with which a ball is 'released' from the left urn; Value: time in ms; default: 1000
':timingRight' - delay with which a ball is 'released' from the right urn; Value: time in ms; default: 1000
':outputLeft' - color of ball released from the left urn; Options: orange, black; default: orange
':outputRight' - color of ball released from the right urn; Options: orange, black; default: orange
':countOrangeLeft' - number of orange balls in the left urn: Value: number of balls; default: 5
':countOrangeRight' - number of orange balls in the right urn: Value: number of balls; default: 5
':countBlackLeft'- number of black balls in the left urn: Value: number of balls; default: 5
':countOrangeRight'- number of black balls in the right urn: Value: number of balls; default: 5

Example usage:

<NonLeakyUrns
  :timingLeft="1000"
  :timingRight="3000"
  :outputLeft="orange"
  :outputRight="black"
  :countOrangeLeft="3"
  :countOrangeRight="5"
  :countBlackLeft="2"
  :countBlackRight="5"
/>

-->

<script setup>
import Vue from "vue";
import { ref } from "vue";
import Ball from "./Ball.vue";
import Urn from "./Urn.vue";
import Spinner from "vue-spinkit";

Vue.component("Spinner", Spinner);

const props = defineProps({
  timingLeft: {
    type: Number,
    default: 1000
  },
  timingRight: {
    type: Number,
    default: 1000
  },
  outputLeft: {
    type: String,
    default: 'orange'
  },
  outputRight: {
    type: String,
    default: 'orange'
  },
  countOrangeLeft: {
    type: Number,
    default: 5
  },
  countBlackLeft: {
    type: Number,
    default: 5
  },
  countOrangeRight: {
    type: Number,
    default: 5
  },
  countBlackRight: {
    type: Number,
    default: 5
  }
});

const leftBallVisible = ref(false);
const rightBallVisible = ref(false);
const fixationVisible = ref(false);
const nextBtnVisible = ref(false);


function runGame() {
  const fixationTiming =
    props.timingLeft > props.timingRight ? props.timingLeft : props.timingRight;

  fixationVisible.value = true;

  setTimeout(() => {
    leftBallVisible.value = true;
  }, props.timingLeft);

  setTimeout(() => {
    rightBallVisible.value = true;
  }, props.timingRight);

  setTimeout(() => {
    fixationVisible.value = false;
  }, fixationTiming);

  setTimeout(() => {
    nextBtnVisible.value = true;
  }, fixationTiming + 1000);
}
</script>

<template>
  <div class="game">

    <button @click="runGame">Begin</button>

    <div class="gamedisplay">

      <Urn
      firstColor="black"
      secondColor="orange"
      :firstCount="countBlackLeft"
      :secondCount="countOrangeLeft"
      class="leftUrn"/>

      <Urn
      firstColor="black"
      secondColor="orange"
      :firstCount="countBlackRight"
      :secondCount="countOrangeRight"
      class="rightUrn"/>

      <svg class="arrow leftArrow" width="20" height="60">
        <line x1="10" y1="0" x2="10" y2="50" stroke="black" stroke-width="2" />
        <polygon points="5,50 15,50 10,60" fill="black" />
      </svg>

      <svg class="arrow rightArrow" width="20" height="60">
        <line x1="10" y1="0" x2="10" y2="50" stroke="black" stroke-width="2" />
        <polygon points="5,50 15,50 10,60" fill="black" />
      </svg>

      <Spinner
        v-if="fixationVisible"
        class="fixation"
        name="double-bounce"
        color="#000000"
      />

      <Ball v-if="leftBallVisible" :class="outputLeft" class="leftBall" />
      <Ball v-if="rightBallVisible" :class="outputRight" class="rightBall" />
    </div>
    <button v-if="nextBtnVisible" @click="$magpie.nextSlide()">Next</button>
  </div>
</template>

<style scoped>
.gamedisplay {
  width: 100%;
  height: 450px;
  padding: 20px;
  display: grid;
  grid-template-areas:
    'leftUrn  . rightUrn'
    'leftArrow . rightArrow'
    'leftBall fixation rightBall';
  grid-template-rows: auto auto 50px;
  grid-template-columns: auto 0px auto;
}

.arrow {
  justify-self: center;
}

.gamedisplay > .leftUrn {
  grid-area: leftUrn;
}

.gamedisplay > .rightUrn {
  grid-area: rightUrn;
}

.gamedisplay > .leftArrow {
  grid-area: leftArrow;
}

.gamedisplay > .rightArrow {
  grid-area: rightArrow;
}

.gamedisplay > .fixation {
  grid-area: fixation;
  justify-self: center;
}

.gamedisplay > .leftBall {
  grid-area: leftBall;
  justify-self: center;
}

.gamedisplay > .rightBall {
  grid-area: rightBall;
  justify-self: center;
}

.fixation {
  animation: none !important;
  opacity: 0.5;
}
</style>
