<template>
  <Experiment title="magpie demo">
    <InstructionScreen :title="'Welcome'">
      Instruction screens and comprehension checks will be added.
      See trials on following screens.
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
  components: {LeakyUrns, LabeledBall, LabeledUrn, TrialScreen},
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
