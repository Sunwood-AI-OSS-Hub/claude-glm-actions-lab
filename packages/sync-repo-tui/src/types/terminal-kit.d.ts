/**
 * terminal-kit型定義（簡易版）
 */

declare module 'terminal-kit' {
  interface Terminal {
    (str: string): void;
    [key: string]: any;
  }

  const terminal: Terminal;

  export { terminal };
}
