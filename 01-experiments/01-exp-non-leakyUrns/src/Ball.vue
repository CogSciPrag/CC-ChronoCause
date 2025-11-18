<!--
TODO: update
A ball of a specified color, with the initial letter of the color’s name on it.

Parameters:
':color' - color of the ball. Options: orange, black, green, red, yellow, blue

Example usage:

<Ball color="orange"/>

-->

<script setup>
import Vue from "vue";
import Component from "vue-class-component";

defineProps({
  color: String,
  type: String
});
</script>

<template>
  <div :class="[color,type]" class="ball"></div>
</template>

<style scoped>
.ball {
  height: 40px;
  width: 40px;
  border-radius: 50%;
  display: inline-flex;
  justify-content: center;
  align-items: center;
  color: white;
  font-weight: bold;
  border: 1px solid darkgrey;
}


.red {
  --color: #B22222;
  --name: 'R';
}

.yellow {
  --color: #EEB14F;
  --name: 'Y';
}

.green {
  --color: #3C902B;
  --name: 'G';
}

.blue {
  --color: #3A4FB4;
  --name: 'B';
}

.ball::before{
  content: var(--name);
}

.solid{
  background-color: var(--color);
}

.stripe{
  background: linear-gradient(
      to bottom,
      #fff 0 20%,
      var(--color) 20% 80%,
      #fff 80% 100%
    );
}
</style>

