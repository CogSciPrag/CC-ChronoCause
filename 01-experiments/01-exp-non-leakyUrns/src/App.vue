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
        In the game, the player sees two urns, both of which contain
        <b style="color: orange">orange</b> and <b>black</b> balls. In each urn
        there are 10 balls: 5 of the balls are
        <b style="color: orange">orange</b>, and 5 of the balls are
        <b>black</b>.
      </p>

      <div class="urns">
        <Urn
            firstColor="red"
            secondColor="blue"
            :firstCount="5"
            :secondCount="5"
            firstType="solid"
            secondType="stripe"
        />
        <Urn
            firstColor="yellow"
            secondColor="green"
            :firstCount="5"
            :secondCount="5"
            firstType="solid"
            secondType="stripe"
        />
      </div>
      <p>
        When the player presses the button, a ball is released from each urn.
        The player wins just in case
        {{
          structure == "conjunctive" ? "BOTH balls are" : "AT LEAST ONE ball is"
        }}
        <b style="color: orange">orange</b>.
        <br/>
        Here are the possible outcomes:
      </p>
      <div class="outcomes">
        <div class="col">
          <Ball color="red" type="solid"/>
          <Ball color="blue" type="stripe"/>
          <Ball color="red" type="solid"/>
          <Ball color="blue" type="stripe"/>
        </div>
        <div class="col">
          <Ball color="yellow" type="solid"/>
          <Ball color="yellow" type="solid"/>
          <Ball color="green" type="stripe"/>
          <Ball color="green" type="stripe"/>
        </div>
        <div class="col">
          <p>WIN</p>
          <p>{{ structure == "conjunctive" ? "LOSE" : "WIN" }}</p>
          <p>{{ structure == "conjunctive" ? "LOSE" : "WIN" }}</p>
          <p>LOSE</p>
        </div>
      </div>
    </InstructionScreen>

    <InstructionScreen>
      Comprehension question like in InferCausAttr
    </InstructionScreen>

    <InstructionScreen :title="'Instructions'">
      <p>
        In this experiment, Alice will be playing the game. You will see a few
        rounds, and after each round, you will be asked to judge several
        statements.
        df thethi
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
            firstColorLeft="red"
            firstTypeLeft="solid"
            secondColorLeft="blue"
            secondTypeLeft="stripe"
            firstColorRight="yellow"
            firstTypeRight="solid"
            secondColorRight="green"
            secondTypeRight="stripe"
            :outputLeftFirst="false"
            :outputRightFirst="true"
        />
      </Slide>

      <Slide>

        Alice [won/lost] the game.
        <NonLeakyUrns
            :timingLeft="base"
            :timingRight="long"
            firstColorLeft="red"
            firstTypeLeft="solid"
            secondColorLeft="blue"
            secondTypeLeft="stripe"
            firstColorRight="yellow"
            firstTypeRight="solid"
            secondColorRight="green"
            secondTypeRight="stripe"
            :outputLeftFirst="false"
            :outputRightFirst="true"
            :enabled="false"
        />


        <br/>
        <p>
          Do you agree with the following statement?
        </p>

        <p>
          <b>The [color] ball caused Alice to win.</b>
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

    <SubmitResultsScreen/>
  </Experiment>
</template>

<script>
import _ from "lodash";
import NonLeakyUrns from "./NonLeakyUrns.vue";
import Ball from "./Ball.vue";

import training_trials from "../trials/training_trials.csv";
import main_trials from "../trials/main_trials.csv";
import Urn from "./Urn.vue";

const structure = _.shuffle(["conjunctive", "disjunctive"])[0];

export default {
  name: "App",
  components: {Urn, NonLeakyUrns, Ball},
  data() {
    return {
      structure: structure,
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

.urns {
  width: 100%;
  justify-content: center;
  display: grid;
  grid-template-columns: auto auto;
  gap: 50px;
}


</style>
