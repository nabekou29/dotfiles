// https://karabiner.ts.evanliu.dev/

import * as k from 'https://deno.land/x/karabinerts@1.30.3/deno.ts';

// mac 内蔵キーボードかどうか
const ifBuiltin = k.ifDevice({ is_built_in_keyboard: true });

// 単押しでかな英数を切り替える設定
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
      .parameters({ 'basic.to_if_held_down_threshold_milliseconds': 70 }),
  ),
]);

k.writeToProfile('Default', [
  k
    .rule('CapsLock to Ctrl')
    .manipulators([k.map('caps_lock').to('left_control')]),

  k
    .rule('^h to BS')
    .manipulators([k.map('h', ['control']).to('delete_or_backspace')]),
  k
    .rule('⌘ + ^h to ⌘ + BS')
    .manipulators([
      k
        .map('h', ['control', 'left_command'])
        .to('delete_or_backspace', ['left_command']),
    ]),
  k
    .rule('⌥ + ^h to ⌥ + BS')
    .manipulators([
      k
        .map('h', ['control', 'left_option'])
        .to('delete_or_backspace', ['left_option']),
    ]),
  k
    .rule('^← to BS')
    .manipulators([k.map('left_arrow', ['control']).to('delete_or_backspace')]),

  k
    .rule('^[ to ESC')
    .manipulators([k.map('open_bracket', ['control']).to('escape')]),

  tapCmdAndOptToKanaEisuu,

  // mac 内蔵キーボード向け設定 (特に JIS 配列を US として扱う場合)
  k
    .rule('かな英数 to ⌥', ifBuiltin)
    .manipulators([
      k.map('japanese_eisuu').to('left_option'),
      k.map('japanese_kana').to('right_option'),
    ]),
  k.rule('>⌥ + ?', ifBuiltin).manipulators([
    k.withMapper({
      escape: 'grave_accent_and_tilde',
      i: 'up_arrow',
      j: 'left_arrow',
      k: 'down_arrow',
      l: 'right_arrow',
    } as const)((key, mapped) =>
      k.map(key, ['right_option'], ['shift']).to(mapped),
    ),
  ]),
]);
