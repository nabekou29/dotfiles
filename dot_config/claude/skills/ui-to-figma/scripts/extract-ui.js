/**
 * UI 情報抽出スクリプト
 *
 * chrome-devtools の evaluate_script で実行:
 *
 * evaluate_script({
 *   function: `() => {
 *     const container = document.querySelector("セレクタ");
 *     // ... このファイルの内容をコピー
 *   }`
 * })
 *
 * または引数付きで実行:
 *
 * evaluate_script({
 *   function: `(el) => {
 *     // ... このファイルの getElementInfo 関数を使用
 *   }`,
 *   args: [{ uid: "選択されたuid" }]
 * })
 */

// セレクタ指定版
const extractUIBySelector = (selector) => {
  const container = document.querySelector(selector);
  if (!container) return { error: "Element not found" };

  return getElementInfo(container);
};

// 要素直接指定版
const extractUIFromElement = (el) => {
  if (!el) return { error: "Element not found" };
  return getElementInfo(el);
};

// メイン関数
function getElementInfo(el, depth = 0) {
  if (depth > 6) return null;
  if (!el || el.nodeType !== 1) return null;

  const info = {
    tagName: el.tagName,
    className: el.className,
    textContent:
      el.childNodes.length === 1 && el.childNodes[0].nodeType === 3
        ? el.textContent.trim()
        : null,
    styles: getComputedStyles(el),
    children: [],
  };

  for (const child of el.children) {
    const childInfo = getElementInfo(child, depth + 1);
    if (childInfo) info.children.push(childInfo);
  }

  return info;
}

function getComputedStyles(el) {
  const styles = window.getComputedStyle(el);
  return {
    // サイズ
    width: styles.width,
    height: styles.height,

    // パディング
    padding: styles.padding,
    paddingTop: styles.paddingTop,
    paddingRight: styles.paddingRight,
    paddingBottom: styles.paddingBottom,
    paddingLeft: styles.paddingLeft,

    // マージン
    margin: styles.margin,
    marginTop: styles.marginTop,
    marginRight: styles.marginRight,
    marginBottom: styles.marginBottom,
    marginLeft: styles.marginLeft,

    // 背景・ボーダー
    backgroundColor: styles.backgroundColor,
    borderRadius: styles.borderRadius,
    border: styles.border,

    // レイアウト
    display: styles.display,
    flexDirection: styles.flexDirection,
    alignItems: styles.alignItems,
    justifyContent: styles.justifyContent,
    gap: styles.gap,

    // テキスト
    fontSize: styles.fontSize,
    fontWeight: styles.fontWeight,
    color: styles.color,
    lineHeight: styles.lineHeight,
  };
}

// 使用例（セレクタ指定）:
// extractUIBySelector(".my-component")

// 使用例（要素直接）:
// extractUIFromElement(document.querySelector(".my-component"))
