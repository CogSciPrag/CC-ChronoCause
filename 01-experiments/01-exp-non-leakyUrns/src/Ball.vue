<!--
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
  color: String
});
</script>

<template>
  <div :class="color" class="ball"></div>
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
}

.orange {
  background-color: orange;
  border: 2px solid darkgrey;
}

.orange::before {
  content: 'O';
}

.black {
  background-color: black;
  border: 2px solid darkgrey;
}

.black::before {
  content: 'B';
}

.green {
  background-color: green;
  border: 2px solid darkgreen;
}

.green::before {
  content: 'G';
}

.red {
  background-color: red;
  border: 2px solid darkred;
}

.red::before {
  content: 'R';
}

.yellow {
  background-color: gold;
  border: 2px solid darkgoldenrod;
}

.yellow::before {
  content: 'Y';
}

.blue {
  background-color: blue;
  border: 2px solid darkblue;
}

.blue::before {
  content: 'B';
}
</style>

