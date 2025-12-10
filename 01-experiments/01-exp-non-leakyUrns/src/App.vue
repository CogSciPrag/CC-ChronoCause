<template>
  <Experiment title="ChronoCause">

    <InstructionScreen :title="'Welcome'">

      Hi, thanks for taking part!
      In this experiment, you will be introduced to a simple game.
      Then, you will see a few rounds of the game being played and you will be asked to make some judgements.
      <div class="pool-ball"></div>
    </InstructionScreen>

    <InstructionScreen :titles="'Game Rules'">
      <p>
        In the game, the player sees these two urns, which each contain both <b>solid</b> and <b>striped</b> balls.
        There are always the same 10 balls in each urn: 5 of the balls are solid, and 5 are striped.
      </p>

      <div class="urns">
        <Urn
            firstColor='red'
            :firstType='getType("red")'
            :firstCount=5
            secondColor='blue'
            :secondType='getType("blue")'
            :secondCount=5

        />
        <Urn
            firstColor='yellow'
            :firstType='getType("yellow")'
            :firstCount=5
            secondColor='green'
            :secondType='getType("green")'
            :secondCount=5
        />
      </div>
    </InstructionScreen>

    <InstructionScreen :titles="'Game Rules'">
      <p>
        In the game, the player sees these two urns, which each contain both <b>solid</b> and <b>striped</b> balls.
        There are always the same 10 balls in each urn: 5 of the balls are solid, and 5 are striped.
      </p>

      <div class="urns">
        <Urn
            firstColor='red'
            :firstType='getType("red")'
            :firstCount=5
            secondColor='blue'
            :secondType='getType("blue")'
            :secondCount=5

        />
        <Urn
            firstColor='yellow'
            :firstType='getType("yellow")'
            :firstCount=5
            secondColor='green'
            :secondType='getType("green")'
            :secondCount=5
        />
      </div>
      <p>
        When the player presses the button, a ball is released from each urn.
        The player wins just in case
        <b>{{
            structure == "conjunctive" ? "both" : "at least one"
          }}</b> {{
          structure == "conjunctive" ? "balls are" : "ball is"
        }}
        <b>solid</b>.
        <br/>
        Here are the possible outcomes:
      </p>
      <div class="outcomes">
        <div class="col">
          <Ball color="red" :type='getType("red")'/>
          <Ball color="blue" :type='getType("blue")'/>
          <Ball color="red" :type='getType("red")'/>
          <Ball color="blue" :type='getType("blue")'/>
        </div>
        <div class="col">
          <Ball color="yellow" :type='getType("yellow")'/>
          <Ball color="yellow" :type='getType("yellow")'/>
          <Ball color="green" :type='getType("green")'/>
          <Ball color="green" :type='getType("green")'/>
        </div>
        <div class="col">
          <p>WIN</p>
          <p>{{ structure == "conjunctive" ? "LOSE" : "WIN" }}</p>
          <p>{{ structure == "conjunctive" ? "LOSE" : "WIN" }}</p>
          <p>LOSE</p>
        </div>
      </div>
    </InstructionScreen>


    <template v-for="(trial, i) in comprehension">
      <Screen>
        <Slide>
          <p>
            Remember, the player wins just in case in case
            <b>{{ structure == "conjunctive" ? "both" : "at least one" }}</b>
            {{ structure == "conjunctive" ? "balls are" : "ball is" }}
            <b>solid</b>.
          </p>

          To make sure you understand, please select whether a player would win or lose when the following balls are
          released:

          <p class="outcomeBalls">
            <Ball class="col" :color="trial.leftColor" :type="getType(trial.leftColor)"/>
            <Ball clas="col" :color="trial.rightColor" :type="getType(trial.rightColor)"/>
          </p>

          <ForcedChoiceInput
              :response.sync="$magpie.measurements.response"
              :options="['win', 'lose']"
              @update:response="saveComprehensionResponse($magpie.measurements.response,trial.correctResponse)"/>

          <Record
              :data="{
              trialType : 'comprehension-1',
              trialNr : i+1,
              correctResponse: trial.correctResponse,
              leftColor : trial.leftColor,
              rightColor : trial.rightColor,
              response : $magpie.measurements.response,
              structure : structure
            }"
          />
        </Slide>
      </Screen>
    </template>

    <InstructionScreen>
      <p v-if="!comprehensionFailed">Great, you understood the task! Let’s begin.</p>

      <p v-if="comprehensionFailed"> Oops! You made a mistake.<br/>
        Remember, the player wins just in case
        <b>{{
            structure == "conjunctive" ? "both" : "at least one"
          }}</b> {{
          structure == "conjunctive" ? "balls are" : "ball is"
        }}
        <b>solid</b>.
        <br/>
        Here are the possible outcomes:
      </p>
      <div v-if="comprehensionFailed" class="outcomes">
        <div class="col">
          <Ball color="red" :type='getType("red")'/>
          <Ball color="blue" :type='getType("blue")'/>
          <Ball color="red" :type='getType("red")'/>
          <Ball color="blue" :type='getType("blue")'/>
        </div>
        <div class="col">
          <Ball color="yellow" :type='getType("yellow")'/>
          <Ball color="yellow" :type='getType("yellow")'/>
          <Ball color="green" :type='getType("green")'/>
          <Ball color="green" :type='getType("green")'/>
        </div>
        <div class="col">
          <p>WIN</p>
          <p>{{ structure == "conjunctive" ? "LOSE" : "WIN" }}</p>
          <p>{{ structure == "conjunctive" ? "LOSE" : "WIN" }}</p>
          <p>LOSE</p>
        </div>
      </div>
      <p v-if="comprehensionFailed">Let’s try again!
      </p>
    </InstructionScreen>

    <template v-if="comprehensionFailed" v-for="(trial, i) in comprehension">
      <Screen>
        <Slide>
          <p>
            Remember, the player wins just in case in case
            <b>{{ structure == "conjunctive" ? "both" : "at least one" }}</b>
            {{ structure == "conjunctive" ? "balls are" : "ball is" }}
            <b>solid</b>.
          </p>

          To make sure you understand, please select whether a player would win or lose when the following balls are
          released:

          <p class="outcomeBalls">
            <Ball class="col" :color="trial.leftColor" :type="getType(trial.leftColor)"/>
            <Ball clas="col" :color="trial.rightColor" :type="getType(trial.rightColor)"/>
          </p>

          <ForcedChoiceInput
              :response.sync="$magpie.measurements.response"
              :options="['win', 'lose']"
              @update:response="$magpie.saveAndNextScreen();"/>

          <Record
              :data="{
              trialType : 'comprehension-2',
              trialNr : i+1,
              correctResponse: trial.correctResponse,
              leftColor : trial.leftColor,
              rightColor : trial.rightColor,
              response : $magpie.measurements.response,
              structure : structure
            }"
          />
        </Slide>
      </Screen>
    </template>

    <InstructionScreen :title="'Instructions'">
      <p>
        In this experiment, Alice will be playing the game.
        You will see a few rounds, and after each round, you will be asked to judge several statements.
      </p>
      <p>
        <b>Pay close attention</b> to when the balls are released from either of the two urns, as they may be released
        at different times.
      </p>
      <p>Let’s practice this first!</p>
    </InstructionScreen>

    <template v-for="(trial, i) of training_trials">
      <TrialScreen trialType="training" :trial="trial" :index="i" :length="training_trials.length" :getType="getType"
                   :getDelay="getDelay" :which_urn_prompted_first="which_urn_prompted_first"/>
    </template>

    <InstructionScreen :title="'Instructions'">
      <p>Great! You are now ready to start the main experiment.</p>
    </InstructionScreen>

    <template v-for="(trial, i) of main_trials">
      <TrialScreen trialType="critical" :trial="trial" :index="i" :length="main_trials.length" :getType="getType"
                   :getDelay="getDelay" :which_urn_prompted_first="which_urn_prompted_first"/>
    </template>

    <PostTestScreen/>
    <SubmitResultsScreen/>
  </Experiment>
