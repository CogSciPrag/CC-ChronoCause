<script setup>

import NonLeakyUrns from "../../00-customComponents/NonLeakyUrns.vue";

defineProps({
  trialType: String,
  trial: Object,
  index: Number,
  length: Number,
  getType: Function,
  getDelay: Function
});

function saveAndNextScreenTimeLog() {
  $magpie.measurements.submitClicked = Date.now();
  $magpie.saveAndNextScreen();
}

</script>

<template>
  <Screen :progress="index/length">
    <Slide>
      Press the button to see Alice's game:
      <NonLeakyUrns
          firstColorLeft='red'
          :firstTypeLeft='getType("red")'
          secondColorLeft='blue'
          :secondTypeLeft='getType("blue")'
          firstColorRight='yellow'
          :firstTypeRight='getType("yellow")'
          secondColorRight='green'
          :secondTypeRight='getType("green")'
          :timingLeft="trial.delayedUrn === 'right'? getDelay('base') : getDelay(trial.delay)"
          :outputColorLeft=trial.leftColor
          :outputTypeLeft='getType(trial.leftColor)'
          :timingRight="trial.delayedUrn === 'right'? getDelay(trial.delay) : getDelay('base')"
          :outputColorRight=trial.rightColor
          :outputTypeRight='getType(trial.rightColor)'
      />
    </Slide>

    <Slide>
      Press the button to see Alice's game:
      <NonLeakyUrns
          firstColorLeft='red'
          :firstTypeLeft='getType("red")'
          secondColorLeft='blue'
          :secondTypeLeft='getType("blue")'
          firstColorRight='yellow'
          :firstTypeRight='getType("yellow")'
          secondColorRight='green'
          :secondTypeRight='getType("green")'
          :timingLeft="trial.delayedUrn === 'right'? getDelay('base') : getDelay(trial.delay)"
          :outputColorLeft=trial.leftColor
          :outputTypeLeft='getType(trial.leftColor)'
          :timingRight="trial.delayedUrn === 'right'? getDelay(trial.delay) : getDelay('base')"
          :outputColorRight=trial.rightColor
          :outputTypeRight='getType(trial.rightColor)'
          :enabled="false"
      />

      Alice <b>{{ trial.gameOutcome === "win" ? "won" : "lost" }}</b> the game.
      <br/>
      <p>
        Do you agree with the following statements?
      </p>

      <p>
        <b>The <span :class="trial.leftColor">{{ trial.leftColor }}</span> ball caused Alice to {{
            trial.gameOutcome
          }}.</b>
      </p>
      <RatingInput
          left="strongly disagree"
          right="strongly agree"
          :response.sync="$magpie.measurements.responseLeft"
      />

      <p>
        <b>The <span :class="trial.rightColor">{{ trial.rightColor }}</span> ball caused Alice to
          {{ trial.gameOutcome }}.</b>
      </p>
      <RatingInput
          left="strongly disagree"
          right="strongly agree"
          :response.sync="$magpie.measurements.responseRight"

      />
      <p v-if="$magpie.measurements.responseLeft > 0 && $magpie.measurements.responseRight > 0">
        <button @click="saveAndNextScreenTimeLog">Submit</button>
      </p>

      <Record
          :data="{
              trialType : trialType,
              trialNr : index + 1,
              structure:trial.structure,
              leftColor: trial.leftColor,
              rightColor: trial.rightColor,
              gameOutcome: trial.gameOutcome,
              delay: trial.delay,
              delayedUrn: trial.delayedUrn,
              responseLeft: $magpie.measurements.responseLeft,
              responseRight: $magpie.measurements.responseRight,
              beginClicked: $magpie.measurements.beginClicked,
              submitClicked: $magpie.measurements.submitClicked
            }"
      />
    </Slide>
  </Screen>
</template>

<style scoped>

</style>