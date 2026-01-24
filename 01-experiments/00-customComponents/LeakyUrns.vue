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

const earlyBallVisible = props.enabled ? ref(false) : ref(true);
const ABallVisible = props.enabled | !props.earlyOutputA ? ref(false) : ref(true);
const BBallVisible = props.enabled | props.earlyOutputA ? ref(false) : ref(true);
const AArrowVisible = props.enabled | !props.earlyOutputA ? ref(false) : ref(true);
const BArrowVisible = props.enabled | props.earlyOutputA ? ref(false) : ref(true);
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
      <LabeledBall v-if="earlyBallVisible" :color="outputColorEarly" :type="outputTypeEarly" class="earlyBall"
                   :label="outputLabelEarly"/>

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

      <svg v-if='AArrowVisible' class="arrow ADiagonalArrow" width="200" height="60">
        <line x1="25" y1="15" x2="190" y2="15" stroke="black" stroke-width="2"/>
        <line x1="25" y1="15" x2="25" y2="50" stroke="black" stroke-width="2"/>
        <polygon points="20,40 30,40 25,50" fill="black"/>
      </svg>

      <svg v-if='BArrowVisible' class="arrow BDiagonalArrow" width="200" height="60">
        <line x1="10" y1="15" x2="175" y2="15" stroke="black" stroke-width="2"/>
        <line x1="175" y1="15" x2="175" y2="50" stroke="black" stroke-width="2"/>
        <polygon points="170,40 180,40 175,50" fill="black"/>
      </svg>


      <svg v-if='AArrowVisible' class="arrow AArrow" width="20" height="60">
        <line x1="10" y1="0" x2="10" y2="50" stroke="black" stroke-width="2"/>
        <polygon points="5,50 15,50 10,60" fill="black"/>
      </svg>

      <svg v-if='BArrowVisible' class="arrow BArrow" width="20" height="60">
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
.btnSpace {
  height: 45px;
  margin-top: 40px;
}

.gamedisplay {
  display: grid;
  padding: 20px;
  grid-template-areas:
    '. earlyUrn .'
    '. earlyArrow .'
    'ADiagonalArrow earlyBall BDiagonalArrow'
    'ALabel . BLabel'
    'AUrn fixation BUrn'
    'AArrow . BArrow'
    'ABall .  BBall';
  grid-template-columns:  auto 0px auto;
  grid-auto-rows: auto 60px 60px 40px auto 60px 50px;
  justify-items: center;
  align-items: center;
  box-sizing: border-box;
}

.gamedisplay > .earlyUrn {
  grid-area: earlyUrn;
}

.gamedisplay > .earlyArrow {
  grid-area: earlyArrow;
}

.gamedisplay > .earlyBall {
  grid-area: earlyBall;
}

.gamedisplay > .ADiagonalArrow {
  grid-area: ADiagonalArrow;
  margin-right: -150px;
  margin-bottom: -20px;
}

.gamedisplay > .BDiagonalArrow {
  grid-area: BDiagonalArrow;
  margin-left: -150px;
  margin-bottom: -20px;
}

.gamedisplay > .ALabel {
  grid-area: ALabel;
  font-size: 30pt;
  font-weight: bold;
}

.gamedisplay > .BLabel {
  grid-area: BLabel;
  font-size: 30pt;
  font-weight: bold;
}

.gamedisplay > .AUrn {
  grid-area: AUrn;
}

.gamedisplay > .BUrn {
  grid-area: BUrn;
}

.gamedisplay > .AArrow {
  grid-area: AArrow;
}

.gamedisplay > .BArrow {
  grid-area: BArrow;
}

.gamedisplay > .ABall {
  grid-area: ABall;
}

.gamedisplay > .fixation {
  grid-area: fixation;
}

.gamedisplay > .BBall {
  grid-area: BBall;
}

</style>