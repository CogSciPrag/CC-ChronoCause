<!--
Screen with multiple slides representing one trial (both main and training)

Parameters:
  'trialType' - description of the trial in the output csv
  'trial' - current trial object
  'index' - index of current trial
  'length' - number of either main or training trials
  'getType' - used to pass the getType function defined in App.vue
  'getDelay' - used to pass the getDelay function defined in App.vue
  'which_urn_prompted_first' - used to pass the which_urn_prompted_first value

Example usage:
  <template v-for="(trial, i) of training_trials">
    <TrialScreen trialType="training" :trial="trial" :index="i" :length="training_trials.length" :getType="getType" :getDelay="getDelay"/>
  </template>
-->

<script setup>

import UrnGame from "../../../00-customComponents/UrnGame.vue";

const props = defineProps({
  trialType: String,
  trial: Object,
  index: Number,
  length: Number,
  getType: Function,
  getDelay: Function,
  which_urn_prompted_first: String
});

function saveAndNextScreenTimeLog() {
  $magpie.measurements.submitClicked = Date.now();
  $magpie.saveAndNextScreen();
}

function saveAndNextSlideTimeLog() {
  $magpie.measurements.submitClicked = Date.now();
  $magpie.saveMeasurements();
  $magpie.nextSlide();
}

function getColorLeftUrn(type) {
  if (type === "solid") {
    return "red"
  } else {
    return "blue"
  }
}

function getColorRightUrn(type) {
  if (type === "solid") {
    return "yellow"
  } else {
    return "green"
  }
}

function getLeftColor() {
  return props.trial.delayedUrn === 'left' ? getColorLeftUrn(props.trial.lateBall) : getColorLeftUrn(props.trial.earlyBall)
}

function getRightColor() {
  return props.trial.delayedUrn === 'left' ? getColorRightUrn(props.trial.earlyBall) : getColorRightUrn(props.trial.lateBall)
}

function getLeftType() {
  return props.trial.delayedUrn === 'left' ? props.trial.lateBall : props.trial.earlyBall;
}

function getRightType() {
  return props.trial.delayedUrn === 'left' ? props.trial.earlyBall : props.trial.lateBall;
}

function getLeftTiming() {
  return props.trial.delayedUrn === 'left' ? props.getDelay(props.trial.delay) : props.getDelay('base');
}

function getRightTiming() {
  return props.trial.delayedUrn === 'left' ? props.getDelay('base') : props.getDelay(props.trial.delay);
}

</script>

