<script setup>
import Vue from "vue";
import {ref} from "vue";
import LabeledUrn from "./LabeledUrn.vue";
import LabeledBall from "./LabeledBall.vue";
import Spinner from "vue-spinkit";
import Ball from "./Ball.vue";

Vue.component("Spinner", Spinner);

const props = defineProps({
  timingEarly: {
    type: Number,
    default: 2000
  },
  timingLate: {
    type: Number,
    default: 4000
  },
  enabled: {
    type: Boolean,
    default: true
  },
  earlyOutputA: {
    type: Boolean,
    default: false
  },
  outputColorEarly: {
    type: String,
    default: 'black'
  },
  outputTypeEarly: {
    type: String,
    default: 'solid'
  },
  outputLabelEarly: {
    type: String,
    default: 'A'
  },
  outputColorA: {
    type: String,
    default: 'red'
  },
  outputTypeA: {
    type: String,
    default: 'solid'
  },
  outputColorB: {
    type: String,
    default: 'yellow'
  },
  outputTypeB: {
    type: String,
    default: 'solid'
  },
});

const AArrowVisible = ref(false);
const BArrowVisible = ref(false);
const earlyBallVisible = props.enabled ? ref(false) : ref(true);
const ABallVisible = props.enabled ? ref(false) : ref(true);
const BBallVisible = props.enabled ? ref(false) : ref(true);
const beginBtnVisible = props.enabled ? ref(true) : ref(false);
const fixationVisible = ref(false);

function runGame() {
  $magpie.measurements.beginClicked = Date.now();

  fixationVisible.value = true;
  beginBtnVisible.value = false;

  setTimeout(() => {
    earlyBallVisible.value = true;
    if (props.earlyOutputA) {
      AArrowVisible.value = true;
    } else {
      BArrowVisible.value = true;
    }

  }, props.timingEarly);

  setTimeout(() => {
    ABallVisible.value = true;
  }, props.timingLate);

  setTimeout(() => {
    BBallVisible.value = true;
  }, props.timingLate);

  setTimeout(() => {
    fixationVisible.value = false;
  }, props.timingLate);

  setTimeout(() => {
    $magpie.nextSlide();
  }, props.timingLate + 1000);
}
</script>


<template>
  <div class="game">
    <div class="btnSpace">
      <button v-if="beginBtnVisible" @click="runGame">Begin</button>
    </div>
    <div class="gamedisplay">
      <LabeledUrn
          firstColor="black"
          secondColor="purple"
          thirdColor="black"
          fourthColor="purple"
          :firstCount="2"
          :secondCount="2"
          :thirdCount="2"
          :fourthCount="2"
          firstType="solid"
          secondType="stripe"
          thirdType="solid"
          fourthType="stripe"
          firstLabel="A"
          secondLabel="A"
          thirdLabel="B"
          fourthLabel="B"
          class="earlyUrn"
      />

      <svg class="arrow earlyArrow" width="20" height="60">
        <line x1="10" y1="0" x2="10" y2="50" stroke="black" stroke-width="2"/>
        <polygon points="5,50 15,50 10,60" fill="black"/>
      </svg>

      <LabeledBall v-if="earlyBallVisible" :color="outputColorEarly" :type="outputTypeEarly" class="earlyBall" :label="outputLabelEarly"/>

      <div class="ALabel">
        A
      </div>

      <div class="BLabel">
        B
      </div>

      <LabeledUrn
          firstColor='red'
          firstType='solid'
          :firstCount=4
          :secondCount=4
          secondColor='blue'
          secondType='stripe'
          firstLabel=''
          secondLabel=''
          class="AUrn"
      />
      <LabeledUrn
          firstColor='yellow'
          firstType='solid'
          :firstCount=4
          :secondCount=4
          secondColor='green'
          secondType='stripe'
          firstLabel=''
          secondLabel=''
          class="BUrn"
      />

      <div class="diagonalArrows">
        <svg v-if='AArrowVisible' class="arrow ADiagonalArrow" width="60" height="60">
          <line x1="55" y1="5" x2="10" y2="50" stroke="black" stroke-width="2"/>
          <polygon points="10,50 18,48 12,42" fill="black"/>
        </svg>

        <svg v-if='BArrowVisible' class="arrow BDiagonalArrow" width="60" height="60">
          <line x1="5" y1="5" x2="50" y2="50" stroke="black" stroke-width="2"/>
          <polygon points="50,50 42,48 48,42" fill="black"/>
        </svg>
      </div>

      <svg v-if='ABallVisible & earlyOutputA' class="arrow AArrow" width="20" height="60">
        <line x1="10" y1="0" x2="10" y2="50" stroke="black" stroke-width="2"/>
        <polygon points="5,50 15,50 10,60" fill="black"/>
      </svg>

      <svg v-if='BBallVisible & !earlyOutputA' class="arrow BArrow" width="20" height="60">
        <line x1="10" y1="0" x2="10" y2="50" stroke="black" stroke-width="2"/>
        <polygon points="5,50 15,50 10,60" fill="black"/>
      </svg>


      <LabeledBall v-if='ABallVisible & earlyOutputA' :color="outputColorA" :type="outputTypeA" class="ABall"/>

      <LabeledBall v-if='BBallVisible & !earlyOutputA' :color="outputColorB" :type="outputTypeB" class="BBall"/>

      <Spinner
          v-if="fixationVisible"
          class="fixation"
          name="double-bounce"
          color="#000000"
      />
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
    '. earlyUrn .'
    '. earlyArrow .'
    '. earlyBall .'
    'diagonalArrows diagonalArrows diagonalArrows'
    'ALabel . BLabel'
    'AUrn . BUrn'
    'AArrow . BArrow'
    'ABall fixation BBall';
  display: grid;
  grid-template-columns: 1fr auto 1fr;
  grid-template-rows: auto auto auto auto auto;
  justify-items: center;
  margin: 0 auto;
}

.gamedisplay > .earlyUrn {
  grid-area: earlyUrn;
}

.gamedisplay > .AUrn {
  grid-area: AUrn;
}

.gamedisplay > .BUrn {
  grid-area: BUrn;
}

.gamedisplay > .diagonalArrows {
  grid-area: diagonalArrows;
  justify-self: center;
  height: 100px;
  background-color: lightgray;
}


.gamedisplay > .AUrn {
  grid-area: AUrn;
}

.gamedisplay > .BUrn {
  grid-area: BUrn;
}

.gamedisplay > .earlyBall {
  grid-area: earlyBall;
  justify-self: center;
}

.gamedisplay > .earlyArrow {
  grid-area: earlyArrow;
  justify-self: center;
}

.gamedisplay > .ALabel {
  grid-area: ALabel;
  font-size: 40px;
}

.gamedisplay > .BLabel {
  grid-area: BLabel;
  font-size: 40px;
}

.gamedisplay > .AArrow {
  grid-area: AArrow;
  justify-self: center;
}

.gamedisplay > .BArrow {
  grid-area: BArrow;
  justify-self: center;
}


.gamedisplay > .ABall {
  grid-area: ABall;
  justify-self: center;
}

.gamedisplay > .BBall {
  grid-area: BBall;
  justify-self: center;
}


.gamedisplay > .fixation {
  grid-area: fixation;
}

.btnSpace {
  height: 35px;
  margin-top: 40px;
  display: flex;
  justify-content: center;
  align-items: center; /* optional */
}

.game{
  background-color: lightgrey;
  position: relative;
  width: 100%;
  height: 1000px;
  overflow: hidden; /* or auto */
  justify-content: center;
}
</style>