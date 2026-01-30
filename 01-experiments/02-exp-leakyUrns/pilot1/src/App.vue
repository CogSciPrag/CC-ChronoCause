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
      </p>
      <p>
        However, the balls may be released at different times. If the first ball released from either urn is
        <b>{{ structure === "conjunctive" ? "striped" : "solid" }},
          no
          ball is released from the other urn</b>, and the game ends in a
        <b>{{ structure === "conjunctive" ? "loss" : "win" }}</b>.
      </p>
      <p>
        Here are the possible outcomes:
      </p>
      <div class="outcomes">
        <div class="col first">
          <Ball class='firstFirst' :class="{disjAnimation: structure=='disjunctive'}" color="none"
                :type='structure === "conjunctive"? "solid": "stripe"'/>
          <Ball class='firstSecond' :class="{disjAnimation: structure=='disjunctive'}" color="none" type='solid'/>
          <Ball class='firstThird' :class="{disjAnimation: structure=='disjunctive'}" color="none"
                :type='structure === "conjunctive"? "stripe": "solid"'/>
        </div>
        <div class="col second">
          <Ball class='secondFirst' :class="{disjAnimation: structure=='disjunctive'}" color="none"
                :type='structure === "conjunctive"? "solid": "stripe"'/>
          <Ball class='secondSecond' :class="{disjAnimation: structure=='disjunctive'}" color="none" type='stripe'/>
          <Ball class='secondThird' :class="{disjAnimation: structure=='disjunctive'}" color="none"
                :type='structure === "conjunctive"? "stripe": "solid"'/>
        </div>
        <div class="col third">
          <p class='thirdFirst'>{{ structure == "conjunctive" ? "WIN" : "LOSE" }}</p>
          <p class='thirdSecond'>{{ structure == "conjunctive" ? "LOSE" : "WIN" }}</p>
          <p class="thirdThird">{{ structure == "conjunctive" ? "LOSE" : "WIN" }}</p>
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
            <Ball class="col" :class="trial.delayedUrn === 'left' ? 'compLate' : 'compEarly'"
                  :color="trial.delayedUrn === 'left' ? getColorLeftUrn(trial.lateBall) : getColorLeftUrn(trial.earlyBall)"
                  :type="trial.delayedUrn === 'left' ? trial.lateBall : trial.earlyBall"/>
            <Ball class="col" :class="trial.delayedUrn === 'left' ? 'compEarly' : 'compLate'"
                  :color="trial.delayedUrn === 'left' ? getColorRightUrn(trial.earlyBall) : getColorRightUrn(trial.lateBall)"
                  :type="trial.delayedUrn === 'left' ? trial.earlyBall : trial.lateBall"/>
          </p>

          <ForcedChoiceInput
              :response.sync="$magpie.measurements.comprehensionResponse"
              :options="['win', 'lose']"
              @update:response="saveComprehensionResponse($magpie.measurements.comprehensionResponse,trial.correctResponse)"/>

          <Record
              :data="{
                  trialType : 'comprehension-1',
                  trialNr : i+1,
                  comprehensionCorrectResponse: trial.correctResponse,
                  earlyBall : trial.earlyBall,
                  lateBall : trial.lateBall,
                  comprehensionResponse : $magpie.measurements.comprehensionResponse,
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
        <div class="col first">
          <Ball class='firstFirst' :class="{disjAnimation: structure=='disjunctive'}" color="none"
                :type='structure === "conjunctive"? "solid": "stripe"'/>
          <Ball class='firstSecond' :class="{disjAnimation: structure=='disjunctive'}" color="none" type='solid'/>
          <Ball class='firstThird' :class="{disjAnimation: structure=='disjunctive'}" color="none"
                :type='structure === "conjunctive"? "stripe": "solid"'/>
        </div>
        <div class="col second">
          <Ball class='secondFirst' :class="{disjAnimation: structure=='disjunctive'}" color="none"
                :type='structure === "conjunctive"? "solid": "stripe"'/>
          <Ball class='secondSecond' :class="{disjAnimation: structure=='disjunctive'}" color="none" type='stripe'/>
          <Ball class='secondThird' :class="{disjAnimation: structure=='disjunctive'}" color="none"
                :type='structure === "conjunctive"? "stripe": "solid"'/>
        </div>
        <div class="col third">
          <p class='thirdFirst'>{{ structure == "conjunctive" ? "WIN" : "LOSE" }}</p>
          <p class='thirdSecond'>{{ structure == "conjunctive" ? "LOSE" : "WIN" }}</p>
          <p class="thirdThird">{{ structure == "conjunctive" ? "LOSE" : "WIN" }}</p>
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
            <Ball class="col" :class="trial.delayedUrn === 'left' ? 'compLate' : 'compEarly'"
                  :color="trial.delayedUrn === 'left' ? getColorLeftUrn(trial.lateBall) : getColorLeftUrn(trial.earlyBall)"
                  :type="trial.delayedUrn === 'left' ? trial.lateBall : trial.earlyBall"/>
            <Ball class="col" :class="trial.delayedUrn === 'left' ? 'compEarly' : 'compLate'"
                  :color="trial.delayedUrn === 'left' ? getColorRightUrn(trial.earlyBall) : getColorRightUrn(trial.lateBall)"
                  :type="trial.delayedUrn === 'left' ? trial.earlyBall : trial.lateBall"/>
          </p>

          <ForcedChoiceInput
              :response.sync="$magpie.measurements.response"
              :options="['win', 'lose']"
              @update:response="$magpie.saveAndNextScreen();"/>

          <Record
              :data="{
                  trialType : 'comprehension-2',
                  trialNr : i+1,
                  comprehensionCorrectResponse: trial.correctResponse,
                  earlyBall : trial.earlyBall,
                  lateBall : trial.lateBall,
                  comprehensionResponse : $magpie.measurements.comprehensionResponse,
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