</template>

<script>
import _ from "lodash";

import NonLeakyUrns from "../../00-customComponents/NonLeakyUrns.vue";
import Urn from "../../00-customComponents/Urn.vue";
import Ball from "../../00-customComponents/Ball.vue";

import TrialScreen from "./TrialScreen.vue";

import training_trials_all from "../trials/training_trials.csv";
import main_trials_all from "../trials/main_trials.csv";
import comprehension_all from "../trials/comprehension.csv";


const structure = _.sample(["conjunctive", "disjunctive"]);
console.log('structure ', structure)
const which_urn_prompted_first = _.sample(["left", "right"]);
console.log('which_urn_prompted_first', which_urn_prompted_first);
let main_trials = _.shuffle(_.filter(main_trials_all, function (i) {
  return i.structure == structure;
}));

main_trials.forEach(trial => {
  if (trial['delay'] == 'simult') {
    trial['delayedUrn'] = 'none';
  } else {
    trial['delayedUrn'] = _.sample(['left', 'right']);
  }
});

// add attention checks
main_trials[2]['attentionCheck'] = true
main_trials[5]['attentionCheck'] = true
main_trials[8]['attentionCheck'] = true

const training_trials = _.filter(training_trials_all, function (i) {
  return i.structure == structure;
});

training_trials.forEach(trial => {
    if (trial['delay'] == 'simult') {
    trial['delayedUrn'] = 'none';
  } else {
    trial['delayedUrn'] = _.sample(['left', 'right']);
  }
});

