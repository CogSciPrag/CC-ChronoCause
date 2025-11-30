<!--
A ball of a specified color, bearing the initial letter of its name, is similar to a billiard ball and comes in solid and striped varieties.

Parameters:
  'color' - color of the ball; Options: black, green, red, yellow, blue
  'type' - type of the ball; Options: solid, stripe

Example usage:
  <Ball color="black" type="solid"/>
-->

<script setup>
import Vue from "vue";
import Component from "vue-class-component";

defineProps({
  color: {
    type: String,
    default: 'black'
  },
  type: {
    type: String,
    default: 'solid'
  }
})

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

.black {
  --color: #000000;
  --name: 'B';
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

.ball::before {
  content: var(--name);
}

.solid {
  background-color: var(--color);
}

.stripe {
  background: linear-gradient(
      to bottom,
      #fff 0 20%,
      var(--color) 20% 80%,
      #fff 80% 100%
  );
}
</style>