import UrnGame from "../../../00-customComponents/UrnGame.vue";
import Urn from "../../../00-customComponents/Urn.vue";
import Ball from "../../../00-customComponents/Ball.vue";

import TrialScreen from "./TrialScreen.vue";

import training_trials_all from "../trials/training_trials.csv";
import main_trials_all from "../trials/main_trials.csv";
import comprehension_all from "../trials/comprehension.csv";

const structure = _.sample(["conjunctive", "disjunctive"]);
console.log('structure ', structure);
const which_urn_prompted_first = _.sample(["left", "right"]);
console.log('which_urn_prompted_first', which_urn_prompted_first);

let main_trials = _.filter(main_trials_all, function (i) {
  return i.structure == structure;
});
main_trials.forEach(trial => {
  trial['delayedUrn'] = _.sample(["left", "right"]);
});

// add attention checks
let attention_check_main_trials = _.sampleSize(_.filter(main_trials, function (trial) {
  return !trial.earlyEnd;
}), 3);
attention_check_main_trials.forEach(trial => {
  trial.attentionCheck = true;
});

const ids_to_remove = new Set(attention_check_main_trials.map(item => item.id));

let no_attention_check_main_trials = _.shuffle(main_trials.filter(item => !ids_to_remove.has(item.id)));

const attentionCheckIndexes = [2, 5, 8];

main_trials = Array.from({length: 11}, (_, i) =>
    attentionCheckIndexes.includes(i)
        ? attention_check_main_trials[attentionCheckIndexes.indexOf(i)]
        : no_attention_check_main_trials.shift());

const training_trials = _.filter(training_trials_all, function (i) {
  return i.structure == structure;
});

training_trials.forEach(trial => {
  trial['delayedUrn'] = _.sample(["left", "right"]);
});

const comprehension = _.shuffle(_.filter(comprehension_all, function (i) {
  return i.structure == structure;
}));

console.log('training trials', JSON.parse(JSON.stringify(training_trials)));
console.log('main trials', JSON.parse(JSON.stringify(main_trials)));

