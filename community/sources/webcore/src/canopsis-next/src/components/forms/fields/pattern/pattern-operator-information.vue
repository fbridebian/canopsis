<template lang="pug">
  v-layout.pattern-operator-information(row, align-center)
    c-pattern-operator-chip.mr-4
      slot
    div.pattern-operator-information__bracket
</template>

<style lang="scss" scoped>
.pattern-operator-information {
  height: 100%;
  position: relative;

  &__bracket {
    position: absolute;
    width: 15px;
    border-radius: 100% 0 0 100% / 50% 50% 50% 50%;
    right: 0;
    top: 0;
    bottom: 0;
    border: 4px #a6a6a6 solid;
    border-right: none;
  }
}
</style>
