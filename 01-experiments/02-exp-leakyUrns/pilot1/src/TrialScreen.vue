<script setup>

import LeakyUrns from "../../../00-customComponents/LeakyUrns.vue";
import NonLeakyUrns from "../../../00-customComponents/NonLeakyUrns.vue";

defineProps({
  trialType: String,
  trial: Object,
  index: Number,
  length: Number,
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

</script>

<template>
  <Screen :progress="index/length">
    <Slide>
      Press the button to start a new round of Alice's game:
      <LeakyUrns
          :timingEarly="getDelay('base')"
          :timingLate="getDelay(trial.delay)"
          :earlyOutputA="trial.outputLabelEarly==='A'"
          :outputColorEarly="trial.early === 'solid' ? 'black' : 'purple'"
          :outputTypeEarly=trial.early
          :outputLabelEarly=trial.outputLabelEarly
          :outputColorA="trial.late === 'solid' ? 'red' : 'blue'"
          :outputTypeA=trial.late
          :outputColorB="trial.late === 'solid' ? 'yellow' : 'green'"
          :outputTypeB=trial.late
      />
    </Slide>

    <Slide v-if="trial.attentionCheck">
      Press the button to start a new round of Alice's game:
      <LeakyUrns
          :timingEarly="getDelay('base')"
          :timingLate="getDelay(trial.delay)"
          :earlyOutputA="trial.outputLabelEarly==='A'"
          :outputColorEarly="trial.early === 'solid' ? 'black' : 'purple'"
          :outputTypeEarly=trial.early
          :outputLabelEarly=trial.outputLabelEarly
          :outputColorA="trial.late === 'solid' ? 'red' : 'blue'"
          :outputTypeA=trial.late
          :outputColorB="trial.late === 'solid' ? 'yellow' : 'green'"
          :outputTypeB=trial.late
          :enabled="false"
      />

      Alice <b>{{ trial.gameOutcome === "win" ? "won" : "lost" }}</b> the game.
      <br/>

      <p>
        Which ball was released first?
        <MultipleChoiceInput
            :response.sync="$magpie.measurements.responseAttention"
            :options="[
                'The ' + trial.early === 'solid' ? 'black' : 'purple' + ' ball',
                'The ' + trial.outputLabelEarly==='A' ? (trial.late === 'solid' ? 'red' : 'blue') : (trial.late === 'solid' ? 'yellow' : 'green')  + ' ball',
                'Both balls were released at the same time']"/>

        <button v-if="$magpie.measurements.responseAttention" @click="saveAndNextSlideTimeLog">Submit</button>
      </p>

      <!--      <Record-->
      <!--          :data="{-->
      <!--              trialType : trialType + '-attention',-->
      <!--              trialNr : index + 1,-->
      <!--              structure:trial.structure,-->
      <!--              leftColor: trial.leftColor,-->
      <!--              rightColor: trial.rightColor,-->
      <!--              combo: trial.combo,-->
      <!--              gameOutcome: trial.gameOutcome,-->
      <!--              delay: trial.delay,-->
      <!--              delayedUrn: trial.delayedUrn,-->
      <!--              beginClicked: $magpie.measurements.beginClicked,-->
      <!--              submitClicked: $magpie.measurements.submitClicked,-->
      <!--              responseAttention: $magpie.measurements.responseAttention,-->
      <!--              correctResponseAttention: trial.delayedUrn == 'none' ? 'Both balls were released at the same time':-->
      <!--              (trial.delayedUrn =='left' ? 'The ' + trial.rightColor + ' ball' : 'The ' + trial.leftColor + ' ball')-->
      <!--            }"-->
      <!--      />-->
    </Slide>

    <Slide>
      Press the button to start a new round of Alice's game:

      <LeakyUrns
          :timingEarly="getDelay('base')"
          :timingLate="getDelay(trial.delay)"
          :earlyOutputA="trial.outputLabelEarly==='A'"
          :outputColorEarly="trial.early === 'solid' ? 'black' : 'purple'"
          :outputTypeEarly=trial.early
          :outputLabelEarly=trial.outputLabelEarly
          :outputColorA="trial.late === 'solid' ? 'red' : 'blue'"
          :outputTypeA=trial.late
          :outputColorB="trial.late === 'solid' ? 'yellow' : 'green'"
          :outputTypeB=trial.late
          :enabled="false"
      />

      Alice <b>{{ trial.gameOutcome === "win" ? "won" : "lost" }}</b> the game.
      <br/>

      <p>
        Do you agree with the following statements?
      </p>

<!--      <p>-->
<!--        <b>Getting a {{ which_urn_prompted_first === "left" ? trial.leftColor : trial.rightColor }} ball caused Alice to-->
<!--          {{-->
<!--            trial.gameOutcome-->
<!--          }}.</b>-->
<!--      </p>-->
<!--      <RatingInput-->
<!--          left="strongly disagree"-->
<!--          right="strongly agree"-->
<!--          :response.sync="$magpie.measurements.responseLeft"-->
<!--      />-->

<!--      <p>-->
<!--        <b>Getting a {{ which_urn_prompted_first === "left" ? trial.rightColor : trial.leftColor }} ball caused Alice to-->
<!--          {{ trial.gameOutcome }}.</b>-->
<!--      </p>-->
<!--      <RatingInput-->
<!--          left="strongly disagree"-->
<!--          right="strongly agree"-->
<!--          :response.sync="$magpie.measurements.responseRight"-->

<!--      />-->
<!--      <p v-if="$magpie.measurements.responseLeft > 0 && $magpie.measurements.responseRight > 0">-->
        <button @click="saveAndNextScreenTimeLog">Submit</button>
<!--      </p>-->

<!--      <Record-->
<!--          :data="{-->
<!--              trialType : trialType,-->
<!--              trialNr : index + 1,-->
<!--              structure:trial.structure,-->
<!--              leftColor: trial.leftColor,-->
<!--              rightColor: trial.rightColor,-->
<!--              combo: trial.combo,-->
<!--              gameOutcome: trial.gameOutcome,-->
<!--              delay: trial.delay,-->
<!--              delayedUrn: trial.delayedUrn,-->
<!--              responseLeft: $magpie.measurements.responseLeft,-->
<!--              responseRight: $magpie.measurements.responseRight,-->
<!--              beginClicked: $magpie.measurements.beginClicked,-->
<!--              submitClicked: $magpie.measurements.submitClicked-->
<!--            }"-->
<!--      />-->
    </Slide>
  </Screen>
</template>

<style scoped>

</style>