<template>
  <Screen :progress="index/length">
    <Slide>
      Press the button to start a new round of Alice's game:
      <UrnGame
          firstColorLeft='red'
          :firstTypeLeft='getType("red")'
          secondColorLeft='blue'
          :secondTypeLeft='getType("blue")'
          firstColorRight='yellow'
          :firstTypeRight='getType("yellow")'
          secondColorRight='green'
          :secondTypeRight='getType("green")'
          :outputColorLeft="getLeftColor()"
          :outputColorRight="getRightColor()"
          :outputTypeLeft="getLeftType()"
          :outputTypeRight="getRightType()"
          :timingLeft="getLeftTiming()"
          :timingRight="getRightTiming()"
          :enabled="true"
          :earlyEnd="props.trial.earlyEnd"
          :delayedUrn="props.trial.delayedUrn"
      />
    </Slide>

    <Slide v-if="props.trial.attentionCheck">
      Press the button to start a new round of Alice's game:
      <UrnGame
          firstColorLeft='red'
          :firstTypeLeft='getType("red")'
          secondColorLeft='blue'
          :secondTypeLeft='getType("blue")'
          firstColorRight='yellow'
          :firstTypeRight='getType("yellow")'
          secondColorRight='green'
          :secondTypeRight='getType("green")'
          :outputColorLeft="getLeftColor()"
          :outputColorRight="getRightColor()"
          :outputTypeLeft="getLeftType()"
          :outputTypeRight="getRightType()"
          :timingLeft="getLeftTiming()"
          :timingRight="getRightTiming()"
          :enabled="false"
          :earlyEnd="props.trial.earlyEnd"
          :delayedUrn="props.trial.delayedUrn"
      />

      Alice <b>{{ props.trial.gameOutcome === "win" ? "won" : "lost" }}</b> the game.
      <br/>

      <p>
        Which ball was released first?
        <MultipleChoiceInput
            :response.sync="$magpie.measurements.attentionResponse"
            :options="[
                'The ' + getLeftColor() + ' ball',
                'The ' + getRightColor() + ' ball',
                'Both balls were released at the same time']"/>

        <button v-if="$magpie.measurements.attentionResponse" @click="saveAndNextSlideTimeLog">Submit</button>
      </p>

      <Record
          :data="{
              trialType : props.trialType + '-attention',
              trialNr : index + 1,
              structure : props.trial.structure,
              earlyBall : props.trial.earlyBall,
              lateBall : props.trial.lateBall,
              earlyEnd : props.trial.earlyEnd,
              gameOutcome : props.trial.gameOutcome,
              delay: props.trial.delay,
              delayedUrn: props.trial.delayedUrn,
              attentionCheck : props.trial.attentionCheck,
              attentionResponse: $magpie.measurements.attentionResponse,
              attentionCorrectResponse: props.trial.delayedUrn === 'none' ? 'Both balls were released at the same time':
              (props.trial.delayedUrn =='left' ? 'The ' + props.trial.rightColor + ' ball' : 'The ' + props.trial.leftColor + ' ball'),
              beginClicked: $magpie.measurements.beginClicked,
              submitClicked: $magpie.measurements.submitClicked
            }"
      />
    </Slide>

    <Slide>
      Press the button to start a new round of Alice's game:
      <UrnGame
          firstColorLeft='red'
          :firstTypeLeft='getType("red")'
          secondColorLeft='blue'
          :secondTypeLeft='getType("blue")'
          firstColorRight='yellow'
          :firstTypeRight='getType("yellow")'
          secondColorRight='green'
          :secondTypeRight='getType("green")'
          :outputColorLeft="getLeftColor()"
          :outputColorRight="getRightColor()"
          :outputTypeLeft="getLeftType()"
          :outputTypeRight="getRightType()"
          :timingLeft="getLeftTiming()"
          :timingRight="getRightTiming()"
          :enabled="false"
          :earlyEnd="props.trial.earlyEnd"
          :delayedUrn="props.trial.delayedUrn"
      />

      Alice <b>{{ props.trial.gameOutcome === "win" ? "won" : "lost" }}</b> the game.
      <br/>

      <p>
        Do you agree with the following statements?
      </p>

      <div v-if="!props.trial.earlyEnd">
        <p>
          <b>Getting a {{ props.which_urn_prompted_first === "left" ? getLeftColor() : getRightColor() }} ball caused
            Alice to
            {{
              props.trial.gameOutcome
            }}.</b>
        </p>
        <RatingInput
            left="strongly disagree"
            right="strongly agree"
            :response.sync="$magpie.measurements.responseLeft"
        />

        <p>
          <b>Getting a {{ props.which_urn_prompted_first === "left" ? getRightColor() : getLeftColor() }} ball caused
            Alice to
            {{ props.trial.gameOutcome }}.</b>
        </p>
        <RatingInput
            left="strongly disagree"
            right="strongly agree"
            :response.sync="$magpie.measurements.responseRight"

        />
        <p v-if="$magpie.measurements.responseLeft > 0 && $magpie.measurements.responseRight > 0">
          <button @click="saveAndNextScreenTimeLog">Submit</button>
        </p>
      </div>
      <div v-if="props.trial.earlyEnd">
        <p>
          <b>Getting a {{
              props.trial.delayedUrn === "left" ? getColorRightUrn(props.trial.earlyBall) : getColorLeftUrn(props.trial.earlyBall)
            }} ball caused Alice to
            {{ props.trial.gameOutcome }}.</b>
        </p>
        <div v-if="props.trial.delayedUrn === 'left'">
          <RatingInput
              left="strongly disagree"
              right="strongly agree"
              :response.sync="$magpie.measurements.responseRight"
          />
          <p v-if="$magpie.measurements.responseRight > 0">
            <button @click="saveAndNextScreenTimeLog">Submit</button>
          </p>
        </div>

        <div v-else>
          <RatingInput
              left="strongly disagree"
              right="strongly agree"
              :response.sync="$magpie.measurements.responseLeft"
          />
          <p v-if="$magpie.measurements.responseLeft > 0">
            <button @click="saveAndNextScreenTimeLog">Submit</button>
          </p>
        </div>

      </div>


      <Record
          :data="{
              trialType : props.trialType,
              trialNr : index + 1,
              structure:props.trial.structure,
              earlyBall : props.trial.earlyBall,
              lateBall : props.trial.lateBall,
              earlyEnd : props.trial.earlyEnd,
              gameOutcome: props.trial.gameOutcome,
              delay: props.trial.delay,
              delayedUrn: props.trial.delayedUrn,
              attentionCheck : props.trial.attentionCheck,
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