<template>
  <Experiment title="ChronoCause">
    <Screen :title="'Game Test Screen 1/3'">
      simultaneous
      <NonLeakyUrns
        :timingLeft="base"
        :timingRight="base"
        :outputLeft="orange"
        :outputRight="black"
      />
      <button @click="$magpie.nextScreen()">Next test screen</button>
    </Screen>

    <Screen :title="'Game Test Screen 2/3'">
      short delay
      <NonLeakyUrns
        :timingLeft="base"
        :timingRight="short"
        :outputLeft="orange"
        :outputRight="orange"
      />
      <button @click="$magpie.nextScreen()">Next test screen</button>
    </Screen>

    <Screen :title="'Game Test Screen 3/3'">
      long delay
      <NonLeakyUrns
        :timingLeft="base"
        :timingRight="long"
        :outputLeft="black"
        :outputRight="black"
      />
      The experiment proper starts on the next screen.
      <button @click="$magpie.nextScreen()">Next screen</button>
    </Screen>

    <InstructionScreen :title="'Welcome'">
      Hi! Thanks for taking part! In this experiment, you will be introduced to
      a simple game. Then, you will see a few rounds of the game being played
      and you will be asked to make some judgements.
    </InstructionScreen>

    <InstructionScreen :titles="'Game Rules'">
      <p>
        In the game, the player sees two urns, both of which contain
        <b style="color: orange">orange</b> and <b>black</b> balls. In each urn
        there are 10 balls: 5 of the balls are
        <b style="color: orange">orange</b>, and 5 of the balls are
        <b>black</b>.
      </p>
      <p>
        When the player presses the button, a ball is released from each urn.
        The player wins just in case
        {{
          structure == "conjunctive" ? "BOTH balls are" : "AT LEAST ONE ball is"
        }}
        <b style="color: orange">orange</b>.
        <br />
        Here are the possible outcomes:
      </p>
      <div class="outcomes">
        <div class="col">
          <Ball color="orange" />
          <Ball color="black" />
          <Ball color="orange" />
          <Ball color="black" />
        </div>
        <div class="col">
          <Ball color="orange" />
          <Ball color="orange" />
          <Ball color="black" />
          <Ball color="black" />
        </div>
        <div class="col">
          <p>WIN</p>
          <p>{{ structure == "conjunctive" ? "LOSE" : "WIN" }}</p>
          <p>{{ structure == "conjunctive" ? "LOSE" : "WIN" }}</p>
          <p>LOSE</p>
        </div>
      </div>
    </InstructionScreen>

    <InstructionScreen :title="'Instructions'">
      <p>
        In this experiment, Alice will be playing the game. You will see a few
        rounds, and after each round, you will be asked to judge several
        statements.
      </p>
      <p>Let’s practice this first!</p>
    </InstructionScreen>
    <!--    <template v-for="(trial, i) of training_trials">-->
    <Screen>
      <Slide>
        Press the button to see Alice's game:
        <NonLeakyUrns
          :timingLeft="base"
          :timingRight="long"
          :outputLeft="orange"
          :outputRight="orange"
        />
      </Slide>
      <Slide>
        Alice [won/lost] the game. These marbles were released:
        <p style="display: flex; gap: 40px; justify-content: center">
          <Ball color="orange" />
          <Ball color="orange" />
        </p>
        <br />
        <p>
          Do you agree with the following statement?
        </p>

        <p>
          <b>Orange ball falling out of the left urn caused Alice to win.</b>
        </p>
        <RatingInput
          left="strongly disagree"
          :response.sync="$magpie.measurements.X"
          right="strongly agree"
        />
        <button @click="$magpie.saveAndNextScreen()">Submit</button>
      </Slide>
    </Screen>
    <!--    </template>-->

    <InstructionScreen :title="'Instructions'">
      <p>Great! You are now ready to start the main experiment.</p>
    </InstructionScreen>

    <!--    <template v-for="(trial, i) of main_trials">-->
    <!--    </template>-->

    <SubmitResultsScreen />
  </Experiment>
</template>

<script>
import _ from "lodash";
import NonLeakyUrns from "./NonLeakyUrns.vue";
import Ball from "./Ball.vue";

import training_trials from "../trials/training_trials.csv";
import main_trials from "../trials/main_trials.csv";

const structure = _.shuffle(["conjunctive", "disjunctive"])[0];
const outcomes_img = "images/outcomes-" + structure + ".png";

export default {
  name: "App",
  components: { NonLeakyUrns, Ball },
  data() {
    return {
      structure: structure,
      outcomes_img: outcomes_img,
      base: 1000,
      short: 2000,
      long: 3000
    };
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
</style>
