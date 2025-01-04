// https://karabiner.ts.evanliu.dev/

import * as k from 'https://deno.land/x/karabinerts@1.30.3/deno.ts';

// mac 内蔵キーボードかどうか
const ifBultin = k.ifDevice({ is_built_in_keyboard: true });

// 単推しでかな英数を切り替える設定
const tapCmdAndOptToKanaEisuu = k.rule('⌘/⌥ to かな英数').manipulators([
  k.withMapper({
    left_command: 'japanese_eisuu',
    right_command: 'japanese_kana',
    left_option: 'japanese_eisuu',
    right_option: 'japanese_kana',
  } as const)((cmd, lang) =>
    k
      .map({ key_code: cmd, modifiers: { optional: ['any'] } })
      .to({ key_code: cmd, lazy: true })
      .toIfAlone({ key_code: lang })
      .description(`Tap ${cmd} alone to switch to ${lang}`)
      .parameters({ 'basic.to_if_held_down_threshold_milliseconds': 100 }),
  ),
]);

k.writeToProfile('Default', [
  k.rule('CapsLock to Ctrl').manipulators([k.map('caps_lock').to('left_control')]),

  tapCmdAndOptToKanaEisuu,

  // mac 内蔵キーボード向け設定 (特に JIS 配列を US として扱う場合)
  k
    .rule('かな英数 to ⌥', ifBultin)
    .manipulators([k.map('japanese_eisuu').to('left_option'), k.map('japanese_kana').to('right_option')]),
  k.rule('>⌥ + ?', ifBultin).manipulators([
    k.withMapper({
      escape: 'grave_accent_and_tilde',
      i: 'up_arrow',
      j: 'left_arrow',
      k: 'down_arrow',
      l: 'right_arrow',
    } as const)((key, mapped) => k.map(key, ['right_option'], ['shift']).to(mapped)),
  ]),
]);