const comprehension = _.shuffle(_.filter(comprehension_all, function (i) {
  return i.structure == structure;
}));

export default {
  name: "App",
  components: {TrialScreen, Urn, NonLeakyUrns, Ball},
  data() {
    return {
      structure: structure,
      which_urn_prompted_first: which_urn_prompted_first,
      main_trials: main_trials,
      training_trials: training_trials,
      comprehension: comprehension,
      comprehensionFailed: false
    };
  },
  methods: {
    getType(color) {
      let type = 'solid';
      switch (color) {
        case 'red':
          type = 'solid';
          break;
        case 'yellow':
          type = 'solid';
          break;
        case 'blue':
          type = 'stripe';
          break;
        case 'green':
          type = 'stripe';
          break;
      }
      return type;
    },
    getDelay(name) {
      let delay = 1000;
      switch (name) {
        case 'base':
          delay = 1000;
          break;
        case 'short':
          delay = 3000;
          break;
        case 'long':
          delay = 7000;
          break;
      }
      return delay;
    },
    saveComprehensionResponse: function (response, correctResponse) {
      this.comprehensionFailed = (this.comprehensionFailed || !(response == correctResponse));
      $magpie.saveAndNextScreen();
    }
  },
  computed: {
    _() {
      return _;
    }
  }
};
</script>

<style>
.outcomes {
  width: 100%;
  justify-content: center;
  display: grid;
  grid-template-columns: 50px 50px 50px;
}

.outcomes .col {
  display: grid;
  align-items: center;
  gap: 10px;
  grid-template-rows: 50px 50px 50px 50px;
}

.outcomeBalls {
  justify-content: center;
  display: grid;
  grid-template-columns: 50px 50px;
  gap: 10px;
  padding-top: 40px;
  padding-bottom: 40px;
}

.outcomeBalls .col {
  display: grid;
  align-items: center;

}

.urns {
  width: 100%;
  justify-content: center;
  display: grid;
  grid-template-columns: auto auto;
  gap: 50px;
}

.red {
  color: #B22222;
}

.yellow {
  color: #EEB14F;
}

.green {
  color: #3C902B;
}

.blue {
  color: #3A4FB4;
}

</style>
