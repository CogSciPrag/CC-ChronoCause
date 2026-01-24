<template>
  <Experiment title="magpie demo">
        <InstructionScreen :title="'Welcome'">
          Hi, thanks for taking part!
          In this experiment, you will be introduced to a simple game.
          Then, you will see a few rounds of the game being played and you will be asked to make some judgements.
        </InstructionScreen>

    <InstructionScreen :title="'Game Rules'">
      <p>
        In the game, the player sees these three urns, which each contain both <b>solid</b> and <b>striped</b> balls.
        There are always the same 8 balls in each urn: 4 of the balls are solid, and 4 are striped.
        The black and purple balls in the first urn are labeled with letters <b>A</b> or <b>B</b> and the two other urns are labeled <b>A</b> and <b>B</b>.
      </p>

      <div class="urns">
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

        <div class="ALabel">A</div>

        <div class="BLabel">B</div>

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
      </div>

    </InstructionScreen>

    <InstructionScreen :title="'Game Rules'">
      <p>
        In the game, the player sees these three urns, which each contain both <b>solid</b> and <b>striped</b> balls.
        There are always the same 8 balls in each urn: 4 of the balls are solid, and 4 are striped.
        The black and purple balls in the first urn are labeled with letters <b>A</b> or <b>B</b> and the two other urns are labeled <b>A</b> and <b>B</b>.
      </p>

      <div class="urns">
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

        <div class="ALabel">A</div>

        <div class="BLabel">B</div>

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
      </div>

      When the player presses the button, a ball is released from the urn with black and purple balls.
      <ul>
        <li>If the released ball has the letter <b>A</b> on it, a ball is then released from the <b>A</b> urn.</li>
        <li>If the released ball has the letter <b>B</b> on it, a ball is then released from the <b>B</b> urn.</li>
      </ul>

      <p>
        When the player presses the button, a ball is released from each urn.
        The player wins just in case
        <b>{{
            structure == "conjunctive" ? "both" : "at least one"
          }}</b> {{
          structure == "conjunctive" ? "balls are" : "ball is"
        }}
        <b>solid</b>.
      </p>

      <p>
        Here are the possible outcomes when the first urn releases a ball with the letter <b>A</b> on it:
        <div class="outcomes">
          <div class="col">
            <LabeledBall color="black" :type='getType("black")' label='A'/>
            <LabeledBall color="purple" :type='getType("purple")' label='A'/>
            <LabeledBall color="black" :type='getType("black")' label='A'/>
            <LabeledBall color="purple" :type='getType("purple")' label='A'/>
          </div>
          <div class="col">
            <LabeledBall color="red" :type='getType("red")'/>
            <LabeledBall color="red" :type='getType("red")'/>
            <LabeledBall color="blue" :type='getType("green")'/>
            <LabeledBall color="blue" :type='getType("blue")'/>
          </div>
          <div class="col">
            <p>WIN</p>
            <p>{{ structure == "conjunctive" ? "LOSE" : "WIN" }}</p>
            <p>{{ structure == "conjunctive" ? "LOSE" : "WIN" }}</p>
            <p>LOSE</p>
          </div>
        </div>
      </p>
      <p>
        Here are the possible outcomes when the first urn releases a ball with the letter <b>B</b> on it:
        <div class="outcomes">
          <div class="col">
            <LabeledBall color="black" :type='getType("black")' label='B'/>
            <LabeledBall color="purple" :type='getType("purple")' label='B'/>
            <LabeledBall color="black" :type='getType("black")' label='B'/>
            <LabeledBall color="purple" :type='getType("purple")' label='B'/>
          </div>
          <div class="col">
            <LabeledBall color="yellow" :type='getType("yellow")'/>
            <LabeledBall color="yellow" :type='getType("yellow")'/>
            <LabeledBall color="green" :type='getType("green")'/>
            <LabeledBall color="green" :type='getType("green")'/>
          </div>
          <div class="col">
            <p>WIN</p>
            <p>{{ structure == "conjunctive" ? "LOSE" : "WIN" }}</p>
            <p>{{ structure == "conjunctive" ? "LOSE" : "WIN" }}</p>
            <p>LOSE</p>
          </div>
        </div>
      </p>
    </InstructionScreen>

    <InstructionScreen>
      comprehension test to be added.
    </InstructionScreen>

    <template v-for="(trial, i) of training_trials">

      <TrialScreen trialType="training" :trial="trial" :index="i" :length="training_trials.length"
                   :getDelay="getDelay" :which_urn_prompted_first="which_urn_prompted_first"/>
    </template>

    <InstructionScreen :title="'Instructions'">
      <p>Great! You are now ready to start the main experiment.</p>
    </InstructionScreen>

    <template v-for="(trial, i) of main_trials">
      <TrialScreen trialType="critical" :trial="trial" :index="i" :length="main_trials.length" :getType="getType"
                   :getDelay="getDelay" :which_urn_prompted_first="which_urn_prompted_first"/>
    </template>

    <SubmitResultsScreen/>
  </Experiment>
