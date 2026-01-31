<!--
A component with two urns (Urn.vue). with two kinds of balls (Ball.vue).
After the user presses the button, balls with specified colors appear under each urn.
Each can appear with a specified delay.
The indicator shows that the game is underway; it stops when the longer delay has elapsed.

Parameters:
  'timingLeft' - delay with which a ball is released from the left urn; Value: time in ms
  'timingRight' - delay with which a ball is released from the right urn; Value: time in ms
  'firstColorLeft' - color of balls in the left column of the left urn; Options: as defined in Urn.vue
  'secondColorLeft' - color of balls in the right column of the left urn; Options: as defined in Urn.vue
  'firstColorRight' - color of balls in the left column of the right urn; Options: as defined in Urn.vue
  'secondColorRight' - color of balls in the right column of the right urn; Options: as defined in Urn.vue
  'firstTypeLeft' - type of balls in the left column of the left urn; Options: as defined in Urn.vue
  'secondTypeLeft' - type of balls in the right column of the left urn; Options: as defined in Urn.vue
  'firstTypeRight' - type of balls in the left column of the right urn; Options: as defined in Urn.vue
  'secondTypeRight' - type of balls in the right column of the right urn; Options: as defined in Urn.vue
  'firstCountLeft' - number of balls in the left column of the left urn; Value: number
  'secondCountLeft' - number of balls in the right column of the left urn; Value: number
  'firstCountRight' - number of balls in the left column of the right urn; Value: number
  'secondCountRight' - number of balls in the right column of the right urn; Value: number
  'outputColorLeft' - colour of a ball released from the left urn; Options: as defined in Urn.vue
  'outputColorRight' - colour of a ball released from the left urn; Options: as defined in Urn.vue
  'outputTypeLeft' - type of a ball released from the left urn; Options: as defined in Urn.vue
  'outputTypeRight' - type of a ball released from the left urn; Options: as defined in Urn.vue
  'enabled' - if not enabled, the output balls are visible and the user cannot run the animation: Value: boolean

Example usage:
  <UrnGame
    :timingLeft="1000"
    :timingRight="3000"
    firstColorLeft="red"
    secondColorLeft="green"
    firstColorRight="blue"
    secondColorRight="yellow"
    firstTypeLeft="solid"
    secondTypeLeft="stripe"
    firstTypeRight="solid"
    secondTypeRight="stripe"
    :firstCountLeft="5"
    :secondCountLeft="5"
    :firstCountRight="5"
    :secondCountRight="5"
    :enabled="true"
    outputColorLeft="red"
    outputColorRight="yellow"
    outputTypeLeft="solid"
    outputTypeRight="stripe"
  />

-->

<script setup>
import Vue from "vue";
import {ref} from "vue";
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
  firstColorLeft: {
    type: String,
    default: 'black'
  },
  secondColorLeft: {
    type: String,
    default: 'gold'
  },
  firstColorRight: {
    type: String,
    default: 'black'
  },
  secondColorRight: {
    type: String,
    default: 'gold'
  },
  firstTypeLeft: {
    type: String,
    default: 'solid'
  },
  secondTypeLeft: {
    type: String,
    default: 'solid'
  },
  firstTypeRight: {
    type: String,
    default: 'solid'
  },
  secondTypeRight: {
    type: String,
    default: 'solid'
  },
  firstCountLeft: {
    type: Number,
    default: 5
  },
  secondCountLeft: {
    type: Number,
    default: 5
  },
  firstCountRight: {
    type: Number,
    default: 5
  },
  secondCountRight: {
    type: Number,
    default: 5
  },
  outputColorLeft: {
    type: String,
    default: 'gold'
  },
  outputTypeLeft: {
    type: String,
    default: 'solid'
  },
  outputColorRight: {
    type: String,
    default: 'gold'
  },
  outputTypeRight: {
    type: String,
    default: 'solid'
  },
  enabled: {
    type: Boolean,
    default: true
  },
  earlyEnd: {
    type: Boolean,
    default: false
  },
  delayedUrn: {
    type:String,
    default: "left"
  }
});