export default {
  name: "App",
  components: {TrialScreen, Urn, UrnGame, Ball},
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
    getColorLeftUrn(type) {
      if (type === "solid") {
        return "red"
      } else {
        return "blue"
      }
    },
    getColorRightUrn(type) {
      if (type === "solid") {
        return "yellow"
      } else {
        return "green"
      }
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


/* First column */
.firstFirst {
  animation: firstFirstConjAnimation 16s steps(1) infinite;
}

.firstFirst.disjAnimation {
  animation: firstFirstDisjAnimation 16s steps(1) infinite;
}

.firstSecond {
  animation: firstSecondConjAnimation 16s steps(1) infinite;
}

.firstSecond.disjAnimation {
  animation: firstSecondDisjAnimation 16s steps(1) infinite;
}

.firstThird {
  animation: firstThirdConjAnimation 16s steps(1) infinite;
}

.firstThird.disjAnimation {
  animation: firstThirdDisjAnimation 16s steps(1) infinite;
}

/* Second column */
.secondFirst {
  animation: secondFirstConjAnimation 16s steps(1) infinite;
}

.secondFirst.disjAnimation {
  animation: secondFirstDisjAnimation 16s steps(1) infinite;
}

.secondSecond {
  animation: secondSecondConjAnimation 16s steps(1) infinite;
}

.secondSecond.disjAnimation {
  animation: secondSecondDisjAnimation 16s steps(1) infinite;
}

.secondThird {
  animation: secondThirdConjAnimation 16s steps(1) infinite;
}

.secondThird.disjAnimation {
  animation: secondThirdDisjAnimation 16s steps(1) infinite;
}


/* Third column */
.thirdFirst {
  opacity: 0;
  animation: thirdFirstAnimation 16s steps(1) infinite;
}

.thirdSecond {
  opacity: 0;
  animation: thirdSecondAnimation 16s steps(1) infinite;
}


.thirdThird {
  opacity: 0;
  animation: thirdThirdAnimation 16s steps(1) infinite;
}


/* First set */
@keyframes firstFirstConjAnimation {
  0%, 50%, 100% {
    --color: white;
    --name: '';
  }
  3.125% {
    --color: #B22222;
    --name: 'R';
  }
  56.25% {
    --color: #B22222;
    --name: 'R';
  }
}

@keyframes secondFirstConjAnimation {
  0%, 50%, 100% {
    --color: white;
    --name: '';
  }
  6.25% {
    --color: #EEB14F;
    --name: 'Y';
  }
  53.125% {
    --color: #EEB14F;
    --name: 'Y';
  }
}

@keyframes firstFirstDisjAnimation {
  0%, 50%, 100% {
    --color: white;
    --name: '';
  }
  3.125% {
    --color: #3A4FB4;
    --name: 'B';
  }
  56.25% {
    --color: #3A4FB4;
    --name: 'B';
  }
}

@keyframes secondFirstDisjAnimation {

  0%, 50%, 100% {
    --color: white;
    --name: '';
  }
  6.25% {
    --color: #3C902B;
    --name: 'G';
  }
  53.125% {
    --color: #3C902B;
    --name: 'G';
  }
}

@keyframes thirdFirstAnimation {
  0%, 50%, 100% {
    opacity: 0;
  }
  9.375%, 59.375% {
    opacity: 1;
  }
}

/* Second set */
@keyframes firstSecondConjAnimation {
  0%, 50%, 100% {
    --color: white;
    --name: '';
    background: none;
    background-color: var(--color);
  }
  15.625% {
    --color: #B22222;
    --name: 'R';
    background: none;
    background-color: var(--color);
  }
  68.75% {
    --color: #3A4FB4;
    --name: 'B';
    background: linear-gradient(
        to bottom,
        #fff 0 20%,
        var(--color) 20% 80%,
        #fff 80% 100%
    );
  }
}

@keyframes secondSecondConjAnimation {
  0%, 50%, 100% {
    --color: white;
    --name: '';
    background: none;
    background-color: var(--color);
  }
  18.75% {
    --color: #3C902B;
    --name: 'G';
    background: linear-gradient(
        to bottom,
        #fff 0 20%,
        var(--color) 20% 80%,
        #fff 80% 100%
    );
  }
  65.625% {
    --color: #EEB14F;
    --name: 'Y';
    background: none;
    background-color: var(--color);
  }
}

@keyframes firstSecondDisjAnimation {
  0%, 50%, 100% {
    --color: white;
    --name: '';
    background: none;
    background-color: var(--color);
  }
  15.625% {
    --color: #3A4FB4;
    --name: 'B';
    background: linear-gradient(
        to bottom,
        #fff 0 20%,
        var(--color) 20% 80%,
        #fff 80% 100%
    );
  }
  68.75% {
    --color: #B22222;
    --name: 'R';
    background: none;
    background-color: var(--color);
  }
}

@keyframes secondSecondDisjAnimation {
  0%, 50%, 100% {
    --color: white;
    --name: '';
    background: none;
    background-color: var(--color);
  }
  18.75% {
    --color: #EEB14F;
    --name: 'Y';
    background: none;
    background-color: var(--color);
  }
  65.625% {
    --color: #3C902B;
    --name: 'G';
    background: linear-gradient(
        to bottom,
        #fff 0 20%,
        var(--color) 20% 80%,
        #fff 80% 100%
    );
  }
}

@keyframes thirdSecondAnimation {
  0%, 50%, 100% {
    opacity: 0;
  }
  21.875%, 71.875% {
    opacity: 1;
  }
}

/* Third set */
@keyframes firstThirdConjAnimation {
  0%, 50%, 100% {
    --color: white;
    --name: '';
  }
  28.125% {
    --color: #3A4FB4;
    --name: 'B';
  }
}

@keyframes secondThirdConjAnimation {
  0%, 50%, 100% {
    --color: white;
    --name: '';
  }
  78.125% {
    --color: #3C902B;
    --name: 'G';
  }
}

@keyframes firstThirdDisjAnimation {
  0%, 50%, 100% {
    --color: white;
    --name: '';
  }
  28.125% {
    --color: #B22222;
    --name: 'R';
  }
}

@keyframes secondThirdDisjAnimation {
  0%, 50%, 100% {
    --color: white;
    --name: '';
  }
  78.125% {
    --color: #EEB14F;
    --name: 'Y';
  }
}

@keyframes thirdThirdAnimation {
  0%, 50%, 100% {
    opacity: 0;
  }
  31.25%, 81.25% {
    opacity: 1;
  }
}

.compEarly {
  opacity: 0;
  animation: compEarlyAnimation 3s steps(1) infinite;
}

.compLate {
  opacity: 0;
  animation: compLateAnimation 3s steps(1) infinite;
}

@keyframes compEarlyAnimation {
  0%, 100% {
    opacity: 0;
  }
  16.67% {
    opacity: 1;
  }
}

@keyframes compLateAnimation {
  0%, 100% {
    opacity: 0;
  }
  33.34% {
    opacity: 1;
  }
}
</style>