</template>
<style scoped>


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

.urns {
  display: grid;
  padding: 10px;
  grid-template-areas:
    '. earlyUrn .'
    'ALabel . BLabel'
    'AUrn . BUrn';
  grid-template-columns:  auto auto auto;
  grid-template-rows: auto  40px auto;
  justify-items: center;
  align-items: start;
  box-sizing: border-box;
}

.urns > .earlyUrn {
  grid-area: earlyUrn;
}

.urns > .ALabel {
  grid-area: ALabel;
  font-size: 30pt;
  font-weight: bold;
}

.urns > .BLabel {
  grid-area: BLabel;
  font-size: 30pt;
  font-weight: bold;
}

.urns > .AUrn {
  grid-area: AUrn;
  align-items: start;
}

.urns > .BUrn {
  grid-area: BUrn;
  align-items: start;
}

</style>
<script>
import _ from 'lodash';
import LeakyUrns from "../../../00-customComponents/LeakyUrns.vue";
import LabeledBall from "../../../00-customComponents/LabeledBall.vue";
import LabeledUrn from "../../../00-customComponents/LabeledUrn.vue";

import TrialScreen from "./TrialScreen.vue";

import training_trials_all from "../trials/training_trials.csv";
import main_trials_all from "../trials/main_trials.csv";
import comprehension_all from "../trials/comprehension.csv";
import Urn from "../../../00-customComponents/Urn.vue";
import Ball from "../../../00-customComponents/Ball.vue";


const structure = _.sample(["conjunctive", "disjunctive"]);
console.log('structure ', structure);
const which_urn_prompted_first = _.sample(["early", "late"]);
console.log('which_urn_prompted_first', which_urn_prompted_first);

let main_trials = _.shuffle(_.filter(main_trials_all, function (i) {
  return i.structure == structure;
}));

main_trials.forEach(trial => {
  trial['outputLabelEarly'] = _.sample(['A', 'B']);
});

// add attention checks
main_trials[2]['attentionCheck'] = true
main_trials[5]['attentionCheck'] = true
main_trials[8]['attentionCheck'] = true

const training_trials = _.filter(training_trials_all, function (i) {
  return i.structure == structure;
});

training_trials.forEach(trial => {
  trial['outputLabelEarly'] = _.sample(['A', 'B']);
});

const comprehension = _.shuffle(_.filter(comprehension_all, function (i) {
  return i.structure == structure;
}));

console.log('training trials', JSON.parse(JSON.stringify(training_trials)));
console.log('main trials', JSON.parse(JSON.stringify(main_trials)));

export default {
  name: 'App',
  components: {Ball, Urn, LeakyUrns, LabeledBall, LabeledUrn, TrialScreen},
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
  computed: {
    // Expose lodash to template code
    _() {
      return _;
    }
  }, methods: {
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
        case 'black':
          type = 'solid';
          break;
        case 'purple':
          type = 'stripe';
          break;
      }
      return type;
    },
    getDelay(name) {
      const base_delay = 1000;
      let delay;
      switch (name) {
        case 'base':
          delay = base_delay;
          break;
        case 'short':
          delay = base_delay + 2000;
          break;
        case 'medium':
          delay = base_delay + 5000;
          break;
        case 'long':
          delay = base_delay + 8000;
          break;
        default:
          delay = base_delay;
      }
      return delay;
    },
    saveComprehensionResponse: function (response, correctResponse) {
      this.comprehensionFailed = (this.comprehensionFailed || !(response == correctResponse));
      $magpie.saveAndNextScreen();
    }
  }
};
</script>