const leftBallVisible = props.enabled ? ref(false) : ref(true);
const rightBallVisible = props.enabled ? ref(false) : ref(true);
const beginBtnVisible = props.enabled ? ref(true) : ref(false);
const leftArrowVisible = ref(true);
const rightArrowVisible = ref(true);
const fixationVisible = ref(false);
const leftIsEarlier = props.timingLeft < props.timingRight;
const leftIsGreyedOut = ref(false);
const rightIsGreyedOut = ref(false);

if (!props.enabled && props.earlyEnd) {
  if (props.delayedUrn === 'right') {
    rightIsGreyedOut.value = true;
    rightArrowVisible.value = false;
    rightBallVisible.value = false;
  } else {
    leftIsGreyedOut.value = true;
    leftArrowVisible.value = false;
    leftBallVisible.value = false;
  }
}

function runGame() {
  $magpie.measurements.beginClicked = Date.now();

  if (props.earlyEnd) {
    fixationVisible.value = true;
    beginBtnVisible.value = false;

    if (leftIsEarlier) {
      setTimeout(() => {
        leftBallVisible.value = true;
        rightIsGreyedOut.value = true;
        rightArrowVisible.value = false;
        fixationVisible.value = false;
      }, props.timingLeft);

      setTimeout(() => {
        $magpie.nextSlide();
      }, props.timingLeft + 1000);
    } else {
      setTimeout(() => {
        rightBallVisible.value = true;
        leftIsGreyedOut.value = true;
        leftArrowVisible.value = false;
        fixationVisible.value = false;
      }, props.timingRight);

      setTimeout(() => {
        $magpie.nextSlide();
      }, props.timingRight + 1000);
    }

  } else {
    const fixationTiming =
        props.timingLeft > props.timingRight ? props.timingLeft : props.timingRight;

    fixationVisible.value = true;
    beginBtnVisible.value = false;

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
      $magpie.nextSlide();
    }, fixationTiming + 1000);
  }
}

</script>

<template>
  <div class="game">
    <div class="btnSpace">
      <button v-if="beginBtnVisible" @click="runGame">Begin</button>
    </div>
    <div class="gamedisplay">
      <Urn
          :firstColor="firstColorLeft"
          :firstType="firstTypeLeft"
          :firstCount="firstCountLeft"
          :secondColor="secondColorLeft"
          :secondType="secondTypeLeft"
          :secondCount="secondCountLeft"
          class="leftUrn"
          :class="{leftGreyedOut : leftIsGreyedOut}"/>
      <Urn
          :firstColor="firstColorRight"
          :firstType="firstTypeRight"
          :firstCount="firstCountRight"
          :secondColor="secondColorRight"
          :secondType="secondTypeRight"
          :secondCount="secondCountRight"
          class="rightUrn"
          :class="{rightGreyedOut : rightIsGreyedOut}"/>

      <svg v-if="leftArrowVisible" class="arrow leftArrow" width="20" height="60">
        <line x1="10" y1="0" x2="10" y2="50" stroke="black" stroke-width="2"/>
        <polygon points="5,50 15,50 10,60" fill="black"/>
      </svg>

      <svg v-if="rightArrowVisible" class="arrow rightArrow" width="20" height="60">
        <line x1="10" y1="0" x2="10" y2="50" stroke="black" stroke-width="2"/>
        <polygon points="5,50 15,50 10,60" fill="black"/>
      </svg>

      <Spinner
          v-if="fixationVisible"
          class="fixation"
          name="double-bounce"
          color="#000000"
      />

      <Ball v-if="leftBallVisible" :color="outputColorLeft" :type="outputTypeLeft" class="leftBall"/>
      <Ball v-if="rightBallVisible" :color="outputColorRight" :type="outputTypeRight" class="rightBall"/>

    </div>
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

.btnSpace {
  height: 35px;
  margin-top: 40px;
}

.leftGreyedOut {
  opacity: 0.3;
}

.rightGreyedOut {
  opacity: 0.3;
}

</style>
