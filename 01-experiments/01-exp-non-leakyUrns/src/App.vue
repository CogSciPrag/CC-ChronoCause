<template>
  <Experiment title="ChronoCause">

    <InstructionScreen :title="'Welcome'">
      Hi! Thanks for taking part! In this experiment, you will be introduced to
      a simple game. Then, you will see a few rounds of the game being played
      and you will be asked to make some judgements.
      <div class="pool-ball"></div>
    </InstructionScreen>

    <InstructionScreen :titles="'Game Rules'">
      <p>
        In the game, the player sees two urns, which each contain both <b>solid</b> and <b>striped</b> balls.
        There are always 10 balls in each urn: 5 of the balls are solid, and 5 are striped.
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
        {{
          structure == "conjunctive" ? "BOTH balls are" : "AT LEAST ONE ball is"
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
          Remember the rule that determines the sound that the machine makes:
          <p style="color: gray">
            The player wins just in case in case
        {{
          structure == "conjunctive" ? "BOTH balls are" : "AT LEAST ONE ball is"
            }} <b>solid</b>.

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
              trialType : 'comprehension',
              trialNr : i+1,
              correctResponse: trial.correctResponse,
              leftColor : trial.leftColor,
              rightColor : trial.rightColor,
              response : $magpie.measurements.response,
              structure : structure,
              fixedTerminology: true
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
      <p>Let’s practice this first!</p>
    </InstructionScreen>
    <template v-for="(trial, i) of training_trials">
      <TrialScreens trialType="training" :trial="trial" :index="i" :getType="getType" :getDelay="getDelay" />
    </template>

    <InstructionScreen :title="'Instructions'">
      <p>Great! You are now ready to start the main experiment.</p>
    </InstructionScreen>

    <template v-for="(trial, i) of main_trials">
      <TrialScreens trialType="critical" :trial="trial" :index="i" :getType="getType" :getDelay="getDelay" />
    </template>

    <SubmitResultsScreen/>
  </Experiment>
</template>

<script>
import _ from "lodash";
import TrialScreens from "./TrialScreen.vue";
import NonLeakyUrns from "../../00-customComponents/NonLeakyUrns.vue";
import Urn from "../../00-customComponents/Urn.vue";
import Ball from "../../00-customComponents/Ball.vue";

import training_trials_all from "../trials/training_trials.csv";
import main_trials_all from "../trials/main_trials.csv";
import comprehension_all from "../trials/comprehension.csv";


const structure = _.sample(["conjunctive", "disjunctive"]);

const main_trials = _.shuffle(_.filter(main_trials_all, function (i) {
  return i.structure == structure;
}));

main_trials.forEach(trial => {
  trial['delayedUrn'] = _.sample(['left', 'right']);
});

const training_trials = _.filter(training_trials_all, function (i) {
  return i.structure == structure;
});

training_trials.forEach(trial => {
  trial['delayedUrn'] = _.sample(['left', 'right']);
});

const comprehension = _.filter(comprehension_all, function (i) {
  return i.structure == structure;
});

export default {
  name: "App",
  components: {TrialScreens,Urn, NonLeakyUrns, Ball},
  data() {
    return {
      structure: structure,
      main_trials: main_trials,
      training_trials: training_trials,
      comprehension: comprehension,
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
          delay = 2000;
          break;
        case 'long':
          delay = 3000;
          break;
      }
      return delay;
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
